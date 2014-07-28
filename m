Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.245]:41965 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750914AbaG1HYR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jul 2014 03:24:17 -0400
From: Josh Wu <josh.wu@atmel.com>
To: <linux-media@vger.kernel.org>, <g.liakhovetski@gmx.de>
CC: <m.chehab@samsung.com>, <linux-arm-kernel@lists.infradead.org>,
	<laurent.pinchart@ideasonboard.com>, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH v4 1/3] media: atmel-isi: add v4l2 async probe support
Date: Mon, 28 Jul 2014 15:22:46 +0800
Message-ID: <1406532167-32655-2-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1406532167-32655-1-git-send-email-josh.wu@atmel.com>
References: <1406532167-32655-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
v3 -> v4:
  no change.

 drivers/media/platform/soc_camera/atmel-isi.c | 5 +++++
 include/media/atmel-isi.h                     | 4 ++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 14bc886..802c203 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -987,6 +987,11 @@ static int atmel_isi_probe(struct platform_device *pdev)
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
1.9.1

