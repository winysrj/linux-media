Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:52916 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106AbcF3MVB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2016 08:21:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] [media] vsp1: use __maybe_unused for PM handlers
Date: Thu, 30 Jun 2016 14:23:02 +0200
Message-Id: <20160630122325.4002029-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Building without CONFIG_PM results in a harmless warning from
slightly incorrect #ifdef guards:

drivers/media/platform/vsp1/vsp1_drv.c:525:12: error: 'vsp1_pm_runtime_resume' defined but not used [-Werror=unused-function]
drivers/media/platform/vsp1/vsp1_drv.c:516:12: error: 'vsp1_pm_runtime_suspend' defined but not used [-Werror=unused-function]

This removes the existing #ifdef and instead marks all four
PM functions as __maybe_unused.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 1e6af546ee66 ("[media] v4l: vsp1: Implement runtime PM support")
---
 drivers/media/platform/vsp1/vsp1_drv.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index e655639af7e2..0c7fd43d6fb7 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -491,8 +491,7 @@ void vsp1_device_put(struct vsp1_device *vsp1)
  * Power Management
  */
 
-#ifdef CONFIG_PM_SLEEP
-static int vsp1_pm_suspend(struct device *dev)
+static int __maybe_unused vsp1_pm_suspend(struct device *dev)
 {
 	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
 
@@ -502,7 +501,7 @@ static int vsp1_pm_suspend(struct device *dev)
 	return 0;
 }
 
-static int vsp1_pm_resume(struct device *dev)
+static int __maybe_unused vsp1_pm_resume(struct device *dev)
 {
 	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
 
@@ -511,9 +510,8 @@ static int vsp1_pm_resume(struct device *dev)
 
 	return 0;
 }
-#endif
 
-static int vsp1_pm_runtime_suspend(struct device *dev)
+static int __maybe_unused vsp1_pm_runtime_suspend(struct device *dev)
 {
 	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
 
@@ -522,7 +520,7 @@ static int vsp1_pm_runtime_suspend(struct device *dev)
 	return 0;
 }
 
-static int vsp1_pm_runtime_resume(struct device *dev)
+static int __maybe_unused vsp1_pm_runtime_resume(struct device *dev)
 {
 	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
 	int ret;
-- 
2.9.0

