Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7HC9TD6022520
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 08:09:29 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7HC8l3s018111
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 08:08:48 -0400
Message-ID: <48A80FC7.6090909@hhs.nl>
Date: Sun, 17 Aug 2008 13:47:19 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
References: <1218734045.1696.39.camel@localhost>
In-Reply-To: <1218734045.1696.39.camel@localhost>
Content-Type: multipart/mixed; boundary="------------010401070502010100060804"
Cc: Video 4 Linux <video4linux-list@redhat.com>
Subject: Re: v4l library - decoding of Pixart JPEG frames
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

This is a multi-part message in MIME format.
--------------010401070502010100060804
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Jean, Thomas,

Jean, good to see that you are working on the pixart 73xx support, I 
have a cam over here as well which didn't work at all, now with your 
fixes, it atleast generates proper frames (they used too be much too 
small). Unfortunately my cam still does not work, your siv.c does show 
something which seems to be decoded video data, but not as it should 
look like, from the looks of it we are close though.

I've made a single raw frame from my cam available here:
http://people.atrpms.net/~hdegoede/image.dat

If anyone can write code which can convert that to an image (might be 
unsharp) that would be great!

I've done a first attempt at making v4lconvert handle these pixart jpeg 
frames, patch attached. Warning this is a crude hack breaking regular 
jpeg support. This seems to work less well with my cam then the siv.c 
code, so we might need to make more changes either to v4lconvert, or 
maybe to the jpeg_put_header call in pac7311.c, talking about this call, 
since we are defining a custom format anyways, shouldn't we just omit 
the header and send the jpeg-ish pixart frame data to userspace as is?

Thomas, I would be very much interested in your tinyjpeg version with 
pixart support!

Jean, perhaps you can make some raw images from your cam available 
somewhere too?

Regards,

Hans

--------------010401070502010100060804
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff"

diff -r 566aac58b414 v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert-priv.h
--- a/v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert-priv.h	Thu Aug 07 19:34:10 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert-priv.h	Sun Aug 17 14:06:29 2008 +0200
@@ -43,6 +43,10 @@
 #define V4L2_PIX_FMT_PAC207 v4l2_fourcc('P','2','0','7')
 #endif
 
+#ifndef V4L2_PIX_FMT_PJPG
+#define V4L2_PIX_FMT_PJPG v4l2_fourcc('P', 'J', 'P', 'G')
+#endif
+
 #ifndef V4L2_PIX_FMT_SGBRG8
 #define V4L2_PIX_FMT_SGBRG8 v4l2_fourcc('G','B','R','G')
 #endif
diff -r 566aac58b414 v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert.c
--- a/v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert.c	Thu Aug 07 19:34:10 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert.c	Sun Aug 17 14:06:29 2008 +0200
@@ -48,6 +48,7 @@
   V4L2_PIX_FMT_SPCA561,
   V4L2_PIX_FMT_SN9C10X,
   V4L2_PIX_FMT_PAC207,
+  V4L2_PIX_FMT_PJPG,
 };
 
 static const unsigned int supported_dst_pixfmts[] = {
@@ -297,6 +298,51 @@
   }
 
   switch (src_fmt->fmt.pix.pixelformat) {
+    case V4L2_PIX_FMT_PJPG:
+    {
+      unsigned char *in;
+      unsigned char *out, out_buf[src_size];
+      int in_size = src_size, out_size, header_size = 0x646;
+      
+      if (src_size < header_size)
+        return needed;
+
+      memcpy(out_buf, src, header_size);
+
+      in = src + header_size;
+      out = out_buf + header_size;
+      in_size -= header_size;
+      out_size = header_size;
+
+      while(in_size > 0) {
+        int chunk_size;
+
+        if (in[0] != 0xff || in[1] != 0xff || in[2] != 0xff) {
+          fprintf(stderr, "Pixart JPEG format error, header: %02x %02x %02x\n",
+            (int)in[0], (int)in[1], (int)in[2]);
+          return needed;
+        }
+        if (in[3] == 0u) 
+          chunk_size = in_size - 4;
+        else if (in[3] < 6u)
+          chunk_size = 1024 >> (in[3] - 1);
+        else {
+          fprintf(stderr, "Pixart JPEG format error: chunk_size = %d\n",
+            (int)in[3]);
+          return needed;
+        }
+
+        memcpy(out, in + 4, chunk_size);
+        in += chunk_size + 4;
+        out += chunk_size;
+        in_size -= chunk_size + 4;
+        out_size += chunk_size;
+      }
+
+      src = out_buf;
+      src_size = out_size;
+      /* fall through! */
+    }
     case V4L2_PIX_FMT_MJPEG:
     case V4L2_PIX_FMT_JPEG:
       if (!data->jdec) {
diff -r 566aac58b414 v4l2-apps/lib/libv4l/libv4lconvert/tinyjpeg.c
--- a/v4l2-apps/lib/libv4l/libv4lconvert/tinyjpeg.c	Thu Aug 07 19:34:10 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4lconvert/tinyjpeg.c	Sun Aug 17 14:06:29 2008 +0200
@@ -60,6 +60,9 @@
 #define BLACK_Y 0
 #define BLACK_U 127
 #define BLACK_V 127
+
+#define DEBUG 1
+#define LOG2FILE 1
 
 #if DEBUG
 #if LOG2FILE
@@ -2112,6 +2115,7 @@
      for (x=0; x < priv->width; x+=xstride_by_mcu)
       {
 	decode_MCU(priv);
+	skip_nbits(priv->reservoir, priv->nbits_in_reservoir, priv->stream, 8);
 	convert_to_pixfmt(priv);
 	priv->plane[0] += bytes_per_mcu[0];
 	priv->plane[1] += bytes_per_mcu[1];

--------------010401070502010100060804
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------010401070502010100060804--
