Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.navvo.net ([74.208.67.6]:49171 "EHLO mail.navvo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124AbZKFPnP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Nov 2009 10:43:15 -0500
From: santiago.nunez@ridgerun.com
To: davinci-linux-open-source@linux.davincidsp.com
Cc: linux-media@vger.kernel.org, nsnehaprabha@ti.com,
	m-karicheri2@ti.com, diego.dompe@ridgerun.com,
	todd.fischer@ridgerun.com, mgrosen@ti.com,
	Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
Date: Fri,  6 Nov 2009 09:43:12 -0600
Message-Id: <1257522192-25990-1-git-send-email-santiago.nunez@ridgerun.com>
Subject: [PATCH 4/4 v6] Menu support for TVP7002 in DM365
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>

This patch provides menu configuration options for the TVP7002
decoder driver in DM365.

Signed-off-by: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
---
 drivers/media/video/Kconfig  |   32 ++++++++++++++++++++++++++++++++
 drivers/media/video/Makefile |    2 ++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index e6186b3..f33652e 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -392,6 +392,15 @@ config VIDEO_TVP5150
 	  To compile this driver as a module, choose M here: the
 	  module will be called tvp5150.
 
+config VIDEO_TVP7002
+	tristate "Texas Instruments TVP7002 video decoder"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Texas Instruments TVP7002 video decoder.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tvp7002.
+
 config VIDEO_VPX3220
 	tristate "vpx3220a, vpx3216b & vpx3214c video decoders"
 	depends on VIDEO_V4L2 && I2C
@@ -466,6 +475,29 @@ config VIDEO_THS7303
 	  To compile this driver as a module, choose M here: the
 	  module will be called ths7303.
 
+config VIDEO_THS7353
+	tristate "THS7353 Video Amplifier"
+	depends on I2C
+	help
+	  Support for TI THS7353 video amplifier
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ths7353.
+
+config VIDEO_THS7353_LUMA_CHANNEL
+	int "THS7353 channel number for Luma Input"
+	default 3
+	depends on VIDEO_THS7353
+	help
+	  Select the luma channel number for the THS7353 input.
+
+	  THS7353 has three identical channels. For the component
+	  interface, luma input will be connected to one of these
+	  channels and cb and cr will be connected to other channels
+	  This config option is used to select the luma input channel
+	  number. Possible values for this option are 1,2 or 3. Any
+	  other value will result in value 2.
+
 config VIDEO_ADV7343
 	tristate "ADV7343 video encoder"
 	depends on I2C
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index e541932..d9a421a 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -53,9 +53,11 @@ obj-$(CONFIG_VIDEO_BT856) += bt856.o
 obj-$(CONFIG_VIDEO_BT866) += bt866.o
 obj-$(CONFIG_VIDEO_KS0127) += ks0127.o
 obj-$(CONFIG_VIDEO_THS7303) += ths7303.o
+obj-$(CONFIG_VIDEO_THS7353) += ths7353.o
 obj-$(CONFIG_VIDEO_VINO) += indycam.o
 obj-$(CONFIG_VIDEO_TVP5150) += tvp5150.o
 obj-$(CONFIG_VIDEO_TVP514X) += tvp514x.o
+obj-$(CONFIG_VIDEO_TVP7002) += tvp7002.o
 obj-$(CONFIG_VIDEO_MSP3400) += msp3400.o
 obj-$(CONFIG_VIDEO_CS5345) += cs5345.o
 obj-$(CONFIG_VIDEO_CS53L32A) += cs53l32a.o
-- 
1.6.0.4

