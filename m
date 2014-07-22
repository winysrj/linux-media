Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53627 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbaGVIq6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 04:46:58 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] msi2500: rename namespace msi3101 => msi2500
Date: Tue, 22 Jul 2014 11:46:52 +0300
Message-Id: <1406018812-4284-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename driver namespace according to current driver name. Old
msi3101 was name of reference design, msi2500 is name of chip
itself.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/msi2500/msi2500.c | 256 ++++++++++++++++++------------------
 1 file changed, 128 insertions(+), 128 deletions(-)

diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index 5bce38e..26b1334 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -34,8 +34,8 @@
 #include <media/videobuf2-vmalloc.h>
 #include <linux/spi/spi.h>
 
-static bool msi3101_emulated_fmt;
-module_param_named(emulated_formats, msi3101_emulated_fmt, bool, 0644);
+static bool msi2500_emulated_fmt;
+module_param_named(emulated_formats, msi2500_emulated_fmt, bool, 0644);
 MODULE_PARM_DESC(emulated_formats, "enable emulated formats (disappears in future)");
 
 /*
@@ -76,14 +76,14 @@ static const struct v4l2_frequency_band bands[] = {
 };
 
 /* stream formats */
-struct msi3101_format {
+struct msi2500_format {
 	char	*name;
 	u32	pixelformat;
 	u32	buffersize;
 };
 
 /* format descriptions for capture and preview */
-static struct msi3101_format formats[] = {
+static struct msi2500_format formats[] = {
 	{
 		.name		= "Complex S8",
 		.pixelformat	= V4L2_SDR_FMT_CS8,
@@ -114,12 +114,12 @@ static struct msi3101_format formats[] = {
 static const unsigned int NUM_FORMATS = ARRAY_SIZE(formats);
 
 /* intermediate buffers with raw data from the USB device */
-struct msi3101_frame_buf {
+struct msi2500_frame_buf {
 	struct vb2_buffer vb;   /* common v4l buffer stuff -- must be first */
 	struct list_head list;
 };
 
-struct msi3101_state {
+struct msi2500_state {
 	struct video_device vdev;
 	struct v4l2_device v4l2_dev;
 	struct v4l2_subdev *v4l2_subdev;
@@ -157,17 +157,17 @@ struct msi3101_state {
 };
 
 /* Private functions */
-static struct msi3101_frame_buf *msi3101_get_next_fill_buf(
-		struct msi3101_state *s)
+static struct msi2500_frame_buf *msi2500_get_next_fill_buf(
+		struct msi2500_state *s)
 {
 	unsigned long flags = 0;
-	struct msi3101_frame_buf *buf = NULL;
+	struct msi2500_frame_buf *buf = NULL;
 
 	spin_lock_irqsave(&s->queued_bufs_lock, flags);
 	if (list_empty(&s->queued_bufs))
 		goto leave;
 
-	buf = list_entry(s->queued_bufs.next, struct msi3101_frame_buf, list);
+	buf = list_entry(s->queued_bufs.next, struct msi2500_frame_buf, list);
 	list_del(&buf->list);
 leave:
 	spin_unlock_irqrestore(&s->queued_bufs_lock, flags);
@@ -256,7 +256,7 @@ leave:
  * signed 14-bit sample
  */
 
-static int msi3101_convert_stream(struct msi3101_state *s, u8 *dst, u8 *src,
+static int msi2500_convert_stream(struct msi2500_state *s, u8 *dst, u8 *src,
 		unsigned int src_len)
 {
 	unsigned int i, j, transactions, dst_len = 0;
@@ -378,12 +378,12 @@ static int msi3101_convert_stream(struct msi3101_state *s, u8 *dst, u8 *src,
  * This gets called for the Isochronous pipe (stream). This is done in interrupt
  * time, so it has to be fast, not crash, and not stall. Neat.
  */
-static void msi3101_isoc_handler(struct urb *urb)
+static void msi2500_isoc_handler(struct urb *urb)
 {
-	struct msi3101_state *s = (struct msi3101_state *)urb->context;
+	struct msi2500_state *s = (struct msi2500_state *)urb->context;
 	int i, flen, fstatus;
 	unsigned char *iso_buf = NULL;
-	struct msi3101_frame_buf *fbuf;
+	struct msi2500_frame_buf *fbuf;
 
 	if (unlikely(urb->status == -ENOENT || urb->status == -ECONNRESET ||
 			urb->status == -ESHUTDOWN)) {
@@ -394,7 +394,7 @@ static void msi3101_isoc_handler(struct urb *urb)
 
 	if (unlikely(urb->status != 0)) {
 		dev_dbg(&s->udev->dev,
-				"msi3101_isoc_handler() called with status %d\n",
+				"msi2500_isoc_handler() called with status %d\n",
 				urb->status);
 		/* Give up after a number of contiguous errors */
 		if (++s->isoc_errors > MAX_ISOC_ERRORS)
@@ -427,7 +427,7 @@ static void msi3101_isoc_handler(struct urb *urb)
 		iso_buf = urb->transfer_buffer + urb->iso_frame_desc[i].offset;
 
 		/* Get free framebuffer */
-		fbuf = msi3101_get_next_fill_buf(s);
+		fbuf = msi2500_get_next_fill_buf(s);
 		if (unlikely(fbuf == NULL)) {
 			s->vb_full++;
 			dev_dbg_ratelimited(&s->udev->dev,
@@ -438,7 +438,7 @@ static void msi3101_isoc_handler(struct urb *urb)
 
 		/* fill framebuffer */
 		ptr = vb2_plane_vaddr(&fbuf->vb, 0);
-		flen = msi3101_convert_stream(s, ptr, iso_buf, flen);
+		flen = msi2500_convert_stream(s, ptr, iso_buf, flen);
 		vb2_set_plane_payload(&fbuf->vb, 0, flen);
 		vb2_buffer_done(&fbuf->vb, VB2_BUF_STATE_DONE);
 	}
@@ -447,11 +447,11 @@ handler_end:
 	i = usb_submit_urb(urb, GFP_ATOMIC);
 	if (unlikely(i != 0))
 		dev_dbg(&s->udev->dev,
-				"Error (%d) re-submitting urb in msi3101_isoc_handler\n",
+				"Error (%d) re-submitting urb in msi2500_isoc_handler\n",
 				i);
 }
 
-static void msi3101_iso_stop(struct msi3101_state *s)
+static void msi2500_iso_stop(struct msi2500_state *s)
 {
 	int i;
 
@@ -467,7 +467,7 @@ static void msi3101_iso_stop(struct msi3101_state *s)
 	}
 }
 
-static void msi3101_iso_free(struct msi3101_state *s)
+static void msi2500_iso_free(struct msi2500_state *s)
 {
 	int i;
 
@@ -490,16 +490,16 @@ static void msi3101_iso_free(struct msi3101_state *s)
 }
 
 /* Both v4l2_lock and vb_queue_lock should be locked when calling this */
-static void msi3101_isoc_cleanup(struct msi3101_state *s)
+static void msi2500_isoc_cleanup(struct msi2500_state *s)
 {
 	dev_dbg(&s->udev->dev, "%s:\n", __func__);
 
-	msi3101_iso_stop(s);
-	msi3101_iso_free(s);
+	msi2500_iso_stop(s);
+	msi2500_iso_free(s);
 }
 
 /* Both v4l2_lock and vb_queue_lock should be locked when calling this */
-static int msi3101_isoc_init(struct msi3101_state *s)
+static int msi2500_isoc_init(struct msi2500_state *s)
 {
 	struct usb_device *udev;
 	struct urb *urb;
@@ -520,7 +520,7 @@ static int msi3101_isoc_init(struct msi3101_state *s)
 		if (urb == NULL) {
 			dev_err(&s->udev->dev,
 					"Failed to allocate urb %d\n", i);
-			msi3101_isoc_cleanup(s);
+			msi2500_isoc_cleanup(s);
 			return -ENOMEM;
 		}
 		s->urbs[i] = urb;
@@ -536,11 +536,11 @@ static int msi3101_isoc_init(struct msi3101_state *s)
 			dev_err(&s->udev->dev,
 					"Failed to allocate urb buffer %d\n",
 					i);
-			msi3101_isoc_cleanup(s);
+			msi2500_isoc_cleanup(s);
 			return -ENOMEM;
 		}
 		urb->transfer_buffer_length = ISO_BUFFER_SIZE;
-		urb->complete = msi3101_isoc_handler;
+		urb->complete = msi2500_isoc_handler;
 		urb->context = s;
 		urb->start_frame = 0;
 		urb->number_of_packets = ISO_FRAMES_PER_DESC;
@@ -557,7 +557,7 @@ static int msi3101_isoc_init(struct msi3101_state *s)
 			dev_err(&s->udev->dev,
 					"isoc_init() submit_urb %d failed with error %d\n",
 					i, ret);
-			msi3101_isoc_cleanup(s);
+			msi2500_isoc_cleanup(s);
 			return ret;
 		}
 		dev_dbg(&s->udev->dev, "URB 0x%p submitted.\n", s->urbs[i]);
@@ -568,7 +568,7 @@ static int msi3101_isoc_init(struct msi3101_state *s)
 }
 
 /* Must be called with vb_queue_lock hold */
-static void msi3101_cleanup_queued_bufs(struct msi3101_state *s)
+static void msi2500_cleanup_queued_bufs(struct msi2500_state *s)
 {
 	unsigned long flags = 0;
 
@@ -576,9 +576,9 @@ static void msi3101_cleanup_queued_bufs(struct msi3101_state *s)
 
 	spin_lock_irqsave(&s->queued_bufs_lock, flags);
 	while (!list_empty(&s->queued_bufs)) {
-		struct msi3101_frame_buf *buf;
+		struct msi2500_frame_buf *buf;
 
-		buf = list_entry(s->queued_bufs.next, struct msi3101_frame_buf,
+		buf = list_entry(s->queued_bufs.next, struct msi2500_frame_buf,
 				 list);
 		list_del(&buf->list);
 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
@@ -587,11 +587,11 @@ static void msi3101_cleanup_queued_bufs(struct msi3101_state *s)
 }
 
 /* The user yanked out the cable... */
-static void msi3101_disconnect(struct usb_interface *intf)
+static void msi2500_disconnect(struct usb_interface *intf)
 {
 	struct v4l2_device *v = usb_get_intfdata(intf);
-	struct msi3101_state *s =
-			container_of(v, struct msi3101_state, v4l2_dev);
+	struct msi2500_state *s =
+			container_of(v, struct msi2500_state, v4l2_dev);
 
 	dev_dbg(&s->udev->dev, "%s:\n", __func__);
 
@@ -608,10 +608,10 @@ static void msi3101_disconnect(struct usb_interface *intf)
 	v4l2_device_put(&s->v4l2_dev);
 }
 
-static int msi3101_querycap(struct file *file, void *fh,
+static int msi2500_querycap(struct file *file, void *fh,
 		struct v4l2_capability *cap)
 {
-	struct msi3101_state *s = video_drvdata(file);
+	struct msi2500_state *s = video_drvdata(file);
 
 	dev_dbg(&s->udev->dev, "%s:\n", __func__);
 
@@ -625,11 +625,11 @@ static int msi3101_querycap(struct file *file, void *fh,
 }
 
 /* Videobuf2 operations */
-static int msi3101_queue_setup(struct vb2_queue *vq,
+static int msi2500_queue_setup(struct vb2_queue *vq,
 		const struct v4l2_format *fmt, unsigned int *nbuffers,
 		unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
 {
-	struct msi3101_state *s = vb2_get_drv_priv(vq);
+	struct msi2500_state *s = vb2_get_drv_priv(vq);
 
 	dev_dbg(&s->udev->dev, "%s: *nbuffers=%d\n", __func__, *nbuffers);
 
@@ -642,11 +642,11 @@ static int msi3101_queue_setup(struct vb2_queue *vq,
 	return 0;
 }
 
-static void msi3101_buf_queue(struct vb2_buffer *vb)
+static void msi2500_buf_queue(struct vb2_buffer *vb)
 {
-	struct msi3101_state *s = vb2_get_drv_priv(vb->vb2_queue);
-	struct msi3101_frame_buf *buf =
-			container_of(vb, struct msi3101_frame_buf, vb);
+	struct msi2500_state *s = vb2_get_drv_priv(vb->vb2_queue);
+	struct msi2500_frame_buf *buf =
+			container_of(vb, struct msi2500_frame_buf, vb);
 	unsigned long flags = 0;
 
 	/* Check the device has not disconnected between prep and queuing */
@@ -665,7 +665,7 @@ static void msi3101_buf_queue(struct vb2_buffer *vb)
 #define CMD_STOP_STREAMING     0x45
 #define CMD_READ_UNKNOW        0x48
 
-#define msi3101_dbg_usb_control_msg(_udev, _r, _t, _v, _i, _b, _l) { \
+#define msi2500_dbg_usb_control_msg(_udev, _r, _t, _v, _i, _b, _l) { \
 	char *_direction; \
 	if (_t & USB_DIR_IN) \
 		_direction = "<<<"; \
@@ -677,7 +677,7 @@ static void msi3101_buf_queue(struct vb2_buffer *vb)
 			_l, _b); \
 }
 
-static int msi3101_ctrl_msg(struct msi3101_state *s, u8 cmd, u32 data)
+static int msi2500_ctrl_msg(struct msi2500_state *s, u8 cmd, u32 data)
 {
 	int ret;
 	u8 request = cmd;
@@ -685,7 +685,7 @@ static int msi3101_ctrl_msg(struct msi3101_state *s, u8 cmd, u32 data)
 	u16 value = (data >> 0) & 0xffff;
 	u16 index = (data >> 16) & 0xffff;
 
-	msi3101_dbg_usb_control_msg(s->udev,
+	msi2500_dbg_usb_control_msg(s->udev,
 			request, requesttype, value, index, NULL, 0);
 
 	ret = usb_control_msg(s->udev, usb_sndctrlpipe(s->udev, 0),
@@ -700,7 +700,7 @@ static int msi3101_ctrl_msg(struct msi3101_state *s, u8 cmd, u32 data)
 
 #define F_REF 24000000
 #define DIV_R_IN 2
-static int msi3101_set_usb_adc(struct msi3101_state *s)
+static int msi2500_set_usb_adc(struct msi2500_state *s)
 {
 	int ret, div_n, div_m, div_r_out, f_sr, f_vco, fract;
 	u32 reg3, reg4, reg7;
@@ -805,44 +805,44 @@ static int msi3101_set_usb_adc(struct msi3101_state *s)
 			__func__, f_sr, f_vco, div_n, div_m, div_r_out, reg3,
 			reg4);
 
-	ret = msi3101_ctrl_msg(s, CMD_WREG, 0x00608008);
+	ret = msi2500_ctrl_msg(s, CMD_WREG, 0x00608008);
 	if (ret)
 		goto err;
 
-	ret = msi3101_ctrl_msg(s, CMD_WREG, 0x00000c05);
+	ret = msi2500_ctrl_msg(s, CMD_WREG, 0x00000c05);
 	if (ret)
 		goto err;
 
-	ret = msi3101_ctrl_msg(s, CMD_WREG, 0x00020000);
+	ret = msi2500_ctrl_msg(s, CMD_WREG, 0x00020000);
 	if (ret)
 		goto err;
 
-	ret = msi3101_ctrl_msg(s, CMD_WREG, 0x00480102);
+	ret = msi2500_ctrl_msg(s, CMD_WREG, 0x00480102);
 	if (ret)
 		goto err;
 
-	ret = msi3101_ctrl_msg(s, CMD_WREG, 0x00f38008);
+	ret = msi2500_ctrl_msg(s, CMD_WREG, 0x00f38008);
 	if (ret)
 		goto err;
 
-	ret = msi3101_ctrl_msg(s, CMD_WREG, reg7);
+	ret = msi2500_ctrl_msg(s, CMD_WREG, reg7);
 	if (ret)
 		goto err;
 
-	ret = msi3101_ctrl_msg(s, CMD_WREG, reg4);
+	ret = msi2500_ctrl_msg(s, CMD_WREG, reg4);
 	if (ret)
 		goto err;
 
-	ret = msi3101_ctrl_msg(s, CMD_WREG, reg3);
+	ret = msi2500_ctrl_msg(s, CMD_WREG, reg3);
 	if (ret)
 		goto err;
 err:
 	return ret;
 };
 
-static int msi3101_start_streaming(struct vb2_queue *vq, unsigned int count)
+static int msi2500_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
-	struct msi3101_state *s = vb2_get_drv_priv(vq);
+	struct msi2500_state *s = vb2_get_drv_priv(vq);
 	int ret;
 
 	dev_dbg(&s->udev->dev, "%s:\n", __func__);
@@ -856,37 +856,37 @@ static int msi3101_start_streaming(struct vb2_queue *vq, unsigned int count)
 	/* wake-up tuner */
 	v4l2_subdev_call(s->v4l2_subdev, core, s_power, 1);
 
-	ret = msi3101_set_usb_adc(s);
+	ret = msi2500_set_usb_adc(s);
 
-	ret = msi3101_isoc_init(s);
+	ret = msi2500_isoc_init(s);
 	if (ret)
-		msi3101_cleanup_queued_bufs(s);
+		msi2500_cleanup_queued_bufs(s);
 
-	ret = msi3101_ctrl_msg(s, CMD_START_STREAMING, 0);
+	ret = msi2500_ctrl_msg(s, CMD_START_STREAMING, 0);
 
 	mutex_unlock(&s->v4l2_lock);
 
 	return ret;
 }
 
-static void msi3101_stop_streaming(struct vb2_queue *vq)
+static void msi2500_stop_streaming(struct vb2_queue *vq)
 {
-	struct msi3101_state *s = vb2_get_drv_priv(vq);
+	struct msi2500_state *s = vb2_get_drv_priv(vq);
 
 	dev_dbg(&s->udev->dev, "%s:\n", __func__);
 
 	mutex_lock(&s->v4l2_lock);
 
 	if (s->udev)
-		msi3101_isoc_cleanup(s);
+		msi2500_isoc_cleanup(s);
 
-	msi3101_cleanup_queued_bufs(s);
+	msi2500_cleanup_queued_bufs(s);
 
 	/* according to tests, at least 700us delay is required  */
 	msleep(20);
-	if (!msi3101_ctrl_msg(s, CMD_STOP_STREAMING, 0)) {
+	if (!msi2500_ctrl_msg(s, CMD_STOP_STREAMING, 0)) {
 		/* sleep USB IF / ADC */
-		msi3101_ctrl_msg(s, CMD_WREG, 0x01000003);
+		msi2500_ctrl_msg(s, CMD_WREG, 0x01000003);
 	}
 
 	/* sleep tuner */
@@ -895,19 +895,19 @@ static void msi3101_stop_streaming(struct vb2_queue *vq)
 	mutex_unlock(&s->v4l2_lock);
 }
 
-static struct vb2_ops msi3101_vb2_ops = {
-	.queue_setup            = msi3101_queue_setup,
-	.buf_queue              = msi3101_buf_queue,
-	.start_streaming        = msi3101_start_streaming,
-	.stop_streaming         = msi3101_stop_streaming,
+static struct vb2_ops msi2500_vb2_ops = {
+	.queue_setup            = msi2500_queue_setup,
+	.buf_queue              = msi2500_buf_queue,
+	.start_streaming        = msi2500_start_streaming,
+	.stop_streaming         = msi2500_stop_streaming,
 	.wait_prepare           = vb2_ops_wait_prepare,
 	.wait_finish            = vb2_ops_wait_finish,
 };
 
-static int msi3101_enum_fmt_sdr_cap(struct file *file, void *priv,
+static int msi2500_enum_fmt_sdr_cap(struct file *file, void *priv,
 		struct v4l2_fmtdesc *f)
 {
-	struct msi3101_state *s = video_drvdata(file);
+	struct msi2500_state *s = video_drvdata(file);
 
 	dev_dbg(&s->udev->dev, "%s: index=%d\n", __func__, f->index);
 
@@ -920,10 +920,10 @@ static int msi3101_enum_fmt_sdr_cap(struct file *file, void *priv,
 	return 0;
 }
 
-static int msi3101_g_fmt_sdr_cap(struct file *file, void *priv,
+static int msi2500_g_fmt_sdr_cap(struct file *file, void *priv,
 		struct v4l2_format *f)
 {
-	struct msi3101_state *s = video_drvdata(file);
+	struct msi2500_state *s = video_drvdata(file);
 
 	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
 			(char *)&s->pixelformat);
@@ -935,10 +935,10 @@ static int msi3101_g_fmt_sdr_cap(struct file *file, void *priv,
 	return 0;
 }
 
-static int msi3101_s_fmt_sdr_cap(struct file *file, void *priv,
+static int msi2500_s_fmt_sdr_cap(struct file *file, void *priv,
 		struct v4l2_format *f)
 {
-	struct msi3101_state *s = video_drvdata(file);
+	struct msi2500_state *s = video_drvdata(file);
 	struct vb2_queue *q = &s->vb_queue;
 	int i;
 
@@ -966,10 +966,10 @@ static int msi3101_s_fmt_sdr_cap(struct file *file, void *priv,
 	return 0;
 }
 
-static int msi3101_try_fmt_sdr_cap(struct file *file, void *priv,
+static int msi2500_try_fmt_sdr_cap(struct file *file, void *priv,
 		struct v4l2_format *f)
 {
-	struct msi3101_state *s = video_drvdata(file);
+	struct msi2500_state *s = video_drvdata(file);
 	int i;
 
 	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
@@ -989,10 +989,10 @@ static int msi3101_try_fmt_sdr_cap(struct file *file, void *priv,
 	return 0;
 }
 
-static int msi3101_s_tuner(struct file *file, void *priv,
+static int msi2500_s_tuner(struct file *file, void *priv,
 		const struct v4l2_tuner *v)
 {
-	struct msi3101_state *s = video_drvdata(file);
+	struct msi2500_state *s = video_drvdata(file);
 	int ret;
 
 	dev_dbg(&s->udev->dev, "%s: index=%d\n", __func__, v->index);
@@ -1007,9 +1007,9 @@ static int msi3101_s_tuner(struct file *file, void *priv,
 	return ret;
 }
 
-static int msi3101_g_tuner(struct file *file, void *priv, struct v4l2_tuner *v)
+static int msi2500_g_tuner(struct file *file, void *priv, struct v4l2_tuner *v)
 {
-	struct msi3101_state *s = video_drvdata(file);
+	struct msi2500_state *s = video_drvdata(file);
 	int ret;
 
 	dev_dbg(&s->udev->dev, "%s: index=%d\n", __func__, v->index);
@@ -1030,10 +1030,10 @@ static int msi3101_g_tuner(struct file *file, void *priv, struct v4l2_tuner *v)
 	return ret;
 }
 
-static int msi3101_g_frequency(struct file *file, void *priv,
+static int msi2500_g_frequency(struct file *file, void *priv,
 		struct v4l2_frequency *f)
 {
-	struct msi3101_state *s = video_drvdata(file);
+	struct msi2500_state *s = video_drvdata(file);
 	int ret  = 0;
 
 	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d\n",
@@ -1052,10 +1052,10 @@ static int msi3101_g_frequency(struct file *file, void *priv,
 	return ret;
 }
 
-static int msi3101_s_frequency(struct file *file, void *priv,
+static int msi2500_s_frequency(struct file *file, void *priv,
 		const struct v4l2_frequency *f)
 {
-	struct msi3101_state *s = video_drvdata(file);
+	struct msi2500_state *s = video_drvdata(file);
 	int ret;
 
 	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d frequency=%u\n",
@@ -1067,7 +1067,7 @@ static int msi3101_s_frequency(struct file *file, void *priv,
 				bands[0].rangehigh);
 		dev_dbg(&s->udev->dev, "%s: ADC frequency=%u Hz\n",
 				__func__, s->f_adc);
-		ret = msi3101_set_usb_adc(s);
+		ret = msi2500_set_usb_adc(s);
 	} else if (f->tuner == 1) {
 		ret = v4l2_subdev_call(s->v4l2_subdev, tuner, s_frequency, f);
 	} else {
@@ -1077,10 +1077,10 @@ static int msi3101_s_frequency(struct file *file, void *priv,
 	return ret;
 }
 
-static int msi3101_enum_freq_bands(struct file *file, void *priv,
+static int msi2500_enum_freq_bands(struct file *file, void *priv,
 		struct v4l2_frequency_band *band)
 {
-	struct msi3101_state *s = video_drvdata(file);
+	struct msi2500_state *s = video_drvdata(file);
 	int ret;
 
 	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d index=%d\n",
@@ -1103,13 +1103,13 @@ static int msi3101_enum_freq_bands(struct file *file, void *priv,
 	return ret;
 }
 
-static const struct v4l2_ioctl_ops msi3101_ioctl_ops = {
-	.vidioc_querycap          = msi3101_querycap,
+static const struct v4l2_ioctl_ops msi2500_ioctl_ops = {
+	.vidioc_querycap          = msi2500_querycap,
 
-	.vidioc_enum_fmt_sdr_cap  = msi3101_enum_fmt_sdr_cap,
-	.vidioc_g_fmt_sdr_cap     = msi3101_g_fmt_sdr_cap,
-	.vidioc_s_fmt_sdr_cap     = msi3101_s_fmt_sdr_cap,
-	.vidioc_try_fmt_sdr_cap   = msi3101_try_fmt_sdr_cap,
+	.vidioc_enum_fmt_sdr_cap  = msi2500_enum_fmt_sdr_cap,
+	.vidioc_g_fmt_sdr_cap     = msi2500_g_fmt_sdr_cap,
+	.vidioc_s_fmt_sdr_cap     = msi2500_s_fmt_sdr_cap,
+	.vidioc_try_fmt_sdr_cap   = msi2500_try_fmt_sdr_cap,
 
 	.vidioc_reqbufs           = vb2_ioctl_reqbufs,
 	.vidioc_create_bufs       = vb2_ioctl_create_bufs,
@@ -1121,19 +1121,19 @@ static const struct v4l2_ioctl_ops msi3101_ioctl_ops = {
 	.vidioc_streamon          = vb2_ioctl_streamon,
 	.vidioc_streamoff         = vb2_ioctl_streamoff,
 
-	.vidioc_g_tuner           = msi3101_g_tuner,
-	.vidioc_s_tuner           = msi3101_s_tuner,
+	.vidioc_g_tuner           = msi2500_g_tuner,
+	.vidioc_s_tuner           = msi2500_s_tuner,
 
-	.vidioc_g_frequency       = msi3101_g_frequency,
-	.vidioc_s_frequency       = msi3101_s_frequency,
-	.vidioc_enum_freq_bands   = msi3101_enum_freq_bands,
+	.vidioc_g_frequency       = msi2500_g_frequency,
+	.vidioc_s_frequency       = msi2500_s_frequency,
+	.vidioc_enum_freq_bands   = msi2500_enum_freq_bands,
 
 	.vidioc_subscribe_event   = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 	.vidioc_log_status        = v4l2_ctrl_log_status,
 };
 
-static const struct v4l2_file_operations msi3101_fops = {
+static const struct v4l2_file_operations msi2500_fops = {
 	.owner                    = THIS_MODULE,
 	.open                     = v4l2_fh_open,
 	.release                  = vb2_fop_release,
@@ -1143,27 +1143,27 @@ static const struct v4l2_file_operations msi3101_fops = {
 	.unlocked_ioctl           = video_ioctl2,
 };
 
-static struct video_device msi3101_template = {
+static struct video_device msi2500_template = {
 	.name                     = "Mirics MSi3101 SDR Dongle",
 	.release                  = video_device_release_empty,
-	.fops                     = &msi3101_fops,
-	.ioctl_ops                = &msi3101_ioctl_ops,
+	.fops                     = &msi2500_fops,
+	.ioctl_ops                = &msi2500_ioctl_ops,
 };
 
-static void msi3101_video_release(struct v4l2_device *v)
+static void msi2500_video_release(struct v4l2_device *v)
 {
-	struct msi3101_state *s =
-			container_of(v, struct msi3101_state, v4l2_dev);
+	struct msi2500_state *s =
+			container_of(v, struct msi2500_state, v4l2_dev);
 
 	v4l2_ctrl_handler_free(&s->hdl);
 	v4l2_device_unregister(&s->v4l2_dev);
 	kfree(s);
 }
 
-static int msi3101_transfer_one_message(struct spi_master *master,
+static int msi2500_transfer_one_message(struct spi_master *master,
 		struct spi_message *m)
 {
-	struct msi3101_state *s = spi_master_get_devdata(master);
+	struct msi2500_state *s = spi_master_get_devdata(master);
 	struct spi_transfer *t;
 	int ret = 0;
 	u32 data;
@@ -1175,7 +1175,7 @@ static int msi3101_transfer_one_message(struct spi_master *master,
 		data |= ((u8 *)t->tx_buf)[0] << 8;
 		data |= ((u8 *)t->tx_buf)[1] << 16;
 		data |= ((u8 *)t->tx_buf)[2] << 24;
-		ret = msi3101_ctrl_msg(s, CMD_WREG, data);
+		ret = msi2500_ctrl_msg(s, CMD_WREG, data);
 	}
 
 	m->status = ret;
@@ -1183,11 +1183,11 @@ static int msi3101_transfer_one_message(struct spi_master *master,
 	return ret;
 }
 
-static int msi3101_probe(struct usb_interface *intf,
+static int msi2500_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
-	struct msi3101_state *s = NULL;
+	struct msi2500_state *s = NULL;
 	struct v4l2_subdev *sd;
 	struct spi_master *master;
 	int ret;
@@ -1198,9 +1198,9 @@ static int msi3101_probe(struct usb_interface *intf,
 		.max_speed_hz		= 12000000,
 	};
 
-	s = kzalloc(sizeof(struct msi3101_state), GFP_KERNEL);
+	s = kzalloc(sizeof(struct msi2500_state), GFP_KERNEL);
 	if (s == NULL) {
-		pr_err("Could not allocate memory for msi3101_state\n");
+		pr_err("Could not allocate memory for msi2500_state\n");
 		return -ENOMEM;
 	}
 
@@ -1213,15 +1213,15 @@ static int msi3101_probe(struct usb_interface *intf,
 	s->pixelformat = formats[0].pixelformat;
 	s->buffersize = formats[0].buffersize;
 	s->num_formats = NUM_FORMATS;
-	if (msi3101_emulated_fmt == false)
+	if (msi2500_emulated_fmt == false)
 		s->num_formats -= 2;
 
 	/* Init videobuf2 queue structure */
 	s->vb_queue.type = V4L2_BUF_TYPE_SDR_CAPTURE;
 	s->vb_queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
 	s->vb_queue.drv_priv = s;
-	s->vb_queue.buf_struct_size = sizeof(struct msi3101_frame_buf);
-	s->vb_queue.ops = &msi3101_vb2_ops;
+	s->vb_queue.buf_struct_size = sizeof(struct msi2500_frame_buf);
+	s->vb_queue.ops = &msi2500_vb2_ops;
 	s->vb_queue.mem_ops = &vb2_vmalloc_memops;
 	s->vb_queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	ret = vb2_queue_init(&s->vb_queue);
@@ -1231,13 +1231,13 @@ static int msi3101_probe(struct usb_interface *intf,
 	}
 
 	/* Init video_device structure */
-	s->vdev = msi3101_template;
+	s->vdev = msi2500_template;
 	s->vdev.queue = &s->vb_queue;
 	s->vdev.queue->lock = &s->vb_queue_lock;
 	video_set_drvdata(&s->vdev, s);
 
 	/* Register the v4l2_device structure */
-	s->v4l2_dev.release = msi3101_video_release;
+	s->v4l2_dev.release = msi2500_video_release;
 	ret = v4l2_device_register(&intf->dev, &s->v4l2_dev);
 	if (ret) {
 		dev_err(&s->udev->dev,
@@ -1255,7 +1255,7 @@ static int msi3101_probe(struct usb_interface *intf,
 	s->master = master;
 	master->bus_num = 0;
 	master->num_chipselect = 1;
-	master->transfer_one_message = msi3101_transfer_one_message;
+	master->transfer_one_message = msi2500_transfer_one_message;
 	spi_master_set_devdata(master, s);
 	ret = spi_register_master(master);
 	if (ret) {
@@ -1314,22 +1314,22 @@ err_free_mem:
 }
 
 /* USB device ID list */
-static struct usb_device_id msi3101_id_table[] = {
+static struct usb_device_id msi2500_id_table[] = {
 	{ USB_DEVICE(0x1df7, 0x2500) }, /* Mirics MSi3101 SDR Dongle */
 	{ USB_DEVICE(0x2040, 0xd300) }, /* Hauppauge WinTV 133559 LF */
 	{ }
 };
-MODULE_DEVICE_TABLE(usb, msi3101_id_table);
+MODULE_DEVICE_TABLE(usb, msi2500_id_table);
 
 /* USB subsystem interface */
-static struct usb_driver msi3101_driver = {
+static struct usb_driver msi2500_driver = {
 	.name                     = KBUILD_MODNAME,
-	.probe                    = msi3101_probe,
-	.disconnect               = msi3101_disconnect,
-	.id_table                 = msi3101_id_table,
+	.probe                    = msi2500_probe,
+	.disconnect               = msi2500_disconnect,
+	.id_table                 = msi2500_id_table,
 };
 
-module_usb_driver(msi3101_driver);
+module_usb_driver(msi2500_driver);
 
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_DESCRIPTION("Mirics MSi3101 SDR Dongle");
-- 
http://palosaari.fi/

