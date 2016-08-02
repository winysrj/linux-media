Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33342 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbcHBGAI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2016 02:00:08 -0400
Received: by mail-wm0-f65.google.com with SMTP id o80so29000663wme.0
        for <linux-media@vger.kernel.org>; Mon, 01 Aug 2016 23:00:07 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 2/3] media: rc: nuvoton: remove unneeded call to
 ir_raw_event_handle
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <5f099e64-0e93-dd76-70aa-023f8538fa38@gmail.com>
Date: Tue, 2 Aug 2016 07:45:30 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ir_raw_event_handle is called anyway after the hw fifo content stored
in nvt->buf[] has been written to the kfifo. There is not really a
benefit in the potential additional call to ir_raw_event_handle
whilst nvt->buf[] is being processed.
Getting rid of this additional call allows to simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index e4158a9..fc462f6 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -769,21 +769,11 @@ static void nvt_process_rx_ir_data(struct nvt_dev *nvt)
 			rawir.pulse ? "pulse" : "space", rawir.duration);
 
 		ir_raw_event_store_with_filter(nvt->rdev, &rawir);
-
-		/*
-		 * BUF_PULSE_BIT indicates end of IR data, BUF_REPEAT_BYTE
-		 * indicates end of IR signal, but new data incoming. In both
-		 * cases, it means we're ready to call ir_raw_event_handle
-		 */
-		if ((sample == BUF_PULSE_BIT) && (i + 1 < nvt->pkts)) {
-			nvt_dbg("Calling ir_raw_event_handle (signal end)\n");
-			ir_raw_event_handle(nvt->rdev);
-		}
 	}
 
 	nvt->pkts = 0;
 
-	nvt_dbg("Calling ir_raw_event_handle (buffer empty)\n");
+	nvt_dbg("Calling ir_raw_event_handle\n");
 	ir_raw_event_handle(nvt->rdev);
 
 	nvt_dbg_verbose("%s done", __func__);
-- 
2.9.2

