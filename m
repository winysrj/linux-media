Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:7954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755511Ab1EUMRR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2011 08:17:17 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p4LCHC2M002758
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 May 2011 08:17:17 -0400
Received: from [10.11.8.107] (vpn-8-107.rdu.redhat.com [10.11.8.107])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p4LCHBXl010775
	for <linux-media@vger.kernel.org>; Sat, 21 May 2011 08:17:11 -0400
Message-ID: <4DD7AD46.8070506@redhat.com>
Date: Sat, 21 May 2011 09:17:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] video/Kconfig: Fix mis-classified devices
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The helper chips are classified by their function. Unfortunaltely,
with time, developers added their stuff into the wrong places.

Fix it by moving itens to be at the right place. Also add a new
category for sensors and for misc devices that are found only on
a certain specific board.

While here, fix two bad whitespaces at Kconfig.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 9c701dd..3be180b 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -128,10 +128,10 @@ config VIDEO_IR_I2C
 # Encoder / Decoder module configuration
 #
 
-menu "Encoders/decoders and other helper chips"
+menu "Encoders, decoders, sensors and other helper chips"
 	visible if !VIDEO_HELPER_CHIPS_AUTO
 
-comment "Audio decoders"
+comment "Audio decoders, processors and mixers"
 
 config VIDEO_TVAUDIO
 	tristate "Simple audio decoder chips"
@@ -210,15 +210,6 @@ config VIDEO_CS53L32A
 	  To compile this driver as a module, choose M here: the
 	  module will be called cs53l32a.
 
-config VIDEO_M52790
-	tristate "Mitsubishi M52790 A/V switch"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	 Support for the Mitsubishi M52790 A/V switch.
-
-	 To compile this driver as a module, choose M here: the
-	 module will be called m52790.
-
 config VIDEO_TLV320AIC23B
 	tristate "Texas Instruments TLV320AIC23B audio codec"
 	depends on VIDEO_V4L2 && I2C && EXPERIMENTAL
@@ -321,36 +312,6 @@ config VIDEO_KS0127
 	  To compile this driver as a module, choose M here: the
 	  module will be called ks0127.
 
-config VIDEO_OV7670
-	tristate "OmniVision OV7670 sensor support"
-	depends on I2C && VIDEO_V4L2
-	---help---
-	  This is a Video4Linux2 sensor-level driver for the OmniVision
-	  OV7670 VGA camera.  It currently only works with the M88ALP01
-	  controller.
-
-config VIDEO_MT9V011
-	tristate "Micron mt9v011 sensor support"
-	depends on I2C && VIDEO_V4L2
-	---help---
-	  This is a Video4Linux2 sensor-level driver for the Micron
-	  mt0v011 1.3 Mpixel camera.  It currently only works with the
-	  em28xx driver.
-
-config VIDEO_MT9V032
-	tristate "Micron MT9V032 sensor support"
-	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
-	---help---
-	  This is a Video4Linux2 sensor-level driver for the Micron
-	  MT9V032 752x480 CMOS sensor.
-
-config VIDEO_TCM825X
-	tristate "TCM825x camera sensor support"
-	depends on I2C && VIDEO_V4L2
-	---help---
-	  This is a driver for the Toshiba TCM825x VGA camera sensor.
-	  It is used for example in Nokia N800.
-
 config VIDEO_SAA7110
 	tristate "Philips SAA7110 video decoder"
 	depends on VIDEO_V4L2 && I2C
@@ -369,15 +330,6 @@ config VIDEO_SAA711X
 	  To compile this driver as a module, choose M here: the
 	  module will be called saa7115.
 
-config VIDEO_SAA717X
-	tristate "Philips SAA7171/3/4 audio/video decoders"
-	depends on VIDEO_V4L2 && I2C
-	---help---
-	  Support for the Philips SAA7171/3/4 audio/video decoders.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called saa717x.
-
 config VIDEO_SAA7191
 	tristate "Philips SAA7191 video decoder"
 	depends on VIDEO_V4L2 && I2C
