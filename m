Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1420 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbaHTW7r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 18:59:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 20/29] wl128x: fix sparse warnings
Date: Thu, 21 Aug 2014 00:59:19 +0200
Message-Id: <1408575568-20562-21-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
References: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/radio/wl128x/fmdrv_common.c:598:32: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_common.c:598:32: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_common.c:598:32: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_common.c:598:32: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_common.c:767:38: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_common.c:767:38: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_common.c:767:38: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_common.c:767:38: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_common.c:992:21: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_common.c:992:21: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_common.c:992:21: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_common.c:992:21: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_common.c:443:41: warning: incorrect type in assignment (different base types)
drivers/media/radio/wl128x/fmdrv_common.c:1359:17: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_common.c:1359:17: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_common.c:1359:17: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_common.c:1359:17: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_common.c:1359:39: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_common.c:1359:39: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_common.c:1359:39: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_common.c:1359:39: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_common.c:1368:25: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_common.c:1368:25: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_common.c:1368:25: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_common.c:1368:25: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_common.c:1368:47: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_common.c:1368:47: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_common.c:1368:47: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_common.c:1368:47: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_rx.c:119:20: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_rx.c:119:20: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_rx.c:119:20: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_rx.c:119:20: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_rx.c:192:20: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_rx.c:192:20: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_rx.c:192:20: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_rx.c:192:20: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_rx.c:288:28: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_rx.c:288:28: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_rx.c:288:28: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_rx.c:288:28: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_rx.c:534:20: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_rx.c:534:20: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_rx.c:534:20: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_rx.c:534:20: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_rx.c:625:17: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_rx.c:625:17: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_rx.c:625:17: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_rx.c:625:17: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_tx.c:377:20: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_tx.c:377:20: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_tx.c:377:20: warning: cast to restricted __be16
drivers/media/radio/wl128x/fmdrv_tx.c:377:20: warning: cast to restricted __be16

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/wl128x/fmdrv_common.c | 11 ++++++-----
 drivers/media/radio/wl128x/fmdrv_rx.c     | 10 +++++-----
 drivers/media/radio/wl128x/fmdrv_tx.c     |  2 +-
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index 4b2e9e8..6f28f6e 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -440,7 +440,7 @@ static int fm_send_cmd(struct fmdev *fmdev, u8 fm_op, u16 type,	void *payload,
 		 * command with u16 payload - convert to be16
 		 */
 		if (payload != NULL)
-			*(u16 *)payload = cpu_to_be16(*(u16 *)payload);
+			*(__be16 *)payload = cpu_to_be16(*(u16 *)payload);
 
 	} else if (payload != NULL) {
 		fm_cb(skb)->fm_op = *((u8 *)payload + 2);
@@ -595,7 +595,7 @@ static void fm_irq_handle_flag_getcmd_resp(struct fmdev *fmdev)
 	skb_pull(skb, sizeof(struct fm_event_msg_hdr));
 	memcpy(&fmdev->irq_info.flag, skb->data, fm_evt_hdr->dlen);
 
-	fmdev->irq_info.flag = be16_to_cpu(fmdev->irq_info.flag);
+	fmdev->irq_info.flag = be16_to_cpu((__force __be16)fmdev->irq_info.flag);
 	fmdbg("irq: flag register(0x%x)\n", fmdev->irq_info.flag);
 
 	/* Continue next function in interrupt handler table */
@@ -764,7 +764,7 @@ static void fm_irq_handle_rdsdata_getcmd_resp(struct fmdev *fmdev)
 			 * Extract PI code and store in local cache.
 			 * We need this during AF switch processing.
 			 */
-			cur_picode = be16_to_cpu(rds_fmt.data.groupgeneral.pidata);
+			cur_picode = be16_to_cpu((__force __be16)rds_fmt.data.groupgeneral.pidata);
 			if (fmdev->rx.stat_info.picode != cur_picode)
 				fmdev->rx.stat_info.picode = cur_picode;
 
@@ -989,7 +989,7 @@ static void fm_irq_afjump_rd_freq_resp(struct fmdev *fmdev)
 	/* Skip header info and copy only response data */
 	skb_pull(skb, sizeof(struct fm_event_msg_hdr));
 	memcpy(&read_freq, skb->data, sizeof(read_freq));
-	read_freq = be16_to_cpu(read_freq);
+	read_freq = be16_to_cpu((__force __be16)read_freq);
 	curr_freq = fmdev->rx.region.bot_freq + ((u32)read_freq * FM_FREQ_MUL);
 
 	jumped_freq = fmdev->rx.stat_info.af_cache[fmdev->rx.afjump_idx];
@@ -1317,7 +1317,8 @@ static int load_default_rx_configuration(struct fmdev *fmdev)
 /* Does FM power on sequence */
 static int fm_power_up(struct fmdev *fmdev, u8 mode)
 {
-	u16 payload, asic_id, asic_ver;
+	u16 payload;
+	__be16 asic_id, asic_ver;
 	int resp_len, ret;
 	u8 fw_name[50];
 
diff --git a/drivers/media/radio/wl128x/fmdrv_rx.c b/drivers/media/radio/wl128x/fmdrv_rx.c
index ebf09a3..09632cb 100644
--- a/drivers/media/radio/wl128x/fmdrv_rx.c
+++ b/drivers/media/radio/wl128x/fmdrv_rx.c
@@ -116,7 +116,7 @@ int fm_rx_set_freq(struct fmdev *fmdev, u32 freq)
 	if (ret < 0)
 		goto exit;
 
-	curr_frq = be16_to_cpu(curr_frq);
+	curr_frq = be16_to_cpu((__force __be16)curr_frq);
 	curr_frq_in_khz = (fmdev->rx.region.bot_freq + ((u32)curr_frq * FM_FREQ_MUL));
 
 	if (curr_frq_in_khz != freq) {
@@ -189,7 +189,7 @@ int fm_rx_seek(struct fmdev *fmdev, u32 seek_upward,
 	if (ret < 0)
 		return ret;
 
-	curr_frq = be16_to_cpu(curr_frq);
+	curr_frq = be16_to_cpu((__force __be16)curr_frq);
 	last_frq = (fmdev->rx.region.top_freq - fmdev->rx.region.bot_freq) / FM_FREQ_MUL;
 
 	/* Check the offset in order to be aligned to the channel spacing*/
@@ -285,7 +285,7 @@ again:
 		if (ret < 0)
 			return ret;
 
-		curr_frq = be16_to_cpu(curr_frq);
+		curr_frq = be16_to_cpu((__force __be16)curr_frq);
 		fmdev->rx.freq = (fmdev->rx.region.bot_freq +
 				((u32)curr_frq * FM_FREQ_MUL));
 
@@ -517,7 +517,7 @@ int fm_rx_set_rfdepend_softmute(struct fmdev *fmdev, u8 rfdepend_mute)
 /* Returns the signal strength level of current channel */
 int fm_rx_get_rssi_level(struct fmdev *fmdev, u16 *rssilvl)
 {
-	u16 curr_rssi_lel;
+	__be16 curr_rssi_lel;
 	u32 resp_len;
 	int ret;
 
@@ -608,7 +608,7 @@ int fm_rx_set_stereo_mono(struct fmdev *fmdev, u16 mode)
 /* Gets current RX stereo/mono mode */
 int fm_rx_get_stereo_mono(struct fmdev *fmdev, u16 *mode)
 {
-	u16 curr_mode;
+	__be16 curr_mode;
 	u32 resp_len;
 	int ret;
 
diff --git a/drivers/media/radio/wl128x/fmdrv_tx.c b/drivers/media/radio/wl128x/fmdrv_tx.c
index 6ea33e0..839970b 100644
--- a/drivers/media/radio/wl128x/fmdrv_tx.c
+++ b/drivers/media/radio/wl128x/fmdrv_tx.c
@@ -374,7 +374,7 @@ int fm_tx_get_tune_cap_val(struct fmdev *fmdev)
 	if (ret < 0)
 		return ret;
 
-	curr_val = be16_to_cpu(curr_val);
+	curr_val = be16_to_cpu((__force __be16)curr_val);
 
 	return curr_val;
 }
-- 
2.1.0.rc1

