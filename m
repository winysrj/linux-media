Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:35838 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbZEWV6G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2009 17:58:06 -0400
Date: Sat, 23 May 2009 17:12:01 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Hans de Goede <hdegoede@redhat.com>
cc: Hans de Goede <j.w.r.degoede@hhs.nl>, linux-media@vger.kernel.org
Subject: [PATCH] to libv4lconvert, to do decompression for sn9c2028 cameras
In-Reply-To: <4A144E41.6080806@redhat.com>
Message-ID: <alpine.LNX.2.00.0905231628240.24795@banach.math.auburn.edu>
References: <1242316804.1759.1@lhost.ldomain> <4A0C544F.1030801@hhs.nl> <alpine.LNX.2.00.0905141424460.11396@banach.math.auburn.edu> <alpine.LNX.2.00.0905191529260.19936@banach.math.auburn.edu> <4A144E41.6080806@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


The purpose of the following patch is to do the decompression for the 
Sonix SN9C2028 cameras, which are already supported as still cameras in 
libgphoto2/camlibs/sonix. The decompression code is essentially identical 
to that which is used in the libgphoto2 driver, with minor changes to 
adapt it for libv4lconvert.

The history and antecedents of this algorithm are described in 
libgphoto2/camlibs/sonix/README.sonix, which was Copyright (C) 2005 
Theodore Kilgore <kilgota@auburn.edu>, as follows:

"The decompression algorithm originates, I understand, in the work of 
Bertrik Sikkens for the sn9c102 cameras. In the macam project for MacOS-X 
camera support (webcam-osx project on Sourceforge), the decompression 
algorithm for the sn9c2028 cameras was developed by Mattias Krauss and 
adapted for use with the Vivitar Vivicam 3350B in particular by Harald 
Ruda <hrx at users.sourceforge.net>. Harald brought to my attention the 
work already done in the macam project, pointed out that it is GPL code, 
and invited me to have a look. Thanks, Harald. The decompression algorithm 
used here is similar to what is used in the macam driver, but is 
considerably streamlined and improved."

Signed-off-by Theodore Kilgore <kilgota@auburn.edu>

-----------------------------------------------------------------------
diff -r 276a90c8ac40 v4l2-apps/libv4l/libv4lconvert/Makefile
--- a/v4l2-apps/libv4l/libv4lconvert/Makefile	Wed May 20 07:23:00 2009 +0200
+++ b/v4l2-apps/libv4l/libv4lconvert/Makefile	Wed May 20 13:10:53 2009 -0500
@@ -14,7 +14,7 @@

  CONVERT_OBJS  = libv4lconvert.o tinyjpeg.o sn9c10x.o sn9c20x.o pac207.o \
  		mr97310a.o flip.o crop.o jidctflt.o spca561-decompress.o \
-		rgbyuv.o spca501.o sq905c.o bayer.o hm12.o \
+		rgbyuv.o sn9c2028-decomp.o spca501.o sq905c.o bayer.o hm12.o \
  		control/libv4lcontrol.o processing/libv4lprocessing.o \
  		processing/rgbprocessing.o processing/bayerprocessing.o
  TARGETS       = $(CONVERT_LIB) libv4lconvert.pc
diff -r 276a90c8ac40 v4l2-apps/libv4l/libv4lconvert/libv4lconvert-priv.h
--- a/v4l2-apps/libv4l/libv4lconvert/libv4lconvert-priv.h	Wed May 20 07:23:00 2009 +0200
+++ b/v4l2-apps/libv4l/libv4lconvert/libv4lconvert-priv.h	Wed May 20 13:10:53 2009 -0500
@@ -51,6 +51,10 @@
  #define V4L2_PIX_FMT_MR97310A v4l2_fourcc('M','3','1','0')
  #endif

+#ifndef V4L2_PIX_FMT_SN9C2028
+#define V4L2_PIX_FMT_SN9C2028 v4l2_fourcc('S', 'O', 'N', 'X')
+#endif
+
  #ifndef V4L2_PIX_FMT_SQ905C
  #define V4L2_PIX_FMT_SQ905C v4l2_fourcc('9', '0', '5', 'C')
  #endif
