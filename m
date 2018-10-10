Return-path: <linux-media-owner@vger.kernel.org>
Received: from vps-vb.mhejs.net ([37.28.154.113]:46828 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbeJKEVa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Oct 2018 00:21:30 -0400
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To: Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andy Walls <awalls@md.metrocast.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH v8 4/4] [media] cxusb: add raw mode support for Medion MD95700
Date: Wed, 10 Oct 2018 22:27:20 +0200
Message-Id: <9fa99ccced709ca7b35c333baf59197450a2ee21.1539198676.git.mail@maciej.szmigiero.name>
In-Reply-To: <cover.1539198675.git.mail@maciej.szmigiero.name>
References: <cover.1539198675.git.mail@maciej.szmigiero.name>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds raw (unprocessed) BT.656 stream capturing support for the analog
part of Medion 95700.
It can be enabled by setting CXUSB_EXTENDEDMODE_CAPTURE_RAW flag in
parm.capture.extendedmode passed to VIDIOC_S_PARM.

Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
---
 drivers/media/usb/dvb-usb/cxusb-analog.c | 190 +++++++++++++++++++----
 drivers/media/usb/dvb-usb/cxusb.h        |   4 +
 drivers/media/v4l2-core/v4l2-ioctl.c     |   3 +-
 3 files changed, 163 insertions(+), 34 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/cxusb-analog.c b/drivers/media/usb/dvb-usb/cxusb-analog.c
