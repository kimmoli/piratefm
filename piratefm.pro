#
# Project harbour-piratefm
#

TARGET = harbour-piratefm

CONFIG += sailfishapp

DEFINES += "APPVERSION=\\\"$${SPECVERSION}\\\""

message($${DEFINES})

SOURCES += src/main.cpp
	
OTHER_FILES += qml/piratefm.qml \
    qml/cover/CoverPage.qml \
    qml/pages/Tuner.qml \
    qml/pages/AboutPage.qml \
    rpm/harbour-piratefm.spec \
	harbour-piratefm.png \
    harbour-piratefm.desktop

