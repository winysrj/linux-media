Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:32942 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757240Ab0FIJvu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jun 2010 05:51:50 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id o599pkUk016017
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 9 Jun 2010 04:51:48 -0500
Received: from dbde71.ent.ti.com (localhost [127.0.0.1])
	by dbdp20.itg.ti.com (8.13.8/8.13.8) with ESMTP id o599pjqF028636
	for <linux-media@vger.kernel.org>; Wed, 9 Jun 2010 15:21:46 +0530 (IST)
From: "Nagarajan, Rajkumar" <x0133774@ti.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 9 Jun 2010 15:21:45 +0530
Subject: [PATCH] OMAP: V4L2: Enable V4L2 on ZOOM2/3 & 3630SDP
Message-ID: <FF55437E1F14DA4BAEB721A458B6701706BD8CCD05@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Defconfig changes to enable V4L2 on zoom2, zoom3 and 3630sdp boards.

Signed-off-by: Mukund Mittal <mmittal@ti.com>
Signed-off-by: Sudeep Basavaraj <sudeep.basavaraj@ti.com>
Signed-off-by: Kishore Y <kishore.y@ti.com>
Signed-off-by: Rajkumar N <rajkumar.nagarajan@ti.com>
---
 arch/arm/configs/omap_3630sdp_defconfig |  100 ++++++++++++++++++++++++++++++-
 arch/arm/configs/omap_zoom2_defconfig   |   91 +++++++++++++++++++++++++++-
 arch/arm/configs/omap_zoom3_defconfig   |  100 ++++++++++++++++++++++++++++++-
 3 files changed, 284 insertions(+), 7 deletions(-)

diff --git a/arch/arm/configs/omap_3630sdp_defconfig b/arch/arm/configs/omap_3630sdp_defconfig
index 57c1c4f..6b6da13 100644
--- a/arch/arm/configs/omap_3630sdp_defconfig
+++ b/arch/arm/configs/omap_3630sdp_defconfig
@@ -879,7 +879,103 @@ CONFIG_REGULATOR_TWL4030=y
 # CONFIG_REGULATOR_LP3971 is not set
 # CONFIG_REGULATOR_TPS65023 is not set
 # CONFIG_REGULATOR_TPS6507X is not set
