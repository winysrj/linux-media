Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:8642 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab2IXOAc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 10:00:32 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MAU00H1KXKU35D0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 24 Sep 2012 23:00:30 +0900 (KST)
Received: from amdc248.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MAU001W7XKKXC30@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 24 Sep 2012 23:00:30 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: a.hajda@samsung.com, sakari.ailus@iki.fi,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC] V4L: Add get/set_frame_desc subdev callbacks
Date: Mon, 24 Sep 2012 16:00:17 +0200
Message-id: <1348495217-32715-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add subdev callbacks for setting up and retrieving parameters of the frame
on media bus that are not exposed to user space directly.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

Hi All,

This patch is intended as an initial, mostly a stub, implementation of the
media bus frame format descriptors idea outlined in Sakari's RFC [1].
I included in this patch only what is necessary for the s5p-fimc driver to
capture JPEG and interleaved JPEG/YUV image data from M-5MOLS and S5C73M3
cameras. The union containing per media bus type structures describing
bus specific configuration is not included here, it likely needs much
discussions and I would like to get this patch merged for v3.7 if possible.

To follow is a patch adding users of these new subdev operations.

Comments are welcome.

Thanks,
Sylwester

[1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg43530.html
---
 include/media/v4l2-subdev.h | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 28067ed..f5d8441 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -21,6 +21,7 @@
 #ifndef _V4L2_SUBDEV_H
 #define _V4L2_SUBDEV_H

+#include <linux/types.h>
 #include <linux/v4l2-subdev.h>
 #include <media/media-entity.h>
 #include <media/v4l2-common.h>
@@ -45,6 +46,7 @@ struct v4l2_fh;
 struct v4l2_subdev;
 struct v4l2_subdev_fh;
 struct tuner_setup;
+struct v4l2_mbus_frame_desc;

 /* decode_vbi_line */
 struct v4l2_decode_vbi_line {
@@ -226,6 +228,36 @@ struct v4l2_subdev_audio_ops {
 	int (*s_stream)(struct v4l2_subdev *sd, int enable);
 };

+/* Indicates the @length field specifies maximum data length. */
+#define V4L2_MBUS_FRAME_DESC_FL_LEN_MAX		(1U << 0)
+/* Indicates user defined data format, i.e. non standard frame format. */
+#define V4L2_MBUS_FRAME_DESC_FL_BLOB		(1U << 1)
+
+/**
+ * struct v4l2_mbus_frame_desc_entry - media bus frame description structure
+ * @flags: V4L2_MBUS_FRAME_DESC_FL_* flags
+ * @pixelcode: media bus pixel code, valid if FRAME_DESC_FL_BLOB is not set
+ * @length: number of octets per frame, valid for compressed or unspecified
+ *          formats
+ */
+struct v4l2_mbus_frame_desc_entry {
+	u16 flags;
+	u32 pixelcode;
+	u32 length;
+};
+
+#define V4L2_FRAME_DESC_ENTRY_MAX	4
+
+/**
+ * struct v4l2_mbus_frame_desc - media bus data frame description
+ * @entry: frame descriptors array
+ * @num_entries: number of entries in @entry array
+ */
+struct v4l2_mbus_frame_desc {
+	struct v4l2_mbus_frame_desc_entry entry[V4L2_FRAME_DESC_ENTRY_MAX];
+	unsigned short num_entries;
+};
+
 /*
    s_std_output: set v4l2_std_id for video OUTPUT devices. This is ignored by
 	video input devices.
@@ -461,6 +493,12 @@ struct v4l2_subdev_ir_ops {
 				struct v4l2_subdev_ir_parameters *params);
 };

+/**
+ * struct v4l2_subdev_pad_ops - v4l2-subdev pad level operations
+ * @get_frame_desc: get the current low level media bus frame parameters.
+ * @get_frame_desc: set the low level media bus frame parameters, @fd array
+ *                  may be adjusted by the subdev driver to device capabilities.
+ */
 struct v4l2_subdev_pad_ops {
 	int (*enum_mbus_code)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 			      struct v4l2_subdev_mbus_code_enum *code);
@@ -489,6 +527,10 @@ struct v4l2_subdev_pad_ops {
 			     struct v4l2_subdev_format *source_fmt,
 			     struct v4l2_subdev_format *sink_fmt);
 #endif /* CONFIG_MEDIA_CONTROLLER */
+	int (*get_frame_desc)(struct v4l2_subdev *sd, unsigned int pad,
+			      struct v4l2_mbus_frame_desc *fd);
+	int (*set_frame_desc)(struct v4l2_subdev *sd, unsigned int pad,
+			      struct v4l2_mbus_frame_desc *fd);
 };

 struct v4l2_subdev_ops {
--
1.7.11.3

