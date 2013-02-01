Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2681 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab3BAMRc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 07:17:32 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 6/6] tm6000: fix G/TRY_FMT.
Date: Fri,  1 Feb 2013 13:17:21 +0100
Message-Id: <800c8f9e30561618d47540698cc79bd3d3470ff2.1359720708.git.hans.verkuil@cisco.com>
In-Reply-To: <1359721041-5133-1-git-send-email-hverkuil@xs4all.nl>
References: <1359721041-5133-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <db596a5954282c998c516d9a8ebd719df71549b3.1359720708.git.hans.verkuil@cisco.com>
References: <db596a5954282c998c516d9a8ebd719df71549b3.1359720708.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Two fixes:

- the priv field wasn't set to 0.
- only V4L2_FIELD_INTERLACED is supported.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/tm6000/tm6000-video.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index f41dbb1..eab2341 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -918,6 +918,7 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 		(f->fmt.pix.width * fh->fmt->depth) >> 3;
 	f->fmt.pix.sizeimage =
 		f->fmt.pix.height * f->fmt.pix.bytesperline;
+	f->fmt.pix.priv = 0;
 
 	return 0;
 }
@@ -948,12 +949,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 
 	field = f->fmt.pix.field;
 
-	if (field == V4L2_FIELD_ANY)
-		field = V4L2_FIELD_SEQ_TB;
-	else if (V4L2_FIELD_INTERLACED != field) {
-		dprintk(dev, V4L2_DEBUG_IOCTL_ARG, "Field type invalid.\n");
-		return -EINVAL;
-	}
+	field = V4L2_FIELD_INTERLACED;
 
 	tm6000_get_std_res(dev);
 
@@ -963,6 +959,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.width &= ~0x01;
 
 	f->fmt.pix.field = field;
+	f->fmt.pix.priv = 0;
 
 	f->fmt.pix.bytesperline =
 		(f->fmt.pix.width * fmt->depth) >> 3;
-- 
1.7.10.4