-# CONFIG_MEDIA_SUPPORT is not set
+CONFIG_MEDIA_SUPPORT=y
+
+#
+# Multimedia core support
+#
+CONFIG_VIDEO_DEV=y
+CONFIG_VIDEO_V4L2_COMMON=y
+# CONFIG_VIDEO_ALLOW_V4L1 is not set
+CONFIG_VIDEO_V4L1_COMPAT=y
+# CONFIG_DVB_CORE is not set
+CONFIG_VIDEO_MEDIA=y
+
+#
+# Multimedia drivers
+#
+# CONFIG_MEDIA_ATTACH is not set
+CONFIG_MEDIA_TUNER=y
+# CONFIG_MEDIA_TUNER_CUSTOMISE is not set
+CONFIG_MEDIA_TUNER_SIMPLE=y
+CONFIG_MEDIA_TUNER_TDA8290=y
+CONFIG_MEDIA_TUNER_TDA9887=y
+CONFIG_MEDIA_TUNER_TEA5761=y
+CONFIG_MEDIA_TUNER_TEA5767=y
+CONFIG_MEDIA_TUNER_MT20XX=y
+CONFIG_MEDIA_TUNER_XC2028=y
+CONFIG_MEDIA_TUNER_XC5000=y
+CONFIG_MEDIA_TUNER_MC44S803=y
+CONFIG_VIDEO_V4L2=y
+CONFIG_VIDEOBUF_GEN=y
+CONFIG_VIDEOBUF_DMA_SG=y
+CONFIG_VIDEO_CAPTURE_DRIVERS=y
+# CONFIG_VIDEO_ADV_DEBUG is not set
+# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
+CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
+# CONFIG_VIDEO_VIVI is not set
+# CONFIG_VIDEO_SAA5246A is not set
+# CONFIG_VIDEO_SAA5249 is not set
+CONFIG_VIDEO_OMAP3_OUT=y
+CONFIG_VIDEO_OMAP2_VOUT=y
+# CONFIG_SOC_CAMERA is not set
+CONFIG_V4L_USB_DRIVERS=y
+# CONFIG_USB_VIDEO_CLASS is not set
+CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
+CONFIG_USB_GSPCA=m
+# CONFIG_USB_M5602 is not set
+# CONFIG_USB_STV06XX is not set
+# CONFIG_USB_GL860 is not set
+# CONFIG_USB_GSPCA_CONEX is not set
+# CONFIG_USB_GSPCA_ETOMS is not set
+# CONFIG_USB_GSPCA_FINEPIX is not set
+# CONFIG_USB_GSPCA_JEILINJ is not set
+# CONFIG_USB_GSPCA_MARS is not set
+# CONFIG_USB_GSPCA_MR97310A is not set
+# CONFIG_USB_GSPCA_OV519 is not set
+# CONFIG_USB_GSPCA_OV534 is not set
+# CONFIG_USB_GSPCA_PAC207 is not set
+# CONFIG_USB_GSPCA_PAC7302 is not set
+# CONFIG_USB_GSPCA_PAC7311 is not set
+# CONFIG_USB_GSPCA_SN9C20X is not set
+# CONFIG_USB_GSPCA_SONIXB is not set
+# CONFIG_USB_GSPCA_SONIXJ is not set
+# CONFIG_USB_GSPCA_SPCA500 is not set
+# CONFIG_USB_GSPCA_SPCA501 is not set
+# CONFIG_USB_GSPCA_SPCA505 is not set
+# CONFIG_USB_GSPCA_SPCA506 is not set
+# CONFIG_USB_GSPCA_SPCA508 is not set
+# CONFIG_USB_GSPCA_SPCA561 is not set
+# CONFIG_USB_GSPCA_SQ905 is not set
+# CONFIG_USB_GSPCA_SQ905C is not set
+# CONFIG_USB_GSPCA_STK014 is not set
+# CONFIG_USB_GSPCA_STV0680 is not set
+# CONFIG_USB_GSPCA_SUNPLUS is not set
+# CONFIG_USB_GSPCA_T613 is not set
+# CONFIG_USB_GSPCA_TV8532 is not set
+# CONFIG_USB_GSPCA_VC032X is not set
+# CONFIG_USB_GSPCA_ZC3XX is not set
+# CONFIG_VIDEO_PVRUSB2 is not set
+# CONFIG_VIDEO_HDPVR is not set
+# CONFIG_VIDEO_EM28XX is not set
+# CONFIG_VIDEO_CX231XX is not set
+# CONFIG_VIDEO_USBVISION is not set
+# CONFIG_USB_ET61X251 is not set
+# CONFIG_USB_SN9C102 is not set
+# CONFIG_USB_ZC0301 is not set
+CONFIG_USB_PWC_INPUT_EVDEV=y
+# CONFIG_USB_ZR364XX is not set
+# CONFIG_USB_STKWEBCAM is not set
+# CONFIG_USB_S2255 is not set
+CONFIG_RADIO_ADAPTERS=y
+# CONFIG_I2C_SI4713 is not set
+# CONFIG_RADIO_SI4713 is not set
+# CONFIG_USB_DSBR is not set
+# CONFIG_RADIO_SI470X is not set
+# CONFIG_USB_MR800 is not set
+# CONFIG_RADIO_TEA5764 is not set
+# CONFIG_RADIO_TEF6862 is not set
+# CONFIG_DAB is not set
 
 #
 # Graphics support
@@ -929,7 +1025,7 @@ CONFIG_OMAP2_DSS_MIN_FCK_PER_PCK=4
 CONFIG_FB_OMAP2=y
 # CONFIG_FB_OMAP2_DEBUG_SUPPORT is not set
 # CONFIG_FB_OMAP2_FORCE_AUTO_UPDATE is not set
-CONFIG_FB_OMAP2_NUM_FBS=3
+CONFIG_FB_OMAP2_NUM_FBS=1
 
 #
 # OMAP2/3 Display Device Drivers
diff --git a/arch/arm/configs/omap_zoom2_defconfig b/arch/arm/configs/omap_zoom2_defconfig
index 50b2bb8..a95a550 100644
--- a/arch/arm/configs/omap_zoom2_defconfig
+++ b/arch/arm/configs/omap_zoom2_defconfig
@@ -845,12 +845,96 @@ CONFIG_TWL4030_CORE=y
 #
 # Multimedia core support
 #
