Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:45491 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab2JDHYr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 03:24:47 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBC00LFOXWSZVQ0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:24:46 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBC006I9XWMLU10@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:24:46 +0900 (KST)
From: Rahul Sharma <rahul.sharma@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, inki.dae@samsung.com,
	kyungmin.park@samsung.com, joshi@samsung.com
Subject: [PATCH v1 07/14] drm: exynos: hdmi: add support for exynos5 ddc
Date: Thu, 04 Oct 2012 21:12:45 +0530
Message-id: <1349365372-21417-8-git-send-email-rahul.sharma@samsung.com>
In-reply-to: <1349365372-21417-1-git-send-email-rahul.sharma@samsung.com>
References: <1349365372-21417-1-git-send-email-rahul.sharma@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for exynos5 ddc with device tree enabled.

Signed-off-by: Rahul Sharma <rahul.sharma@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_ddc.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_ddc.c b/drivers/gpu/drm/exynos/exynos_ddc.c
index 7e1051d..ef28779 100644
--- a/drivers/gpu/drm/exynos/exynos_ddc.c
+++ b/drivers/gpu/drm/exynos/exynos_ddc.c
@@ -26,29 +26,41 @@ static int s5p_ddc_probe(struct i2c_client *client,
 {
 	hdmi_attach_ddc_client(client);
 
-	dev_info(&client->adapter->dev, "attached s5p_ddc "
-		"into i2c adapter successfully\n");
+	dev_info(&client->adapter->dev,
+		"attached %s into i2c adapter successfully\n",
+		client->name);
 
 	return 0;
 }
 
 static int s5p_ddc_remove(struct i2c_client *client)
 {
-	dev_info(&client->adapter->dev, "detached s5p_ddc "
-		"from i2c adapter successfully\n");
+	dev_info(&client->adapter->dev,
+		"detached %s from i2c adapter successfully\n",
+		client->name);
 
 	return 0;
 }
 
 static struct i2c_device_id ddc_idtable[] = {
 	{"s5p_ddc", 0},
+	{"exynos5-hdmiddc", 0},
 	{ },
 };
 
+static struct of_device_id hdmiddc_match_types[] = {
+	{
+		.compatible = "samsung,exynos5-hdmiddc",
+	}, {
+		/* end node */
+	}
+};
+
 struct i2c_driver ddc_driver = {
 	.driver = {
-		.name = "s5p_ddc",
+		.name = "exynos-hdmiddc",
 		.owner = THIS_MODULE,
+		.of_match_table = hdmiddc_match_types,
 	},
 	.id_table	= ddc_idtable,
 	.probe		= s5p_ddc_probe,
-- 
1.7.0.4

