Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59121 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757010AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 32/57] [media] wl128x: don't break long lines
Date: Fri, 14 Oct 2016 17:20:20 -0300
Message-Id: <6f7a557cc2db1982c9137eedb68e78ee41fa5030.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/radio/wl128x/fmdrv_common.c | 21 +++++++--------------
 drivers/media/radio/wl128x/fmdrv_rx.c     |  6 ++----
 2 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index 642b89c66bcb..db7c1c549fcf 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -230,8 +230,7 @@ inline void dump_rx_skb_data(struct sk_buff *skb)
 	struct fm_event_msg_hdr *evt_hdr;
 
 	evt_hdr = (struct fm_event_msg_hdr *)skb->data;
-	printk(KERN_INFO ">> hdr:%02x len:%02x sts:%02x numhci:%02x "
-	    "opcode:%02x type:%s dlen:%02x", evt_hdr->hdr, evt_hdr->len,
+	printk(KERN_INFO ">> hdr:%02x len:%02x sts:%02x numhci:%02x opcode:%02x type:%s dlen:%02x", evt_hdr->hdr, evt_hdr->len,
 	    evt_hdr->status, evt_hdr->num_fm_hci_cmds, evt_hdr->op,
 	    (evt_hdr->rd_wr) ? "RD" : "WR", evt_hdr->dlen);
 
@@ -271,8 +270,7 @@ static void recv_tasklet(unsigned long arg)
 	/* Process all packets in the RX queue */
 	while ((skb = skb_dequeue(&fmdev->rx_q))) {
 		if (skb->len < sizeof(struct fm_event_msg_hdr)) {
-			fmerr("skb(%p) has only %d bytes, "
-				"at least need %zu bytes to decode\n", skb,
+			fmerr("skb(%p) has only %d bytes, at least need %zu bytes to decode\n", skb,
 				skb->len, sizeof(struct fm_event_msg_hdr));
 			kfree_skb(skb);
 			continue;
@@ -472,8 +470,7 @@ int fmc_send_cmd(struct fmdev *fmdev, u8 fm_op, u16 type, void *payload,
 
 	if (!wait_for_completion_timeout(&fmdev->maintask_comp,
 					 FM_DRV_TX_TIMEOUT)) {
-		fmerr("Timeout(%d sec),didn't get reg"
-			   "completion signal from RX tasklet\n",
+		fmerr("Timeout(%d sec),didn't get regcompletion signal from RX tasklet\n",
 			   jiffies_to_msecs(FM_DRV_TX_TIMEOUT) / 1000);
 		return -ETIMEDOUT;
 	}
@@ -523,8 +520,7 @@ static inline int check_cmdresp_status(struct fmdev *fmdev,
 
 	fm_evt_hdr = (void *)(*skb)->data;
 	if (fm_evt_hdr->status != 0) {
-		fmerr("irq: opcode %x response status is not zero "
-				"Initiating irq recovery process\n",
+		fmerr("irq: opcode %x response status is not zero Initiating irq recovery process\n",
 				fm_evt_hdr->op);
 
 		mod_timer(&fmdev->irq_info.timer, jiffies + FM_DRV_TX_TIMEOUT);
@@ -564,8 +560,7 @@ static void int_timeout_handler(unsigned long data)
 		 * reset stage index & retry count values */
 		fmirq->stage = 0;
 		fmirq->retry = 0;
-		fmerr("Recovery action failed during"
-				"irq processing, max retry reached\n");
+		fmerr("Recovery action failed duringirq processing, max retry reached\n");
 		return;
 	}
 	fm_irq_call_stage(fmdev, FM_SEND_INTMSK_CMD_IDX);
@@ -1516,14 +1511,12 @@ int fmc_prepare(struct fmdev *fmdev)
 
 		if (!wait_for_completion_timeout(&wait_for_fmdrv_reg_comp,
 						 FM_ST_REG_TIMEOUT)) {
-			fmerr("Timeout(%d sec), didn't get reg "
-					"completion signal from ST\n",
+			fmerr("Timeout(%d sec), didn't get reg completion signal from ST\n",
 					jiffies_to_msecs(FM_ST_REG_TIMEOUT) / 1000);
 			return -ETIMEDOUT;
 		}
 		if (fmdev->streg_cbdata != 0) {
-			fmerr("ST reg comp CB called with error "
-					"status %d\n", fmdev->streg_cbdata);
+			fmerr("ST reg comp CB called with error status %d\n", fmdev->streg_cbdata);
 			return -EAGAIN;
 		}
 
diff --git a/drivers/media/radio/wl128x/fmdrv_rx.c b/drivers/media/radio/wl128x/fmdrv_rx.c
index cfaeb2417fbb..84dfad13e4df 100644
--- a/drivers/media/radio/wl128x/fmdrv_rx.c
+++ b/drivers/media/radio/wl128x/fmdrv_rx.c
@@ -120,8 +120,7 @@ int fm_rx_set_freq(struct fmdev *fmdev, u32 freq)
 	curr_frq_in_khz = (fmdev->rx.region.bot_freq + ((u32)curr_frq * FM_FREQ_MUL));
 
 	if (curr_frq_in_khz != freq) {
-		pr_info("Frequency is set to (%d) but "
-			   "requested freq is (%d)\n", curr_frq_in_khz, freq);
+		pr_info("Frequency is set to (%d) but requested freq is (%d)\n", curr_frq_in_khz, freq);
 	}
 
 	/* Update local cache  */
@@ -390,8 +389,7 @@ int fm_rx_set_region(struct fmdev *fmdev, u8 region_to_set)
 		new_frq = fmdev->rx.region.top_freq;
 
 	if (new_frq) {
-		fmdbg("Current freq is not within band limit boundary,"
-				"switching to %d KHz\n", new_frq);
+		fmdbg("Current freq is not within band limit boundary,switching to %d KHz\n", new_frq);
 		 /* Current RX frequency is not in range. So, update it */
 		ret = fm_rx_set_freq(fmdev, new_frq);
 	}
-- 
2.7.4


