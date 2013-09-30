Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46392 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429Ab3I3NfA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 09:35:00 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 04/10] [media] coda: fix FMO value setting for CodaDx6
Date: Mon, 30 Sep 2013 15:34:47 +0200
Message-Id: <1380548093-22313-5-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1380548093-22313-1-git-send-email-p.zabel@pengutronix.de>
References: <1380548093-22313-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The register is only written on CodaDx6, so the temporary variable
to be written only needs to be initialized on CodaDx6. Also, drop
two no-op lines.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
 - Removed no-op lines leaving FMOPARAM fields of CMD_ENC_SEQ_FMO
   at zero values on CodaDx6.
---
 drivers/media/platform/coda.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 53539c1..5fe947c 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -2074,10 +2074,8 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	coda_setup_iram(ctx);
 
 	if (dst_fourcc == V4L2_PIX_FMT_H264) {
-		value  = (FMO_SLICE_SAVE_BUF_SIZE << 7);
-		value |= (0 & CODA_FMOPARAM_TYPE_MASK) << CODA_FMOPARAM_TYPE_OFFSET;
-		value |=  0 & CODA_FMOPARAM_SLICENUM_MASK;
 		if (dev->devtype->product == CODA_DX6) {
+			value = FMO_SLICE_SAVE_BUF_SIZE << 7;
 			coda_write(dev, value, CODADX6_CMD_ENC_SEQ_FMO);
 		} else {
 			coda_write(dev, ctx->iram_info.search_ram_paddr,
-- 
1.8.4.rc3

