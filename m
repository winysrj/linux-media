Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40711 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbaBIIt6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 03:49:58 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 26/86] rtl2832_sdr: return NULL on rtl2832_sdr_attach failure
Date: Sun,  9 Feb 2014 10:48:31 +0200
Message-Id: <1391935771-18670-27-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dvb_attach() expects NULL on attach failure.
Do some style changes also while we are here.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 50 ++++++++++++------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index a26125c..1cc7bf7 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -1250,31 +1250,31 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 	struct rtl2832_sdr_state *s;
 	struct dvb_usb_device *d = i2c_get_adapdata(i2c);
 	static const struct v4l2_ctrl_config ctrl_tuner_bw = {
-		.ops	= &rtl2832_sdr_ctrl_ops,
-		.id	= RTL2832_SDR_CID_TUNER_BW,
-		.type	= V4L2_CTRL_TYPE_INTEGER,
-		.name	= "Tuner BW",
-		.min	=  200000,
-		.max	= 8000000,
+		.ops    = &rtl2832_sdr_ctrl_ops,
+		.id     = RTL2832_SDR_CID_TUNER_BW,
+		.type   = V4L2_CTRL_TYPE_INTEGER,
+		.name   = "Tuner BW",
+		.min    =  200000,
+		.max    = 8000000,
 		.def    =  600000,
-		.step	= 1,
+		.step   = 1,
 	};
 	static const struct v4l2_ctrl_config ctrl_tuner_gain = {
-		.ops	= &rtl2832_sdr_ctrl_ops,
-		.id	= RTL2832_SDR_CID_TUNER_GAIN,
-		.type	= V4L2_CTRL_TYPE_INTEGER,
-		.name	= "Tuner Gain",
-		.min	= 0,
-		.max	= 102,
+		.ops    = &rtl2832_sdr_ctrl_ops,
+		.id     = RTL2832_SDR_CID_TUNER_GAIN,
+		.type   = V4L2_CTRL_TYPE_INTEGER,
+		.name   = "Tuner Gain",
+		.min    = 0,
+		.max    = 102,
 		.def    = 0,
-		.step	= 1,
+		.step   = 1,
 	};
 
 	s = kzalloc(sizeof(struct rtl2832_sdr_state), GFP_KERNEL);
 	if (s == NULL) {
 		dev_err(&d->udev->dev,
 				"Could not allocate memory for rtl2832_sdr_state\n");
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 	}
 
 	/* setup the state */
@@ -1298,18 +1298,11 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 	s->vb_queue.mem_ops = &vb2_vmalloc_memops;
 	s->vb_queue.timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	ret = vb2_queue_init(&s->vb_queue);
-	if (ret < 0) {
+	if (ret) {
 		dev_err(&s->udev->dev, "Could not initialize vb2 queue\n");
 		goto err_free_mem;
 	}
 
-	/* Init video_device structure */
-	s->vdev = rtl2832_sdr_template;
-	s->vdev.queue = &s->vb_queue;
-	s->vdev.queue->lock = &s->vb_queue_lock;
-	set_bit(V4L2_FL_USE_FH_PRIO, &s->vdev.flags);
-	video_set_drvdata(&s->vdev, s);
-
 	/* Register controls */
 	v4l2_ctrl_handler_init(&s->ctrl_handler, 2);
 	s->ctrl_tuner_bw = v4l2_ctrl_new_custom(&s->ctrl_handler, &ctrl_tuner_bw, NULL);
@@ -1320,6 +1313,13 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 		goto err_free_controls;
 	}
 
+	/* Init video_device structure */
+	s->vdev = rtl2832_sdr_template;
+	s->vdev.queue = &s->vb_queue;
+	s->vdev.queue->lock = &s->vb_queue_lock;
+	set_bit(V4L2_FL_USE_FH_PRIO, &s->vdev.flags);
+	video_set_drvdata(&s->vdev, s);
+
 	/* Register the v4l2_device structure */
 	s->v4l2_dev.release = rtl2832_sdr_video_release;
 	ret = v4l2_device_register(&s->udev->dev, &s->v4l2_dev);
@@ -1335,7 +1335,7 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 	s->vdev.vfl_dir = VFL_DIR_RX;
 
 	ret = video_register_device(&s->vdev, VFL_TYPE_SDR, -1);
-	if (ret < 0) {
+	if (ret) {
 		dev_err(&s->udev->dev,
 				"Failed to register as video device (%d)\n",
 				ret);
@@ -1357,7 +1357,7 @@ err_free_controls:
 	v4l2_ctrl_handler_free(&s->ctrl_handler);
 err_free_mem:
 	kfree(s);
-	return ERR_PTR(ret);
+	return NULL;
 }
 EXPORT_SYMBOL(rtl2832_sdr_attach);
 
-- 
1.8.5.3