@@ -427,6 +379,15 @@ config VIDEO_VPX3220
 
 comment "Video and audio decoders"
 
+config VIDEO_SAA717X
+	tristate "Philips SAA7171/3/4 audio/video decoders"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Philips SAA7171/3/4 audio/video decoders.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called saa717x.
+
 source "drivers/media/video/cx25840/Kconfig"
 
 comment "MPEG video encoders"
@@ -481,15 +442,6 @@ config VIDEO_ADV7175
 	  To compile this driver as a module, choose M here: the
 	  module will be called adv7175.
 
-config VIDEO_THS7303
-	tristate "THS7303 Video Amplifier"
-	depends on I2C
-	help
-	  Support for TI THS7303 video amplifier
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called ths7303.
-
 config VIDEO_ADV7343
 	tristate "ADV7343 video encoder"
 	depends on I2C
@@ -505,6 +457,38 @@ config VIDEO_AK881X
 	help
 	  Video output driver for AKM AK8813 and AK8814 TV encoders
 
+comment "Camera sensor devices"
+
+config VIDEO_OV7670
+	tristate "OmniVision OV7670 sensor support"
+	depends on I2C && VIDEO_V4L2
+	---help---
+	  This is a Video4Linux2 sensor-level driver for the OmniVision
+	  OV7670 VGA camera.  It currently only works with the M88ALP01
+	  controller.
+
+config VIDEO_MT9V011
+	tristate "Micron mt9v011 sensor support"
+	depends on I2C && VIDEO_V4L2
+	---help---
+	  This is a Video4Linux2 sensor-level driver for the Micron
+	  mt0v011 1.3 Mpixel camera.  It currently only works with the
+	  em28xx driver.
+
+config VIDEO_MT9V032
+	tristate "Micron MT9V032 sensor support"
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	---help---
+	  This is a Video4Linux2 sensor-level driver for the Micron
+	  MT9V032 752x480 CMOS sensor.
+
+config VIDEO_TCM825X
+	tristate "TCM825x camera sensor support"
+	depends on I2C && VIDEO_V4L2
+	---help---
+	  This is a driver for the Toshiba TCM825x VGA camera sensor.
+	  It is used for example in Nokia N800.
+
 comment "Video improvement chips"
 
 config VIDEO_UPD64031A
@@ -530,6 +514,26 @@ config VIDEO_UPD64083
 	  To compile this driver as a module, choose M here: the
 	  module will be called upd64083.
 
+comment "Miscelaneous helper chips"
+
+config VIDEO_THS7303
+	tristate "THS7303 Video Amplifier"
+	depends on I2C
+	help
+	  Support for TI THS7303 video amplifier
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ths7303.
+
+config VIDEO_M52790
+	tristate "Mitsubishi M52790 A/V switch"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	 Support for the Mitsubishi M52790 A/V switch.
+
+	 To compile this driver as a module, choose M here: the
+	 module will be called m52790.
+
 endmenu # encoder / decoder chips
 
 config VIDEO_SH_VOU
@@ -923,7 +927,7 @@ config VIDEO_OMAP2
 	  This is a v4l2 driver for the TI OMAP2 camera capture interface
 
 config VIDEO_MX2_HOSTSUPPORT
-        bool
+	bool
 
 config VIDEO_MX2
 	tristate "i.MX27/i.MX25 Camera Sensor Interface driver"
@@ -1010,7 +1014,7 @@ config USB_STKWEBCAM
 	  Supported devices are typically found in some Asus laptops,
 	  with USB id 174f:a311 and 05e1:0501. Other Syntek cameras
 	  may be supported by the stk11xx driver, from which this is
-	  derived, see <http://sourceforge.net/projects/syntekdriver/> 
+	  derived, see <http://sourceforge.net/projects/syntekdriver/>
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called stkwebcam.
