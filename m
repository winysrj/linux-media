Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:40681 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755710AbZKRWnz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 17:43:55 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH v3] V4L - Adding Digital Video Timings APIs
Date: Wed, 18 Nov 2009 17:43:59 -0500
Message-Id: <1258584239-12092-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

Some minor updates (comment format) made to previous v3.

This is v3 of the digital video timings APIs implementation.
This has updates based on comments received against v2 of the patch. Hopefully
this can be merged to 2.6.33 if there are no more comments.

This adds the above APIs to the v4l2 core. This is based on version v1.2
of the RFC titled "V4L - Support for video timings at the input/output interface"
Following new ioctls are added:-

	- VIDIOC_ENUM_DV_PRESETS
	- VIDIOC_S_DV_PRESET
	- VIDIOC_G_DV_PRESET
	- VIDIOC_QUERY_DV_PRESET
	- VIDIOC_S_DV_TIMINGS
	- VIDIOC_G_DV_TIMINGS

Please refer to the RFC for the details. This code was tested using vpfe
capture driver on TI's DM365. Following is the test configuration used :-

Blue Ray HD DVD source -> TVP7002 -> DM365 (VPFE) ->DDR

A draft version of the TVP7002 driver (currently being reviewed in the mailing
list) was used that supports V4L2_DV_1080I60 & V4L2_DV_720P60 presets. 

A loopback video capture application was used for testing these APIs. This calls
following IOCTLS :-

 -  verify the new v4l2_input capabilities flag added
 -  Enumerate available presets using VIDIOC_ENUM_DV_PRESETS
 -  Set one of the supported preset using VIDIOC_S_DV_PRESET
 -  Get current preset using VIDIOC_G_DV_PRESET
 -  Detect current preset using VIDIOC_QUERY_DV_PRESET
 -  Using stub functions in tvp7002, verify VIDIOC_S_DV_TIMINGS
    and VIDIOC_G_DV_TIMINGS ioctls are received at the sub device. 
 -  Tested on 64bit platform by Hans Verkuil
	
TODOs :

 - Update v4l2-apps for the new ioctl (will send another patch after
   compilation issue is resolved)

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Reviewed-by: Randy Dunlap <randy.dunlap@oracle.com>
---
Applies to V4L-DVB linux-next branch

 drivers/media/video/v4l2-compat-ioctl32.c |    6 +
 drivers/media/video/v4l2-ioctl.c          |  147 +++++++++++++++++++++++++++++
 include/linux/videodev2.h                 |  116 ++++++++++++++++++++++-
 include/media/v4l2-ioctl.h                |   15 +++
 include/media/v4l2-subdev.h               |   21 ++++
 5 files changed, 303 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index 997975d..c4150bd 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -1077,6 +1077,12 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	case VIDIOC_DBG_G_REGISTER:
 	case VIDIOC_DBG_G_CHIP_IDENT:
 	case VIDIOC_S_HW_FREQ_SEEK:
+	case VIDIOC_ENUM_DV_PRESETS:
+	case VIDIOC_S_DV_PRESET:
+	case VIDIOC_G_DV_PRESET:
+	case VIDIOC_QUERY_DV_PRESET:
+	case VIDIOC_S_DV_TIMINGS:
+	case VIDIOC_G_DV_TIMINGS:
 		ret = do_video_ioctl(file, cmd, arg);
 		break;
 
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 30cc334..4b11257 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -284,6 +284,12 @@ static const char *v4l2_ioctls[] = {
 	[_IOC_NR(VIDIOC_DBG_G_CHIP_IDENT)] = "VIDIOC_DBG_G_CHIP_IDENT",
 	[_IOC_NR(VIDIOC_S_HW_FREQ_SEEK)]   = "VIDIOC_S_HW_FREQ_SEEK",
 #endif
+	[_IOC_NR(VIDIOC_ENUM_DV_PRESETS)]  = "VIDIOC_ENUM_DV_PRESETS",
+	[_IOC_NR(VIDIOC_S_DV_PRESET)]	   = "VIDIOC_S_DV_PRESET",
+	[_IOC_NR(VIDIOC_G_DV_PRESET)]	   = "VIDIOC_G_DV_PRESET",
+	[_IOC_NR(VIDIOC_QUERY_DV_PRESET)]  = "VIDIOC_QUERY_DV_PRESET",
+	[_IOC_NR(VIDIOC_S_DV_TIMINGS)]     = "VIDIOC_S_DV_TIMINGS",
+	[_IOC_NR(VIDIOC_G_DV_TIMINGS)]     = "VIDIOC_G_DV_TIMINGS",
 };
 #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
 
