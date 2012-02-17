Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60862 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab2BQI5T (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 03:57:19 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 2/7] media: tuners: append $(srctree) to -I parameters
Date: Fri, 17 Feb 2012 10:57:08 +0200
Message-Id: <1329469034-25493-2-git-send-email-andriy.shevchenko@linux.intel.com>
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
 drivers/media/common/tuners/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/tuners/Makefile b/drivers/media/common/tuners/Makefile
index 8295854..f80407e 100644
--- a/drivers/media/common/tuners/Makefile
+++ b/drivers/media/common/tuners/Makefile
@@ -29,5 +29,5 @@ obj-$(CONFIG_MEDIA_TUNER_MAX2165) += max2165.o
 obj-$(CONFIG_MEDIA_TUNER_TDA18218) += tda18218.o
 obj-$(CONFIG_MEDIA_TUNER_TDA18212) += tda18212.o
 
-ccflags-y += -Idrivers/media/dvb/dvb-core
-ccflags-y += -Idrivers/media/dvb/frontends
+ccflags-y += -I$(srctree)/drivers/media/dvb/dvb-core
+ccflags-y += -I$(srctree)/drivers/media/dvb/frontends
-- 
1.7.9

