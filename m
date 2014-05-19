Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:50304 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096AbaESMdb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 May 2014 08:33:31 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, posciak@chromium.org, avnd.kiran@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH 06/10] [media] s5p-mfc: Don't try to resubmit VP8 bitstream buffer for decode.
Date: Mon, 19 May 2014 18:03:02 +0530
Message-Id: <1400502786-4826-7-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1400502786-4826-1-git-send-email-arun.kk@samsung.com>
References: <1400502786-4826-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pawel Osciak <posciak@chromium.org>

Currently, for formats that are not H264, MFC driver will check
the consumed stream size returned by the firmware and, based on that,
will try to decide whether the bitstream buffer contained more than
one frame. If the size of the buffer is larger than the consumed
stream, it assumes that there are more frames in the buffer and that the
buffer should be resubmitted for decode. This rarely works though and
actually introduces problems, because:

- v7 firmware will always return consumed stream size equal to whatever
the driver passed to it when running decode (which is the size of the whole
buffer), which means we will never try to resubmit, because the firmware
will always tell us that it consumed all the data we passed to it;

- v6 firmware will return the number of consumed bytes, but will not
include the padding ("stuffing") bytes that are allowed after the frame
in VP8. Since there is no way of figuring out how many of those bytes
follow the frame without getting the frame size from IVF headers (or
somewhere else, but not from the stream itself), the driver tries to guess that
padding size is not larger than 4 bytes, which is not always true;

The only way to make it work is to queue only one frame per buffer from
userspace and the check in the kernel is useless and wrong for VP8.
So adding VP8 also along with H264 to disallow re-submitting of buffer
back to hardware for decode.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 70f728f..297d681 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -368,6 +368,7 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 		ctx->consumed_stream += s5p_mfc_hw_call(dev->mfc_ops,
 						get_consumed_stream, dev);
 		if (ctx->codec_mode != S5P_MFC_CODEC_H264_DEC &&
+			ctx->codec_mode != S5P_MFC_CODEC_VP8_DEC &&
 			ctx->consumed_stream + STUFF_BYTE <
 			src_buf->b->v4l2_planes[0].bytesused) {
 			/* Run MFC again on the same buffer */
-- 
1.7.9.5

