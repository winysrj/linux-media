Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:51091 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752597AbdDJT1E (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 15:27:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCHv4 03/15] v4l: Add metadata buffer type and format
Date: Mon, 10 Apr 2017 21:26:39 +0200
Message-Id: <20170410192651.18486-4-hverkuil@xs4all.nl>
In-Reply-To: <20170410192651.18486-1-hverkuil@xs4all.nl>
References: <20170410192651.18486-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The metadata buffer type is used to transfer metadata between userspace
and kernelspace through a V4L2 buffers queue. It comes with a new
metadata capture capability and format description.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Tested-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
[hans.verkuil@cisco.com: removed left-over 'experimental' note]
[hans.verkuil@cisco.com: add newline after _v4l2-meta-format label]
---
 Documentation/media/uapi/v4l/buffer.rst          |  3 ++
 Documentation/media/uapi/v4l/dev-meta.rst        | 58 ++++++++++++++++++++++++
 Documentation/media/uapi/v4l/devices.rst         |  1 +
 Documentation/media/uapi/v4l/vidioc-querycap.rst |  3 ++
 Documentation/media/videodev2.h.rst.exceptions   |  2 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c    | 19 ++++++++
 drivers/media/v4l2-core/v4l2-dev.c               | 16 ++++---
 drivers/media/v4l2-core/v4l2-ioctl.c             | 34 ++++++++++++++
 drivers/media/v4l2-core/videobuf2-v4l2.c         |  3 ++
 include/media/v4l2-ioctl.h                       | 17 +++++++
 include/trace/events/v4l2.h                      |  1 +
 include/uapi/linux/videodev2.h                   | 13 ++++++
 12 files changed, 164 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/dev-meta.rst

diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index d1e0d55dc219..64613d935edd 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -440,6 +440,9 @@ enum v4l2_buf_type
       - 12
       - Buffer for Software Defined Radio (SDR) output stream, see
 	:ref:`sdr`.
+    * - ``V4L2_BUF_TYPE_META_CAPTURE``
+      - 13
+      - Buffer for metadata capture, see :ref:`metadata`.
 
 
 
diff --git a/Documentation/media/uapi/v4l/dev-meta.rst b/Documentation/media/uapi/v4l/dev-meta.rst
new file mode 100644
index 000000000000..62518adfe37b
--- /dev/null
+++ b/Documentation/media/uapi/v4l/dev-meta.rst
@@ -0,0 +1,58 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _metadata:
+
+******************
+Metadata Interface
+******************
+
+Metadata refers to any non-image data that supplements video frames with
+additional information. This may include statistics computed over the image
+or frame capture parameters supplied by the image source. This interface is
+intended for transfer of metadata to userspace and control of that operation.
+
+The metadata interface is implemented on video capture device nodes. The device
+can be dedicated to metadata or can implement both video and metadata capture
+as specified in its reported capabilities.
+
+Querying Capabilities
+=====================
+
+Device nodes supporting the metadata interface set the ``V4L2_CAP_META_CAPTURE``
+flag in the ``device_caps`` field of the
+:c:type:`v4l2_capability` structure returned by the :c:func:`VIDIOC_QUERYCAP`
+ioctl. That flag means the device can capture metadata to memory.
+
+At least one of the read/write or streaming I/O methods must be supported.
+
+
+Data Format Negotiation
+=======================
+
+The metadata device uses the :ref:`format` ioctls to select the capture format.
+The metadata buffer content format is bound to that selected format. In addition
+to the basic :ref:`format` ioctls, the :c:func:`VIDIOC_ENUM_FMT` ioctl must be
+supported as well.
+
+To use the :ref:`format` ioctls applications set the ``type`` field of the
+:c:type:`v4l2_format` structure to ``V4L2_BUF_TYPE_META_CAPTURE`` and use the
+:c:type:`v4l2_meta_format` ``meta`` member of the ``fmt`` union as needed per
+the desired operation. Both drivers and applications must set the remainder of
+the :c:type:`v4l2_format` structure to 0.
+
+.. _v4l2-meta-format:
+
+.. flat-table:: struct v4l2_meta_format
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - __u32
+      - ``dataformat``
+      - The data format, set by the application. This is a little endian
+        :ref:`four character code <v4l2-fourcc>`. V4L2 defines metadata formats
+        in :ref:`meta-formats`.
+    * - __u32
+      - ``buffersize``
+      - Maximum buffer size in bytes required for data. The value is set by the
+        driver.
diff --git a/Documentation/media/uapi/v4l/devices.rst b/Documentation/media/uapi/v4l/devices.rst
index 5c3d6c29e12c..fb7f8c26cf09 100644
--- a/Documentation/media/uapi/v4l/devices.rst
+++ b/Documentation/media/uapi/v4l/devices.rst
@@ -25,3 +25,4 @@ Interfaces
     dev-touch
     dev-event
     dev-subdev
