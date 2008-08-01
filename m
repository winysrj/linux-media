Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m71Il8e3020871
	for <video4linux-list@redhat.com>; Fri, 1 Aug 2008 14:47:08 -0400
Received: from smtp6-g19.free.fr (smtp6-g19.free.fr [212.27.42.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m71IkvCh007340
	for <video4linux-list@redhat.com>; Fri, 1 Aug 2008 14:46:57 -0400
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-1
Date: Fri, 01 Aug 2008 20:09:03 +0200
Message-Id: <1217614143.1686.12.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Video 4 Linux <video4linux-list@redhat.com>
Subject: [PATCH] libv4l decoding to rgb24
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

The RGB24 pixel format is often used in X11 applications.
This patch adds it to the V4L library.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>

--

diff -r cfa0097c9e85 v4l2-apps/lib/libv4l/libv4lconvert/bayer.c
--- a/v4l2-apps/lib/libv4l/libv4lconvert/bayer.c	Fri Aug 01 18:23:15 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4lconvert/bayer.c	Fri Aug 01 19:57:00 2008 +0200
@@ -163,14 +163,10 @@
 }
 
 /* From libdc1394, which on turn was based on OpenCV's Bayer decoding */
-void v4lconvert_bayer_to_bgr24(const unsigned char *bayer,
-  unsigned char *bgr, int width, int height, unsigned int pixfmt)
+static void bayer_to_rgbbgr24(const unsigned char *bayer,
+  unsigned char *bgr, int width, int height, unsigned int pixfmt,
+	int start_with_green, int blue_line)
 {
-    int blue_line = pixfmt == V4L2_PIX_FMT_SBGGR8
-	|| pixfmt == V4L2_PIX_FMT_SGBRG8;
-    int start_with_green = pixfmt == V4L2_PIX_FMT_SGBRG8
-	|| pixfmt == V4L2_PIX_FMT_SGRBG8;
-
     /* render the first line */
     v4lconvert_border_bayer_line_to_bgr24(bayer, bayer + width, bgr, width,
       start_with_green, blue_line);
@@ -315,6 +311,26 @@
     /* render the last line */
     v4lconvert_border_bayer_line_to_bgr24(bayer + width, bayer, bgr, width,
       !start_with_green, !blue_line);
+}
+
+void v4lconvert_bayer_to_rgb24(const unsigned char *bayer,
+  unsigned char *bgr, int width, int height, unsigned int pixfmt)
+{
+	bayer_to_rgbbgr24(bayer, bgr, width, height, pixfmt,
+		pixfmt == V4L2_PIX_FMT_SGBRG8		/* start with green */
+			|| pixfmt == V4L2_PIX_FMT_SGRBG8,
+		pixfmt != V4L2_PIX_FMT_SBGGR8		/* blue line */
+			&& pixfmt != V4L2_PIX_FMT_SGBRG8);
+}
+
+void v4lconvert_bayer_to_bgr24(const unsigned char *bayer,
+  unsigned char *bgr, int width, int height, unsigned int pixfmt)
+{
+	bayer_to_rgbbgr24(bayer, bgr, width, height, pixfmt,
+		pixfmt == V4L2_PIX_FMT_SGBRG8		/* start with green */
+			|| pixfmt == V4L2_PIX_FMT_SGRBG8,
+		pixfmt == V4L2_PIX_FMT_SBGGR8		/* blue line */
+			|| pixfmt == V4L2_PIX_FMT_SGBRG8);
 }
 
 static void v4lconvert_border_bayer_line_to_y(
diff -r cfa0097c9e85 v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert-priv.h
--- a/v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert-priv.h	Fri Aug 01 18:23:15 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert-priv.h	Fri Aug 01 19:57:00 2008 +0200
@@ -71,6 +71,9 @@
 };
 
 
+void v4lconvert_yuv420_to_rgb24(const unsigned char *src, unsigned char *dst,
+  int width, int height);
+
 void v4lconvert_yuv420_to_bgr24(const unsigned char *src, unsigned char *dst,
   int width, int height);
 
@@ -92,6 +95,9 @@
 void v4lconvert_decode_pac207(const unsigned char *src, unsigned char *dst,
   int width, int height);
 
+void v4lconvert_bayer_to_rgb24(const unsigned char *bayer,
+  unsigned char *rgb, int width, int height, unsigned int pixfmt);
+
 void v4lconvert_bayer_to_bgr24(const unsigned char *bayer,
   unsigned char *rgb, int width, int height, unsigned int pixfmt);
 
diff -r cfa0097c9e85 v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert.c
--- a/v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert.c	Fri Aug 01 18:23:15 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert.c	Fri Aug 01 19:57:00 2008 +0200
@@ -30,6 +30,7 @@
 /* Note for proper functioning of v4lconvert_enum_fmt the first entries in
   supported_src_pixfmts must match with the entries in supported_dst_pixfmts */
 #define SUPPORTED_DST_PIXFMTS \
+  V4L2_PIX_FMT_RGB24, \
   V4L2_PIX_FMT_BGR24, \
   V4L2_PIX_FMT_YUV420
 
@@ -191,6 +192,7 @@
   if (closest_fmt.fmt.pix.pixelformat != desired_pixfmt) {
     dest_fmt->fmt.pix.pixelformat = desired_pixfmt;
     switch (dest_fmt->fmt.pix.pixelformat) {
+      case V4L2_PIX_FMT_RGB24:
       case V4L2_PIX_FMT_BGR24:
 	dest_fmt->fmt.pix.bytesperline = dest_fmt->fmt.pix.width * 3;
 	dest_fmt->fmt.pix.sizeimage = dest_fmt->fmt.pix.width *
@@ -228,6 +230,7 @@
 
   /* sanity check, is the dest buffer large enough? */
   switch (dest_fmt->fmt.pix.pixelformat) {
+    case V4L2_PIX_FMT_RGB24:
     case V4L2_PIX_FMT_BGR24:
       needed = dest_fmt->fmt.pix.width * dest_fmt->fmt.pix.height * 3;
       break;
@@ -283,12 +286,19 @@
       components[2] = components[1] + (dest_fmt->fmt.pix.width *
 				       dest_fmt->fmt.pix.height) / 4;
 
-      if (dest_fmt->fmt.pix.pixelformat == V4L2_PIX_FMT_BGR24) {
+      switch (dest_fmt->fmt.pix.pixelformat) {
+      case V4L2_PIX_FMT_RGB24:
+	tinyjpeg_set_components(data->jdec, components, 1);
+	result = tinyjpeg_decode(data->jdec, TINYJPEG_FMT_RGB24);
+	break;
+      case V4L2_PIX_FMT_BGR24:
 	tinyjpeg_set_components(data->jdec, components, 1);
 	result = tinyjpeg_decode(data->jdec, TINYJPEG_FMT_BGR24);
-      } else {
+	break;
+      default:
 	tinyjpeg_set_components(data->jdec, components, 3);
 	result = tinyjpeg_decode(data->jdec, TINYJPEG_FMT_YUV420P);
+	break;
       }
 
       /* If the JPEG header checked out ok and we get an error during actual
@@ -304,12 +314,20 @@
     case V4L2_PIX_FMT_SGBRG8:
     case V4L2_PIX_FMT_SGRBG8:
     case V4L2_PIX_FMT_SRGGB8:
-      if (dest_fmt->fmt.pix.pixelformat == V4L2_PIX_FMT_BGR24)
+      switch (dest_fmt->fmt.pix.pixelformat) {
+      case V4L2_PIX_FMT_RGB24:
+	v4lconvert_bayer_to_rgb24(src, dest, dest_fmt->fmt.pix.width,
+		    dest_fmt->fmt.pix.height, src_fmt->fmt.pix.pixelformat);
+        break;
+      case V4L2_PIX_FMT_BGR24:
 	v4lconvert_bayer_to_bgr24(src, dest, dest_fmt->fmt.pix.width,
 		    dest_fmt->fmt.pix.height, src_fmt->fmt.pix.pixelformat);
-      else
+        break;
+      default:
 	v4lconvert_bayer_to_yuv420(src, dest, dest_fmt->fmt.pix.width,
 		    dest_fmt->fmt.pix.height, src_fmt->fmt.pix.pixelformat);
+        break;
+      }
       break;
 
     /* YUYV line by line formats */
@@ -319,8 +337,8 @@
     {
       unsigned char tmpbuf[dest_fmt->fmt.pix.width * dest_fmt->fmt.pix.height *
 			   3 / 2];
-      unsigned char *my_dst = (dest_fmt->fmt.pix.pixelformat ==
-			       V4L2_PIX_FMT_BGR24) ? tmpbuf : dest;
+      unsigned char *my_dst = (dest_fmt->fmt.pix.pixelformat !=
+			       V4L2_PIX_FMT_YUV420) ? tmpbuf : dest;
 
       switch (src_fmt->fmt.pix.pixelformat) {
 	case V4L2_PIX_FMT_SPCA501:
@@ -337,10 +355,16 @@
 	  break;
       }
 
-      if (dest_fmt->fmt.pix.pixelformat == V4L2_PIX_FMT_BGR24)
+      switch (dest_fmt->fmt.pix.pixelformat) {
+      case V4L2_PIX_FMT_RGB24:
+	v4lconvert_yuv420_to_rgb24(tmpbuf, dest, dest_fmt->fmt.pix.width,
+				   dest_fmt->fmt.pix.height);
+	break;
+      case V4L2_PIX_FMT_BGR24:
 	v4lconvert_yuv420_to_bgr24(tmpbuf, dest, dest_fmt->fmt.pix.width,
 				   dest_fmt->fmt.pix.height);
-
+	break;
+      }
       break;
     }
 
@@ -370,12 +394,20 @@
 	  break;
       }
 
-      if (dest_fmt->fmt.pix.pixelformat == V4L2_PIX_FMT_BGR24)
+      switch (dest_fmt->fmt.pix.pixelformat) {
+      case V4L2_PIX_FMT_RGB24:
+	v4lconvert_bayer_to_rgb24(tmpbuf, dest, dest_fmt->fmt.pix.width,
+		    dest_fmt->fmt.pix.height, bayer_fmt);
+        break;
+      case V4L2_PIX_FMT_BGR24:
 	v4lconvert_bayer_to_bgr24(tmpbuf, dest, dest_fmt->fmt.pix.width,
 		    dest_fmt->fmt.pix.height, bayer_fmt);
-      else
+        break;
+      default:
 	v4lconvert_bayer_to_yuv420(tmpbuf, dest, dest_fmt->fmt.pix.width,
 		    dest_fmt->fmt.pix.height, bayer_fmt);
+        break;
+      }
       break;
     }
 
diff -r cfa0097c9e85 v4l2-apps/lib/libv4l/libv4lconvert/rgbyuv.c
--- a/v4l2-apps/lib/libv4l/libv4lconvert/rgbyuv.c	Fri Aug 01 18:23:15 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4lconvert/rgbyuv.c	Fri Aug 01 19:57:00 2008 +0200
@@ -34,14 +34,24 @@
 
 #define CLIP(color) (unsigned char)(((color)>0xFF)?0xff:(((color)<0)?0:(color)))
 
-void v4lconvert_yuv420_to_bgr24(const unsigned char *src, unsigned char *dest,
-  int width, int height)
+static void yuv420_to_rgbbgr24(const unsigned char *src,
+				unsigned char *dest,
+				int width, int height,
+				int bgr)
 {
   int i,j;
 
   const unsigned char *ysrc = src;
-  const unsigned char *usrc = src + width * height;
-  const unsigned char *vsrc = usrc + (width * height) / 4;
+  const unsigned char *usrc;
+  const unsigned char *vsrc;
+
+	if (bgr) {
+		vsrc = src + width * height;
+		usrc = vsrc + (width * height) / 4;
+	} else {
+		usrc = src + width * height;
+		vsrc = usrc + (width * height) / 4;
+	}
 
   for (i = 0; i < height; i++) {
     for (j = 0; j < width; j += 2) {
@@ -80,3 +90,15 @@
     }
   }
 }
+
+void v4lconvert_yuv420_to_rgb24(const unsigned char *src, unsigned char *dest,
+  int width, int height)
+{
+	yuv420_to_rgbbgr24(src, dest, width, height, 0);
+}
+
+void v4lconvert_yuv420_to_bgr24(const unsigned char *src, unsigned char *dest,
+  int width, int height)
+{
+	yuv420_to_rgbbgr24(src, dest, width, height, 1);
+}


-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
