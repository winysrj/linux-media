Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1364 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246AbaGUJoL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 05:44:11 -0400
Message-ID: <53CCE0E2.8020903@xs4all.nl>
Date: Mon, 21 Jul 2014 11:44:02 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCHv3 for v3.17] v4l2-ioctl: don't set PRIV_MAGIC unconditionally
 in g_fmt()
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Regression fix:

V4L2_PIX_FMT_PRIV_MAGIC should only be set for the VIDEO_CAPTURE and
VIDEO_OUTPUT buffer types, and not for any others. In the case of
the win format this overwrote a pointer value that is passed in from
userspace.

Just set it for V4L2_BUF_TYPE_VIDEO_CAPTURE and OUTPUT only. Also set
it before the callback is called, just as is done for try/s_fmt.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index e620387..22c8d48 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1143,8 +1143,6 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 	int ret;
 
-	p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
-
 	/*
 	 * fmt can't be cleared for these overlay types due to the 'clips'
 	 * 'clipcount' and 'bitmap' pointers in struct v4l2_window.
@@ -1164,6 +1162,15 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 		p->fmt.win.bitmap = bitmap;
 		break;
 	}
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+		memset(&p->fmt, 0, sizeof(p->fmt));
+		/*
+		 * Fill in the priv field to signal that the extended
+		 * v4l2_pix_format fields are valid.
+		 */
+		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
+		break;
 	default:
 		memset(&p->fmt, 0, sizeof(p->fmt));
 		break;
@@ -1174,6 +1181,7 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!is_rx || !is_vid || !ops->vidioc_g_fmt_vid_cap))
 			break;
 		ret = ops->vidioc_g_fmt_vid_cap(file, fh, arg);
+		/* just in case the driver zeroed it again */
 		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
 		return ret;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
@@ -1196,6 +1204,7 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!is_tx || !is_vid || !ops->vidioc_g_fmt_vid_out))
 			break;
 		ret = ops->vidioc_g_fmt_vid_out(file, fh, arg);
+		/* just in case the driver zeroed it again */
 		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
 		return ret;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
