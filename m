Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:22037 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310AbbIVFLg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 01:11:36 -0400
From: Josh Wu <josh.wu@atmel.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Josh Wu <josh.wu@atmel.com>
Subject: [PATCH 3/5] media: atmel-isi: add code to setup correct resolution for preview path
Date: Tue, 22 Sep 2015 13:14:32 +0800
Message-ID: <1442898875-7147-4-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1442898875-7147-1-git-send-email-josh.wu@atmel.com>
References: <1442898875-7147-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Not like codec path, preview path can do downsampling, so we should setup
a extra preview width, height for it.

This patch add preview resolution setup without down sampling. So currently
preview path will output same size as sensor output size.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---

 drivers/media/platform/soc_camera/atmel-isi.c | 12 +++++++++++-
 drivers/media/platform/soc_camera/atmel-isi.h | 10 ++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index e6f4ade..bbf6449 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -135,7 +135,7 @@ static u32 setup_cfg2_yuv_swap(struct atmel_isi *isi,
 static void configure_geometry(struct atmel_isi *isi, u32 width,
 		u32 height, const struct soc_camera_format_xlate *xlate)
 {
-	u32 cfg2;
+	u32 cfg2, psize;
 
 	/* According to sensor's output format to set cfg2 */
 	switch (xlate->code) {
@@ -163,6 +163,16 @@ static void configure_geometry(struct atmel_isi *isi, u32 width,
 	cfg2 |= ((height - 1) << ISI_CFG2_IM_VSIZE_OFFSET)
 			& ISI_CFG2_IM_VSIZE_MASK;
 	isi_writel(isi, ISI_CFG2, cfg2);
+
+	/* No down sampling, preview size equal to sensor output size */
+	psize = ((width - 1) << ISI_PSIZE_PREV_HSIZE_OFFSET) &
+		ISI_PSIZE_PREV_HSIZE_MASK;
+	psize |= ((height - 1) << ISI_PSIZE_PREV_VSIZE_OFFSET) &
+		ISI_PSIZE_PREV_VSIZE_MASK;
+	isi_writel(isi, ISI_PSIZE, psize);
+	isi_writel(isi, ISI_PDECF, ISI_PDECF_NO_SAMPLING);
+
+	return;
 }
 
 static bool is_supported(struct soc_camera_device *icd,
diff --git a/drivers/media/platform/soc_camera/atmel-isi.h b/drivers/media/platform/soc_camera/atmel-isi.h
index 5acc771..0acb32a 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.h
+++ b/drivers/media/platform/soc_camera/atmel-isi.h
@@ -79,6 +79,16 @@
 #define ISI_CFG2_IM_VSIZE_MASK		(0x7FF << ISI_CFG2_IM_VSIZE_OFFSET)
 #define ISI_CFG2_IM_HSIZE_MASK		(0x7FF << ISI_CFG2_IM_HSIZE_OFFSET)
 
+/* Bitfields in PSIZE */
+#define ISI_PSIZE_PREV_VSIZE_OFFSET	0
+#define ISI_PSIZE_PREV_HSIZE_OFFSET	16
+#define ISI_PSIZE_PREV_VSIZE_MASK	(0x3FF << ISI_PSIZE_PREV_VSIZE_OFFSET)
+#define ISI_PSIZE_PREV_HSIZE_MASK	(0x3FF << ISI_PSIZE_PREV_HSIZE_OFFSET)
+
+/* Bitfields in PDECF */
+#define ISI_PDECF_DEC_FACTOR_MASK	(0xFF << 0)
+#define	ISI_PDECF_NO_SAMPLING		(16)
+
 /* Bitfields in CTRL */
 /* Also using in SR(ISI_V2) */
 #define ISI_CTRL_EN				(1 << 0)
-- 
1.9.1