-# CONFIG_VIDEO_DEV is not set
+CONFIG_VIDEO_DEV=y
+CONFIG_VIDEO_V4L2_COMMON=y
+# CONFIG_VIDEO_ALLOW_V4L1 is not set
+CONFIG_VIDEO_V4L1_COMPAT=y
 # CONFIG_DVB_CORE is not set
-# CONFIG_VIDEO_MEDIA is not set
+CONFIG_VIDEO_MEDIA=y
 
 #
 # Multimedia drivers
+# CONFIG_MEDIA_ATTACH is not set
+CONFIG_MEDIA_TUNER=y
+# CONFIG_MEDIA_TUNER_CUSTOMISE is not set
+CONFIG_MEDIA_TUNER_SIMPLE=y
+CONFIG_MEDIA_TUNER_TDA8290=y
+CONFIG_MEDIA_TUNER_TDA9887=y
+CONFIG_MEDIA_TUNER_TEA5761=y
+CONFIG_MEDIA_TUNER_TEA5767=y
+CONFIG_MEDIA_TUNER_MT20XX=y
+CONFIG_MEDIA_TUNER_XC2028=y
+CONFIG_MEDIA_TUNER_XC5000=y
+CONFIG_MEDIA_TUNER_MC44S803=y
+CONFIG_VIDEO_V4L2=y
+CONFIG_VIDEOBUF_GEN=y
+CONFIG_VIDEOBUF_DMA_SG=y
+CONFIG_VIDEO_CAPTURE_DRIVERS=y
+# CONFIG_VIDEO_ADV_DEBUG is not set
+# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
+CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
+# CONFIG_VIDEO_VIVI is not set
+# CONFIG_VIDEO_SAA5246A is not set
+# CONFIG_VIDEO_SAA5249 is not set
+CONFIG_VIDEO_OMAP3_OUT=y
+CONFIG_VIDEO_OMAP2_VOUT=y
+# CONFIG_SOC_CAMERA is not set
+CONFIG_V4L_USB_DRIVERS=y
+# CONFIG_USB_VIDEO_CLASS is not set
+CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
+CONFIG_USB_GSPCA=m
+# CONFIG_USB_M5602 is not set
+# CONFIG_USB_STV06XX is not set
+# CONFIG_USB_GL860 is not set
+# CONFIG_USB_GSPCA_CONEX is not set
+# CONFIG_USB_GSPCA_ETOMS is not set
+# CONFIG_USB_GSPCA_FINEPIX is not set
+# CONFIG_USB_GSPCA_JEILINJ is not set
+# CONFIG_USB_GSPCA_MARS is not set
+# CONFIG_USB_GSPCA_MR97310A is not set
+# CONFIG_USB_GSPCA_OV519 is not set
+# CONFIG_USB_GSPCA_OV534 is not set
+# CONFIG_USB_GSPCA_PAC207 is not set
+# CONFIG_USB_GSPCA_PAC7302 is not set
+# CONFIG_USB_GSPCA_PAC7311 is not set
+# CONFIG_USB_GSPCA_SN9C20X is not set
+# CONFIG_USB_GSPCA_SONIXB is not set
+# CONFIG_USB_GSPCA_SONIXJ is not set
+# CONFIG_USB_GSPCA_SPCA500 is not set
+# CONFIG_USB_GSPCA_SPCA501 is not set
+# CONFIG_USB_GSPCA_SPCA505 is not set
+# CONFIG_USB_GSPCA_SPCA506 is not set
+# CONFIG_USB_GSPCA_SPCA508 is not set
+# CONFIG_USB_GSPCA_SPCA561 is not set
+# CONFIG_USB_GSPCA_SQ905 is not set
+# CONFIG_USB_GSPCA_SQ905C is not set
+# CONFIG_USB_GSPCA_STK014 is not set
+# CONFIG_USB_GSPCA_STV0680 is not set
+# CONFIG_USB_GSPCA_SUNPLUS is not set
+# CONFIG_USB_GSPCA_T613 is not set
+# CONFIG_USB_GSPCA_TV8532 is not set
+# CONFIG_USB_GSPCA_VC032X is not set
+# CONFIG_USB_GSPCA_ZC3XX is not set
+# CONFIG_VIDEO_PVRUSB2 is not set
+# CONFIG_VIDEO_HDPVR is not set
+# CONFIG_VIDEO_EM28XX is not set
+# CONFIG_VIDEO_CX231XX is not set
+# CONFIG_VIDEO_USBVISION is not set
+# CONFIG_USB_ET61X251 is not set
+# CONFIG_USB_SN9C102 is not set
+# CONFIG_USB_ZC0301 is not set
+CONFIG_USB_PWC_INPUT_EVDEV=y
+# CONFIG_USB_ZR364XX is not set
+# CONFIG_USB_STKWEBCAM is not set
+# CONFIG_USB_S2255 is not set
+CONFIG_RADIO_ADAPTERS=y
+# CONFIG_I2C_SI4713 is not set
+# CONFIG_RADIO_SI4713 is not set
+# CONFIG_USB_DSBR is not set
+# CONFIG_RADIO_SI470X is not set
+# CONFIG_USB_MR800 is not set
+# CONFIG_RADIO_TEA5764 is not set
+# CONFIG_RADIO_TEF6862 is not set
 #
 CONFIG_DAB=y
 # CONFIG_USB_DABUSB is not set
