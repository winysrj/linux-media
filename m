Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:54340 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752305AbeCCUvV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Mar 2018 15:51:21 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 11/11] media: em28xx-video: fix most coding style issues
Date: Sat,  3 Mar 2018 17:51:12 -0300
Message-Id: <686d29a5ba7d180ad9fb84a6fb7bd2d785ab9153.1520110127.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520110127.git.mchehab@s-opensource.com>
References: <cover.1520110127.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520110127.git.mchehab@s-opensource.com>
References: <cover.1520110127.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are a number of coding style issues at em28xx-video.
Fix most of them, by using checkpatch in strict mode to point
for it.

Automatic fixes were made with --fix-inplace, but those
were complemented by manual work.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 277 ++++++++++++++++++--------------
 1 file changed, 158 insertions(+), 119 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 540c62c87f3f..347f14b1749a 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -246,7 +246,8 @@ static int em28xx_set_outfmt(struct em28xx *dev)
 	if (em28xx_vbi_supported(dev) == 1) {
 		vinctrl |= EM28XX_VINCTRL_VBI_RAW;
 		em28xx_write_reg(dev, EM28XX_R34_VBI_START_H, 0x00);
-		em28xx_write_reg(dev, EM28XX_R36_VBI_WIDTH, v4l2->vbi_width/4);
+		em28xx_write_reg(dev, EM28XX_R36_VBI_WIDTH,
+				 v4l2->vbi_width / 4);
 		em28xx_write_reg(dev, EM28XX_R37_VBI_HEIGHT, v4l2->vbi_height);
 		if (v4l2->norm & V4L2_STD_525_60) {
 			/* NTSC */
@@ -316,8 +317,10 @@ static int em28xx_scaler_set(struct em28xx *dev, u16 h, u16 v)
 		buf[0] = v;
 		buf[1] = v >> 8;
 		em28xx_write_regs(dev, EM28XX_R32_VSCALELOW, (char *)buf, 2);
-		/* it seems that both H and V scalers must be active
-		   to work correctly */
+		/*
+		 * it seems that both H and V scalers must be active
+		 * to work correctly
+		 */
 		mode = (h || v) ? 0x30 : 0x00;
 	}
 	return em28xx_write_reg(dev, EM28XX_R26_COMPR, mode);
@@ -341,13 +344,15 @@ static int em28xx_resolution_set(struct em28xx *dev)
 
 	em28xx_accumulator_set(dev, 1, (width - 4) >> 2, 1, (height - 4) >> 2);
 
-	/* If we don't set the start position to 2 in VBI mode, we end up
-	   with line 20/21 being YUYV encoded instead of being in 8-bit
-	   greyscale.  The core of the issue is that line 21 (and line 23 for
-	   PAL WSS) are inside of active video region, and as a result they
-	   get the pixelformatting associated with that area.  So by cropping
-	   it out, we end up with the same format as the rest of the VBI
-	   region */
+	/*
+	 * If we don't set the start position to 2 in VBI mode, we end up
+	 * with line 20/21 being YUYV encoded instead of being in 8-bit
+	 * greyscale.  The core of the issue is that line 21 (and line 23 for
+	 * PAL WSS) are inside of active video region, and as a result they
+	 * get the pixelformatting associated with that area.  So by cropping
+	 * it out, we end up with the same format as the rest of the VBI
+	 * region
+	 */
 	if (em28xx_vbi_supported(dev) == 1)
 		em28xx_capture_area_set(dev, 0, 2, width, height);
 	else
@@ -361,14 +366,16 @@ static int em28xx_set_alternate(struct em28xx *dev)
 {
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 	struct usb_device *udev = interface_to_usbdev(dev->intf);
-	int errCode;
+	int err;
 	int i;
 	unsigned int min_pkt_size = v4l2->width * 2 + 4;
 
-	/* NOTE: for isoc transfers, only alt settings > 0 are allowed
-		 bulk transfers seem to work only with alt=0 ! */
+	/*
+	 * NOTE: for isoc transfers, only alt settings > 0 are allowed
+	 * bulk transfers seem to work only with alt=0 !
+	 */
 	dev->alt = 0;
-	if ((alt > 0) && (alt < dev->num_alt)) {
+	if (alt > 0 && alt < dev->num_alt) {
 		em28xx_videodbg("alternate forced to %d\n", dev->alt);
 		dev->alt = alt;
 		goto set_alt;
@@ -376,9 +383,10 @@ static int em28xx_set_alternate(struct em28xx *dev)
 	if (dev->analog_xfer_bulk)
 		goto set_alt;
 
-	/* When image size is bigger than a certain value,
-	   the frame size should be increased, otherwise, only
-	   green screen will be received.
+	/*
+	 * When image size is bigger than a certain value,
+	 * the frame size should be increased, otherwise, only
+	 * green screen will be received.
 	 */
 	if (v4l2->width * 2 * v4l2->height > 720 * 240 * 2)
 		min_pkt_size *= 2;
@@ -388,18 +396,22 @@ static int em28xx_set_alternate(struct em28xx *dev)
 		if (dev->alt_max_pkt_size_isoc[i] >= min_pkt_size) {
 			dev->alt = i;
 			break;
-		/* otherwise make sure that we end up with the maximum bandwidth
-		   because the min_pkt_size equation might be wrong...
-		*/
+		/*
+		 * otherwise make sure that we end up with the maximum
+		 * bandwidth because the min_pkt_size equation might be wrong.
+		 *
+		 */
 		} else if (dev->alt_max_pkt_size_isoc[i] >
 			   dev->alt_max_pkt_size_isoc[dev->alt])
 			dev->alt = i;
 	}
 
 set_alt:
-	/* NOTE: for bulk transfers, we need to call usb_set_interface()
+	/*
+	 * NOTE: for bulk transfers, we need to call usb_set_interface()
 	 * even if the previous settings were the same. Otherwise streaming
-	 * fails with all urbs having status = -EOVERFLOW ! */
+	 * fails with all urbs having status = -EOVERFLOW !
+	 */
 	if (dev->analog_xfer_bulk) {
 		dev->max_pkt_size = 512; /* USB 2.0 spec */
 		dev->packet_multiplier = EM28XX_BULK_PACKET_MULTIPLIER;
@@ -412,19 +424,19 @@ static int em28xx_set_alternate(struct em28xx *dev)
 	}
 	em28xx_videodbg("setting alternate %d with wMaxPacketSize=%u\n",
 			dev->alt, dev->max_pkt_size);
-	errCode = usb_set_interface(udev, dev->ifnum, dev->alt);
-	if (errCode < 0) {
+	err = usb_set_interface(udev, dev->ifnum, dev->alt);
+	if (err < 0) {
 		dev_err(&dev->intf->dev,
 			"cannot change alternate number to %d (error=%i)\n",
-			dev->alt, errCode);
-		return errCode;
+			dev->alt, err);
+		return err;
 	}
 	return 0;
 }
 
-/* ------------------------------------------------------------------
-	DMA and thread functions
-   ------------------------------------------------------------------*/
+/*
+ * DMA and thread functions
+ */
 
 /*
  * Finish the current buffer
@@ -510,8 +522,9 @@ static void em28xx_copy_video(struct em28xx *dev,
 			em28xx_isocdbg("Overflow of %zu bytes past buffer end(2)\n",
 				       ((char *)startwrite + lencopy) -
 				       ((char *)buf->vb_buf + buf->length));
-			lencopy = remain = (char *)buf->vb_buf + buf->length -
-				(char *)startwrite;
+			remain = (char *)buf->vb_buf + buf->length -
+				 (char *)startwrite;
+			lencopy = remain;
 		}
 		if (lencopy <= 0)
 			break;
@@ -619,11 +632,11 @@ finish_field_prepare_next(struct em28xx *dev,
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 
 	if (v4l2->progressive || v4l2->top_field) { /* Brand new frame */
-		if (buf != NULL)
+		if (buf)
 			finish_buffer(dev, buf);
 		buf = get_next_buf(dev, dma_q);
 	}
-	if (buf != NULL) {
+	if (buf) {
 		buf->top_field = v4l2->top_field;
 		buf->pos = 0;
 	}
@@ -644,13 +657,17 @@ static inline void process_frame_data_em28xx(struct em28xx *dev,
 	struct em28xx_dmaqueue  *dma_q = &dev->vidq;
 	struct em28xx_dmaqueue  *vbi_dma_q = &dev->vbiq;
 
-	/* capture type 0 = vbi start
-	   capture type 1 = vbi in progress
-	   capture type 2 = video start
-	   capture type 3 = video in progress */
+	/*
+	 * capture type 0 = vbi start
+	 * capture type 1 = vbi in progress
+	 * capture type 2 = video start
+	 * capture type 3 = video in progress
+	 */
 	if (data_len >= 4) {
-		/* NOTE: Headers are always 4 bytes and
-		 * never split across packets */
+		/*
+		 * NOTE: Headers are always 4 bytes and
+		 * never split across packets
+		 */
 		if (data_pkt[0] == 0x88 && data_pkt[1] == 0x88 &&
 		    data_pkt[2] == 0x88 && data_pkt[3] == 0x88) {
 			/* Continuation */
@@ -673,8 +690,10 @@ static inline void process_frame_data_em28xx(struct em28xx *dev,
 			data_len -= 4;
 		}
 	}
-	/* NOTE: With bulk transfers, intermediate data packets
-	 * have no continuation header */
+	/*
+	 * NOTE: With bulk transfers, intermediate data packets
+	 * have no continuation header
+	 */
 
 	if (v4l2->capture_type == 0) {
 		vbi_buf = finish_field_prepare_next(dev, vbi_buf, vbi_dma_q);
@@ -688,7 +707,7 @@ static inline void process_frame_data_em28xx(struct em28xx *dev,
 				   (vbi_size - v4l2->vbi_read) : data_len;
 
 		/* Copy VBI data */
-		if (vbi_buf != NULL)
+		if (vbi_buf)
 			em28xx_copy_vbi(dev, vbi_buf, data_pkt, vbi_data_len);
 		v4l2->vbi_read += vbi_data_len;
 
@@ -706,7 +725,7 @@ static inline void process_frame_data_em28xx(struct em28xx *dev,
 		v4l2->capture_type = 3;
 	}
 
-	if (v4l2->capture_type == 3 && buf != NULL && data_len > 0)
+	if (v4l2->capture_type == 3 && buf && data_len > 0)
 		em28xx_copy_video(dev, buf, data_pkt, data_len);
 }
 
@@ -723,8 +742,10 @@ static inline void process_frame_data_em25xx(struct em28xx *dev,
 	bool frame_end = false;
 
 	/* Check for header */
-	/* NOTE: at least with bulk transfers, only the first packet
-	 * has a header and has always set the FRAME_END bit         */
+	/*
+	 * NOTE: at least with bulk transfers, only the first packet
+	 * has a header and has always set the FRAME_END bit
+	 */
 	if (data_len >= 2) {	/* em25xx header is only 2 bytes long */
 		if ((data_pkt[0] == EM25XX_FRMDATAHDR_BYTE1) &&
 		    ((data_pkt[1] & ~EM25XX_FRMDATAHDR_BYTE2_MASK) == 0x00)) {
@@ -741,14 +762,15 @@ static inline void process_frame_data_em25xx(struct em28xx *dev,
 			buf = finish_field_prepare_next(dev, buf, dmaq);
 			dev->usb_ctl.vid_buf = buf;
 		}
-		/* NOTE: in ISOC mode when a new frame starts and buf==NULL,
+		/*
+		 * NOTE: in ISOC mode when a new frame starts and buf==NULL,
 		 * we COULD already prepare a buffer here to avoid skipping the
 		 * first frame.
 		 */
 	}
 
 	/* Copy data */
-	if (buf != NULL && data_len > 0)
+	if (buf && data_len > 0)
 		em28xx_copy_video(dev, buf, data_pkt, data_len);
 
 	/* Finish frame (ISOC only) => avoids lag of 1 frame */
@@ -757,14 +779,17 @@ static inline void process_frame_data_em25xx(struct em28xx *dev,
 		dev->usb_ctl.vid_buf = buf;
 	}
 
-	/* NOTE: Tested with USB bulk transfers only !
+	/*
+	 * NOTES:
+	 *
+	 * 1) Tested with USB bulk transfers only !
 	 * The wording in the datasheet suggests that isoc might work different.
 	 * The current code assumes that with isoc transfers each packet has a
 	 * header like with the other em28xx devices.
+	 *
+	 * 2) Support for interlaced mode is pure theory. It has not been
+	 * tested and it is unknown if these devices actually support it.
 	 */
-	/* NOTE: Support for interlaced mode is pure theory. It has not been
-	 * tested and it is unknown if these devices actually support it. */
-	/* NOTE: No VBI support yet (these chips likely do not support VBI). */
 }
 
 /* Processes and copies the URB data content (video and VBI data) */
@@ -825,12 +850,11 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 		else
 			process_frame_data_em28xx(dev,
 						  usb_data_pkt, usb_data_len);
-
 	}
 	return 1;
 }
 
-static int get_ressource(enum v4l2_buf_type f_type)
+static int get_resource(enum v4l2_buf_type f_type)
 {
 	switch (f_type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
@@ -838,14 +862,15 @@ static int get_ressource(enum v4l2_buf_type f_type)
 	case V4L2_BUF_TYPE_VBI_CAPTURE:
 		return EM28XX_RESOURCE_VBI;
 	default:
-		BUG();
+		WARN_ON(1);
+		return -1; /* Indicate that device is busy */
 	}
 }
 
 /* Usage lock check functions */
 static int res_get(struct em28xx *dev, enum v4l2_buf_type f_type)
 {
-	int res_type = get_ressource(f_type);
+	int res_type = get_resource(f_type);
 
 	/* is it free? */
 	if (dev->resources & res_type) {
@@ -861,7 +886,7 @@ static int res_get(struct em28xx *dev, enum v4l2_buf_type f_type)
 
 static void res_free(struct em28xx *dev, enum v4l2_buf_type f_type)
 {
-	int res_type = get_ressource(f_type);
+	int res_type = get_resource(f_type);
 
 	dev->resources &= ~res_type;
 	em28xx_videodbg("res: put %d\n", res_type);
@@ -933,10 +958,11 @@ static int em28xx_enable_analog_tuner(struct em28xx *dev)
 				flags ? "enabled" : "disabled",
 				ret);
 			return ret;
-		} else
-			em28xx_videodbg("link %s->%s was %s\n",
-					source->name, sink->name,
-					flags ? "ENABLED" : "disabled");
+		}
+
+		em28xx_videodbg("link %s->%s was %s\n",
+				source->name, sink->name,
+				flags ? "ENABLED" : "disabled");
 	}
 #endif
 	return 0;
@@ -1012,10 +1038,9 @@ static void em28xx_v4l2_create_entities(struct em28xx *dev)
 #endif
 }
 
-
-/* ------------------------------------------------------------------
-	Videobuf2 operations
-   ------------------------------------------------------------------*/
+/*
+ * Videobuf2 operations
+ */
 
 static int queue_setup(struct vb2_queue *vq,
 		       unsigned int *nbuffers, unsigned int *nplanes,
@@ -1068,8 +1093,10 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 
 	em28xx_videodbg("%s\n", __func__);
 
-	/* Make sure streaming is not already in progress for this type
-	   of filehandle (e.g. video, vbi) */
+	/*
+	 * Make sure streaming is not already in progress for this type
+	 * of filehandle (e.g. video, vbi)
+	 */
 	rc = res_get(dev, vq->type);
 	if (rc)
 		return rc;
@@ -1080,9 +1107,10 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 		/* Allocate the USB bandwidth */
 		em28xx_set_alternate(dev);
 
-		/* Needed, since GPIO might have disabled power of
-		   some i2c device
-		*/
+		/*
+		 * Needed, since GPIO might have disabled power of
+		 * some i2c device
+		 */
 		em28xx_wake_i2c(dev);
 
 		v4l2->capture_type = -1;
@@ -1141,7 +1169,7 @@ static void em28xx_stop_streaming(struct vb2_queue *vq)
 	}
 
 	spin_lock_irqsave(&dev->slock, flags);
-	if (dev->usb_ctl.vid_buf != NULL) {
+	if (dev->usb_ctl.vid_buf) {
 		vb2_buffer_done(&dev->usb_ctl.vid_buf->vb.vb2_buf,
 				VB2_BUF_STATE_ERROR);
 		dev->usb_ctl.vid_buf = NULL;
@@ -1176,7 +1204,7 @@ void em28xx_stop_vbi_streaming(struct vb2_queue *vq)
 	}
 
 	spin_lock_irqsave(&dev->slock, flags);
-	if (dev->usb_ctl.vbi_buf != NULL) {
+	if (dev->usb_ctl.vbi_buf) {
 		vb2_buffer_done(&dev->usb_ctl.vbi_buf->vb.vb2_buf,
 				VB2_BUF_STATE_ERROR);
 		dev->usb_ctl.vbi_buf = NULL;
@@ -1257,7 +1285,9 @@ static int em28xx_vb2_setup(struct em28xx *dev)
 	return 0;
 }
 
-/*********************  v4l2 interface  **************************************/
+/*
+ * v4l2 interface
+ */
 
 static void video_mux(struct em28xx *dev, int index)
 {
@@ -1390,9 +1420,9 @@ static void scale_to_size(struct em28xx *dev,
 		*height = 1;
 }
 
-/* ------------------------------------------------------------------
-	IOCTL vidioc handling
-   ------------------------------------------------------------------*/
+/*
+ * IOCTL vidioc handling
+ */
 
 static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
@@ -1458,8 +1488,10 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 		if (width == maxw && height == maxh)
 			width /= 2;
 	} else {
-		/* width must even because of the YUYV format
-		   height must be even because of interlacing */
+		/*
+		 * width must even because of the YUYV format
+		 * height must be even because of interlacing
+		 */
 		v4l_bound_align_image(&width, 48, maxw, 1, &height, 32, maxh,
 				      1, 0);
 	}
@@ -1489,7 +1521,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 }
 
 static int em28xx_set_video_format(struct em28xx *dev, unsigned int fourcc,
-				   unsigned width, unsigned height)
+				   unsigned int width, unsigned int height)
 {
 	struct em28xx_fmt     *fmt;
 	struct em28xx_v4l2    *v4l2 = dev->v4l2;
@@ -1612,15 +1644,14 @@ static int vidioc_enum_input(struct file *file, void *priv,
 	n = i->index;
 	if (n >= MAX_EM28XX_INPUT)
 		return -EINVAL;
-	if (0 == INPUT(n)->type)
+	if (!INPUT(n)->type)
 		return -EINVAL;
 
-	i->index = n;
 	i->type = V4L2_INPUT_TYPE_CAMERA;
 
 	strcpy(i->name, iname[INPUT(n)->type]);
 
-	if ((EM28XX_VMUX_TELEVISION == INPUT(n)->type))
+	if (INPUT(n)->type == EM28XX_VMUX_TELEVISION)
 		i->type = V4L2_INPUT_TYPE_TUNER;
 
 	i->std = dev->v4l2->vdev.tvnorms;
@@ -1646,7 +1677,7 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 
 	if (i >= MAX_EM28XX_INPUT)
 		return -EINVAL;
-	if (0 == INPUT(i)->type)
+	if (!INPUT(i)->type)
 		return -EINVAL;
 
 	video_mux(dev, i);
@@ -1692,13 +1723,14 @@ static int vidioc_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
 	return 0;
 }
 
-static int vidioc_s_audio(struct file *file, void *priv, const struct v4l2_audio *a)
+static int vidioc_s_audio(struct file *file, void *priv,
+			  const struct v4l2_audio *a)
 {
 	struct em28xx *dev = video_drvdata(file);
 
 	if (a->index >= MAX_EM28XX_INPUT)
 		return -EINVAL;
-	if (0 == INPUT(a->index)->type)
+	if (!INPUT(a->index)->type)
 		return -EINVAL;
 
 	dev->ctl_ainput = INPUT(a->index)->amux;
@@ -1715,7 +1747,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 {
 	struct em28xx *dev = video_drvdata(file);
 
-	if (0 != t->index)
+	if (t->index != 0)
 		return -EINVAL;
 
 	strcpy(t->name, "Tuner");
@@ -1729,7 +1761,7 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 {
 	struct em28xx *dev = video_drvdata(file);
 
-	if (0 != t->index)
+	if (t->index != 0)
 		return -EINVAL;
 
 	v4l2_device_call_all(&dev->v4l2->v4l2_dev, 0, tuner, s_tuner, t);
@@ -1742,7 +1774,7 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 	struct em28xx         *dev = video_drvdata(file);
 	struct em28xx_v4l2    *v4l2 = dev->v4l2;
 
-	if (0 != f->tuner)
+	if (f->tuner != 0)
 		return -EINVAL;
 
 	f->frequency = v4l2->frequency;
@@ -1756,7 +1788,7 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	struct em28xx             *dev  = video_drvdata(file);
 	struct em28xx_v4l2        *v4l2 = dev->v4l2;
 
-	if (0 != f->tuner)
+	if (f->tuner != 0)
 		return -EINVAL;
 
 	v4l2_device_call_all(&v4l2->v4l2_dev, 0, tuner, s_frequency, f);
@@ -1880,8 +1912,9 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	if (dev->tuner_type != TUNER_ABSENT)
 		cap->device_caps |= V4L2_CAP_TUNER;
 
-	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS |
-		V4L2_CAP_READWRITE | V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps |
+			    V4L2_CAP_DEVICE_CAPS | V4L2_CAP_READWRITE |
+			    V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
 	if (video_is_registered(&v4l2->vbi_dev))
 		cap->capabilities |= V4L2_CAP_VBI_CAPTURE;
 	if (video_is_registered(&v4l2->radio_dev))
@@ -1974,9 +2007,9 @@ static int vidioc_g_fmt_vbi_cap(struct file *file, void *priv,
 	return 0;
 }
 
-/* ----------------------------------------------------------- */
-/* RADIO ESPECIFIC IOCTLS                                      */
-/* ----------------------------------------------------------- */
+/*
+ * RADIO ESPECIFIC IOCTLS
+ */
 
 static int radio_g_tuner(struct file *file, void *priv,
 			 struct v4l2_tuner *t)
@@ -1998,7 +2031,7 @@ static int radio_s_tuner(struct file *file, void *priv,
 {
 	struct em28xx *dev = video_drvdata(file);
 
-	if (0 != t->index)
+	if (t->index != 0)
 		return -EINVAL;
 
 	v4l2_device_call_all(&dev->v4l2->v4l2_dev, 0, tuner, s_tuner, t);
@@ -2093,7 +2126,7 @@ static int em28xx_v4l2_open(struct file *filp)
  * em28xx_v4l2_fini()
  * unregisters the v4l2,i2c and usb devices
  * called when the device gets disconected or at module unload
-*/
+ */
 static int em28xx_v4l2_fini(struct em28xx *dev)
 {
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
@@ -2108,7 +2141,7 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 		return 0;
 	}
 
-	if (v4l2 == NULL)
+	if (!v4l2)
 		return 0;
 
 	dev_info(&dev->intf->dev, "Closing video extension\n");
@@ -2123,17 +2156,17 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 
 	if (video_is_registered(&v4l2->radio_dev)) {
 		dev_info(&dev->intf->dev, "V4L2 device %s deregistered\n",
-			video_device_node_name(&v4l2->radio_dev));
+			 video_device_node_name(&v4l2->radio_dev));
 		video_unregister_device(&v4l2->radio_dev);
 	}
 	if (video_is_registered(&v4l2->vbi_dev)) {
 		dev_info(&dev->intf->dev, "V4L2 device %s deregistered\n",
-			video_device_node_name(&v4l2->vbi_dev));
+			 video_device_node_name(&v4l2->vbi_dev));
 		video_unregister_device(&v4l2->vbi_dev);
 	}
 	if (video_is_registered(&v4l2->vdev)) {
 		dev_info(&dev->intf->dev, "V4L2 device %s deregistered\n",
-			video_device_node_name(&v4l2->vdev));
+			 video_device_node_name(&v4l2->vdev));
 		video_unregister_device(&v4l2->vdev);
 	}
 
@@ -2185,7 +2218,7 @@ static int em28xx_v4l2_close(struct file *filp)
 	struct em28xx         *dev  = video_drvdata(filp);
 	struct em28xx_v4l2    *v4l2 = dev->v4l2;
 	struct usb_device *udev = interface_to_usbdev(dev->intf);
-	int              errCode;
+	int              err;
 
 	em28xx_videodbg("users=%d\n", v4l2->users);
 
@@ -2206,11 +2239,11 @@ static int em28xx_v4l2_close(struct file *filp)
 		/* set alternate 0 */
 		dev->alt = 0;
 		em28xx_videodbg("setting alternate 0\n");
-		errCode = usb_set_interface(udev, 0, 0);
-		if (errCode < 0) {
+		err = usb_set_interface(udev, 0, 0);
+		if (err < 0) {
 			dev_err(&dev->intf->dev,
 				"cannot change alternate number to 0 (error=%i)\n",
-				errCode);
+				err);
 		}
 	}
 
@@ -2368,7 +2401,7 @@ static void em28xx_tuner_setup(struct em28xx *dev, unsigned short tuner_addr)
 				     0, tuner, s_type_addr, &tun_setup);
 	}
 
-	if ((dev->tuner_type != TUNER_ABSENT) && (dev->tuner_type)) {
+	if (dev->tuner_type != TUNER_ABSENT && dev->tuner_type) {
 		tun_setup.type   = dev->tuner_type;
 		tun_setup.addr   = tuner_addr;
 
@@ -2431,7 +2464,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 
 	mutex_lock(&dev->lock);
 
-	v4l2 = kzalloc(sizeof(struct em28xx_v4l2), GFP_KERNEL);
+	v4l2 = kzalloc(sizeof(*v4l2), GFP_KERNEL);
 	if (!v4l2) {
 		mutex_unlock(&dev->lock);
 		return -ENOMEM;
@@ -2564,7 +2597,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 				__func__, ret);
 			goto unregister_dev;
 		}
-		msleep(3);
+		usleep_range(10000, 11000);
 
 		ret = em28xx_write_reg(dev, EM2820_R08_GPIO_CTRL, 0xff);
 		if (ret < 0) {
@@ -2573,7 +2606,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 				__func__, ret);
 			goto unregister_dev;
 		}
-		msleep(3);
+		usleep_range(10000, 11000);
 	}
 
 	/* set default norm */
@@ -2585,8 +2618,10 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	v4l2->format = &format[0];
 
 	maxw = norm_maxw(dev);
-	/* MaxPacketSize for em2800 is too small to capture at full resolution
-	 * use half of maxw as the scaler can only scale to 50% */
+	/*
+	 * MaxPacketSize for em2800 is too small to capture at full resolution
+	 * use half of maxw as the scaler can only scale to 50%
+	 */
 	if (dev->board.is_em2800)
 		maxw /= 2;
 
@@ -2607,29 +2642,33 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	em28xx_set_outfmt(dev);
 
 	/* Add image controls */
-	/* NOTE: at this point, the subdevices are already registered, so bridge
-	 * controls are only added/enabled when no subdevice provides them */
-	if (NULL == v4l2_ctrl_find(hdl, V4L2_CID_CONTRAST))
+
+	/*
+	 * NOTE: at this point, the subdevices are already registered, so
+	 * bridge controls are only added/enabled when no subdevice provides
+	 * them
+	 */
+	if (!v4l2_ctrl_find(hdl, V4L2_CID_CONTRAST))
 		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
 				  V4L2_CID_CONTRAST,
 				  0, 0x1f, 1, CONTRAST_DEFAULT);