+    dev-meta
diff --git a/Documentation/media/uapi/v4l/vidioc-querycap.rst b/Documentation/media/uapi/v4l/vidioc-querycap.rst
index 165d8314327e..12e0d9a63cd8 100644
--- a/Documentation/media/uapi/v4l/vidioc-querycap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querycap.rst
@@ -236,6 +236,9 @@ specification the ioctl returns an ``EINVAL`` error code.
     * - ``V4L2_CAP_SDR_OUTPUT``
       - 0x00400000
       - The device supports the :ref:`SDR Output <sdr>` interface.
+    * - ``V4L2_CAP_META_CAPTURE``
+      - 0x00800000
+      - The device supports the :ref:`metadata` capture interface.
     * - ``V4L2_CAP_READWRITE``
       - 0x01000000
       - The device supports the :ref:`read() <rw>` and/or
diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
index e11a0d0a8931..c9c611b18ba1 100644
--- a/Documentation/media/videodev2.h.rst.exceptions
+++ b/Documentation/media/videodev2.h.rst.exceptions
@@ -27,6 +27,7 @@ replace symbol V4L2_FIELD_SEQ_TB :c:type:`v4l2_field`
 replace symbol V4L2_FIELD_TOP :c:type:`v4l2_field`
 
 # Documented enum v4l2_buf_type
+replace symbol V4L2_BUF_TYPE_META_CAPTURE :c:type:`v4l2_buf_type`
 replace symbol V4L2_BUF_TYPE_SDR_CAPTURE :c:type:`v4l2_buf_type`
 replace symbol V4L2_BUF_TYPE_SDR_OUTPUT :c:type:`v4l2_buf_type`
 replace symbol V4L2_BUF_TYPE_SLICED_VBI_CAPTURE :c:type:`v4l2_buf_type`
@@ -152,6 +153,7 @@ replace define V4L2_CAP_MODULATOR device-capabilities
 replace define V4L2_CAP_SDR_CAPTURE device-capabilities
 replace define V4L2_CAP_EXT_PIX_FORMAT device-capabilities
 replace define V4L2_CAP_SDR_OUTPUT device-capabilities
+replace define V4L2_CAP_META_CAPTURE device-capabilities
 replace define V4L2_CAP_READWRITE device-capabilities
 replace define V4L2_CAP_ASYNCIO device-capabilities
 replace define V4L2_CAP_STREAMING device-capabilities
diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 77b8a2dcfcdf..6f52970f8b54 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -161,6 +161,20 @@ static inline int put_v4l2_sdr_format(struct v4l2_sdr_format *kp, struct v4l2_sd
 	return 0;
 }
 
