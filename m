Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42956 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab3FQO7Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 10:59:24 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Kamil Debski <k.debski@samsung.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	=?UTF-8?q?Ga=C3=ABtan=20Carlier?= <gcembed@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 6/8] [media] coda: dynamic IRAM setup for decoder
Date: Mon, 17 Jun 2013 16:59:17 +0200
Message-Id: <1371481159-27412-7-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1371481159-27412-1-git-send-email-p.zabel@pengutronix.de>
References: <1371481159-27412-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 50 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 48 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 1f3bd43..856a93e 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1212,6 +1212,7 @@ static void coda_setup_iram(struct coda_ctx *ctx)
 	int ipacdc_size;
 	int bitram_size;
 	int dbk_size;
+	int ovl_size;
 	int mb_width;
 	int me_size;
 	int size;
@@ -1273,7 +1274,47 @@ static void coda_setup_iram(struct coda_ctx *ctx)
 			size -= ipacdc_size;
 		}
 
-		/* OVL disabled for encoder */
+		/* OVL and BTP disabled for encoder */
+	} else if (ctx->inst_type == CODA_INST_DECODER) {
+		struct coda_q_data *q_data_dst;
+		int mb_height;
+
+		q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+		mb_width = DIV_ROUND_UP(q_data_dst->width, 16);
+		mb_height = DIV_ROUND_UP(q_data_dst->height, 16);
+
+		dbk_size = round_up(256 * mb_width, 1024);
+		if (size >= dbk_size) {
+			iram_info->axi_sram_use |= CODA7_USE_HOST_DBK_ENABLE;
+			iram_info->buf_dbk_y_use = dev->iram_paddr;
+			iram_info->buf_dbk_c_use = dev->iram_paddr +
+						   dbk_size / 2;
+			size -= dbk_size;
+		} else {
+			goto out;
+		}
+
+		bitram_size = round_up(128 * mb_width, 1024);
+		if (size >= bitram_size) {
+			iram_info->axi_sram_use |= CODA7_USE_HOST_BIT_ENABLE;
+			iram_info->buf_bit_use = iram_info->buf_dbk_c_use +
+						 dbk_size / 2;
+			size -= bitram_size;
+		} else {
+			goto out;
+		}
+
+		ipacdc_size = round_up(128 * mb_width, 1024);
+		if (size >= ipacdc_size) {
+			iram_info->axi_sram_use |= CODA7_USE_HOST_IP_ENABLE;
+			iram_info->buf_ip_ac_dc_use = iram_info->buf_bit_use +
+						      bitram_size;
+			size -= ipacdc_size;
+		} else {
+			goto out;
+		}
+
+		ovl_size = round_up(80 * mb_width, 1024);
 	}
 
 out:
@@ -1300,7 +1341,12 @@ out:
 
 	if (dev->devtype->product == CODA_7541) {
 		/* TODO - Enabling these causes picture errors on CODA7541 */
-		if (ctx->inst_type == CODA_INST_ENCODER) {
+		if (ctx->inst_type == CODA_INST_DECODER) {
+			/* fw 1.4.50 */
+			iram_info->axi_sram_use &= ~(CODA7_USE_HOST_IP_ENABLE |
+						     CODA7_USE_IP_ENABLE);
+		} else {
+			/* fw 13.4.29 */
 			iram_info->axi_sram_use &= ~(CODA7_USE_HOST_IP_ENABLE |
 						     CODA7_USE_HOST_DBK_ENABLE |
 						     CODA7_USE_IP_ENABLE |
-- 
1.8.3.1

