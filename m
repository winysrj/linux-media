Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49161 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755473AbaHYRMP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 13:12:15 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 06/12] msi2500: logging changes
Date: Mon, 25 Aug 2014 20:11:52 +0300
Message-Id: <1408986718-3881-6-git-send-email-crope@iki.fi>
In-Reply-To: <1408986718-3881-1-git-send-email-crope@iki.fi>
References: <1408986718-3881-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kernel logging system needs pointer to usb interface device in
order to print names and bus numbers properly. There was wrong
device pointer given and log printings wasn't correct.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/msi2500/msi2500.c | 157 +++++++++++++++---------------------
 1 file changed, 66 insertions(+), 91 deletions(-)

diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index 26b1334..5e3be0e 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -120,6 +120,7 @@ struct msi2500_frame_buf {
 };
 
 struct msi2500_state {
+	struct device *dev;
 	struct video_device vdev;
 	struct v4l2_device v4l2_dev;
 	struct v4l2_subdev *v4l2_subdev;
@@ -153,7 +154,6 @@ struct msi2500_state {
 	u32 next_sample; /* for track lost packets */
 	u32 sample; /* for sample rate calc */
 	unsigned long jiffies_next;
-	unsigned int sample_ctrl_bit[4];
 };
 
 /* Private functions */
@@ -269,7 +269,7 @@ static int msi2500_convert_stream(struct msi2500_state *s, u8 *dst, u8 *src,
 		sample[i] = src[3] << 24 | src[2] << 16 | src[1] << 8 |
 				src[0] << 0;
 		if (i == 0 && s->next_sample != sample[0]) {
-			dev_dbg_ratelimited(&s->udev->dev,
+			dev_dbg_ratelimited(s->dev,
 					"%d samples lost, %d %08x:%08x\n",
 					sample[0] - s->next_sample,
 					src_len, s->next_sample, sample[0]);
@@ -279,7 +279,7 @@ static int msi2500_convert_stream(struct msi2500_state *s, u8 *dst, u8 *src,
 		 * Dump all unknown 'garbage' data - maybe we will discover
 		 * someday if there is something rational...
 		 */
-		dev_dbg_ratelimited(&s->udev->dev, "%*ph\n", 12, &src[4]);
+		dev_dbg_ratelimited(s->dev, "%*ph\n", 12, &src[4]);
 
 		src += 16; /* skip header */
 
@@ -322,8 +322,7 @@ static int msi2500_convert_stream(struct msi2500_state *s, u8 *dst, u8 *src,
 		}
 		case MSI2500_PIX_FMT_SDR_MSI2500_384: /* 384 x IQ samples */
 			/* Dump unknown 'garbage' data */
-			dev_dbg_ratelimited(&s->udev->dev,
-					"%*ph\n", 24, &src[1000]);
+			dev_dbg_ratelimited(s->dev, "%*ph\n", 24, &src[1000]);
 			memcpy(dst, src, 984);
 			src += 984 + 24;
 			dst += 984;
@@ -365,8 +364,7 @@ static int msi2500_convert_stream(struct msi2500_state *s, u8 *dst, u8 *src,
 
 		s->jiffies_next = jiffies + msecs_to_jiffies(MSECS);
 		s->sample = s->next_sample;
-		dev_dbg(&s->udev->dev,
-				"size=%u samples=%u msecs=%u sample rate=%lu\n",
+		dev_dbg(s->dev, "size=%u samples=%u msecs=%u sample rate=%lu\n",
 				src_len, samples, msecs,
 				samples * 1000UL / msecs);
 	}
@@ -387,19 +385,16 @@ static void msi2500_isoc_handler(struct urb *urb)
 
 	if (unlikely(urb->status == -ENOENT || urb->status == -ECONNRESET ||
 			urb->status == -ESHUTDOWN)) {
-		dev_dbg(&s->udev->dev, "URB (%p) unlinked %ssynchronuously\n",
+		dev_dbg(s->dev, "URB (%p) unlinked %ssynchronuously\n",
 				urb, urb->status == -ENOENT ? "" : "a");
 		return;
 	}
 
 	if (unlikely(urb->status != 0)) {
-		dev_dbg(&s->udev->dev,
-				"msi2500_isoc_handler() called with status %d\n",
-				urb->status);
+		dev_dbg(s->dev, "called with status %d\n", urb->status);
 		/* Give up after a number of contiguous errors */
 		if (++s->isoc_errors > MAX_ISOC_ERRORS)
-			dev_dbg(&s->udev->dev,
-					"Too many ISOC errors, bailing out\n");
+			dev_dbg(s->dev, "Too many ISOC errors, bailing out\n");
 		goto handler_end;
 	} else {
 		/* Reset ISOC error counter. We did get here, after all. */
@@ -413,7 +408,7 @@ static void msi2500_isoc_handler(struct urb *urb)
 		/* Check frame error */
 		fstatus = urb->iso_frame_desc[i].status;
 		if (unlikely(fstatus)) {
-			dev_dbg_ratelimited(&s->udev->dev,
+			dev_dbg_ratelimited(s->dev,
 					"frame=%d/%d has error %d skipping\n",
 					i, urb->number_of_packets, fstatus);
 			continue;
@@ -430,7 +425,7 @@ static void msi2500_isoc_handler(struct urb *urb)
 		fbuf = msi2500_get_next_fill_buf(s);
 		if (unlikely(fbuf == NULL)) {
 			s->vb_full++;
-			dev_dbg_ratelimited(&s->udev->dev,
+			dev_dbg_ratelimited(s->dev,
 					"videobuf is full, %d packets dropped\n",
 					s->vb_full);
 			continue;
@@ -446,22 +441,19 @@ static void msi2500_isoc_handler(struct urb *urb)
 handler_end:
 	i = usb_submit_urb(urb, GFP_ATOMIC);
 	if (unlikely(i != 0))
-		dev_dbg(&s->udev->dev,
-				"Error (%d) re-submitting urb in msi2500_isoc_handler\n",
-				i);
+		dev_dbg(s->dev, "Error (%d) re-submitting urb\n", i);
 }
 
 static void msi2500_iso_stop(struct msi2500_state *s)
 {
 	int i;
 
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	dev_dbg(s->dev, "\n");
 
 	/* Unlinking ISOC buffers one by one */
 	for (i = 0; i < MAX_ISO_BUFS; i++) {
 		if (s->urbs[i]) {
-			dev_dbg(&s->udev->dev, "Unlinking URB %p\n",
-					s->urbs[i]);
+			dev_dbg(s->dev, "Unlinking URB %p\n", s->urbs[i]);
 			usb_kill_urb(s->urbs[i]);
 		}
 	}
@@ -471,12 +463,12 @@ static void msi2500_iso_free(struct msi2500_state *s)
 {
 	int i;
 
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	dev_dbg(s->dev, "\n");
 
 	/* Freeing ISOC buffers one by one */
 	for (i = 0; i < MAX_ISO_BUFS; i++) {
 		if (s->urbs[i]) {
-			dev_dbg(&s->udev->dev, "Freeing URB\n");
+			dev_dbg(s->dev, "Freeing URB\n");
 			if (s->urbs[i]->transfer_buffer) {
 				usb_free_coherent(s->udev,
 					s->urbs[i]->transfer_buffer_length,
@@ -492,7 +484,7 @@ static void msi2500_iso_free(struct msi2500_state *s)
 /* Both v4l2_lock and vb_queue_lock should be locked when calling this */
 static void msi2500_isoc_cleanup(struct msi2500_state *s)
 {
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	dev_dbg(s->dev, "\n");
 
 	msi2500_iso_stop(s);
 	msi2500_iso_free(s);
@@ -505,7 +497,7 @@ static int msi2500_isoc_init(struct msi2500_state *s)
 	struct urb *urb;
 	int i, j, ret;
 
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	dev_dbg(s->dev, "\n");
 
 	s->isoc_errors = 0;
 	udev = s->udev;
@@ -518,13 +510,12 @@ static int msi2500_isoc_init(struct msi2500_state *s)
 	for (i = 0; i < MAX_ISO_BUFS; i++) {
 		urb = usb_alloc_urb(ISO_FRAMES_PER_DESC, GFP_KERNEL);
 		if (urb == NULL) {
-			dev_err(&s->udev->dev,
-					"Failed to allocate urb %d\n", i);
+			dev_err(s->dev, "Failed to allocate urb %d\n", i);
 			msi2500_isoc_cleanup(s);
 			return -ENOMEM;
 		}
 		s->urbs[i] = urb;
-		dev_dbg(&s->udev->dev, "Allocated URB at 0x%p\n", urb);
+		dev_dbg(s->dev, "Allocated URB at 0x%p\n", urb);
 
 		urb->interval = 1;
 		urb->dev = udev;
@@ -533,8 +524,7 @@ static int msi2500_isoc_init(struct msi2500_state *s)
 		urb->transfer_buffer = usb_alloc_coherent(udev, ISO_BUFFER_SIZE,
 				GFP_KERNEL, &urb->transfer_dma);
 		if (urb->transfer_buffer == NULL) {
-			dev_err(&s->udev->dev,
-					"Failed to allocate urb buffer %d\n",
+			dev_err(s->dev, "Failed to allocate urb buffer %d\n",
 					i);
 			msi2500_isoc_cleanup(s);
 			return -ENOMEM;
@@ -554,13 +544,12 @@ static int msi2500_isoc_init(struct msi2500_state *s)
 	for (i = 0; i < MAX_ISO_BUFS; i++) {
 		ret = usb_submit_urb(s->urbs[i], GFP_KERNEL);
 		if (ret) {
-			dev_err(&s->udev->dev,
-					"isoc_init() submit_urb %d failed with error %d\n",
+			dev_err(s->dev, "usb_submit_urb %d failed with error %d\n",
 					i, ret);
 			msi2500_isoc_cleanup(s);
 			return ret;
 		}
-		dev_dbg(&s->udev->dev, "URB 0x%p submitted.\n", s->urbs[i]);
+		dev_dbg(s->dev, "URB 0x%p submitted.\n", s->urbs[i]);
 	}
 
 	/* All is done... */
@@ -572,7 +561,7 @@ static void msi2500_cleanup_queued_bufs(struct msi2500_state *s)
 {
 	unsigned long flags = 0;
 
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	dev_dbg(s->dev, "\n");
 
 	spin_lock_irqsave(&s->queued_bufs_lock, flags);
 	while (!list_empty(&s->queued_bufs)) {
@@ -593,7 +582,7 @@ static void msi2500_disconnect(struct usb_interface *intf)
 	struct msi2500_state *s =
 			container_of(v, struct msi2500_state, v4l2_dev);
 
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	dev_dbg(s->dev, "\n");
 
 	mutex_lock(&s->vb_queue_lock);
 	mutex_lock(&s->v4l2_lock);
@@ -613,7 +602,7 @@ static int msi2500_querycap(struct file *file, void *fh,
 {
 	struct msi2500_state *s = video_drvdata(file);
 
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	dev_dbg(s->dev, "\n");
 
 	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
 	strlcpy(cap->card, s->vdev.name, sizeof(cap->card));
@@ -631,14 +620,13 @@ static int msi2500_queue_setup(struct vb2_queue *vq,
 {
 	struct msi2500_state *s = vb2_get_drv_priv(vq);
 
-	dev_dbg(&s->udev->dev, "%s: *nbuffers=%d\n", __func__, *nbuffers);
+	dev_dbg(s->dev, "nbuffers=%d\n", *nbuffers);
 
 	/* Absolute min and max number of buffers available for mmap() */
 	*nbuffers = clamp_t(unsigned int, *nbuffers, 8, 32);
 	*nplanes = 1;
 	sizes[0] = PAGE_ALIGN(s->buffersize);
-	dev_dbg(&s->udev->dev, "%s: nbuffers=%d sizes[0]=%d\n",
-			__func__, *nbuffers, sizes[0]);
+	dev_dbg(s->dev, "nbuffers=%d sizes[0]=%d\n", *nbuffers, sizes[0]);
 	return 0;
 }
 
@@ -665,16 +653,15 @@ static void msi2500_buf_queue(struct vb2_buffer *vb)
 #define CMD_STOP_STREAMING     0x45
 #define CMD_READ_UNKNOW        0x48
 
-#define msi2500_dbg_usb_control_msg(_udev, _r, _t, _v, _i, _b, _l) { \
+#define msi2500_dbg_usb_control_msg(_dev, _r, _t, _v, _i, _b, _l) { \
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
 
 static int msi2500_ctrl_msg(struct msi2500_state *s, u8 cmd, u32 data)
@@ -685,18 +672,16 @@ static int msi2500_ctrl_msg(struct msi2500_state *s, u8 cmd, u32 data)
 	u16 value = (data >> 0) & 0xffff;
 	u16 index = (data >> 16) & 0xffff;
 
-	msi2500_dbg_usb_control_msg(s->udev,
+	msi2500_dbg_usb_control_msg(s->dev,
 			request, requesttype, value, index, NULL, 0);
-
 	ret = usb_control_msg(s->udev, usb_sndctrlpipe(s->udev, 0),
 			request, requesttype, value, index, NULL, 0, 2000);
-
 	if (ret)
-		dev_err(&s->udev->dev, "%s: failed %d, cmd %02x, data %04x\n",
-				__func__, ret, cmd, data);
+		dev_err(s->dev, "failed %d, cmd %02x, data %04x\n",
+				ret, cmd, data);
 
 	return ret;
-};
+}
 
 #define F_REF 24000000
 #define DIV_R_IN 2
@@ -785,8 +770,7 @@ static int msi2500_set_usb_adc(struct msi2500_state *s)
 
 	for (div_r_out = 4; div_r_out < 16; div_r_out += 2) {
 		f_vco = f_sr * div_r_out * 12;
-		dev_dbg(&s->udev->dev, "%s: div_r_out=%d f_vco=%d\n",
-				__func__, div_r_out, f_vco);
+		dev_dbg(s->dev, "div_r_out=%d f_vco=%d\n", div_r_out, f_vco);
 		if (f_vco >= 202000000)
 			break;
 	}
@@ -800,10 +784,8 @@ static int msi2500_set_usb_adc(struct msi2500_state *s)
 	reg3 |= ((fract >> 20) & 0x000001) << 15; /* [20] */
 	reg4 |= ((fract >>  0) & 0x0fffff) <<  8; /* [19:0] */
 
-	dev_dbg(&s->udev->dev,
-			"%s: f_sr=%d f_vco=%d div_n=%d div_m=%d div_r_out=%d reg3=%08x reg4=%08x\n",
-			__func__, f_sr, f_vco, div_n, div_m, div_r_out, reg3,
-			reg4);
+	dev_dbg(s->dev, "f_sr=%d f_vco=%d div_n=%d div_m=%d div_r_out=%d reg3=%08x reg4=%08x\n",
+			f_sr, f_vco, div_n, div_m, div_r_out, reg3, reg4);
 
 	ret = msi2500_ctrl_msg(s, CMD_WREG, 0x00608008);
 	if (ret)
@@ -838,14 +820,14 @@ static int msi2500_set_usb_adc(struct msi2500_state *s)
 		goto err;
 err:
 	return ret;
-};
+}
 
 static int msi2500_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct msi2500_state *s = vb2_get_drv_priv(vq);
 	int ret;
 
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	dev_dbg(s->dev, "\n");
 
 	if (!s->udev)
 		return -ENODEV;
@@ -873,7 +855,7 @@ static void msi2500_stop_streaming(struct vb2_queue *vq)
 {
 	struct msi2500_state *s = vb2_get_drv_priv(vq);
 
-	dev_dbg(&s->udev->dev, "%s:\n", __func__);
+	dev_dbg(s->dev, "\n");
 
 	mutex_lock(&s->v4l2_lock);
 
@@ -909,7 +891,7 @@ static int msi2500_enum_fmt_sdr_cap(struct file *file, void *priv,
 {
 	struct msi2500_state *s = video_drvdata(file);
 
-	dev_dbg(&s->udev->dev, "%s: index=%d\n", __func__, f->index);
+	dev_dbg(s->dev, "index=%d\n", f->index);
 
 	if (f->index >= s->num_formats)
 		return -EINVAL;
@@ -925,7 +907,7 @@ static int msi2500_g_fmt_sdr_cap(struct file *file, void *priv,
 {
 	struct msi2500_state *s = video_drvdata(file);
 
-	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
+	dev_dbg(s->dev, "pixelformat fourcc %4.4s\n",
 			(char *)&s->pixelformat);
 
 	f->fmt.sdr.pixelformat = s->pixelformat;
@@ -942,7 +924,7 @@ static int msi2500_s_fmt_sdr_cap(struct file *file, void *priv,
 	struct vb2_queue *q = &s->vb_queue;
 	int i;
 
-	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
+	dev_dbg(s->dev, "pixelformat fourcc %4.4s\n",
 			(char *)&f->fmt.sdr.pixelformat);
 
 	if (vb2_is_busy(q))
@@ -972,7 +954,7 @@ static int msi2500_try_fmt_sdr_cap(struct file *file, void *priv,
 	struct msi2500_state *s = video_drvdata(file);
 	int i;
 
-	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
+	dev_dbg(s->dev, "pixelformat fourcc %4.4s\n",
 			(char *)&f->fmt.sdr.pixelformat);
 
 	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
@@ -995,7 +977,7 @@ static int msi2500_s_tuner(struct file *file, void *priv,
 	struct msi2500_state *s = video_drvdata(file);
 	int ret;
 
-	dev_dbg(&s->udev->dev, "%s: index=%d\n", __func__, v->index);
+	dev_dbg(s->dev, "index=%d\n", v->index);
 
 	if (v->index == 0)
 		ret = 0;
@@ -1012,7 +994,7 @@ static int msi2500_g_tuner(struct file *file, void *priv, struct v4l2_tuner *v)
 	struct msi2500_state *s = video_drvdata(file);
 	int ret;
 
-	dev_dbg(&s->udev->dev, "%s: index=%d\n", __func__, v->index);
+	dev_dbg(s->dev, "index=%d\n", v->index);
 
 	if (v->index == 0) {
 		strlcpy(v->name, "Mirics MSi2500", sizeof(v->name));
@@ -1036,8 +1018,7 @@ static int msi2500_g_frequency(struct file *file, void *priv,
 	struct msi2500_state *s = video_drvdata(file);
 	int ret  = 0;
 
-	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d\n",
-			__func__, f->tuner, f->type);
+	dev_dbg(s->dev, "tuner=%d type=%d\n", f->tuner, f->type);
 
 	if (f->tuner == 0) {
 		f->frequency = s->f_adc;
@@ -1058,15 +1039,14 @@ static int msi2500_s_frequency(struct file *file, void *priv,
 	struct msi2500_state *s = video_drvdata(file);
 	int ret;
 
-	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d frequency=%u\n",
-			__func__, f->tuner, f->type, f->frequency);
+	dev_dbg(s->dev, "tuner=%d type=%d frequency=%u\n",
+			f->tuner, f->type, f->frequency);
 
 	if (f->tuner == 0) {
 		s->f_adc = clamp_t(unsigned int, f->frequency,
 				bands[0].rangelow,
 				bands[0].rangehigh);
-		dev_dbg(&s->udev->dev, "%s: ADC frequency=%u Hz\n",
-				__func__, s->f_adc);
+		dev_dbg(s->dev, "ADC frequency=%u Hz\n", s->f_adc);
 		ret = msi2500_set_usb_adc(s);
 	} else if (f->tuner == 1) {
 		ret = v4l2_subdev_call(s->v4l2_subdev, tuner, s_frequency, f);
@@ -1083,8 +1063,8 @@ static int msi2500_enum_freq_bands(struct file *file, void *priv,
 	struct msi2500_state *s = video_drvdata(file);
 	int ret;
 
-	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d index=%d\n",
-			__func__, band->tuner, band->type, band->index);
+	dev_dbg(s->dev, "tuner=%d type=%d index=%d\n",
+			band->tuner, band->type, band->index);
 
 	if (band->tuner == 0) {
 		if (band->index >= ARRAY_SIZE(bands)) {
@@ -1169,8 +1149,7 @@ static int msi2500_transfer_one_message(struct spi_master *master,
 	u32 data;
 
 	list_for_each_entry(t, &m->transfers, transfer_list) {
-		dev_dbg(&s->udev->dev, "%s: msg=%*ph\n",
-				__func__, t->len, t->tx_buf);
+		dev_dbg(s->dev, "msg=%*ph\n", t->len, t->tx_buf);
 		data = 0x09; /* reg 9 is SPI adapter */
 		data |= ((u8 *)t->tx_buf)[0] << 8;
 		data |= ((u8 *)t->tx_buf)[1] << 16;
@@ -1186,8 +1165,7 @@ static int msi2500_transfer_one_message(struct spi_master *master,
 static int msi2500_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	struct usb_device *udev = interface_to_usbdev(intf);
-	struct msi2500_state *s = NULL;
+	struct msi2500_state *s;
 	struct v4l2_subdev *sd;
 	struct spi_master *master;
 	int ret;
@@ -1200,7 +1178,7 @@ static int msi2500_probe(struct usb_interface *intf,
 
 	s = kzalloc(sizeof(struct msi2500_state), GFP_KERNEL);
 	if (s == NULL) {
-		pr_err("Could not allocate memory for msi2500_state\n");
+		dev_err(&intf->dev, "Could not allocate memory for state\n");
 		return -ENOMEM;
 	}
 
@@ -1208,7 +1186,8 @@ static int msi2500_probe(struct usb_interface *intf,
 	mutex_init(&s->vb_queue_lock);
 	spin_lock_init(&s->queued_bufs_lock);
 	INIT_LIST_HEAD(&s->queued_bufs);
-	s->udev = udev;
+	s->dev = &intf->dev;
+	s->udev = interface_to_usbdev(intf);
 	s->f_adc = bands[0].rangelow;
 	s->pixelformat = formats[0].pixelformat;
 	s->buffersize = formats[0].buffersize;
@@ -1226,7 +1205,7 @@ static int msi2500_probe(struct usb_interface *intf,
 	s->vb_queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	ret = vb2_queue_init(&s->vb_queue);
 	if (ret) {
-		dev_err(&s->udev->dev, "Could not initialize vb2 queue\n");
+		dev_err(s->dev, "Could not initialize vb2 queue\n");
 		goto err_free_mem;
 	}
 
@@ -1240,13 +1219,12 @@ static int msi2500_probe(struct usb_interface *intf,
 	s->v4l2_dev.release = msi2500_video_release;
 	ret = v4l2_device_register(&intf->dev, &s->v4l2_dev);
 	if (ret) {
-		dev_err(&s->udev->dev,
-				"Failed to register v4l2-device (%d)\n", ret);
+		dev_err(s->dev, "Failed to register v4l2-device (%d)\n", ret);
 		goto err_free_mem;
 	}
 
 	/* SPI master adapter */
-	master = spi_alloc_master(&s->udev->dev, 0);
+	master = spi_alloc_master(s->dev, 0);
 	if (master == NULL) {
 		ret = -ENOMEM;
 		goto err_unregister_v4l2_dev;
@@ -1267,7 +1245,7 @@ static int msi2500_probe(struct usb_interface *intf,
 	sd = v4l2_spi_new_subdev(&s->v4l2_dev, master, &board_info);
 	s->v4l2_subdev = sd;
 	if (sd == NULL) {
-		dev_err(&s->udev->dev, "cannot get v4l2 subdevice\n");
+		dev_err(s->dev, "cannot get v4l2 subdevice\n");
 		ret = -ENODEV;
 		goto err_unregister_master;
 	}
@@ -1276,7 +1254,7 @@ static int msi2500_probe(struct usb_interface *intf,
 	v4l2_ctrl_handler_init(&s->hdl, 0);
 	if (s->hdl.error) {
 		ret = s->hdl.error;
-		dev_err(&s->udev->dev, "Could not initialize controls\n");
+		dev_err(s->dev, "Could not initialize controls\n");
 		goto err_free_controls;
 	}
 
@@ -1289,16 +1267,13 @@ static int msi2500_probe(struct usb_interface *intf,
 
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
 
-- 
http://palosaari.fi/

