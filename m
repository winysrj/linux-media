Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:45874 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab3JAI1D (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Oct 2013 04:27:03 -0400
Received: by mail-la0-f53.google.com with SMTP id el20so5430889lab.40
        for <linux-media@vger.kernel.org>; Tue, 01 Oct 2013 01:27:01 -0700 (PDT)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [RFC v2] [RFC] v4l2: Support for multiple selections
Date: Tue,  1 Oct 2013 10:26:56 +0200
Message-Id: <1380616016-32140-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend v4l2 selection API to support multiple selection areas, this way
sensors that support multiple readout areas can work with multiple areas
of insterest.

The struct v4l2_selection and v4l2_subdev_selection has been extented
with a new field rectangles. If it is value is different than zero the
pr array is used instead of the r field.

A new structure v4l2_ext_rect has been defined, containing 4 reserved
fields for future improvements, as suggested by Hans.

Two helper functiona are also added, to help the drivers that support
a single selection.

This Patch ONLY adds the modification to the core. Once it is agreed, a
new version including changes on the drivers that handle the selection
api will come.

struct v4l2_selection has the same size on 32 and 64 bits, therefore I
dont think that any change on v4l2-compat-ioctl32 is needed.

ricardo@neopili:/tmp$ gcc kk.c -m32
ricardo@neopili:/tmp$ ./a.out
Size of v4l2_selection=64
ricardo@neopili:/tmp$ gcc kk.c
ricardo@neopili:/tmp$ ./a.out
Size of v4l2_selection=64

This patch includes all the comments by Hans Verkuil.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/v4l2-core/v4l2-common.c | 39 +++++++++++++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ioctl.c  | 37 ++++++++++++++++++++++++++++-----
 include/media/v4l2-common.h           |  4 ++++
 include/uapi/linux/v4l2-subdev.h      | 10 +++++++--
 include/uapi/linux/videodev2.h        | 21 +++++++++++++++----
 5 files changed, 100 insertions(+), 11 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index a95e5e2..007ab32 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -886,3 +886,42 @@ void v4l2_get_timestamp(struct timeval *tv)
 	tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
 }
 EXPORT_SYMBOL_GPL(v4l2_get_timestamp);
+
+int v4l2_selection_get_rect(struct v4l2_selection *s, struct v4l2_ext_rect *r)
+{
+	if (s->rectangles > 1)
+		return -EINVAL;
+	if (s->rectangles == 1) {
+		*r = s->pr[0];
+		return 0;
+	}
+	if (s->r.width < 0 || s->r.height < 0)
+		return -EINVAL;
+	r->left = s->r.left;
+	r->top = s->r.top;
+	r->width = s->r.width;
+	r->height = s->r.height;
+	memset(r->reserved, 0, sizeof(r->reserved));
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_selection_get_rect);
+
+int v4l2_selection_set_rect(struct v4l2_ext_rect *r, struct v4l2_selection *s)
+{
+	if (s->rectangles == 0) {
+		if (s->r.width > UINT_MAX || s->r.height > UINT_MAX)
+			return -EINVAL;
+		s->r.left = r->left;
+		s->r.top = r->top;
+		s->r.width = r->width;
+		s->r.height = r->height;
+		return 0;
+	}
+	if (s->rectangles > 1) {
+		s->pr[0] = *r;
+		s->rectangles = 1;
+		return 0;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_selection_set_rect);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 68e6b5e..29f7cf1 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -572,11 +572,22 @@ static void v4l_print_crop(const void *arg, bool write_only)
 static void v4l_print_selection(const void *arg, bool write_only)
 {
 	const struct v4l2_selection *p = arg;
+	int i;
 
-	pr_cont("type=%s, target=%d, flags=0x%x, wxh=%dx%d, x,y=%d,%d\n",
-		prt_names(p->type, v4l2_type_names),
-		p->target, p->flags,
-		p->r.width, p->r.height, p->r.left, p->r.top);
+	if (p->rectangles == 0)
+		pr_cont("type=%s, target=%d, flags=0x%x, wxh=%dx%d, x,y=%d,%d\n",
+			prt_names(p->type, v4l2_type_names),
+			p->target, p->flags,
+			p->r.width, p->r.height, p->r.left, p->r.top);
+	else{
+		pr_cont("type=%s, target=%d, flags=0x%x rectangles=%d\n",
+			prt_names(p->type, v4l2_type_names),
+			p->target, p->flags, p->rectangles);
+		for (i = 0; i < p->rectangles; i++)
+			pr_cont("rectangle %d: wxh=%dx%d, x,y=%d,%d\n",
+				i, p->r.width, p->r.height,
+				p->r.left, p->r.top);
+	}
 }
 
 static void v4l_print_jpegcompression(const void *arg, bool write_only)
@@ -1692,7 +1703,9 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct v4l2_cropcap *p = arg;
-	struct v4l2_selection s = { .type = p->type };
+	struct v4l2_selection s = {
+		.type = p->type,
+	};
 	int ret;
 
 	if (ops->vidioc_cropcap)
@@ -2253,6 +2266,20 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
 		}
 		break;
 	}
