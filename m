Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:22190 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab1HHRNC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2011 13:13:02 -0400
Received: from spt2.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LPM00BERD5O9Z@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 08 Aug 2011 18:13:00 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LPM008WUD5NVZ@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 08 Aug 2011 18:12:59 +0100 (BST)
Date: Mon, 08 Aug 2011 19:12:51 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: [PATCH] media: s5p-mfc: fix section mismatch
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	k.debski@samsung.com, jaeryul.oh@samsung.com, mchehab@redhat.com
Message-id: <1312823571-13891-1-git-send-email-k.debski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix section mismatch in the MFC driver.

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-mfc/s5p_mfc.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c b/drivers/media/video/s5p-mfc/s5p_mfc.c
index 7dc7eab..90ffbfa 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
@@ -940,9 +940,8 @@ static int match_child(struct device *dev, void *data)
 	return !strcmp(dev_name(dev), (char *)data);
 }
 
-
 /* MFC probe function */
-static int __devinit s5p_mfc_probe(struct platform_device *pdev)
+static int s5p_mfc_probe(struct platform_device *pdev)
 {
 	struct s5p_mfc_dev *dev;
 	struct video_device *vfd;
@@ -1236,7 +1235,7 @@ static const struct dev_pm_ops s5p_mfc_pm_ops = {
 			   NULL)
 };
 
-static struct platform_driver s5p_mfc_pdrv = {
+static struct platform_driver s5p_mfc_driver = {
 	.probe	= s5p_mfc_probe,
 	.remove	= __devexit_p(s5p_mfc_remove),
 	.driver	= {
@@ -1254,15 +1253,15 @@ static int __init s5p_mfc_init(void)
 	int ret;
 
 	pr_info("%s", banner);
-	ret = platform_driver_register(&s5p_mfc_pdrv);
+	ret = platform_driver_register(&s5p_mfc_driver);
 	if (ret)
 		pr_err("Platform device registration failed.\n");
 	return ret;
 }
 
-static void __devexit s5p_mfc_exit(void)
+static void __exit s5p_mfc_exit(void)
 {
-	platform_driver_unregister(&s5p_mfc_pdrv);
+	platform_driver_unregister(&s5p_mfc_driver);
 }
 
 module_init(s5p_mfc_init);
-- 
1.6.3.3

