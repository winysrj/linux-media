Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4315 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766Ab3BAMRc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 07:17:32 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 4/6] tm6000: set colorspace field.
Date: Fri,  1 Feb 2013 13:17:19 +0100
Message-Id: <2d82496b9bf93e0540329792d2ad0aef3c297db1.1359720708.git.hans.verkuil@cisco.com>
In-Reply-To: <1359721041-5133-1-git-send-email-hverkuil@xs4all.nl>
References: <1359721041-5133-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <db596a5954282c998c516d9a8ebd719df71549b3.1359720708.git.hans.verkuil@cisco.com>
References: <db596a5954282c998c516d9a8ebd719df71549b3.1359720708.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/tm6000/tm6000-video.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index 25202a7..ac25885 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -913,6 +913,7 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.height       = fh->height;
 	f->fmt.pix.field        = fh->vb_vidq.field;
 	f->fmt.pix.pixelformat  = fh->fmt->fourcc;
+	f->fmt.pix.colorspace   = V4L2_COLORSPACE_SMPTE170M;
 	f->fmt.pix.bytesperline =
 		(f->fmt.pix.width * fh->fmt->depth) >> 3;
 	f->fmt.pix.sizeimage =
@@ -967,6 +968,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 		(f->fmt.pix.width * fmt->depth) >> 3;
 	f->fmt.pix.sizeimage =
 		f->fmt.pix.height * f->fmt.pix.bytesperline;
+	f->fmt.pix.colorspace   = V4L2_COLORSPACE_SMPTE170M;
 
 	return 0;
 }
-- 
1.7.10.4