+
+	case VIDIOC_G_SELECTION:
+	case VIDIOC_S_SELECTION: {
+		struct v4l2_selection *s = parg;
+
+		if (s->rectangles) {
+			*user_ptr = (void __user *)s->pr;
+			kernel_ptr = (void *)&s->pr;
+			array_size = sizeof(struct v4l2_ext_rect)
+				* s->rectangles;
+			ret = 1;
+		}
+		break;
+	}
 	}
 
 	return ret;
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 015ff82..dc96861 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -216,4 +216,8 @@ struct v4l2_fract v4l2_calc_aspect_ratio(u8 hor_landscape, u8 vert_portrait);
 
 void v4l2_get_timestamp(struct timeval *tv);
 
+int v4l2_selection_get_rect(struct v4l2_selection *s, struct v4l2_ext_rect *r);
+
+int v4l2_selection_set_rect(struct v4l2_ext_rect *r, struct v4l2_selection *s);
+
 #endif /* V4L2_COMMON_H_ */
diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2-subdev.h
index a33c4da..c02a886 100644
--- a/include/uapi/linux/v4l2-subdev.h
+++ b/include/uapi/linux/v4l2-subdev.h
@@ -133,6 +133,8 @@ struct v4l2_subdev_frame_interval_enum {
  *	    defined in v4l2-common.h; V4L2_SEL_TGT_* .
  * @flags: constraint flags, defined in v4l2-common.h; V4L2_SEL_FLAG_*.
  * @r: coordinates of the selection window
+ * @pr:		array of rectangles containing the selection windows
+ * @rectangles:	Number of rectangles in pr structure. If zero, r is used instead
  * @reserved: for future use, set to zero for now
  *
  * Hardware may use multiple helper windows to process a video stream.
@@ -144,8 +146,12 @@ struct v4l2_subdev_selection {
 	__u32 pad;
 	__u32 target;
 	__u32 flags;
-	struct v4l2_rect r;
-	__u32 reserved[8];
+	union {
+		struct v4l2_rect r;
+		struct v4l2_ext_rect *pr;
+	};
+	__u32 rectangles;
+	__u32 reserved[7];
 };
 
 struct v4l2_subdev_edid {
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 95ef455..a4a7902 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -211,6 +211,14 @@ struct v4l2_rect {
 	__s32   height;
 };
 
+struct v4l2_ext_rect {
+	__s32   left;
+	__s32   top;
+	__u32   width;
+	__u32   height;
+	__u32   reserved[4];
+};
+
 struct v4l2_fract {
 	__u32   numerator;
 	__u32   denominator;
@@ -804,6 +812,8 @@ struct v4l2_crop {
  *		defined in v4l2-common.h; V4L2_SEL_TGT_* .
  * @flags:	constraints flags, defined in v4l2-common.h; V4L2_SEL_FLAG_*.
  * @r:		coordinates of selection window
+ * @pr:		array of rectangles containing the selection windows
+ * @rectangles:	Number of rectangles in pr structure. If zero, r is used instead
  * @reserved:	for future use, rounds structure size to 64 bytes, set to zero
  *
  * Hardware may use multiple helper windows to process a video stream.
@@ -814,10 +824,13 @@ struct v4l2_selection {
 	__u32			type;
 	__u32			target;
 	__u32                   flags;
-	struct v4l2_rect        r;
-	__u32                   reserved[9];
-};
-
+	union {
+		struct v4l2_rect        r;
+		struct v4l2_ext_rect    *pr;
+	};
+	__u32                   rectangles;
+	__u32                   reserved[8];
+} __packed;
 
 /*
  *      A N A L O G   V I D E O   S T A N D A R D
-- 
1.8.4.rc3

