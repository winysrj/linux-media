Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4569 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbaHUUT5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 16:19:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 08/12] ivtv: fix sparse warnings
Date: Thu, 21 Aug 2014 22:19:32 +0200
Message-Id: <1408652376-39525-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408652376-39525-1-git-send-email-hverkuil@xs4all.nl>
References: <1408652376-39525-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/pci/ivtv/ivtv-irq.c:195:25: warning: incorrect type in argument 1 (different base types)
drivers/media/pci/ivtv/ivtv-irq.c:199:25: warning: incorrect type in argument 1 (different base types)
drivers/media/pci/ivtv/ivtv-irq.c:278:35: warning: restricted __le32 degrades to integer
drivers/media/pci/ivtv/ivtv-irq.c:281:51: warning: restricted __le32 degrades to integer

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/ivtv/ivtv-irq.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-irq.c b/drivers/media/pci/ivtv/ivtv-irq.c
index 19a7c9b..ab6d5d2 100644
--- a/drivers/media/pci/ivtv/ivtv-irq.c
+++ b/drivers/media/pci/ivtv/ivtv-irq.c
@@ -192,11 +192,11 @@ static int stream_enc_dma_append(struct ivtv_stream *s, u32 data[CX2341X_MBOX_MA
 		if (itv->has_cx23415 && (s->type == IVTV_ENC_STREAM_TYPE_PCM ||
 		    s->type == IVTV_DEC_STREAM_TYPE_VBI)) {
 			s->pending_backup = read_dec(offset - IVTV_DECODER_OFFSET);
-			write_dec_sync(cpu_to_le32(DMA_MAGIC_COOKIE), offset - IVTV_DECODER_OFFSET);
+			write_dec_sync(DMA_MAGIC_COOKIE, offset - IVTV_DECODER_OFFSET);
 		}
 		else {
 			s->pending_backup = read_enc(offset);
-			write_enc_sync(cpu_to_le32(DMA_MAGIC_COOKIE), offset);
+			write_enc_sync(DMA_MAGIC_COOKIE, offset);
 		}
 		s->pending_offset = offset;
 	}
@@ -275,13 +275,11 @@ static void dma_post(struct ivtv_stream *s)
 
 		if (x == 0 && ivtv_use_dma(s)) {
 			offset = s->dma_last_offset;
-			if (u32buf[offset / 4] != DMA_MAGIC_COOKIE)
+			if (le32_to_cpu(u32buf[offset / 4]) != DMA_MAGIC_COOKIE)
 			{
-				for (offset = 0; offset < 64; offset++) {
-					if (u32buf[offset] == DMA_MAGIC_COOKIE) {
+				for (offset = 0; offset < 64; offset++)
+					if (le32_to_cpu(u32buf[offset]) == DMA_MAGIC_COOKIE)
 						break;
-					}
-				}
 				offset *= 4;
 				if (offset == 256) {
 					IVTV_DEBUG_WARN("%s: Couldn't find start of buffer within the first 256 bytes\n", s->name);
-- 
2.1.0.rc1

