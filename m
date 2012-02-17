Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60862 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509Ab2BQI5S (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 03:57:18 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 1/7] media: video: append $(srctree) to -I parameters
Date: Fri, 17 Feb 2012 10:57:07 +0200
Message-Id: <1329469034-25493-1-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <2218117.VoHfpPQjC4@avalon>
References: <2218117.VoHfpPQjC4@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without this we have got the warnings like following if build with "make W=1
O=/var/tmp":
   CHECK   drivers/media/video/videobuf-vmalloc.c
   CC [M]  drivers/media/video/videobuf-vmalloc.o
 +cc1: warning: drivers/media/dvb/dvb-core: No such file or directory [enabled by default]
 +cc1: warning: drivers/media/dvb/frontends: No such file or directory [enabled by default]
 +cc1: warning: drivers/media/dvb/dvb-core: No such file or directory [enabled by default]
 +cc1: warning: drivers/media/dvb/frontends: No such file or directory [enabled by default]
   LD      drivers/media/built-in.o

Some details could be found in [1] as well.

[1] http://comments.gmane.org/gmane.linux.kbuild.devel/7733

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/video/Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 3541388..3bf0aa8 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -199,6 +199,6 @@ obj-y	+= davinci/
 
 obj-$(CONFIG_ARCH_OMAP)	+= omap/
 
-ccflags-y += -Idrivers/media/dvb/dvb-core
-ccflags-y += -Idrivers/media/dvb/frontends
-ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -I$(srctree)/drivers/media/dvb/dvb-core
+ccflags-y += -I$(srctree)/drivers/media/dvb/frontends
+ccflags-y += -I$(srctree)/drivers/media/common/tuners
-- 
1.7.9

