Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:36522 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751372AbdGRKYS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 06:24:18 -0400
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: linux-i2c@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-input@vger.kernel.org, linux-iio@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH v3 3/4] i2c: sh_mobile: use helper to decide if DMA is useful
Date: Tue, 18 Jul 2017 12:23:38 +0200
Message-Id: <20170718102339.28726-4-wsa+renesas@sang-engineering.com>
In-Reply-To: <20170718102339.28726-1-wsa+renesas@sang-engineering.com>
References: <20170718102339.28726-1-wsa+renesas@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This ensures that we fall back to PIO if the buffer is too small for DMA
being useful. Otherwise, we use DMA. A bounce buffer might be applied if
the original message buffer is not DMA safe

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
 drivers/i2c/busses/i2c-sh_mobile.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-sh_mobile.c b/drivers/i2c/busses/i2c-sh_mobile.c
index 2e097d97d258bc..19f45bcd9b35ca 100644
--- a/drivers/i2c/busses/i2c-sh_mobile.c
+++ b/drivers/i2c/busses/i2c-sh_mobile.c
@@ -145,6 +145,7 @@ struct sh_mobile_i2c_data {
 	struct dma_chan *dma_rx;
 	struct scatterlist sg;
 	enum dma_data_direction dma_direction;
+	u8 *bounce_buf;
 };
 
 struct sh_mobile_dt_config {
@@ -548,6 +549,8 @@ static void sh_mobile_i2c_dma_callback(void *data)
 	pd->pos = pd->msg->len;
 	pd->stop_after_dma = true;
 
+	i2c_release_dma_bounce_buf(pd->msg, pd->bounce_buf);
+
 	iic_set_clr(pd, ICIC, 0, ICIC_TDMAE | ICIC_RDMAE);
 }
 
@@ -595,6 +598,7 @@ static void sh_mobile_i2c_xfer_dma(struct sh_mobile_i2c_data *pd)
 	struct dma_async_tx_descriptor *txdesc;
 	dma_addr_t dma_addr;
 	dma_cookie_t cookie;
+	u8 *dma_buf = pd->bounce_buf ?: pd->msg->buf;
 
 	if (PTR_ERR(chan) == -EPROBE_DEFER) {
 		if (read)
@@ -608,7 +612,7 @@ static void sh_mobile_i2c_xfer_dma(struct sh_mobile_i2c_data *pd)
 	if (IS_ERR(chan))
 		return;
 
-	dma_addr = dma_map_single(chan->device->dev, pd->msg->buf, pd->msg->len, dir);
+	dma_addr = dma_map_single(chan->device->dev, dma_buf, pd->msg->len, dir);
 	if (dma_mapping_error(chan->device->dev, dma_addr)) {
 		dev_dbg(pd->dev, "dma map failed, using PIO\n");
 		return;
@@ -665,7 +669,7 @@ static int start_ch(struct sh_mobile_i2c_data *pd, struct i2c_msg *usr_msg,
 	pd->pos = -1;
 	pd->sr = 0;
 
-	if (pd->msg->len > 8)
+	if (i2c_check_msg_for_dma(pd->msg, 8, &pd->bounce_buf) == 0)
 		sh_mobile_i2c_xfer_dma(pd);
 
 	/* Enable all interrupts to begin with */
-- 
2.11.0
