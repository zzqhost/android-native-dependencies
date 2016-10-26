/*
 * Copyright (C) 2014 Nabil HACHICHA.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.nabilhachicha.nativedependencies.extension

import org.gradle.api.tasks.StopExecutionException

class NativeDependenciesExtension {
    final String CONFIGURATION_SEPARATOR = ":"
    final def classifiers = ['armeabi', 'armeabi-v7a', 'arm64-v8a', 'x86', 'x86_64', 'mips', 'mips64']
    def dependencies = []

    def boolean isClearJniLibsDir = true
    def jniLibsDir = ""

    /**
     * set by a closure to let the user choose if he/she wants to disable
     * prefixing the artifact with 'lib'
     */
    boolean addLibPrefixToArtifact = true
    private int timeValue = NativeDep.CACHE_PERIOD_TIME_VALUE
    private String timeUnits = NativeDep.CACHE_PERIOD_TIME_UNITS

    def cacheChangingModulesFor (int value, String units) {
        timeValue = value
        timeUnits = units
    }

    /**
     * add {@code dep} to the list of dependencies to retrieve
     *
     * @param dep
     * handle String notation ex: artifact com.snappydb:snappydb-native:0.2.+
     */
    def artifact (String dep, Closure... closures) {

        def closure = closures?.size() > 0 ? closures[0] : null

        def dependency = dep.tokenize(CONFIGURATION_SEPARATOR)

        if (dependency.size() < 3 || dependency.size() > 4) {
            throw new StopExecutionException('please specify group:name:version')

        } else if (dependency.size() == 3) {//add classifier
            classifiers.each {
                dependencies << createNativeDep (dep + CONFIGURATION_SEPARATOR + it, closure)
            }

        } else {
            dependencies << createNativeDep (dep, closure)
        }
    }

    /**
     * add {@code dep} to the list of dependencies to retrieve
     *
     * @param dep
     * artifact group: 'com.snappydb', name: 'snappydb-native', version: '0.2.0'
     *
     * Note: if the user doesn't specify the optional 'classifier', this method will add
     * all the supported architectures to this dependencies ('armeabi', 'armeabi-v7a', 'x86' and 'mips')
     */
    def artifact (Map m, Closure... closures) {

        def closure = closures?.size() > 0 ? closures[0] : null

        String temp = m['group'] + CONFIGURATION_SEPARATOR + m['name'] + CONFIGURATION_SEPARATOR + m['version']

        if (!m.containsKey('classifier')) {
            classifiers.each {
                dependencies << createNativeDep (temp + CONFIGURATION_SEPARATOR + it, closure)
            }

        } else {
            dependencies << createNativeDep (temp + CONFIGURATION_SEPARATOR + m['classifier'], closure)
        }
    }

    def createNativeDep (String dep, Closure closure) {

        def nativeDep = new NativeDep (dependency: dep, shouldPrefixWithLib: addLibPrefixToArtifact, cachePeriodTimeValue: timeValue, cachePeriodTimeUnits: timeUnits)
        nativeDep.setProperties (closure)

        return nativeDep
    }
}
