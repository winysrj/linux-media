Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:61206 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756294Ab2FNSA3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 14:00:29 -0400
Received: by gglu4 with SMTP id u4so1628432ggl.19
        for <linux-media@vger.kernel.org>; Thu, 14 Jun 2012 11:00:29 -0700 (PDT)
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jarod Wilson <jarod@redhat.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	Ben Hutchings <ben@decadent.org.uk>,
	Luis Henriques <luis.henriques@canonical.com>,
	linux-media@vger.kernel.org
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 5/8] nuvoton-cir: Code cleanup: remove unused variable and function
Date: Thu, 14 Jun 2012 14:58:13 -0300
Message-Id: <1339696716-14373-5-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1339696716-14373-1-git-send-email-peter.senna@gmail.com>
References: <1339696716-14373-1-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c |   37 -------------------------------------
 1 file changed, 37 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index dc8a7dd..0e8052f 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -473,39 +473,6 @@ static void nvt_enable_wake(struct nvt_dev *nvt)
 	nvt_cir_wake_reg_write(nvt, 0, CIR_WAKE_IREN);
 }
 
-/* rx carrier detect only works in learning mode, must be called w/nvt_lock */
-static u32 nvt_rx_carrier_detect(struct nvt_dev *nvt)
-{
-	u32 count, carrier, duration = 0;
-	int i;
-
-	count = nvt_cir_reg_read(nvt, CIR_FCCL) |
-		nvt_cir_reg_read(nvt, CIR_FCCH) << 8;
-
-	for (i = 0; i < nvt->pkts; i++) {
-		if (nvt->buf[i] & BUF_PULSE_BIT)
-			duration += nvt->buf[i] & BUF_LEN_MASK;
-	}
-
-	duration *= SAMPLE_PERIOD;
-
-	if (!count || !duration) {
-		nvt_pr(KERN_NOTICE, "Unable to determine carrier! (c:%u, d:%u)",
-		       count, duration);
-		return 0;
-	}
-
-	carrier = MS_TO_NS(count) / duration;
-
-	if ((carrier > MAX_CARRIER) || (carrier < MIN_CARRIER))
-		nvt_dbg("WTF? Carrier frequency out of range!");
-
-	nvt_dbg("Carrier frequency: %u (count %u, duration %u)",
-		carrier, count, duration);
-
-	return carrier;
-}
-
 /*
  * set carrier frequency
  *
@@ -618,7 +585,6 @@ static void nvt_dump_rx_buf(struct nvt_dev *nvt)
 static void nvt_process_rx_ir_data(struct nvt_dev *nvt)
 {
 	DEFINE_IR_RAW_EVENT(rawir);
-	u32 carrier;
 	u8 sample;
 	int i;
 
@@ -627,9 +593,6 @@ static void nvt_process_rx_ir_data(struct nvt_dev *nvt)
 	if (debug)
 		nvt_dump_rx_buf(nvt);
 
-	if (nvt->carrier_detect_enabled)
-		carrier = nvt_rx_carrier_detect(nvt);
-
 	nvt_dbg_verbose("Processing buffer of len %d", nvt->pkts);
 
 	init_ir_raw_event(&rawir);
-- 
1.7.10.2

