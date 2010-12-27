Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:61576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921Ab0L0LpX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 06:45:23 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBRBjN10021993
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 06:45:23 -0500
Received: from gaivota (vpn-11-156.rdu.redhat.com [10.11.11.156])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oBRBd1iS001764
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 06:45:19 -0500
Date: Mon, 27 Dec 2010 09:38:42 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/6] [media] V4L1 removal: Remove linux/videodev.h
Message-ID: <20101227093842.3bec0bcb@gaivota>
In-Reply-To: <cover.1293449547.git.mchehab@redhat.com>
References: <cover.1293449547.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

There's no sense on keeping it on 2.6.38, as nobody is using it
anymore, at the kernel tree, and installing it at the userspace
API.

As two deprecated drivers still need it, move it to their internal
directories.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 create mode 100644 drivers/staging/se401/videodev.h
 create mode 100644 drivers/staging/usbvideo/videodev.h
 delete mode 100644 include/linux/videodev.h
 delete mode 100644 include/media/ovcamchip.h

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index d66ed2b..e348b7e 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -97,23 +97,6 @@ Who:	Pavel Machek <pavel@ucw.cz>
 
 ---------------------------
 
-What:	Video4Linux API 1 ioctls and from Video devices.
-When:	kernel 2.6.39
-Files:	include/linux/videodev.h
-Check:	include/linux/videodev.h
-Why:	V4L1 AP1 was replaced by V4L2 API during migration from 2.4 to 2.6
-	series. The old API have lots of drawbacks and don't provide enough
-	means to work with all video and audio standards. The newer API is
-	already available on the main drivers and should be used instead.
-
-	The userspace libv4l1 library can convert V4L1 calls to V4L2. This
-	replaces the kernel V4L1 compatibility module which was removed in
-	2.6.38. The last V4L1 drivers will either be converted to V4L2 or
-	removed for 2.6.39 at which point the V4L1 API will cease to exist.
-Who:	Mauro Carvalho Chehab <mchehab@infradead.org>
-
----------------------------
-
 What:	Video4Linux obsolete drivers using V4L1 API
 When:	kernel 2.6.39
 Files:	drivers/staging/se401/* drivers/staging/usbvideo/*
diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index 8ac89ad..38c4b3c 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -15,7 +15,6 @@
 
 #include <linux/compat.h>
 #define __OLD_VIDIOC_ /* To allow fixing old calls*/
-#include <linux/videodev.h>
 #include <linux/videodev2.h>
 #include <linux/module.h>
 #include <linux/smp_lock.h>
diff --git a/drivers/staging/se401/se401.h b/drivers/staging/se401/se401.h
index bf7d2e9..2758f47 100644
--- a/drivers/staging/se401/se401.h
+++ b/drivers/staging/se401/se401.h
@@ -3,7 +3,7 @@
 #define __LINUX_se401_H
 
 #include <linux/uaccess.h>
