Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33716 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096AbcHBF6z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2016 01:58:55 -0400
Received: by mail-wm0-f65.google.com with SMTP id o80so28995848wme.0
        for <linux-media@vger.kernel.org>; Mon, 01 Aug 2016 22:58:00 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 3/3] media: rc: nuvoton: simplify nvt_get_rx_ir_data a little
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <64fc324e-631a-84cc-1e65-981be88eed42@gmail.com>
Date: Tue, 2 Aug 2016 07:45:51 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify the code a little.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index fc462f6..04fedaa 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -791,7 +791,7 @@ static void nvt_handle_rx_fifo_overrun(struct nvt_dev *nvt)
 /* copy data from hardware rx fifo into driver buffer */
 static void nvt_get_rx_ir_data(struct nvt_dev *nvt)
 {
-	u8 fifocount, val;
+	u8 fifocount;
 	int i;
 
 	/* Get count of how many bytes to read from RX FIFO */
@@ -800,10 +800,8 @@ static void nvt_get_rx_ir_data(struct nvt_dev *nvt)
 	nvt_dbg("attempting to fetch %u bytes from hw rx fifo", fifocount);
 
 	/* Read fifocount bytes from CIR Sample RX FIFO register */
-	for (i = 0; i < fifocount; i++) {
-		val = nvt_cir_reg_read(nvt, CIR_SRXFIFO);
-		nvt->buf[i] = val;
-	}
+	for (i = 0; i < fifocount; i++)
+		nvt->buf[i] = nvt_cir_reg_read(nvt, CIR_SRXFIFO);
 
 	nvt->pkts = fifocount;
 	nvt_dbg("%s: pkts now %d", __func__, nvt->pkts);
-- 
2.9.2

