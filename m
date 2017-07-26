Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:58147 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751563AbdGZMvu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Jul 2017 08:51:50 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Gregor Jasny <gjasny@googlemail.com>,
        Christophe Priouzeau <christophe.priouzeau@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: [PATCH v2] Build libv4lconvert helper support only when fork() is available
Date: Wed, 26 Jul 2017 14:51:24 +0200
Message-ID: <1501073484-9193-2-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1501073484-9193-1-git-send-email-hugues.fruchet@st.com>
References: <1501073484-9193-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 configure.ac                      | 3 +++
 lib/libv4lconvert/Makefile.am     | 7 ++++++-
 lib/libv4lconvert/libv4lconvert.c | 6 ++++++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index ae8f2e2..72c9421 100644
--- a/configure.ac
+++ b/configure.ac
@@ -299,6 +299,9 @@ argp_saved_libs=$LIBS
   AC_SUBST([ARGP_LIBS])
 LIBS=$argp_saved_libs
 
+AC_CHECK_FUNCS([fork], AC_DEFINE([HAVE_LIBV4LCONVERT_HELPERS],[1],[whether to use libv4lconvert helpers]))
+AM_CONDITIONAL([HAVE_LIBV4LCONVERT_HELPERS], [test x$ac_cv_func_fork = xyes])
+
 AC_CHECK_HEADER([linux/i2c-dev.h], [linux_i2c_dev=yes], [linux_i2c_dev=no])
 AM_CONDITIONAL([HAVE_LINUX_I2C_DEV], [test x$linux_i2c_dev = xyes])
 
diff --git a/lib/libv4lconvert/Makefile.am b/lib/libv4lconvert/Makefile.am
index 4f332fa..f266f3e 100644
--- a/lib/libv4lconvert/Makefile.am
+++ b/lib/libv4lconvert/Makefile.am
@@ -1,6 +1,8 @@
 if WITH_DYN_LIBV4L
 lib_LTLIBRARIES = libv4lconvert.la
+if HAVE_LIBV4LCONVERT_HELPERS
 libv4lconvertpriv_PROGRAMS = ov511-decomp ov518-decomp
+endif
 include_HEADERS = ../include/libv4lconvert.h
 pkgconfig_DATA = libv4lconvert.pc
 LIBV4LCONVERT_VERSION = -version-info 0
@@ -16,11 +18,14 @@ libv4lconvert_la_SOURCES = \
   control/libv4lcontrol.c control/libv4lcontrol.h control/libv4lcontrol-priv.h \
   processing/libv4lprocessing.c processing/whitebalance.c processing/autogain.c \
   processing/gamma.c processing/libv4lprocessing.h processing/libv4lprocessing-priv.h \
-  helper.c helper-funcs.h libv4lconvert-priv.h libv4lsyscall-priv.h \
+  helper-funcs.h libv4lconvert-priv.h libv4lsyscall-priv.h \
   tinyjpeg.h tinyjpeg-internal.h
 if HAVE_JPEG
 libv4lconvert_la_SOURCES += jpeg_memsrcdest.c jpeg_memsrcdest.h
 endif
+if HAVE_LIBV4LCONVERT_HELPERS
+libv4lconvert_la_SOURCES += helper.c
+endif
 libv4lconvert_la_CPPFLAGS = $(CFLAG_VISIBILITY) $(ENFORCE_LIBV4L_STATIC)
 libv4lconvert_la_LDFLAGS = $(LIBV4LCONVERT_VERSION) -lrt -lm $(JPEG_LIBS) $(ENFORCE_LIBV4L_STATIC)
 
diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
index d60774e..1a5ccec 100644
--- a/lib/libv4lconvert/libv4lconvert.c
+++ b/lib/libv4lconvert/libv4lconvert.c
@@ -122,8 +122,10 @@ static const struct v4lconvert_pixfmt supported_src_pixfmts[] = {
 	{ V4L2_PIX_FMT_JPEG,		 0,	 7,	 7,	0 },
 	{ V4L2_PIX_FMT_PJPG,		 0,	 7,	 7,	1 },
 	{ V4L2_PIX_FMT_JPGL,		 0,	 7,	 7,	1 },
+#ifdef HAVE_LIBV4LCONVERT_HELPERS
 	{ V4L2_PIX_FMT_OV511,		 0,	 7,	 7,	1 },
 	{ V4L2_PIX_FMT_OV518,		 0,	 7,	 7,	1 },
+#endif
 	/* uncompressed bayer */
 	{ V4L2_PIX_FMT_SBGGR8,		 8,	 8,	 8,	0 },
 	{ V4L2_PIX_FMT_SGBRG8,		 8,	 8,	 8,	0 },
@@ -278,7 +280,9 @@ void v4lconvert_destroy(struct v4lconvert_data *data)
 	if (data->cinfo_initialized)
 		jpeg_destroy_decompress(&data->cinfo);
 #endif // HAVE_JPEG
+#ifdef HAVE_LIBV4LCONVERT_HELPERS
 	v4lconvert_helper_cleanup(data);
+#endif
 	free(data->convert1_buf);
 	free(data->convert2_buf);
 	free(data->rotate90_buf);
@@ -833,6 +837,7 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
 				return -1;
 			}
 			break;
+#ifdef HAVE_LIBV4LCONVERT_HELPERS
 		case V4L2_PIX_FMT_OV511:
 			if (v4lconvert_helper_decompress(data, LIBV4LCONVERT_PRIV_DIR "/ov511-decomp",
 						src, src_size, d, d_size, width, height, yvu)) {
@@ -849,6 +854,7 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
 				return -1;
 			}
 			break;
+#endif
 		}
 
 		switch (dest_pix_fmt) {
-- 
1.9.1
