Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:48319 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096Ab2BQI5W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 03:57:22 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 7/7] media: saa7134: append $(srctree) to -I parameters
Date: Fri, 17 Feb 2012 10:57:13 +0200
Message-Id: <1329469034-25493-7-git-send-email-andriy.shevchenko@linux.intel.com>
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
 drivers/media/video/saa7134/Makefile |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/saa7134/Makefile b/drivers/media/video/saa7134/Makefile
index a646ccf..da38993 100644
--- a/drivers/media/video/saa7134/Makefile
+++ b/drivers/media/video/saa7134/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_VIDEO_SAA7134_ALSA) += saa7134-alsa.o
 
 obj-$(CONFIG_VIDEO_SAA7134_DVB) += saa7134-dvb.o
 
-ccflags-y += -Idrivers/media/video
-ccflags-y += -Idrivers/media/common/tuners
-ccflags-y += -Idrivers/media/dvb/dvb-core
-ccflags-y += -Idrivers/media/dvb/frontends
+ccflags-y += -I$(srctree)/drivers/media/video
+ccflags-y += -I$(srctree)/drivers/media/common/tuners
+ccflags-y += -I$(srctree)/drivers/media/dvb/dvb-core
+ccflags-y += -I$(srctree)/drivers/media/dvb/frontends
-- 
1.7.9

