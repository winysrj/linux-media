Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:52162 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbaCRIwv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Mar 2014 04:52:51 -0400
Received: by mail-pb0-f44.google.com with SMTP id rp16so6950111pbb.31
        for <linux-media@vger.kernel.org>; Tue, 18 Mar 2014 01:52:50 -0700 (PDT)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, posciak@chromium.org,
	arunkk.samsung@gmail.com
Subject: [PATCH] [media] s5p-mfc: Copy timestamps only when a frame is produced.
Date: Tue, 18 Mar 2014 14:22:39 +0530
Message-Id: <1395132760-5529-1-git-send-email-arun.kk@samsung.com>
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
index 66c1775..d636789 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -304,12 +304,15 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
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
@@ -342,8 +345,7 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 		}
 	}
 
-	if (dst_frame_status == S5P_FIMV_DEC_STATUS_DECODING_DISPLAY ||
-		dst_frame_status == S5P_FIMV_DEC_STATUS_DECODING_ONLY)
+	if (dec_frame_status == S5P_FIMV_DEC_STATUS_DECODING_DISPLAY)
 		s5p_mfc_handle_frame_copy_time(ctx);
 
 	/* A frame has been decoded and is in the buffer  */
-- 
1.7.9.5

