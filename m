Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4901 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab2EAJGA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 May 2012 05:06:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/7] videodev2.h: add enum/query/cap dv_timings ioctls.
Date: Tue,  1 May 2012 11:05:46 +0200
Message-Id: <de77f3452a3710c48282ebe24937731b252a1ef7.1335862609.git.hans.verkuil@cisco.com>
In-Reply-To: <1335863152-15791-1-git-send-email-hverkuil@xs4all.nl>
References: <1335863152-15791-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These new ioctls make it possible for the dv_timings API to replace
the dv_preset API eventually.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 include/linux/videodev2.h |  173 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 149 insertions(+), 24 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 5a09ac3..6062c57 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -986,29 +986,56 @@ struct v4l2_dv_enum_preset {
  *	D V 	B T	T I M I N G S
  */
 
-/* BT.656/BT.1120 timing data */
+/** struct v4l2_bt_timings - BT.656/BT.1120 timing data
+ * @width:	total width of the active video in pixels
+ * @height:	total height of the active video in lines
+ * @interlaced:	Interlaced or progressive
+ * @polarities:	Positive or negative polarities
+ * @pixelclock:	Pixel clock in HZ. Ex. 74.25MHz->74250000
+ * @hfrontporch:Horizontal front porch in pixels
+ * @hsync:	Horizontal Sync length in pixels
+ * @hbackporch:	Horizontal back porch in pixels
+ * @vfrontporch:Vertical front porch in lines
+ * @vsync:	Vertical Sync length in lines
+ * @vbackporch:	Vertical back porch in lines
+ * @il_vfrontporch:Vertical front porch for the even field
+ *		(aka field 2) of interlaced field formats
+ * @il_vsync:	Vertical Sync length for the even field
+ *		(aka field 2) of interlaced field formats
+ * @il_vbackporch:Vertical back porch for the even field
+ *		(aka field 2) of interlaced field formats
+ * @standards:	Standards the timing belongs to
+ * @flags:	Flags
+ * @reserved:	Reserved fields, must be zeroed.
+ *
+ * A note regarding vertical interlaced timings: height refers to the total
+ * height of the active video frame (= two fields). The blanking timings refer
+ * to the blanking of each field. So the height of the total frame is
+ * calculated as follows:
+ *
+ * tot_height = height + vfrontporch + vsync + vbackporch +
+ *                       il_vfrontporch + il_vsync + il_vbackporch
+ *
+ * The active height of each field is height / 2.
+ */
 struct v4l2_bt_timings {
-	__u32	width;		/* width in pixels */
-	__u32	height;		/* height in lines */
-	__u32	interlaced;	/* Interlaced or progressive */
-	__u32	polarities;	/* Positive or negative polarity */
-	__u64	pixelclock;	/* Pixel clock in HZ. Ex. 74.25MHz->74250000 */
-	__u32	hfrontporch;	/* Horizpontal front porch in pixels */
-	__u32	hsync;		/* Horizontal Sync length in pixels */
-	__u32	hbackporch;	/* Horizontal back porch in pixels */
-	__u32	vfrontporch;	/* Vertical front porch in pixels */
-	__u32	vsync;		/* Vertical Sync length in lines */
-	__u32	vbackporch;	/* Vertical back porch in lines */
-	__u32	il_vfrontporch;	/* Vertical front porch for bottom field of
-				 * interlaced field formats
-				 */
-	__u32	il_vsync;	/* Vertical sync length for bottom field of
-				 * interlaced field formats
-				 */
-	__u32	il_vbackporch;	/* Vertical back porch for bottom field of
-				 * interlaced field formats
-				 */
-	__u32	reserved[16];
+	__u32	width;
+	__u32	height;
+	__u32	interlaced;
+	__u32	polarities;
+	__u64	pixelclock;
+	__u32	hfrontporch;
+	__u32	hsync;
+	__u32	hbackporch;
+	__u32	vfrontporch;
+	__u32	vsync;
+	__u32	vbackporch;
+	__u32	il_vfrontporch;
+	__u32	il_vsync;
+	__u32	il_vbackporch;
+	__u32	standards;
+	__u32	flags;
+	__u32	reserved[14];
 } __attribute__ ((packed));
 
 /* Interlaced or progressive format */
@@ -1019,8 +1046,42 @@ struct v4l2_bt_timings {
 #define V4L2_DV_VSYNC_POS_POL	0x00000001
 #define V4L2_DV_HSYNC_POS_POL	0x00000002
 
-
-/* DV timings */
+/* Timings standards */
+#define V4L2_DV_BT_STD_CEA861	(1 << 0)  /* CEA-861 Digital TV Profile */
+#define V4L2_DV_BT_STD_DMT	(1 << 1)  /* VESA Discrete Monitor Timings */
+#define V4L2_DV_BT_STD_CVT	(1 << 2)  /* VESA Coordinated Video Timings */
+#define V4L2_DV_BT_STD_GTF	(1 << 3)  /* VESA Generalized Timings Formula */
+
+/* Flags */
+
+/* CVT/GTF specific: timing uses reduced blanking (CVT) or the 'Secondary
+   GTF' curve (GTF). In both cases the horizontal and/or vertical blanking
+   intervals are reduced, allowing a higher resolution over the same
+   bandwidth. This is a read-only flag. */
+#define V4L2_DV_FL_REDUCED_BLANKING		(1 << 0)
+/* CEA-861 specific: set for CEA-861 formats with a framerate of a multiple
+   of six. These formats can be optionally played at 1 / 1.001 speed.
+   This is a read-only flag. */
+#define V4L2_DV_FL_CAN_REDUCE_FPS		(1 << 1)
+/* CEA-861 specific: only valid for video transmitters, the flag is cleared
+   by receivers.
+   If the framerate of the format is a multiple of six, then the pixelclock
+   used to set up the transmitter is divided by 1.001 to make it compatible
+   with 60 Hz based standards such as NTSC and PAL-M that use a framerate of
+   29.97 Hz. Otherwise this flag is cleared. If the transmitter can't generate
+   such frequencies, then the flag will also be cleared. */
+#define V4L2_DV_FL_REDUCED_FPS			(1 << 2)
+/* Specific to interlaced formats: if set, then field 1 is really one half-line
+   longer and field 2 is really one half-line shorter, so each field has
+   exactly the same number of half-lines. Whether half-lines can be detected
+   or used depends on the hardware. */
+#define V4L2_DV_FL_HALF_LINE			(1 << 0)
+
+
+/** struct v4l2_dv_timings - DV timings
+ * @type:	the type of the timings
+ * @bt:	BT656/1120 timings
+ */
 struct v4l2_dv_timings {
 	__u32 type;
 	union {
@@ -1032,6 +1093,64 @@ struct v4l2_dv_timings {
 /* Values for the type field */
 #define V4L2_DV_BT_656_1120	0	/* BT.656/1120 timing type */
 
+
+/** struct v4l2_enum_dv_timings - DV timings enumeration
+ * @index:	enumeration index
+ * @reserved:	must be zeroed
+ * @timings:	the timings for the given index
+ */
+struct v4l2_enum_dv_timings {
+	__u32 index;
+	__u32 reserved[3];
+	struct v4l2_dv_timings timings;
+};
+
+/** struct v4l2_bt_timings_cap - BT.656/BT.1120 timing capabilities
+ * @min_width:		width in pixels
+ * @max_width:		width in pixels
+ * @min_height:		height in lines
+ * @max_height:		height in lines
+ * @min_pixelclock:	Pixel clock in HZ. Ex. 74.25MHz->74250000
+ * @max_pixelclock:	Pixel clock in HZ. Ex. 74.25MHz->74250000
+ * @standards:		Supported standards
+ * @capabilities:	Supported capabilities
+ * @reserved:		Must be zeroed
+ */
+struct v4l2_bt_timings_cap {
+	__u32	min_width;
+	__u32	max_width;
+	__u32	min_height;
+	__u32	max_height;
+	__u64	min_pixelclock;
+	__u64	max_pixelclock;
+	__u32	standards;
+	__u32	capabilities;
+	__u32	reserved[16];
+} __attribute__ ((packed));
+
+/* Supports interlaced formats */
+#define V4L2_DV_BT_CAP_INTERLACED	(1 << 0)
+/* Supports progressive formats */
+#define V4L2_DV_BT_CAP_PROGRESSIVE	(1 << 1)
+/* Supports CVT/GTF reduced blanking */
+#define V4L2_DV_BT_CAP_REDUCED_BLANKING	(1 << 2)
+/* Supports custom formats */
+#define V4L2_DV_BT_CAP_CUSTOM		(1 << 3)
+
+/** struct v4l2_dv_timings_cap - DV timings capabilities
+ * @type:	the type of the timings (same as in struct v4l2_dv_timings)
+ * @bt:		the BT656/1120 timings capabilities
+ */
+struct v4l2_dv_timings_cap {
+	__u32 type;
+	__u32 reserved[3];
+	union {
+		struct v4l2_bt_timings_cap bt;
+		__u32 raw_data[32];
+	};
+};
+
+
 /*
  *	V I D E O   I N P U T S
  */
@@ -2412,6 +2531,12 @@ struct v4l2_create_buffers {
 #define VIDIOC_DECODER_CMD	_IOWR('V', 96, struct v4l2_decoder_cmd)
 #define VIDIOC_TRY_DECODER_CMD	_IOWR('V', 97, struct v4l2_decoder_cmd)
 
+/* Experimental, these three ioctls may change over the next couple of kernel
+   versions. */
+#define VIDIOC_ENUM_DV_TIMINGS  _IOWR('V', 96, struct v4l2_enum_dv_timings)
+#define VIDIOC_QUERY_DV_TIMINGS  _IOR('V', 97, struct v4l2_dv_timings)
+#define VIDIOC_DV_TIMINGS_CAP   _IOWR('V', 98, struct v4l2_dv_timings_cap)
+
 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/video/v4l2-compat-ioctl32.c as well! */
 
-- 
1.7.10

