Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:34309 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757875AbZGCCTU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Jul 2009 22:19:20 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n632JOnC018672
	for <linux-media@vger.kernel.org>; Thu, 2 Jul 2009 22:19:24 -0400
Date: Thu, 2 Jul 2009 23:19:20 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] libv4l: add support for RGB565 format
Message-ID: <20090702231920.422c1e20@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, em28xx driver outputs webcams only at RGB565 format. However,
several webcam applications don't support this format.

In order to properly work with those applications, a RGB565 handler should be
added at libv4l.

Tested with Silvercrest 1.3 mpix with v4l2grab (V4L2, with native libv4l
support) and two LD_PRELOAD applications: camorama (V4L1 API) and skype (using compat32).

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/v4l2-apps/libv4l/libv4lconvert/libv4lconvert-priv.h b/v4l2-apps/libv4l/libv4lconvert/libv4lconvert-priv.h
--- a/v4l2-apps/libv4l/libv4lconvert/libv4lconvert-priv.h
+++ b/v4l2-apps/libv4l/libv4lconvert/libv4lconvert-priv.h
@@ -184,6 +184,15 @@ void v4lconvert_swap_rgb(const unsigned 
 void v4lconvert_swap_uv(const unsigned char *src, unsigned char *dst,
   const struct v4l2_format *src_fmt);
 
+void v4lconvert_rgb565_to_rgb24(const unsigned char *src, unsigned char *dest,
+  int width, int height);
+
+void v4lconvert_rgb565_to_bgr24(const unsigned char *src, unsigned char *dest,
+  int width, int height);
+
+void v4lconvert_rgb565_to_yuv420(const unsigned char *src, unsigned char *dest,
+  const struct v4l2_format *src_fmt, int yvu);
+
 void v4lconvert_spca501_to_yuv420(const unsigned char *src, unsigned char *dst,
   int width, int height, int yvu);
 
diff --git a/v4l2-apps/libv4l/libv4lconvert/libv4lconvert.c b/v4l2-apps/libv4l/libv4lconvert/libv4lconvert.c
--- a/v4l2-apps/libv4l/libv4lconvert/libv4lconvert.c
+++ b/v4l2-apps/libv4l/libv4lconvert/libv4lconvert.c
@@ -46,6 +46,7 @@ static const struct v4lconvert_pixfmt su
   { V4L2_PIX_FMT_YUYV,         0 },
   { V4L2_PIX_FMT_YVYU,         0 },
   { V4L2_PIX_FMT_UYVY,         0 },
+  { V4L2_PIX_FMT_RGB565,       0 },
   { V4L2_PIX_FMT_SN9C20X_I420, V4LCONVERT_NEEDS_CONVERSION },
   { V4L2_PIX_FMT_SBGGR8,       V4LCONVERT_NEEDS_CONVERSION },
   { V4L2_PIX_FMT_SGBRG8,       V4LCONVERT_NEEDS_CONVERSION },
@@ -787,6 +788,23 @@ static int v4lconvert_convert_pixfmt(str
       }
       break;
 
+    case V4L2_PIX_FMT_RGB565:
+      switch (dest_pix_fmt) {
+      case V4L2_PIX_FMT_RGB24:
+	v4lconvert_rgb565_to_rgb24(src, dest, width, height);
+	break;
+      case V4L2_PIX_FMT_BGR24:
+	v4lconvert_rgb565_to_bgr24(src, dest, width, height);
+	break;
+      case V4L2_PIX_FMT_YUV420:
+	v4lconvert_rgb565_to_yuv420(src, dest, fmt, 0);
+	break;
+      case V4L2_PIX_FMT_YVU420:
+	v4lconvert_rgb565_to_yuv420(src, dest, fmt, 1);
+	break;
+      }
+      break;
+
     case V4L2_PIX_FMT_RGB24:
       switch (dest_pix_fmt) {
       case V4L2_PIX_FMT_BGR24:
diff --git a/v4l2-apps/libv4l/libv4lconvert/rgbyuv.c b/v4l2-apps/libv4l/libv4lconvert/rgbyuv.c
--- a/v4l2-apps/libv4l/libv4lconvert/rgbyuv.c
+++ b/v4l2-apps/libv4l/libv4lconvert/rgbyuv.c
@@ -1,8 +1,10 @@
 /*
 
 # RGB <-> YUV conversion routines
+#             (C) 2008 Hans de Goede <j.w.r.degoede@hhs.nl>
 
-#             (C) 2008 Hans de Goede <j.w.r.degoede@hhs.nl>
+# RGB565 conversion routines
+#             (C) 2009 Mauro Carvalho Chehab <mchehab@redhat.com>
 
 # This program is free software; you can redistribute it and/or modify
 # it under the terms of the GNU Lesser General Public License as published by
@@ -472,3 +474,103 @@ void v4lconvert_swap_uv(const unsigned c
     src += src_fmt->fmt.pix.bytesperline / 2;
   }
 }
+
+void v4lconvert_rgb565_to_rgb24(const unsigned char *src, unsigned char *dest,
+  int width, int height)
+{
+  int j;
+  while (--height >= 0) {
+    for (j = 0; j < width; j++) {
+      unsigned short tmp = *(unsigned short *)src;
+
+      /* Original format: rrrrrggg gggbbbbb */
+      *dest++ = 0xf8 & (tmp >> 8);
+      *dest++ = 0xfc & (tmp >> 3);
+      *dest++ = 0xf8 & (tmp << 3);
+
+      src += 2;
+    }
+  }
+}
+
+void v4lconvert_rgb565_to_bgr24(const unsigned char *src, unsigned char *dest,
+  int width, int height)
+{
+  int j;
+  while (--height >= 0) {
+    for (j = 0; j < width; j++) {
+      unsigned short tmp = *(unsigned short *)src;
+
+      /* Original format: rrrrrggg gggbbbbb */
+      *dest++ = 0xf8 & (tmp << 3);
+      *dest++ = 0xfc & (tmp >> 3);
+      *dest++ = 0xf8 & (tmp >> 8);
+
+      src += 2;
+    }
+  }
+}
+
+void v4lconvert_rgb565_to_yuv420(const unsigned char *src, unsigned char *dest,
+  const struct v4l2_format *src_fmt, int yvu)
+{
+  int x, y;
+  unsigned short tmp;
+  unsigned char *udest, *vdest;
+  unsigned r[4], g[4], b[4];
+  int avg_src[3];
+
+  /* Y */
+  for (y = 0; y < src_fmt->fmt.pix.height; y++) {
+    for (x = 0; x < src_fmt->fmt.pix.width; x++) {
+      tmp = *(unsigned short *)src;
+      r[0] = 0xf8 & (tmp << 3);
+      g[0] = 0xfc & (tmp >> 3);
+      b[0] = 0xf8 & (tmp >> 8);
+      RGB2Y(r[0], g[0], b[0], *dest++);
+      src += 2;
+    }
+    src += src_fmt->fmt.pix.bytesperline - 2 * src_fmt->fmt.pix.width;
+  }
+  src -= src_fmt->fmt.pix.height * src_fmt->fmt.pix.bytesperline;
+
+  /* U + V */
+  if (yvu) {
+    vdest = dest;
+    udest = dest + src_fmt->fmt.pix.width * src_fmt->fmt.pix.height / 4;
+  } else {
+    udest = dest;
+    vdest = dest + src_fmt->fmt.pix.width * src_fmt->fmt.pix.height / 4;
+  }
+
+  for (y = 0; y < src_fmt->fmt.pix.height / 2; y++) {
+    for (x = 0; x < src_fmt->fmt.pix.width / 2; x++) {
+      tmp = *(unsigned short *)src;
+      r[0] = 0xf8 & (tmp << 3);
+      g[0] = 0xfc & (tmp >> 3);
+      b[0] = 0xf8 & (tmp >> 8);
+
+      tmp = *(((unsigned short *)src) + 1);
+      r[1] = 0xf8 & (tmp << 3);
+      g[1] = 0xfc & (tmp >> 3);
+      b[1] = 0xf8 & (tmp >> 8);
+
+      tmp = *(((unsigned short *)src) + src_fmt->fmt.pix.bytesperline);
+      r[2] = 0xf8 & (tmp << 3);
+      g[2] = 0xfc & (tmp >> 3);
+      b[2] = 0xf8 & (tmp >> 8);
+
+      tmp = *(((unsigned short *)src) + src_fmt->fmt.pix.bytesperline + 1);
+      r[3] = 0xf8 & (tmp << 3);
+      g[3] = 0xfc & (tmp >> 3);
+      b[3] = 0xf8 & (tmp >> 8);
+
+      avg_src[0] = (r[0] + r[1] + r[2] + r[3]) /4;
+      avg_src[1] = (g[0] + g[1] + g[2] + g[3]) /4;
+      avg_src[2] = (b[0] + b[1] + b[2] + b[3]) /4;
+      RGB2UV(avg_src[0], avg_src[1], avg_src[2], *udest++, *vdest++);
+      src += 4;
+    }
+    src += 2 * src_fmt->fmt.pix.bytesperline - 2 * src_fmt->fmt.pix.width;
+  }
+}


-- 

Cheers,
Mauro