+static inline int get_v4l2_meta_format(struct v4l2_meta_format *kp, struct v4l2_meta_format __user *up)
+{
+	if (copy_from_user(kp, up, sizeof(struct v4l2_meta_format)))
+		return -EFAULT;
+	return 0;
+}
+
+static inline int put_v4l2_meta_format(struct v4l2_meta_format *kp, struct v4l2_meta_format __user *up)
+{
+	if (copy_to_user(up, kp, sizeof(struct v4l2_meta_format)))
+		return -EFAULT;
+	return 0;
+}
+
 struct v4l2_format32 {
 	__u32	type;	/* enum v4l2_buf_type */
 	union {
@@ -170,6 +184,7 @@ struct v4l2_format32 {
 		struct v4l2_vbi_format	vbi;
 		struct v4l2_sliced_vbi_format	sliced;
 		struct v4l2_sdr_format	sdr;
+		struct v4l2_meta_format	meta;
 		__u8	raw_data[200];        /* user-defined */
 	} fmt;
 };
@@ -216,6 +231,8 @@ static int __get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __us
 	case V4L2_BUF_TYPE_SDR_CAPTURE:
 	case V4L2_BUF_TYPE_SDR_OUTPUT:
 		return get_v4l2_sdr_format(&kp->fmt.sdr, &up->fmt.sdr);
+	case V4L2_BUF_TYPE_META_CAPTURE:
+		return get_v4l2_meta_format(&kp->fmt.meta, &up->fmt.meta);
 	default:
 		pr_info("compat_ioctl32: unexpected VIDIOC_FMT type %d\n",
 								kp->type);
@@ -263,6 +280,8 @@ static int __put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __us
 	case V4L2_BUF_TYPE_SDR_CAPTURE:
 	case V4L2_BUF_TYPE_SDR_OUTPUT:
 		return put_v4l2_sdr_format(&kp->fmt.sdr, &up->fmt.sdr);
+	case V4L2_BUF_TYPE_META_CAPTURE:
+		return put_v4l2_meta_format(&kp->fmt.meta, &up->fmt.meta);
 	default:
 		pr_info("compat_ioctl32: unexpected VIDIOC_FMT type %d\n",
 								kp->type);
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index fa2124cb31bd..c647ba648805 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -575,30 +575,34 @@ static void determine_valid_ioctls(struct video_device *vdev)
 		set_bit(_IOC_NR(VIDIOC_ENUM_FREQ_BANDS), valid_ioctls);
 
 	if (is_vid || is_tch) {
-		/* video specific ioctls */
+		/* video and metadata specific ioctls */
 		if ((is_rx && (ops->vidioc_enum_fmt_vid_cap ||
 			       ops->vidioc_enum_fmt_vid_cap_mplane ||
-			       ops->vidioc_enum_fmt_vid_overlay)) ||
+			       ops->vidioc_enum_fmt_vid_overlay ||
+			       ops->vidioc_enum_fmt_meta_cap)) ||
 		    (is_tx && (ops->vidioc_enum_fmt_vid_out ||
 			       ops->vidioc_enum_fmt_vid_out_mplane)))
 			set_bit(_IOC_NR(VIDIOC_ENUM_FMT), valid_ioctls);
 		if ((is_rx && (ops->vidioc_g_fmt_vid_cap ||
 			       ops->vidioc_g_fmt_vid_cap_mplane ||
-			       ops->vidioc_g_fmt_vid_overlay)) ||
+			       ops->vidioc_g_fmt_vid_overlay ||
+			       ops->vidioc_g_fmt_meta_cap)) ||
 		    (is_tx && (ops->vidioc_g_fmt_vid_out ||
 			       ops->vidioc_g_fmt_vid_out_mplane ||
 			       ops->vidioc_g_fmt_vid_out_overlay)))
 			 set_bit(_IOC_NR(VIDIOC_G_FMT), valid_ioctls);
 		if ((is_rx && (ops->vidioc_s_fmt_vid_cap ||
 			       ops->vidioc_s_fmt_vid_cap_mplane ||
-			       ops->vidioc_s_fmt_vid_overlay)) ||
+			       ops->vidioc_s_fmt_vid_overlay ||
+			       ops->vidioc_s_fmt_meta_cap)) ||
 		    (is_tx && (ops->vidioc_s_fmt_vid_out ||
 			       ops->vidioc_s_fmt_vid_out_mplane ||
 			       ops->vidioc_s_fmt_vid_out_overlay)))
 			 set_bit(_IOC_NR(VIDIOC_S_FMT), valid_ioctls);
 		if ((is_rx && (ops->vidioc_try_fmt_vid_cap ||
 			       ops->vidioc_try_fmt_vid_cap_mplane ||
-			       ops->vidioc_try_fmt_vid_overlay)) ||
+			       ops->vidioc_try_fmt_vid_overlay ||
+			       ops->vidioc_try_fmt_meta_cap)) ||
 		    (is_tx && (ops->vidioc_try_fmt_vid_out ||
 			       ops->vidioc_try_fmt_vid_out_mplane ||
 			       ops->vidioc_try_fmt_vid_out_overlay)))
