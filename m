Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51554 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934882AbcJRUqW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:22 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH v2 30/58] wl128x: don't break long lines
Date: Tue, 18 Oct 2016 18:45:42 -0200
Message-Id: <4c8fd5d96bd55faf272fde5c671c85d42e7a5f85.1476822925.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols restrictions, and latter due to checkpatch
warnings, several strings were broken into multiple lines. This
is not considered a good practice anymore, as it makes harder
to grep for strings at the source code.

As we're right now fixing other drivers due to KERN_CONT, we need
to be able to identify what printk strings don't end with a "\n".
It is a way easier to detect those if we don't break long lines.

So, join those continuation lines.

The patch was generated via the script below, and manually
adjusted if needed.

</script>
use Text::Tabs;
while (<>) {
	if ($next ne "") {
		$c=$_;
		if ($c =~ /^\s+\"(.*)/) {
			$c2=$1;
			$next =~ s/\"\n$//;
			$n = expand($next);
			$funpos = index($n, '(');
			$pos = index($c2, '",');
			if ($funpos && $pos > 0) {
				$s1 = substr $c2, 0, $pos + 2;
				$s2 = ' ' x ($funpos + 1) . substr $c2, $pos + 2;
				$s2 =~ s/^\s+//;

				$s2 = ' ' x ($funpos + 1) . $s2 if ($s2 ne "");

				print unexpand("$next$s1\n");
				print unexpand("$s2\n") if ($s2 ne "");
			} else {
				print "$next$c2\n";
			}
			$next="";
			next;
		} else {
			print $next;
		}
		$next="";
	} else {
		if (m/\"$/) {
			if (!m/\\n\"$/) {
				$next=$_;
				next;
			}
		}
	}
	print $_;
}
</script>

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/radio/wl128x/fmdrv_common.c | 30 +++++++++++++-----------------
 drivers/media/radio/wl128x/fmdrv_rx.c     |  8 ++++----
 2 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index 642b89c66bcb..6f254e80ffa6 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -230,10 +230,10 @@ inline void dump_rx_skb_data(struct sk_buff *skb)
 	struct fm_event_msg_hdr *evt_hdr;
 
 	evt_hdr = (struct fm_event_msg_hdr *)skb->data;
-	printk(KERN_INFO ">> hdr:%02x len:%02x sts:%02x numhci:%02x "
-	    "opcode:%02x type:%s dlen:%02x", evt_hdr->hdr, evt_hdr->len,
-	    evt_hdr->status, evt_hdr->num_fm_hci_cmds, evt_hdr->op,
-	    (evt_hdr->rd_wr) ? "RD" : "WR", evt_hdr->dlen);
+	printk(KERN_INFO ">> hdr:%02x len:%02x sts:%02x numhci:%02x opcode:%02x type:%s dlen:%02x",
+	       evt_hdr->hdr, evt_hdr->len,
+	       evt_hdr->status, evt_hdr->num_fm_hci_cmds, evt_hdr->op,
+	       (evt_hdr->rd_wr) ? "RD" : "WR", evt_hdr->dlen);
 
 	len_org = skb->len - FM_EVT_MSG_HDR_SIZE;
 	if (len_org > 0) {
@@ -271,9 +271,9 @@ static void recv_tasklet(unsigned long arg)
 	/* Process all packets in the RX queue */
 	while ((skb = skb_dequeue(&fmdev->rx_q))) {
 		if (skb->len < sizeof(struct fm_event_msg_hdr)) {
-			fmerr("skb(%p) has only %d bytes, "
-				"at least need %zu bytes to decode\n", skb,
-				skb->len, sizeof(struct fm_event_msg_hdr));
+			fmerr("skb(%p) has only %d bytes, at least need %zu bytes to decode\n",
+			      skb,
+			      skb->len, sizeof(struct fm_event_msg_hdr));
 			kfree_skb(skb);
 			continue;
 		}
@@ -472,8 +472,7 @@ int fmc_send_cmd(struct fmdev *fmdev, u8 fm_op, u16 type, void *payload,
 
 	if (!wait_for_completion_timeout(&fmdev->maintask_comp,
 					 FM_DRV_TX_TIMEOUT)) {
-		fmerr("Timeout(%d sec),didn't get reg"
-			   "completion signal from RX tasklet\n",
+		fmerr("Timeout(%d sec),didn't get regcompletion signal from RX tasklet\n",
 			   jiffies_to_msecs(FM_DRV_TX_TIMEOUT) / 1000);
 		return -ETIMEDOUT;
 	}
@@ -523,8 +522,7 @@ static inline int check_cmdresp_status(struct fmdev *fmdev,
 
 	fm_evt_hdr = (void *)(*skb)->data;
 	if (fm_evt_hdr->status != 0) {
-		fmerr("irq: opcode %x response status is not zero "
-				"Initiating irq recovery process\n",
+		fmerr("irq: opcode %x response status is not zero Initiating irq recovery process\n",
 				fm_evt_hdr->op);
 
 		mod_timer(&fmdev->irq_info.timer, jiffies + FM_DRV_TX_TIMEOUT);
@@ -564,8 +562,7 @@ static void int_timeout_handler(unsigned long data)
 		 * reset stage index & retry count values */
 		fmirq->stage = 0;
 		fmirq->retry = 0;
-		fmerr("Recovery action failed during"
-				"irq processing, max retry reached\n");
+		fmerr("Recovery action failed duringirq processing, max retry reached\n");
 		return;
 	}
 	fm_irq_call_stage(fmdev, FM_SEND_INTMSK_CMD_IDX);
@@ -1516,14 +1513,13 @@ int fmc_prepare(struct fmdev *fmdev)
 
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
+			fmerr("ST reg comp CB called with error status %d\n",
+			      fmdev->streg_cbdata);
 			return -EAGAIN;
 		}
 
diff --git a/drivers/media/radio/wl128x/fmdrv_rx.c b/drivers/media/radio/wl128x/fmdrv_rx.c
index cfaeb2417fbb..e7455f82fadc 100644
--- a/drivers/media/radio/wl128x/fmdrv_rx.c
+++ b/drivers/media/radio/wl128x/fmdrv_rx.c
@@ -120,8 +120,8 @@ int fm_rx_set_freq(struct fmdev *fmdev, u32 freq)
 	curr_frq_in_khz = (fmdev->rx.region.bot_freq + ((u32)curr_frq * FM_FREQ_MUL));
 
 	if (curr_frq_in_khz != freq) {
-		pr_info("Frequency is set to (%d) but "
-			   "requested freq is (%d)\n", curr_frq_in_khz, freq);
+		pr_info("Frequency is set to (%d) but requested freq is (%d)\n",
+			curr_frq_in_khz, freq);
 	}
 
 	/* Update local cache  */
@@ -390,8 +390,8 @@ int fm_rx_set_region(struct fmdev *fmdev, u8 region_to_set)
 		new_frq = fmdev->rx.region.top_freq;
 
 	if (new_frq) {
-		fmdbg("Current freq is not within band limit boundary,"
-				"switching to %d KHz\n", new_frq);
+		fmdbg("Current freq is not within band limit boundary,switching to %d KHz\n",
+		      new_frq);
 		 /* Current RX frequency is not in range. So, update it */
 		ret = fm_rx_set_freq(fmdev, new_frq);
 	}
-- 
2.7.4


