Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:45511 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab2JDHZG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 03:25:06 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBC00LFOXWSZVQ0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:24:48 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBC006I9XWMLU10@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:24:48 +0900 (KST)
From: Rahul Sharma <rahul.sharma@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, inki.dae@samsung.com,
	kyungmin.park@samsung.com, joshi@samsung.com
Subject: [PATCH v1 08/14] drm: exynos: hdmi: add support for exynos5 hdmiphy
Date: Thu, 04 Oct 2012 21:12:46 +0530
Message-id: <1349365372-21417-9-git-send-email-rahul.sharma@samsung.com>
In-reply-to: <1349365372-21417-1-git-send-email-rahul.sharma@samsung.com>
References: <1349365372-21417-1-git-send-email-rahul.sharma@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for exynos5 hdmi phy with device tree enabled.

Signed-off-by: Rahul Sharma <rahul.sharma@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_hdmiphy.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_hdmiphy.c b/drivers/gpu/drm/exynos/exynos_hdmiphy.c
index 9fe2995..a33073b 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmiphy.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmiphy.c
@@ -42,13 +42,23 @@ static int hdmiphy_remove(struct i2c_client *client)
 
 static const struct i2c_device_id hdmiphy_id[] = {
 	{ "s5p_hdmiphy", 0 },
+	{ "exynos5-hdmiphy", 0 },
 	{ },
 };
 
+static struct of_device_id hdmiphy_match_types[] = {
+	{
+		.compatible = "samsung,exynos5-hdmiphy",
+	}, {
+		/* end node */
+	}
+};
+
 struct i2c_driver hdmiphy_driver = {
 	.driver = {
-		.name	= "s5p-hdmiphy",
+		.name	= "exynos-hdmiphy",
 		.owner	= THIS_MODULE,
+		.of_match_table = hdmiphy_match_types,
 	},
 	.id_table = hdmiphy_id,
 	.probe		= hdmiphy_probe,
-- 
1.7.0.4

