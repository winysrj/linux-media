Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1327 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab2BCKGQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Feb 2012 05:06:16 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 1/6] videodev2.h: add enum/query/cap dv_timings ioctls.
Date: Fri,  3 Feb 2012 11:06:01 +0100
Message-Id: <f884dc30bd71901ea5dad39dc3310fa5a7d9e9c2.1328262332.git.hans.verkuil@cisco.com>
In-Reply-To: <1328263566-21620-1-git-send-email-hverkuil@xs4all.nl>
References: <1328263566-21620-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These new ioctls make it possible for the dv_timings API to replace
the dv_preset API eventually.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/linux/videodev2.h |  110 ++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 100 insertions(+), 10 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 0db0503..e59cd02 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -987,28 +987,42 @@ struct v4l2_dv_enum_preset {
  */
 
 /* BT.656/BT.1120 timing data */
+
+/*
+ * A note regarding vertical interlaced timings: height refers to the total
+ * height of the frame (= two fields). The blanking timings refer
+ * to the blanking of each field. So the height of the active frame is
+ * calculated as follows:
+ *
+ * act_height = height - vfrontporch - vsync - vbackporch -
+ *                       il_vfrontporch - il_vsync - il_vbackporch
+ *
+ * The active height of each field is act_height / 2.
+ */
 struct v4l2_bt_timings {
-	__u32	width;		/* width in pixels */
-	__u32	height;		/* height in lines */
+	__u32	width;		/* total frame width in pixels */
+	__u32	height;		/* total frame height in lines */
 	__u32	interlaced;	/* Interlaced or progressive */
 	__u32	polarities;	/* Positive or negative polarity */
 	__u64	pixelclock;	/* Pixel clock in HZ. Ex. 74.25MHz->74250000 */
-	__u32	hfrontporch;	/* Horizpontal front porch in pixels */
+	__u32	hfrontporch;	/* Horizontal front porch in pixels */
 	__u32	hsync;		/* Horizontal Sync length in pixels */
 	__u32	hbackporch;	/* Horizontal back porch in pixels */
 	__u32	vfrontporch;	/* Vertical front porch in pixels */
 	__u32	vsync;		/* Vertical Sync length in lines */
 	__u32	vbackporch;	/* Vertical back porch in lines */
-	__u32	il_vfrontporch;	/* Vertical front porch for bottom field of
-				 * interlaced field formats
+	__u32	il_vfrontporch;	/* Vertical front porch for the even field
+				 * (aka field 2) of interlaced field formats
 				 */
-	__u32	il_vsync;	/* Vertical sync length for bottom field of
-				 * interlaced field formats
+	__u32	il_vsync;	/* Vertical sync length for the even field
+				 * (aka field 2) of interlaced field formats
 				 */
-	__u32	il_vbackporch;	/* Vertical back porch for bottom field of
-				 * interlaced field formats
+	__u32	il_vbackporch;	/* Vertical back porch for the even field
+				 * (aka field 2) of interlaced field formats
 				 */
-	__u32	reserved[16];
+	__u32	standards;	/* Standards the timing belongs to */
+	__u32	flags;		/* Flags */
+	__u32	reserved[14];
 } __attribute__ ((packed));
 
 /* Interlaced or progressive format */
@@ -1019,6 +1033,37 @@ struct v4l2_bt_timings {
 #define V4L2_DV_VSYNC_POS_POL	0x00000001
 #define V4L2_DV_HSYNC_POS_POL	0x00000002
 
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
+   of six. These formats can be optionally played at 1 / 1.001 speed to
+   be compatible with the normal NTSC framerate of 29.97 frames per second.
+   This is a read-only flag. */
+#define V4L2_DV_FL_NTSC_COMPATIBLE		(1 << 1)
+/* CEA-861 specific: only valid for video transmitters, the flag is cleared
+   by receivers.
+   If the framerate of the format is a multiple of six, then the pixelclock
+   used to set up the transmitter is divided by 1.001 to make it compatible
+   with NTSC framerates. Otherwise this flag is cleared. If the transmitter
+   can't generate such frequencies, then the flag will also be cleared. */
+#define V4L2_DV_FL_DIVIDE_CLOCK_BY_1_001	(1 << 2)
+/* Specific to interlaced formats: if set, then field 1 is really one half-line
+   longer and field 2 is really one half-line shorter, so each field has
+   exactly the same number of half-lines. Whether half-lines can be detected
+   or used depends on the hardware. */
+#define V4L2_DV_FL_HALF_LINE			(1 << 0)
+
 
 /* DV timings */
 struct v4l2_dv_timings {
@@ -1032,6 +1077,47 @@ struct v4l2_dv_timings {
 /* Values for the type field */
 #define V4L2_DV_BT_656_1120	0	/* BT.656/1120 timing type */
 
+
+/* DV timings enumeration */
+struct v4l2_enum_dv_timings {
+	__u32 index;
+	__u32 reserved[3];
+	struct v4l2_dv_timings timings;
+};
+
+/* BT.656/BT.1120 timing capabilities */
+struct v4l2_bt_timings_cap {
+	__u32	min_width;	/* width in pixels */
+	__u32	max_width;	/* width in pixels */
+	__u32	min_height;	/* height in lines */
+	__u32	max_height;	/* height in lines */
+	__u64	min_pixelclock;	/* Pixel clock in HZ. Ex. 74.25MHz->74250000 */
+	__u64	max_pixelclock;	/* Pixel clock in HZ. Ex. 74.25MHz->74250000 */
+	__u32	standards;	/* Supported standards */
+	__u32	capabilities;	/* See below */
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
+/* DV timings capabilities */
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
@@ -2318,6 +2404,10 @@ struct v4l2_create_buffers {
 #define VIDIOC_G_SELECTION	_IOWR('V', 94, struct v4l2_selection)
 #define VIDIOC_S_SELECTION	_IOWR('V', 95, struct v4l2_selection)
 
+#define VIDIOC_ENUM_DV_TIMINGS  _IOWR('V', 96, struct v4l2_enum_dv_timings)
+#define VIDIOC_QUERY_DV_TIMINGS  _IOR('V', 97, struct v4l2_dv_timings)
+#define VIDIOC_DV_TIMINGS_CAP   _IOWR('V', 98, struct v4l2_dv_timings_cap)
+
 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/video/v4l2-compat-ioctl32.c as well! */
 
-- 
1.7.8.3