index c726e578b5da..f8dcb8240d5c 100644
--- a/drivers/media/usb/dvb-usb/cxusb-analog.c
+++ b/drivers/media/usb/dvb-usb/cxusb-analog.c
@@ -44,7 +44,9 @@ static int cxusb_medion_v_queue_setup(struct vb2_queue *q,
 {
 	struct dvb_usb_device *dvbdev = vb2_get_drv_priv(q);
 	struct cxusb_medion_dev *cxdev = dvbdev->priv;
-	unsigned int size = cxdev->width * cxdev->height * 2;
+	unsigned int size = cxdev->raw_mode ?
+		CXUSB_VIDEO_MAX_FRAME_SIZE :
+		cxdev->width * cxdev->height * 2;
 
 	if (*num_planes > 0) {
 		if (*num_planes != 1)
@@ -67,8 +69,13 @@ static int cxusb_medion_v_buf_init(struct vb2_buffer *vb)
 
 	cxusb_vprintk(dvbdev, OPS, "buffer init\n");
 
-	if (vb2_plane_size(vb, 0) < cxdev->width * cxdev->height * 2)
-		return -ENOMEM;
+	if (cxdev->raw_mode) {
+		if (vb2_plane_size(vb, 0) < CXUSB_VIDEO_MAX_FRAME_SIZE)
+			return -ENOMEM;
+	} else {
+		if (vb2_plane_size(vb, 0) < cxdev->width * cxdev->height * 2)
+			return -ENOMEM;
+	}
 
 	cxusb_vprintk(dvbdev, OPS, "buffer OK\n");
 
@@ -442,6 +449,45 @@ static bool cxusb_medion_copy_field(struct dvb_usb_device *dvbdev,
 	return true;
 }
 
+static void cxusb_medion_v_process_urb_raw(struct cxusb_medion_dev *cxdev,
+					   struct urb *urb)
+{
+	struct dvb_usb_device *dvbdev = cxdev->dvbdev;
+	u8 *buf;
+	struct cxusb_medion_vbuffer *vbuf;
+	int i;
+	unsigned long len;
+
+	if (list_empty(&cxdev->buflist)) {
+		dev_warn(&dvbdev->udev->dev, "no free buffers\n");
+		cxdev->vbuf_sequence++;
+		return;
+	}
+
+	vbuf = list_first_entry(&cxdev->buflist, struct cxusb_medion_vbuffer,
+				list);
+	list_del(&vbuf->list);
+
+	vbuf->vb2.field = V4L2_FIELD_NONE;
+	vbuf->vb2.sequence = cxdev->vbuf_sequence++;
+	vbuf->vb2.vb2_buf.timestamp = ktime_get_ns();
+
+	buf = vb2_plane_vaddr(&vbuf->vb2.vb2_buf, 0);
+
+	for (i = 0, len = 0; i < urb->number_of_packets; i++) {
+		memcpy(buf, urb->transfer_buffer +
+		       urb->iso_frame_desc[i].offset,
+		       urb->iso_frame_desc[i].actual_length);
+
+		buf += urb->iso_frame_desc[i].actual_length;
+		len += urb->iso_frame_desc[i].actual_length;
+	}
+
+	vb2_set_plane_payload(&vbuf->vb2.vb2_buf, 0, len);
+
+	vb2_buffer_done(&vbuf->vb2.vb2_buf, VB2_BUF_STATE_DONE);
+}
+
 static bool cxusb_medion_v_process_auxbuf(struct cxusb_medion_dev *cxdev,
 					  bool reset)
 {
@@ -566,22 +612,26 @@ static bool cxusb_medion_v_complete_handle_urb(struct cxusb_medion_dev *cxdev,
 			      len);
 
 		if (len > 0) {
-			cxusb_vprintk(dvbdev, URB, "appending URB\n");
-
-			/*
-			 * append new data to auxbuf while
-			 * overwriting old data if necessary
-			 *
-			 * if any overwrite happens then we can no
-			 * longer rely on consistency of the whole
-			 * data so let's start again the current
-			 * auxbuf frame assembling process from
-			 * the beginning
-			 */
-			*auxbuf_reset =
-				!cxusb_auxbuf_append_urb(dvbdev,
-							 &cxdev->auxbuf,
-							 urb);
+			if (cxdev->raw_mode)
+				cxusb_medion_v_process_urb_raw(cxdev, urb);
+			else {
+				cxusb_vprintk(dvbdev, URB, "appending URB\n");
+
+				/*
+				 * append new data to auxbuf while
+				 * overwriting old data if necessary
+				 *
+				 * if any overwrite happens then we can no
+				 * longer rely on consistency of the whole
+				 * data so let's start again the current
+				 * auxbuf frame assembling process from
+				 * the beginning
+				 */
+				*auxbuf_reset =
+					!cxusb_auxbuf_append_urb(dvbdev,
+								 &cxdev->auxbuf,
+								 urb);
+			}
 		}
 	}
 
@@ -616,7 +666,8 @@ static void cxusb_medion_v_complete_work(struct work_struct *work)
 
 	reschedule = cxusb_medion_v_complete_handle_urb(cxdev, &auxbuf_reset);
 
-	if (cxusb_medion_v_process_auxbuf(cxdev, auxbuf_reset))
+	if (!cxdev->raw_mode && cxusb_medion_v_process_auxbuf(cxdev,
+							      auxbuf_reset))
 		/* reschedule us until auxbuf no longer can produce any frame */
 		reschedule = true;
 
@@ -755,9 +806,13 @@ static int cxusb_medion_v_start_streaming(struct vb2_queue *q,
 		goto ret_unstream_cx;
 	}
 
-	ret = cxusb_medion_v_ss_auxbuf_alloc(cxdev, &npackets);
-	if (ret != 0)
-		goto ret_unstream_md;
+	if (cxdev->raw_mode)
+		npackets = CXUSB_VIDEO_MAX_FRAME_PKTS;
+	else {
+		ret = cxusb_medion_v_ss_auxbuf_alloc(cxdev, &npackets);
+		if (ret != 0)
+			goto ret_unstream_md;
+	}
 
 	for (i = 0; i < CXUSB_VIDEO_URBS; i++) {
 		int framen;
@@ -813,9 +868,11 @@ static int cxusb_medion_v_start_streaming(struct vb2_queue *q,
 	cxdev->nexturb = 0;
 	cxdev->vbuf_sequence = 0;
 
-	cxdev->vbuf = NULL;
-	cxdev->bt656.mode = NEW_FRAME;
-	cxdev->bt656.buf = NULL;
+	if (!cxdev->raw_mode) {
+		cxdev->vbuf = NULL;
+		cxdev->bt656.mode = NEW_FRAME;
+		cxdev->bt656.buf = NULL;
+	}
 
 	for (i = 0; i < CXUSB_VIDEO_URBS; i++)
 		if (cxdev->streamurbs[i] != NULL) {
@@ -833,7 +890,8 @@ static int cxusb_medion_v_start_streaming(struct vb2_queue *q,
 	cxusb_medion_urbs_free(cxdev);
 
 ret_freeab:
-	vfree(cxdev->auxbuf.buf);
+	if (!cxdev->raw_mode)
+		vfree(cxdev->auxbuf.buf);
 
 ret_unstream_md:
 	cxusb_ctrl_msg(dvbdev, CMD_STREAMING_OFF, NULL, 0, NULL, 0);
@@ -880,7 +938,8 @@ static void cxusb_medion_v_stop_streaming(struct vb2_queue *q)
 	mutex_lock(cxdev->videodev->lock);
 
 	/* free transfer buffer and URB */
-	vfree(cxdev->auxbuf.buf);
+	if (!cxdev->raw_mode)
+		vfree(cxdev->auxbuf.buf);
 
 	cxusb_medion_urbs_free(cxdev);
 
@@ -953,9 +1012,11 @@ static int cxusb_medion_g_fmt_vid_cap(struct file *file, void *fh,
 	f->fmt.pix.height = cxdev->height;
 	f->fmt.pix.pixelformat = V4L2_PIX_FMT_UYVY;
 	f->fmt.pix.field = V4L2_FIELD_SEQ_TB;
-	f->fmt.pix.bytesperline = cxdev->width * 2;
+	f->fmt.pix.bytesperline = cxdev->raw_mode ? 0 : cxdev->width * 2;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
-	f->fmt.pix.sizeimage = f->fmt.pix.bytesperline * f->fmt.pix.height;
+	f->fmt.pix.sizeimage =
+		cxdev->raw_mode ? CXUSB_VIDEO_MAX_FRAME_SIZE :
+		f->fmt.pix.bytesperline * f->fmt.pix.height;
 	f->fmt.pix.priv = 0;
 
 	return 0;
@@ -1010,8 +1071,10 @@ static int cxusb_medion_try_s_fmt_vid_cap(struct file *file,
 	f->fmt.pix.height = subfmt.format.height;
 	f->fmt.pix.pixelformat = V4L2_PIX_FMT_UYVY;
 	f->fmt.pix.field = V4L2_FIELD_SEQ_TB;
-	f->fmt.pix.bytesperline = f->fmt.pix.width * 2;
-	f->fmt.pix.sizeimage = f->fmt.pix.bytesperline * f->fmt.pix.height;
+	f->fmt.pix.bytesperline = cxdev->raw_mode ? 0 : f->fmt.pix.width * 2;
+	f->fmt.pix.sizeimage =
+		cxdev->raw_mode ? CXUSB_VIDEO_MAX_FRAME_SIZE :
+		f->fmt.pix.bytesperline * f->fmt.pix.height;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 	f->fmt.pix.priv = 0;
 
@@ -1340,6 +1403,67 @@ static int cxusb_medion_s_std(struct file *file, void *fh,
 	return 0;
 }
 
+static int cxusb_medion_g_s_parm(struct file *file, void *fh,
+				 struct v4l2_streamparm *param)
+{
+	v4l2_std_id std;
+
+	if (param->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	param->parm.capture.readbuffers = 2;
+
+	if (cxusb_medion_g_std(file, fh, &std) == 0)
+		v4l2_video_std_frame_period(std,
+					    &param->parm.capture.timeperframe);
+
+	return 0;
+}
+
+static int cxusb_medion_g_parm(struct file *file, void *fh,
+			       struct v4l2_streamparm *param)
+{
+	struct dvb_usb_device *dvbdev = video_drvdata(file);
+	struct cxusb_medion_dev *cxdev = dvbdev->priv;
+	int ret;
+
+	ret = cxusb_medion_g_s_parm(file, fh, param);
+	if (ret != 0)
+		return ret;
+
+	if (cxdev->raw_mode)
+		param->parm.capture.extendedmode |=
+			CXUSB_EXTENDEDMODE_CAPTURE_RAW;
+
+	return 0;
+}
+
+static int cxusb_medion_s_parm(struct file *file, void *fh,
+			       struct v4l2_streamparm *param)
+{
+	struct dvb_usb_device *dvbdev = video_drvdata(file);
+	struct cxusb_medion_dev *cxdev = dvbdev->priv;
+	int ret;
+	bool want_raw;
+
+	ret = cxusb_medion_g_s_parm(file, fh, param);
+	if (ret != 0)
+		return ret;
+
+	want_raw = param->parm.capture.extendedmode &
+		CXUSB_EXTENDEDMODE_CAPTURE_RAW;
+
+	if (want_raw != cxdev->raw_mode) {
+		if (vb2_start_streaming_called(&cxdev->videoqueue) ||
+		    cxdev->stop_streaming)
+			return -EBUSY;
+
+		cxdev->raw_mode = want_raw;
+	}
+
+	return 0;
+}
+
 static int cxusb_medion_log_status(struct file *file, void *fh)
 {
 	struct dvb_usb_device *dvbdev = video_drvdata(file);
@@ -1359,6 +1483,8 @@ static const struct v4l2_ioctl_ops cxusb_video_ioctl = {
 	.vidioc_enum_input = cxusb_medion_enum_input,
 	.vidioc_g_input = cxusb_medion_g_input,
 	.vidioc_s_input = cxusb_medion_s_input,
+	.vidioc_g_parm = cxusb_medion_g_parm,
+	.vidioc_s_parm = cxusb_medion_s_parm,
 	.vidioc_g_tuner = cxusb_medion_g_tuner,
 	.vidioc_s_tuner = cxusb_medion_s_tuner,
 	.vidioc_g_frequency = cxusb_medion_g_frequency,
diff --git a/drivers/media/usb/dvb-usb/cxusb.h b/drivers/media/usb/dvb-usb/cxusb.h
index edd7e873e619..e08c946f7c35 100644
--- a/drivers/media/usb/dvb-usb/cxusb.h
+++ b/drivers/media/usb/dvb-usb/cxusb.h
@@ -130,6 +130,7 @@ struct cxusb_medion_dev {
 	u32 input;
 	bool stop_streaming;
 	u32 width, height;
+	bool raw_mode;
 	struct cxusb_medion_auxbuf auxbuf;
 	v4l2_std_id norm;
 
@@ -153,6 +154,9 @@ struct cxusb_medion_vbuffer {
 	struct list_head list;
 };
 
+/* Capture streaming parameters extendedmode field flags */
+#define CXUSB_EXTENDEDMODE_CAPTURE_RAW 1
+
 /* defines for "debug" module parameter */
 #define CXUSB_DBG_RC BIT(0)
 #define CXUSB_DBG_I2C BIT(1)
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 7de041bae84f..3784d3bfd964 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1970,7 +1970,7 @@ static int v4l_s_parm(const struct v4l2_ioctl_ops *ops,
 	if (ret)
 		return ret;
 
-	/* Note: extendedmode is never used in drivers */
+	/* Note: extendedmode is never used in output drivers */
 	if (V4L2_TYPE_IS_OUTPUT(p->type)) {
 		memset(p->parm.output.reserved, 0,
 		       sizeof(p->parm.output.reserved));
@@ -1979,7 +1979,6 @@ static int v4l_s_parm(const struct v4l2_ioctl_ops *ops,
 	} else {
 		memset(p->parm.capture.reserved, 0,
 		       sizeof(p->parm.capture.reserved));
-		p->parm.capture.extendedmode = 0;
 		p->parm.capture.capturemode &= V4L2_MODE_HIGHQUALITY;
 	}
 	return ops->vidioc_s_parm(file, fh, p);
