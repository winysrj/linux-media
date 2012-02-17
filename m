Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32474 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab2BQI5U (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 03:57:20 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 4/7] media: dvb: append $(srctree) to -I parameters
Date: Fri, 17 Feb 2012 10:57:10 +0200
Message-Id: <1329469034-25493-4-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1329469034-25493-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <2218117.VoHfpPQjC4@avalon>
 <1329469034-25493-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without this we have got the warnings like following if build with "make W=1
O=/var/tmp":
  cc1: warning: drivers/media/dvb/dvb-core: No such file or directory [enabled by default]

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/dvb/dvb-usb/Makefile   |    7 ++++---
 drivers/media/dvb/frontends/Makefile |    4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/Makefile b/drivers/media/dvb/dvb-usb/Makefile
index d9549cb..2e64f84 100644
--- a/drivers/media/dvb/dvb-usb/Makefile
+++ b/drivers/media/dvb/dvb-usb/Makefile
@@ -107,8 +107,9 @@ obj-$(CONFIG_DVB_USB_MXL111SF) += dvb-usb-mxl111sf.o
 obj-$(CONFIG_DVB_USB_MXL111SF) += mxl111sf-demod.o
 obj-$(CONFIG_DVB_USB_MXL111SF) += mxl111sf-tuner.o
 
-ccflags-y += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
+ccflags-y += -I$(srctree)/drivers/media/dvb/dvb-core
+ccflags-y += -I$(srctree)/drivers/media/dvb/frontends/
 # due to tuner-xc3028
-ccflags-y += -Idrivers/media/common/tuners
-EXTRA_CFLAGS += -Idrivers/media/dvb/ttpci
+ccflags-y += -I$(srctree)/drivers/media/common/tuners
+ccflags-y += -I$(srctree)/drivers/media/dvb/ttpci
 
diff --git a/drivers/media/dvb/frontends/Makefile b/drivers/media/dvb/frontends/Makefile
index 00a2063..90320f1 100644
--- a/drivers/media/dvb/frontends/Makefile
+++ b/drivers/media/dvb/frontends/Makefile
@@ -2,8 +2,8 @@
 # Makefile for the kernel DVB frontend device drivers.
 #
 
-ccflags-y += -Idrivers/media/dvb/dvb-core/
-ccflags-y += -Idrivers/media/common/tuners/
+ccflags-y += -I$(srctree)/drivers/media/dvb/dvb-core/
+ccflags-y += -I$(srctree)/drivers/media/common/tuners/
 
 stb0899-objs = stb0899_drv.o stb0899_algo.o
 stv0900-objs = stv0900_core.o stv0900_sw.o
-- 
1.7.9

