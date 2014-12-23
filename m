Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51387 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756658AbaLWUug (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:36 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 49/66] rtl2832_sdr: fix logging
Date: Tue, 23 Dec 2014 22:49:42 +0200
Message-Id: <1419367799-14263-49-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pass correct device, platform device, for logging system in order
to format printouts correctly.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832_sdr.c | 151 +++++++++++++++++-------------
 1 file changed, 86 insertions(+), 65 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index 6c5b294..361b1eb7 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -224,6 +224,7 @@ leave:
 static unsigned int rtl2832_sdr_convert_stream(struct rtl2832_sdr_dev *dev,
 		void *dst, const u8 *src, unsigned int src_len)
 {
+	struct platform_device *pdev = dev->pdev;
 	unsigned int dst_len;
 
 	if (dev->pixelformat ==  V4L2_SDR_FMT_CU8) {
@@ -251,10 +252,9 @@ static unsigned int rtl2832_sdr_convert_stream(struct rtl2832_sdr_dev *dev,
 
 		dev->jiffies_next = jiffies + msecs_to_jiffies(MSECS);
 		dev->sample_measured = dev->sample;
-		dev_dbg(&dev->udev->dev,
-				"slen=%u samples=%u msecs=%u sample rate=%lu\n",
-				src_len, samples, msecs,
-				samples * 1000UL / msecs);
+		dev_dbg(&pdev->dev,
+			"slen=%u samples=%u msecs=%u sample rate=%lu\n",
+			src_len, samples, msecs, samples * 1000UL / msecs);
 	}
 
 	/* total number of I+Q pairs */
@@ -270,12 +270,12 @@ static unsigned int rtl2832_sdr_convert_stream(struct rtl2832_sdr_dev *dev,
 static void rtl2832_sdr_urb_complete(struct urb *urb)
 {
 	struct rtl2832_sdr_dev *dev = urb->context;
+	struct platform_device *pdev = dev->pdev;
 	struct rtl2832_sdr_frame_buf *fbuf;
 
-	dev_dbg_ratelimited(&dev->udev->dev,
-			"status=%d length=%d/%d errors=%d\n",
-			urb->status, urb->actual_length,
-			urb->transfer_buffer_length, urb->error_count);
+	dev_dbg_ratelimited(&pdev->dev, "status=%d length=%d/%d errors=%d\n",
+			    urb->status, urb->actual_length,
+			    urb->transfer_buffer_length, urb->error_count);
 
 	switch (urb->status) {
 	case 0:             /* success */
@@ -286,8 +286,7 @@ static void rtl2832_sdr_urb_complete(struct urb *urb)
 	case -ESHUTDOWN:
 		return;
 	default:            /* error */
-		dev_err_ratelimited(&dev->udev->dev, "urb failed=%d\n",
-				urb->status);
+		dev_err_ratelimited(&pdev->dev, "urb failed=%d\n", urb->status);
 		break;
 	}
 
@@ -298,9 +297,9 @@ static void rtl2832_sdr_urb_complete(struct urb *urb)
 		fbuf = rtl2832_sdr_get_next_fill_buf(dev);
 		if (unlikely(fbuf == NULL)) {
 			dev->vb_full++;
-			dev_notice_ratelimited(&dev->udev->dev,
-					"videobuf is full, %d packets dropped\n",
-					dev->vb_full);
+			dev_notice_ratelimited(&pdev->dev,
+					       "videobuf is full, %d packets dropped\n",
+					       dev->vb_full);
 			goto skip;
 		}
 
@@ -319,10 +318,11 @@ skip:
 
 static int rtl2832_sdr_kill_urbs(struct rtl2832_sdr_dev *dev)
 {
+	struct platform_device *pdev = dev->pdev;
 	int i;
 
 	for (i = dev->urbs_submitted - 1; i >= 0; i--) {
-		dev_dbg(&dev->udev->dev, "kill urb=%d\n", i);
+		dev_dbg(&pdev->dev, "kill urb=%d\n", i);
 		/* stop the URB */
 		usb_kill_urb(dev->urb_list[i]);
 	}
@@ -333,15 +333,16 @@ static int rtl2832_sdr_kill_urbs(struct rtl2832_sdr_dev *dev)
 
 static int rtl2832_sdr_submit_urbs(struct rtl2832_sdr_dev *dev)
 {
+	struct platform_device *pdev = dev->pdev;
 	int i, ret;
 
 	for (i = 0; i < dev->urbs_initialized; i++) {
-		dev_dbg(&dev->udev->dev, "submit urb=%d\n", i);
+		dev_dbg(&pdev->dev, "submit urb=%d\n", i);
 		ret = usb_submit_urb(dev->urb_list[i], GFP_ATOMIC);
 		if (ret) {
-			dev_err(&dev->udev->dev,
-					"Could not submit urb no. %d - get them all back\n",
-					i);
+			dev_err(&pdev->dev,
+				"Could not submit urb no. %d - get them all back\n",
+				i);
 			rtl2832_sdr_kill_urbs(dev);
 			return ret;
 		}
@@ -353,10 +354,11 @@ static int rtl2832_sdr_submit_urbs(struct rtl2832_sdr_dev *dev)
 
 static int rtl2832_sdr_free_stream_bufs(struct rtl2832_sdr_dev *dev)
 {
+	struct platform_device *pdev = dev->pdev;
 	if (dev->flags & USB_STATE_URB_BUF) {
 		while (dev->buf_num) {
 			dev->buf_num--;
-			dev_dbg(&dev->udev->dev, "free buf=%d\n", dev->buf_num);
+			dev_dbg(&pdev->dev, "free buf=%d\n", dev->buf_num);
 			usb_free_coherent(dev->udev, dev->buf_size,
 					  dev->buf_list[dev->buf_num],
 					  dev->dma_addr[dev->buf_num]);
@@ -369,26 +371,27 @@ static int rtl2832_sdr_free_stream_bufs(struct rtl2832_sdr_dev *dev)
 
 static int rtl2832_sdr_alloc_stream_bufs(struct rtl2832_sdr_dev *dev)
 {
+	struct platform_device *pdev = dev->pdev;
 	dev->buf_num = 0;
 	dev->buf_size = BULK_BUFFER_SIZE;
 
-	dev_dbg(&dev->udev->dev, "all in all I will use %u bytes for streaming\n",
-			MAX_BULK_BUFS * BULK_BUFFER_SIZE);
+	dev_dbg(&pdev->dev, "all in all I will use %u bytes for streaming\n",
+		MAX_BULK_BUFS * BULK_BUFFER_SIZE);
 
 	for (dev->buf_num = 0; dev->buf_num < MAX_BULK_BUFS; dev->buf_num++) {
 		dev->buf_list[dev->buf_num] = usb_alloc_coherent(dev->udev,
 				BULK_BUFFER_SIZE, GFP_ATOMIC,
 				&dev->dma_addr[dev->buf_num]);
 		if (!dev->buf_list[dev->buf_num]) {
-			dev_dbg(&dev->udev->dev, "alloc buf=%d failed\n",
-					dev->buf_num);
+			dev_dbg(&pdev->dev, "alloc buf=%d failed\n",
+				dev->buf_num);
 			rtl2832_sdr_free_stream_bufs(dev);
 			return -ENOMEM;
 		}
 
-		dev_dbg(&dev->udev->dev, "alloc buf=%d %p (dma %llu)\n",
-				dev->buf_num, dev->buf_list[dev->buf_num],
-				(long long)dev->dma_addr[dev->buf_num]);
+		dev_dbg(&pdev->dev, "alloc buf=%d %p (dma %llu)\n",
+			dev->buf_num, dev->buf_list[dev->buf_num],
+			(long long)dev->dma_addr[dev->buf_num]);
 		dev->flags |= USB_STATE_URB_BUF;
 	}
 
@@ -397,13 +400,14 @@ static int rtl2832_sdr_alloc_stream_bufs(struct rtl2832_sdr_dev *dev)
 
 static int rtl2832_sdr_free_urbs(struct rtl2832_sdr_dev *dev)
 {
+	struct platform_device *pdev = dev->pdev;
 	int i;
 
 	rtl2832_sdr_kill_urbs(dev);
 
 	for (i = dev->urbs_initialized - 1; i >= 0; i--) {
 		if (dev->urb_list[i]) {
-			dev_dbg(&dev->udev->dev, "free urb=%d\n", i);
+			dev_dbg(&pdev->dev, "free urb=%d\n", i);
 			/* free the URBs */
 			usb_free_urb(dev->urb_list[i]);
 		}
@@ -415,14 +419,15 @@ static int rtl2832_sdr_free_urbs(struct rtl2832_sdr_dev *dev)
 
 static int rtl2832_sdr_alloc_urbs(struct rtl2832_sdr_dev *dev)
 {
+	struct platform_device *pdev = dev->pdev;
 	int i, j;
 
 	/* allocate the URBs */
 	for (i = 0; i < MAX_BULK_BUFS; i++) {
-		dev_dbg(&dev->udev->dev, "alloc urb=%d\n", i);
+		dev_dbg(&pdev->dev, "alloc urb=%d\n", i);
 		dev->urb_list[i] = usb_alloc_urb(0, GFP_ATOMIC);
 		if (!dev->urb_list[i]) {
-			dev_dbg(&dev->udev->dev, "failed\n");
+			dev_dbg(&pdev->dev, "failed\n");
 			for (j = 0; j < i; j++)
 				usb_free_urb(dev->urb_list[j]);
 			return -ENOMEM;
@@ -445,9 +450,10 @@ static int rtl2832_sdr_alloc_urbs(struct rtl2832_sdr_dev *dev)
 /* Must be called with vb_queue_lock hold */
 static void rtl2832_sdr_cleanup_queued_bufs(struct rtl2832_sdr_dev *dev)
 {
+	struct platform_device *pdev = dev->pdev;
 	unsigned long flags;
 
-	dev_dbg(&dev->udev->dev, "\n");
+	dev_dbg(&pdev->dev, "\n");
 
 	spin_lock_irqsave(&dev->queued_bufs_lock, flags);
 	while (!list_empty(&dev->queued_bufs)) {
@@ -465,8 +471,9 @@ static int rtl2832_sdr_querycap(struct file *file, void *fh,
 		struct v4l2_capability *cap)
 {
 	struct rtl2832_sdr_dev *dev = video_drvdata(file);
+	struct platform_device *pdev = dev->pdev;
 
-	dev_dbg(&dev->udev->dev, "\n");
+	dev_dbg(&pdev->dev, "\n");
 
 	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
 	strlcpy(cap->card, dev->vdev.name, sizeof(cap->card));
@@ -483,16 +490,16 @@ static int rtl2832_sdr_queue_setup(struct vb2_queue *vq,
 		unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct rtl2832_sdr_dev *dev = vb2_get_drv_priv(vq);
+	struct platform_device *pdev = dev->pdev;
 
-	dev_dbg(&dev->udev->dev, "nbuffers=%d\n", *nbuffers);
+	dev_dbg(&pdev->dev, "nbuffers=%d\n", *nbuffers);
 
 	/* Need at least 8 buffers */
 	if (vq->num_buffers + *nbuffers < 8)
 		*nbuffers = 8 - vq->num_buffers;
 	*nplanes = 1;
 	sizes[0] = PAGE_ALIGN(dev->buffersize);
-	dev_dbg(&dev->udev->dev, "nbuffers=%d sizes[0]=%d\n",
-			*nbuffers, sizes[0]);
+	dev_dbg(&pdev->dev, "nbuffers=%d sizes[0]=%d\n", *nbuffers, sizes[0]);
 	return 0;
 }
 
@@ -536,7 +543,7 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_dev *dev)
 	u64 u64tmp;
 	u32 u32tmp;
 
-	dev_dbg(&dev->udev->dev, "f_adc=%u\n", dev->f_adc);
+	dev_dbg(&pdev->dev, "f_adc=%u\n", dev->f_adc);
 
 	if (!test_bit(POWER_ON, &dev->flags))
 		return 0;
@@ -570,7 +577,7 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_dev *dev)
 	u64tmp = -u64tmp;
 	u32tmp = u64tmp & 0x3fffff;
 
-	dev_dbg(&dev->udev->dev, "f_if=%u if_ctl=%08x\n", f_if, u32tmp);
+	dev_dbg(&pdev->dev, "f_if=%u if_ctl=%08x\n", f_if, u32tmp);
 
 	buf[0] = (u32tmp >> 16) & 0xff;
 	buf[1] = (u32tmp >>  8) & 0xff;
@@ -739,7 +746,7 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_dev *dev)
 		ret = rtl2832_sdr_wr_regs(dev, 0x011, "\xf4", 1);
 		break;
 	default:
-		dev_notice(&dev->udev->dev, "Unsupported tuner\n");
+		dev_notice(&pdev->dev, "Unsupported tuner\n");
 	}
 
 	/* software reset */
@@ -756,9 +763,10 @@ err:
 
 static void rtl2832_sdr_unset_adc(struct rtl2832_sdr_dev *dev)
 {
+	struct platform_device *pdev = dev->pdev;
 	int ret;
 
-	dev_dbg(&dev->udev->dev, "\n");
+	dev_dbg(&pdev->dev, "\n");
 
 	/* PID filter */
 	ret = rtl2832_sdr_wr_regs(dev, 0x061, "\xe0", 1);
@@ -792,6 +800,7 @@ err:
 
 static int rtl2832_sdr_set_tuner_freq(struct rtl2832_sdr_dev *dev)
 {
+	struct platform_device *pdev = dev->pdev;
 	struct dvb_frontend *fe = dev->fe;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct v4l2_ctrl *bandwidth_auto;
@@ -819,8 +828,8 @@ static int rtl2832_sdr_set_tuner_freq(struct rtl2832_sdr_dev *dev)
 	c->frequency = dev->f_tuner;
 	c->delivery_system = SYS_DVBT;
 
-	dev_dbg(&dev->udev->dev, "frequency=%u bandwidth=%d\n",
-			c->frequency, c->bandwidth_hz);
+	dev_dbg(&pdev->dev, "frequency=%u bandwidth=%d\n",
+		c->frequency, c->bandwidth_hz);
 
 	if (!test_bit(POWER_ON, &dev->flags))
 		return 0;
@@ -833,9 +842,10 @@ static int rtl2832_sdr_set_tuner_freq(struct rtl2832_sdr_dev *dev)
 
 static int rtl2832_sdr_set_tuner(struct rtl2832_sdr_dev *dev)
 {
+	struct platform_device *pdev = dev->pdev;
 	struct dvb_frontend *fe = dev->fe;
 
-	dev_dbg(&dev->udev->dev, "\n");
+	dev_dbg(&pdev->dev, "\n");
 
 	if (fe->ops.tuner_ops.init)
 		fe->ops.tuner_ops.init(fe);
@@ -845,9 +855,10 @@ static int rtl2832_sdr_set_tuner(struct rtl2832_sdr_dev *dev)
 
 static void rtl2832_sdr_unset_tuner(struct rtl2832_sdr_dev *dev)
 {
+	struct platform_device *pdev = dev->pdev;
 	struct dvb_frontend *fe = dev->fe;
 
-	dev_dbg(&dev->udev->dev, "\n");
+	dev_dbg(&pdev->dev, "\n");
 
 	if (fe->ops.tuner_ops.sleep)
 		fe->ops.tuner_ops.sleep(fe);
@@ -858,9 +869,10 @@ static void rtl2832_sdr_unset_tuner(struct rtl2832_sdr_dev *dev)
 static int rtl2832_sdr_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct rtl2832_sdr_dev *dev = vb2_get_drv_priv(vq);
+	struct platform_device *pdev = dev->pdev;
 	int ret;
 
-	dev_dbg(&dev->udev->dev, "\n");
+	dev_dbg(&pdev->dev, "\n");
 
 	if (!dev->udev)
 		return -ENODEV;
@@ -912,8 +924,9 @@ err:
 static void rtl2832_sdr_stop_streaming(struct vb2_queue *vq)
 {
 	struct rtl2832_sdr_dev *dev = vb2_get_drv_priv(vq);
+	struct platform_device *pdev = dev->pdev;
 
-	dev_dbg(&dev->udev->dev, "\n");
+	dev_dbg(&pdev->dev, "\n");
 
 	mutex_lock(&dev->v4l2_lock);
 
@@ -950,8 +963,9 @@ static int rtl2832_sdr_g_tuner(struct file *file, void *priv,
 		struct v4l2_tuner *v)
 {
 	struct rtl2832_sdr_dev *dev = video_drvdata(file);
+	struct platform_device *pdev = dev->pdev;
 
-	dev_dbg(&dev->udev->dev, "index=%d type=%d\n", v->index, v->type);
+	dev_dbg(&pdev->dev, "index=%d type=%d\n", v->index, v->type);
 
 	if (v->index == 0) {
 		strlcpy(v->name, "ADC: Realtek RTL2832", sizeof(v->name));
@@ -976,8 +990,9 @@ static int rtl2832_sdr_s_tuner(struct file *file, void *priv,
 		const struct v4l2_tuner *v)
 {
 	struct rtl2832_sdr_dev *dev = video_drvdata(file);
+	struct platform_device *pdev = dev->pdev;
 
-	dev_dbg(&dev->udev->dev, "\n");
+	dev_dbg(&pdev->dev, "\n");
 
 	if (v->index > 1)
 		return -EINVAL;
@@ -988,9 +1003,10 @@ static int rtl2832_sdr_enum_freq_bands(struct file *file, void *priv,
 		struct v4l2_frequency_band *band)
 {
 	struct rtl2832_sdr_dev *dev = video_drvdata(file);
+	struct platform_device *pdev = dev->pdev;
 
-	dev_dbg(&dev->udev->dev, "tuner=%d type=%d index=%d\n",
-			band->tuner, band->type, band->index);
+	dev_dbg(&pdev->dev, "tuner=%d type=%d index=%d\n",
+		band->tuner, band->type, band->index);
 
 	if (band->tuner == 0) {
 		if (band->index >= ARRAY_SIZE(bands_adc))
@@ -1013,10 +1029,10 @@ static int rtl2832_sdr_g_frequency(struct file *file, void *priv,
 		struct v4l2_frequency *f)
 {
 	struct rtl2832_sdr_dev *dev = video_drvdata(file);
+	struct platform_device *pdev = dev->pdev;
 	int ret  = 0;
 
-	dev_dbg(&dev->udev->dev, "tuner=%d type=%d\n",
-			f->tuner, f->type);
+	dev_dbg(&pdev->dev, "tuner=%d type=%d\n", f->tuner, f->type);
 
 	if (f->tuner == 0) {
 		f->frequency = dev->f_adc;
@@ -1035,10 +1051,11 @@ static int rtl2832_sdr_s_frequency(struct file *file, void *priv,
 		const struct v4l2_frequency *f)
 {
 	struct rtl2832_sdr_dev *dev = video_drvdata(file);
+	struct platform_device *pdev = dev->pdev;
 	int ret, band;
 
-	dev_dbg(&dev->udev->dev, "tuner=%d type=%d frequency=%u\n",
-			f->tuner, f->type, f->frequency);
+	dev_dbg(&pdev->dev, "tuner=%d type=%d frequency=%u\n",
+		f->tuner, f->type, f->frequency);
 
 	/* ADC band midpoints */
 	#define BAND_ADC_0 ((bands_adc[0].rangehigh + bands_adc[1].rangelow) / 2)
@@ -1056,13 +1073,13 @@ static int rtl2832_sdr_s_frequency(struct file *file, void *priv,
 				bands_adc[band].rangelow,
 				bands_adc[band].rangehigh);
 
-		dev_dbg(&dev->udev->dev, "ADC frequency=%u Hz\n", dev->f_adc);
+		dev_dbg(&pdev->dev, "ADC frequency=%u Hz\n", dev->f_adc);
 		ret = rtl2832_sdr_set_adc(dev);
 	} else if (f->tuner == 1) {
 		dev->f_tuner = clamp_t(unsigned int, f->frequency,
 				bands_fm[0].rangelow,
 				bands_fm[0].rangehigh);
-		dev_dbg(&dev->udev->dev, "RF frequency=%u Hz\n", f->frequency);
+		dev_dbg(&pdev->dev, "RF frequency=%u Hz\n", f->frequency);
 
 		ret = rtl2832_sdr_set_tuner_freq(dev);
 	} else {
@@ -1076,8 +1093,9 @@ static int rtl2832_sdr_enum_fmt_sdr_cap(struct file *file, void *priv,
 		struct v4l2_fmtdesc *f)
 {
 	struct rtl2832_sdr_dev *dev = video_drvdata(file);
+	struct platform_device *pdev = dev->pdev;
 
-	dev_dbg(&dev->udev->dev, "\n");
+	dev_dbg(&pdev->dev, "\n");
 
 	if (f->index >= dev->num_formats)
 		return -EINVAL;
@@ -1092,8 +1110,9 @@ static int rtl2832_sdr_g_fmt_sdr_cap(struct file *file, void *priv,
 		struct v4l2_format *f)
 {
 	struct rtl2832_sdr_dev *dev = video_drvdata(file);
+	struct platform_device *pdev = dev->pdev;
 
-	dev_dbg(&dev->udev->dev, "\n");
+	dev_dbg(&pdev->dev, "\n");
 
 	f->fmt.sdr.pixelformat = dev->pixelformat;
 	f->fmt.sdr.buffersize = dev->buffersize;
@@ -1107,11 +1126,12 @@ static int rtl2832_sdr_s_fmt_sdr_cap(struct file *file, void *priv,
 		struct v4l2_format *f)
 {
 	struct rtl2832_sdr_dev *dev = video_drvdata(file);
+	struct platform_device *pdev = dev->pdev;
 	struct vb2_queue *q = &dev->vb_queue;
 	int i;
 
-	dev_dbg(&dev->udev->dev, "pixelformat fourcc %4.4s\n",
-			(char *)&f->fmt.sdr.pixelformat);
+	dev_dbg(&pdev->dev, "pixelformat fourcc %4.4s\n",
+		(char *)&f->fmt.sdr.pixelformat);
 
 	if (vb2_is_busy(q))
 		return -EBUSY;
@@ -1138,10 +1158,11 @@ static int rtl2832_sdr_try_fmt_sdr_cap(struct file *file, void *priv,
 		struct v4l2_format *f)
 {
 	struct rtl2832_sdr_dev *dev = video_drvdata(file);
+	struct platform_device *pdev = dev->pdev;
 	int i;
 
-	dev_dbg(&dev->udev->dev, "pixelformat fourcc %4.4s\n",
-			(char *)&f->fmt.sdr.pixelformat);
+	dev_dbg(&pdev->dev, "pixelformat fourcc %4.4s\n",
+		(char *)&f->fmt.sdr.pixelformat);
 
 	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
 	for (i = 0; i < dev->num_formats; i++) {
@@ -1210,13 +1231,13 @@ static int rtl2832_sdr_s_ctrl(struct v4l2_ctrl *ctrl)
 			container_of(ctrl->handler, struct rtl2832_sdr_dev,
 					hdl);
 	struct dvb_frontend *fe = dev->fe;
+	struct platform_device *pdev = dev->pdev;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 
-	dev_dbg(&dev->udev->dev,
-			"id=%d name=%s val=%d min=%lld max=%lld step=%lld\n",
-			ctrl->id, ctrl->name, ctrl->val,
-			ctrl->minimum, ctrl->maximum, ctrl->step);
+	dev_dbg(&pdev->dev, "id=%d name=%s val=%d min=%lld max=%lld step=%lld\n",
+		ctrl->id, ctrl->name, ctrl->val, ctrl->minimum, ctrl->maximum,
+		ctrl->step);
 
 	switch (ctrl->id) {
 	case V4L2_CID_RF_TUNER_BANDWIDTH_AUTO:
@@ -1375,7 +1396,7 @@ static int rtl2832_sdr_probe(struct platform_device *pdev)
 
 	/* Register the v4l2_device structure */
 	dev->v4l2_dev.release = rtl2832_sdr_video_release;
-	ret = v4l2_device_register(&dev->udev->dev, &dev->v4l2_dev);
+	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to register v4l2-device %d\n", ret);
 		goto err_v4l2_ctrl_handler_free;
-- 
http://palosaari.fi/