@@ -664,7 +668,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	}
 
 	if (is_vid || is_vbi || is_sdr || is_tch) {
-		/* ioctls valid for video, vbi or sdr */
+		/* ioctls valid for video, metadata, vbi or sdr */
 		SET_VALID_IOCTL(ops, VIDIOC_REQBUFS, vidioc_reqbufs);
 		SET_VALID_IOCTL(ops, VIDIOC_QUERYBUF, vidioc_querybuf);
 		SET_VALID_IOCTL(ops, VIDIOC_QBUF, vidioc_qbuf);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 93e8f42b0d63..dec6b120a5a2 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -155,6 +155,7 @@ const char *v4l2_type_names[] = {
 	[V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE] = "vid-out-mplane",
 	[V4L2_BUF_TYPE_SDR_CAPTURE]        = "sdr-cap",
 	[V4L2_BUF_TYPE_SDR_OUTPUT]         = "sdr-out",
+	[V4L2_BUF_TYPE_META_CAPTURE]       = "meta-cap",
 };
 EXPORT_SYMBOL(v4l2_type_names);
 
@@ -246,6 +247,7 @@ static void v4l_print_format(const void *arg, bool write_only)
 	const struct v4l2_sliced_vbi_format *sliced;
 	const struct v4l2_window *win;
 	const struct v4l2_sdr_format *sdr;
+	const struct v4l2_meta_format *meta;
 	unsigned i;
 
 	pr_cont("type=%s", prt_names(p->type, v4l2_type_names));
@@ -325,6 +327,15 @@ static void v4l_print_format(const void *arg, bool write_only)
 			(sdr->pixelformat >> 16) & 0xff,
 			(sdr->pixelformat >> 24) & 0xff);
 		break;
+	case V4L2_BUF_TYPE_META_CAPTURE:
+		meta = &p->fmt.meta;
+		pr_cont(", dataformat=%c%c%c%c, buffersize=%u\n",
+			(meta->dataformat >>  0) & 0xff,
+			(meta->dataformat >>  8) & 0xff,
+			(meta->dataformat >> 16) & 0xff,
+			(meta->dataformat >> 24) & 0xff,
+			meta->buffersize);
+		break;
 	}
 }
 
@@ -943,6 +954,10 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
 		if (is_sdr && is_tx && ops->vidioc_g_fmt_sdr_out)
 			return 0;
 		break;
+	case V4L2_BUF_TYPE_META_CAPTURE:
+		if (is_vid && is_rx && ops->vidioc_g_fmt_meta_cap)
+			return 0;
+		break;
 	default:
 		break;
 	}
@@ -1327,6 +1342,11 @@ static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
 			break;
 		ret = ops->vidioc_enum_fmt_sdr_out(file, fh, arg);
 		break;
+	case V4L2_BUF_TYPE_META_CAPTURE:
+		if (unlikely(!is_rx || !is_vid || !ops->vidioc_enum_fmt_meta_cap))
+			break;
+		ret = ops->vidioc_enum_fmt_meta_cap(file, fh, arg);
+		break;
 	}
 	if (ret == 0)
 		v4l_fill_fmtdesc(p);
@@ -1426,6 +1446,10 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 		if (unlikely(!is_tx || !is_sdr || !ops->vidioc_g_fmt_sdr_out))
 			break;
 		return ops->vidioc_g_fmt_sdr_out(file, fh, arg);
+	case V4L2_BUF_TYPE_META_CAPTURE:
+		if (unlikely(!is_rx || !is_vid || !ops->vidioc_g_fmt_meta_cap))
+			break;
+		return ops->vidioc_g_fmt_meta_cap(file, fh, arg);
 	}
 	return -EINVAL;
 }
@@ -1531,6 +1555,11 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.sdr);
 		return ops->vidioc_s_fmt_sdr_out(file, fh, arg);
+	case V4L2_BUF_TYPE_META_CAPTURE:
+		if (unlikely(!is_rx || !is_vid || !ops->vidioc_s_fmt_meta_cap))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.meta);
+		return ops->vidioc_s_fmt_meta_cap(file, fh, arg);
 	}
 	return -EINVAL;
 }
@@ -1616,6 +1645,11 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
 			break;
 		CLEAR_AFTER_FIELD(p, fmt.sdr);
 		return ops->vidioc_try_fmt_sdr_out(file, fh, arg);
