Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54022 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750976AbcIGWYm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 18:24:42 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran@ksquared.org.uk>
Subject: [PATCH v3 01/10] v4l: ioctl: Clear the v4l2_pix_format_mplane reserved field
Date: Thu,  8 Sep 2016 01:25:01 +0300
Message-Id: <1473287110-780-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1473287110-780-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1473287110-780-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The S_FMT and TRY_FMT handlers in multiplane mode attempt at clearing
the reserved fields of the v4l2_format structure after the pix_mp
member. However, the reserved fields are inside pix_mp, not after it.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Tested-by: Kieran Bingham <kieran@bingham.xyz>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index eb6ccc70e9a8..c52d94c018bb 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1504,7 +1504,7 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 		if (unlikely(!is_rx || !is_vid || !ops->vidioc_s_fmt_vid_cap_mplane))
 			break;
-		CLEAR_AFTER_FIELD(p, fmt.pix_mp);
+		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
 		return ops->vidioc_s_fmt_vid_cap_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 		if (unlikely(!is_rx || !is_vid || !ops->vidioc_s_fmt_vid_overlay))
@@ -1532,7 +1532,7 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
 		if (unlikely(!is_tx || !is_vid || !ops->vidioc_s_fmt_vid_out_mplane))
 			break;
-		CLEAR_AFTER_FIELD(p, fmt.pix_mp);
+		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
 		return ops->vidioc_s_fmt_vid_out_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
 		if (unlikely(!is_tx || !is_vid || !ops->vidioc_s_fmt_vid_out_overlay))
@@ -1589,7 +1589,7 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 		if (unlikely(!is_rx || !is_vid || !ops->vidioc_try_fmt_vid_cap_mplane))
 			break;
-		CLEAR_AFTER_FIELD(p, fmt.pix_mp);
+		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
 		return ops->vidioc_try_fmt_vid_cap_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 		if (unlikely(!is_rx || !is_vid || !ops->vidioc_try_fmt_vid_overlay))
@@ -1617,7 +1617,7 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
 		if (unlikely(!is_tx || !is_vid || !ops->vidioc_try_fmt_vid_out_mplane))
 			break;
-		CLEAR_AFTER_FIELD(p, fmt.pix_mp);
+		CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
 		return ops->vidioc_try_fmt_vid_out_mplane(file, fh, arg);
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
 		if (unlikely(!is_tx || !is_vid || !ops->vidioc_try_fmt_vid_out_overlay))
-- 
Regards,

Laurent Pinchart

