Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:60619 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964823AbeEYPZj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 11:25:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Pavel Machek <pavel@ucw.cz>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] media: omap3isp: fix warning for !CONFIG_PM
Date: Fri, 25 May 2018 17:25:08 +0200
Message-Id: <20180525152523.2821369-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The final version of the COMPILE_TEST patch for this driver missed
one warning about suspend/resume functions that can now appear
on platforms that don't always set CONFIG_PM:

drivers/media/platform/omap3isp/isp.c:1008:13: error: 'isp_resume_modules' defined but not used [-Werror=unused-function]
 static void isp_resume_modules(struct isp_device *isp)
             ^~~~~~~~~~~~~~~~~~
drivers/media/platform/omap3isp/isp.c:974:12: error: 'isp_suspend_modules' defined but not used [-Werror=unused-function]
 static int isp_suspend_modules(struct isp_device *isp)

This marks the respective functions as __maybe_unused as an easy
workaround.

Fixes: 243131134be4 ("media: omap3isp: Allow it to build with COMPILE_TEST")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/omap3isp/isp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index f22cf351e3ee..a658c12eead1 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -971,7 +971,7 @@ static void isp_resume_module_pipeline(struct media_entity *me)
  * Returns 0 if suspend left in idle state all the submodules properly,
  * or returns 1 if a general Reset is required to suspend the submodules.
  */
-static int isp_suspend_modules(struct isp_device *isp)
+static int __maybe_unused isp_suspend_modules(struct isp_device *isp)
 {
 	unsigned long timeout;
 
@@ -1005,7 +1005,7 @@ static int isp_suspend_modules(struct isp_device *isp)
  * isp_resume_modules - Resume ISP submodules.
  * @isp: OMAP3 ISP device
  */
-static void isp_resume_modules(struct isp_device *isp)
+static void __maybe_unused isp_resume_modules(struct isp_device *isp)
 {
 	omap3isp_stat_resume(&isp->isp_aewb);
 	omap3isp_stat_resume(&isp->isp_af);
-- 
2.9.0