@@ -903,7 +987,7 @@ CONFIG_OMAP2_DSS_MIN_FCK_PER_PCK=4
 CONFIG_FB_OMAP2=y
 # CONFIG_FB_OMAP2_DEBUG_SUPPORT is not set
 # CONFIG_FB_OMAP2_FORCE_AUTO_UPDATE is not set
-CONFIG_FB_OMAP2_NUM_FBS=3
+CONFIG_FB_OMAP2_NUM_FBS=1
 
 #
 # OMAP2/3 Display Device Drivers
@@ -1226,6 +1310,7 @@ CONFIG_REGULATOR=y
 # CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
 # CONFIG_REGULATOR_BQ24022 is not set
 CONFIG_REGULATOR_TWL4030=y
+CONFIG_MEDIA_SUPPORT=y
 # CONFIG_UIO is not set
 # CONFIG_STAGING is not set
 
diff --git a/arch/arm/configs/omap_zoom3_defconfig b/arch/arm/configs/omap_zoom3_defconfig
index 1098d71..47e0045 100644
--- a/arch/arm/configs/omap_zoom3_defconfig
+++ b/arch/arm/configs/omap_zoom3_defconfig
@@ -880,7 +880,103 @@ CONFIG_REGULATOR_TWL4030=y
 # CONFIG_REGULATOR_LP3971 is not set
 # CONFIG_REGULATOR_TPS65023 is not set
 # CONFIG_REGULATOR_TPS6507X is not set
