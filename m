Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:56787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720Ab0KIVLF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Nov 2010 16:11:05 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oA9LB5CA015242
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 9 Nov 2010 16:11:05 -0500
Date: Tue, 9 Nov 2010 16:11:04 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Subject: [PATCH] nuvoton-cir: improve buffer parsing responsiveness
Message-ID: <20101109211104.GC11073@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Rather than waiting for trigger bits, the formula for which was slightly
messy, and apparently, not actually 100% complete for some remotes, just
call ir_raw_event_handle whenever we finish parsing a chunk of data from
the rx fifo, similar to mceusb, as well as whenever we see an 'end of
signal data' 0x80 packet.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---

Note: this patch should really go into 2.6.37, imo, as non-mce remotes
frequently don't behave without it.

 drivers/media/IR/nuvoton-cir.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/IR/nuvoton-cir.c b/drivers/media/IR/nuvoton-cir.c
index 301be53..acc729c 100644
--- a/drivers/media/IR/nuvoton-cir.c
+++ b/drivers/media/IR/nuvoton-cir.c
@@ -603,6 +603,8 @@ static void nvt_process_rx_ir_data(struct nvt_dev *nvt)
 	count = nvt->pkts;
 	nvt_dbg_verbose("Processing buffer of len %d", count);
 
+	init_ir_raw_event(&rawir);
+
 	for (i = 0; i < count; i++) {
 		nvt->pkts--;
 		sample = nvt->buf[i];
@@ -643,11 +645,15 @@ static void nvt_process_rx_ir_data(struct nvt_dev *nvt)
 		 * indicates end of IR signal, but new data incoming. In both
 		 * cases, it means we're ready to call ir_raw_event_handle
 		 */
-		if (sample == BUF_PULSE_BIT || ((sample != BUF_LEN_MASK) &&
-		    (sample & BUF_REPEAT_MASK) == BUF_REPEAT_BYTE))
+		if ((sample == BUF_PULSE_BIT) && nvt->pkts) {
+			nvt_dbg("Calling ir_raw_event_handle (signal end)\n");
 			ir_raw_event_handle(nvt->rdev);
+		}
 	}
 
+	nvt_dbg("Calling ir_raw_event_handle (buffer empty)\n");
+	ir_raw_event_handle(nvt->rdev);
+
 	if (nvt->pkts) {
 		nvt_dbg("Odd, pkts should be 0 now... (its %u)", nvt->pkts);
 		nvt->pkts = 0;
-- 
1.7.1

-- 
Jarod Wilson
jarod@redhat.com