@@ -193,6 +197,9 @@
  void v4lconvert_decode_mr97310a(const unsigned char *src, unsigned char *dst,
    int width, int height);

+void v4lconvert_decode_sn9c2028(const unsigned char *src, unsigned char *dst,
+  int width, int height);
+
  void v4lconvert_decode_sq905c(const unsigned char *src, unsigned char *dst,
    int width, int height);

diff -r 276a90c8ac40 v4l2-apps/libv4l/libv4lconvert/libv4lconvert.c
--- a/v4l2-apps/libv4l/libv4lconvert/libv4lconvert.c	Wed May 20 07:23:00 2009 +0200
+++ b/v4l2-apps/libv4l/libv4lconvert/libv4lconvert.c	Wed May 20 13:10:53 2009 -0500
@@ -60,6 +60,7 @@
    { V4L2_PIX_FMT_JPEG,         V4LCONVERT_COMPRESSED },
    { V4L2_PIX_FMT_SPCA561,      V4LCONVERT_COMPRESSED },
    { V4L2_PIX_FMT_SN9C10X,      V4LCONVERT_COMPRESSED },
+  { V4L2_PIX_FMT_SN9C2028,     V4LCONVERT_COMPRESSED },
    { V4L2_PIX_FMT_PAC207,       V4LCONVERT_COMPRESSED },
    { V4L2_PIX_FMT_MR97310A,     V4LCONVERT_COMPRESSED },
    { V4L2_PIX_FMT_SQ905C,       V4LCONVERT_COMPRESSED },
@@ -460,6 +461,7 @@
      case V4L2_PIX_FMT_SN9C10X:
      case V4L2_PIX_FMT_PAC207:
      case V4L2_PIX_FMT_MR97310A:
+    case V4L2_PIX_FMT_SN9C2028:
      case V4L2_PIX_FMT_SQ905C:
      case V4L2_PIX_FMT_SBGGR8:
      case V4L2_PIX_FMT_SGBRG8:
@@ -672,6 +674,7 @@
      case V4L2_PIX_FMT_SN9C10X:
      case V4L2_PIX_FMT_PAC207:
      case V4L2_PIX_FMT_MR97310A:
