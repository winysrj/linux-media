Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m63CRU7O025518
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 08:27:30 -0400
Received: from frosty.hhs.nl (frosty.hhs.nl [145.52.2.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m63CRGfh031598
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 08:27:17 -0400
Received: from exim (helo=frosty) by frosty.hhs.nl with local-smtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>) id 1KENu8-0007EW-CU
	for video4linux-list@redhat.com; Thu, 03 Jul 2008 14:27:16 +0200
Message-ID: <486CC582.1070705@hhs.nl>
Date: Thu, 03 Jul 2008 14:26:42 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Thierry Merle <thierry.merle@free.fr>
Content-Type: multipart/mixed; boundary="------------040404070800010003050908"
Cc: video4linux-list@redhat.com
Subject: PATCH: Add support for sonix (sn9c10x) bayer compression to
	libv4lconvert
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
--------------040404070800010003050908
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This patch adds support for sonix (sn9c10x) bayer compression to libv4lconvert.

Regards,

Hans

--------------040404070800010003050908
Content-Type: text/plain;
 name="libv4l-sn9c10x.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libv4l-sn9c10x.patch"

Add support for sonix (sn9c10x) bayer compression to libv4lconvert

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>
diff -r e90ac66913c6 v4l2-apps/lib/libv4l/libv4lconvert/Makefile
--- a/v4l2-apps/lib/libv4l/libv4lconvert/Makefile	Thu Jul 03 13:54:53 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4lconvert/Makefile	Thu Jul 03 14:19:49 2008 +0200
@@ -9,7 +9,7 @@
 LDFLAGS       = -shared
 
 CONVERT_LIB   = libv4lconvert.so
-CONVERT_OBJS  = libv4lconvert.o tinyjpeg.o \
+CONVERT_OBJS  = libv4lconvert.o tinyjpeg.o sn9c10x.o \
 		jidctflt.o spca561-decompress.o rgbyuv.o spca501.o bayer.o
 TARGETS       = $(CONVERT_LIB)
 INCLUDES      = ../include/libv4lconvert.h
diff -r e90ac66913c6 v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert-priv.h
--- a/v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert-priv.h	Thu Jul 03 13:54:53 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert-priv.h	Thu Jul 03 14:19:49 2008 +0200
@@ -71,6 +71,9 @@
 void v4lconvert_decode_spca561(const unsigned char *src, unsigned char *dst,
   int width, int height);
 
+void v4lconvert_decode_sn9c10x(const unsigned char *src, unsigned char *dst,
+  int width, int height);
+
 void v4lconvert_bayer_to_bgr24(const unsigned char *bayer,
   unsigned char *rgb, int width, int height, unsigned int pixfmt);
 
diff -r e90ac66913c6 v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert.c
--- a/v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert.c	Thu Jul 03 13:54:53 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert.c	Thu Jul 03 14:19:49 2008 +0200
@@ -37,6 +37,7 @@
   V4L2_PIX_FMT_SRGGB8,
   V4L2_PIX_FMT_SPCA501,
   V4L2_PIX_FMT_SPCA561,
+  V4L2_PIX_FMT_SN9C10X,
   -1
 };
 
@@ -314,23 +315,40 @@
 				     dest_fmt->fmt.pix.height);
       break;
 
+    /* compressed bayer formats */
     case V4L2_PIX_FMT_SPCA561:
+    case V4L2_PIX_FMT_SN9C10X:
     {
-      static unsigned char tmpbuf[640 * 480];
-      v4lconvert_decode_spca561(src, tmpbuf, dest_fmt->fmt.pix.width,
-				dest_fmt->fmt.pix.height);
+      unsigned char tmpbuf[dest_fmt->fmt.pix.width*dest_fmt->fmt.pix.height];
+      unsigned int bayer_fmt;
+
+      switch (src_fmt->fmt.pix.pixelformat) {
+        case V4L2_PIX_FMT_SPCA561:
+          v4lconvert_decode_spca561(src, tmpbuf, dest_fmt->fmt.pix.width,
+                                    dest_fmt->fmt.pix.height);
+          bayer_fmt = V4L2_PIX_FMT_SGBRG8;
+          break;
+        case V4L2_PIX_FMT_SN9C10X:
+          v4lconvert_decode_sn9c10x(src, tmpbuf, dest_fmt->fmt.pix.width,
+                                    dest_fmt->fmt.pix.height);
+          bayer_fmt = V4L2_PIX_FMT_SGBRG8;
+          break;
+      }
+
       if (dest_fmt->fmt.pix.pixelformat == V4L2_PIX_FMT_BGR24)
 	v4lconvert_bayer_to_bgr24(tmpbuf, dest, dest_fmt->fmt.pix.width,
-		    dest_fmt->fmt.pix.height, V4L2_PIX_FMT_SGBRG8);
+		    dest_fmt->fmt.pix.height, bayer_fmt);
       else
 	v4lconvert_bayer_to_yuv420(tmpbuf, dest, dest_fmt->fmt.pix.width,
-		    dest_fmt->fmt.pix.height, V4L2_PIX_FMT_SGBRG8);
+		    dest_fmt->fmt.pix.height, bayer_fmt);
       break;
     }
+
     case V4L2_PIX_FMT_BGR24:
       /* dest must be V4L2_PIX_FMT_YUV420 then */
       printf("FIXME add bgr24 -> yuv420 conversion\n");
       break;