@@ -1135,6 +1141,19 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_input *p = arg;
 
+		/*
+		 * We set the flags for CAP_PRESETS, CAP_CUSTOM_TIMINGS &
+		 * CAP_STD here based on ioctl handler provided by the
+		 * driver. If the driver doesn't support these
+		 * for a specific input, it must override these flags.
+		 */
+		if (ops->vidioc_s_std)
+			p->capabilities |= V4L2_IN_CAP_STD;
+		if (ops->vidioc_s_dv_preset)
+			p->capabilities |= V4L2_IN_CAP_PRESETS;
+		if (ops->vidioc_s_dv_timings)
+			p->capabilities |= V4L2_IN_CAP_CUSTOM_TIMINGS;
+
 		if (!ops->vidioc_enum_input)
 			break;
 
@@ -1179,6 +1198,19 @@ static long __video_do_ioctl(struct file *file,
 		if (!ops->vidioc_enum_output)
 			break;
 
+		/*
+		 * We set the flags for CAP_PRESETS, CAP_CUSTOM_TIMINGS &
+		 * CAP_STD here based on ioctl handler provided by the
+		 * driver. If the driver doesn't support these
+		 * for a specific output, it must override these flags.
+		 */
+		if (ops->vidioc_s_std)
+			p->capabilities |= V4L2_OUT_CAP_STD;
+		if (ops->vidioc_s_dv_preset)
+			p->capabilities |= V4L2_OUT_CAP_PRESETS;
+		if (ops->vidioc_s_dv_timings)
+			p->capabilities |= V4L2_OUT_CAP_CUSTOM_TIMINGS;
+
 		ret = ops->vidioc_enum_output(file, fh, p);
 		if (!ret)
 			dbgarg(cmd, "index=%d, name=%s, type=%d, "
@@ -1794,6 +1826,121 @@ static long __video_do_ioctl(struct file *file,
 		}
 		break;
 	}
+	case VIDIOC_ENUM_DV_PRESETS:
+	{
+		struct v4l2_dv_enum_preset *p = arg;
+
+		if (!ops->vidioc_enum_dv_presets)
+			break;
+
+		ret = ops->vidioc_enum_dv_presets(file, fh, p);
+		if (!ret)
+			dbgarg(cmd,
+				"index=%d, preset=%d, name=%s, width=%d,"
+				" height=%d ",
+				p->index, p->preset, p->name, p->width,
+				p->height);
+		break;
+	}
+	case VIDIOC_S_DV_PRESET:
+	{
+		struct v4l2_dv_preset *p = arg;
+
+		if (!ops->vidioc_s_dv_preset)
+			break;
+
+		dbgarg(cmd, "preset=%d\n", p->preset);
+		ret = ops->vidioc_s_dv_preset(file, fh, p);
+		break;
+	}
+	case VIDIOC_G_DV_PRESET:
+	{
+		struct v4l2_dv_preset *p = arg;
+
+		if (!ops->vidioc_g_dv_preset)
+			break;
+
+		ret = ops->vidioc_g_dv_preset(file, fh, p);
+		if (!ret)
+			dbgarg(cmd, "preset=%d\n", p->preset);
+		break;
+	}
+	case VIDIOC_QUERY_DV_PRESET:
+	{
+		struct v4l2_dv_preset *p = arg;
+
+		if (!ops->vidioc_query_dv_preset)
+			break;
+
+		ret = ops->vidioc_query_dv_preset(file, fh, p);
+		if (!ret)
+			dbgarg(cmd, "preset=%d\n", p->preset);
+		break;
+	}
+	case VIDIOC_S_DV_TIMINGS:
+	{
+		struct v4l2_dv_timings *p = arg;
+
+		if (!ops->vidioc_s_dv_timings)
+			break;
+
+		switch (p->type) {
+		case V4L2_DV_BT_656_1120:
+			dbgarg2("bt-656/1120:interlaced=%d, pixelclock=%lld,"
+				" width=%d, height=%d, polarities=%x,"
+				" hfrontporch=%d, hsync=%d, hbackporch=%d,"
+				" vfrontporch=%d, vsync=%d, vbackporch=%d,"
+				" il_vfrontporch=%d, il_vsync=%d,"
+				" il_vbackporch=%d\n",
+				p->bt.interlaced, p->bt.pixelclock,
+				p->bt.width, p->bt.height, p->bt.polarities,
+				p->bt.hfrontporch, p->bt.hsync,
+				p->bt.hbackporch, p->bt.vfrontporch,
+				p->bt.vsync, p->bt.vbackporch,
+				p->bt.il_vfrontporch, p->bt.il_vsync,
+				p->bt.il_vbackporch);
+			ret = ops->vidioc_s_dv_timings(file, fh, p);
+			break;
+		default:
+			dbgarg2("Unknown type %d!\n", p->type);
+			break;
+		}
+		break;
+	}
+	case VIDIOC_G_DV_TIMINGS:
+	{
+		struct v4l2_dv_timings *p = arg;
+
+		if (!ops->vidioc_g_dv_timings)
+			break;
+
+		ret = ops->vidioc_g_dv_timings(file, fh, p);
+		if (!ret) {
+			switch (p->type) {
+			case V4L2_DV_BT_656_1120:
+				dbgarg2("bt-656/1120:interlaced=%d,"
+					" pixelclock=%lld,"
+					" width=%d, height=%d, polarities=%x,"
+					" hfrontporch=%d, hsync=%d,"
+					" hbackporch=%d, vfrontporch=%d,"
+					" vsync=%d, vbackporch=%d,"
+					" il_vfrontporch=%d, il_vsync=%d,"
+					" il_vbackporch=%d\n",
+					p->bt.interlaced, p->bt.pixelclock,
+					p->bt.width, p->bt.height,
+					p->bt.polarities, p->bt.hfrontporch,
+					p->bt.hsync, p->bt.hbackporch,
+					p->bt.vfrontporch, p->bt.vsync,
+					p->bt.vbackporch, p->bt.il_vfrontporch,
+					p->bt.il_vsync, p->bt.il_vbackporch);
+				break;
+			default:
+				dbgarg2("Unknown type %d!\n", p->type);
+				break;
+			}
+		}
+		break;
+	}
 
 	default:
 	{
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index cfde111..b8ae314 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -731,6 +731,99 @@ struct v4l2_standard {
 };
 
 /*
+ *	V I D E O	T I M I N G S	D V	P R E S E T
+ */
+struct v4l2_dv_preset {
+	__u32	preset;
+	__u32	reserved[4];
+};
+
+/*
+ *	D V	P R E S E T S	E N U M E R A T I O N
+ */
+struct v4l2_dv_enum_preset {
+	__u32	index;
+	__u32	preset;
+	__u8	name[32]; /* Name of the preset timing */
+	__u32	width;
+	__u32	height;
+	__u32	reserved[4];
+};
+
+/*
+ * 	D V	P R E S E T	V A L U E S
+ */
+#define		V4L2_DV_INVALID		0
+#define		V4L2_DV_480P59_94	1 /* BT.1362 */
+#define		V4L2_DV_576P50		2 /* BT.1362 */
+#define		V4L2_DV_720P24		3 /* SMPTE 296M */
+#define		V4L2_DV_720P25		4 /* SMPTE 296M */
+#define		V4L2_DV_720P30		5 /* SMPTE 296M */
+#define		V4L2_DV_720P50		6 /* SMPTE 296M */
+#define		V4L2_DV_720P59_94	7 /* SMPTE 274M */
+#define		V4L2_DV_720P60		8 /* SMPTE 274M/296M */
+#define		V4L2_DV_1080I29_97	9 /* BT.1120/ SMPTE 274M */
+#define		V4L2_DV_1080I30		10 /* BT.1120/ SMPTE 274M */
+#define		V4L2_DV_1080I25		11 /* BT.1120 */
+#define		V4L2_DV_1080I50		12 /* SMPTE 296M */
+#define		V4L2_DV_1080I60		13 /* SMPTE 296M */
+#define		V4L2_DV_1080P24		14 /* SMPTE 296M */
+#define		V4L2_DV_1080P25		15 /* SMPTE 296M */
+#define		V4L2_DV_1080P30		16 /* SMPTE 296M */
+#define		V4L2_DV_1080P50		17 /* BT.1120 */
+#define		V4L2_DV_1080P60		18 /* BT.1120 */
+
+/*
+ *	D V 	B T	T I M I N G S
+ */
+
+/* BT.656/BT.1120 timing data */
+struct v4l2_bt_timings {
+	__u32	width;		/* width in pixels */
+	__u32	height;		/* height in lines */
+	__u32	interlaced;	/* Interlaced or progressive */
+	__u32	polarities;	/* Positive or negative polarity */
+	__u64	pixelclock;	/* Pixel clock in HZ. Ex. 74.25MHz->74250000 */
+	__u32	hfrontporch;	/* Horizpontal front porch in pixels */
+	__u32	hsync;		/* Horizontal Sync length in pixels */
+	__u32	hbackporch;	/* Horizontal back porch in pixels */
+	__u32	vfrontporch;	/* Vertical front porch in pixels */
+	__u32	vsync;		/* Vertical Sync length in lines */
+	__u32	vbackporch;	/* Vertical back porch in lines */
+	__u32	il_vfrontporch;	/* Vertical front porch for bottom field of
+				 * interlaced field formats
+				 */
+	__u32	il_vsync;	/* Vertical sync length for bottom field of
+				 * interlaced field formats
+				 */
+	__u32	il_vbackporch;	/* Vertical back porch for bottom field of
+				 * interlaced field formats
+				 */
+	__u32	reserved[16];
+} __attribute__ ((packed));
+
+/* Interlaced or progressive format */
+#define	V4L2_DV_PROGRESSIVE	0
+#define	V4L2_DV_INTERLACED	1
+
+/* Polarities. If bit is not set, it is assumed to be negative polarity */
+#define V4L2_DV_VSYNC_POS_POL	0x00000001
+#define V4L2_DV_HSYNC_POS_POL	0x00000002
+
+
+/* DV timings */
+struct v4l2_dv_timings {
+	__u32 type;
+	union {
+		struct v4l2_bt_timings	bt;
+		__u32	reserved[32];
+	};
+} __attribute__ ((packed));
+
+/* Values for the type field */
+#define V4L2_DV_BT_656_1120	0	/* BT.656/1120 timing type */
+
+/*
  *	V I D E O   I N P U T S
  */
 struct v4l2_input {
@@ -741,7 +834,8 @@ struct v4l2_input {
 	__u32        tuner;             /*  Associated tuner */
 	v4l2_std_id  std;
 	__u32	     status;
-	__u32	     reserved[4];
+	__u32	     capabilities;
+	__u32	     reserved[3];
 };
 
 /*  Values for the 'type' field */
@@ -772,6 +866,11 @@ struct v4l2_input {
 #define V4L2_IN_ST_NO_ACCESS   0x02000000  /* Conditional access denied */
 #define V4L2_IN_ST_VTR         0x04000000  /* VTR time constant */
 
+/* capabilities flags */
+#define V4L2_IN_CAP_PRESETS		0x00000001 /* Supports S_DV_PRESET */
+#define V4L2_IN_CAP_CUSTOM_TIMINGS	0x00000002 /* Supports S_DV_TIMINGS */
+#define V4L2_IN_CAP_STD			0x00000004 /* Supports S_STD */
+
 /*
  *	V I D E O   O U T P U T S
  */
@@ -782,13 +881,19 @@ struct v4l2_output {
 	__u32	     audioset;		/*  Associated audios (bitfield) */
 	__u32	     modulator;         /*  Associated modulator */
 	v4l2_std_id  std;
-	__u32	     reserved[4];
+	__u32	     capabilities;
+	__u32	     reserved[3];
 };
 /*  Values for the 'type' field */
 #define V4L2_OUTPUT_TYPE_MODULATOR		1
 #define V4L2_OUTPUT_TYPE_ANALOG			2
 #define V4L2_OUTPUT_TYPE_ANALOGVGAOVERLAY	3
 
+/* capabilities flags */
+#define V4L2_OUT_CAP_PRESETS		0x00000001 /* Supports S_DV_PRESET */
+#define V4L2_OUT_CAP_CUSTOM_TIMINGS	0x00000002 /* Supports S_DV_TIMINGS */
+#define V4L2_OUT_CAP_STD		0x00000004 /* Supports S_STD */
+
 /*
  *	C O N T R O L S
  */
@@ -1621,6 +1726,13 @@ struct v4l2_dbg_chip_ident {
 #endif
 
 #define VIDIOC_S_HW_FREQ_SEEK	 _IOW('V', 82, struct v4l2_hw_freq_seek)
+#define	VIDIOC_ENUM_DV_PRESETS	_IOWR('V', 83, struct v4l2_dv_enum_preset)
+#define	VIDIOC_S_DV_PRESET	_IOWR('V', 84, struct v4l2_dv_preset)
+#define	VIDIOC_G_DV_PRESET	_IOWR('V', 85, struct v4l2_dv_preset)
+#define	VIDIOC_QUERY_DV_PRESET	_IOR('V',  86, struct v4l2_dv_preset)
+#define	VIDIOC_S_DV_TIMINGS	_IOWR('V', 87, struct v4l2_dv_timings)
+#define	VIDIOC_G_DV_TIMINGS	_IOWR('V', 88, struct v4l2_dv_timings)
+
 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/video/v4l2-compat-ioctl32.c as well! */
 
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 7a4529d..e8ba0f2 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -239,6 +239,21 @@ struct v4l2_ioctl_ops {
 	int (*vidioc_enum_frameintervals) (struct file *file, void *fh,
 					   struct v4l2_frmivalenum *fival);
 
+	/* DV Timings IOCTLs */
+	int (*vidioc_enum_dv_presets) (struct file *file, void *fh,
+				       struct v4l2_dv_enum_preset *preset);
+
+	int (*vidioc_s_dv_preset) (struct file *file, void *fh,
+				   struct v4l2_dv_preset *preset);
+	int (*vidioc_g_dv_preset) (struct file *file, void *fh,
+				   struct v4l2_dv_preset *preset);
+	int (*vidioc_query_dv_preset) (struct file *file, void *fh,
+					struct v4l2_dv_preset *qpreset);
+	int (*vidioc_s_dv_timings) (struct file *file, void *fh,
+				    struct v4l2_dv_timings *timings);
+	int (*vidioc_g_dv_timings) (struct file *file, void *fh,
+				    struct v4l2_dv_timings *timings);
+
 	/* For other private ioctls */
 	long (*vidioc_default)	       (struct file *file, void *fh,
 					int cmd, void *arg);
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 88c13d6..92634da 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -217,6 +217,19 @@ struct v4l2_subdev_audio_ops {
 
    s_routing: see s_routing in audio_ops, except this version is for video
 	devices.
+
+   s_dv_preset: set dv (Digital Video) preset in the sub device. Similar to
+	s_std()
+
+   query_dv_preset: query dv preset in the sub device. This is similar to
+	querystd()
+
+   s_dv_timings(): Set custom dv timings in the sub device. This is used
+	when sub device is capable of setting detailed timing information
+	in the hardware to generate/detect the video signal.
+
+   g_dv_timings(): Get custom dv timings in the sub device.
+
  */
 struct v4l2_subdev_video_ops {
 	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32 config);
@@ -240,6 +253,14 @@ struct v4l2_subdev_video_ops {
 	int (*s_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
 	int (*enum_framesizes)(struct v4l2_subdev *sd, struct v4l2_frmsizeenum *fsize);
 	int (*enum_frameintervals)(struct v4l2_subdev *sd, struct v4l2_frmivalenum *fival);
+	int (*s_dv_preset)(struct v4l2_subdev *sd,
+			struct v4l2_dv_preset *preset);
+	int (*query_dv_preset)(struct v4l2_subdev *sd,
+			struct v4l2_dv_preset *preset);
+	int (*s_dv_timings)(struct v4l2_subdev *sd,
+			struct v4l2_dv_timings *timings);
+	int (*g_dv_timings)(struct v4l2_subdev *sd,
+			struct v4l2_dv_timings *timings);
 };
 
 /*
-- 
1.6.0.4

