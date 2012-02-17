Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:48319 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab2BQI5U (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 03:57:20 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 5/7] media: ivtv: append $(srctree) to -I parameters
Date: Fri, 17 Feb 2012 10:57:11 +0200
Message-Id: <1329469034-25493-5-git-send-email-andriy.shevchenko@linux.intel.com>
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
 drivers/media/video/ivtv/Makefile |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/ivtv/Makefile b/drivers/media/video/ivtv/Makefile
index 71ab76a..77de8a4 100644
--- a/drivers/media/video/ivtv/Makefile
+++ b/drivers/media/video/ivtv/Makefile
@@ -7,8 +7,8 @@ ivtv-objs	:= ivtv-routing.o ivtv-cards.o ivtv-controls.o \
 obj-$(CONFIG_VIDEO_IVTV) += ivtv.o
 obj-$(CONFIG_VIDEO_FB_IVTV) += ivtvfb.o
 
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

