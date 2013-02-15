Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1189 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932895Ab3BOJTH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 04:19:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 2/9] s2255: add V4L2_CID_JPEG_COMPRESSION_QUALITY
Date: Fri, 15 Feb 2013 10:18:47 +0100
Message-Id: <670519c87b8a474a0447b445bfee0718f2a454e0.1360919695.git.hans.verkuil@cisco.com>
In-Reply-To: <1360919934-25552-1-git-send-email-hverkuil@xs4all.nl>
References: <1360919934-25552-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <fa483ff8ca5aae815cd227f47fe797c1c5a8a73d.1360919695.git.hans.verkuil@cisco.com>
References: <fa483ff8ca5aae815cd227f47fe797c1c5a8a73d.1360919695.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The use of the V4L2_CID_JPEG_COMPRESSION_QUALITY control is recommended over
the G/S_JPEGCOMP ioctls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/s2255/s2255drv.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 2dcb29b..42c3afe 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -219,12 +219,13 @@ struct s2255_dev;
 struct s2255_channel {
 	struct video_device	vdev;
 	struct v4l2_ctrl_handler hdl;
+	struct v4l2_ctrl	*jpegqual_ctrl;
 	int			resources;
 	struct s2255_dmaqueue	vidq;
 	struct s2255_bufferi	buffer;
 	struct s2255_mode	mode;
 	/* jpeg compression */
-	struct v4l2_jpegcompression jc;
+	unsigned		jpegqual;
 	/* capture parameters (for high quality mode full size) */
 	struct v4l2_captureparm cap_parm;
 	int			cur_frame;
@@ -1015,7 +1016,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	case V4L2_PIX_FMT_MJPEG:
 		mode.color &= ~MASK_COLOR;
 		mode.color |= COLOR_JPG;
-		mode.color |= (channel->jc.quality << 8);
+		mode.color |= (channel->jpegqual << 8);
 		break;
 	case V4L2_PIX_FMT_YUV422P:
 		mode.color &= ~MASK_COLOR;
@@ -1185,7 +1186,7 @@ static int s2255_set_mode(struct s2255_channel *channel,
 		mode->color &= ~MASK_COLOR;
 		mode->color |= COLOR_JPG;
 		mode->color &= ~MASK_JPG_QUALITY;
-		mode->color |= (channel->jc.quality << 8);
+		mode->color |= (channel->jpegqual << 8);
 	}
 	/* save the mode */
 	channel->mode = *mode;
@@ -1434,6 +1435,9 @@ static int s2255_s_ctrl(struct v4l2_ctrl *ctrl)
 		mode.color &= ~MASK_INPUT_TYPE;
 		mode.color |= !ctrl->val << 16;
 		break;
+	case V4L2_CID_JPEG_COMPRESSION_QUALITY:
+		channel->jpegqual = ctrl->val;
+		return 0;
 	default:
 		return -EINVAL;
 	}
@@ -1451,7 +1455,9 @@ static int vidioc_g_jpegcomp(struct file *file, void *priv,
 {
 	struct s2255_fh *fh = priv;
 	struct s2255_channel *channel = fh->channel;
-	*jc = channel->jc;
+
+	memset(jc, 0, sizeof(*jc));
+	jc->quality = channel->jpegqual;
 	dprintk(2, "%s: quality %d\n", __func__, jc->quality);
 	return 0;
 }
@@ -1463,7 +1469,7 @@ static int vidioc_s_jpegcomp(struct file *file, void *priv,
 	struct s2255_channel *channel = fh->channel;
 	if (jc->quality < 0 || jc->quality > 100)
 		return -EINVAL;
-	channel->jc.quality = jc->quality;
+	v4l2_ctrl_s_ctrl(channel->jpegqual_ctrl, jc->quality);
 	dprintk(2, "%s: quality %d\n", __func__, jc->quality);
 	return 0;
 }
@@ -1864,7 +1870,7 @@ static int s2255_probe_v4l(struct s2255_dev *dev)
 		channel = &dev->channel[i];
 		INIT_LIST_HEAD(&channel->vidq.active);
 
-		v4l2_ctrl_handler_init(&channel->hdl, 5);
+		v4l2_ctrl_handler_init(&channel->hdl, 6);
 		v4l2_ctrl_new_std(&channel->hdl, &s2255_ctrl_ops,
 				V4L2_CID_BRIGHTNESS, -127, 127, 1, DEF_BRIGHT);
 		v4l2_ctrl_new_std(&channel->hdl, &s2255_ctrl_ops,
@@ -1873,6 +1879,10 @@ static int s2255_probe_v4l(struct s2255_dev *dev)
 				V4L2_CID_SATURATION, 0, 255, 1, DEF_SATURATION);
 		v4l2_ctrl_new_std(&channel->hdl, &s2255_ctrl_ops,
 				V4L2_CID_HUE, 0, 255, 1, DEF_HUE);
+		channel->jpegqual_ctrl = v4l2_ctrl_new_std(&channel->hdl,
+				&s2255_ctrl_ops,
+				V4L2_CID_JPEG_COMPRESSION_QUALITY,
+				0, 100, 1, S2255_DEF_JPEG_QUAL);
 		if (dev->dsp_fw_ver >= S2255_MIN_DSP_COLORFILTER &&
 		    (dev->pid != 0x2257 || channel->idx <= 1))
 			v4l2_ctrl_new_custom(&channel->hdl, &color_filter_ctrl, NULL);
@@ -2238,7 +2248,7 @@ static int s2255_board_init(struct s2255_dev *dev)
 		channel->mode = mode_def;
 		if (dev->pid == 0x2257 && j > 1)
 			channel->mode.color |= (1 << 16);
-		channel->jc.quality = S2255_DEF_JPEG_QUAL;
+		channel->jpegqual = S2255_DEF_JPEG_QUAL;
 		channel->width = LINE_SZ_4CIFS_NTSC;
 		channel->height = NUM_LINES_4CIFS_NTSC * 2;
 		channel->fmt = &formats[0];
-- 
1.7.10.4

