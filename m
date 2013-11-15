Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1435 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab3KOOVm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Nov 2013 09:21:42 -0500
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id rAFELdOj054189
	for <linux-media@vger.kernel.org>; Fri, 15 Nov 2013 15:21:41 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id D1C562A12AD
	for <linux-media@vger.kernel.org>; Fri, 15 Nov 2013 15:21:35 +0100 (CET)
Message-ID: <52862DEF.8000906@xs4all.nl>
Date: Fri, 15 Nov 2013 15:21:35 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [RFC PATCH]: v4l2: Introducing the property API
References: <52862D55.8010406@xs4all.nl>
In-Reply-To: <52862D55.8010406@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just to show how it would look like...

Regards,

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cpia2/cpia2_v4l.c           |  2 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |  4 +-
 drivers/media/v4l2-core/videobuf2-core.c      |  2 +-
 include/uapi/linux/v4l2-controls.h            | 15 ++++++
 include/uapi/linux/videodev2.h                | 69 +++++++++++++++++++++++++--
 5 files changed, 83 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/cpia2/cpia2_v4l.c b/drivers/media/usb/cpia2/cpia2_v4l.c
index d5d42b6..51b7759 100644
--- a/drivers/media/usb/cpia2/cpia2_v4l.c
+++ b/drivers/media/usb/cpia2/cpia2_v4l.c
@@ -952,7 +952,7 @@ static int cpia2_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 	buf->sequence = cam->buffers[buf->index].seq;
 	buf->m.offset = cam->buffers[buf->index].data - cam->frame_buffer;
 	buf->length = cam->frame_size;
-	buf->reserved2 = 0;
+	buf->config_store = 0;
 	buf->reserved = 0;
 	memset(&buf->timecode, 0, sizeof(buf->timecode));
 
diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 8f7a6a4..829eed0 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -322,7 +322,7 @@ struct v4l2_buffer32 {
 		__s32		fd;
 	} m;
 	__u32			length;
-	__u32			reserved2;
+	__u32			config_store;
 	__u32			reserved;
 };
 
@@ -487,7 +487,7 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 		put_user(kp->timestamp.tv_usec, &up->timestamp.tv_usec) ||
 		copy_to_user(&up->timecode, &kp->timecode, sizeof(struct v4l2_timecode)) ||
 		put_user(kp->sequence, &up->sequence) ||
-		put_user(kp->reserved2, &up->reserved2) ||
+		put_user(kp->config_store, &up->config_store) ||
 		put_user(kp->reserved, &up->reserved))
 			return -EFAULT;
 
diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 91412d4..4021b39 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -414,7 +414,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 
 	/* Copy back data such as timestamp, flags, etc. */
 	memcpy(b, &vb->v4l2_buf, offsetof(struct v4l2_buffer, m));