+    case V4L2_PIX_FMT_SN9C2028:
      case V4L2_PIX_FMT_SQ905C:
      {
        unsigned char *tmpbuf;
@@ -699,6 +702,10 @@
  	  v4lconvert_decode_mr97310a(src, tmpbuf, width, height);
  	  tmpfmt.fmt.pix.pixelformat = V4L2_PIX_FMT_SBGGR8;
  	  break;
+	case V4L2_PIX_FMT_SN9C2028:
+	  v4lconvert_decode_sn9c2028(src, tmpbuf, width, height);
+	  src_pix_fmt = V4L2_PIX_FMT_SBGGR8;
+	  break;
  	case V4L2_PIX_FMT_SQ905C:
  	  v4lconvert_decode_sq905c(src, tmpbuf, width, height);
  	  tmpfmt.fmt.pix.pixelformat = V4L2_PIX_FMT_SRGGB8;
diff -r 276a90c8ac40 v4l2-apps/libv4l/libv4lconvert/sn9c2028-decomp.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/v4l2-apps/libv4l/libv4lconvert/sn9c2028-decomp.c	Wed May 20 13:10:53 2009 -0500
@@ -0,0 +1,158 @@
+/*
+ * sn9c2028-decomp.c
+ *
+ * Decompression function for the Sonix SN9C2028 dual-mode cameras.
+ *
+ * Code adapted from libgphoto2/camlibs/sonix, original version of which was
+ * Copyright (c) 2005 Theodore Kilgore <kilgota@auburn.edu>
+ *
+ * History:
+ *
+ * This decoding algorithm originates from the work of Bertrik Sikken for the
+ * SN9C102 cameras. This version is an adaptation of work done by Mattias
+ * Krauss for the webcam-osx (macam) project. There, it was further adapted
+ * for use with the Vivitar Vivicam 3350B (an SN9C2028 camera) by
+ * Harald Ruda <hrx@users.sourceforge.net>. Harald brought to my attention the
+ * work done in the macam project and suggested that I use it. The
+ * macam project is also licensed under the GPL. One improvement of my own
+ * was to notice that the even and odd columns of the image have been reversed
+ * by the decompression algorithm, and this needs to be corrected during the
+ * decompression.
+ *
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 02111-1307, USA.
+ */
+
+#include "libv4lconvert-priv.h"
+
+/* Four defines for bitstream operations, used in the decode function */
+
+#define PEEK_BITS(num,to) {\
+	if (bitBufCount < num) {\
+		do {\
+			bitBuf = (bitBuf << 8)|(*(src++));\
+			bitBufCount += 8; \
+		} \
+		while\
+			(bitBufCount < 24);\
+	} \
+	to = bitBuf >> (bitBufCount-num);\
+}
+
+/*
+ * PEEK_BITS puts the next <num> bits into the low bits of <to>.
+ * when the buffer is empty, it is completely refilled.
+ * This strategy tries to reduce memory access. Note that the high bits
+ * are NOT set to zero!
+ */
+
+#define EAT_BITS(num) { bitBufCount -= num; bits_eaten += num; }
+
+/*
+ * EAT_BITS consumes <num> bits (PEEK_BITS does not consume anything,
+ * it just peeks)
+ */
+
+#define PARSE_PIXEL(val) {\
+	PEEK_BITS(10, bits);\
+	if ((bits&0x200) == 0) {\
+		EAT_BITS(1);\
+	} \
+	else if ((bits&0x380) == 0x280) {\
+		EAT_BITS(3);\
+		val += 3;\
+		if (val > 255)\
+			val = 255;\
+	} \
+	else if ((bits&0x380) == 0x300) {\
+		EAT_BITS(3);\
+		val -= 3;\
+		if (val < 0)\
+			val = 0;\
+	} \
+	else if ((bits&0x3c0) == 0x200) {\
+		EAT_BITS(4);\
+		val += 8;\
+		if (val > 255)\
+			val = 255;\
+	} \
+	else if ((bits&0x3c0) == 0x240) {\
+		EAT_BITS(4);\
+		val -= 8;\
+		if (val < 0)\
+			val = 0;\
+	} \
+	else if ((bits&0x3c0) == 0x3c0) {\
+		EAT_BITS(4);\
+		val -= 20;\
+		if (val < 0)\
+			val = 0;\
+	} \
+	else if ((bits&0x3e0) == 0x380) {\
+		EAT_BITS(5);\
+		val += 20;\
+		if (val > 255)\
+			val = 255;\
+	} \
+	else {\
+		EAT_BITS(10);\
+		val = 8*(bits&0x1f)+0;\
+	} \
+}
+
+
+#define PUT_PIXEL_PAIR {\
+    long pp;\
+    pp = (c1val<<8)+c2val;\
+    *((unsigned short *) (dst+dst_index)) = pp;\
+    dst_index += 2;\
+}
+
+/* Now the decode function itself */
+
+void v4lconvert_decode_sn9c2028(const unsigned char *src, unsigned char *dst,
+  int width, int height)
+{
+	long dst_index = 0;
+	int starting_row = 0;
+	unsigned short bits;
+	short c1val, c2val;
+	int x, y;
+	unsigned long bitBuf = 0;
+	unsigned long bitBufCount = 0;
+	unsigned long bits_eaten = 0;
+
+	src += 12;	/* Remove the header */
+
+	for (y = starting_row; y < height; y++) {
+		PEEK_BITS(8, bits);
+		EAT_BITS(8);
+		c2val = (bits & 0xff);
+		PEEK_BITS(8, bits);
+		EAT_BITS(8);
+		c1val = (bits & 0xff);
+
+		PUT_PIXEL_PAIR;
+
+		for (x = 2; x < width ; x += 2) {
+			/* The compression reversed the even and odd columns.*/
+			PARSE_PIXEL(c2val);
+			PARSE_PIXEL(c1val);
+			PUT_PIXEL_PAIR;
+		}
+	}
+}
