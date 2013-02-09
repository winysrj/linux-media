Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1042 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab3BIKBT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2013 05:01:19 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 06/26] cx231xx: zero priv field and use right width in try_fmt
Date: Sat,  9 Feb 2013 11:00:36 +0100
Message-Id: <b2e41de42ae000cb8d3ca17b08a7efc5feb2e6ee.1360403310.git.hans.verkuil@cisco.com>
In-Reply-To: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
References: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
References: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The priv field of v4l2_pix_format must be zeroed. Also fix a bug in try_fmt
where the current width was used instead of the width passed to try_fmt.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-video.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 8e0703c..90f4510 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1005,6 +1005,7 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 
 	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
+	f->fmt.pix.priv = 0;
 
 	return 0;
 }
@@ -1045,10 +1046,11 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.width = width;
 	f->fmt.pix.height = height;
 	f->fmt.pix.pixelformat = fmt->fourcc;
-	f->fmt.pix.bytesperline = (dev->width * fmt->depth + 7) >> 3;
+	f->fmt.pix.bytesperline = (width * fmt->depth + 7) >> 3;
 	f->fmt.pix.sizeimage = f->fmt.pix.bytesperline * height;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 	f->fmt.pix.field = V4L2_FIELD_INTERLACED;
+	f->fmt.pix.priv = 0;
 
 	return 0;
 }
-- 
1.7.10.4

