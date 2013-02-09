Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4351 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab3BIKBY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2013 05:01:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 13/26] cx231xx: get rid of a bunch of unused cx231xx_fh fields.
Date: Sat,  9 Feb 2013 11:00:43 +0100
Message-Id: <ec0d3303adb48c9ee6132cfdcd1370a3d782a141.1360403310.git.hans.verkuil@cisco.com>
In-Reply-To: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
References: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
References: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-video.c |    6 +-----
 drivers/media/usb/cx231xx/cx231xx.h       |   18 +-----------------
 2 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index e3c69f7..311d106 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1620,9 +1620,6 @@ static int vidioc_streamoff(struct file *file, void *priv,
 	if (rc < 0)
 		return rc;
 
-	if ((fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
-	    (fh->type != V4L2_BUF_TYPE_VBI_CAPTURE))
-		return -EINVAL;
 	if (type != fh->type)
 		return -EINVAL;
 
@@ -1868,7 +1865,6 @@ static int cx231xx_v4l2_open(struct file *filp)
 		return -ERESTARTSYS;
 	}
 	fh->dev = dev;
-	fh->radio = radio;
 	fh->type = fh_type;
 	filp->private_data = fh;
 	v4l2_fh_init(&fh->fh, vdev);
@@ -1899,7 +1895,7 @@ static int cx231xx_v4l2_open(struct file *filp)
 		dev->video_input = dev->video_input > 2 ? 2 : dev->video_input;
 
 	}
-	if (fh->radio) {
+	if (radio) {
 		cx231xx_videodbg("video_open: setting radio device\n");
 
 		/* cx231xx_start_radio(dev); */
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index 4c83ff5..c17889d 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -433,25 +433,9 @@ struct cx231xx_fh {
 	struct v4l2_fh fh;
 	struct cx231xx *dev;
 	unsigned int stream_on:1;	/* Locks streams */
-	int radio;
-
-	struct videobuf_queue vb_vidq;
-
 	enum v4l2_buf_type type;
 
-
-
-/*following is copyed from cx23885.h*/
-	u32                        resources;
-
-	/* video overlay */
-	struct v4l2_window         win;
-	struct v4l2_clip           *clips;
-	unsigned int               nclips;
-
-	/* video capture */
-	struct cx23417_fmt         *fmt;
-	unsigned int               width, height;
+	struct videobuf_queue vb_vidq;
 
 	/* vbi capture */
 	struct videobuf_queue      vidq;
-- 
1.7.10.4

