Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:10149 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbaCRLT2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Mar 2014 07:19:28 -0400
From: Josh Wu <josh.wu@atmel.com>
To: <g.liakhovetski@gmx.de>
CC: <linux-media@vger.kernel.org>, <m.chehab@samsung.com>,
	<nicolas.ferre@atmel.com>, <linux-arm-kernel@lists.infradead.org>,
	Josh Wu <josh.wu@atmel.com>
Subject: [PATCH 1/3] [media] atmel-isi: add v4l2 async probe support
Date: Tue, 18 Mar 2014 19:13:57 +0800
Message-ID: <1395141238-5948-2-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1395141238-5948-1-git-send-email-josh.wu@atmel.com>
References: <1395141238-5948-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
 drivers/media/platform/soc_camera/atmel-isi.c |    5 +++++
 include/media/atmel-isi.h                     |    4 ++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index f0b6c90..d22aba1 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -982,6 +982,11 @@ static int atmel_isi_probe(struct platform_device *pdev)
 	soc_host->v4l2_dev.dev	= &pdev->dev;
 	soc_host->nr		= pdev->id;
 
+	if (isi->pdata.asd_sizes) {
+		soc_host->asd = isi->pdata.asd;
+		soc_host->asd_sizes = isi->pdata.asd_sizes;
+	}
+
 	ret = soc_camera_host_register(soc_host);
 	if (ret) {
 		dev_err(&pdev->dev, "Unable to register soc camera host\n");
diff --git a/include/media/atmel-isi.h b/include/media/atmel-isi.h
index 2b02347..c2e5703 100644
--- a/include/media/atmel-isi.h
+++ b/include/media/atmel-isi.h
@@ -106,6 +106,8 @@
 #define ISI_DATAWIDTH_8				0x01
 #define ISI_DATAWIDTH_10			0x02
 
+struct v4l2_async_subdev;
+
 struct isi_platform_data {
 	u8 has_emb_sync;
 	u8 emb_crc_sync;
@@ -118,6 +120,8 @@ struct isi_platform_data {
 	u32 frate;
 	/* Using for ISI_MCK */
 	u32 mck_hz;
+	struct v4l2_async_subdev **asd;	/* Flat array, arranged in groups */
+	int *asd_sizes;		/* 0-terminated array of asd group sizes */
 };
 
 #endif /* __ATMEL_ISI_H__ */
-- 
1.7.9.5

