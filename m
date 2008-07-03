Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m63JhfY3011722
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 15:43:41 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m63JhORZ010515
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 15:43:25 -0400
Message-ID: <486D2D60.3070801@hhs.nl>
Date: Thu, 03 Jul 2008 21:49:52 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Thierry Merle <thierry.merle@free.fr>
Content-Type: multipart/mixed; boundary="------------040000010503010200010107"
Cc: video4linux-list@redhat.com, v4l2 library <v4l2-library@linuxtv.org>
Subject: PATCH: libv
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
--------------040000010503010200010107
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi All,

This patch adds support to libv4l for the compressed bayer format emitted by
pac207 based cams.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans

--------------040000010503010200010107
Content-Type: text/x-patch;
 name="libv4l-pac207.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libv4l-pac207.patch"

This patch adds support to libv4l for the compressed bayer format emitted by
pac207 based cams.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

diff -r faf96cf9a97c v4l2-apps/lib/libv4l/libv4lconvert/Makefile
--- a/v4l2-apps/lib/libv4l/libv4lconvert/Makefile	Thu Jul 03 14:28:04 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4lconvert/Makefile	Thu Jul 03 20:13:42 2008 +0200
@@ -9,7 +9,7 @@
 LDFLAGS       = -shared
 
 CONVERT_LIB   = libv4lconvert.so
-CONVERT_OBJS  = libv4lconvert.o tinyjpeg.o sn9c10x.o \
+CONVERT_OBJS  = libv4lconvert.o tinyjpeg.o sn9c10x.o pac207.o \
 		jidctflt.o spca561-decompress.o rgbyuv.o spca501.o bayer.o
 TARGETS       = $(CONVERT_LIB)
 INCLUDES      = ../include/libv4lconvert.h
diff -r faf96cf9a97c v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert-priv.h
--- a/v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert-priv.h	Thu Jul 03 14:28:04 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert-priv.h	Thu Jul 03 20:13:42 2008 +0200
@@ -31,6 +31,10 @@
 #define V4L2_PIX_FMT_SPCA561 v4l2_fourcc('S','5','6','1')
 #endif
 
+#ifndef V4L2_PIX_FMT_PAC207
+#define V4L2_PIX_FMT_PAC207 v4l2_fourcc('P','2','0','7')
+#endif
+
 #ifndef V4L2_PIX_FMT_SGBRG8
 #define V4L2_PIX_FMT_SGBRG8 v4l2_fourcc('G','B','R','G')
 #endif
@@ -74,6 +78,9 @@
 void v4lconvert_decode_sn9c10x(const unsigned char *src, unsigned char *dst,
   int width, int height);
 
+void v4lconvert_decode_pac207(const unsigned char *src, unsigned char *dst,
+  int width, int height);
+
 void v4lconvert_bayer_to_bgr24(const unsigned char *bayer,
   unsigned char *rgb, int width, int height, unsigned int pixfmt);
 
diff -r faf96cf9a97c v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert.c
--- a/v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert.c	Thu Jul 03 14:28:04 2008 +0200
+++ b/v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert.c	Thu Jul 03 20:13:42 2008 +0200
@@ -38,6 +38,7 @@
   V4L2_PIX_FMT_SPCA501,
   V4L2_PIX_FMT_SPCA561,
   V4L2_PIX_FMT_SN9C10X,
+  V4L2_PIX_FMT_PAC207,
   -1
 };
 
@@ -318,6 +319,7 @@
     /* compressed bayer formats */
     case V4L2_PIX_FMT_SPCA561:
     case V4L2_PIX_FMT_SN9C10X:
+    case V4L2_PIX_FMT_PAC207:
     {
       unsigned char tmpbuf[dest_fmt->fmt.pix.width*dest_fmt->fmt.pix.height];
       unsigned int bayer_fmt;
@@ -332,6 +334,11 @@
 	  v4lconvert_decode_sn9c10x(src, tmpbuf, dest_fmt->fmt.pix.width,
 				    dest_fmt->fmt.pix.height);
 	  bayer_fmt = V4L2_PIX_FMT_SGBRG8;
+	  break;
+	case V4L2_PIX_FMT_PAC207:
+	  v4lconvert_decode_pac207(src, tmpbuf, dest_fmt->fmt.pix.width,
+				    dest_fmt->fmt.pix.height);
+	  bayer_fmt = V4L2_PIX_FMT_SBGGR8;
 	  break;
       }
 
