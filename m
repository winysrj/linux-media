Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35198 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaDUJ0Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Apr 2014 05:26:24 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, posciak@chromium.org,
	arunkk.samsung@gmail.com
Subject: [PATCH v2 2/2] [media] s5p-mfc: Add support for resolution change event
Date: Mon, 21 Apr 2014 14:56:02 +0530
Message-Id: <1398072362-24962-3-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1398072362-24962-1-git-send-email-arun.kk@samsung.com>
References: <1398072362-24962-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pawel Osciak <posciak@chromium.org>

When a resolution change point is reached, queue an event to signal the
userspace that a new set of buffers is required before decoding can
continue.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c     |    6 ++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c |    2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 4ee5a02..5152a23 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -308,6 +308,7 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 	struct s5p_mfc_buf *src_buf;
 	unsigned long flags;
 	unsigned int res_change;
+	struct v4l2_event ev;
 
 	dst_frame_status = s5p_mfc_hw_call(dev->mfc_ops, get_dspl_status, dev)
 				& S5P_FIMV_DEC_STATUS_DECODING_STATUS_MASK;
@@ -339,6 +340,11 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 		if (ctx->state == MFCINST_RES_CHANGE_FLUSH) {
 			s5p_mfc_handle_frame_all_extracted(ctx);
 			ctx->state = MFCINST_RES_CHANGE_END;
+
+			memset(&ev, 0, sizeof(struct v4l2_event));
+			ev.type = V4L2_EVENT_SOURCE_CHANGE;
+			v4l2_event_queue_fh(&ctx->fh, &ev);
+
 			goto leave_handle_frame;
 		} else {
 			s5p_mfc_handle_frame_all_extracted(ctx);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 4586186..069d354 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -851,6 +851,8 @@ static int vidioc_subscribe_event(struct v4l2_fh *fh,
 	switch (sub->type) {
 	case V4L2_EVENT_EOS:
 		return v4l2_event_subscribe(fh, sub, 2, NULL);
+	case V4L2_EVENT_SOURCE_CHANGE:
+		return v4l2_event_subscribe(fh, sub, 2, NULL);
 	default:
 		return -EINVAL;
 	}
-- 
1.7.9.5