+	case V4L2_BUF_TYPE_META_CAPTURE:
+		if (unlikely(!is_rx || !is_vid || !ops->vidioc_try_fmt_meta_cap))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.meta);
+		return ops->vidioc_try_fmt_meta_cap(file, fh, arg);
 	}
 	return -EINVAL;
 }
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 3529849d2218..0c0669976bdc 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -544,6 +544,9 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 	case V4L2_BUF_TYPE_SDR_OUTPUT:
 		requested_sizes[0] = f->fmt.sdr.buffersize;
 		break;
+	case V4L2_BUF_TYPE_META_CAPTURE:
+		requested_sizes[0] = f->fmt.meta.buffersize;
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 6cd94e5ee113..bd5312118013 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -44,6 +44,9 @@ struct v4l2_fh;
  * @vidioc_enum_fmt_sdr_out: pointer to the function that implements
  *	:ref:`VIDIOC_ENUM_FMT <vidioc_enum_fmt>` ioctl logic
  *	for Software Defined Radio output
+ * @vidioc_enum_fmt_meta_cap: pointer to the function that implements
+ *	:ref:`VIDIOC_ENUM_FMT <vidioc_enum_fmt>` ioctl logic
+ *	for metadata capture
  * @vidioc_g_fmt_vid_cap: pointer to the function that implements
  *	:ref:`VIDIOC_G_FMT <vidioc_g_fmt>` ioctl logic for video capture
  *	in single plane mode
@@ -74,6 +77,8 @@ struct v4l2_fh;
  * @vidioc_g_fmt_sdr_out: pointer to the function that implements
  *	:ref:`VIDIOC_G_FMT <vidioc_g_fmt>` ioctl logic for Software Defined
  *	Radio output
+ * @vidioc_g_fmt_meta_cap: pointer to the function that implements
+ *	:ref:`VIDIOC_G_FMT <vidioc_g_fmt>` ioctl logic for metadata capture
  * @vidioc_s_fmt_vid_cap: pointer to the function that implements
  *	:ref:`VIDIOC_S_FMT <vidioc_g_fmt>` ioctl logic for video capture
  *	in single plane mode
@@ -104,6 +109,8 @@ struct v4l2_fh;
  * @vidioc_s_fmt_sdr_out: pointer to the function that implements
  *	:ref:`VIDIOC_S_FMT <vidioc_g_fmt>` ioctl logic for Software Defined
  *	Radio output
+ * @vidioc_s_fmt_meta_cap: pointer to the function that implements
+ *	:ref:`VIDIOC_S_FMT <vidioc_g_fmt>` ioctl logic for metadata capture
  * @vidioc_try_fmt_vid_cap: pointer to the function that implements
  *	:ref:`VIDIOC_TRY_FMT <vidioc_g_fmt>` ioctl logic for video capture
  *	in single plane mode
@@ -136,6 +143,8 @@ struct v4l2_fh;
  * @vidioc_try_fmt_sdr_out: pointer to the function that implements
  *	:ref:`VIDIOC_TRY_FMT <vidioc_g_fmt>` ioctl logic for Software Defined
  *	Radio output
+ * @vidioc_try_fmt_meta_cap: pointer to the function that implements
+ *	:ref:`VIDIOC_TRY_FMT <vidioc_g_fmt>` ioctl logic for metadata capture
  * @vidioc_reqbufs: pointer to the function that implements
  *	:ref:`VIDIOC_REQBUFS <vidioc_reqbufs>` ioctl
  * @vidioc_querybuf: pointer to the function that implements
@@ -306,6 +315,8 @@ struct v4l2_ioctl_ops {
 				       struct v4l2_fmtdesc *f);
 	int (*vidioc_enum_fmt_sdr_out)(struct file *file, void *fh,
 				       struct v4l2_fmtdesc *f);
