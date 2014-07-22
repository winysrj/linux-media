Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43526 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbaGVFpg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 01:45:36 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] msi2500: correct style issues
Date: Tue, 22 Jul 2014 08:45:31 +0300
Message-Id: <1406007931-17744-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Correct some style issues, mostly reported by checkpatch.pl.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/msi2500/msi2500.c | 70 +++++++++++++++++++++++++++----------
 1 file changed, 51 insertions(+), 19 deletions(-)

diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index 483dc6e..755f959 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -55,9 +55,14 @@ MODULE_PARM_DESC(emulated_formats, "enable emulated formats (disappears in futur
 #define ISO_BUFFER_SIZE         (ISO_FRAMES_PER_DESC * ISO_MAX_FRAME_SIZE)
 #define MAX_ISOC_ERRORS         20
 
-/* TODO: These should be moved to V4L2 API */
-#define V4L2_PIX_FMT_SDR_S12    v4l2_fourcc('D', 'S', '1', '2') /* signed 12-bit */
-#define V4L2_PIX_FMT_SDR_MSI2500_384 v4l2_fourcc('M', '3', '8', '4') /* Mirics MSi2500 format 384 */
+/*
+ * TODO: These formats should be moved to V4L2 API. Formats are currently
+ * disabled from formats[] table, not visible to userspace.
+ */
+ /* signed 12-bit */
+#define MSI2500_PIX_FMT_SDR_S12         v4l2_fourcc('D', 'S', '1', '2')
+/* Mirics MSi2500 format 384 */
+#define MSI2500_PIX_FMT_SDR_MSI2500_384 v4l2_fourcc('M', '3', '8', '4')
 
 static const struct v4l2_frequency_band bands[] = {
 	{
@@ -86,10 +91,10 @@ static struct msi3101_format formats[] = {
 #if 0
 	}, {
 		.name		= "10+2-bit signed",
-		.pixelformat	= V4L2_PIX_FMT_SDR_MSI2500_384,
+		.pixelformat	= MSI2500_PIX_FMT_SDR_MSI2500_384,
 	}, {
 		.name		= "12-bit signed",
-		.pixelformat	= V4L2_PIX_FMT_SDR_S12,
+		.pixelformat	= MSI2500_PIX_FMT_SDR_S12,
 #endif
 	}, {
 		.name		= "Complex S14LE",
@@ -221,6 +226,7 @@ static int msi3101_convert_stream_504(struct msi3101_state *s, u8 *dst,
 		unsigned long jiffies_now = jiffies;
 		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
 		unsigned int samples = sample_num[i_max - 1] - s->sample;
+
 		s->jiffies_next = jiffies_now;
 		s->sample = sample_num[i_max - 1];
 		dev_dbg(&s->udev->dev,
@@ -278,6 +284,7 @@ static int msi3101_convert_stream_504_u8(struct msi3101_state *s, u8 *dst,
 	if (unlikely(time_is_before_jiffies(s->jiffies_next))) {
 #define MSECS 10000UL
 		unsigned int samples = sample_num[i_max - 1] - s->sample;
+
 		s->jiffies_next = jiffies + msecs_to_jiffies(MSECS);
 		s->sample = sample_num[i_max - 1];
 		dev_dbg(&s->udev->dev,
@@ -373,6 +380,7 @@ static int msi3101_convert_stream_384(struct msi3101_state *s, u8 *dst,
 		unsigned long jiffies_now = jiffies;
 		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
 		unsigned int samples = sample_num[i_max - 1] - s->sample;
+
 		s->jiffies_next = jiffies_now;
 		s->sample = sample_num[i_max - 1];
 		dev_dbg(&s->udev->dev,
@@ -438,6 +446,7 @@ static int msi3101_convert_stream_336(struct msi3101_state *s, u8 *dst,
 		unsigned long jiffies_now = jiffies;
 		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
 		unsigned int samples = sample_num[i_max - 1] - s->sample;
+
 		s->jiffies_next = jiffies_now;
 		s->sample = sample_num[i_max - 1];
 		dev_dbg(&s->udev->dev,
@@ -501,6 +510,7 @@ static int msi3101_convert_stream_252(struct msi3101_state *s, u8 *dst,
 		unsigned long jiffies_now = jiffies;
 		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
 		unsigned int samples = sample_num[i_max - 1] - s->sample;
+
 		s->jiffies_next = jiffies_now;
 		s->sample = sample_num[i_max - 1];
 		dev_dbg(&s->udev->dev,
@@ -521,7 +531,7 @@ static int msi3101_convert_stream_252_u16(struct msi3101_state *s, u8 *dst,
 	int i, j, i_max, dst_len = 0;
 	u32 sample_num[3];
 	u16 *u16dst = (u16 *) dst;
-	struct {signed int x:14;} se;
+	struct {signed int x:14; } se;
 
 	/* There could be 1-3 1024 bytes URB frames */
 	i_max = src_len / 1024;
@@ -573,6 +583,7 @@ static int msi3101_convert_stream_252_u16(struct msi3101_state *s, u8 *dst,
 	if (unlikely(time_is_before_jiffies(s->jiffies_next))) {
 #define MSECS 10000UL
 		unsigned int samples = sample_num[i_max - 1] - s->sample;
+
 		s->jiffies_next = jiffies + msecs_to_jiffies(MSECS);
 		s->sample = sample_num[i_max - 1];
 		dev_dbg(&s->udev->dev,
@@ -667,6 +678,7 @@ handler_end:
 static void msi3101_iso_stop(struct msi3101_state *s)
 {
 	int i;
+
 	dev_dbg(&s->udev->dev, "%s:\n", __func__);
 
 	/* Unlinking ISOC buffers one by one */
@@ -682,6 +694,7 @@ static void msi3101_iso_stop(struct msi3101_state *s)
 static void msi3101_iso_free(struct msi3101_state *s)
 {
 	int i;
+
 	dev_dbg(&s->udev->dev, "%s:\n", __func__);
 
 	/* Freeing ISOC buffers one by one */
@@ -715,6 +728,7 @@ static int msi3101_isoc_init(struct msi3101_state *s)
 	struct usb_device *udev;
 	struct urb *urb;
 	int i, j, ret;
+
 	dev_dbg(&s->udev->dev, "%s:\n", __func__);
 
 	s->isoc_errors = 0;
@@ -781,6 +795,7 @@ static int msi3101_isoc_init(struct msi3101_state *s)
 static void msi3101_cleanup_queued_bufs(struct msi3101_state *s)
 {
 	unsigned long flags = 0;
+
 	dev_dbg(&s->udev->dev, "%s:\n", __func__);
 
 	spin_lock_irqsave(&s->queued_bufs_lock, flags);
@@ -801,6 +816,7 @@ static void msi3101_disconnect(struct usb_interface *intf)
 	struct v4l2_device *v = usb_get_intfdata(intf);
 	struct msi3101_state *s =
 			container_of(v, struct msi3101_state, v4l2_dev);
+
 	dev_dbg(&s->udev->dev, "%s:\n", __func__);
 
 	mutex_lock(&s->vb_queue_lock);
@@ -820,6 +836,7 @@ static int msi3101_querycap(struct file *file, void *fh,
 		struct v4l2_capability *cap)
 {
 	struct msi3101_state *s = video_drvdata(file);
+
 	dev_dbg(&s->udev->dev, "%s:\n", __func__);
 
 	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
@@ -837,6 +854,7 @@ static int msi3101_queue_setup(struct vb2_queue *vq,
 		unsigned int *nplanes, unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct msi3101_state *s = vb2_get_drv_priv(vq);
+
 	dev_dbg(&s->udev->dev, "%s: *nbuffers=%d\n", __func__, *nbuffers);
 
 	/* Absolute min and max number of buffers available for mmap() */
@@ -871,15 +889,16 @@ static void msi3101_buf_queue(struct vb2_buffer *vb)
 #define CMD_STOP_STREAMING     0x45
 #define CMD_READ_UNKNOW        0x48
 
-#define msi3101_dbg_usb_control_msg(udev, r, t, v, _i, b, l) { \
-	char *direction; \
-	if (t == (USB_TYPE_VENDOR | USB_DIR_OUT)) \
-		direction = ">>>"; \
+#define msi3101_dbg_usb_control_msg(_udev, _r, _t, _v, _i, _b, _l) { \
+	char *_direction; \
+	if (_t & USB_DIR_IN) \
+		_direction = "<<<"; \
 	else \
-		direction = "<<<"; \
-	dev_dbg(&udev->dev, "%s: %02x %02x %02x %02x %02x %02x %02x %02x " \
-			"%s %*ph\n",  __func__, t, r, v & 0xff, v >> 8, \
-			_i & 0xff, _i >> 8, l & 0xff, l >> 8, direction, l, b); \
+		_direction = ">>>"; \
+	dev_dbg(&_udev->dev, "%s: %02x %02x %02x %02x %02x %02x %02x %02x " \
+			"%s %*ph\n",  __func__, _t, _r, _v & 0xff, _v >> 8, \
+			_i & 0xff, _i >> 8, _l & 0xff, _l >> 8, _direction, \
+			_l, _b); \
 }
 
 static int msi3101_ctrl_msg(struct msi3101_state *s, u8 cmd, u32 data)
@@ -915,9 +934,11 @@ static int msi3101_set_usb_adc(struct msi3101_state *s)
 	f_sr = s->f_adc;
 
 	/* set tuner, subdev, filters according to sampling rate */
-	bandwidth_auto = v4l2_ctrl_find(&s->hdl, V4L2_CID_RF_TUNER_BANDWIDTH_AUTO);
+	bandwidth_auto = v4l2_ctrl_find(&s->hdl,
+			V4L2_CID_RF_TUNER_BANDWIDTH_AUTO);
 	if (v4l2_ctrl_g_ctrl(bandwidth_auto)) {
-		bandwidth = v4l2_ctrl_find(&s->hdl, V4L2_CID_RF_TUNER_BANDWIDTH);
+		bandwidth = v4l2_ctrl_find(&s->hdl,
+				V4L2_CID_RF_TUNER_BANDWIDTH);
 		v4l2_ctrl_s_ctrl(bandwidth, s->f_adc);
 	}
 
@@ -935,11 +956,11 @@ static int msi3101_set_usb_adc(struct msi3101_state *s)
 		s->convert_stream = msi3101_convert_stream_504;
 		reg7 = 0x000c9407;
 		break;
-	case V4L2_PIX_FMT_SDR_MSI2500_384:
+	case MSI2500_PIX_FMT_SDR_MSI2500_384:
 		s->convert_stream = msi3101_convert_stream_384;
 		reg7 = 0x0000a507;
 		break;
-	case V4L2_PIX_FMT_SDR_S12:
+	case MSI2500_PIX_FMT_SDR_S12:
 		s->convert_stream = msi3101_convert_stream_336;
 		reg7 = 0x00008507;
 		break;
@@ -1012,7 +1033,8 @@ static int msi3101_set_usb_adc(struct msi3101_state *s)
 
 	dev_dbg(&s->udev->dev,
 			"%s: f_sr=%d f_vco=%d div_n=%d div_m=%d div_r_out=%d reg3=%08x reg4=%08x\n",
-			__func__, f_sr, f_vco, div_n, div_m, div_r_out, reg3, reg4);
+			__func__, f_sr, f_vco, div_n, div_m, div_r_out, reg3,
+			reg4);
 
 	ret = msi3101_ctrl_msg(s, CMD_WREG, 0x00608008);
 	if (ret)
@@ -1053,6 +1075,7 @@ static int msi3101_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct msi3101_state *s = vb2_get_drv_priv(vq);
 	int ret;
+
 	dev_dbg(&s->udev->dev, "%s:\n", __func__);
 
 	if (!s->udev)
@@ -1116,6 +1139,7 @@ static int msi3101_enum_fmt_sdr_cap(struct file *file, void *priv,
 		struct v4l2_fmtdesc *f)
 {
 	struct msi3101_state *s = video_drvdata(file);
+
 	dev_dbg(&s->udev->dev, "%s: index=%d\n", __func__, f->index);
 
 	if (f->index >= s->num_formats)
@@ -1131,6 +1155,7 @@ static int msi3101_g_fmt_sdr_cap(struct file *file, void *priv,
 		struct v4l2_format *f)
 {
 	struct msi3101_state *s = video_drvdata(file);
+
 	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
 			(char *)&s->pixelformat);
 
@@ -1147,6 +1172,7 @@ static int msi3101_s_fmt_sdr_cap(struct file *file, void *priv,
 	struct msi3101_state *s = video_drvdata(file);
 	struct vb2_queue *q = &s->vb_queue;
 	int i;
+
 	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
 			(char *)&f->fmt.sdr.pixelformat);
 
@@ -1176,6 +1202,7 @@ static int msi3101_try_fmt_sdr_cap(struct file *file, void *priv,
 {
 	struct msi3101_state *s = video_drvdata(file);
 	int i;
+
 	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
 			(char *)&f->fmt.sdr.pixelformat);
 
@@ -1198,6 +1225,7 @@ static int msi3101_s_tuner(struct file *file, void *priv,
 {
 	struct msi3101_state *s = video_drvdata(file);
 	int ret;
+
 	dev_dbg(&s->udev->dev, "%s: index=%d\n", __func__, v->index);
 
 	if (v->index == 0)
@@ -1214,6 +1242,7 @@ static int msi3101_g_tuner(struct file *file, void *priv, struct v4l2_tuner *v)
 {
 	struct msi3101_state *s = video_drvdata(file);
 	int ret;
+
 	dev_dbg(&s->udev->dev, "%s: index=%d\n", __func__, v->index);
 
 	if (v->index == 0) {
@@ -1237,6 +1266,7 @@ static int msi3101_g_frequency(struct file *file, void *priv,
 {
 	struct msi3101_state *s = video_drvdata(file);
 	int ret  = 0;
+
 	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d\n",
 			__func__, f->tuner, f->type);
 
@@ -1258,6 +1288,7 @@ static int msi3101_s_frequency(struct file *file, void *priv,
 {
 	struct msi3101_state *s = video_drvdata(file);
 	int ret;
+
 	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d frequency=%u\n",
 			__func__, f->tuner, f->type, f->frequency);
 
@@ -1282,6 +1313,7 @@ static int msi3101_enum_freq_bands(struct file *file, void *priv,
 {
 	struct msi3101_state *s = video_drvdata(file);
 	int ret;
+
 	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d index=%d\n",
 			__func__, band->tuner, band->type, band->index);
 
-- 
http://palosaari.fi/

