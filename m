Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36521 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbcHBGiy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2016 02:38:54 -0400
Received: by mail-wm0-f68.google.com with SMTP id x83so29091620wma.3
        for <linux-media@vger.kernel.org>; Mon, 01 Aug 2016 23:37:54 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 1/3] media: rc: nuvoton: remove usage of b_idx in
 nvt_get_rx_ir_data
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <cf5d3a3d-55b8-d11b-7e3a-1f3add786e7d@gmail.com>
Date: Tue, 2 Aug 2016 07:44:44 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The call to nvt_get_rx_ir_data and nvt_process_rx_ir_data from
the ISR is protected with spinlock nvt->lock. Therefore it's
guaranteed that nvt->pkts is 0 when entering nvt_get_rx_ir_data
(as nvt->pkts is set to 0 at the end of nvt_process_rx_ir_data).
Having said that we can remove b_idx.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 0c69536..e4158a9 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -802,7 +802,6 @@ static void nvt_handle_rx_fifo_overrun(struct nvt_dev *nvt)
 static void nvt_get_rx_ir_data(struct nvt_dev *nvt)
 {
 	u8 fifocount, val;
-	unsigned int b_idx;
 	int i;
 
 	/* Get count of how many bytes to read from RX FIFO */
@@ -810,21 +809,13 @@ static void nvt_get_rx_ir_data(struct nvt_dev *nvt)
 
 	nvt_dbg("attempting to fetch %u bytes from hw rx fifo", fifocount);
 
-	b_idx = nvt->pkts;
-
-	/* This should never happen, but lets check anyway... */
-	if (b_idx + fifocount > RX_BUF_LEN) {
-		nvt_process_rx_ir_data(nvt);
-		b_idx = 0;
-	}
-
 	/* Read fifocount bytes from CIR Sample RX FIFO register */
 	for (i = 0; i < fifocount; i++) {
 		val = nvt_cir_reg_read(nvt, CIR_SRXFIFO);
-		nvt->buf[b_idx + i] = val;
+		nvt->buf[i] = val;
 	}
 
-	nvt->pkts += fifocount;
+	nvt->pkts = fifocount;
 	nvt_dbg("%s: pkts now %d", __func__, nvt->pkts);
 
 	nvt_process_rx_ir_data(nvt);
-- 
2.9.2

