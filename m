Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:50112 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbaESMdP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 May 2014 08:33:15 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, posciak@chromium.org, avnd.kiran@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH 01/10] [media] s5p-mfc: Copy timestamps only when a frame is produced.
Date: Mon, 19 May 2014 18:02:57 +0530
Message-Id: <1400502786-4826-2-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1400502786-4826-1-git-send-email-arun.kk@samsung.com>
References: <1400502786-4826-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pawel Osciak <posciak@chromium.org>

Timestamps for destination buffers are assigned by copying them from
corresponding source buffers when the decode operation results in a frame
being outputted to a destination buffer. But the decision when to do this, i.e.
whether the decode operation on current source buffer produced a destination
frame, is wrongly based on "display status". Display status reflects the status
of the destination buffer, not source.

This used to work for firmwares version <= 6, because in addition to the above,
we'd check the decoded frame type register, which was set to "skipped" if
a destination frame was not produced, exiting early from
s5p_mfc_handle_frame_new().
Firmware >=7 does not set the frame type register for frames that were not
decoded anymore though, which results in us wrongly overwriting timestamps of
previously decoded buffers (firmware reports the same destination buffer address
as previously decoded one if a frame wasn't decoded during current operation).

To do it properly, we should be basing our decision to copy the timestamp on the
status of the source buffer, i.e. "decode status". The decode status register
values are confusing, because in its case "display" means "a frame has been
outputted to a destination buffer". We should copy if "decode and display"
is returned in it. This also works on <= v6 firmware, which behaves in the same
way with regards to decode status register.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 89356ae..6ef6bd1 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -309,12 +309,15 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	unsigned int dst_frame_status;
+	unsigned int dec_frame_status;
 	struct s5p_mfc_buf *src_buf;
 	unsigned long flags;
 	unsigned int res_change;
 
 	dst_frame_status = s5p_mfc_hw_call(dev->mfc_ops, get_dspl_status, dev)
 				& S5P_FIMV_DEC_STATUS_DECODING_STATUS_MASK;
+	dec_frame_status = s5p_mfc_hw_call(dev->mfc_ops, get_dec_status, dev)
+				& S5P_FIMV_DEC_STATUS_DECODING_STATUS_MASK;
 	res_change = (s5p_mfc_hw_call(dev->mfc_ops, get_dspl_status, dev)
 				& S5P_FIMV_DEC_STATUS_RESOLUTION_MASK)
 				>> S5P_FIMV_DEC_STATUS_RESOLUTION_SHIFT;
@@ -347,8 +350,7 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 		}
 	}
 
-	if (dst_frame_status == S5P_FIMV_DEC_STATUS_DECODING_DISPLAY ||
-		dst_frame_status == S5P_FIMV_DEC_STATUS_DECODING_ONLY)
+	if (dec_frame_status == S5P_FIMV_DEC_STATUS_DECODING_DISPLAY)
 		s5p_mfc_handle_frame_copy_time(ctx);
 
 	/* A frame has been decoded and is in the buffer  */
-- 
1.7.9.5

