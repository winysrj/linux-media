Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4100 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab3JDOCJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Oct 2013 10:02:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 13/14] cx25821: fix sparse warnings
Date: Fri,  4 Oct 2013 16:01:51 +0200
Message-Id: <1380895312-30863-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
References: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/pci/cx25821/cx25821-cards.c:49:20: warning: symbol 'cx25821_bcount' was not declared. Should it be static?
drivers/media/pci/cx25821/cx25821-video-upstream.c:162:33: warning: incorrect type in assignment (different base types)
drivers/media/pci/cx25821/cx25821-video-upstream.c:163:33: warning: incorrect type in assignment (different base types)
drivers/media/pci/cx25821/cx25821-video-upstream.c:164:33: warning: incorrect type in assignment (different base types)
drivers/media/pci/cx25821/cx25821-video-upstream.c:165:33: warning: incorrect type in assignment (different base types)
drivers/media/pci/cx25821/cx25821-medusa-video.h:43:16: warning: symbol '_num_decoders' was not declared. Should it be static?
drivers/media/pci/cx25821/cx25821-medusa-video.h:44:16: warning: symbol '_num_cameras' was not declared. Should it be static?
drivers/media/pci/cx25821/cx25821-medusa-video.h:46:14: warning: symbol '_video_standard' was not declared. Should it be static?
drivers/media/pci/cx25821/cx25821-medusa-video.h:47:5: warning: symbol '_display_field_cnt' was not declared. Should it be static?

After analyzing the last four warnings carefully it became clear that these
variables were really completely unused. As a result of that the call to
medusa_set_decoderduration() is now dubious since the duration is always 0.

Without documentation, however, I can't tell what the right value is.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-cards.c          |  2 --
 drivers/media/pci/cx25821/cx25821-medusa-video.c   | 18 ++++++++++--------
 drivers/media/pci/cx25821/cx25821-medusa-video.h   |  6 ------
 drivers/media/pci/cx25821/cx25821-video-upstream.c |  8 ++++----
 4 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-cards.c b/drivers/media/pci/cx25821/cx25821-cards.c
index 3b409fe..f2ebc98 100644
--- a/drivers/media/pci/cx25821/cx25821-cards.c
+++ b/drivers/media/pci/cx25821/cx25821-cards.c
@@ -45,5 +45,3 @@ struct cx25821_board cx25821_boards[] = {
 	},
 
 };
-
-const unsigned int cx25821_bcount = ARRAY_SIZE(cx25821_boards);
diff --git a/drivers/media/pci/cx25821/cx25821-medusa-video.c b/drivers/media/pci/cx25821/cx25821-medusa-video.c
index 22fa044..43bdfa4 100644
--- a/drivers/media/pci/cx25821/cx25821-medusa-video.c
+++ b/drivers/media/pci/cx25821/cx25821-medusa-video.c
@@ -438,7 +438,7 @@ void medusa_set_resolution(struct cx25821_dev *dev, int width,
 		decoder_count = decoder_select + 1;
 	} else {
 		decoder = 0;
-		decoder_count = _num_decoders;
+		decoder_count = dev->_max_num_decoders;
 	}
 
 	switch (width) {
@@ -506,8 +506,6 @@ static void medusa_set_decoderduration(struct cx25821_dev *dev, int decoder,
 		break;
 	}
 
-	_display_field_cnt[decoder] = duration;
-
 	/* update hardware */
 	fld_cnt = cx25821_i2c_read(&dev->i2c_bus[0], disp_cnt_reg, &tmp);
 
@@ -667,8 +665,6 @@ int medusa_video_init(struct cx25821_dev *dev)
 	int ret_val = 0;
 	int i = 0;
 
-	_num_decoders = dev->_max_num_decoders;
-
 	/* disable Auto source selection on all video decoders */
 	value = cx25821_i2c_read(&dev->i2c_bus[0], MON_A_CTRL, &tmp);
 	value &= 0xFFFFF0FF;
@@ -685,8 +681,14 @@ int medusa_video_init(struct cx25821_dev *dev)
 	if (ret_val < 0)
 		goto error;
 
-	for (i = 0; i < _num_decoders; i++)
-		medusa_set_decoderduration(dev, i, _display_field_cnt[i]);
+	/*
+	 * FIXME: due to a coding bug the duration was always 0. It's
+	 * likely that it really should be something else, but due to the
+	 * lack of documentation I have no idea what it should be. For
+	 * now just fill in 0 as the duration.
+	 */
+	for (i = 0; i < dev->_max_num_decoders; i++)
+		medusa_set_decoderduration(dev, i, 0);
 
 	/* Select monitor as DENC A input, power up the DAC */
 	value = cx25821_i2c_read(&dev->i2c_bus[0], DENC_AB_CTRL, &tmp);
@@ -717,7 +719,7 @@ int medusa_video_init(struct cx25821_dev *dev)
 	/* Turn on all of the data out and control output pins. */
 	value = cx25821_i2c_read(&dev->i2c_bus[0], PIN_OE_CTRL, &tmp);
 	value &= 0xFEF0FE00;
-	if (_num_decoders == MAX_DECODERS) {
+	if (dev->_max_num_decoders == MAX_DECODERS) {
 		/*
 		 * Note: The octal board does not support control pins(bit16-19)
 		 * These bits are ignored in the octal board.
diff --git a/drivers/media/pci/cx25821/cx25821-medusa-video.h b/drivers/media/pci/cx25821/cx25821-medusa-video.h
index 6175e09..8bf602f 100644
--- a/drivers/media/pci/cx25821/cx25821-medusa-video.h
+++ b/drivers/media/pci/cx25821/cx25821-medusa-video.h
@@ -40,10 +40,4 @@
 #define CONTRAST_DEFAULT                5000
 #define HUE_DEFAULT                     5000
 
-unsigned short _num_decoders;
-unsigned short _num_cameras;
-
-unsigned int _video_standard;
-int _display_field_cnt[MAX_DECODERS];
-
 #endif
diff --git a/drivers/media/pci/cx25821/cx25821-video-upstream.c b/drivers/media/pci/cx25821/cx25821-video-upstream.c
index 88ffef4..1f43be0 100644
--- a/drivers/media/pci/cx25821/cx25821-video-upstream.c
+++ b/drivers/media/pci/cx25821/cx25821-video-upstream.c
@@ -159,10 +159,10 @@ static __le32 *cx25821_risc_field_upstream(struct cx25821_channel *chan, __le32
 		 * For the upstream video channel, the risc engine will enable
 		 * the FIFO. */
 		if (fifo_enable && line == 3) {
-			*(rp++) = RISC_WRITECR;
-			*(rp++) = sram_ch->dma_ctl;
-			*(rp++) = FLD_VID_FIFO_EN;
-			*(rp++) = 0x00000001;
+			*(rp++) = cpu_to_le32(RISC_WRITECR);
+			*(rp++) = cpu_to_le32(sram_ch->dma_ctl);
+			*(rp++) = cpu_to_le32(FLD_VID_FIFO_EN);
+			*(rp++) = cpu_to_le32(0x00000001);
 		}
 	}
 
-- 
1.8.3.2