diff -r faf96cf9a97c v4l2-apps/lib/libv4l/libv4lconvert/pac207.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/v4l2-apps/lib/libv4l/libv4lconvert/pac207.c	Thu Jul 03 20:13:42 2008 +0200
@@ -0,0 +1,421 @@
+/*
+
+# PAC207 decoder 
+#               Bertrik.Sikken. Thomas Kaiser (C) 2005
+#               Copyright (C) 2003 2004 2005 Michel Xhaard
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
+
+# Note this code was originally licensed under the GNU GPL instead of the
+# GNU LGPL, its license has been changed with permission, see the permission
+# mails at the end of this file.
+
+*/
+
+#include <string.h>
+#include "libv4lconvert-priv.h"
+
+#define CLIP(color) (unsigned char)(((color)>0xFF)?0xff:(((color)<0)?0:(color)))
+
+/* FIXME not threadsafe */
+static int decoder_initialized = 0;
+
+static struct {
+	unsigned char is_abs;
+	unsigned char len;
+	signed char val;
+} table[256];
+
+void init_pixart_decoder(void)
+{
+    int i;
+    int is_abs, val, len;
+    for (i = 0; i < 256; i++) {
+	is_abs = 0;
+	val = 0;
+	len = 0;
+	if ((i & 0xC0) == 0) {
+	    /* code 00 */
+	    val = 0;
+	    len = 2;
+	} else if ((i & 0xC0) == 0x40) {
+	    /* code 01 */
+	    val = -5;
+	    len = 2;
+	} else if ((i & 0xC0) == 0x80) {
+	    /* code 10 */
+	    val = +5;
+	    len = 2;
+	} else if ((i & 0xF0) == 0xC0) {
+	    /* code 1100 */
+	    val = -10;
+	    len = 4;
+	} else if ((i & 0xF0) == 0xD0) {
+	    /* code 1101 */
+	    val = +10;
+	    len = 4;
+	} else if ((i & 0xF8) == 0xE0) {
+	    /* code 11100 */
+	    val = -15;
+	    len = 5;
+	} else if ((i & 0xF8) == 0xE8) {
+	    /* code 11101 */
+	    val = +15;
+	    len = 5;
+	} else if ((i & 0xFC) == 0xF0) {
+	    /* code 111100 */
+	    val = -20;
+	    len = 6;
+	} else if ((i & 0xFC) == 0xF4) {
+	    /* code 111101 */
+	    val = +20;
+	    len = 6;
+	} else if ((i & 0xF8) == 0xF8) {
+	    /* code 11111xxxxxx */
+	    is_abs = 1;
+	    val = 0;
+	    len = 5;
+	}
+	table[i].is_abs = is_abs;
+	table[i].val = val;
+	table[i].len = len;
+    }
+    decoder_initialized = 1;
+}
+
+static inline unsigned char getByte(const unsigned char *inp,
+				    unsigned int bitpos)
+{
+    const unsigned char *addr;
+    addr = inp + (bitpos >> 3);
+    return (addr[0] << (bitpos & 7)) | (addr[1] >> (8 - (bitpos & 7)));
+}
+
+static inline unsigned short getShort(const unsigned char *pt)
+{
+    return ((pt[0] << 8) | pt[1]);
+}
+
+static int
+pac_decompress_row(const unsigned char *inp, unsigned char *outp, int width)
+{
+    int col;
+    int val;
+    int bitpos;
+    unsigned char code;
+
+    if (!decoder_initialized)
+        init_pixart_decoder();
+
+    /* first two pixels are stored as raw 8-bit */
+    *outp++ = inp[2];
+    *outp++ = inp[3];
+    bitpos = 32;
+
+    /* main decoding loop */
+    for (col = 2; col < width; col++) {
+	/* get bitcode */
+
+	code = getByte(inp, bitpos);
+	bitpos += table[code].len;
+
+	/* calculate pixel value */
+	if (table[code].is_abs) {
+	    /* absolute value: get 6 more bits */
+	    code = getByte(inp, bitpos);
+	    bitpos += 6;
+	    *outp++ = code & 0xFC;
+	} else {
+	    /* relative to left pixel */
+	    val = outp[-2] + table[code].val;
+	    *outp++ = CLIP(val);
+	}
+    }
+
+    /* return line length, rounded up to next 16-bit word */
+    return 2 * ((bitpos + 15) / 16);
+}
+
+void v4lconvert_decode_pac207(const unsigned char *inp, unsigned char *outp,
+  int width, int height)
+{
+/* we should received a whole frame with header and EOL marker
+in myframe->data and return a GBRG pattern in frame->tmpbuffer
+remove the header then copy line by line EOL is set with 0x0f 0xf0 marker
+or 0x1e 0xe1 for compressed line*/
+    unsigned short word;
+    int row;
+
+    /* iterate over all rows */
+    for (row = 0; row < height; row++) {
+	word = getShort(inp);
+	switch (word) {
+	case 0x0FF0:
+	    memcpy(outp, inp + 2, width);
+	    inp += (2 + width);
+	    break;
+	case 0x1EE1:
+	    inp += pac_decompress_row(inp, outp, width);
+	    break;
+
+	default:
+            /* FIXME add error reporting */
+            /* Notice this seems to happen with high framerates (low exposure
+               setting due to much light and bad compressible images, so most
+               likely the usb just cannot keep us and we miss parts of some
+               frames (sometimes of many frames in a row) messing things up
+               completely. It might be worth to try changing the compression
+               balance setting to see if that can compensate for this.
+               However currently I cannot reproduce this (no daylight) */
+	    return;
+	}
+	outp += width;
+    }
+
+    return;
+}
+
+
+
+
+/*
+Return-Path: <thomas@kaiser-linux.li>
+Received: from koko.hhs.nl ([145.52.2.16] verified)
+  by hhs.nl (CommuniGate Pro SMTP 4.3.6)
+  with ESMTP id 88906346 for j.w.r.degoede@hhs.nl; Thu, 26 Jun 2008 01:17:00 +0200
+Received: from exim (helo=koko)
+	by koko.hhs.nl with local-smtp (Exim 4.62)
+	(envelope-from <thomas@kaiser-linux.li>)
+	id 1KBeEW-0001qu-H6
+	for j.w.r.degoede@hhs.nl; Thu, 26 Jun 2008 01:17:00 +0200
+Received: from [192.87.102.74] (port=41049 helo=filter6-ams.mf.surf.net)
+	by koko.hhs.nl with esmtp (Exim 4.62)
+	(envelope-from <thomas@kaiser-linux.li>)
+	id 1KBeEV-0001qn-2T
+	for j.w.r.degoede@hhs.nl; Thu, 26 Jun 2008 01:17:00 +0200
+Received: from smtp0.lie-comtel.li (smtp0.lie-comtel.li [217.173.238.80])
+	by filter6-ams.mf.surf.net (8.13.8/8.13.8/Debian-3) with ESMTP id m5PNGwSF007539
+	for <j.w.r.degoede@hhs.nl>; Thu, 26 Jun 2008 01:16:58 +0200
+Received: from localhost (localhost.lie-comtel.li [127.0.0.1])
+	by smtp0.lie-comtel.li (Postfix) with ESMTP id DDB609FEC1D;
+	Thu, 26 Jun 2008 00:16:56 +0100 (GMT-1)
+X-Virus-Scanned: Virus scanned by amavis at smtp.lie-comtel.li
+Received: from [192.168.0.16] (217-173-228-198.cmts.powersurf.li [217.173.228.198])
+	by smtp0.lie-comtel.li (Postfix) with ESMTP id 80B589FEC19;
+	Thu, 26 Jun 2008 00:16:56 +0100 (GMT-1)
+Message-ID: <4862D211.3000802@kaiser-linux.li>
+Date: Thu, 26 Jun 2008 01:17:37 +0200
+From: Thomas Kaiser <thomas@kaiser-linux.li>
+User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
+MIME-Version: 1.0
+To: Hans de Goede <j.w.r.degoede@hhs.nl>
+CC: Thomas Kaiser <spca5xx@kaiser-linux.li>, bertrik@zonnet.nl,
+        mxhaard@magic.fr
+Subject: Re: pac207 bayer decompression algorithm license question
+References: <4862C0A4.3060003@hhs.nl>
+In-Reply-To: <4862C0A4.3060003@hhs.nl>
+Content-Type: text/plain; charset=ISO-8859-1; format=flowed
+Content-Transfer-Encoding: 7bit
+X-Canit-CHI2: 0.00
+X-Bayes-Prob: 0.0001 (Score 0, tokens from: @@RPTN)
+X-Spam-Score: 0.00 () [Tag at 8.00] 
+X-CanItPRO-Stream: hhs:j.w.r.degoede@hhs.nl (inherits from hhs:default,base:default)
+X-Canit-Stats-ID: 88604132 - 38b3b44cd798
+X-Scanned-By: CanIt (www . roaringpenguin . com) on 192.87.102.74
+X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.2/RELEASE, bases: 25062008 #787666, status: clean
+
+Hello Hans
+
+Hans de Goede wrote:
+> Hi,
+>
+> As you may have seen on the mailinglist, I've created a userspace 
+> library to handle cam specific format handling in userspace where it 
+> belongs, see:
+> http://hansdegoede.livejournal.com/
+Yes, I saw it on the mail list and I think it is a good idea :-)
+>
+> I would like to also add support for decompressing the pac207's 
+> compressed bayer to this lib (and remove it from the kernel driver) 
+> for this I need permission to relicense the decompress code under the 
+> LGPL (version 2 or later).
+Actually, this was done by Bertrik Sikken (bertrik@zonnet.nl), Michel 
+Xhaard (mxhaard@magic.fr) and me. But Bertrik was the one who found out 
+how to decode the lines :-)
+>
+> Can you give me permission for this, or if the code is not yours put 
+> me in contact with someone who can?
+For me it's no problem to release it with LGPL. Maybe you have to ask 
+the other one's also.
+>
+> Thanks & Regards,
+>
+> Hans
+
+Rgeards, Thomas
+*/
+
+/*
+Return-Path: <mxhaard@magic.fr>
+Received: from koko.hhs.nl ([145.52.2.16] verified)
+  by hhs.nl (CommuniGate Pro SMTP 4.3.6)
+  with ESMTP id 88910192 for j.w.r.degoede@hhs.nl; Thu, 26 Jun 2008 09:15:37 +0200
+Received: from exim (helo=koko)
+	by koko.hhs.nl with local-smtp (Exim 4.62)
+	(envelope-from <mxhaard@magic.fr>)
+	id 1KBlhh-0006Fi-Oe
+	for j.w.r.degoede@hhs.nl; Thu, 26 Jun 2008 09:15:37 +0200
+Received: from [194.171.167.220] (port=54180 helo=filter4-til.mf.surf.net)
+	by koko.hhs.nl with esmtp (Exim 4.62)
+	(envelope-from <mxhaard@magic.fr>)
+	id 1KBlhh-0006Fd-FY
+	for j.w.r.degoede@hhs.nl; Thu, 26 Jun 2008 09:15:37 +0200
+Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
+	by filter4-til.mf.surf.net (8.13.8/8.13.8/Debian-3) with ESMTP id m5Q7FY1I006360
+	for <j.w.r.degoede@hhs.nl>; Thu, 26 Jun 2008 09:15:34 +0200
+Received: from smtp4-g19.free.fr (localhost.localdomain [127.0.0.1])
+	by smtp4-g19.free.fr (Postfix) with ESMTP id 51C683EA0E7;
+	Thu, 26 Jun 2008 09:15:34 +0200 (CEST)
+Received: from [192.168.1.11] (lns-bzn-54-82-251-105-53.adsl.proxad.net [82.251.105.53])
+	by smtp4-g19.free.fr (Postfix) with ESMTP id 1149E3EA0C7;
+	Thu, 26 Jun 2008 09:15:34 +0200 (CEST)
+From: Michel Xhaard <mxhaard@magic.fr>
+To: Hans de Goede <j.w.r.degoede@hhs.nl>
+Subject: Re: pac207 bayer decompression algorithm license question
+Date: Thu, 26 Jun 2008 11:15:32 +0200
+User-Agent: KMail/1.9.5
+Cc: bertrik@zonnet.nl, spca5xx@kaiser-linux.li,
+        "Jean-Francois Moine" <moinejf@free.fr>
+References: <48633F02.3040108@hhs.nl>
+In-Reply-To: <48633F02.3040108@hhs.nl>
+MIME-Version: 1.0
+Content-Type: text/plain;
+  charset="iso-8859-1"
+Content-Transfer-Encoding: quoted-printable
+Content-Disposition: inline
+Message-Id: <200806261115.32909.mxhaard@magic.fr>
+X-Canit-CHI2: 0.00
+X-Bayes-Prob: 0.0001 (Score 0, tokens from: @@RPTN)
+X-Spam-Score: 0.00 () [Tag at 8.00] 
+X-CanItPRO-Stream: hhs:j.w.r.degoede@hhs.nl (inherits from hhs:default,base:default)
+X-Canit-Stats-ID: 88656338 - 0dde233cb8b5
+X-Scanned-By: CanIt (www . roaringpenguin . com) on 194.171.167.220
+X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.2/RELEASE, bases: 26062008 #787720, status: clean
+
+Le jeudi 26 juin 2008 09:02, Hans de Goede a =E9crit=A0:
+> Hi,
+>
+> As you may have seen on the mailinglist, I've created a userspace library
+> to handle cam specific format handling in userspace, see:
+> http://hansdegoede.livejournal.com/
+>
+> I would like to also add support for decompressing the pac207's compressed
+> bayer to this lib (and remove it from the kernel driver) and I've heard
+> from Thomas Kaiser that you are a co-author of the decompression code. In
+> order to add support for decompressing pac207 compressed bayer to libv4l I
+> need permission to relicense the decompression code under the LGPL (versi=
+on
+> 2 or later).
+>
+> Can you give me permission for this?
+>
+> Thanks & Regards,
+>
+> Hans
+>
+>
+>
+> p.s.
+>
+> Thomas has already given permission.
+
+=46or me it is ok and a good idea for all free world familly ;-).
+Bests regards
+=2D-=20
+Michel Xhaard
+http://mxhaard.free.fr
+*/
+
+/*
+Return-Path: <bertrik@sikken.nl>
+Received: from koko.hhs.nl ([145.52.2.16] verified)
+  by hhs.nl (CommuniGate Pro SMTP 4.3.6)
+  with ESMTP id 88940205 for j.w.r.degoede@hhs.nl; Thu, 26 Jun 2008 22:03:30 +0200
+Received: from exim (helo=koko)
+	by koko.hhs.nl with local-smtp (Exim 4.62)
+	(envelope-from <bertrik@sikken.nl>)
+	id 1KBxgo-0003Dj-ET
+	for j.w.r.degoede@hhs.nl; Thu, 26 Jun 2008 22:03:30 +0200
+Received: from [192.87.102.69] (port=51992 helo=filter1-ams.mf.surf.net)
+	by koko.hhs.nl with esmtp (Exim 4.62)
+	(envelope-from <bertrik@sikken.nl>)
+	id 1KBxgo-0003Dd-5i
+	for j.w.r.degoede@hhs.nl; Thu, 26 Jun 2008 22:03:30 +0200
+Received: from pelian.kabelfoon.nl (pelian3.kabelfoon.nl [62.45.45.106])
+	by filter1-ams.mf.surf.net (8.13.8/8.13.8/Debian-3) with ESMTP id m5QK3ThE007720
+	for <j.w.r.degoede@hhs.nl>; Thu, 26 Jun 2008 22:03:29 +0200
+Received: from [192.168.1.1] (062-015-045-062.dynamic.caiway.nl [62.45.15.62])
+	by pelian.kabelfoon.nl (Postfix) with ESMTP id 9239B428100
+	for <j.w.r.degoede@hhs.nl>; Thu, 26 Jun 2008 22:03:29 +0200 (CEST)
+Message-ID: <4863F611.80104@sikken.nl>
+Date: Thu, 26 Jun 2008 22:03:29 +0200
+From: Bertrik Sikken <bertrik@sikken.nl>
+User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
+MIME-Version: 1.0
+To: Hans de Goede <j.w.r.degoede@hhs.nl>
+Subject: Re: pac207 bayer decompression algorithm license question
+References: <48633F02.3040108@hhs.nl>
+In-Reply-To: <48633F02.3040108@hhs.nl>
+X-Enigmail-Version: 0.95.6
+Content-Type: text/plain; charset=ISO-8859-1; format=flowed
+Content-Transfer-Encoding: 7bit
+X-Canit-CHI2: 0.00
+X-Bayes-Prob: 0.0001 (Score 0, tokens from: @@RPTN)
+X-Spam-Score: 0.00 () [Tag at 8.00] 
+X-CanItPRO-Stream: hhs:j.w.r.degoede@hhs.nl (inherits from hhs:default,base:default)
+X-Canit-Stats-ID: 88938005 - ef1f0836ffc7
+X-Scanned-By: CanIt (www . roaringpenguin . com) on 192.87.102.69
+X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.2/RELEASE, bases: 26062008 #787877, status: clean
+
+Hallo Hans,
+
+Hans de Goede wrote:
+> Hi,
+> 
+> As you may have seen on the mailinglist, I've created a userspace 
+> library to
+> handle cam specific format handling in userspace, see:
+> http://hansdegoede.livejournal.com/
+
+O leuk, zoiets is naar mijn idee precies wat er nodig is voor webcam
+support onder linux. Ik ben een jaar of 3 geleden heel actief geweest
+met een aantal webcams, maar doe er tegenwoordig helemaal niets meer
+aan.
+
+> I would like to also add support for decompressing the pac207's compressed
+> bayer to this lib (and remove it from the kernel driver) and I've heard 
+> from Thomas Kaiser that you are a co-author of the decompression code. 
+> In order to add support for decompressing pac207 compressed bayer to 
+> libv4l I need
+> permission to relicense the decompression code under the LGPL (version 2 
+> or later).
+> 
+> Can you give me permission for this?
+
+Ja, vind ik goed.
+
+Vriendelijke groet,
+Bertrik
+*/

--------------040000010503010200010107
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------040000010503010200010107--
