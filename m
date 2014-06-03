Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44656 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbaFCAoa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jun 2014 20:44:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/2] Use installed kernel headers instead of raw kernel headers
Date: Tue,  3 Jun 2014 02:44:51 +0200
Message-Id: <1401756292-27676-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1401756292-27676-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1401756292-27676-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kernel headers exported to userspace can contain kernel-specific
statements (such as __user annotations) that are removed when installing
the headers with 'make headers_install' in the kernel sources. Only the
installed headers must be used by userspace. Replace the private copy of
the raw headers with installed headers.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/linux/dvb/dmx.h      |  8 +++-----
 include/linux/dvb/frontend.h |  4 ----
 include/linux/dvb/video.h    | 12 +++++-------
 include/linux/fb.h           |  8 +++-----
 include/linux/ivtv.h         |  6 +++---
 include/linux/videodev2.h    | 16 +++++++---------
 6 files changed, 21 insertions(+), 33 deletions(-)

diff --git a/include/linux/dvb/dmx.h b/include/linux/dvb/dmx.h
index b4fb650..4ed210a 100644
--- a/include/linux/dvb/dmx.h
+++ b/include/linux/dvb/dmx.h
@@ -21,13 +21,11 @@
  *
  */
 
-#ifndef _UAPI_DVBDMX_H_
-#define _UAPI_DVBDMX_H_
+#ifndef _DVBDMX_H_
+#define _DVBDMX_H_
 
 #include <linux/types.h>
-#ifndef __KERNEL__
 #include <time.h>
-#endif
 
 
 #define DMX_FILTER_SIZE 16