-# CONFIG_MEDIA_SUPPORT is not set
+CONFIG_MEDIA_SUPPORT=y
+
+#
+# Multimedia core support
+#
+CONFIG_VIDEO_DEV=y
+CONFIG_VIDEO_V4L2_COMMON=y
+# CONFIG_VIDEO_ALLOW_V4L1 is not set
+CONFIG_VIDEO_V4L1_COMPAT=y
+# CONFIG_DVB_CORE is not set
+CONFIG_VIDEO_MEDIA=y
+
+#
+# Multimedia drivers
+#
+# CONFIG_MEDIA_ATTACH is not set
+CONFIG_MEDIA_TUNER=y
+# CONFIG_MEDIA_TUNER_CUSTOMISE is not set
+CONFIG_MEDIA_TUNER_SIMPLE=y
+CONFIG_MEDIA_TUNER_TDA8290=y
+CONFIG_MEDIA_TUNER_TDA9887=y
+CONFIG_MEDIA_TUNER_TEA5761=y
+CONFIG_MEDIA_TUNER_TEA5767=y
+CONFIG_MEDIA_TUNER_MT20XX=y
+CONFIG_MEDIA_TUNER_XC2028=y
+CONFIG_MEDIA_TUNER_XC5000=y
+CONFIG_MEDIA_TUNER_MC44S803=y
+CONFIG_VIDEO_V4L2=y
+CONFIG_VIDEOBUF_GEN=y
+CONFIG_VIDEOBUF_DMA_SG=y
+CONFIG_VIDEO_CAPTURE_DRIVERS=y
+# CONFIG_VIDEO_ADV_DEBUG is not set
+# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
+CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
+# CONFIG_VIDEO_VIVI is not set
+# CONFIG_VIDEO_SAA5246A is not set
+# CONFIG_VIDEO_SAA5249 is not set
+CONFIG_VIDEO_OMAP3_OUT=y
+CONFIG_VIDEO_OMAP2_VOUT=y
+# CONFIG_SOC_CAMERA is not set
+CONFIG_V4L_USB_DRIVERS=y
+# CONFIG_USB_VIDEO_CLASS is not set
+CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
+CONFIG_USB_GSPCA=m
+# CONFIG_USB_M5602 is not set
+# CONFIG_USB_STV06XX is not set
+# CONFIG_USB_GL860 is not set
+# CONFIG_USB_GSPCA_CONEX is not set
+# CONFIG_USB_GSPCA_ETOMS is not set
+# CONFIG_USB_GSPCA_FINEPIX is not set
+# CONFIG_USB_GSPCA_JEILINJ is not set
+# CONFIG_USB_GSPCA_MARS is not set
+# CONFIG_USB_GSPCA_MR97310A is not set
+# CONFIG_USB_GSPCA_OV519 is not set
+# CONFIG_USB_GSPCA_OV534 is not set
+# CONFIG_USB_GSPCA_PAC207 is not set
+# CONFIG_USB_GSPCA_PAC7302 is not set
+# CONFIG_USB_GSPCA_PAC7311 is not set
+# CONFIG_USB_GSPCA_SN9C20X is not set
+# CONFIG_USB_GSPCA_SONIXB is not set
+# CONFIG_USB_GSPCA_SONIXJ is not set
+# CONFIG_USB_GSPCA_SPCA500 is not set
+# CONFIG_USB_GSPCA_SPCA501 is not set
+# CONFIG_USB_GSPCA_SPCA505 is not set
+# CONFIG_USB_GSPCA_SPCA506 is not set
+# CONFIG_USB_GSPCA_SPCA508 is not set
+# CONFIG_USB_GSPCA_SPCA561 is not set
+# CONFIG_USB_GSPCA_SQ905 is not set
+# CONFIG_USB_GSPCA_SQ905C is not set
+# CONFIG_USB_GSPCA_STK014 is not set
+# CONFIG_USB_GSPCA_STV0680 is not set
+# CONFIG_USB_GSPCA_SUNPLUS is not set
+# CONFIG_USB_GSPCA_T613 is not set
+# CONFIG_USB_GSPCA_TV8532 is not set
+# CONFIG_USB_GSPCA_VC032X is not set
+# CONFIG_USB_GSPCA_ZC3XX is not set
+# CONFIG_VIDEO_PVRUSB2 is not set
+# CONFIG_VIDEO_HDPVR is not set
+# CONFIG_VIDEO_EM28XX is not set
+# CONFIG_VIDEO_CX231XX is not set
+# CONFIG_VIDEO_USBVISION is not set
+# CONFIG_USB_ET61X251 is not set
+# CONFIG_USB_SN9C102 is not set
+# CONFIG_USB_ZC0301 is not set
+CONFIG_USB_PWC_INPUT_EVDEV=y
+# CONFIG_USB_ZR364XX is not set
+# CONFIG_USB_STKWEBCAM is not set
+# CONFIG_USB_S2255 is not set
+CONFIG_RADIO_ADAPTERS=y
+# CONFIG_I2C_SI4713 is not set
+# CONFIG_RADIO_SI4713 is not set
+# CONFIG_USB_DSBR is not set
+# CONFIG_RADIO_SI470X is not set
+# CONFIG_USB_MR800 is not set
+# CONFIG_RADIO_TEA5764 is not set
+# CONFIG_RADIO_TEF6862 is not set
+# CONFIG_DAB is not set
 
 #
 # Graphics support
@@ -930,7 +1026,7 @@ CONFIG_OMAP2_DSS_MIN_FCK_PER_PCK=4
 CONFIG_FB_OMAP2=y
 # CONFIG_FB_OMAP2_DEBUG_SUPPORT is not set
 # CONFIG_FB_OMAP2_FORCE_AUTO_UPDATE is not set
-CONFIG_FB_OMAP2_NUM_FBS=3
+CONFIG_FB_OMAP2_NUM_FBS=1
 
 #
 # OMAP2/3 Display Device Drivers
-- 
1.5.4.3