+	int (*vidioc_enum_fmt_meta_cap)(struct file *file, void *fh,
+					struct v4l2_fmtdesc *f);
 
 	/* VIDIOC_G_FMT handlers */
 	int (*vidioc_g_fmt_vid_cap)(struct file *file, void *fh,
@@ -332,6 +343,8 @@ struct v4l2_ioctl_ops {
 				    struct v4l2_format *f);
 	int (*vidioc_g_fmt_sdr_out)(struct file *file, void *fh,
 				    struct v4l2_format *f);
+	int (*vidioc_g_fmt_meta_cap)(struct file *file, void *fh,
+				     struct v4l2_format *f);
 
 	/* VIDIOC_S_FMT handlers */
 	int (*vidioc_s_fmt_vid_cap)(struct file *file, void *fh,
@@ -358,6 +371,8 @@ struct v4l2_ioctl_ops {
 				    struct v4l2_format *f);
 	int (*vidioc_s_fmt_sdr_out)(struct file *file, void *fh,
 				    struct v4l2_format *f);
+	int (*vidioc_s_fmt_meta_cap)(struct file *file, void *fh,
+				     struct v4l2_format *f);
 
 	/* VIDIOC_TRY_FMT handlers */
 	int (*vidioc_try_fmt_vid_cap)(struct file *file, void *fh,
@@ -384,6 +399,8 @@ struct v4l2_ioctl_ops {
 				      struct v4l2_format *f);
 	int (*vidioc_try_fmt_sdr_out)(struct file *file, void *fh,
 				      struct v4l2_format *f);
+	int (*vidioc_try_fmt_meta_cap)(struct file *file, void *fh,
+				       struct v4l2_format *f);
 
 	/* Buffer handlers */
 	int (*vidioc_reqbufs)(struct file *file, void *fh,
diff --git a/include/trace/events/v4l2.h b/include/trace/events/v4l2.h
index ee7754c6e4a1..b3a85b3df53e 100644
--- a/include/trace/events/v4l2.h
+++ b/include/trace/events/v4l2.h
@@ -29,6 +29,7 @@
 	EM( V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,  "VIDEO_OUTPUT_MPLANE" )	\
 	EM( V4L2_BUF_TYPE_SDR_CAPTURE,          "SDR_CAPTURE" )		\
 	EM( V4L2_BUF_TYPE_SDR_OUTPUT,           "SDR_OUTPUT" )		\
+	EM( V4L2_BUF_TYPE_META_CAPTURE,		"META_CAPTURE" )	\
 	EMe(V4L2_BUF_TYPE_PRIVATE,		"PRIVATE" )
 
 SHOW_TYPE
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 8d351f5df2aa..7078deef2c64 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -143,6 +143,7 @@ enum v4l2_buf_type {
 	V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE  = 10,
 	V4L2_BUF_TYPE_SDR_CAPTURE          = 11,
 	V4L2_BUF_TYPE_SDR_OUTPUT           = 12,
+	V4L2_BUF_TYPE_META_CAPTURE         = 13,
 	/* Deprecated, do not use */
 	V4L2_BUF_TYPE_PRIVATE              = 0x80,
 };
@@ -451,6 +452,7 @@ struct v4l2_capability {
 #define V4L2_CAP_SDR_CAPTURE		0x00100000  /* Is a SDR capture device */
 #define V4L2_CAP_EXT_PIX_FORMAT		0x00200000  /* Supports the extended pixel format */
 #define V4L2_CAP_SDR_OUTPUT		0x00400000  /* Is a SDR output device */
+#define V4L2_CAP_META_CAPTURE		0x00800000  /* Is a metadata capture device */
 
 #define V4L2_CAP_READWRITE              0x01000000  /* read/write systemcalls */
 #define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
@@ -2086,6 +2088,16 @@ struct v4l2_sdr_format {
 } __attribute__ ((packed));
 
 /**
+ * struct v4l2_meta_format - metadata format definition
+ * @dataformat:		little endian four character code (fourcc)
+ * @buffersize:		maximum size in bytes required for data
+ */
+struct v4l2_meta_format {
+	__u32				dataformat;
+	__u32				buffersize;
+} __attribute__ ((packed));
+
+/**
  * struct v4l2_format - stream data format
  * @type:	enum v4l2_buf_type; type of the data stream
  * @pix:	definition of an image format
@@ -2104,6 +2116,7 @@ struct v4l2_format {
 		struct v4l2_vbi_format		vbi;     /* V4L2_BUF_TYPE_VBI_CAPTURE */
 		struct v4l2_sliced_vbi_format	sliced;  /* V4L2_BUF_TYPE_SLICED_VBI_CAPTURE */
 		struct v4l2_sdr_format		sdr;     /* V4L2_BUF_TYPE_SDR_CAPTURE */
+		struct v4l2_meta_format		meta;    /* V4L2_BUF_TYPE_META_CAPTURE */
 		__u8	raw_data[200];                   /* user-defined */
 	} fmt;
 };
-- 
2.11.0
