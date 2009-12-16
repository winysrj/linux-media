Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.navvo.net ([74.208.67.6]:42205 "EHLO mail.navvo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757954AbZLPVbv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2009 16:31:51 -0500
From: santiago.nunez@ridgerun.com
To: davinci-linux-open-source@linux.davincidsp.com
Cc: linux-media@vger.kernel.org, nsnehaprabha@ti.com,
	m-karicheri2@ti.com, diego.dompe@ridgerun.com,
	todd.fischer@ridgerun.com, mgrosen@ti.com,
	Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
Date: Wed, 16 Dec 2009 15:32:12 -0600
Message-Id: <1260999132-28383-1-git-send-email-santiago.nunez@ridgerun.com>
Subject: [PATCH 4/4 v12] Menu support for TVP7002 in DM365
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>

This patch provides menu configuration options for the TVP7002
decoder driver in DM365. Includes only TVP7002.

Signed-off-by: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
---
 drivers/media/video/Kconfig  |    9 +++++++++
 drivers/media/video/Makefile |    1 +
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index e6186b3..25f5735 100644
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
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index e541932..a4fff2a 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -56,6 +56,7 @@ obj-$(CONFIG_VIDEO_THS7303) += ths7303.o
 obj-$(CONFIG_VIDEO_VINO) += indycam.o
 obj-$(CONFIG_VIDEO_TVP5150) += tvp5150.o
 obj-$(CONFIG_VIDEO_TVP514X) += tvp514x.o
+obj-$(CONFIG_VIDEO_TVP7002) += tvp7002.o
 obj-$(CONFIG_VIDEO_MSP3400) += msp3400.o
 obj-$(CONFIG_VIDEO_CS5345) += cs5345.o
 obj-$(CONFIG_VIDEO_CS53L32A) += cs53l32a.o
-- 
1.6.0.4

