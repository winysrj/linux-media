Return-path: <linux-media-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:52306
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933842Ab2JYPCz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 11:02:55 -0400
From: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
To: "Laurent Pinchart <laurent.pinchart@ideasonboard.com>
	(laurent.pinchart@ideasonboard.com)"
	<laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] Rotate the videout via V4L2_CID_ROTATE based on
 fb_var_screeninfo.rotate
Date: Thu, 25 Oct 2012 15:02:46 +0000
Message-ID: <6EE9CD707FBED24483D4CB0162E8546710079A2F@AM2PRD0710MB375.eurprd07.prod.outlook.com>
Content-Language: de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent

You are very fast on implementing new features in omap3-isp-live. I appreciate much the new panning-feature - thank you!
On my beagleboard I use omap-vout with vrfb-rotation. As I already configured omapfb to rotate the screen upon start (kernel-argument omapfb.rotate), I thought it might be useful to rotate omap-vout accordingly in your application. This is what the following patch does.
The patch is a diff against your latest commit 619164a994c8d878249d6c1b8b16c27074a04209.

I hope it is useful.
Greetings,
Florian

diff -rupN '--exclude=.git' omap3-isp-live/live.c omap3-isp-live-voisee/live.c
--- omap3-isp-live/live.c	2012-10-24 18:14:58.830555741 +0200
+++ omap3-isp-live-voisee/live.c	2012-10-24 22:28:49.278056954 +0200
@@ -661,7 +674,36 @@ struct color_rgb24 {
 	unsigned int value:24;
 } __attribute__((__packed__));
 
-static int fb_init(struct v4l2_rect *rect)
+/*
+ * Convert DSS rotation to V4L2 rotation
+ *      V4L2 understand 0, 90, 180, 270 degrees.
+ */
+static int dss_rot_to_v4l2_rot(int dss_rotation,
+                        int *v4l2_rotation)
+{
+        int ret = 0;
+
+        switch (dss_rotation) {
+        case 1:
+                *v4l2_rotation = 90;
+                break;
+        case 2:
+                *v4l2_rotation = 180;
+                break;
+        case 3:
+                *v4l2_rotation = 270;
+                break;
+        case 0:
+                *v4l2_rotation = 0;
+                break;
+        default:
+                ret = -EINVAL;
+                break;
+        }
+        return ret;
+}
+
+static int fb_init(struct v4l2_rect *rect, int *rotation)
 {
 	struct color_24bpp ;
 
@@ -745,6 +787,8 @@ static int fb_init(struct v4l2_rect *rec
 	rect->width = var.xres;
 	rect->height = var.yres;
 
+	/* Return the rotation (if any) in degrees */
+	dss_rot_to_v4l2_rot(var.rotate, rotation);
 done:
 	if (mem != NULL)
 		munmap(mem, fix.smem_len);
@@ -812,6 +858,7 @@ int main(int argc __attribute__((__unuse
 	unsigned int colorkey;
 	bool enable_aewb = true;
 	float fps;
+	int rotation;
 	int ret;
 	int c;
 
@@ -851,10 +898,10 @@ int main(int argc __attribute__((__unuse
 	}
 
 	events_init(&events);
 	input_init(&input);
 
 	memset(&rect, 0, sizeof rect);
-	ret = fb_init(&rect);
+	ret = fb_init(&rect, &rotation);
 	if (ret < 0) {
 		printf("error: unable to initialize frame buffer\n");
 		goto cleanup;
@@ -879,7 +929,7 @@ int main(int argc __attribute__((__unuse
 	format.pixelformat = V4L2_PIX_FMT_YUYV;
 	format.width = rect.width;
 	format.height = rect.height;
-	vo = vo_init(vo_devname, &vo_ops, buffers, &format);
+	vo = vo_init(vo_devname, &vo_ops, buffers, &format, rotation);
 	if (vo == NULL) {
 		printf("error: unable to initialize video output\n");
 		goto cleanup;

diff -rupN '--exclude=.git' omap3-isp-live/snapshot.c omap3-isp-live-voisee/snapshot.c
--- omap3-isp-live/snapshot.c	2012-10-24 18:14:58.830555741 +0200
+++ omap3-isp-live-voisee/snapshot.c	2012-10-24 22:28:49.274057063 +0200
@@ -45,6 +45,7 @@
 #if USE_LIBJPEG
 #include <jpeglib.h>
 #include <setjmp.h>
+#include "jpeg.h"
 #endif
 
 #include "isp/list.h"
@@ -55,7 +56,6 @@
 
 #include "events.h"
 #include "iq.h"
-#include "jpeg.h"
 
 #define MEDIA_DEVICE		"/dev/media0"

diff -rupN '--exclude=.git' omap3-isp-live/videoout.c omap3-isp-live-voisee/videoout.c
--- omap3-isp-live/videoout.c	2012-09-28 14:43:53.978198906 +0200
+++ omap3-isp-live-voisee/videoout.c	2012-10-24 22:28:49.278056954 +0200
@@ -54,7 +54,8 @@ struct videoout
 struct videoout *vo_init(const char *devname,
 			 const struct video_out_operations *ops,
 			 unsigned int buffers,
-			 struct v4l2_pix_format *format)
+			 struct v4l2_pix_format *format,
+			 int rotation)
 {
 	struct v4l2_pix_format pixfmt;
 	struct v4l2_format fmt;
@@ -76,6 +77,14 @@ struct videoout *vo_init(const char *dev
 		goto error;
 	}
 
+	/* setup the rotation here, we have to do it BEFORE
+	 * setting the format. */
+	ret = v4l2_set_control(vo->dev, V4L2_CID_ROTATE, &rotation);
+	if (ret < 0){
+		perror("Failed to setup rotation\n");
+		goto error;
+	}
+
 	pixfmt.pixelformat = format->pixelformat;
 	pixfmt.width = format->width;
 	pixfmt.height = format->height;
diff -rupN '--exclude=.git' omap3-isp-live/videoout.h omap3-isp-live-voisee/videoout.h
--- omap3-isp-live/videoout.h	2012-09-28 14:43:53.978198906 +0200
+++ omap3-isp-live-voisee/videoout.h	2012-10-24 22:28:49.274057063 +0200
@@ -34,10 +34,13 @@ struct video_out_operations {
 	void (*unwatch_fd)(int fd);
 };
 
+int vo_set_rotation(struct videoout *vo, int rotation);
+
 struct videoout *vo_init(const char *devname,
 			 const struct video_out_operations *ops,
 			 unsigned int buffers,
-			 struct v4l2_pix_format *format);
+			 struct v4l2_pix_format *format,
+			 int rotation);
 void vo_cleanup(struct videoout *vo);
 
 int vo_enable_colorkey(struct videoout *vo, unsigned int val);