-	b->reserved2 = vb->v4l2_buf.reserved2;
+	b->config_store = vb->v4l2_buf.config_store;
 	b->reserved = vb->v4l2_buf.reserved;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(q->type)) {
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 1666aab..586467f 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -61,6 +61,9 @@
 #define V4L2_CTRL_CLASS_DV		0x00a00000	/* Digital Video controls */
 #define V4L2_CTRL_CLASS_FM_RX		0x00a10000	/* FM Receiver controls */
 
+/* Property classes */
+#define V4L2_PROP_CLASS_USER		0x08980000	/* Generic properties */
+
 /* User-class control IDs */
 
 #define V4L2_CID_BASE			(V4L2_CTRL_CLASS_USER | 0x900)
@@ -886,4 +889,16 @@ enum v4l2_deemphasis {
 
 #define V4L2_CID_RDS_RECEPTION			(V4L2_CID_FM_RX_CLASS_BASE + 2)
 
+/* Generic properties */
+#define V4L2_PID_USER_BASE			(V4L2_PROP_CLASS_USER | 0x10)
+
+#define V4L2_PID_CAPTURE_CROP			(V4L2_PID_USER_BASE + 0)
+#define V4L2_PID_CAPTURE_COMPOSE		(V4L2_PID_USER_BASE + 1)
+#define V4L2_PID_OUTPUT_CROP			(V4L2_PID_USER_BASE + 2)
+#define V4L2_PID_OUTPUT_COMPOSE			(V4L2_PID_USER_BASE + 3)
+
+/* TODO: use a Motion Detection property class */
+#define V4L2_PID_MD_REGION			(V4L2_PID_USER_BASE + 4)
+#define V4L2_PID_MD_THRESHOLD			(V4L2_PID_USER_BASE + 5)
+
 #endif
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 437f1b0..9faba79 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -640,7 +640,7 @@ struct v4l2_plane {
  * @length:	size in bytes of the buffer (NOT its payload) for single-plane
  *		buffers (when type != *_MPLANE); number of elements in the
  *		planes array for multi-plane buffers
- * @input:	input number from which the video data has has been captured
+ * @config_store: this buffer should use this configuration store
  *
  * Contains data exchanged by application and driver using one of the Streaming
  * I/O methods.
@@ -664,7 +664,7 @@ struct v4l2_buffer {
 		__s32		fd;
 	} m;
 	__u32			length;
-	__u32			reserved2;
+	__u32			config_store;
 	__u32			reserved;
 };
 
@@ -1228,11 +1228,15 @@ struct v4l2_ext_control {
 		__s32 value;
 		__s64 value64;
 		char *string;
+		void *prop;
 	};
 } __attribute__ ((packed));
 
 struct v4l2_ext_controls {
-	__u32 ctrl_class;
+	union {
+		__u32 ctrl_class;
+		__u32 config_store;
+	};
 	__u32 count;
 	__u32 error_idx;
 	__u32 reserved[2];
@@ -1240,6 +1244,7 @@ struct v4l2_ext_controls {
 };
 
 #define V4L2_CTRL_ID_MASK      	  (0x0fffffff)
+#define V4L2_CTRL_IS_PROP(id)     ((id) & 0x08000000)
 #define V4L2_CTRL_ID2CLASS(id)    ((id) & 0x0fff0000UL)
 #define V4L2_CTRL_DRIVER_PRIV(id) (((id) & 0xffff) >= 0x1000)
 
@@ -1252,7 +1257,29 @@ enum v4l2_ctrl_type {
 	V4L2_CTRL_TYPE_CTRL_CLASS    = 6,
 	V4L2_CTRL_TYPE_STRING        = 7,
 	V4L2_CTRL_TYPE_BITMASK       = 8,
-	V4L2_CTRL_TYPE_INTEGER_MENU = 9,
+	V4L2_CTRL_TYPE_INTEGER_MENU  = 9,
+
+	V4l2_PROP_TYPE_MATRIX_U8     = 0x100,
+	V4l2_PROP_TYPE_MATRIX_U16    = 0x101,
+};
+
+/* Property types */
+struct v4l2_prop_selection {
+	struct v4l2_rect r;
+	__u32 flags;
+	__u32 reserved[7];
+};
+
+struct v4l2_prop_type_matrix_u8 {
+	struct v4l2_rect r;
+	__u32 reserved[4];
+	__u8 data[];
+};
+
+struct v4l2_prop_type_matrix_u16 {
+	struct v4l2_rect r;
+	__u32 reserved[4];
+	__u16 data[];
 };
 
 /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
@@ -1268,6 +1295,34 @@ struct v4l2_queryctrl {
 	__u32		     reserved[2];
 };
 
+/*  Used in the VIDIOC_QUERY_EXT_CTRL ioctl for querying extended controls */
+struct v4l2_query_ext_ctrl {
+	__u32                config_store;
+	__u32		     id;
+	__u32		     type;
+	__u8		     name[32];
+	__u8		     unit[32];
+	union {
+		__s64 val;
+		__u32 reserved[8];
+	} min;
+	union {
+		__s64 val;
+		__u32 reserved[8];
+	} max;
+	union {
+		__s64 val;
+		__u32 reserved[8];
+	} step;
+	union {
+		__s64 val;
+		__u32 reserved[8];
+	} def;
+	__u32                flags;
+	__u32                width, height;
+	__u32		     reserved[16];
+};
+
 /*  Used in the VIDIOC_QUERYMENU ioctl for querying menu items */
 struct v4l2_querymenu {
 	__u32		id;
@@ -1288,9 +1343,11 @@ struct v4l2_querymenu {
 #define V4L2_CTRL_FLAG_SLIDER 		0x0020
 #define V4L2_CTRL_FLAG_WRITE_ONLY 	0x0040
 #define V4L2_CTRL_FLAG_VOLATILE		0x0080
+#define V4L2_CTRL_FLAG_CAN_STORE	0x0100
 
-/*  Query flag, to be ORed with the control ID */
+/*  Query flags, to be ORed with the control ID */
 #define V4L2_CTRL_FLAG_NEXT_CTRL	0x80000000
+#define V4L2_CTRL_FLAG_NEXT_PROP	0x40000000
 
 /*  User-class control IDs defined by V4L2 */
 #define V4L2_CID_MAX_CTRLS		1024
@@ -1958,6 +2015,8 @@ struct v4l2_create_buffers {
    Never use these in applications! */
 #define VIDIOC_DBG_G_CHIP_INFO  _IOWR('V', 102, struct v4l2_dbg_chip_info)
 
+#define VIDIOC_QUERY_EXT_CTRL	_IOWR('V', 103, struct v4l2_query_ext_ctrl)
+
 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/video/v4l2-compat-ioctl32.c as well! */
 
-- 
1.8.4.3


