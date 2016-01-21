Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:56580 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965006AbcAUJxK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2016 04:53:10 -0500
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: [PATCH v4l-utils] libv4lconvert: only expose jpeg_mem_*() protoypes when JPEG_LIB_VERSION < 80
Date: Thu, 21 Jan 2016 10:53:07 +0100
Message-Id: <1453369987-12428-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The jpeg_memsrcdest.c file implements jpeg_mem_src() and
jpeg_mem_dest() when JPEG_LIB_VERSION < 80 in order to provide those
functions to libv4lconvert when the libjpeg library being used is too
old.

However, the jpeg_memsrcdest.h file exposes the prototypes of those
functions unconditionally. Until now, the prototype was matching the
one of the functions exposed by libjpeg (when JPEG_LIB_VERSION >= 80),
so there was no problem.

But since the release of libjpeg 9b (in January 2016), they changed
the second argument of jpeg_mem_src() from "unsigned char *" to "const
unsigned char*". Therefore, there are two prototypes for the
jpeg_mem_src() function: one from libjpeg, one from libv4l, and they
conflict with each other.

To resolve this situation, this patch modifies jpeg_memsrcdest.h to
only expose the prototypes when libv4l is implementing the functions
(i.e when JPEG_LIB_VERSION < 80). When JPEG_LIB_VERSION >= 80, the
prototypes will come from <jpeglib.h>.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 lib/libv4lconvert/jpeg_memsrcdest.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/libv4lconvert/jpeg_memsrcdest.h b/lib/libv4lconvert/jpeg_memsrcdest.h
index e971182..28a6477 100644
--- a/lib/libv4lconvert/jpeg_memsrcdest.h
+++ b/lib/libv4lconvert/jpeg_memsrcdest.h
@@ -1,5 +1,7 @@
 #include <jpeglib.h>
 
+#if JPEG_LIB_VERSION < 80
+
 void
 jpeg_mem_src (j_decompress_ptr cinfo, unsigned char * buffer,
 	unsigned long bufsize);
@@ -7,3 +9,5 @@ jpeg_mem_src (j_decompress_ptr cinfo, unsigned char * buffer,
 void
 jpeg_mem_dest (j_compress_ptr cinfo, unsigned char ** outbuffer,
 	unsigned long * outsize);
+
+#endif
-- 
2.6.4

