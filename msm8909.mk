DEVICE_PACKAGE_OVERLAYS := device/qcom/msm8909/overlay

TARGET_USES_QCOM_BSP := true
ifneq ($(TARGET_USES_AOSP),true)
TARGET_USES_QCA_NFC := true
endif
ifeq ($(TARGET_USES_QCOM_BSP), true)
# Add QC Video Enhancements flag
TARGET_ENABLE_QC_AV_ENHANCEMENTS := true
endif #TARGET_USES_QCOM_BSP




# media_profiles and media_codecs xmls for msm8909
ifeq ($(TARGET_ENABLE_QC_AV_ENHANCEMENTS), true)
PRODUCT_COPY_FILES += device/qcom/msm8909/media/media_profiles_8909.xml:system/etc/media_profiles.xml \
                      device/qcom/msm8909/media/media_codecs_8909.xml:system/etc/media_codecs.xml
endif

$(call inherit-product, device/qcom/common/common.mk)

PRODUCT_NAME := msm8909
PRODUCT_DEVICE := msm8909



#Android EGL implementation
PRODUCT_PACKAGES += libGLES_android

# Audio configuration file
PRODUCT_COPY_FILES += \
    device/qcom/msm8909/audio_policy.conf:system/etc/audio_policy.conf \
    device/qcom/msm8909/audio_effects.conf:system/vendor/etc/audio_effects.conf \
    device/qcom/msm8909/mixer_paths_qrd_skuh.xml:system/etc/mixer_paths_qrd_skuh.xml \
    device/qcom/msm8909/mixer_paths_qrd_skui.xml:system/etc/mixer_paths_qrd_skui.xml \
    device/qcom/msm8909/mixer_paths.xml:system/etc/mixer_paths.xml \
    device/qcom/msm8909/sound_trigger_mixer_paths.xml:system/etc/sound_trigger_mixer_paths.xml \
    device/qcom/msm8909/sound_trigger_platform_info.xml:system/etc/sound_trigger_platform_info.xml

# NFC packages
ifeq ($(TARGET_USES_QCA_NFC),true)
NFC_D := true

ifeq ($(NFC_D), true)
    PRODUCT_PACKAGES += \
        libqnfc-nci \
        libqnfc_nci_jni \
        nfc_nci.msm8909 \
        QNfc \
	Tag \
	GsmaNfcService \
        com.gsma.services.nfc\
        com.gsma.services.utils \
        com.gsma.services.nfc.xml \
        com.android.nfc_extras \
        com.android.qcom.nfc_extras \
	com.android.qcom.nfc_extras.xml \
	com.android.nfc.helper \
	SmartcardService \
	org.simalliance.openmobileapi \
	org.simalliance.openmobileapi.xml \
        libassd
else
    PRODUCT_PACKAGES += \
    libnfc-nci \
    libnfc_nci_jni \
    nfc_nci.msm8909 \
    NfcNci \
    Tag \
    com.android.nfc_extras
endif

# file that declares the MIFARE NFC constant
# Commands to migrate prefs from com.android.nfc3 to com.android.nfc
# NFC access control + feature files + configuration
PRODUCT_COPY_FILES += \
        packages/apps/Nfc/migrate_nfc.txt:system/etc/updatecmds/migrate_nfc.txt \
        frameworks/native/data/etc/com.nxp.mifare.xml:system/etc/permissions/com.nxp.mifare.xml \
        frameworks/native/data/etc/com.android.nfc_extras.xml:system/etc/permissions/com.android.nfc_extras.xml \
        frameworks/native/data/etc/android.hardware.nfc.xml:system/etc/permissions/android.hardware.nfc.xml \
        frameworks/native/data/etc/android.hardware.nfc.hce.xml:system/etc/permissions/android.hardware.nfc.hce.xml
# Enable NFC Forum testing by temporarily changing the PRODUCT_BOOT_JARS
# line has to be in sync with build/target/product/core_base.mk

PRODUCT_BOOT_JARS := core:conscrypt:okhttp:core-junit:bouncycastle:ext:com.android.nfc.helper:framework:framework2:telephony-common:voip-common:mms-common:android.policy:services:apache-xml:webviewchromium:telephony-msim

ifeq ($(NFC_D), true)
PRODUCT_BOOT_JARS += org.simalliance.openmobileapi:com.android.qcom.nfc_extras:com.gsma.services.nfc
# SmartcardService, SIM1,SIM2,eSE1 not including eSE2,SD1 as default
ADDITIONAL_BUILD_PROPERTIES += persist.nfc.smartcard.config=SIM1,SIM2,eSE1
endif

endif # TARGET_USES_QCA_NFC

PRODUCT_BOOT_JARS += qcmediaplayer \
                     WfdCommon \
                     oem-services \
                     qcom.fmradio \
                     org.codeaurora.Performance \
                     vcard
# Listen configuration file
PRODUCT_COPY_FILES += \
    device/qcom/msm8909/listen_platform_info.xml:system/etc/listen_platform_info.xml

# Feature definition files for msm8909
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml

#fstab.qcom
PRODUCT_PACKAGES += fstab.qcom

PRODUCT_PACKAGES += \
    libqcomvisualizer \
    libqcompostprocbundle

#OEM Services library
PRODUCT_PACKAGES += oem-services
PRODUCT_PACKAGES += libsubsystem_control
PRODUCT_PACKAGES += libSubSystemShutdown

PRODUCT_PACKAGES += wcnss_service

#wlan driver
PRODUCT_COPY_FILES += \
    device/qcom/msm8909/WCNSS_qcom_cfg.ini:system/etc/wifi/WCNSS_qcom_cfg.ini \
    device/qcom/msm8909/WCNSS_wlan_dictionary.dat:persist/WCNSS_wlan_dictionary.dat \
    device/qcom/msm8909/WCNSS_qcom_wlan_nv.bin:persist/WCNSS_qcom_wlan_nv.bin

PRODUCT_PACKAGES += \
    wpa_supplicant_overlay.conf \
    p2p_supplicant_overlay.conf
#ANT+ stack
PRODUCT_PACKAGES += \
AntHalService \
libantradio \
antradio_app

# Add the overlay path
PRODUCT_PACKAGE_OVERLAYS := $(QCPATH)/qrdplus/Extension/res-overlay \
        $(PRODUCT_PACKAGE_OVERLAYS)

