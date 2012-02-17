Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:48319 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509Ab2BQI5T (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 03:57:19 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 3/7] media: gspca: append $(srctree) to -I parameters
Date: Fri, 17 Feb 2012 10:57:09 +0200
Message-Id: <1329469034-25493-3-git-send-email-andriy.shevchenko@linux.intel.com>
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
 drivers/media/video/gspca/gl860/Makefile   |    2 +-
 drivers/media/video/gspca/m5602/Makefile   |    2 +-
 drivers/media/video/gspca/stv06xx/Makefile |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/gspca/gl860/Makefile b/drivers/media/video/gspca/gl860/Makefile
index f511ecc..773ea34 100644
--- a/drivers/media/video/gspca/gl860/Makefile
+++ b/drivers/media/video/gspca/gl860/Makefile
@@ -6,5 +6,5 @@ gspca_gl860-objs := gl860.o \
 		    gl860-ov9655.o \
 		    gl860-mi2020.o
 
-ccflags-y += -Idrivers/media/video/gspca
+ccflags-y += -I$(srctree)/drivers/media/video/gspca
 
diff --git a/drivers/media/video/gspca/m5602/Makefile b/drivers/media/video/gspca/m5602/Makefile
index 7f52961..575b75b 100644
--- a/drivers/media/video/gspca/m5602/Makefile
+++ b/drivers/media/video/gspca/m5602/Makefile
@@ -8,4 +8,4 @@ gspca_m5602-objs := m5602_core.o \
 		    m5602_s5k83a.o \
 		    m5602_s5k4aa.o
 
-ccflags-y += -Idrivers/media/video/gspca
+ccflags-y += -I$(srctree)/drivers/media/video/gspca
diff --git a/drivers/media/video/gspca/stv06xx/Makefile b/drivers/media/video/gspca/stv06xx/Makefile
index 5b318fa..38bc410 100644
--- a/drivers/media/video/gspca/stv06xx/Makefile
+++ b/drivers/media/video/gspca/stv06xx/Makefile
@@ -6,5 +6,5 @@ gspca_stv06xx-objs := stv06xx.o \
 		      stv06xx_pb0100.o \
 		      stv06xx_st6422.o
 
-ccflags-y += -Idrivers/media/video/gspca
+ccflags-y += -I$(srctree)/drivers/media/video/gspca
 
-- 
1.7.9