-	if (NULL == v4l2_ctrl_find(hdl, V4L2_CID_BRIGHTNESS))
+	if (!v4l2_ctrl_find(hdl, V4L2_CID_BRIGHTNESS))
 		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
 				  V4L2_CID_BRIGHTNESS,
 				  -0x80, 0x7f, 1, BRIGHTNESS_DEFAULT);
-	if (NULL == v4l2_ctrl_find(hdl, V4L2_CID_SATURATION))
+	if (!v4l2_ctrl_find(hdl, V4L2_CID_SATURATION))
 		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
 				  V4L2_CID_SATURATION,
 				  0, 0x1f, 1, SATURATION_DEFAULT);
-	if (NULL == v4l2_ctrl_find(hdl, V4L2_CID_BLUE_BALANCE))
+	if (!v4l2_ctrl_find(hdl, V4L2_CID_BLUE_BALANCE))
 		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
 				  V4L2_CID_BLUE_BALANCE,
 				  -0x30, 0x30, 1, BLUE_BALANCE_DEFAULT);
-	if (NULL == v4l2_ctrl_find(hdl, V4L2_CID_RED_BALANCE))
+	if (!v4l2_ctrl_find(hdl, V4L2_CID_RED_BALANCE))
 		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
 				  V4L2_CID_RED_BALANCE,
 				  -0x30, 0x30, 1, RED_BALANCE_DEFAULT);
-	if (NULL == v4l2_ctrl_find(hdl, V4L2_CID_SHARPNESS))
+	if (!v4l2_ctrl_find(hdl, V4L2_CID_SHARPNESS))
 		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
 				  V4L2_CID_SHARPNESS,
 				  0, 0x0f, 1, SHARPNESS_DEFAULT);
@@ -2679,7 +2718,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	/* Allocate and fill vbi video_device struct */
 	if (em28xx_vbi_supported(dev) == 1) {
 		em28xx_vdev_init(dev, &v4l2->vbi_dev, &em28xx_video_template,
-				"vbi");
+				 "vbi");
 
 		v4l2->vbi_dev.queue = &v4l2->vb_vbiq;
 		v4l2->vbi_dev.queue->lock = &v4l2->vb_vbi_queue_lock;
@@ -2709,7 +2748,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 
 	if (em28xx_boards[dev->model].radio.type == EM28XX_RADIO) {
 		em28xx_vdev_init(dev, &v4l2->radio_dev, &em28xx_radio_template,
-				   "radio");
+				 "radio");
 		ret = video_register_device(&v4l2->radio_dev, VFL_TYPE_RADIO,
 					    radio_nr[dev->devno]);
 		if (ret < 0) {
-- 
2.14.3
