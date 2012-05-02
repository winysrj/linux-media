Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:50460 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756133Ab2EBTOI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 May 2012 15:14:08 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@redhat.com,
	remi@remlab.net, nbowler@elliptictech.com, james.dutton@gmail.com
Subject: [RFC v3 2/2] v4l: Implement compat functions for enum to __u32 change
Date: Wed,  2 May 2012 22:13:48 +0300
Message-Id: <1335986028-23618-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120502191324.GE852@valkosipuli.localdomain>
References: <20120502191324.GE852@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement compat functions to provide conversion between structs containing
enums and those not. The functions are intended to be removed when the
support for such old binaries is no longer necessary.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/Kconfig      |   12 +
 drivers/media/video/v4l2-ioctl.c |  684 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 687 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index f2479c5..949f804 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -7,6 +7,18 @@ config VIDEO_V4L2
 	depends on VIDEO_DEV && VIDEO_V4L2_COMMON
 	default VIDEO_DEV && VIDEO_V4L2_COMMON
 
+config V4L2_COMPAT
+	bool "Compatibility for old binaries"
+	depends on VIDEO_V4L2
+	default y
+	---help---
+	  Compatibility code to support binaries compiled with old V4L2
+	  IOCTL definitions containing enums that have been replaced by
+	  __u32. If you do not need to use such binaries you can disable
+	  this option.
+
+	  When in doubt, say Y.
+
 config VIDEOBUF_GEN
 	tristate
 
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 5b2ec1f..9b88360 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -2303,6 +2303,653 @@ static long __video_do_ioctl(struct file *file,
 	return ret;
 }
 
