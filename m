Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:62982 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756347AbcCBQAq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2016 11:00:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 13/14] [media] omap3isp: use IS_ENABLED() to hide pm functions
Date: Wed,  2 Mar 2016 16:59:05 +0100
Message-Id: <1456934350-1389172-14-git-send-email-arnd@arndb.de>
In-Reply-To: <1456934350-1389172-1-git-send-email-arnd@arndb.de>
References: <1456934350-1389172-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The omap3isp driver hides is power management functions using #ifdef
but it fails to hide the isp_suspend_modules/isp_resume_modules
functions in the same way, which leads to a build warning when
CONFIG_PM is disabled:

drivers/media/platform/omap3isp/isp.c:1183:12: error: 'isp_suspend_modules' defined but not used [-Werror=unused-function]
drivers/media/platform/omap3isp/isp.c:1217:13: error: 'isp_resume_modules' defined but not used [-Werror=unused-function]

As the driver manually defines its dev_pm_ops structure and all
members are NULL without CONFIG_PM, we can simply avoid referencing
the structure using an IS_ENABLED() check, and drop all the #ifdef
to avoid all warnings.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/omap3isp/isp.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index f9e5245f26ac..7f118baca270 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1713,8 +1713,6 @@ void omap3isp_print_status(struct isp_device *isp)
 	dev_dbg(isp->dev, "--------------------------------------------\n");
 }
 
-#ifdef CONFIG_PM
-
 /*
  * Power management support.
  *
@@ -1785,15 +1783,6 @@ static void isp_pm_complete(struct device *dev)
 	isp_resume_modules(isp);
 }
 
-#else
-
-#define isp_pm_prepare	NULL
-#define isp_pm_suspend	NULL
-#define isp_pm_resume	NULL
-#define isp_pm_complete	NULL
-
-#endif /* CONFIG_PM */
-
 static void isp_unregister_entities(struct isp_device *isp)
 {
 	omap3isp_csi2_unregister_entities(&isp->isp_csi2a);
@@ -2611,7 +2600,7 @@ static struct platform_driver omap3isp_driver = {
 	.id_table = omap3isp_id_table,
 	.driver = {
 		.name = "omap3isp",
-		.pm	= &omap3isp_pm_ops,
+		.pm	= IS_ENABLED(CONFIG_PM) ? &omap3isp_pm_ops : NULL,
 		.of_match_table = omap3isp_of_table,
 	},
 };
-- 
2.7.0

