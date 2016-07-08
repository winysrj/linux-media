Return-path: <linux-media-owner@vger.kernel.org>
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:32302 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754344AbcGHL0M (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 07:26:12 -0400
From: Nick Dyer <nick@shmanahar.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Alan Bowens <Alan.Bowens@atmel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	Florian Echtler <floe@butterbrot.org>, mchehab@osg.samsung.com,
	jon.older@itdev.co.uk, nick.dyer@itdev.co.uk,
	Nick Dyer <nick@shmanahar.org>
Subject: [PATCH v7 02/11] v4l2-core: Add support for touch devices
Date: Fri,  8 Jul 2016 12:25:55 +0100
Message-Id: <1467977164-17551-3-git-send-email-nick@shmanahar.org>
In-Reply-To: <1467977164-17551-1-git-send-email-nick@shmanahar.org>
References: <1467977164-17551-1-git-send-email-nick@shmanahar.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some touch controllers send out touch data in a similar way to a
greyscale frame grabber.

Add new device type VFL_TYPE_TOUCH:
- This uses a new device prefix v4l-touch for these devices, to stop
  generic capture software from treating them as webcams. Otherwise,
  touch is treated similarly to video capture.
- Add V4L2_INPUT_TYPE_TOUCH
- Add MEDIA_INTF_T_V4L_TOUCH
- Add V4L2_CAP_TOUCH to indicate device is a touch device

Add formats:
- V4L2_TCH_FMT_DELTA_TD16 for signed 16-bit touch deltas
- V4L2_TCH_FMT_DELTA_TD08 for signed 16-bit touch deltas
- V4L2_TCH_FMT_TU16 for unsigned 16-bit touch data
- V4L2_TCH_FMT_TU08 for unsigned 8-bit touch data

This support will be used by:
- Atmel maXTouch (atmel_mxt_ts)
- Synaptics RMI4.
- sur40

Signed-off-by: Nick Dyer <nick@shmanahar.org>
Tested-By: Chris Healy <cphealy@gmail.com>
---
 drivers/media/media-entity.c         |    2 ++
 drivers/media/v4l2-core/v4l2-dev.c   |   16 ++++++++++++---
 drivers/media/v4l2-core/v4l2-ioctl.c |   36 +++++++++++++++++++++++++++++-----
 include/media/v4l2-dev.h             |    3 ++-
 include/uapi/linux/media.h           |    1 +
 include/uapi/linux/videodev2.h       |    9 +++++++++
 6 files changed, 58 insertions(+), 9 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index d8a2299..9014362 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -65,6 +65,8 @@ static inline const char *intf_type(struct media_interface *intf)
 		return "v4l-subdev";
 	case MEDIA_INTF_T_V4L_SWRADIO:
 		return "v4l-swradio";
+	case MEDIA_INTF_T_V4L_TOUCH:
+		return "v4l-touch";
 	case MEDIA_INTF_T_ALSA_PCM_CAPTURE:
 		return "alsa-pcm-capture";
 	case MEDIA_INTF_T_ALSA_PCM_PLAYBACK:
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 70b559d..21ba9b4 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -527,6 +527,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	bool is_vbi = vdev->vfl_type == VFL_TYPE_VBI;
 	bool is_radio = vdev->vfl_type == VFL_TYPE_RADIO;
 	bool is_sdr = vdev->vfl_type == VFL_TYPE_SDR;
+	bool is_tch = vdev->vfl_type == VFL_TYPE_TOUCH;
 	bool is_rx = vdev->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vdev->vfl_dir != VFL_DIR_RX;
 
@@ -573,7 +574,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	if (ops->vidioc_enum_freq_bands || ops->vidioc_g_tuner || ops->vidioc_g_modulator)
 		set_bit(_IOC_NR(VIDIOC_ENUM_FREQ_BANDS), valid_ioctls);
 
-	if (is_vid) {
+	if (is_vid || is_tch) {
 		/* video specific ioctls */
 		if ((is_rx && (ops->vidioc_enum_fmt_vid_cap ||
 			       ops->vidioc_enum_fmt_vid_cap_mplane ||
@@ -662,7 +663,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 			set_bit(_IOC_NR(VIDIOC_TRY_FMT), valid_ioctls);
 	}
 
-	if (is_vid || is_vbi || is_sdr) {
+	if (is_vid || is_vbi || is_sdr || is_tch) {
 		/* ioctls valid for video, vbi or sdr */
 		SET_VALID_IOCTL(ops, VIDIOC_REQBUFS, vidioc_reqbufs);
 		SET_VALID_IOCTL(ops, VIDIOC_QUERYBUF, vidioc_querybuf);
@@ -675,7 +676,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 		SET_VALID_IOCTL(ops, VIDIOC_STREAMOFF, vidioc_streamoff);
 	}
 
-	if (is_vid || is_vbi) {
+	if (is_vid || is_vbi || is_tch) {
 		/* ioctls valid for video or vbi */
 		if (ops->vidioc_s_std)
 			set_bit(_IOC_NR(VIDIOC_ENUMSTD), valid_ioctls);
@@ -751,6 +752,10 @@ static int video_register_media_controller(struct video_device *vdev, int type)
 		intf_type = MEDIA_INTF_T_V4L_SWRADIO;
 		vdev->entity.function = MEDIA_ENT_F_IO_SWRADIO;
 		break;
+	case VFL_TYPE_TOUCH:
+		intf_type = MEDIA_INTF_T_V4L_TOUCH;
+		vdev->entity.function = MEDIA_ENT_F_IO_V4L;
+		break;
 	case VFL_TYPE_RADIO:
 		intf_type = MEDIA_INTF_T_V4L_RADIO;
 		/*
@@ -845,6 +850,8 @@ static int video_register_media_controller(struct video_device *vdev, int type)
  *	%VFL_TYPE_SUBDEV - A subdevice
  *
  *	%VFL_TYPE_SDR - Software Defined Radio
+ *
+ *	%VFL_TYPE_TOUCH - A touch sensor
  */
 int __video_register_device(struct video_device *vdev, int type, int nr,
 		int warn_if_nr_in_use, struct module *owner)
@@ -888,6 +895,9 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 		/* Use device name 'swradio' because 'sdr' was already taken. */
 		name_base = "swradio";
 		break;
+	case VFL_TYPE_TOUCH:
+		name_base = "v4l-touch";
+		break;
 	default:
 		printk(KERN_ERR "%s called with unknown type: %d\n",
 		       __func__, type);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 28e5be2..c3463f7 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -924,6 +924,7 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
 	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
 	bool is_vbi = vfd->vfl_type == VFL_TYPE_VBI;
 	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
+	bool is_tch = vfd->vfl_type == VFL_TYPE_TOUCH;
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 
@@ -932,7 +933,7 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
 
 	switch (type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		if (is_vid && is_rx &&
+		if ((is_vid || is_tch) && is_rx &&
 		    (ops->vidioc_g_fmt_vid_cap || ops->vidioc_g_fmt_vid_cap_mplane))
 			return 0;
 		break;
@@ -1243,6 +1244,10 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 	case V4L2_SDR_FMT_CS8:		descr = "Complex S8"; break;
 	case V4L2_SDR_FMT_CS14LE:	descr = "Complex S14LE"; break;
 	case V4L2_SDR_FMT_RU12LE:	descr = "Real U12LE"; break;
+	case V4L2_TCH_FMT_DELTA_TD16:	descr = "16-bit signed deltas"; break;
+	case V4L2_TCH_FMT_DELTA_TD08:	descr = "8-bit signed deltas"; break;
+	case V4L2_TCH_FMT_TU16:		descr = "16-bit unsigned touch data"; break;
+	case V4L2_TCH_FMT_TU08:		descr = "8-bit unsigned touch data"; break;
 
 	default:
 		/* Compressed formats */
@@ -1309,13 +1314,14 @@ static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
 	struct video_device *vfd = video_devdata(file);
 	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
 	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
+	bool is_tch = vfd->vfl_type == VFL_TYPE_TOUCH;
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 	int ret = -EINVAL;
 
 	switch (p->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		if (unlikely(!is_rx || !is_vid || !ops->vidioc_enum_fmt_vid_cap))
+		if (unlikely(!is_rx || (!is_vid && !is_tch) || !ops->vidioc_enum_fmt_vid_cap))
 			break;
 		ret = ops->vidioc_enum_fmt_vid_cap(file, fh, arg);
 		break;
@@ -1362,6 +1368,7 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 	struct video_device *vfd = video_devdata(file);
 	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
 	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
+	bool is_tch = vfd->vfl_type == VFL_TYPE_TOUCH;
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 	int ret;
@@ -1392,7 +1399,7 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 
 	switch (p->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		if (unlikely(!is_rx || !is_vid || !ops->vidioc_g_fmt_vid_cap))
+		if (unlikely(!is_rx || (!is_vid && !is_tch) || !ops->vidioc_g_fmt_vid_cap))
 			break;
 		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
 		ret = ops->vidioc_g_fmt_vid_cap(file, fh, arg);
@@ -1451,6 +1458,21 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 	return -EINVAL;
 }
 
+static void v4l_pix_format_touch(struct v4l2_pix_format *p)
+{
+	/*
+	 * The v4l2_pix_format structure contains fields that make no sense for
+	 * touch. Set them to default values in this case.
+	 */
+
+	p->field = V4L2_FIELD_NONE;
+	p->colorspace = V4L2_COLORSPACE_RAW;
+	p->flags = 0;
+	p->ycbcr_enc = 0;
+	p->quantization = 0;
+	p->xfer_func = 0;
+}
+
 static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
@@ -1458,6 +1480,7 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 	struct video_device *vfd = video_devdata(file);
 	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
 	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
+	bool is_tch = vfd->vfl_type == VFL_TYPE_TOUCH;
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 	int ret;
@@ -1469,12 +1492,14 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 
 	switch (p->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		if (unlikely(!is_rx || !is_vid || !ops->vidioc_s_fmt_vid_cap))
+		if (unlikely(!is_rx || (!is_vid && !is_tch) || !ops->vidioc_s_fmt_vid_cap))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix);
 		ret = ops->vidioc_s_fmt_vid_cap(file, fh, arg);
 		/* just in case the driver zeroed it again */
 		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
+		if (is_tch)
+			v4l_pix_format_touch(&p->fmt.pix);
 		return ret;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 		if (unlikely(!is_rx || !is_vid || !ops->vidioc_s_fmt_vid_cap_mplane))
@@ -1545,6 +1570,7 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 	struct video_device *vfd = video_devdata(file);
 	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
 	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
+	bool is_tch = vfd->vfl_type == VFL_TYPE_TOUCH;
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 	int ret;
@@ -1553,7 +1579,7 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 
 	switch (p->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		if (unlikely(!is_rx || !is_vid || !ops->vidioc_try_fmt_vid_cap))
+		if (unlikely(!is_rx || (!is_vid && !is_tch) || !ops->vidioc_try_fmt_vid_cap))
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.pix);
 		ret = ops->vidioc_try_fmt_vid_cap(file, fh, arg);
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 25a3190..a2bbf1c 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -25,7 +25,8 @@
 #define VFL_TYPE_RADIO		2
 #define VFL_TYPE_SUBDEV		3
 #define VFL_TYPE_SDR		4
-#define VFL_TYPE_MAX		5
+#define VFL_TYPE_TOUCH		5
+#define VFL_TYPE_MAX		6
 
 /* Is this a receiver, transmitter or mem-to-mem? */
 /* Ignored for VFL_TYPE_SUBDEV. */
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index df59ede..a962ebd 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -297,6 +297,7 @@ struct media_links_enum {
 #define MEDIA_INTF_T_V4L_RADIO  (MEDIA_INTF_T_V4L_BASE + 2)
 #define MEDIA_INTF_T_V4L_SUBDEV (MEDIA_INTF_T_V4L_BASE + 3)
 #define MEDIA_INTF_T_V4L_SWRADIO (MEDIA_INTF_T_V4L_BASE + 4)
+#define MEDIA_INTF_T_V4L_TOUCH	(MEDIA_INTF_T_V4L_BASE + 5)
 
 #define MEDIA_INTF_T_ALSA_PCM_CAPTURE   (MEDIA_INTF_T_ALSA_BASE)
 #define MEDIA_INTF_T_ALSA_PCM_PLAYBACK  (MEDIA_INTF_T_ALSA_BASE + 1)
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 8f95191..ea64f3d 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -440,6 +440,8 @@ struct v4l2_capability {
 #define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
 #define V4L2_CAP_STREAMING              0x04000000  /* streaming I/O ioctls */
 
+#define V4L2_CAP_TOUCH                  0x10000000  /* Is a touch device */
+
 #define V4L2_CAP_DEVICE_CAPS            0x80000000  /* sets device capabilities field */
 
 /*
@@ -633,6 +635,12 @@ struct v4l2_pix_format {
 #define V4L2_SDR_FMT_CS14LE       v4l2_fourcc('C', 'S', '1', '4') /* complex s14le */
 #define V4L2_SDR_FMT_RU12LE       v4l2_fourcc('R', 'U', '1', '2') /* real u12le */
 
+/* Touch formats - used for Touch devices */
+#define V4L2_TCH_FMT_DELTA_TD16	v4l2_fourcc('T', 'D', '1', '6') /* 16-bit signed deltas */
+#define V4L2_TCH_FMT_DELTA_TD08	v4l2_fourcc('T', 'D', '0', '8') /* 8-bit signed deltas */
+#define V4L2_TCH_FMT_TU16	v4l2_fourcc('T', 'U', '1', '6') /* 16-bit unsigned touch data */
+#define V4L2_TCH_FMT_TU08	v4l2_fourcc('T', 'U', '0', '8') /* 8-bit unsigned touch data */
+
 /* priv field value to indicates that subsequent fields are valid. */
 #define V4L2_PIX_FMT_PRIV_MAGIC		0xfeedcafe
 
@@ -1399,6 +1407,7 @@ struct v4l2_input {
 /*  Values for the 'type' field */
 #define V4L2_INPUT_TYPE_TUNER		1
 #define V4L2_INPUT_TYPE_CAMERA		2
+#define V4L2_INPUT_TYPE_TOUCH		3
 
 /* field 'status' - general */
 #define V4L2_IN_ST_NO_POWER    0x00000001  /* Attached device is off */
-- 
1.7.9.5