-#include <linux/videodev.h>
+#include "videodev.h"
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <linux/mutex.h>
diff --git a/drivers/staging/se401/videodev.h b/drivers/staging/se401/videodev.h
new file mode 100644
index 0000000..f11efbe
--- /dev/null
+++ b/drivers/staging/se401/videodev.h
@@ -0,0 +1,318 @@
+/*
+ *	Video for Linux version 1 - OBSOLETE
+ *
+ *	Header file for v4l1 drivers and applications, for
+ *	Linux kernels 2.2.x or 2.4.x.
+ *
+ *	Provides header for legacy drivers and applications
+ *
+ *	See http://linuxtv.org for more info
+ *
+ */
+#ifndef __LINUX_VIDEODEV_H
+#define __LINUX_VIDEODEV_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+#include <linux/videodev2.h>
+
+#define VID_TYPE_CAPTURE	1	/* Can capture */
+#define VID_TYPE_TUNER		2	/* Can tune */
+#define VID_TYPE_TELETEXT	4	/* Does teletext */
+#define VID_TYPE_OVERLAY	8	/* Overlay onto frame buffer */
+#define VID_TYPE_CHROMAKEY	16	/* Overlay by chromakey */
+#define VID_TYPE_CLIPPING	32	/* Can clip */
+#define VID_TYPE_FRAMERAM	64	/* Uses the frame buffer memory */
+#define VID_TYPE_SCALES		128	/* Scalable */
+#define VID_TYPE_MONOCHROME	256	/* Monochrome only */
+#define VID_TYPE_SUBCAPTURE	512	/* Can capture subareas of the image */
+#define VID_TYPE_MPEG_DECODER	1024	/* Can decode MPEG streams */
+#define VID_TYPE_MPEG_ENCODER	2048	/* Can encode MPEG streams */
+#define VID_TYPE_MJPEG_DECODER	4096	/* Can decode MJPEG streams */
+#define VID_TYPE_MJPEG_ENCODER	8192	/* Can encode MJPEG streams */
+
+struct video_capability
+{
+	char name[32];
+	int type;
+	int channels;	/* Num channels */
+	int audios;	/* Num audio devices */
+	int maxwidth;	/* Supported width */
+	int maxheight;	/* And height */
+	int minwidth;	/* Supported width */
+	int minheight;	/* And height */
+};
+
+
+struct video_channel
+{
+	int channel;
+	char name[32];
+	int tuners;
+	__u32  flags;
+#define VIDEO_VC_TUNER		1	/* Channel has a tuner */
+#define VIDEO_VC_AUDIO		2	/* Channel has audio */
+	__u16  type;
+#define VIDEO_TYPE_TV		1
+#define VIDEO_TYPE_CAMERA	2
+	__u16 norm;			/* Norm set by channel */
+};
+
+struct video_tuner
+{
+	int tuner;
+	char name[32];
+	unsigned long rangelow, rangehigh;	/* Tuner range */
+	__u32 flags;
+#define VIDEO_TUNER_PAL		1
+#define VIDEO_TUNER_NTSC	2
+#define VIDEO_TUNER_SECAM	4
+#define VIDEO_TUNER_LOW		8	/* Uses KHz not MHz */
+#define VIDEO_TUNER_NORM	16	/* Tuner can set norm */
+#define VIDEO_TUNER_STEREO_ON	128	/* Tuner is seeing stereo */
+#define VIDEO_TUNER_RDS_ON      256     /* Tuner is seeing an RDS datastream */
+#define VIDEO_TUNER_MBS_ON      512     /* Tuner is seeing an MBS datastream */
+	__u16 mode;			/* PAL/NTSC/SECAM/OTHER */
+#define VIDEO_MODE_PAL		0
+#define VIDEO_MODE_NTSC		1
+#define VIDEO_MODE_SECAM	2
+#define VIDEO_MODE_AUTO		3
+	__u16 signal;			/* Signal strength 16bit scale */
+};
+
+struct video_picture
+{
+	__u16	brightness;
+	__u16	hue;
+	__u16	colour;
+	__u16	contrast;
+	__u16	whiteness;	/* Black and white only */
+	__u16	depth;		/* Capture depth */
+	__u16   palette;	/* Palette in use */
+#define VIDEO_PALETTE_GREY	1	/* Linear greyscale */
+#define VIDEO_PALETTE_HI240	2	/* High 240 cube (BT848) */
+#define VIDEO_PALETTE_RGB565	3	/* 565 16 bit RGB */
+#define VIDEO_PALETTE_RGB24	4	/* 24bit RGB */
+#define VIDEO_PALETTE_RGB32	5	/* 32bit RGB */
+#define VIDEO_PALETTE_RGB555	6	/* 555 15bit RGB */
+#define VIDEO_PALETTE_YUV422	7	/* YUV422 capture */
+#define VIDEO_PALETTE_YUYV	8
+#define VIDEO_PALETTE_UYVY	9	/* The great thing about standards is ... */
+#define VIDEO_PALETTE_YUV420	10
+#define VIDEO_PALETTE_YUV411	11	/* YUV411 capture */
+#define VIDEO_PALETTE_RAW	12	/* RAW capture (BT848) */
+#define VIDEO_PALETTE_YUV422P	13	/* YUV 4:2:2 Planar */
+#define VIDEO_PALETTE_YUV411P	14	/* YUV 4:1:1 Planar */
+#define VIDEO_PALETTE_YUV420P	15	/* YUV 4:2:0 Planar */
+#define VIDEO_PALETTE_YUV410P	16	/* YUV 4:1:0 Planar */
+#define VIDEO_PALETTE_PLANAR	13	/* start of planar entries */
+#define VIDEO_PALETTE_COMPONENT 7	/* start of component entries */
+};
+
+struct video_audio
+{
+	int	audio;		/* Audio channel */
+	__u16	volume;		/* If settable */
+	__u16	bass, treble;
+	__u32	flags;
+#define VIDEO_AUDIO_MUTE	1
+#define VIDEO_AUDIO_MUTABLE	2
+#define VIDEO_AUDIO_VOLUME	4
+#define VIDEO_AUDIO_BASS	8
+#define VIDEO_AUDIO_TREBLE	16
+#define VIDEO_AUDIO_BALANCE	32
+	char    name[16];
+#define VIDEO_SOUND_MONO	1
+#define VIDEO_SOUND_STEREO	2
+#define VIDEO_SOUND_LANG1	4
+#define VIDEO_SOUND_LANG2	8
+	__u16   mode;
+	__u16	balance;	/* Stereo balance */
+	__u16	step;		/* Step actual volume uses */
+};
+
+struct video_clip
+{
+	__s32	x,y;
+	__s32	width, height;
+	struct	video_clip *next;	/* For user use/driver use only */
+};
+
+struct video_window
+{
+	__u32	x,y;			/* Position of window */
+	__u32	width,height;		/* Its size */
+	__u32	chromakey;
+	__u32	flags;
+	struct	video_clip __user *clips;	/* Set only */
+	int	clipcount;
+#define VIDEO_WINDOW_INTERLACE	1
+#define VIDEO_WINDOW_CHROMAKEY	16	/* Overlay by chromakey */
+#define VIDEO_CLIP_BITMAP	-1
+/* bitmap is 1024x625, a '1' bit represents a clipped pixel */
+#define VIDEO_CLIPMAP_SIZE	(128 * 625)
+};
+
+struct video_capture
+{
+	__u32 	x,y;			/* Offsets into image */
+	__u32	width, height;		/* Area to capture */
+	__u16	decimation;		/* Decimation divider */
+	__u16	flags;			/* Flags for capture */
+#define VIDEO_CAPTURE_ODD		0	/* Temporal */
+#define VIDEO_CAPTURE_EVEN		1
+};
+
+struct video_buffer
+{
+	void	*base;
+	int	height,width;
+	int	depth;
+	int	bytesperline;
+};
+
+struct video_mmap
+{
+	unsigned	int frame;		/* Frame (0 - n) for double buffer */
+	int		height,width;
+	unsigned	int format;		/* should be VIDEO_PALETTE_* */
+};
+
+struct video_key
+{
+	__u8	key[8];
+	__u32	flags;
+};
+
+struct video_mbuf
+{
+	int	size;		/* Total memory to map */
+	int	frames;		/* Frames */
+	int	offsets[VIDEO_MAX_FRAME];
+};
+
+#define 	VIDEO_NO_UNIT	(-1)
+
+struct video_unit
+{
+	int 	video;		/* Video minor */
+	int	vbi;		/* VBI minor */
+	int	radio;		/* Radio minor */
+	int	audio;		/* Audio minor */
+	int	teletext;	/* Teletext minor */
+};
+
+struct vbi_format {
+	__u32	sampling_rate;	/* in Hz */
+	__u32	samples_per_line;
+	__u32	sample_format;	/* VIDEO_PALETTE_RAW only (1 byte) */
+	__s32	start[2];	/* starting line for each frame */
+	__u32	count[2];	/* count of lines for each frame */
+	__u32	flags;
+#define	VBI_UNSYNC	1	/* can distingues between top/bottom field */
+#define	VBI_INTERLACED	2	/* lines are interlaced */
+};
+
+/* video_info is biased towards hardware mpeg encode/decode */
+/* but it could apply generically to any hardware compressor/decompressor */
+struct video_info
+{
+	__u32	frame_count;	/* frames output since decode/encode began */
+	__u32	h_size;		/* current unscaled horizontal size */
+	__u32	v_size;		/* current unscaled veritcal size */
+	__u32	smpte_timecode;	/* current SMPTE timecode (for current GOP) */
+	__u32	picture_type;	/* current picture type */
+	__u32	temporal_reference;	/* current temporal reference */
+	__u8	user_data[256];	/* user data last found in compressed stream */
+	/* user_data[0] contains user data flags, user_data[1] has count */
+};
+
+/* generic structure for setting playback modes */
+struct video_play_mode
+{
+	int	mode;
+	int	p1;
+	int	p2;
+};
+
+/* for loading microcode / fpga programming */
+struct video_code
+{
+	char	loadwhat[16];	/* name or tag of file being passed */
+	int	datasize;
+	__u8	*data;
+};
+
+#define VIDIOCGCAP		_IOR('v',1,struct video_capability)	/* Get capabilities */
+#define VIDIOCGCHAN		_IOWR('v',2,struct video_channel)	/* Get channel info (sources) */
+#define VIDIOCSCHAN		_IOW('v',3,struct video_channel)	/* Set channel 	*/
+#define VIDIOCGTUNER		_IOWR('v',4,struct video_tuner)		/* Get tuner abilities */
+#define VIDIOCSTUNER		_IOW('v',5,struct video_tuner)		/* Tune the tuner for the current channel */
+#define VIDIOCGPICT		_IOR('v',6,struct video_picture)	/* Get picture properties */
+#define VIDIOCSPICT		_IOW('v',7,struct video_picture)	/* Set picture properties */
+#define VIDIOCCAPTURE		_IOW('v',8,int)				/* Start, end capture */
+#define VIDIOCGWIN		_IOR('v',9, struct video_window)	/* Get the video overlay window */
+#define VIDIOCSWIN		_IOW('v',10, struct video_window)	/* Set the video overlay window - passes clip list for hardware smarts , chromakey etc */
+#define VIDIOCGFBUF		_IOR('v',11, struct video_buffer)	/* Get frame buffer */
+#define VIDIOCSFBUF		_IOW('v',12, struct video_buffer)	/* Set frame buffer - root only */
+#define VIDIOCKEY		_IOR('v',13, struct video_key)		/* Video key event - to dev 255 is to all - cuts capture on all DMA windows with this key (0xFFFFFFFF == all) */
+#define VIDIOCGFREQ		_IOR('v',14, unsigned long)		/* Set tuner */
+#define VIDIOCSFREQ		_IOW('v',15, unsigned long)		/* Set tuner */
+#define VIDIOCGAUDIO		_IOR('v',16, struct video_audio)	/* Get audio info */
+#define VIDIOCSAUDIO		_IOW('v',17, struct video_audio)	/* Audio source, mute etc */
+#define VIDIOCSYNC		_IOW('v',18, int)			/* Sync with mmap grabbing */
+#define VIDIOCMCAPTURE		_IOW('v',19, struct video_mmap)		/* Grab frames */
+#define VIDIOCGMBUF		_IOR('v',20, struct video_mbuf)		/* Memory map buffer info */
+#define VIDIOCGUNIT		_IOR('v',21, struct video_unit)		/* Get attached units */
+#define VIDIOCGCAPTURE		_IOR('v',22, struct video_capture)	/* Get subcapture */
+#define VIDIOCSCAPTURE		_IOW('v',23, struct video_capture)	/* Set subcapture */
+#define VIDIOCSPLAYMODE		_IOW('v',24, struct video_play_mode)	/* Set output video mode/feature */
+#define VIDIOCSWRITEMODE	_IOW('v',25, int)			/* Set write mode */
+#define VIDIOCGPLAYINFO		_IOR('v',26, struct video_info)		/* Get current playback info from hardware */
+#define VIDIOCSMICROCODE	_IOW('v',27, struct video_code)		/* Load microcode into hardware */
+#define	VIDIOCGVBIFMT		_IOR('v',28, struct vbi_format)		/* Get VBI information */
+#define	VIDIOCSVBIFMT		_IOW('v',29, struct vbi_format)		/* Set VBI information */
+
+
+#define BASE_VIDIOCPRIVATE	192		/* 192-255 are private */
+
+/* VIDIOCSWRITEMODE */
+#define VID_WRITE_MPEG_AUD		0
+#define VID_WRITE_MPEG_VID		1
+#define VID_WRITE_OSD			2
+#define VID_WRITE_TTX			3
+#define VID_WRITE_CC			4
+#define VID_WRITE_MJPEG			5
+
+/* VIDIOCSPLAYMODE */
+#define VID_PLAY_VID_OUT_MODE		0
+	/* p1: = VIDEO_MODE_PAL, VIDEO_MODE_NTSC, etc ... */
+#define VID_PLAY_GENLOCK		1
+	/* p1: 0 = OFF, 1 = ON */
+	/* p2: GENLOCK FINE DELAY value */
+#define VID_PLAY_NORMAL			2
+#define VID_PLAY_PAUSE			3
+#define VID_PLAY_SINGLE_FRAME		4
+#define VID_PLAY_FAST_FORWARD		5
+#define VID_PLAY_SLOW_MOTION		6
+#define VID_PLAY_IMMEDIATE_NORMAL	7
+#define VID_PLAY_SWITCH_CHANNELS	8
+#define VID_PLAY_FREEZE_FRAME		9
+#define VID_PLAY_STILL_MODE		10
+#define VID_PLAY_MASTER_MODE		11
+	/* p1: see below */
+#define		VID_PLAY_MASTER_NONE	1
+#define		VID_PLAY_MASTER_VIDEO	2
+#define		VID_PLAY_MASTER_AUDIO	3
+#define VID_PLAY_ACTIVE_SCANLINES	12
+	/* p1 = first active; p2 = last active */
+#define VID_PLAY_RESET			13
+#define VID_PLAY_END_MARK		14
+
+#endif /* __LINUX_VIDEODEV_H */
+
+/*
+ * Local variables:
+ * c-basic-offset: 8
+ * End:
+ */
diff --git a/drivers/staging/usbvideo/usbvideo.h b/drivers/staging/usbvideo/usbvideo.h
index c66985b..95638a0 100644
--- a/drivers/staging/usbvideo/usbvideo.h
+++ b/drivers/staging/usbvideo/usbvideo.h
@@ -16,7 +16,7 @@
 #ifndef usbvideo_h
 #define	usbvideo_h
 
