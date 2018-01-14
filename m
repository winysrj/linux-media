Return-path: <linux-media-owner@vger.kernel.org>
Received: from avasout04.plus.net ([212.159.14.19]:53262 "EHLO
        avasout04.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752010AbeANUXa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 14 Jan 2018 15:23:30 -0500
From: Chris Mayo <aklhfex@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] [v4l-utils] sdlcam: Only build if using libjpeg
Date: Sun, 14 Jan 2018 20:15:57 +0000
Message-Id: <20180114201557.23077-1-aklhfex@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Chris Mayo <aklhfex@gmail.com>
---

Otherwise build fails on linking:

libtool: link: x86_64-pc-linux-gnu-gcc -march=ivybridge -ftree-vectorize -O2 -pipe -Wl,-O1 -Wl,--as-needed -Wl,--hash-style=gnu -o pixfmt-test pixfmt_test-pixfmt-test.o  -lX11
/usr/lib/gcc/x86_64-pc-linux-gnu/6.4.0/../../../../x86_64-pc-linux-gnu/bin/ld: sdlcam-sdlcam.o: undefined reference to symbol 'jpeg_set_quality@@LIBJPEG_6.2'
/usr/lib64/libjpeg.so.62: error adding symbols: DSO missing from command line
collect2: error: ld returned 1 exit status
make[3]: *** [Makefile:558: sdlcam] Error 1

Affects released v4l-utils-1.14.1.

 contrib/test/Makefile.am | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/contrib/test/Makefile.am b/contrib/test/Makefile.am
index 0188fe214..c7c38e7a6 100644
--- a/contrib/test/Makefile.am
+++ b/contrib/test/Makefile.am
@@ -17,8 +17,10 @@ noinst_PROGRAMS += v4l2gl
 endif
 
 if HAVE_SDL
+if HAVE_JPEG
 noinst_PROGRAMS += sdlcam
 endif
+endif
 
 driver_test_SOURCES = driver-test.c
 driver_test_LDADD = ../../utils/libv4l2util/libv4l2util.la
-- 
2.13.6
