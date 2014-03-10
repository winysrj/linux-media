Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44017 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028AbaCJTer (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 15:34:47 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [FINAL PATCH 2/6] rtl2832u_sdr: fixing v4l2-compliance issues
Date: Mon, 10 Mar 2014 21:34:08 +0200
Message-Id: <1394480052-6003-2-git-send-email-crope@iki.fi>
In-Reply-To: <1394480052-6003-1-git-send-email-crope@iki.fi>
References: <1394480052-6003-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hverkuil@xs4all.nl>

Fix rtl2832u_sdr driver v4l2-compliance issues.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 29 +++++++++++++++++++-----
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index 932716f..bcc632a 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -120,6 +120,7 @@ struct rtl2832_sdr_state {
 	struct vb2_queue vb_queue;
 	struct list_head queued_bufs;
 	spinlock_t queued_bufs_lock; /* Protects queued_bufs */
+	unsigned sequence;	     /* buffer sequence counter */
 
 	/* Note if taking both locks v4l2_lock must always be locked first! */
 	struct mutex v4l2_lock;      /* Protects everything else */
@@ -415,6 +416,8 @@ static void rtl2832_sdr_urb_complete(struct urb *urb)
 		len = rtl2832_sdr_convert_stream(s, ptr, urb->transfer_buffer,
 				urb->actual_length);
 		vb2_set_plane_payload(&fbuf->vb, 0, len);
+		v4l2_get_timestamp(&fbuf->vb.v4l2_buf.timestamp);
+		fbuf->vb.v4l2_buf.sequence = s->sequence++;
 		vb2_buffer_done(&fbuf->vb, VB2_BUF_STATE_DONE);
 	}
 skip:
@@ -611,8 +614,9 @@ static int rtl2832_sdr_queue_setup(struct vb2_queue *vq,
 	struct rtl2832_sdr_state *s = vb2_get_drv_priv(vq);
 	dev_dbg(&s->udev->dev, "%s: *nbuffers=%d\n", __func__, *nbuffers);
 
-	/* Absolute min and max number of buffers available for mmap() */
-	*nbuffers = clamp_t(unsigned int, *nbuffers, 8, 32);
+	/* Need at least 8 buffers */
+	if (vq->num_buffers + *nbuffers < 8)
+		*nbuffers = 8 - vq->num_buffers;
 	*nplanes = 1;
 	/* 2 = max 16-bit sample returned */
 	sizes[0] = PAGE_ALIGN(BULK_BUFFER_SIZE * 2);
@@ -1013,6 +1017,8 @@ static int rtl2832_sdr_start_streaming(struct vb2_queue *vq, unsigned int count)
 	if (ret)
 		goto err;
 
+	s->sequence = 0;
+
 	ret = rtl2832_sdr_submit_urbs(s);
 	if (ret)
 		goto err;
@@ -1090,6 +1096,8 @@ static int rtl2832_sdr_s_tuner(struct file *file, void *priv,
 	struct rtl2832_sdr_state *s = video_drvdata(file);
 	dev_dbg(&s->udev->dev, "%s:\n", __func__);
 
+	if (v->index > 1)
+		return -EINVAL;
 	return 0;
 }
 
@@ -1125,12 +1133,15 @@ static int rtl2832_sdr_g_frequency(struct file *file, void *priv,
 	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d\n",
 			__func__, f->tuner, f->type);
 
-	if (f->tuner == 0)
+	if (f->tuner == 0) {
 		f->frequency = s->f_adc;
-	else if (f->tuner == 1)
+		f->type = V4L2_TUNER_ADC;
+	} else if (f->tuner == 1) {
 		f->frequency = s->f_tuner;
-	else
+		f->type = V4L2_TUNER_RF;
+	} else {
 		return -EINVAL;
+	}
 
 	return ret;
 }
@@ -1164,7 +1175,9 @@ static int rtl2832_sdr_s_frequency(struct file *file, void *priv,
 				__func__, s->f_adc);
 		ret = rtl2832_sdr_set_adc(s);
 	} else if (f->tuner == 1) {
-		s->f_tuner = f->frequency;
+		s->f_tuner = clamp_t(unsigned int, f->frequency,
+				bands_fm[0].rangelow,
+				bands_fm[0].rangehigh);
 		dev_dbg(&s->udev->dev, "%s: RF frequency=%u Hz\n",
 				__func__, f->frequency);
 
@@ -1198,6 +1211,7 @@ static int rtl2832_sdr_g_fmt_sdr_cap(struct file *file, void *priv,
 	dev_dbg(&s->udev->dev, "%s:\n", __func__);
 
 	f->fmt.sdr.pixelformat = s->pixelformat;
+	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
 
 	return 0;
 }
@@ -1214,6 +1228,7 @@ static int rtl2832_sdr_s_fmt_sdr_cap(struct file *file, void *priv,
 	if (vb2_is_busy(q))
 		return -EBUSY;
 
+	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
 	for (i = 0; i < NUM_FORMATS; i++) {
 		if (formats[i].pixelformat == f->fmt.sdr.pixelformat) {
 			s->pixelformat = f->fmt.sdr.pixelformat;
@@ -1235,6 +1250,7 @@ static int rtl2832_sdr_try_fmt_sdr_cap(struct file *file, void *priv,
 	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
 			(char *)&f->fmt.sdr.pixelformat);
 
+	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
 	for (i = 0; i < NUM_FORMATS; i++) {
 		if (formats[i].pixelformat == f->fmt.sdr.pixelformat)
 			return 0;
@@ -1365,6 +1381,7 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 	s->i2c = i2c;
 	s->cfg = cfg;
 	s->f_adc = bands_adc[0].rangelow;
+	s->f_tuner = bands_fm[0].rangelow;
 	s->pixelformat =  V4L2_SDR_FMT_CU8;
 
 	mutex_init(&s->v4l2_lock);
-- 
1.8.5.3

