Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-5.mail.uk.tiscali.com ([212.74.114.1]:9540
	"EHLO mk-outboundfilter-5.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754488AbZCOWet (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 18:34:49 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: linux-media@vger.kernel.org
Subject: [RFC][PATCH 2/2] Sensor orientation reporting
Date: Sun, 15 Mar 2009 22:34:45 +0000
Cc: kilgota@banach.math.auburn.edu,
	Hans de Goede <j.w.r.degoede@hhs.nl>,
	"Jean-Francois Moine" <moinejf@free.fr>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <200903152224.29388.linux@baker-net.org.uk>
In-Reply-To: <200903152224.29388.linux@baker-net.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903152234.46045.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add check to libv4l of the sensor orientation as reported by
VIDIOC_ENUMINPUT

Signed-off-by: Adam Baker <linux@baker-net.org.uk>

---
diff -r a647c2dfa989 v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert.c
--- a/v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert.c	Tue Jan 20 11:25:54 
2009 +0100
+++ b/v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert.c	Sun Mar 15 22:34:00 
2009 +0000
@@ -28,6 +28,11 @@
 
 #define MIN(a,b) (((a)<(b))?(a):(b))
 #define ARRAY_SIZE(x) ((int)sizeof(x)/(int)sizeof((x)[0]))
+
+/* Workaround this potentially being missing from videodev2.h */
+#ifndef V4L2_IN_ST_VFLIP
+#define V4L2_IN_ST_VFLIP       0x00000020 /* Output is flipped vertically */
+#endif
 
 /* Note for proper functioning of v4lconvert_enum_fmt the first entries in
   supported_src_pixfmts must match with the entries in supported_dst_pixfmts 
*/
@@ -134,6 +139,7 @@ struct v4lconvert_data *v4lconvert_creat
   int i, j;
   struct v4lconvert_data *data = calloc(1, sizeof(struct v4lconvert_data));
   struct v4l2_capability cap;
+  struct v4l2_input input;
 
   if (!data)
     return NULL;
@@ -161,6 +167,13 @@ struct v4lconvert_data *v4lconvert_creat
 
   /* Check if this cam has any special flags */
   data->flags = v4lconvert_get_flags(data->fd);
+  if ((syscall(SYS_ioctl, fd, VIDIOC_G_INPUT, &input.index) == 0) &&
+      (syscall(SYS_ioctl, fd, VIDIOC_ENUMINPUT, &input) == 0)) {
+    /* Don't yet support independent HFLIP and VFLIP so getting
+     * image the right way up is highest priority. */
+    if (input.status & V4L2_IN_ST_VFLIP)
+      data->flags |= V4LCONVERT_ROTATE_180;
+  }
   if (syscall(SYS_ioctl, fd, VIDIOC_QUERYCAP, &cap) == 0) {
     if (!strcmp((char *)cap.driver, "uvcvideo"))
       data->flags |= V4LCONVERT_IS_UVC;

