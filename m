Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2000 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab3F1M2H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 08:28:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 1/5] v4l2: add matrix support.
Date: Fri, 28 Jun 2013 14:27:30 +0200
Message-Id: <1372422454-13752-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1372422454-13752-1-git-send-email-hverkuil@xs4all.nl>
References: <1372422454-13752-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch adds core support for matrices: querying, getting and setting.

Two initial matrix types are defined for motion detection (defining regions
and thresholds).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dev.c   |  3 ++
 drivers/media/v4l2-core/v4l2-ioctl.c | 23 ++++++++++++-
 include/media/v4l2-ioctl.h           |  8 +++++
 include/uapi/linux/videodev2.h       | 64 ++++++++++++++++++++++++++++++++++++
 4 files changed, 97 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index c8859d6..5e58df6 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -598,6 +598,9 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	SET_VALID_IOCTL(ops, VIDIOC_UNSUBSCRIBE_EVENT, vidioc_unsubscribe_event);
 	if (ops->vidioc_enum_freq_bands || ops->vidioc_g_tuner || ops->vidioc_g_modulator)
 		set_bit(_IOC_NR(VIDIOC_ENUM_FREQ_BANDS), valid_ioctls);
+	SET_VALID_IOCTL(ops, VIDIOC_QUERY_MATRIX, vidioc_query_matrix);
+	SET_VALID_IOCTL(ops, VIDIOC_G_MATRIX, vidioc_g_matrix);
+	SET_VALID_IOCTL(ops, VIDIOC_S_MATRIX, vidioc_s_matrix);
 
 	if (is_vid) {
 		/* video specific ioctls */
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 68e6b5e..47debfc 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -549,7 +549,7 @@ static void v4l_print_cropcap(const void *arg, bool write_only)
 	const struct v4l2_cropcap *p = arg;
 
 	pr_cont("type=%s, bounds wxh=%dx%d, x,y=%d,%d, "
-		"defrect wxh=%dx%d, x,y=%d,%d\n, "
+		"defrect wxh=%dx%d, x,y=%d,%d, "
 		"pixelaspect %d/%d\n",
 		prt_names(p->type, v4l2_type_names),
 		p->bounds.width, p->bounds.height,
@@ -831,6 +831,24 @@ static void v4l_print_freq_band(const void *arg, bool write_only)
 			p->rangehigh, p->modulation);
 }
 
