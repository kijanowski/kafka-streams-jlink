#!/bin/sh

mkdir modlibs
cp build/libs/slf4j* modlibs

mkdir jigsawed

jdeps --generate-module-info . build/libs/lz4-java-1.6.0.jar
cd org.lz4.java
mkdir compiled
cp ../build/libs/lz4-java-1.6.0.jar compiled
cd compiled
jar xf lz4-java-1.6.0.jar
rm lz4-java-1.6.0.jar
cd ..
javac -d compiled module-info.java
cd compiled
jar cmf META-INF/MANIFEST.MF lz4-java-1.6.0-mod.jar *
cd ../..
cp org.lz4.java/compiled/lz4-java-1.6.0-mod.jar jigsawed
rm -rf org.lz4.java

jdeps --generate-module-info . build/libs/jackson-core-2.9.9.jar
cd com.fasterxml.jackson.core
mkdir compiled
cp ../build/libs/jackson-core-2.9.9.jar compiled
cd compiled
jar xf jackson-core-2.9.9.jar
rm jackson-core-2.9.9.jar
cd ..
javac -d compiled module-info.java
cd compiled/
jar cmf META-INF/MANIFEST.MF jackson-core-2.9.9-mod.jar *
cd ../..
cp com.fasterxml.jackson.core/compiled/jackson-core-2.9.9-mod.jar jigsawed
rm -rf com.fasterxml.jackson.core

jdeps --generate-module-info . build/libs/jackson-annotations-2.9.0.jar
cd jackson.annotations
mkdir compiled
cp ../build/libs/jackson-annotations-2.9.0.jar compiled
cd compiled
jar xf jackson-annotations-2.9.0.jar
rm jackson-annotations-2.9.0.jar
cd ..
javac -d compiled module-info.java
cd compiled
jar cmf META-INF/MANIFEST.MF jackson-annotations-2.9.0-mod.jar *
cd ../..
cp jackson.annotations/compiled/jackson-annotations-2.9.0-mod.jar jigsawed
rm -rf jackson.annotations

jdeps --multi-release 12 --module-path jigsawed --generate-module-info . build/libs/jackson-databind-2.9.9.jar
cd com.fasterxml.jackson.databind
mkdir compiled
cp ../build/libs/jackson-databind-2.9.9.jar compiled
cd compiled
jar xf jackson-databind-2.9.9.jar
rm jackson-databind-2.9.9.jar
cd ..
javac -d compiled --module-path ../jigsawed module-info.java
cd compiled
jar cmf META-INF/MANIFEST.MF jackson-databind-2.9.9-mod.jar *
cd ../..
cp com.fasterxml.jackson.databind/compiled/jackson-databind-2.9.9-mod.jar jigsawed
rm -rf com.fasterxml.jackson.databind

jdeps --multi-release 12 --module-path jigsawed:modlibs --generate-module-info . build/libs/kafka-clients-2.3.0.jar
cd kafka.clients
mkdir compiled
cp ../build/libs/kafka-clients-2.3.0.jar compiled
cd compiled
jar xf kafka-clients-2.3.0.jar
rm kafka-clients-2.3.0.jar
cd ..
javac -d compiled --module-path ../jigsawed:../modlibs module-info.java
cd compiled
jar cmf META-INF/MANIFEST.MF kafka-clients-2.3.0-mod.jar *
cd ../..
cp kafka.clients/compiled/kafka-clients-2.3.0-mod.jar jigsawed
rm -rf kafka.clients

jdeps --multi-release 12 --module-path jigsawed:modlibs --generate-module-info . build/libs/rocksdbjni-5.18.3.jar
cd rocksdbjni
mkdir compiled
cp ../build/libs/rocksdbjni-5.18.3.jar compiled
cd compiled
jar xf rocksdbjni-5.18.3.jar
rm rocksdbjni-5.18.3.jar
cd ..
javac -d compiled --module-path ../jigsawed module-info.java
cd compiled
jar cmf META-INF/MANIFEST.MF rocksdbjni-5.18.3-mod.jar *
cd ../..
cp rocksdbjni/compiled/rocksdbjni-5.18.3-mod.jar jigsawed
rm -rf rocksdbjni

jdeps --multi-release 12 --module-path jigsawed:modlibs --generate-module-info . build/libs/kafka-streams-2.3.0.jar
cd kafka.streams
mkdir compiled
cp ../build/libs/kafka-streams-2.3.0.jar compiled
cd compiled
jar xf kafka-streams-2.3.0.jar
rm kafka-streams-2.3.0.jar
cd ..
grep -v unnamed module-info.java > x
mv x module-info.java
javac -d compiled --module-path ../jigsawed:../modlibs module-info.java
cd compiled
jar cmf META-INF/MANIFEST.MF kafka-streams-2.3.0-mod.jar *
cd ../..
cp kafka.streams/compiled/kafka-streams-2.3.0-mod.jar jigsawed
rm -rf kafka.streams
