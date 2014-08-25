Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35930 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892AbaHYRMP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 13:12:15 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 03/12] airspy: logging changes
Date: Mon, 25 Aug 2014 20:11:49 +0300
Message-Id: <1408986718-3881-3-git-send-email-crope@iki.fi>
In-Reply-To: <1408986718-3881-1-git-send-email-crope@iki.fi>
References: <1408986718-3881-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kernel logging system needs pointer to usb interface device in
order to print names and bus numbers properly. There was wrong
device pointer given and log printings wasn't correct.

Remove some debug logging from v4l2 ioctl functions. v4l2 core debug
prints almost same information when enabled.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/airspy/airspy.c | 172 ++++++++++++++------------------------
 1 file changed, 61 insertions(+), 111 deletions(-)

diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index dee1fe2..de9fc52 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -107,6 +107,7 @@ struct airspy {
 #define USB_STATE_URB_BUF  (1 << 3)
 	unsigned long flags;
 
+	struct device *dev;
 	struct usb_device *udev;
 	struct video_device vdev;
 	struct v4l2_device v4l2_dev;
@@ -154,16 +155,15 @@ struct airspy {
 	unsigned int sample_measured;
 };
 
-#define airspy_dbg_usb_control_msg(_udev, _r, _t, _v, _i, _b, _l) { \
+#define airspy_dbg_usb_control_msg(_dev, _r, _t, _v, _i, _b, _l) { \
 	char *_direction; \
 	if (_t & USB_DIR_IN) \
 		_direction = "<<<"; \
 	else \
 		_direction = ">>>"; \
-	dev_dbg(&_udev->dev, "%s: %02x %02x %02x %02x %02x %02x %02x %02x " \
-			"%s %*ph\n",  __func__, _t, _r, _v & 0xff, _v >> 8, \
-			_i & 0xff, _i >> 8, _l & 0xff, _l >> 8, _direction, \
-			_l, _b); \
+	dev_dbg(_dev, "%02x %02x %02x %02x %02x %02x %02x %02x %s %*ph\n", \
+			_t, _r, _v & 0xff, _v >> 8, _i & 0xff, _i >> 8, \
+			_l & 0xff, _l >> 8, _direction, _l, _b); \
 }
 
 /* execute firmware command */
@@ -192,7 +192,7 @@ static int airspy_ctrl_msg(struct airspy *s, u8 request, u16 value, u16 index,
 		requesttype = (USB_TYPE_VENDOR | USB_DIR_IN);
 		break;
 	default:
-		dev_err(&s->udev->dev, "Unknown command %02x\n", request);
+		dev_err(s->dev, "Unknown command %02x\n", request);
 		ret = -EINVAL;
 		goto err;
 	}
