Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:50469 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964963AbaLMLxf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Dec 2014 06:53:35 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH 03/10] ivtv: fix sparse warning
Date: Sat, 13 Dec 2014 12:52:53 +0100
Message-Id: <1418471580-26510-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1418471580-26510-1-git-send-email-hverkuil@xs4all.nl>
References: <1418471580-26510-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Fix this warning:

drivers/media/pci/ivtv/ivtv-irq.c:418:9: warning: context imbalance in 'ivtv_dma_stream_dec_prepare' - different lock contexts for basic block

sparse didn't quite understand the locking scheme, so rewrite it to keep
sparse happy.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/pci/ivtv/ivtv-irq.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-irq.c b/drivers/media/pci/ivtv/ivtv-irq.c
index ab6d5d2..e7d7017 100644
--- a/drivers/media/pci/ivtv/ivtv-irq.c
+++ b/drivers/media/pci/ivtv/ivtv-irq.c
@@ -357,7 +357,6 @@ void ivtv_dma_stream_dec_prepare(struct ivtv_stream *s, u32 offset, int lock)
 	u32 uv_offset = offset + IVTV_YUV_BUFFER_UV_OFFSET;
 	int y_done = 0;
 	int bytes_written = 0;
-	unsigned long flags = 0;
 	int idx = 0;
 
 	IVTV_DEBUG_HI_DMA("DEC PREPARE DMA %s: %08x %08x\n", s->name, s->q_predma.bytesused, offset);
@@ -407,16 +406,21 @@ void ivtv_dma_stream_dec_prepare(struct ivtv_stream *s, u32 offset, int lock)
 
 	/* Sync Hardware SG List of buffers */
 	ivtv_stream_sync_for_device(s);
-	if (lock)
+	if (lock) {
+		unsigned long flags = 0;
+
 		spin_lock_irqsave(&itv->dma_reg_lock, flags);
-	if (!test_bit(IVTV_F_I_DMA, &itv->i_flags)) {
-		ivtv_dma_dec_start(s);
-	}
-	else {
-		set_bit(IVTV_F_S_DMA_PENDING, &s->s_flags);
-	}
-	if (lock)
+		if (!test_bit(IVTV_F_I_DMA, &itv->i_flags))
+			ivtv_dma_dec_start(s);
+		else
+			set_bit(IVTV_F_S_DMA_PENDING, &s->s_flags);
 		spin_unlock_irqrestore(&itv->dma_reg_lock, flags);
+	} else {
+		if (!test_bit(IVTV_F_I_DMA, &itv->i_flags))
+			ivtv_dma_dec_start(s);
+		else
+			set_bit(IVTV_F_S_DMA_PENDING, &s->s_flags);
+	}
 }
 
 static void ivtv_dma_enc_start_xfer(struct ivtv_stream *s)
-- 
2.1.3

