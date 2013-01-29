Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1909 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899Ab3A2Qdo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 11:33:44 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 07/20] cx231xx: fix frequency clamping.
Date: Tue, 29 Jan 2013 17:33:00 +0100
Message-Id: <547a7773f2b6733c2e47ef729489cd5364fe5816.1359476777.git.hans.verkuil@cisco.com>
In-Reply-To: <1359477193-9768-1-git-send-email-hverkuil@xs4all.nl>
References: <1359477193-9768-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <8a9d877c6be8a336a44c69a21b3fca449294139d.1359476776.git.hans.verkuil@cisco.com>
References: <8a9d877c6be8a336a44c69a21b3fca449294139d.1359476776.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Let the tuner clamp the frequency and store that clamped value.

This fixes a v4l2_compliance failure.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-video.c |   33 +++++++++++++++--------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 05bafdaf..ee9c9a5 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1356,11 +1356,8 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 	if (f->tuner)
 		return -EINVAL;
 
-	f->type = fh->radio ? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 	f->frequency = dev->ctl_freq;
 
-	call_all(dev, tuner, g_frequency, f);
-
 	return 0;
 }
 
@@ -1383,16 +1380,12 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	if (0 != f->tuner)
 		return -EINVAL;
 
-	if (unlikely(0 == fh->radio && f->type != V4L2_TUNER_ANALOG_TV))
-		return -EINVAL;
-	if (unlikely(1 == fh->radio && f->type != V4L2_TUNER_RADIO))
-		return -EINVAL;
-
 	/* set pre channel change settings in DIF first */
 	rc = cx231xx_tuner_pre_channel_change(dev);
 
-	dev->ctl_freq = f->frequency;
 	call_all(dev, tuner, s_frequency, f);
+	call_all(dev, tuner, g_frequency, f);
+	dev->ctl_freq = f->frequency;
 
 	/* set post channel change settings in DIF first */
 	rc = cx231xx_tuner_post_channel_change(dev);
@@ -1921,6 +1914,7 @@ static int vidioc_g_fmt_vbi_cap(struct file *file, void *priv,
 {
 	struct cx231xx_fh *fh = priv;
 	struct cx231xx *dev = fh->dev;
+
 	f->fmt.vbi.sampling_rate = 6750000 * 4;
 	f->fmt.vbi.samples_per_line = VBI_LINE_LENGTH;
 	f->fmt.vbi.sample_format = V4L2_PIX_FMT_GREY;
@@ -1943,12 +1937,6 @@ static int vidioc_try_fmt_vbi_cap(struct file *file, void *priv,
 	struct cx231xx_fh *fh = priv;
 	struct cx231xx *dev = fh->dev;
 
-	if (dev->vbi_stream_on && !fh->stream_on) {
-		cx231xx_errdev("%s device in use by another fh\n", __func__);
-		return -EBUSY;
-	}
-
-	f->type = V4L2_BUF_TYPE_VBI_CAPTURE;
 	f->fmt.vbi.sampling_rate = 6750000 * 4;
 	f->fmt.vbi.samples_per_line = VBI_LINE_LENGTH;
 	f->fmt.vbi.sample_format = V4L2_PIX_FMT_GREY;
@@ -1966,6 +1954,19 @@ static int vidioc_try_fmt_vbi_cap(struct file *file, void *priv,
 
 }
 
+static int vidioc_s_fmt_vbi_cap(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	struct cx231xx_fh *fh = priv;
+	struct cx231xx *dev = fh->dev;
+
+	if (dev->vbi_stream_on && !fh->stream_on) {
+		cx231xx_errdev("%s device in use by another fh\n", __func__);
+		return -EBUSY;
+	}
+	return vidioc_try_fmt_vbi_cap(file, priv, f);
+}
+
 static int vidioc_reqbufs(struct file *file, void *priv,
 			  struct v4l2_requestbuffers *rb)
 {
@@ -2427,7 +2428,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_s_fmt_vid_cap          = vidioc_s_fmt_vid_cap,
 	.vidioc_g_fmt_vbi_cap          = vidioc_g_fmt_vbi_cap,
 	.vidioc_try_fmt_vbi_cap        = vidioc_try_fmt_vbi_cap,
-	.vidioc_s_fmt_vbi_cap          = vidioc_try_fmt_vbi_cap,
+	.vidioc_s_fmt_vbi_cap          = vidioc_s_fmt_vbi_cap,
 	.vidioc_cropcap                = vidioc_cropcap,
 	.vidioc_g_fmt_sliced_vbi_cap   = vidioc_g_fmt_sliced_vbi_cap,
 	.vidioc_try_fmt_sliced_vbi_cap = vidioc_try_set_sliced_vbi_cap,
-- 
1.7.10.4