@@ -203,11 +203,10 @@ static int airspy_ctrl_msg(struct airspy *s, u8 request, u16 value, u16 index,
 
 	ret = usb_control_msg(s->udev, pipe, request, requesttype, value,
 			index, s->buf, size, 1000);
-	airspy_dbg_usb_control_msg(s->udev, request, requesttype, value,
+	airspy_dbg_usb_control_msg(s->dev, request, requesttype, value,
 			index, s->buf, size);
 	if (ret < 0) {
-		dev_err(&s->udev->dev,
-				"usb_control_msg() failed %d request %02x\n",
+		dev_err(s->dev, "usb_control_msg() failed %d request %02x\n",
 				ret, request);
 		goto err;
 	}
@@ -258,8 +257,7 @@ static unsigned int airspy_convert_stream(struct airspy *s,
 
 		s->jiffies_next = jiffies + msecs_to_jiffies(MSECS);
 		s->sample_measured = s->sample;
-		dev_dbg(&s->udev->dev,
-				"slen=%d samples=%u msecs=%lu sample rate=%lu\n",
+		dev_dbg(s->dev, "slen=%d samples=%u msecs=%lu sample rate=%lu\n",
 				src_len, samples, MSECS,
 				samples * 1000UL / MSECS);
 	}
@@ -279,9 +277,8 @@ static void airspy_urb_complete(struct urb *urb)
 	struct airspy *s = urb->context;
 	struct airspy_frame_buf *fbuf;
 
-	dev_dbg_ratelimited(&s->udev->dev,
-			"%s: status=%d length=%d/%d errors=%d\n",
-			__func__, urb->status, urb->actual_length,
+	dev_dbg_ratelimited(s->dev, "status=%d length=%d/%d errors=%d\n",
+			urb->status, urb->actual_length,
 			urb->transfer_buffer_length, urb->error_count);
 
 	switch (urb->status) {
@@ -293,8 +290,7 @@ static void airspy_urb_complete(struct urb *urb)
 	case -ESHUTDOWN:
 		return;
 	default:            /* error */
-		dev_err_ratelimited(&s->udev->dev, "URB failed %d\n",
-				urb->status);
+		dev_err_ratelimited(s->dev, "URB failed %d\n", urb->status);
 		break;
 	}
 
@@ -305,7 +301,7 @@ static void airspy_urb_complete(struct urb *urb)
 		fbuf = airspy_get_next_fill_buf(s);
 		if (unlikely(fbuf == NULL)) {
 			s->vb_full++;
-			dev_notice_ratelimited(&s->udev->dev,
+			dev_notice_ratelimited(s->dev,
 					"videobuf is full, %d packets dropped\n",
 					s->vb_full);
 			goto skip;
@@ -329,7 +325,7 @@ static int airspy_kill_urbs(struct airspy *s)
 	int i;
 
 	for (i = s->urbs_submitted - 1; i >= 0; i--) {
-		dev_dbg(&s->udev->dev, "%s: kill urb=%d\n", __func__, i);
+		dev_dbg(s->dev, "kill urb=%d\n", i);
 		/* stop the URB */
 		usb_kill_urb(s->urb_list[i]);
 	}
@@ -343,11 +339,10 @@ static int airspy_submit_urbs(struct airspy *s)
 	int i, ret;
 
 	for (i = 0; i < s->urbs_initialized; i++) {
-		dev_dbg(&s->udev->dev, "%s: submit urb=%d\n", __func__, i);
+		dev_dbg(s->dev, "submit urb=%d\n", i);
 		ret = usb_submit_urb(s->urb_list[i], GFP_ATOMIC);
 		if (ret) {
-			dev_err(&s->udev->dev,
-					"Could not submit URB no. %d - get them all back\n",
+			dev_err(s->dev, "Could not submit URB no. %d - get them all back\n",
 					i);
 			airspy_kill_urbs(s);
 			return ret;
@@ -363,8 +358,7 @@ static int airspy_free_stream_bufs(struct airspy *s)
 	if (s->flags & USB_STATE_URB_BUF) {
 		while (s->buf_num) {
 			s->buf_num--;
-			dev_dbg(&s->udev->dev, "%s: free buf=%d\n",
-					__func__, s->buf_num);
+			dev_dbg(s->dev, "free buf=%d\n", s->buf_num);
 			usb_free_coherent(s->udev, s->buf_size,
 					  s->buf_list[s->buf_num],
 					  s->dma_addr[s->buf_num]);
@@ -380,23 +374,20 @@ static int airspy_alloc_stream_bufs(struct airspy *s)
 	s->buf_num = 0;
 	s->buf_size = BULK_BUFFER_SIZE;
 
-	dev_dbg(&s->udev->dev,
-			"%s: all in all I will use %u bytes for streaming\n",
-			__func__,  MAX_BULK_BUFS * BULK_BUFFER_SIZE);
+	dev_dbg(s->dev, "all in all I will use %u bytes for streaming\n",
+			MAX_BULK_BUFS * BULK_BUFFER_SIZE);
 
 	for (s->buf_num = 0; s->buf_num < MAX_BULK_BUFS; s->buf_num++) {
 		s->buf_list[s->buf_num] = usb_alloc_coherent(s->udev,
 				BULK_BUFFER_SIZE, GFP_ATOMIC,
 				&s->dma_addr[s->buf_num]);
 		if (!s->buf_list[s->buf_num]) {
-			dev_dbg(&s->udev->dev, "%s: alloc buf=%d failed\n",
-					__func__, s->buf_num);
+			dev_dbg(s->dev, "alloc buf=%d failed\n", s->buf_num);
 			airspy_free_stream_bufs(s);
 			return -ENOMEM;
 		}
 
-		dev_dbg(&s->udev->dev, "%s: alloc buf=%d %p (dma %llu)\n",
-				__func__, s->buf_num,
+		dev_dbg(s->dev, "alloc buf=%d %p (dma %llu)\n", s->buf_num,
 				s->buf_list[s->buf_num],
 				(long long)s->dma_addr[s->buf_num]);
 		s->flags |= USB_STATE_URB_BUF;
@@ -413,8 +404,7 @@ static int airspy_free_urbs(struct airspy *s)
 
 	for (i = s->urbs_initialized - 1; i >= 0; i--) {
 		if (s->urb_list[i]) {
-			dev_dbg(&s->udev->dev, "%s: free urb=%d\n",
-					__func__, i);
+			dev_dbg(s->dev, "free urb=%d\n", i);
 			/* free the URBs */
 			usb_free_urb(s->urb_list[i]);
 		}
@@ -430,10 +420,10 @@ static int airspy_alloc_urbs(struct airspy *s)
 
 	/* allocate the URBs */
 	for (i = 0; i < MAX_BULK_BUFS; i++) {
-		dev_dbg(&s->udev->dev, "%s: alloc urb=%d\n", __func__, i);
+		dev_dbg(s->dev, "alloc urb=%d\n", i);
 		s->urb_list[i] = usb_alloc_urb(0, GFP_ATOMIC);
 		if (!s->urb_list[i]) {
-			dev_dbg(&s->udev->dev, "%s: failed\n", __func__);
+			dev_dbg(s->dev, "failed\n");
 			for (j = 0; j < i; j++)
 				usb_free_urb(s->urb_list[j]);
 			return -ENOMEM;
@@ -458,7 +448,7 @@ static void airspy_cleanup_queued_bufs(struct airspy *s)
 {
 	unsigned long flags = 0;
 
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	dev_dbg(s->dev, "\n");
 
 	spin_lock_irqsave(&s->queued_bufs_lock, flags);
 	while (!list_empty(&s->queued_bufs)) {
@@ -478,7 +468,7 @@ static void airspy_disconnect(struct usb_interface *intf)
 	struct v4l2_device *v = usb_get_intfdata(intf);
 	struct airspy *s = container_of(v, struct airspy, v4l2_dev);
 
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	dev_dbg(s->dev, "\n");
 
 	mutex_lock(&s->vb_queue_lock);
 	mutex_lock(&s->v4l2_lock);
@@ -499,7 +489,7 @@ static int airspy_queue_setup(struct vb2_queue *vq,
 {
 	struct airspy *s = vb2_get_drv_priv(vq);
 
-	dev_dbg(&s->udev->dev, "%s: *nbuffers=%d\n", __func__, *nbuffers);
+	dev_dbg(s->dev, "nbuffers=%d\n", *nbuffers);
 
 	/* Need at least 8 buffers */
 	if (vq->num_buffers + *nbuffers < 8)
@@ -507,8 +497,7 @@ static int airspy_queue_setup(struct vb2_queue *vq,
 	*nplanes = 1;
 	sizes[0] = PAGE_ALIGN(s->buffersize);
 
-	dev_dbg(&s->udev->dev, "%s: nbuffers=%d sizes[0]=%d\n",
-			__func__, *nbuffers, sizes[0]);
+	dev_dbg(s->dev, "nbuffers=%d sizes[0]=%d\n", *nbuffers, sizes[0]);
 	return 0;
 }
 
@@ -535,7 +524,7 @@ static int airspy_start_streaming(struct vb2_queue *vq, unsigned int count)
 	struct airspy *s = vb2_get_drv_priv(vq);
 	int ret;
 
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	dev_dbg(s->dev, "\n");
 
 	if (!s->udev)
 		return -ENODEV;
@@ -594,7 +583,7 @@ static void airspy_stop_streaming(struct vb2_queue *vq)
 {
 	struct airspy *s = vb2_get_drv_priv(vq);
 
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	dev_dbg(s->dev, "\n");
 
 	mutex_lock(&s->v4l2_lock);
 
@@ -626,8 +615,6 @@ static int airspy_querycap(struct file *file, void *fh,
 {
 	struct airspy *s = video_drvdata(file);
 
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
-
 	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
 	strlcpy(cap->card, s->vdev.name, sizeof(cap->card));
 	usb_make_path(s->udev, cap->bus_info, sizeof(cap->bus_info));
@@ -641,10 +628,6 @@ static int airspy_querycap(struct file *file, void *fh,
 static int airspy_enum_fmt_sdr_cap(struct file *file, void *priv,
 		struct v4l2_fmtdesc *f)
 {
-	struct airspy *s = video_drvdata(file);
-
-	dev_dbg(&s->udev->dev, "%s: index=%d\n", __func__, f->index);
-
 	if (f->index >= NUM_FORMATS)
 		return -EINVAL;
 
@@ -659,9 +642,6 @@ static int airspy_g_fmt_sdr_cap(struct file *file, void *priv,
 {
 	struct airspy *s = video_drvdata(file);
 
-	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
-			(char *)&s->pixelformat);
-
 	f->fmt.sdr.pixelformat = s->pixelformat;
 	f->fmt.sdr.buffersize = s->buffersize;
 	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
@@ -676,9 +656,6 @@ static int airspy_s_fmt_sdr_cap(struct file *file, void *priv,
 	struct vb2_queue *q = &s->vb_queue;
 	int i;
 
-	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
-			(char *)&f->fmt.sdr.pixelformat);
-
 	if (vb2_is_busy(q))
 		return -EBUSY;
 
@@ -703,12 +680,8 @@ static int airspy_s_fmt_sdr_cap(struct file *file, void *priv,
 static int airspy_try_fmt_sdr_cap(struct file *file, void *priv,
 		struct v4l2_format *f)
 {
-	struct airspy *s = video_drvdata(file);
 	int i;
 
-	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
-			(char *)&f->fmt.sdr.pixelformat);
-
 	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
 	for (i = 0; i < NUM_FORMATS; i++) {
 		if (formats[i].pixelformat == f->fmt.sdr.pixelformat) {
@@ -726,11 +699,8 @@ static int airspy_try_fmt_sdr_cap(struct file *file, void *priv,
 static int airspy_s_tuner(struct file *file, void *priv,
 		const struct v4l2_tuner *v)
 {
-	struct airspy *s = video_drvdata(file);
 	int ret;
 
-	dev_dbg(&s->udev->dev, "%s: index=%d\n", __func__, v->index);
-
 	if (v->index == 0)
 		ret = 0;
 	else if (v->index == 1)
@@ -743,11 +713,8 @@ static int airspy_s_tuner(struct file *file, void *priv,
 
 static int airspy_g_tuner(struct file *file, void *priv, struct v4l2_tuner *v)
 {
-	struct airspy *s = video_drvdata(file);
 	int ret;
 
-	dev_dbg(&s->udev->dev, "%s: index=%d\n", __func__, v->index);
-
 	if (v->index == 0) {
 		strlcpy(v->name, "AirSpy ADC", sizeof(v->name));
 		v->type = V4L2_TUNER_ADC;
@@ -773,18 +740,18 @@ static int airspy_g_frequency(struct file *file, void *priv,
 		struct v4l2_frequency *f)
 {
 	struct airspy *s = video_drvdata(file);
-	int ret  = 0;
-
-	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d\n",
-			__func__, f->tuner, f->type);
+	int ret;
 
 	if (f->tuner == 0) {
 		f->type = V4L2_TUNER_ADC;
 		f->frequency = s->f_adc;
+		dev_dbg(s->dev, "ADC frequency=%u Hz\n", s->f_adc);
 		ret = 0;
 	} else if (f->tuner == 1) {
 		f->type = V4L2_TUNER_RF;
 		f->frequency = s->f_rf;
+		dev_dbg(s->dev, "RF frequency=%u Hz\n", s->f_rf);
+		ret = 0;
 	} else {
 		ret = -EINVAL;
 	}
@@ -799,22 +766,17 @@ static int airspy_s_frequency(struct file *file, void *priv,
 	int ret;
 	u8 buf[4];
 
-	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d frequency=%u\n",
-			__func__, f->tuner, f->type, f->frequency);
-
 	if (f->tuner == 0) {
 		s->f_adc = clamp_t(unsigned int, f->frequency,
 				bands[0].rangelow,
 				bands[0].rangehigh);
-		dev_dbg(&s->udev->dev, "%s: ADC frequency=%u Hz\n",
-				__func__, s->f_adc);
+		dev_dbg(s->dev, "ADC frequency=%u Hz\n", s->f_adc);
 		ret = 0;
 	} else if (f->tuner == 1) {
 		s->f_rf = clamp_t(unsigned int, f->frequency,
 				bands_rf[0].rangelow,
 				bands_rf[0].rangehigh);
-		dev_dbg(&s->udev->dev, "%s: RF frequency=%u Hz\n",
-				__func__, s->f_rf);
+		dev_dbg(s->dev, "RF frequency=%u Hz\n", s->f_rf);
 		buf[0] = (s->f_rf >>  0) & 0xff;
 		buf[1] = (s->f_rf >>  8) & 0xff;
 		buf[2] = (s->f_rf >> 16) & 0xff;
@@ -830,12 +792,8 @@ static int airspy_s_frequency(struct file *file, void *priv,
 static int airspy_enum_freq_bands(struct file *file, void *priv,
 		struct v4l2_frequency_band *band)
 {
-	struct airspy *s = video_drvdata(file);
 	int ret;
 
-	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d index=%d\n",
-			__func__, band->tuner, band->type, band->index);
-
 	if (band->tuner == 0) {
 		if (band->index >= ARRAY_SIZE(bands)) {
 			ret = -EINVAL;
@@ -918,10 +876,9 @@ static int airspy_set_lna_gain(struct airspy *s)
 	int ret;
 	u8 u8tmp;
 
-	dev_dbg(&s->udev->dev, "%s: lna auto=%d->%d val=%d->%d\n",
-			__func__, s->lna_gain_auto->cur.val,
-			s->lna_gain_auto->val, s->lna_gain->cur.val,
-			s->lna_gain->val);
+	dev_dbg(s->dev, "lna auto=%d->%d val=%d->%d\n",
+			s->lna_gain_auto->cur.val, s->lna_gain_auto->val,
+			s->lna_gain->cur.val, s->lna_gain->val);
 
 	ret = airspy_ctrl_msg(s, CMD_SET_LNA_AGC, 0, s->lna_gain_auto->val,
 			&u8tmp, 1);
@@ -936,7 +893,7 @@ static int airspy_set_lna_gain(struct airspy *s)
 	}
 err:
 	if (ret)
-		dev_dbg(&s->udev->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(s->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -946,10 +903,9 @@ static int airspy_set_mixer_gain(struct airspy *s)
 	int ret;
 	u8 u8tmp;
 
-	dev_dbg(&s->udev->dev, "%s: mixer auto=%d->%d val=%d->%d\n",
-			__func__, s->mixer_gain_auto->cur.val,
-			s->mixer_gain_auto->val, s->mixer_gain->cur.val,
-			s->mixer_gain->val);
+	dev_dbg(s->dev, "mixer auto=%d->%d val=%d->%d\n",
+			s->mixer_gain_auto->cur.val, s->mixer_gain_auto->val,
+			s->mixer_gain->cur.val, s->mixer_gain->val);
 
 	ret = airspy_ctrl_msg(s, CMD_SET_MIXER_AGC, 0, s->mixer_gain_auto->val,
 			&u8tmp, 1);
@@ -964,7 +920,7 @@ static int airspy_set_mixer_gain(struct airspy *s)
 	}
 err:
 	if (ret)
-		dev_dbg(&s->udev->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(s->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -974,8 +930,7 @@ static int airspy_set_if_gain(struct airspy *s)
 	int ret;
 	u8 u8tmp;
 
-	dev_dbg(&s->udev->dev, "%s: val=%d->%d\n",
-			__func__, s->if_gain->cur.val, s->if_gain->val);
+	dev_dbg(s->dev, "val=%d->%d\n", s->if_gain->cur.val, s->if_gain->val);
 
 	ret = airspy_ctrl_msg(s, CMD_SET_VGA_GAIN, 0, s->if_gain->val,
 			&u8tmp, 1);
@@ -983,7 +938,7 @@ static int airspy_set_if_gain(struct airspy *s)
 		goto err;
 err:
 	if (ret)
-		dev_dbg(&s->udev->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(s->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -1006,8 +961,8 @@ static int airspy_s_ctrl(struct v4l2_ctrl *ctrl)
 		ret = airspy_set_if_gain(s);
 		break;
 	default:
-		dev_dbg(&s->udev->dev, "%s: unknown ctrl: id=%d name=%s\n",
-				__func__, ctrl->id, ctrl->name);
+		dev_dbg(s->dev, "unknown ctrl: id=%d name=%s\n",
+				ctrl->id, ctrl->name);
 		ret = -EINVAL;
 	}
 
@@ -1021,15 +976,13 @@ static const struct v4l2_ctrl_ops airspy_ctrl_ops = {
 static int airspy_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	struct usb_device *udev = interface_to_usbdev(intf);
-	struct airspy *s = NULL;
+	struct airspy *s;
 	int ret;
 	u8 u8tmp, buf[BUF_SIZE];
 
 	s = kzalloc(sizeof(struct airspy), GFP_KERNEL);
 	if (s == NULL) {
-		dev_err(&udev->dev,
-				"Could not allocate memory for airspy state\n");
+		dev_err(&intf->dev, "Could not allocate memory for state\n");
 		return -ENOMEM;
 	}
 
@@ -1037,7 +990,8 @@ static int airspy_probe(struct usb_interface *intf,
 	mutex_init(&s->vb_queue_lock);
 	spin_lock_init(&s->queued_bufs_lock);
 	INIT_LIST_HEAD(&s->queued_bufs);
-	s->udev = udev;
+	s->dev = &intf->dev;
+	s->udev = interface_to_usbdev(intf);
 	s->f_adc = bands[0].rangelow;
 	s->f_rf = bands_rf[0].rangelow;
 	s->pixelformat = formats[0].pixelformat;
@@ -1049,14 +1003,14 @@ static int airspy_probe(struct usb_interface *intf,
 		ret = airspy_ctrl_msg(s, CMD_VERSION_STRING_READ, 0, 0,
 				buf, BUF_SIZE);
 	if (ret) {
-		dev_err(&s->udev->dev, "Could not detect board\n");
+		dev_err(s->dev, "Could not detect board\n");
 		goto err_free_mem;
 	}
 
 	buf[BUF_SIZE - 1] = '\0';
 
-	dev_info(&s->udev->dev, "Board ID: %02x\n", u8tmp);
-	dev_info(&s->udev->dev, "Firmware version: %s\n", buf);
+	dev_info(s->dev, "Board ID: %02x\n", u8tmp);
+	dev_info(s->dev, "Firmware version: %s\n", buf);
 
 	/* Init videobuf2 queue structure */
 	s->vb_queue.type = V4L2_BUF_TYPE_SDR_CAPTURE;
@@ -1068,7 +1022,7 @@ static int airspy_probe(struct usb_interface *intf,
 	s->vb_queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	ret = vb2_queue_init(&s->vb_queue);
 	if (ret) {
-		dev_err(&s->udev->dev, "Could not initialize vb2 queue\n");
+		dev_err(s->dev, "Could not initialize vb2 queue\n");
 		goto err_free_mem;
 	}
 
@@ -1082,8 +1036,7 @@ static int airspy_probe(struct usb_interface *intf,
 	s->v4l2_dev.release = airspy_video_release;
 	ret = v4l2_device_register(&intf->dev, &s->v4l2_dev);
 	if (ret) {
-		dev_err(&s->udev->dev,
-				"Failed to register v4l2-device (%d)\n", ret);
+		dev_err(s->dev, "Failed to register v4l2-device (%d)\n", ret);
 		goto err_free_mem;
 	}
 
@@ -1103,7 +1056,7 @@ static int airspy_probe(struct usb_interface *intf,
 			V4L2_CID_RF_TUNER_IF_GAIN, 0, 15, 1, 0);
 	if (s->hdl.error) {
 		ret = s->hdl.error;
-		dev_err(&s->udev->dev, "Could not initialize controls\n");
+		dev_err(s->dev, "Could not initialize controls\n");
 		goto err_free_controls;
 	}
 
@@ -1115,16 +1068,13 @@ static int airspy_probe(struct usb_interface *intf,
 
 	ret = video_register_device(&s->vdev, VFL_TYPE_SDR, -1);
 	if (ret) {
-		dev_err(&s->udev->dev,
-				"Failed to register as video device (%d)\n",
+		dev_err(s->dev, "Failed to register as video device (%d)\n",
 				ret);
 		goto err_unregister_v4l2_dev;
 	}
-	dev_info(&s->udev->dev, "Registered as %s\n",
+	dev_info(s->dev, "Registered as %s\n",
 			video_device_node_name(&s->vdev));
-	dev_notice(&s->udev->dev,
-			"%s: SDR API is still slightly experimental and functionality changes may follow\n",
-			KBUILD_MODNAME);
+	dev_notice(s->dev, "SDR API is still slightly experimental and functionality changes may follow\n");
 	return 0;
 
 err_free_controls:
-- 
http://palosaari.fi/