+
     case V4L2_PIX_FMT_YUV420:
       /* dest must be V4L2_PIX_FMT_BGR24 then */
       v4lconvert_yuv420_to_bgr24(src, dest, dest_fmt->fmt.pix.width,
diff -r e90ac66913c6 v4l2-apps/lib/libv4l/libv4lconvert/sn9c10x.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/v4l2-apps/lib/libv4l/libv4lconvert/sn9c10x.c	Thu Jul 03 14:19:49 2008 +0200
@@ -0,0 +1,199 @@
+/*
+#             (C) 2008 Hans de Goede <j.w.r.degoede@hhs.nl>
+
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU Lesser General Public License as published by
+# the Free Software Foundation; either version 2.1 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU Lesser General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+*/
+
+#include "libv4lconvert-priv.h"
+
+/* FIXME FIXME FIXME add permission notice from Bertrik Sikken to release
+   this code (which is his) under the LGPL */
+
+#define CLAMP(x)	((x)<0?0:((x)>255)?255:(x))
+
+typedef struct {
+	int is_abs;
+	int len;
+	int val;
+	int unk;
+} code_table_t;
+
+
+/* local storage */
+/* FIXME not thread safe !! */
+static code_table_t table[256];
+static int init_done = 0;
+
+/* global variable */
+static int sonix_unknown = 0;
+
+/*
+	sonix_decompress_init
+	=====================
+		pre-calculates a locally stored table for efficient huffman-decoding.
+
+	Each entry at index x in the table represents the codeword
+	present at the MSB of byte x.
+
+*/
+void sonix_decompress_init(void)
+{
+	int i;
+	int is_abs, val, len, unk;
+
+	for (i = 0; i < 256; i++) {
+		is_abs = 0;
+		val = 0;
+		len = 0;
+		unk = 0;
+		if ((i & 0x80) == 0) {
+			/* code 0 */
+			val = 0;
+			len = 1;
+		}
+		else if ((i & 0xE0) == 0x80) {
+			/* code 100 */
+			val = +4;
+			len = 3;
+		}
+		else if ((i & 0xE0) == 0xA0) {
+			/* code 101 */
+			val = -4;
+			len = 3;
+		}
+		else if ((i & 0xF0) == 0xD0) {
+			/* code 1101 */
+			val = +11;
+			len = 4;
+		}
+		else if ((i & 0xF0) == 0xF0) {
+			/* code 1111 */
+			val = -11;
+			len = 4;
+		}
+		else if ((i & 0xF8) == 0xC8) {
+			/* code 11001 */
+			val = +20;
+			len = 5;
+		}
+		else if ((i & 0xFC) == 0xC0) {
+			/* code 110000 */
+			val = -20;
+			len = 6;
+		}
+		else if ((i & 0xFC) == 0xC4) {
+			/* code 110001xx: unknown */
+			val = 0;
+			len = 8;
+			unk = 1;
+		}
+		else if ((i & 0xF0) == 0xE0) {
+			/* code 1110xxxx */
+			is_abs = 1;
+			val = (i & 0x0F) << 4;
+			len = 8;
+		}
+		table[i].is_abs = is_abs;
+		table[i].val = val;
+		table[i].len = len;
+		table[i].unk = unk;
+	}
+
+	sonix_unknown = 0;
+	init_done = 1;
+}
+
+
+/*
+	sonix_decompress
+	================
+		decompresses an image encoded by a SN9C101 camera controller chip.
+
+	IN	width
+		height
+		inp		pointer to compressed frame (with header already stripped)
+	OUT	outp	pointer to decompressed frame
+
+	Returns 0 if the operation was successful.
+	Returns <0 if operation failed.
+
+*/
+void v4lconvert_decode_sn9c10x(const unsigned char *inp, unsigned char *outp,
+	int width, int height)
+{
+	int row, col;
+	int val;
+	int bitpos;
+	unsigned char code;
+	unsigned char *addr;
+
+	if (!init_done)
+		sonix_decompress_init();
+
+	bitpos = 0;
+	for (row = 0; row < height; row++) {
+
+		col = 0;
+
+		/* first two pixels in first two rows are stored as raw 8-bit */
+		if (row < 2) {
+			addr = inp + (bitpos >> 3);
+			code = (addr[0] << (bitpos & 7)) | (addr[1] >> (8 - (bitpos & 7)));
+			bitpos += 8;
+			*outp++ = code;
+
+			addr = inp + (bitpos >> 3);
+			code = (addr[0] << (bitpos & 7)) | (addr[1] >> (8 - (bitpos & 7)));
+			bitpos += 8;
+			*outp++ = code;
+
+			col += 2;
+		}
+
+		while (col < width) {
+			/* get bitcode from bitstream */
+			addr = inp + (bitpos >> 3);
+			code = (addr[0] << (bitpos & 7)) | (addr[1] >> (8 - (bitpos & 7)));
+
+			/* update bit position */
+			bitpos += table[code].len;
+
+			/* update code statistics */
+			sonix_unknown += table[code].unk;
+
+			/* calculate pixel value */
+			val = table[code].val;
+			if (!table[code].is_abs) {
+				/* value is relative to top and left pixel */
+				if (col < 2) {
+					/* left column: relative to top pixel */
+					val += outp[-2*width];
+				}
+				else if (row < 2) {
+					/* top row: relative to left pixel */
+					val += outp[-2];
+				}
+				else {
+					/* main area: average of left pixel and top pixel */
+					val += (outp[-2] + outp[-2*width]) / 2;
+				}
+			}
+
+			/* store pixel */
+			*outp++ = CLAMP(val);
+			col++;
+		}
+	}
+}

--------------040404070800010003050908
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------040404070800010003050908--