-#include <linux/videodev.h>
+#include "videodev.h"
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <linux/usb.h>
diff --git a/drivers/staging/usbvideo/vicam.c b/drivers/staging/usbvideo/vicam.c
index dc17cce..ecdb121 100644
--- a/drivers/staging/usbvideo/vicam.c
+++ b/drivers/staging/usbvideo/vicam.c
@@ -38,7 +38,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/videodev.h>
+#include "videodev.h"
 #include <linux/usb.h>
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
diff --git a/drivers/staging/usbvideo/videodev.h b/drivers/staging/usbvideo/videodev.h
new file mode 100644
index 0000000..f11efbe
--- /dev/null
+++ b/drivers/staging/usbvideo/videodev.h
@@ -0,0 +1,318 @@
+/*
+ *	Video for Linux version 1 - OBSOLETE
+ *
+ *	Header file for v4l1 drivers and applications, for
+ *	Linux kernels 2.2.x or 2.4.x.
+ *
+ *	Provides header for legacy drivers and applications
+ *
+ *	See http://linuxtv.org for more info
+ *
+ */
+#ifndef __LINUX_VIDEODEV_H
+#define __LINUX_VIDEODEV_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+#include <linux/videodev2.h>
+
+#define VID_TYPE_CAPTURE	1	/* Can capture */
+#define VID_TYPE_TUNER		2	/* Can tune */
+#define VID_TYPE_TELETEXT	4	/* Does teletext */
+#define VID_TYPE_OVERLAY	8	/* Overlay onto frame buffer */
+#define VID_TYPE_CHROMAKEY	16	/* Overlay by chromakey */
+#define VID_TYPE_CLIPPING	32	/* Can clip */
+#define VID_TYPE_FRAMERAM	64	/* Uses the frame buffer memory */
+#define VID_TYPE_SCALES		128	/* Scalable */
+#define VID_TYPE_MONOCHROME	256	/* Monochrome only */
+#define VID_TYPE_SUBCAPTURE	512	/* Can capture subareas of the image */
+#define VID_TYPE_MPEG_DECODER	1024	/* Can decode MPEG streams */
+#define VID_TYPE_MPEG_ENCODER	2048	/* Can encode MPEG streams */
+#define VID_TYPE_MJPEG_DECODER	4096	/* Can decode MJPEG streams */
+#define VID_TYPE_MJPEG_ENCODER	8192	/* Can encode MJPEG streams */
+
+struct video_capability
+{
+	char name[32];
+	int type;
+	int channels;	/* Num channels */
+	int audios;	/* Num audio devices */
+	int maxwidth;	/* Supported width */
+	int maxheight;	/* And height */
+	int minwidth;	/* Supported width */
+	int minheight;	/* And height */
+};
+
+
+struct video_channel
+{
+	int channel;
+	char name[32];
+	int tuners;
+	__u32  flags;
+#define VIDEO_VC_TUNER		1	/* Channel has a tuner */
+#define VIDEO_VC_AUDIO		2	/* Channel has audio */
+	__u16  type;
+#define VIDEO_TYPE_TV		1
+#define VIDEO_TYPE_CAMERA	2
+	__u16 norm;			/* Norm set by channel */
+};
+
+struct video_tuner
+{
+	int tuner;
+	char name[32];
+	unsigned long rangelow, rangehigh;	/* Tuner range */
+	__u32 flags;
+#define VIDEO_TUNER_PAL		1
+#define VIDEO_TUNER_NTSC	2
+#define VIDEO_TUNER_SECAM	4
+#define VIDEO_TUNER_LOW		8	/* Uses KHz not MHz */
+#define VIDEO_TUNER_NORM	16	/* Tuner can set norm */
+#define VIDEO_TUNER_STEREO_ON	128	/* Tuner is seeing stereo */
+#define VIDEO_TUNER_RDS_ON      256     /* Tuner is seeing an RDS datastream */
+#define VIDEO_TUNER_MBS_ON      512     /* Tuner is seeing an MBS datastream */
+	__u16 mode;			/* PAL/NTSC/SECAM/OTHER */
+#define VIDEO_MODE_PAL		0
+#define VIDEO_MODE_NTSC		1
+#define VIDEO_MODE_SECAM	2
+#define VIDEO_MODE_AUTO		3
+	__u16 signal;			/* Signal strength 16bit scale */
+};
+
+struct video_picture
+{
+	__u16	brightness;
+	__u16	hue;
+	__u16	colour;
+	__u16	contrast;
+	__u16	whiteness;	/* Black and white only */
+	__u16	depth;		/* Capture depth */
+	__u16   palette;	/* Palette in use */
+#define VIDEO_PALETTE_GREY	1	/* Linear greyscale */
+#define VIDEO_PALETTE_HI240	2	/* High 240 cube (BT848) */
+#define VIDEO_PALETTE_RGB565	3	/* 565 16 bit RGB */
+#define VIDEO_PALETTE_RGB24	4	/* 24bit RGB */
+#define VIDEO_PALETTE_RGB32	5	/* 32bit RGB */
+#define VIDEO_PALETTE_RGB555	6	/* 555 15bit RGB */
+#define VIDEO_PALETTE_YUV422	7	/* YUV422 capture */
+#define VIDEO_PALETTE_YUYV	8
+#define VIDEO_PALETTE_UYVY	9	/* The great thing about standards is ... */
+#define VIDEO_PALETTE_YUV420	10
+#define VIDEO_PALETTE_YUV411	11	/* YUV411 capture */
+#define VIDEO_PALETTE_RAW	12	/* RAW capture (BT848) */
+#define VIDEO_PALETTE_YUV422P	13	/* YUV 4:2:2 Planar */
+#define VIDEO_PALETTE_YUV411P	14	/* YUV 4:1:1 Planar */
+#define VIDEO_PALETTE_YUV420P	15	/* YUV 4:2:0 Planar */
+#define VIDEO_PALETTE_YUV410P	16	/* YUV 4:1:0 Planar */
+#define VIDEO_PALETTE_PLANAR	13	/* start of planar entries */
+#define VIDEO_PALETTE_COMPONENT 7	/* start of component entries */
+};
+
+struct video_audio
+{
+	int	audio;		/* Audio channel */
+	__u16	volume;		/* If settable */
+	__u16	bass, treble;
+	__u32	flags;
+#define VIDEO_AUDIO_MUTE	1
+#define VIDEO_AUDIO_MUTABLE	2
+#define VIDEO_AUDIO_VOLUME	4
+#define VIDEO_AUDIO_BASS	8
+#define VIDEO_AUDIO_TREBLE	16
+#define VIDEO_AUDIO_BALANCE	32
+	char    name[16];
+#define VIDEO_SOUND_MONO	1
+#define VIDEO_SOUND_STEREO	2
+#define VIDEO_SOUND_LANG1	4
+#define VIDEO_SOUND_LANG2	8
+	__u16   mode;
+	__u16	balance;	/* Stereo balance */
+	__u16	step;		/* Step actual volume uses */
+};
+
+struct video_clip
+{
+	__s32	x,y;
+	__s32	width, height;
+	struct	video_clip *next;	/* For user use/driver use only */
+};
+
+struct video_window
+{
+	__u32	x,y;			/* Position of window */
+	__u32	width,height;		/* Its size */
+	__u32	chromakey;
+	__u32	flags;
+	struct	video_clip __user *clips;	/* Set only */
+	int	clipcount;
+#define VIDEO_WINDOW_INTERLACE	1
+#define VIDEO_WINDOW_CHROMAKEY	16	/* Overlay by chromakey */
+#define VIDEO_CLIP_BITMAP	-1
+/* bitmap is 1024x625, a '1' bit represents a clipped pixel */
+#define VIDEO_CLIPMAP_SIZE	(128 * 625)
+};
+
+struct video_capture
+{
+	__u32 	x,y;			/* Offsets into image */
+	__u32	width, height;		/* Area to capture */
+	__u16	decimation;		/* Decimation divider */
+	__u16	flags;			/* Flags for capture */
+#define VIDEO_CAPTURE_ODD		0	/* Temporal */
+#define VIDEO_CAPTURE_EVEN		1
+};
+
+struct video_buffer
+{
+	void	*base;
+	int	height,width;
+	int	depth;
+	int	bytesperline;
+};
+
+struct video_mmap
+{
+	unsigned	int frame;		/* Frame (0 - n) for double buffer */
+	int		height,width;
+	unsigned	int format;		/* should be VIDEO_PALETTE_* */
+};
+
+struct video_key
+{
+	__u8	key[8];
+	__u32	flags;
+};
+
+struct video_mbuf
+{
+	int	size;		/* Total memory to map */
+	int	frames;		/* Frames */
+	int	offsets[VIDEO_MAX_FRAME];
+};
+
+#define 	VIDEO_NO_UNIT	(-1)
+
+struct video_unit
+{
+	int 	video;		/* Video minor */
+	int	vbi;		/* VBI minor */
+	int	radio;		/* Radio minor */
+	int	audio;		/* Audio minor */
+	int	teletext;	/* Teletext minor */
+};
+
+struct vbi_format {
+	__u32	sampling_rate;	/* in Hz */
+	__u32	samples_per_line;
+	__u32	sample_format;	/* VIDEO_PALETTE_RAW only (1 byte) */
+	__s32	start[2];	/* starting line for each frame */
+	__u32	count[2];	/* count of lines for each frame */
+	__u32	flags;
+#define	VBI_UNSYNC	1	/* can distingues between top/bottom field */
+#define	VBI_INTERLACED	2	/* lines are interlaced */
+};
+
+/* video_info is biased towards hardware mpeg encode/decode */
+/* but it could apply generically to any hardware compressor/decompressor */
+struct video_info
+{
+	__u32	frame_count;	/* frames output since decode/encode began */
+	__u32	h_size;		/* current unscaled horizontal size */
+	__u32	v_size;		/* current unscaled veritcal size */
+	__u32	smpte_timecode;	/* current SMPTE timecode (for current GOP) */
+	__u32	picture_type;	/* current picture type */
+	__u32	temporal_reference;	/* current temporal reference */
+	__u8	user_data[256];	/* user data last found in compressed stream */
+	/* user_data[0] contains user data flags, user_data[1] has count */
+};
+
+/* generic structure for setting playback modes */
+struct video_play_mode
+{
+	int	mode;
+	int	p1;
+	int	p2;
+};
+
+/* for loading microcode / fpga programming */
+struct video_code
+{
+	char	loadwhat[16];	/* name or tag of file being passed */
+	int	datasize;
+	__u8	*data;
+};
+
+#define VIDIOCGCAP		_IOR('v',1,struct video_capability)	/* Get capabilities */
+#define VIDIOCGCHAN		_IOWR('v',2,struct video_channel)	/* Get channel info (sources) */
+#define VIDIOCSCHAN		_IOW('v',3,struct video_channel)	/* Set channel 	*/
+#define VIDIOCGTUNER		_IOWR('v',4,struct video_tuner)		/* Get tuner abilities */
+#define VIDIOCSTUNER		_IOW('v',5,struct video_tuner)		/* Tune the tuner for the current channel */
+#define VIDIOCGPICT		_IOR('v',6,struct video_picture)	/* Get picture properties */
+#define VIDIOCSPICT		_IOW('v',7,struct video_picture)	/* Set picture properties */
+#define VIDIOCCAPTURE		_IOW('v',8,int)				/* Start, end capture */
+#define VIDIOCGWIN		_IOR('v',9, struct video_window)	/* Get the video overlay window */
+#define VIDIOCSWIN		_IOW('v',10, struct video_window)	/* Set the video overlay window - passes clip list for hardware smarts , chromakey etc */
+#define VIDIOCGFBUF		_IOR('v',11, struct video_buffer)	/* Get frame buffer */
+#define VIDIOCSFBUF		_IOW('v',12, struct video_buffer)	/* Set frame buffer - root only */
+#define VIDIOCKEY		_IOR('v',13, struct video_key)		/* Video key event - to dev 255 is to all - cuts capture on all DMA windows with this key (0xFFFFFFFF == all) */
+#define VIDIOCGFREQ		_IOR('v',14, unsigned long)		/* Set tuner */
+#define VIDIOCSFREQ		_IOW('v',15, unsigned long)		/* Set tuner */
+#define VIDIOCGAUDIO		_IOR('v',16, struct video_audio)	/* Get audio info */
+#define VIDIOCSAUDIO		_IOW('v',17, struct video_audio)	/* Audio source, mute etc */
+#define VIDIOCSYNC		_IOW('v',18, int)			/* Sync with mmap grabbing */
+#define VIDIOCMCAPTURE		_IOW('v',19, struct video_mmap)		/* Grab frames */
+#define VIDIOCGMBUF		_IOR('v',20, struct video_mbuf)		/* Memory map buffer info */
+#define VIDIOCGUNIT		_IOR('v',21, struct video_unit)		/* Get attached units */
+#define VIDIOCGCAPTURE		_IOR('v',22, struct video_capture)	/* Get subcapture */
+#define VIDIOCSCAPTURE		_IOW('v',23, struct video_capture)	/* Set subcapture */
+#define VIDIOCSPLAYMODE		_IOW('v',24, struct video_play_mode)	/* Set output video mode/feature */
+#define VIDIOCSWRITEMODE	_IOW('v',25, int)			/* Set write mode */
+#define VIDIOCGPLAYINFO		_IOR('v',26, struct video_info)		/* Get current playback info from hardware */
+#define VIDIOCSMICROCODE	_IOW('v',27, struct video_code)		/* Load microcode into hardware */
+#define	VIDIOCGVBIFMT		_IOR('v',28, struct vbi_format)		/* Get VBI information */
+#define	VIDIOCSVBIFMT		_IOW('v',29, struct vbi_format)		/* Set VBI information */
+
+
+#define BASE_VIDIOCPRIVATE	192		/* 192-255 are private */
+
+/* VIDIOCSWRITEMODE */
+#define VID_WRITE_MPEG_AUD		0
+#define VID_WRITE_MPEG_VID		1
+#define VID_WRITE_OSD			2
+#define VID_WRITE_TTX			3
+#define VID_WRITE_CC			4
+#define VID_WRITE_MJPEG			5
+
+/* VIDIOCSPLAYMODE */
+#define VID_PLAY_VID_OUT_MODE		0
+	/* p1: = VIDEO_MODE_PAL, VIDEO_MODE_NTSC, etc ... */
+#define VID_PLAY_GENLOCK		1
+	/* p1: 0 = OFF, 1 = ON */
+	/* p2: GENLOCK FINE DELAY value */
+#define VID_PLAY_NORMAL			2
+#define VID_PLAY_PAUSE			3
+#define VID_PLAY_SINGLE_FRAME		4
+#define VID_PLAY_FAST_FORWARD		5
+#define VID_PLAY_SLOW_MOTION		6
+#define VID_PLAY_IMMEDIATE_NORMAL	7
+#define VID_PLAY_SWITCH_CHANNELS	8
+#define VID_PLAY_FREEZE_FRAME		9
+#define VID_PLAY_STILL_MODE		10
+#define VID_PLAY_MASTER_MODE		11
+	/* p1: see below */
+#define		VID_PLAY_MASTER_NONE	1
+#define		VID_PLAY_MASTER_VIDEO	2
+#define		VID_PLAY_MASTER_AUDIO	3
+#define VID_PLAY_ACTIVE_SCANLINES	12
+	/* p1 = first active; p2 = last active */
+#define VID_PLAY_RESET			13
+#define VID_PLAY_END_MARK		14
+
+#endif /* __LINUX_VIDEODEV_H */
+
+/*
+ * Local variables:
+ * c-basic-offset: 8
+ * End:
+ */
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 410ed18..3af13c2 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -43,7 +43,7 @@
 #include <linux/tty.h>
 #include <linux/vt_kern.h>
 #include <linux/fb.h>