+#ifdef CONFIG_V4L2_COMPAT
+
+static inline unsigned int get_non_compat_cmd(unsigned int cmd)
+{
+	switch (cmd) {
+	case VIDIOC_ENUM_FMT_ENUM:
+		return VIDIOC_ENUM_FMT;
+	case VIDIOC_G_FMT_ENUM:
+		return VIDIOC_G_FMT;
+	case VIDIOC_S_FMT_ENUM:
+		return VIDIOC_S_FMT;
+	case VIDIOC_REQBUFS_ENUM:
+		return VIDIOC_REQBUFS;
+	case VIDIOC_QUERYBUF_ENUM:
+		return VIDIOC_QUERYBUF;
+	case VIDIOC_G_FBUF_ENUM:
+		return VIDIOC_G_FBUF;
+	case VIDIOC_S_FBUF_ENUM:
+		return VIDIOC_S_FBUF;
+	case VIDIOC_QBUF_ENUM:
+		return VIDIOC_QBUF;
+	case VIDIOC_DQBUF_ENUM:
+		return VIDIOC_DQBUF;
+	case VIDIOC_G_PARM_ENUM:
+		return VIDIOC_G_PARM;
+	case VIDIOC_S_PARM_ENUM:
+		return VIDIOC_S_PARM;
+	case VIDIOC_G_TUNER_ENUM:
+		return VIDIOC_G_TUNER;
+	case VIDIOC_S_TUNER_ENUM:
+		return VIDIOC_S_TUNER;
+	case VIDIOC_QUERYCTRL_ENUM:
+		return VIDIOC_QUERYCTRL;
+	case VIDIOC_G_FREQUENCY_ENUM:
+		return VIDIOC_G_FREQUENCY;
+	case VIDIOC_S_FREQUENCY_ENUM:
+		return VIDIOC_S_FREQUENCY;
+	case VIDIOC_CROPCAP_ENUM:
+		return VIDIOC_CROPCAP;
+	case VIDIOC_G_CROP_ENUM:
+		return VIDIOC_G_CROP;
+	case VIDIOC_S_CROP_ENUM:
+		return VIDIOC_S_CROP;
+	case VIDIOC_TRY_FMT_ENUM:
+		return VIDIOC_TRY_FMT;
+	case VIDIOC_G_SLICED_VBI_CAP_ENUM:
+		return VIDIOC_G_SLICED_VBI_CAP;
+	case VIDIOC_S_HW_FREQ_SEEK_ENUM:
+		return VIDIOC_S_HW_FREQ_SEEK;
+	case VIDIOC_CREATE_BUFS_ENUM:
+		return VIDIOC_CREATE_BUFS;
+	case VIDIOC_PREPARE_BUF_ENUM:
+		return VIDIOC_PREPARE_BUF;
+	default:
+		return cmd;
+	}
+}
+
+#define get_user_conv(x, ptr)			\
+	({					\
+		typeof (*ptr) tmp;		\
+		int rval;			\
+						\
+		rval = get_user(tmp, ptr);	\
+		if (!rval)			\
+			x = (typeof (x))tmp;	\
+						\
+		rval;				\
+	})
+
+static int get_user_pix_format(struct v4l2_pix_format *k,
+			       struct v4l2_pix_format_enum *u)
+{
+	return get_user(k->width, &u->width)
+		|| get_user(k->height, &u->height)
+		|| get_user(k->pixelformat, &u->pixelformat)
+		|| get_user_conv(k->field, &u->field)
+		|| get_user(k->bytesperline, &u->bytesperline)
+		|| get_user(k->sizeimage, &u->sizeimage)
+		|| get_user_conv(k->colorspace, &u->colorspace)
+		|| get_user(k->priv, &u->priv);
+}
+
+static int get_user_pix_format_mplane(struct v4l2_pix_format_mplane *k,
+				      struct v4l2_pix_format_mplane_enum *u)
+{
+	return get_user(k->width, &u->width)
+		|| get_user(k->height, &u->height)
+		|| get_user(k->pixelformat, &u->pixelformat)
+		|| get_user_conv(k->field, &u->field)
+		|| get_user_conv(k->colorspace, &u->colorspace)
+		|| copy_from_user(k->plane_fmt, u->plane_fmt,
+				  sizeof(k->plane_fmt))
+		|| get_user(k->num_planes, &u->num_planes)
+		|| copy_from_user(k->reserved, u->reserved,
+				  sizeof(k->reserved));
+}
+
+static int get_user_window(struct v4l2_window *k,
+			   struct v4l2_window_enum *u)
+{
+	return copy_from_user(&k->w, &u->w, sizeof(k->w))
+		|| get_user_conv(k->field, &u->field)
+		|| get_user(k->chromakey, &u->chromakey)
+		|| get_user(k->clips, &u->clips)
+		|| get_user(k->clipcount, &u->clipcount)
+		|| get_user(k->bitmap, &u->bitmap)
+		|| get_user(k->global_alpha, &u->global_alpha);
+}
+
+static int get_user_format(struct v4l2_format *k,
+			   struct v4l2_format_enum *u)
+{
+	if (get_user(k->type, &u->type))
+		return -EFAULT;
+
+	switch (k->type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+		if (get_user_pix_format(&k->fmt.pix, &u->fmt.pix))
+			return -EFAULT;
+		return 0;
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		if (get_user_pix_format_mplane(&k->fmt.pix_mp, &u->fmt.pix_mp))
+			return -EFAULT;
+		return 0;
+	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
+		if (get_user_window(&k->fmt.win, &u->fmt.win))
+			return -EFAULT;
+		return 0;
+	default:
+		if (copy_from_user(k->fmt.raw_data, u->fmt.raw_data,
+				   sizeof(k->fmt.raw_data)))
+			return -EFAULT;
+		return 0;
+	}
+}
+
+static long copy_compat_from_user(unsigned int cmd, void *parg,
+				  void __user *arg)
+{
+	union {
+		struct v4l2_fmtdesc_enum fmtdesc;
+		struct v4l2_format_enum fmt;
+		struct v4l2_requestbuffers_enum reqbufs;
+		struct v4l2_framebuffer_enum fb;
+		struct v4l2_buffer_enum buf;
+		struct v4l2_streamparm_enum sparm;
+		struct v4l2_tuner_enum tuner;
+		struct v4l2_queryctrl_enum qc;
+		struct v4l2_frequency_enum freq;
+		struct v4l2_cropcap_enum cropcap;
+		struct v4l2_crop_enum crop;
+		struct v4l2_sliced_vbi_cap_enum vbi_cap;
+		struct v4l2_hw_freq_seek_enum freq_seek;
+		struct v4l2_create_buffers_enum create_bufs;
+	} __user *u = arg;
+	union {
+		struct v4l2_fmtdesc fmtdesc;
+		struct v4l2_format fmt;
+		struct v4l2_requestbuffers reqbufs;
+		struct v4l2_framebuffer fb;
+		struct v4l2_buffer buf;
+		struct v4l2_streamparm sparm;
+		struct v4l2_tuner tuner;
+		struct v4l2_queryctrl qc;
+		struct v4l2_frequency freq;
+		struct v4l2_cropcap cropcap;
+		struct v4l2_crop crop;
+		struct v4l2_sliced_vbi_cap vbi_cap;
+		struct v4l2_hw_freq_seek freq_seek;
+		struct v4l2_create_buffers create_bufs;
+	} *k = parg;
+
+	if (!access_ok(VERIFY_READ, u, _IOC_SIZE(cmd)))
+		return -EFAULT;
+
+	switch (cmd) {
+	case VIDIOC_ENUM_FMT_ENUM:
+		if (get_user(k->fmtdesc.index, &u->fmtdesc.index)
+		    || get_user_conv(k->fmtdesc.type, &u->fmtdesc.type)
+		    || get_user(k->fmtdesc.flags, &u->fmtdesc.flags)
+		    || copy_from_user(k->fmtdesc.description,
+				      u->fmtdesc.description,
+				      sizeof(k->fmtdesc.description))
+		    || get_user(k->fmtdesc.pixelformat,
+				&u->fmtdesc.pixelformat)
+		    || copy_from_user(k->fmtdesc.reserved,
+				      u->fmtdesc.reserved,
+				      sizeof(k->fmtdesc.reserved)))
+			return -EFAULT;
+		return 0;
+	case VIDIOC_G_FMT_ENUM:
+	case VIDIOC_S_FMT_ENUM:
+	case VIDIOC_TRY_FMT_ENUM:
+		if (get_user_format(&k->fmt, &u->fmt))
+			return -EFAULT;
+		return 0;
+	case VIDIOC_REQBUFS_ENUM:
+		if (get_user(k->reqbufs.count, &u->reqbufs.count)
+		    || get_user_conv(k->reqbufs.type, &u->reqbufs.type)
+		    || get_user_conv(k->reqbufs.memory, &u->reqbufs.memory)
+		    || copy_from_user(k->reqbufs.reserved,
+				      u->reqbufs.reserved,
+				      sizeof(k->reqbufs.reserved)))
+			return -EFAULT;
+		return 0;
+	case VIDIOC_QUERYBUF_ENUM:
+	case VIDIOC_QBUF_ENUM:
+	case VIDIOC_DQBUF_ENUM:
+	case VIDIOC_PREPARE_BUF_ENUM:
+		if (get_user(k->buf.index, &u->buf.index)
+		    || get_user_conv(k->buf.type, &u->buf.type)
+		    || get_user(k->buf.bytesused, &u->buf.bytesused)
+		    || get_user(k->buf.flags, &u->buf.flags)
+		    || get_user_conv(k->buf.field, &u->buf.field)
+		    || copy_from_user(&k->buf.timestamp, &u->buf.timestamp,
+				      sizeof(k->buf.timestamp))
+		    || copy_from_user(&k->buf.timecode, &u->buf.timecode,
+				      sizeof(k->buf.timecode))
+		    || get_user(k->buf.sequence, &u->buf.sequence)
+		    || get_user_conv(k->buf.memory, &u->buf.memory)
+		    || copy_from_user(&k->buf.m, &u->buf.m, sizeof(k->buf.m))
+		    || get_user(k->buf.length, &u->buf.length)
+		    || get_user(k->buf.reserved2, &u->buf.reserved2)
+		    || get_user(k->buf.reserved, &u->buf.reserved))
+			return -EFAULT;
+		return 0;
+	case VIDIOC_G_FBUF_ENUM:
+	case VIDIOC_S_FBUF_ENUM:
+		if (get_user(k->fb.capability, &u->fb.capability)
+		    || get_user(k->fb.flags, &u->fb.flags)
+		    || get_user(k->fb.base, &u->fb.base)
+		    || get_user_pix_format(&k->fb.fmt, &u->fb.fmt))
+			return -EFAULT;
+		return 0;
+	case VIDIOC_G_PARM_ENUM:
+	case VIDIOC_S_PARM_ENUM:
+		if (get_user_conv(k->sparm.type, &u->sparm.type)
+		    || copy_from_user(&k->sparm.parm, &u->sparm.parm,
+				      sizeof(k->sparm.parm)))
+			return -EFAULT;
+		return 0;
+	case VIDIOC_G_TUNER_ENUM:
+	case VIDIOC_S_TUNER_ENUM:
+		if (get_user(k->tuner.index, &u->tuner.index)
+		    || copy_from_user(k->tuner.name, u->tuner.name,
+				      sizeof(k->tuner.name))
+		    || get_user_conv(k->tuner.type, &u->tuner.type)
+		    || get_user(k->tuner.capability, &u->tuner.capability)
+		    || get_user(k->tuner.rangelow, &u->tuner.rangelow)
+		    || get_user(k->tuner.rangehigh, &u->tuner.rangehigh)
+		    || get_user(k->tuner.rxsubchans, &u->tuner.rxsubchans)
+		    || get_user(k->tuner.audmode, &u->tuner.audmode)
+		    || get_user(k->tuner.signal, &u->tuner.signal)
+		    || get_user(k->tuner.afc, &u->tuner.afc)
+		    || copy_from_user(k->tuner.reserved, u->tuner.reserved,
+				      sizeof(k->tuner.reserved)))
+			return -EFAULT;
+		return 0;
+	case VIDIOC_QUERYCTRL_ENUM:
+		if (get_user(k->qc.id, &u->qc.id)
+		    || get_user_conv(k->qc.type, &u->qc.type)
+		    || copy_from_user(k->qc.name, u->qc.name,
+				      sizeof(k->qc.name))
+		    || get_user(k->qc.minimum, &u->qc.minimum)
+		    || get_user(k->qc.maximum, &u->qc.maximum)
+		    || get_user(k->qc.step, &u->qc.step)
+		    || get_user(k->qc.default_value, &u->qc.default_value)
+		    || get_user(k->qc.flags, &u->qc.flags)
+		    || copy_from_user(k->qc.reserved, u->qc.reserved,
+				      sizeof(k->qc.reserved)))
+			return -EFAULT;
+		return 0;
+	case VIDIOC_G_FREQUENCY_ENUM:
+	case VIDIOC_S_FREQUENCY_ENUM:
+		if (get_user(k->freq.tuner, &u->freq.tuner)
+		    || get_user_conv(k->freq.type, &u->freq.type)
+		    || get_user(k->freq.frequency, &u->freq.frequency)
+		    || copy_from_user(k->freq.reserved, u->freq.reserved,
+				      sizeof(k->freq.reserved)))
+			return -EFAULT;
+		return 0;
+	case VIDIOC_CROPCAP_ENUM:
+		if (get_user_conv(k->cropcap.type, &u->cropcap.type)
+		    || copy_from_user(&k->cropcap.bounds, &u->cropcap.bounds,
+				      sizeof(k->cropcap.bounds))
+		    || copy_from_user(&k->cropcap.defrect, &u->cropcap.defrect,
+				      sizeof(k->cropcap.bounds))
+		    || copy_from_user(&k->cropcap.pixelaspect,
+				      &u->cropcap.pixelaspect,
+				      sizeof(k->cropcap.pixelaspect)))
+			return -EFAULT;
+		return 0;
+	case VIDIOC_G_CROP_ENUM:
+	case VIDIOC_S_CROP_ENUM:
+		if (get_user_conv(k->crop.type, &u->crop.type)
+		    || copy_from_user(&k->crop.c, &u->crop.c,
+				      sizeof(k->crop.c)))
+			return -EFAULT;
+		return 0;
+	case VIDIOC_G_SLICED_VBI_CAP_ENUM:
+		if (get_user(k->vbi_cap.service_set, &u->vbi_cap.service_set)
+		    || copy_from_user(k->vbi_cap.service_lines,
+				      u->vbi_cap.service_lines,
+				      sizeof(k->vbi_cap.service_lines))
+		    || get_user_conv(k->vbi_cap.type, &u->vbi_cap.type)
+		    || copy_from_user(k->vbi_cap.reserved, u->vbi_cap.reserved,
+				      sizeof(k->vbi_cap.reserved)))
+			return -EFAULT;
+		return 0;
+	case VIDIOC_S_HW_FREQ_SEEK_ENUM:
+		if (get_user(k->freq_seek.tuner, &u->freq_seek.tuner)
+		    || get_user_conv(k->freq_seek.type, &u->freq_seek.type)
+		    || get_user(k->freq_seek.seek_upward,
+				&u->freq_seek.seek_upward)
+		    || get_user(k->freq_seek.wrap_around,
+				&u->freq_seek.wrap_around)
+		    || get_user(k->freq_seek.spacing, &u->freq_seek.spacing)
+		    || copy_from_user(k->freq_seek.reserved,
+				      u->freq_seek.reserved,
+				      sizeof(k->freq_seek.reserved)))
+			return -EFAULT;
+		return 0;
+	case VIDIOC_CREATE_BUFS_ENUM:
+		if (get_user(k->create_bufs.index, &u->create_bufs.index)
+		    || get_user(k->create_bufs.count, &u->create_bufs.count)
+		    || get_user_conv(k->create_bufs.memory,
+				     &u->create_bufs.memory)
+		    || get_user_format(&k->create_bufs.format,
+				       &u->create_bufs.format)
+		    || copy_from_user(k->create_bufs.reserved,
+				      u->create_bufs.reserved,
+				      sizeof(k->create_bufs.reserved)))
+			return -EFAULT;
+		return 0;
+	default:
+		WARN(1, "%s: bad compat cmd %8.8x\n", __func__, cmd);
+		return -EINVAL;
+	}
+}
+
+#define put_user_conv(x, ptr)			\
+	({					\
+		typeof (*ptr) tmp;		\
+						\
+		tmp = (typeof (*ptr))x;		\
+		put_user(tmp, ptr);		\
+	})
+
+static int put_user_pix_format(struct v4l2_pix_format *k,
+			       struct v4l2_pix_format_enum *u)
+{
+	return put_user(k->width, &u->width)
+		|| put_user(k->height, &u->height)
+		|| put_user(k->pixelformat, &u->pixelformat)
+		|| put_user_conv(k->field, &u->field)
+		|| put_user(k->bytesperline, &u->bytesperline)
+		|| put_user(k->sizeimage, &u->sizeimage)
+		|| put_user_conv(k->colorspace, &u->colorspace)
+		|| put_user(k->priv, &u->priv);
+}
+
+static int put_user_pix_format_mplane(struct v4l2_pix_format_mplane *k,
+				      struct v4l2_pix_format_mplane_enum *u)
+{
+	return put_user(k->width, &u->width)
+		|| put_user(k->height, &u->height)
+		|| put_user(k->pixelformat, &u->pixelformat)
+		|| put_user_conv(k->field, &u->field)
+		|| put_user_conv(k->colorspace, &u->colorspace)
+		|| copy_to_user(u->plane_fmt, k->plane_fmt,
+				sizeof(k->plane_fmt))
+		|| put_user(k->num_planes, &u->num_planes)
+		|| copy_to_user(u->reserved, k->reserved,
+				sizeof(k->reserved));
+}
+
+static int put_user_window(struct v4l2_window *k,
+			   struct v4l2_window_enum *u)
+{
+	return copy_to_user(&u->w, &k->w, sizeof(k->w))
+		|| put_user_conv(k->field, &u->field)
+		|| put_user(k->chromakey, &u->chromakey)
+		|| put_user(k->clips, &u->clips)
+		|| put_user(k->clipcount, &u->clipcount)
+		|| put_user(k->bitmap, &u->bitmap)
+		|| put_user(k->global_alpha, &u->global_alpha);
+}
+
+static int put_user_format(struct v4l2_format *k,
+			   struct v4l2_format_enum *u)
+{
+	if (put_user(k->type, &u->type))
+		return -EFAULT;
+
+	switch (k->type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+		if (put_user_pix_format(&k->fmt.pix, &u->fmt.pix))
+			return -EFAULT;
+		return 0;
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		if (put_user_pix_format_mplane(&k->fmt.pix_mp, &u->fmt.pix_mp))
+			return -EFAULT;
+		return 0;
+	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
+		if (put_user_window(&k->fmt.win, &u->fmt.win))
+			return -EFAULT;
+		return 0;
+	default:
+		if (copy_to_user(u->fmt.raw_data, k->fmt.raw_data,
+				 sizeof(k->fmt.raw_data)))
+			return -EFAULT;
+		return 0;
+	}
+}
+
+static long copy_compat_to_user(unsigned int cmd, void __user *arg,
+				void *parg)
+{
+	union {
+		struct v4l2_fmtdesc_enum fmtdesc;
+		struct v4l2_format_enum fmt;
+		struct v4l2_requestbuffers_enum reqbufs;
+		struct v4l2_framebuffer_enum fb;
+		struct v4l2_buffer_enum buf;
+		struct v4l2_streamparm_enum sparm;
+		struct v4l2_tuner_enum tuner;
+		struct v4l2_queryctrl_enum qc;
+		struct v4l2_frequency_enum freq;
+		struct v4l2_cropcap_enum cropcap;
+		struct v4l2_crop_enum crop;
+		struct v4l2_sliced_vbi_cap_enum vbi_cap;
+		struct v4l2_hw_freq_seek_enum freq_seek;
+		struct v4l2_create_buffers_enum create_bufs;
+	} __user *u = arg;
+	union {
+		struct v4l2_fmtdesc fmtdesc;
+		struct v4l2_format fmt;
+		struct v4l2_requestbuffers reqbufs;
+		struct v4l2_framebuffer fb;
+		struct v4l2_buffer buf;
+		struct v4l2_streamparm sparm;
+		struct v4l2_tuner tuner;
+		struct v4l2_queryctrl qc;
+		struct v4l2_frequency freq;
+		struct v4l2_cropcap cropcap;
+		struct v4l2_crop crop;
+		struct v4l2_sliced_vbi_cap vbi_cap;
+		struct v4l2_hw_freq_seek freq_seek;
+		struct v4l2_create_buffers create_bufs;
+	} *k = parg;
+
+	if (!access_ok(VERIFY_WRITE, u, _IOC_SIZE(cmd)))
+		return -EFAULT;
+
+	switch (cmd) {
+	case VIDIOC_ENUM_FMT_ENUM:
+		if (put_user(k->fmtdesc.index, &u->fmtdesc.index)
+		    || put_user_conv(k->fmtdesc.type, &u->fmtdesc.type)
+		    || put_user(k->fmtdesc.flags, &u->fmtdesc.flags)
+		    || copy_to_user(u->fmtdesc.description,
+				    k->fmtdesc.description,
+				    sizeof(k->fmtdesc.description))
+		    || put_user(k->fmtdesc.pixelformat,
+				&u->fmtdesc.pixelformat)
+		    || copy_to_user(u->fmtdesc.reserved,
+				    k->fmtdesc.reserved,
+				    sizeof(k->fmtdesc.reserved)))
+			return -EFAULT;
+		return 0;
+	case VIDIOC_G_FMT_ENUM:
+	case VIDIOC_S_FMT_ENUM:
+	case VIDIOC_TRY_FMT_ENUM:
+		if (put_user_format(&k->fmt, &u->fmt))
+			return -EFAULT;
+		return 0;
+	case VIDIOC_REQBUFS_ENUM:
+		if (put_user(k->reqbufs.count, &u->reqbufs.count)
+		    || put_user_conv(k->reqbufs.type, &u->reqbufs.type)
+		    || put_user_conv(k->reqbufs.memory, &u->reqbufs.memory)
+		    || copy_to_user(u->reqbufs.reserved,
+				    k->reqbufs.reserved,
+				    sizeof(k->reqbufs.reserved)))
+			return -EFAULT;
+		return 0;
+	case VIDIOC_QUERYBUF_ENUM:
+	case VIDIOC_QBUF_ENUM:
+	case VIDIOC_DQBUF_ENUM:
+	case VIDIOC_PREPARE_BUF_ENUM:
+		if (put_user(k->buf.index, &u->buf.index)
+		    || put_user_conv(k->buf.type, &u->buf.type)
+		    || put_user(k->buf.bytesused, &u->buf.bytesused)
+		    || put_user(k->buf.flags, &u->buf.flags)
+		    || put_user_conv(k->buf.field, &u->buf.field)
+		    || copy_to_user(&u->buf.timestamp, &k->buf.timestamp,
+				    sizeof(k->buf.timestamp))
+		    || copy_to_user(&u->buf.timecode, &k->buf.timecode,
+				    sizeof(k->buf.timecode))
+		    || put_user(k->buf.sequence, &u->buf.sequence)
+		    || put_user_conv(k->buf.memory, &u->buf.memory)
+		    || copy_to_user(&u->buf.m, &k->buf.m, sizeof(k->buf.m))
+		    || put_user(k->buf.length, &u->buf.length)
+		    || put_user(k->buf.reserved2, &u->buf.reserved2)
+		    || put_user(k->buf.reserved, &u->buf.reserved))
+			return -EFAULT;
+		return 0;
+	case VIDIOC_G_FBUF_ENUM:
+	case VIDIOC_S_FBUF_ENUM:
+		if (put_user(k->fb.capability, &u->fb.capability)
+		    || put_user(k->fb.flags, &u->fb.flags)
+		    || put_user(k->fb.base, &u->fb.base)
+		    || put_user_pix_format(&k->fb.fmt, &u->fb.fmt))
+			return -EFAULT;
+		return 0;
+	case VIDIOC_G_PARM_ENUM:
+	case VIDIOC_S_PARM_ENUM:
+		if (put_user_conv(k->sparm.type, &u->sparm.type)
+		    || copy_to_user(&u->sparm.parm, &k->sparm.parm,
+				    sizeof(k->sparm.parm)))
+			return -EFAULT;
+		return 0;
+	case VIDIOC_G_TUNER_ENUM:
+	case VIDIOC_S_TUNER_ENUM:
+		if (put_user(k->tuner.index, &u->tuner.index)
+		    || copy_to_user(u->tuner.name, k->tuner.name,
+				    sizeof(k->tuner.name))
+		    || put_user_conv(k->tuner.type, &u->tuner.type)
+		    || put_user(k->tuner.capability, &u->tuner.capability)
+		    || put_user(k->tuner.rangelow, &u->tuner.rangelow)
+		    || put_user(k->tuner.rangehigh, &u->tuner.rangehigh)
+		    || put_user(k->tuner.rxsubchans, &u->tuner.rxsubchans)
+		    || put_user(k->tuner.audmode, &u->tuner.audmode)
+		    || put_user(k->tuner.signal, &u->tuner.signal)
+		    || put_user(k->tuner.afc, &u->tuner.afc)
+		    || copy_to_user(u->tuner.reserved, k->tuner.reserved,
+				    sizeof(k->tuner.reserved)))
+			return -EFAULT;
+		return 0;
+	case VIDIOC_QUERYCTRL_ENUM:
+		if (put_user(k->qc.id, &u->qc.id)
+		    || put_user_conv(k->qc.type, &u->qc.type)
+		    || copy_to_user(u->qc.name, k->qc.name,
+				    sizeof(k->qc.name))
+		    || put_user(k->qc.minimum, &u->qc.minimum)
+		    || put_user(k->qc.maximum, &u->qc.maximum)
+		    || put_user(k->qc.step, &u->qc.step)
+		    || put_user(k->qc.default_value, &u->qc.default_value)
+		    || put_user(k->qc.flags, &u->qc.flags)
+		    || copy_to_user(u->qc.reserved, k->qc.reserved,
+				    sizeof(k->qc.reserved)))
+			return -EFAULT;
+		return 0;
+	case VIDIOC_G_FREQUENCY_ENUM:
+	case VIDIOC_S_FREQUENCY_ENUM:
+		if (put_user(k->freq.tuner, &u->freq.tuner)
+		    || put_user_conv(k->freq.type, &u->freq.type)
+		    || put_user(k->freq.frequency, &u->freq.frequency)
+		    || copy_to_user(u->freq.reserved, k->freq.reserved,
+				    sizeof(k->freq.reserved)))
+			return -EFAULT;
+		return 0;
+	case VIDIOC_CROPCAP_ENUM:
+		if (put_user_conv(k->cropcap.type, &u->cropcap.type)
+		    || copy_to_user(&u->cropcap.bounds, &k->cropcap.bounds,
+				    sizeof(k->cropcap.bounds))
+		    || copy_to_user(&u->cropcap.defrect, &k->cropcap.defrect,
+				    sizeof(k->cropcap.bounds))
+		    || copy_to_user(&u->cropcap.pixelaspect,
+				    &k->cropcap.pixelaspect,
+				    sizeof(k->cropcap.pixelaspect)))
+			return -EFAULT;
+		return 0;
+	case VIDIOC_G_CROP_ENUM:
+	case VIDIOC_S_CROP_ENUM:
+		if (put_user_conv(k->crop.type, &u->crop.type)
+		    || copy_to_user(&u->crop.c, &k->crop.c,
+				    sizeof(k->crop.c)))
+			return -EFAULT;
+		return 0;
+	case VIDIOC_G_SLICED_VBI_CAP_ENUM:
+		if (put_user(k->vbi_cap.service_set, &u->vbi_cap.service_set)
+		    || copy_to_user(u->vbi_cap.service_lines,
+				    k->vbi_cap.service_lines,
+				    sizeof(k->vbi_cap.service_lines))
+		    || put_user_conv(k->vbi_cap.type, &u->vbi_cap.type)
+		    || copy_to_user(u->vbi_cap.reserved, k->vbi_cap.reserved,
+				    sizeof(k->vbi_cap.reserved)))
+			return -EFAULT;
+		return 0;
+	case VIDIOC_S_HW_FREQ_SEEK_ENUM:
+		if (put_user(k->freq_seek.tuner, &u->freq_seek.tuner)
+		    || put_user_conv(k->freq_seek.type, &u->freq_seek.type)
+		    || put_user(k->freq_seek.seek_upward,
+				&u->freq_seek.seek_upward)
+		    || put_user(k->freq_seek.wrap_around,
+				&u->freq_seek.wrap_around)
+		    || put_user(k->freq_seek.spacing, &u->freq_seek.spacing)
+		    || copy_to_user(u->freq_seek.reserved,
+				    k->freq_seek.reserved,
+				    sizeof(k->freq_seek.reserved)))
+			return -EFAULT;
+		return 0;
+	case VIDIOC_CREATE_BUFS_ENUM:
+		if (put_user(k->create_bufs.index, &u->create_bufs.index)
+		    || put_user(k->create_bufs.count, &u->create_bufs.count)
+		    || put_user_conv(k->create_bufs.memory,
+				     &u->create_bufs.memory)
+		    || put_user_format(&k->create_bufs.format,
+				       &u->create_bufs.format)
+		    || copy_to_user(u->create_bufs.reserved,
+				    k->create_bufs.reserved,
+				    sizeof(k->create_bufs.reserved)))
+			return -EFAULT;
+		return 0;
+	default:
+		WARN(1, "%s: bad compat cmd %8.8x\n", __func__, cmd);
+		return -EINVAL;
+	}
+}
+
+#else /* CONFIG_V4L2_COMPAT */
+
+static inline unsigned int get_non_compat_cmd(unsigned int cmd)
+{
+	return cmd;
+}
+
+static inline long copy_compat_from_user(unsigned int cmd, void __user *arg,
+					 void *parg)
+{
+	return 0;
+}
+
+static inline long copy_compat_to_user(unsigned int cmd, void __user *arg,
+				       void *parg)
+{
+	return 0;
+}
+
+#endif /* CONFIG_V4L2_COMPAT */
+
 /* In some cases, only a few fields are used as input, i.e. when the app sets
  * "index" and then the driver fills in the rest of the structure for the thing
  * with that index.  We only need to copy up the first non-input field.  */