+static void v4l_print_query_matrix(const void *arg, bool write_only)
+{
+	const struct v4l2_query_matrix *p = arg;
+
+	pr_cont("type=0x%x, columns=%u, rows=%u, elem_min=%lld, elem_max=%lld, elem_size=%u\n",
+			p->type, p->columns, p->rows,
+			p->elem_min.val, p->elem_max.val, p->elem_size);
+}
+
+static void v4l_print_matrix(const void *arg, bool write_only)
+{
+	const struct v4l2_matrix *p = arg;
+
+	pr_cont("type=0x%x, wxh=%dx%d, x,y=%d,%d, matrix=%p\n",
+			p->type, p->rect.width, p->rect.height,
+			p->rect.top, p->rect.left, p->matrix);
+}
+
 static void v4l_print_u32(const void *arg, bool write_only)
 {
 	pr_cont("value=%u\n", *(const u32 *)arg);
@@ -2055,6 +2073,9 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_STD(VIDIOC_DV_TIMINGS_CAP, vidioc_dv_timings_cap, v4l_print_dv_timings_cap, INFO_FL_CLEAR(v4l2_dv_timings_cap, type)),
 	IOCTL_INFO_FNC(VIDIOC_ENUM_FREQ_BANDS, v4l_enum_freq_bands, v4l_print_freq_band, 0),
 	IOCTL_INFO_FNC(VIDIOC_DBG_G_CHIP_INFO, v4l_dbg_g_chip_info, v4l_print_dbg_chip_info, INFO_FL_CLEAR(v4l2_dbg_chip_info, match)),
+	IOCTL_INFO_STD(VIDIOC_QUERY_MATRIX, vidioc_query_matrix, v4l_print_query_matrix, INFO_FL_CLEAR(v4l2_query_matrix, ref)),
+	IOCTL_INFO_STD(VIDIOC_G_MATRIX, vidioc_g_matrix, v4l_print_matrix, INFO_FL_CLEAR(v4l2_matrix, matrix)),
+	IOCTL_INFO_STD(VIDIOC_S_MATRIX, vidioc_s_matrix, v4l_print_matrix, INFO_FL_PRIO | INFO_FL_CLEAR(v4l2_matrix, matrix)),
 };
 #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
 
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index e0b74a4..7e4538e 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -271,6 +271,14 @@ struct v4l2_ioctl_ops {
 	int (*vidioc_unsubscribe_event)(struct v4l2_fh *fh,
 					const struct v4l2_event_subscription *sub);
 
+	/* Matrix ioctls */
+	int (*vidioc_query_matrix) (struct file *file, void *fh,
+				    struct v4l2_query_matrix *qmatrix);
+	int (*vidioc_g_matrix) (struct file *file, void *fh,
+				    struct v4l2_matrix *matrix);
+	int (*vidioc_s_matrix) (struct file *file, void *fh,
+				    struct v4l2_matrix *matrix);
+
 	/* For other private ioctls */
 	long (*vidioc_default)	       (struct file *file, void *fh,
 					bool valid_prio, unsigned int cmd, void *arg);
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 95ef455..5cbe815 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1838,6 +1838,64 @@ struct v4l2_create_buffers {
 	__u32			reserved[8];
 };
 
+/* Define to which motion detection region each element belongs.
+ * Each element is a __u8. */
+#define V4L2_MATRIX_TYPE_MD_REGION     (1)
+/* Define the motion detection threshold for each element.
+ * Each element is a __u16. */
+#define V4L2_MATRIX_TYPE_MD_THRESHOLD  (2)
+
+/**
+ * struct v4l2_query_matrix - VIDIOC_QUERY_MATRIX argument
+ * @type:	matrix type
+ * @ref:	reference to some object (if any) owning the matrix
+ * @columns:	number of columns in the matrix
+ * @rows:	number of rows in the matrix
+ * @elem_min:	minimum matrix element value
+ * @elem_max:	maximum matrix element value
+ * @elem_size:	size in bytes each matrix element
+ * @reserved:	future extensions, applications and drivers must zero this.
+ */
+struct v4l2_query_matrix {
+	__u32 type;
+	union {
+		__u32 reserved[4];
+	} ref;
+	__u32 columns;
+	__u32 rows;
+	union {
+		__s64 val;
+		__u64 uval;
+		__u32 reserved[4];
+	} elem_min;
+	union {
+		__s64 val;
+		__u64 uval;
+		__u32 reserved[4];
+	} elem_max;
+	__u32 elem_size;
+	__u32 reserved[12];
+} __attribute__ ((packed));
+
+/**
+ * struct v4l2_matrix - VIDIOC_G/S_MATRIX argument
+ * @type:	matrix type
+ * @ref:	reference to some object (if any) owning the matrix
+ * @rect:	which part of the matrix to get/set
+ * @matrix:	pointer to the matrix of size (in bytes):
+ *		elem_size * rect.width * rect.height
+ * @reserved:	future extensions, applications and drivers must zero this.
+ */
+struct v4l2_matrix {
+	__u32 type;
+	union {
+		__u32 reserved[4];
+	} ref;
+	struct v4l2_rect rect;
+	void __user *matrix;
+	__u32 reserved[12];
+} __attribute__ ((packed));
+
 /*
  *	I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
  *
@@ -1946,6 +2004,12 @@ struct v4l2_create_buffers {
    Never use these in applications! */
 #define VIDIOC_DBG_G_CHIP_INFO  _IOWR('V', 102, struct v4l2_dbg_chip_info)
 
+/* Experimental, these three ioctls may change over the next couple of kernel
+   versions. */
+#define VIDIOC_QUERY_MATRIX	_IOWR('V', 103, struct v4l2_query_matrix)
+#define VIDIOC_G_MATRIX		_IOWR('V', 104, struct v4l2_matrix)
+#define VIDIOC_S_MATRIX		_IOWR('V', 105, struct v4l2_matrix)
+
 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/video/v4l2-compat-ioctl32.c as well! */
 
-- 
1.8.3.1

