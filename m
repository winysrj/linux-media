Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44830 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756183AbaHYRMQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 13:12:16 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 12/12] rtl2832_sdr: logging changes
Date: Mon, 25 Aug 2014 20:11:58 +0300
Message-Id: <1408986718-3881-12-git-send-email-crope@iki.fi>
In-Reply-To: <1408986718-3881-1-git-send-email-crope@iki.fi>
References: <1408986718-3881-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove function name from debug logs. Logging system could add it
automatically.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832_sdr.c | 98 ++++++++++++++-----------------
 1 file changed, 45 insertions(+), 53 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index 4f75753..e5bc993 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -396,8 +396,8 @@ static void rtl2832_sdr_urb_complete(struct urb *urb)
 	struct rtl2832_sdr_frame_buf *fbuf;
 
 	dev_dbg_ratelimited(&s->udev->dev,
-			"%s: status=%d length=%d/%d errors=%d\n",
-			__func__, urb->status, urb->actual_length,
+			"status=%d length=%d/%d errors=%d\n",
+			urb->status, urb->actual_length,
 			urb->transfer_buffer_length, urb->error_count);
 
 	switch (urb->status) {
@@ -445,7 +445,7 @@ static int rtl2832_sdr_kill_urbs(struct rtl2832_sdr_state *s)
 	int i;
 
 	for (i = s->urbs_submitted - 1; i >= 0; i--) {
-		dev_dbg(&s->udev->dev, "%s: kill urb=%d\n", __func__, i);
+		dev_dbg(&s->udev->dev, "kill urb=%d\n", i);
 		/* stop the URB */
 		usb_kill_urb(s->urb_list[i]);
 	}
@@ -459,7 +459,7 @@ static int rtl2832_sdr_submit_urbs(struct rtl2832_sdr_state *s)
 	int i, ret;
 
 	for (i = 0; i < s->urbs_initialized; i++) {
-		dev_dbg(&s->udev->dev, "%s: submit urb=%d\n", __func__, i);
+		dev_dbg(&s->udev->dev, "submit urb=%d\n", i);
 		ret = usb_submit_urb(s->urb_list[i], GFP_ATOMIC);
 		if (ret) {
 			dev_err(&s->udev->dev,
@@ -479,8 +479,7 @@ static int rtl2832_sdr_free_stream_bufs(struct rtl2832_sdr_state *s)
 	if (s->flags & USB_STATE_URB_BUF) {
 		while (s->buf_num) {
 			s->buf_num--;
-			dev_dbg(&s->udev->dev, "%s: free buf=%d\n",
-					__func__, s->buf_num);
+			dev_dbg(&s->udev->dev, "free buf=%d\n", s->buf_num);
 			usb_free_coherent(s->udev, s->buf_size,
 					  s->buf_list[s->buf_num],
 					  s->dma_addr[s->buf_num]);
@@ -496,24 +495,22 @@ static int rtl2832_sdr_alloc_stream_bufs(struct rtl2832_sdr_state *s)
 	s->buf_num = 0;
 	s->buf_size = BULK_BUFFER_SIZE;
 
-	dev_dbg(&s->udev->dev,
-			"%s: all in all I will use %u bytes for streaming\n",
-			__func__,  MAX_BULK_BUFS * BULK_BUFFER_SIZE);
+	dev_dbg(&s->udev->dev, "all in all I will use %u bytes for streaming\n",
+			MAX_BULK_BUFS * BULK_BUFFER_SIZE);
 
 	for (s->buf_num = 0; s->buf_num < MAX_BULK_BUFS; s->buf_num++) {
 		s->buf_list[s->buf_num] = usb_alloc_coherent(s->udev,
 				BULK_BUFFER_SIZE, GFP_ATOMIC,
 				&s->dma_addr[s->buf_num]);
 		if (!s->buf_list[s->buf_num]) {
-			dev_dbg(&s->udev->dev, "%s: alloc buf=%d failed\n",
-					__func__, s->buf_num);
+			dev_dbg(&s->udev->dev, "alloc buf=%d failed\n",
+					s->buf_num);
 			rtl2832_sdr_free_stream_bufs(s);
 			return -ENOMEM;
 		}
 
-		dev_dbg(&s->udev->dev, "%s: alloc buf=%d %p (dma %llu)\n",
-				__func__, s->buf_num,
-				s->buf_list[s->buf_num],
+		dev_dbg(&s->udev->dev, "alloc buf=%d %p (dma %llu)\n",
+				s->buf_num, s->buf_list[s->buf_num],
 				(long long)s->dma_addr[s->buf_num]);
 		s->flags |= USB_STATE_URB_BUF;
 	}
@@ -529,8 +526,7 @@ static int rtl2832_sdr_free_urbs(struct rtl2832_sdr_state *s)
 
 	for (i = s->urbs_initialized - 1; i >= 0; i--) {
 		if (s->urb_list[i]) {
-			dev_dbg(&s->udev->dev, "%s: free urb=%d\n",
-					__func__, i);
+			dev_dbg(&s->udev->dev, "free urb=%d\n", i);
 			/* free the URBs */
 			usb_free_urb(s->urb_list[i]);
 		}
@@ -546,10 +542,10 @@ static int rtl2832_sdr_alloc_urbs(struct rtl2832_sdr_state *s)
 
 	/* allocate the URBs */
 	for (i = 0; i < MAX_BULK_BUFS; i++) {
-		dev_dbg(&s->udev->dev, "%s: alloc urb=%d\n", __func__, i);
+		dev_dbg(&s->udev->dev, "alloc urb=%d\n", i);
 		s->urb_list[i] = usb_alloc_urb(0, GFP_ATOMIC);
 		if (!s->urb_list[i]) {
-			dev_dbg(&s->udev->dev, "%s: failed\n", __func__);
+			dev_dbg(&s->udev->dev, "failed\n");
 			for (j = 0; j < i; j++)
 				usb_free_urb(s->urb_list[j]);
 			return -ENOMEM;
@@ -574,7 +570,7 @@ static void rtl2832_sdr_cleanup_queued_bufs(struct rtl2832_sdr_state *s)
 {
 	unsigned long flags;
 
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	dev_dbg(&s->udev->dev, "\n");
 
 	spin_lock_irqsave(&s->queued_bufs_lock, flags);
 	while (!list_empty(&s->queued_bufs)) {
@@ -593,7 +589,7 @@ static void rtl2832_sdr_release_sec(struct dvb_frontend *fe)
 {
 	struct rtl2832_sdr_state *s = fe->sec_priv;
 
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	dev_dbg(&s->udev->dev, "\n");
 
 	mutex_lock(&s->vb_queue_lock);
 	mutex_lock(&s->v4l2_lock);
@@ -615,7 +611,7 @@ static int rtl2832_sdr_querycap(struct file *file, void *fh,
 {
 	struct rtl2832_sdr_state *s = video_drvdata(file);
 
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	dev_dbg(&s->udev->dev, "\n");
 
 	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
 	strlcpy(cap->card, s->vdev.name, sizeof(cap->card));
@@ -633,15 +629,15 @@ static int rtl2832_sdr_queue_setup(struct vb2_queue *vq,
 {
 	struct rtl2832_sdr_state *s = vb2_get_drv_priv(vq);
 
-	dev_dbg(&s->udev->dev, "%s: *nbuffers=%d\n", __func__, *nbuffers);
+	dev_dbg(&s->udev->dev, "nbuffers=%d\n", *nbuffers);
 
 	/* Need at least 8 buffers */
 	if (vq->num_buffers + *nbuffers < 8)
 		*nbuffers = 8 - vq->num_buffers;
 	*nplanes = 1;
 	sizes[0] = PAGE_ALIGN(s->buffersize);
-	dev_dbg(&s->udev->dev, "%s: nbuffers=%d sizes[0]=%d\n",
-			__func__, *nbuffers, sizes[0]);
+	dev_dbg(&s->udev->dev, "nbuffers=%d sizes[0]=%d\n",
+			*nbuffers, sizes[0]);
 	return 0;
 }
 
@@ -683,7 +679,7 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_state *s)
 	u64 u64tmp;
 	u32 u32tmp;
 
-	dev_dbg(&s->udev->dev, "%s: f_adc=%u\n", __func__, s->f_adc);
+	dev_dbg(&s->udev->dev, "f_adc=%u\n", s->f_adc);
 
 	if (!test_bit(POWER_ON, &s->flags))
 		return 0;
@@ -717,8 +713,7 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_state *s)
 	u64tmp = -u64tmp;
 	u32tmp = u64tmp & 0x3fffff;
 
-	dev_dbg(&s->udev->dev, "%s: f_if=%u if_ctl=%08x\n",
-			__func__, f_if, u32tmp);
+	dev_dbg(&s->udev->dev, "f_if=%u if_ctl=%08x\n", f_if, u32tmp);
 
 	buf[0] = (u32tmp >> 16) & 0xff;
 	buf[1] = (u32tmp >>  8) & 0xff;
@@ -905,7 +900,7 @@ static void rtl2832_sdr_unset_adc(struct rtl2832_sdr_state *s)
 {
 	int ret;
 
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	dev_dbg(&s->udev->dev, "\n");
 
 	/* PID filter */
 	ret = rtl2832_sdr_wr_regs(s, 0x061, "\xe0", 1);
@@ -966,8 +961,8 @@ static int rtl2832_sdr_set_tuner_freq(struct rtl2832_sdr_state *s)
 	c->frequency = s->f_tuner;
 	c->delivery_system = SYS_DVBT;
 
-	dev_dbg(&s->udev->dev, "%s: frequency=%u bandwidth=%d\n",
-			__func__, c->frequency, c->bandwidth_hz);
+	dev_dbg(&s->udev->dev, "frequency=%u bandwidth=%d\n",
+			c->frequency, c->bandwidth_hz);
 
 	if (!test_bit(POWER_ON, &s->flags))
 		return 0;
@@ -982,7 +977,7 @@ static int rtl2832_sdr_set_tuner(struct rtl2832_sdr_state *s)
 {
 	struct dvb_frontend *fe = s->fe;
 
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	dev_dbg(&s->udev->dev, "\n");
 
 	if (fe->ops.tuner_ops.init)
 		fe->ops.tuner_ops.init(fe);
@@ -994,7 +989,7 @@ static void rtl2832_sdr_unset_tuner(struct rtl2832_sdr_state *s)
 {
 	struct dvb_frontend *fe = s->fe;
 
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	dev_dbg(&s->udev->dev, "\n");
 
 	if (fe->ops.tuner_ops.sleep)
 		fe->ops.tuner_ops.sleep(fe);
@@ -1007,7 +1002,7 @@ static int rtl2832_sdr_start_streaming(struct vb2_queue *vq, unsigned int count)
 	struct rtl2832_sdr_state *s = vb2_get_drv_priv(vq);
 	int ret;
 
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	dev_dbg(&s->udev->dev, "\n");
 
 	if (!s->udev)
 		return -ENODEV;
@@ -1056,7 +1051,7 @@ static void rtl2832_sdr_stop_streaming(struct vb2_queue *vq)
 {
 	struct rtl2832_sdr_state *s = vb2_get_drv_priv(vq);
 
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	dev_dbg(&s->udev->dev, "\n");
 
 	mutex_lock(&s->v4l2_lock);
 
@@ -1090,8 +1085,7 @@ static int rtl2832_sdr_g_tuner(struct file *file, void *priv,
 {
 	struct rtl2832_sdr_state *s = video_drvdata(file);
 
-	dev_dbg(&s->udev->dev, "%s: index=%d type=%d\n",
-			__func__, v->index, v->type);
+	dev_dbg(&s->udev->dev, "index=%d type=%d\n", v->index, v->type);
 
 	if (v->index == 0) {
 		strlcpy(v->name, "ADC: Realtek RTL2832", sizeof(v->name));
@@ -1117,7 +1111,7 @@ static int rtl2832_sdr_s_tuner(struct file *file, void *priv,
 {
 	struct rtl2832_sdr_state *s = video_drvdata(file);
 
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	dev_dbg(&s->udev->dev, "\n");
 
 	if (v->index > 1)
 		return -EINVAL;
@@ -1129,8 +1123,8 @@ static int rtl2832_sdr_enum_freq_bands(struct file *file, void *priv,
 {
 	struct rtl2832_sdr_state *s = video_drvdata(file);
 
-	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d index=%d\n",
-			__func__, band->tuner, band->type, band->index);
+	dev_dbg(&s->udev->dev, "tuner=%d type=%d index=%d\n",
+			band->tuner, band->type, band->index);
 
 	if (band->tuner == 0) {
 		if (band->index >= ARRAY_SIZE(bands_adc))
@@ -1155,8 +1149,8 @@ static int rtl2832_sdr_g_frequency(struct file *file, void *priv,
 	struct rtl2832_sdr_state *s = video_drvdata(file);
 	int ret  = 0;
 
-	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d\n",
-			__func__, f->tuner, f->type);
+	dev_dbg(&s->udev->dev, "tuner=%d type=%d\n",
+			f->tuner, f->type);
 
 	if (f->tuner == 0) {
 		f->frequency = s->f_adc;
@@ -1177,8 +1171,8 @@ static int rtl2832_sdr_s_frequency(struct file *file, void *priv,
 	struct rtl2832_sdr_state *s = video_drvdata(file);
 	int ret, band;
 
-	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d frequency=%u\n",
-			__func__, f->tuner, f->type, f->frequency);
+	dev_dbg(&s->udev->dev, "tuner=%d type=%d frequency=%u\n",
+			f->tuner, f->type, f->frequency);
 
 	/* ADC band midpoints */
 	#define BAND_ADC_0 ((bands_adc[0].rangehigh + bands_adc[1].rangelow) / 2)
@@ -1196,15 +1190,13 @@ static int rtl2832_sdr_s_frequency(struct file *file, void *priv,
 				bands_adc[band].rangelow,
 				bands_adc[band].rangehigh);
 
-		dev_dbg(&s->udev->dev, "%s: ADC frequency=%u Hz\n",
-				__func__, s->f_adc);
+		dev_dbg(&s->udev->dev, "ADC frequency=%u Hz\n", s->f_adc);
 		ret = rtl2832_sdr_set_adc(s);
 	} else if (f->tuner == 1) {
 		s->f_tuner = clamp_t(unsigned int, f->frequency,
 				bands_fm[0].rangelow,
 				bands_fm[0].rangehigh);
-		dev_dbg(&s->udev->dev, "%s: RF frequency=%u Hz\n",
-				__func__, f->frequency);
+		dev_dbg(&s->udev->dev, "RF frequency=%u Hz\n", f->frequency);
 
 		ret = rtl2832_sdr_set_tuner_freq(s);
 	} else {
@@ -1219,7 +1211,7 @@ static int rtl2832_sdr_enum_fmt_sdr_cap(struct file *file, void *priv,
 {
 	struct rtl2832_sdr_state *s = video_drvdata(file);
 
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	dev_dbg(&s->udev->dev, "\n");
 
 	if (f->index >= s->num_formats)
 		return -EINVAL;
@@ -1235,7 +1227,7 @@ static int rtl2832_sdr_g_fmt_sdr_cap(struct file *file, void *priv,
 {
 	struct rtl2832_sdr_state *s = video_drvdata(file);
 
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	dev_dbg(&s->udev->dev, "\n");
 
 	f->fmt.sdr.pixelformat = s->pixelformat;
 	f->fmt.sdr.buffersize = s->buffersize;
@@ -1252,7 +1244,7 @@ static int rtl2832_sdr_s_fmt_sdr_cap(struct file *file, void *priv,
 	struct vb2_queue *q = &s->vb_queue;
 	int i;
 
-	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
+	dev_dbg(&s->udev->dev, "pixelformat fourcc %4.4s\n",
 			(char *)&f->fmt.sdr.pixelformat);
 
 	if (vb2_is_busy(q))
@@ -1282,7 +1274,7 @@ static int rtl2832_sdr_try_fmt_sdr_cap(struct file *file, void *priv,
 	struct rtl2832_sdr_state *s = video_drvdata(file);
 	int i;
 
-	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
+	dev_dbg(&s->udev->dev, "pixelformat fourcc %4.4s\n",
 			(char *)&f->fmt.sdr.pixelformat);
 
 	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
@@ -1356,8 +1348,8 @@ static int rtl2832_sdr_s_ctrl(struct v4l2_ctrl *ctrl)
 	int ret;
 
 	dev_dbg(&s->udev->dev,
-			"%s: id=%d name=%s val=%d min=%lld max=%lld step=%lld\n",
-			__func__, ctrl->id, ctrl->name, ctrl->val,
+			"id=%d name=%s val=%d min=%lld max=%lld step=%lld\n",
+			ctrl->id, ctrl->name, ctrl->val,
 			ctrl->minimum, ctrl->maximum, ctrl->step);
 
 	switch (ctrl->id) {
-- 
http://palosaari.fi/