@@ -2390,7 +3037,7 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
 }
 
 long
-video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
+video_usercopy(struct file *file, unsigned int compat_cmd, unsigned long arg,
 	       v4l2_kioctl func)
 {
 	char	sbuf[128];
@@ -2401,6 +3048,7 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 	size_t  array_size = 0;
 	void __user *user_ptr = NULL;
 	void	**kernel_ptr = NULL;
+	unsigned int cmd = get_non_compat_cmd(compat_cmd);
 
 	/*  Copy arguments into temp kernel buffer  */
 	if (_IOC_DIR(cmd) != _IOC_NONE) {
@@ -2418,12 +3066,23 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 		if (_IOC_DIR(cmd) & _IOC_WRITE) {
 			unsigned long n = cmd_input_size(cmd);
 
-			if (copy_from_user(parg, (void __user *)arg, n))
-				goto out;
-
-			/* zero out anything we don't copy from userspace */
-			if (n < _IOC_SIZE(cmd))
-				memset((u8 *)parg + n, 0, _IOC_SIZE(cmd) - n);
+			if (cmd == compat_cmd) {
+				if (copy_from_user(
+					    parg, (void __user *)arg, n))
+					goto out;
+
+				/*
+				 * zero out anything we don't copy
+				 * from userspace
+				 */
+				if (n < _IOC_SIZE(cmd))
+					memset((u8 *)parg + n, 0,
+					       _IOC_SIZE(cmd) - n);
+			} else {
+				if (copy_compat_from_user(compat_cmd, parg,
+							  (void __user *)arg))
+					goto out;
+			}
 		} else {
 			/* read-only ioctl */
 			memset(parg, 0, _IOC_SIZE(cmd));
@@ -2471,8 +3130,15 @@ out_array_args:
 	switch (_IOC_DIR(cmd)) {
 	case _IOC_READ:
 	case (_IOC_WRITE | _IOC_READ):
-		if (copy_to_user((void __user *)arg, parg, _IOC_SIZE(cmd)))
-			err = -EFAULT;
+		if (cmd == compat_cmd) {
+			if (copy_to_user((void __user *)arg, parg,
+					 _IOC_SIZE(cmd)))
+				err = -EFAULT;
+		} else {
+			if (copy_compat_to_user(compat_cmd, (void __user *)arg,
+						parg))
+				err = -EFAULT;
+		}
 		break;
 	}
 
-- 
1.7.2.5