-#include <linux/videodev.h>
+#include <linux/videodev2.h>
 #include <linux/netdevice.h>
 #include <linux/raw.h>
 #include <linux/blkdev.h>
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 97319a8..a354c19 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -367,7 +367,6 @@ header-y += utime.h
 header-y += utsname.h
 header-y += veth.h
 header-y += vhost.h
-header-y += videodev.h
 header-y += videodev2.h
 header-y += virtio_9p.h
 header-y += virtio_balloon.h
diff --git a/include/linux/videodev.h b/include/linux/videodev.h
deleted file mode 100644
index f11efbe..0000000
--- a/include/linux/videodev.h
+++ /dev/null
@@ -1,318 +0,0 @@
-/*
- *	Video for Linux version 1 - OBSOLETE
- *
- *	Header file for v4l1 drivers and applications, for
- *	Linux kernels 2.2.x or 2.4.x.
- *
- *	Provides header for legacy drivers and applications
- *
- *	See http://linuxtv.org for more info
- *
- */
-#ifndef __LINUX_VIDEODEV_H
-#define __LINUX_VIDEODEV_H
-
-#include <linux/types.h>
-#include <linux/ioctl.h>
-#include <linux/videodev2.h>
-
-#define VID_TYPE_CAPTURE	1	/* Can capture */
-#define VID_TYPE_TUNER		2	/* Can tune */
-#define VID_TYPE_TELETEXT	4	/* Does teletext */
-#define VID_TYPE_OVERLAY	8	/* Overlay onto frame buffer */
-#define VID_TYPE_CHROMAKEY	16	/* Overlay by chromakey */
-#define VID_TYPE_CLIPPING	32	/* Can clip */
-#define VID_TYPE_FRAMERAM	64	/* Uses the frame buffer memory */
-#define VID_TYPE_SCALES		128	/* Scalable */
-#define VID_TYPE_MONOCHROME	256	/* Monochrome only */
-#define VID_TYPE_SUBCAPTURE	512	/* Can capture subareas of the image */
-#define VID_TYPE_MPEG_DECODER	1024	/* Can decode MPEG streams */
-#define VID_TYPE_MPEG_ENCODER	2048	/* Can encode MPEG streams */
-#define VID_TYPE_MJPEG_DECODER	4096	/* Can decode MJPEG streams */
-#define VID_TYPE_MJPEG_ENCODER	8192	/* Can encode MJPEG streams */
-
-struct video_capability
-{
-	char name[32];
-	int type;
-	int channels;	/* Num channels */
-	int audios;	/* Num audio devices */
-	int maxwidth;	/* Supported width */
-	int maxheight;	/* And height */
-	int minwidth;	/* Supported width */
-	int minheight;	/* And height */
-};
-
-
-struct video_channel
-{
-	int channel;
-	char name[32];
-	int tuners;
-	__u32  flags;
-#define VIDEO_VC_TUNER		1	/* Channel has a tuner */
-#define VIDEO_VC_AUDIO		2	/* Channel has audio */
-	__u16  type;
-#define VIDEO_TYPE_TV		1
-#define VIDEO_TYPE_CAMERA	2
-	__u16 norm;			/* Norm set by channel */
-};
-
-struct video_tuner
-{
-	int tuner;
-	char name[32];
-	unsigned long rangelow, rangehigh;	/* Tuner range */
-	__u32 flags;
-#define VIDEO_TUNER_PAL		1
-#define VIDEO_TUNER_NTSC	2
-#define VIDEO_TUNER_SECAM	4
-#define VIDEO_TUNER_LOW		8	/* Uses KHz not MHz */
-#define VIDEO_TUNER_NORM	16	/* Tuner can set norm */
-#define VIDEO_TUNER_STEREO_ON	128	/* Tuner is seeing stereo */
-#define VIDEO_TUNER_RDS_ON      256     /* Tuner is seeing an RDS datastream */
-#define VIDEO_TUNER_MBS_ON      512     /* Tuner is seeing an MBS datastream */
-	__u16 mode;			/* PAL/NTSC/SECAM/OTHER */
-#define VIDEO_MODE_PAL		0
-#define VIDEO_MODE_NTSC		1
-#define VIDEO_MODE_SECAM	2
-#define VIDEO_MODE_AUTO		3
-	__u16 signal;			/* Signal strength 16bit scale */
-};
-
-struct video_picture
-{
-	__u16	brightness;
-	__u16	hue;
-	__u16	colour;
-	__u16	contrast;
-	__u16	whiteness;	/* Black and white only */
-	__u16	depth;		/* Capture depth */
-	__u16   palette;	/* Palette in use */
-#define VIDEO_PALETTE_GREY	1	/* Linear greyscale */
-#define VIDEO_PALETTE_HI240	2	/* High 240 cube (BT848) */
-#define VIDEO_PALETTE_RGB565	3	/* 565 16 bit RGB */
-#define VIDEO_PALETTE_RGB24	4	/* 24bit RGB */
-#define VIDEO_PALETTE_RGB32	5	/* 32bit RGB */
-#define VIDEO_PALETTE_RGB555	6	/* 555 15bit RGB */
-#define VIDEO_PALETTE_YUV422	7	/* YUV422 capture */
-#define VIDEO_PALETTE_YUYV	8
-#define VIDEO_PALETTE_UYVY	9	/* The great thing about standards is ... */
-#define VIDEO_PALETTE_YUV420	10
-#define VIDEO_PALETTE_YUV411	11	/* YUV411 capture */
-#define VIDEO_PALETTE_RAW	12	/* RAW capture (BT848) */
-#define VIDEO_PALETTE_YUV422P	13	/* YUV 4:2:2 Planar */
-#define VIDEO_PALETTE_YUV411P	14	/* YUV 4:1:1 Planar */
-#define VIDEO_PALETTE_YUV420P	15	/* YUV 4:2:0 Planar */
-#define VIDEO_PALETTE_YUV410P	16	/* YUV 4:1:0 Planar */
-#define VIDEO_PALETTE_PLANAR	13	/* start of planar entries */
-#define VIDEO_PALETTE_COMPONENT 7	/* start of component entries */
-};
-
-struct video_audio
-{
-	int	audio;		/* Audio channel */
-	__u16	volume;		/* If settable */
-	__u16	bass, treble;
-	__u32	flags;
-#define VIDEO_AUDIO_MUTE	1
-#define VIDEO_AUDIO_MUTABLE	2
-#define VIDEO_AUDIO_VOLUME	4
-#define VIDEO_AUDIO_BASS	8
-#define VIDEO_AUDIO_TREBLE	16
-#define VIDEO_AUDIO_BALANCE	32
-	char    name[16];
-#define VIDEO_SOUND_MONO	1
-#define VIDEO_SOUND_STEREO	2
-#define VIDEO_SOUND_LANG1	4
-#define VIDEO_SOUND_LANG2	8
-	__u16   mode;
-	__u16	balance;	/* Stereo balance */
-	__u16	step;		/* Step actual volume uses */
-};
-
-struct video_clip
-{
-	__s32	x,y;
-	__s32	width, height;
-	struct	video_clip *next;	/* For user use/driver use only */
-};
-
-struct video_window
-{
-	__u32	x,y;			/* Position of window */
-	__u32	width,height;		/* Its size */
-	__u32	chromakey;
-	__u32	flags;
-	struct	video_clip __user *clips;	/* Set only */
-	int	clipcount;
-#define VIDEO_WINDOW_INTERLACE	1
-#define VIDEO_WINDOW_CHROMAKEY	16	/* Overlay by chromakey */
-#define VIDEO_CLIP_BITMAP	-1
-/* bitmap is 1024x625, a '1' bit represents a clipped pixel */
-#define VIDEO_CLIPMAP_SIZE	(128 * 625)
-};
-
-struct video_capture
-{
-	__u32 	x,y;			/* Offsets into image */
-	__u32	width, height;		/* Area to capture */
-	__u16	decimation;		/* Decimation divider */
-	__u16	flags;			/* Flags for capture */
-#define VIDEO_CAPTURE_ODD		0	/* Temporal */
-#define VIDEO_CAPTURE_EVEN		1
-};
-
-struct video_buffer
-{
-	void	*base;
-	int	height,width;
-	int	depth;
-	int	bytesperline;
-};
-
-struct video_mmap
-{
-	unsigned	int frame;		/* Frame (0 - n) for double buffer */
-	int		height,width;
-	unsigned	int format;		/* should be VIDEO_PALETTE_* */
-};
-
-struct video_key
-{
-	__u8	key[8];
-	__u32	flags;
-};
-
-struct video_mbuf
-{
-	int	size;		/* Total memory to map */
-	int	frames;		/* Frames */
-	int	offsets[VIDEO_MAX_FRAME];
-};
-
-#define 	VIDEO_NO_UNIT	(-1)
-
-struct video_unit
-{
-	int 	video;		/* Video minor */
-	int	vbi;		/* VBI minor */
-	int	radio;		/* Radio minor */
-	int	audio;		/* Audio minor */
-	int	teletext;	/* Teletext minor */
-};
-
-struct vbi_format {
-	__u32	sampling_rate;	/* in Hz */
-	__u32	samples_per_line;
-	__u32	sample_format;	/* VIDEO_PALETTE_RAW only (1 byte) */
-	__s32	start[2];	/* starting line for each frame */
-	__u32	count[2];	/* count of lines for each frame */
-	__u32	flags;
-#define	VBI_UNSYNC	1	/* can distingues between top/bottom field */
-#define	VBI_INTERLACED	2	/* lines are interlaced */
-};
-
-/* video_info is biased towards hardware mpeg encode/decode */
-/* but it could apply generically to any hardware compressor/decompressor */
-struct video_info
-{
-	__u32	frame_count;	/* frames output since decode/encode began */
-	__u32	h_size;		/* current unscaled horizontal size */
-	__u32	v_size;		/* current unscaled veritcal size */
-	__u32	smpte_timecode;	/* current SMPTE timecode (for current GOP) */
-	__u32	picture_type;	/* current picture type */
-	__u32	temporal_reference;	/* current temporal reference */
-	__u8	user_data[256];	/* user data last found in compressed stream */
-	/* user_data[0] contains user data flags, user_data[1] has count */
-};
-
-/* generic structure for setting playback modes */
-struct video_play_mode
-{
-	int	mode;
-	int	p1;
-	int	p2;
-};
-
-/* for loading microcode / fpga programming */
-struct video_code
-{
-	char	loadwhat[16];	/* name or tag of file being passed */
-	int	datasize;
-	__u8	*data;
-};
-
-#define VIDIOCGCAP		_IOR('v',1,struct video_capability)	/* Get capabilities */
-#define VIDIOCGCHAN		_IOWR('v',2,struct video_channel)	/* Get channel info (sources) */
-#define VIDIOCSCHAN		_IOW('v',3,struct video_channel)	/* Set channel 	*/
-#define VIDIOCGTUNER		_IOWR('v',4,struct video_tuner)		/* Get tuner abilities */
-#define VIDIOCSTUNER		_IOW('v',5,struct video_tuner)		/* Tune the tuner for the current channel */
-#define VIDIOCGPICT		_IOR('v',6,struct video_picture)	/* Get picture properties */
-#define VIDIOCSPICT		_IOW('v',7,struct video_picture)	/* Set picture properties */
-#define VIDIOCCAPTURE		_IOW('v',8,int)				/* Start, end capture */
-#define VIDIOCGWIN		_IOR('v',9, struct video_window)	/* Get the video overlay window */
-#define VIDIOCSWIN		_IOW('v',10, struct video_window)	/* Set the video overlay window - passes clip list for hardware smarts , chromakey etc */
-#define VIDIOCGFBUF		_IOR('v',11, struct video_buffer)	/* Get frame buffer */
-#define VIDIOCSFBUF		_IOW('v',12, struct video_buffer)	/* Set frame buffer - root only */
-#define VIDIOCKEY		_IOR('v',13, struct video_key)		/* Video key event - to dev 255 is to all - cuts capture on all DMA windows with this key (0xFFFFFFFF == all) */
-#define VIDIOCGFREQ		_IOR('v',14, unsigned long)		/* Set tuner */
-#define VIDIOCSFREQ		_IOW('v',15, unsigned long)		/* Set tuner */
-#define VIDIOCGAUDIO		_IOR('v',16, struct video_audio)	/* Get audio info */
-#define VIDIOCSAUDIO		_IOW('v',17, struct video_audio)	/* Audio source, mute etc */
-#define VIDIOCSYNC		_IOW('v',18, int)			/* Sync with mmap grabbing */
-#define VIDIOCMCAPTURE		_IOW('v',19, struct video_mmap)		/* Grab frames */
-#define VIDIOCGMBUF		_IOR('v',20, struct video_mbuf)		/* Memory map buffer info */
-#define VIDIOCGUNIT		_IOR('v',21, struct video_unit)		/* Get attached units */
-#define VIDIOCGCAPTURE		_IOR('v',22, struct video_capture)	/* Get subcapture */
-#define VIDIOCSCAPTURE		_IOW('v',23, struct video_capture)	/* Set subcapture */
-#define VIDIOCSPLAYMODE		_IOW('v',24, struct video_play_mode)	/* Set output video mode/feature */
-#define VIDIOCSWRITEMODE	_IOW('v',25, int)			/* Set write mode */
-#define VIDIOCGPLAYINFO		_IOR('v',26, struct video_info)		/* Get current playback info from hardware */
-#define VIDIOCSMICROCODE	_IOW('v',27, struct video_code)		/* Load microcode into hardware */
-#define	VIDIOCGVBIFMT		_IOR('v',28, struct vbi_format)		/* Get VBI information */
-#define	VIDIOCSVBIFMT		_IOW('v',29, struct vbi_format)		/* Set VBI information */
-
-
-#define BASE_VIDIOCPRIVATE	192		/* 192-255 are private */
-
-/* VIDIOCSWRITEMODE */
-#define VID_WRITE_MPEG_AUD		0
-#define VID_WRITE_MPEG_VID		1
-#define VID_WRITE_OSD			2
-#define VID_WRITE_TTX			3
-#define VID_WRITE_CC			4
-#define VID_WRITE_MJPEG			5
-
-/* VIDIOCSPLAYMODE */
-#define VID_PLAY_VID_OUT_MODE		0
-	/* p1: = VIDEO_MODE_PAL, VIDEO_MODE_NTSC, etc ... */
-#define VID_PLAY_GENLOCK		1
-	/* p1: 0 = OFF, 1 = ON */
-	/* p2: GENLOCK FINE DELAY value */
-#define VID_PLAY_NORMAL			2
-#define VID_PLAY_PAUSE			3
-#define VID_PLAY_SINGLE_FRAME		4
-#define VID_PLAY_FAST_FORWARD		5
-#define VID_PLAY_SLOW_MOTION		6
-#define VID_PLAY_IMMEDIATE_NORMAL	7
-#define VID_PLAY_SWITCH_CHANNELS	8
-#define VID_PLAY_FREEZE_FRAME		9
-#define VID_PLAY_STILL_MODE		10
-#define VID_PLAY_MASTER_MODE		11
-	/* p1: see below */
-#define		VID_PLAY_MASTER_NONE	1
-#define		VID_PLAY_MASTER_VIDEO	2
-#define		VID_PLAY_MASTER_AUDIO	3
-#define VID_PLAY_ACTIVE_SCANLINES	12
-	/* p1 = first active; p2 = last active */
-#define VID_PLAY_RESET			13
-#define VID_PLAY_END_MARK		14
-
-#endif /* __LINUX_VIDEODEV_H */
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/include/media/ovcamchip.h b/include/media/ovcamchip.h
deleted file mode 100644
index 05b9569..0000000
--- a/include/media/ovcamchip.h
+++ /dev/null
@@ -1,90 +0,0 @@
-/* OmniVision* camera chip driver API
- *
- * Copyright (c) 1999-2004 Mark McClelland
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2 of the License, or (at your
- * option) any later version. NO WARRANTY OF ANY KIND is expressed or implied.
- *
- * * OmniVision is a trademark of OmniVision Technologies, Inc. This driver
- * is not sponsored or developed by them.
- */
-
-#ifndef __LINUX_OVCAMCHIP_H
-#define __LINUX_OVCAMCHIP_H
-
-#include <linux/videodev.h>
-#include <media/v4l2-common.h>
-
-/* --------------------------------- */
-/*           ENUMERATIONS            */
-/* --------------------------------- */
-
-/* Controls */
-enum {
-	OVCAMCHIP_CID_CONT,		/* Contrast */
-	OVCAMCHIP_CID_BRIGHT,		/* Brightness */
-	OVCAMCHIP_CID_SAT,		/* Saturation */
-	OVCAMCHIP_CID_HUE,		/* Hue */
-	OVCAMCHIP_CID_EXP,		/* Exposure */
-	OVCAMCHIP_CID_FREQ,		/* Light frequency */
-	OVCAMCHIP_CID_BANDFILT,		/* Banding filter */
-	OVCAMCHIP_CID_AUTOBRIGHT,	/* Auto brightness */
-	OVCAMCHIP_CID_AUTOEXP,		/* Auto exposure */
-	OVCAMCHIP_CID_BACKLIGHT,	/* Back light compensation */
-	OVCAMCHIP_CID_MIRROR,		/* Mirror horizontally */
-};
-
-/* Chip types */
-#define NUM_CC_TYPES	9
-enum {
-	CC_UNKNOWN,
-	CC_OV76BE,
-	CC_OV7610,
-	CC_OV7620,
-	CC_OV7620AE,
-	CC_OV6620,
-	CC_OV6630,
-	CC_OV6630AE,
-	CC_OV6630AF,
-};
-
-/* --------------------------------- */
-/*           I2C ADDRESSES           */
-/* --------------------------------- */
-
-#define OV7xx0_SID   (0x42 >> 1)
-#define OV6xx0_SID   (0xC0 >> 1)
-
-/* --------------------------------- */
-/*                API                */
-/* --------------------------------- */
-
-struct ovcamchip_control {
-	__u32 id;
-	__s32 value;
-};
-
-struct ovcamchip_window {
-	int x;
-	int y;
-	int width;
-	int height;
-	int format;
-	int quarter;		/* Scale width and height down 2x */
-
-	/* This stuff will be removed eventually */
-	int clockdiv;		/* Clock divisor setting */
-};
-
-/* Commands */
-#define OVCAMCHIP_CMD_Q_SUBTYPE     _IOR  (0x88, 0x00, int)
-#define OVCAMCHIP_CMD_INITIALIZE    _IOW  (0x88, 0x01, int)
-/* You must call OVCAMCHIP_CMD_INITIALIZE before any of commands below! */
-#define OVCAMCHIP_CMD_S_CTRL        _IOW  (0x88, 0x02, struct ovcamchip_control)
-#define OVCAMCHIP_CMD_G_CTRL        _IOWR (0x88, 0x03, struct ovcamchip_control)
-#define OVCAMCHIP_CMD_S_MODE        _IOW  (0x88, 0x04, struct ovcamchip_window)
-#define OVCAMCHIP_MAX_CMD           _IO   (0x88, 0x3f)
-
-#endif
-- 
1.7.3.4