@@ -152,4 +150,4 @@ struct dmx_stc {
 #define DMX_ADD_PID              _IOW('o', 51, __u16)
 #define DMX_REMOVE_PID           _IOW('o', 52, __u16)
 
-#endif /* _UAPI_DVBDMX_H_ */
+#endif /* _DVBDMX_H_ */
diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
index c56d77c..5cb498d 100644
--- a/include/linux/dvb/frontend.h
+++ b/include/linux/dvb/frontend.h
@@ -197,7 +197,6 @@ typedef enum fe_transmit_mode {
 	TRANSMISSION_MODE_C3780,
 } fe_transmit_mode_t;
 
-#if defined(__DVB_CORE__) || !defined (__KERNEL__)
 typedef enum fe_bandwidth {
 	BANDWIDTH_8_MHZ,
 	BANDWIDTH_7_MHZ,
@@ -207,7 +206,6 @@ typedef enum fe_bandwidth {
 	BANDWIDTH_10_MHZ,
 	BANDWIDTH_1_712_MHZ,
 } fe_bandwidth_t;
-#endif
 
 typedef enum fe_guard_interval {
 	GUARD_INTERVAL_1_32,
@@ -239,7 +237,6 @@ enum fe_interleaving {
 	INTERLEAVING_720,
 };
 
-#if defined(__DVB_CORE__) || !defined (__KERNEL__)
 struct dvb_qpsk_parameters {
 	__u32		symbol_rate;  /* symbol rate in Symbols per second */
 	fe_code_rate_t	fec_inner;    /* forward error correction (see above) */
@@ -282,7 +279,6 @@ struct dvb_frontend_event {
 	fe_status_t status;
 	struct dvb_frontend_parameters parameters;
 };
-#endif
 
 /* S2API Commands */
 #define DTV_UNDEFINED		0
diff --git a/include/linux/dvb/video.h b/include/linux/dvb/video.h
index d3d14a5..4bb276c 100644
--- a/include/linux/dvb/video.h
+++ b/include/linux/dvb/video.h
@@ -21,14 +21,12 @@
  *
  */
 
-#ifndef _UAPI_DVBVIDEO_H_
-#define _UAPI_DVBVIDEO_H_
+#ifndef _DVBVIDEO_H_
+#define _DVBVIDEO_H_
 
 #include <linux/types.h>
-#ifndef __KERNEL__
 #include <stdint.h>
 #include <time.h>
-#endif
 
 typedef enum {
 	VIDEO_FORMAT_4_3,     /* Select 4:3 format */
@@ -154,7 +152,7 @@ struct video_status {
 
 
 struct video_still_picture {
-	char __user *iFrame;        /* pointer to a single iframe in memory */
+	char *iFrame;        /* pointer to a single iframe in memory */
 	__s32 size;
 };
 
@@ -187,7 +185,7 @@ typedef struct video_spu {
 
 typedef struct video_spu_palette {      /* SPU Palette information */
 	int length;
-	__u8 __user *palette;
+	__u8 *palette;
 } video_spu_palette_t;
 
 
@@ -271,4 +269,4 @@ typedef __u16 video_attributes_t;
 #define VIDEO_COMMAND     	   _IOWR('o', 59, struct video_command)
 #define VIDEO_TRY_COMMAND 	   _IOWR('o', 60, struct video_command)
 
-#endif /* _UAPI_DVBVIDEO_H_ */
+#endif /* _DVBVIDEO_H_ */
diff --git a/include/linux/fb.h b/include/linux/fb.h
index fb795c3..1b3b239 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -1,5 +1,5 @@
-#ifndef _UAPI_LINUX_FB_H
-#define _UAPI_LINUX_FB_H
+#ifndef _LINUX_FB_H
+#define _LINUX_FB_H
 
 #include <linux/types.h>
 #include <linux/i2c.h>
@@ -16,9 +16,7 @@
 #define FBIOGETCMAP		0x4604
 #define FBIOPUTCMAP		0x4605
 #define FBIOPAN_DISPLAY		0x4606
-#ifndef __KERNEL__
 #define FBIO_CURSOR            _IOWR('F', 0x08, struct fb_cursor)
-#endif
 /* 0x4607-0x460B are defined below */
 /* #define FBIOGET_MONITORSPEC	0x460C */
 /* #define FBIOPUT_MONITORSPEC	0x460D */
@@ -399,4 +397,4 @@ struct fb_cursor {
 #endif
 
 
-#endif /* _UAPI_LINUX_FB_H */
+#endif /* _LINUX_FB_H */
diff --git a/include/linux/ivtv.h b/include/linux/ivtv.h
index 42bf725..120e82c 100644
--- a/include/linux/ivtv.h
+++ b/include/linux/ivtv.h
@@ -21,7 +21,7 @@
 #ifndef __LINUX_IVTV_H__
 #define __LINUX_IVTV_H__
 
-#include <linux/compiler.h>
+
 #include <linux/types.h>
 #include <linux/videodev2.h>
 
@@ -49,9 +49,9 @@
 struct ivtv_dma_frame {
 	enum v4l2_buf_type type; /* V4L2_BUF_TYPE_VIDEO_OUTPUT */
 	__u32 pixelformat;	 /* 0 == same as destination */
-	void __user *y_source;   /* if NULL and type == V4L2_BUF_TYPE_VIDEO_OUTPUT,
+	void *y_source;   /* if NULL and type == V4L2_BUF_TYPE_VIDEO_OUTPUT,
 				    then just switch to user DMA YUV output mode */
-	void __user *uv_source;  /* Unused for RGB pixelformats */
+	void *uv_source;  /* Unused for RGB pixelformats */
 	struct v4l2_rect src;
 	struct v4l2_rect dst;
 	__u32 src_width;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 168ff50..e9a5547 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -53,13 +53,11 @@
  *              Hans Verkuil <hverkuil@xs4all.nl>
  *		et al.
  */
-#ifndef _UAPI__LINUX_VIDEODEV2_H
-#define _UAPI__LINUX_VIDEODEV2_H
+#ifndef __LINUX_VIDEODEV2_H
+#define __LINUX_VIDEODEV2_H
 
-#ifndef __KERNEL__
 #include <sys/time.h>
-#endif
-#include <linux/compiler.h>
+
 #include <linux/ioctl.h>
 #include <linux/types.h>
 #include <linux/v4l2-common.h>
@@ -766,16 +764,16 @@ struct v4l2_framebuffer {
 
 struct v4l2_clip {
 	struct v4l2_rect        c;
-	struct v4l2_clip	__user *next;
+	struct v4l2_clip	*next;
 };
 
 struct v4l2_window {
 	struct v4l2_rect        w;
 	__u32			field;	 /* enum v4l2_field */
 	__u32			chromakey;
-	struct v4l2_clip	__user *clips;
+	struct v4l2_clip	*clips;
 	__u32			clipcount;
-	void			__user *bitmap;
+	void			*bitmap;
 	__u8                    global_alpha;
 };
 
@@ -2010,4 +2008,4 @@ struct v4l2_create_buffers {
 
 #define BASE_VIDIOC_PRIVATE	192		/* 192-255 are private */
 
-#endif /* _UAPI__LINUX_VIDEODEV2_H */
+#endif /* __LINUX_VIDEODEV2_H */
-- 
1.8.5.5

