Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1196 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687AbaHNJyZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Aug 2014 05:54:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 16/20] cx23885: fix field handling
Date: Thu, 14 Aug 2014 11:54:01 +0200
Message-Id: <1408010045-24016-17-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl>
References: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add missing SEQ_BT/TB support, bottom field is first for all 60 Hz formats,
not just NTSC, restore an overwritten field value and initialize dev->field
correctly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/cx23885-video.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 16fcdfc..ff45417 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -356,7 +356,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 				buf->bpl, 0, dev->height);
 		break;
 	case V4L2_FIELD_INTERLACED:
-		if (dev->tvnorm & V4L2_STD_NTSC)
+		if (dev->tvnorm & V4L2_STD_525_60)
 			/* NTSC or  */
 			field_tff = 1;
 		else
@@ -563,6 +563,8 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 		maxh = maxh / 2;
 		break;
 	case V4L2_FIELD_INTERLACED:
+	case V4L2_FIELD_SEQ_TB:
+	case V4L2_FIELD_SEQ_BT:
 		break;
 	default:
 		field = V4L2_FIELD_INTERLACED;
@@ -602,6 +604,8 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	v4l2_fill_mbus_format(&mbus_fmt, &f->fmt.pix, V4L2_MBUS_FMT_FIXED);
 	call_all(dev, video, s_mbus_fmt, &mbus_fmt);
 	v4l2_fill_pix_format(&f->fmt.pix, &mbus_fmt);
+	/* s_mbus_fmt overwrites f->fmt.pix.field, restore it */
+	f->fmt.pix.field = dev->field;
 	return 0;
 }
 
@@ -1144,6 +1148,7 @@ int cx23885_video_register(struct cx23885_dev *dev)
 
 	dev->tvnorm = V4L2_STD_NTSC_M;
 	dev->fmt = format_by_fourcc(V4L2_PIX_FMT_YUYV);
+	dev->field = V4L2_FIELD_INTERLACED;
 	dev->width = norm_maxw(dev->tvnorm);
 	dev->height = norm_maxh(dev->tvnorm);
 
-- 
2.1.0.rc1

