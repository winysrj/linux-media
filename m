Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44137 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab0I0NBz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Sep 2010 09:01:55 -0400
Received: by bwz11 with SMTP id 11so3241947bwz.19
        for <linux-media@vger.kernel.org>; Mon, 27 Sep 2010 06:01:54 -0700 (PDT)
From: Ruslan Pisarev <ruslanpisarev@gmail.com>
To: linux-media@vger.kernel.org
Cc: ruslan@rpisarev.org.ua
Subject: [PATCH 02/13] Staging: cx25821: fix braces and space coding style issue in cx25821-audio-upstream.c This is a patch to the cx25821-audio-upstream.c file that fixed up a brace and space Errors found by the checkpatch.pl tools.
Date: Mon, 27 Sep 2010 16:01:36 +0300
Message-Id: <1285592496-32121-1-git-send-email-ruslan@rpisarev.org.ua>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Ruslan Pisarev <ruslan@rpisarev.org.ua>
---
 drivers/staging/cx25821/cx25821-audio-upstream.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.c b/drivers/staging/cx25821/cx25821-audio-upstream.c
index cdff49f..6f32006 100644
--- a/drivers/staging/cx25821/cx25821-audio-upstream.c
+++ b/drivers/staging/cx25821/cx25821-audio-upstream.c
@@ -40,8 +40,8 @@ MODULE_AUTHOR("Hiep Huynh <hiep.huynh@conexant.com>");
 MODULE_LICENSE("GPL");
 
 static int _intr_msk =
-    FLD_AUD_SRC_RISCI1 | FLD_AUD_SRC_OF | FLD_AUD_SRC_SYNC |
-    FLD_AUD_SRC_OPC_ERR;
+	FLD_AUD_SRC_RISCI1 | FLD_AUD_SRC_OF | FLD_AUD_SRC_SYNC |
+	FLD_AUD_SRC_OPC_ERR;
 
 int cx25821_sram_channel_setup_upstream_audio(struct cx25821_dev *dev,
 					      struct sram_channel *ch,
@@ -506,7 +506,7 @@ int cx25821_audio_upstream_irq(struct cx25821_dev *dev, int chan_num,
 {
 	int i = 0;
 	u32 int_msk_tmp;
-       struct sram_channel *channel = dev->channels[chan_num].sram_channels;
+	struct sram_channel *channel = dev->channels[chan_num].sram_channels;
 	dma_addr_t risc_phys_jump_addr;
 	__le32 *rp;
 
@@ -608,7 +608,7 @@ static irqreturn_t cx25821_upstream_irq_audio(int irq, void *dev_id)
 	if (!dev)
 		return -1;
 
-       sram_ch = dev->channels[dev->_audio_upstream_channel_select].
+	sram_ch = dev->channels[dev->_audio_upstream_channel_select].
 				       sram_channels;
 
 	msk_stat = cx_read(sram_ch->int_mstat);
@@ -733,7 +733,7 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 	}
 
 	dev->_audio_upstream_channel_select = channel_select;
-       sram_ch = dev->channels[channel_select].sram_channels;
+	sram_ch = dev->channels[channel_select].sram_channels;
 
 	/* Work queue */
 	INIT_WORK(&dev->_audio_work_entry, cx25821_audioups_handler);
@@ -764,9 +764,8 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 		       str_length + 1);
 
 		/* Default if filename is empty string */
-		if (strcmp(dev->input_audiofilename, "") == 0) {
+		if (strcmp(dev->input_audiofilename, "") == 0)
 			dev->_audiofilename = "/root/audioGOOD.wav";
-		}
 	} else {
 		str_length = strlen(_defaultAudioName);
 		dev->_audiofilename = kmalloc(str_length + 1, GFP_KERNEL);
-- 
1.7.0.4

