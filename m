Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:19710 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab3HFKTV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Aug 2013 06:19:21 -0400
Received: from bwinther.cisco.com (dhcp-10-54-92-83.cisco.com [10.54.92.83])
	by ams-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id r76AJ9nJ014605
	for <linux-media@vger.kernel.org>; Tue, 6 Aug 2013 10:19:17 GMT
From: =?UTF-8?q?B=C3=A5rd=20Eirik=20Winther?= <bwinther@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCHv2 4/5] qv4l2: add ALSA stream to qv4l2
Date: Tue,  6 Aug 2013 12:18:45 +0200
Message-Id: <bc6c13e4bdb1e063ce51e5140a3330c969fecd58.1375784295.git.bwinther@cisco.com>
In-Reply-To: <1375784326-18572-1-git-send-email-bwinther@cisco.com>
References: <1375784326-18572-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <1a734456df06299e284f793264ca843c98b0f18a.1375784295.git.bwinther@cisco.com>
References: <1a734456df06299e284f793264ca843c98b0f18a.1375784295.git.bwinther@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes the ALSA streaming code to work with qv4l2 and allows it to
be compiled in. qv4l2 does not use the streaming function yet.

Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
---
 configure.ac              |  7 +++++++
 utils/qv4l2/Makefile.am   |  8 ++++++--
 utils/qv4l2/alsa_stream.c | 28 ++++++++++++++++++++++++----
 utils/qv4l2/alsa_stream.h | 13 ++++++++++---
 4 files changed, 47 insertions(+), 9 deletions(-)

diff --git a/configure.ac b/configure.ac
index d74da61..5a0bb5f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -136,6 +136,13 @@ if test "x$qt_pkgconfig_gl" = "xfalse"; then
    AC_MSG_WARN(Qt4 OpenGL or higher is not available)
 fi
 
+PKG_CHECK_MODULES(ALSA, [alsa], [alsa_pkgconfig=true], [alsa_pkgconfig=false])
+if test "x$alsa_pkgconfig" = "xtrue"; then
+   AC_DEFINE([HAVE_ALSA], [1], [alsa library is present])
+else
+   AC_MSG_WARN(ALSA library not available)
+fi
+
 AC_SUBST([JPEG_LIBS])
 
 # The dlopen() function is in the C library for *BSD and in
diff --git a/utils/qv4l2/Makefile.am b/utils/qv4l2/Makefile.am
index 22d4c17..3aed18c 100644
--- a/utils/qv4l2/Makefile.am
+++ b/utils/qv4l2/Makefile.am
@@ -1,10 +1,11 @@
 bin_PROGRAMS = qv4l2
 
 qv4l2_SOURCES = qv4l2.cpp general-tab.cpp ctrl-tab.cpp vbi-tab.cpp v4l2-api.cpp capture-win.cpp \
-  capture-win-qt.cpp capture-win-qt.h capture-win-gl.cpp capture-win-gl.h \
+  capture-win-qt.cpp capture-win-qt.h capture-win-gl.cpp capture-win-gl.h alsa_stream.c alsa_stream.h \
   raw2sliced.cpp qv4l2.h capture-win.h general-tab.h vbi-tab.h v4l2-api.h raw2sliced.h
 nodist_qv4l2_SOURCES = moc_qv4l2.cpp moc_general-tab.cpp moc_capture-win.cpp moc_vbi-tab.cpp qrc_qv4l2.cpp
-qv4l2_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la ../libv4l2util/libv4l2util.la
+qv4l2_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la ../libv4l2util/libv4l2util.la \
+  ../libmedia_dev/libmedia_dev.la
 
 if WITH_QV4L2_GL
 qv4l2_CPPFLAGS = $(QTGL_CFLAGS) -DENABLE_GL
@@ -14,6 +15,9 @@ qv4l2_CPPFLAGS = $(QT_CFLAGS)
 qv4l2_LDFLAGS = $(QT_LIBS)
 endif
 
+qv4l2_CPPFLAGS += $(ALSA_CFLAGS)
+qv4l2_LDFLAGS += $(ALSA_LIBS) -pthread
+
 EXTRA_DIST = exit.png fileopen.png qv4l2_24x24.png qv4l2_64x64.png qv4l2.png qv4l2.svg snapshot.png \
   video-television.png fileclose.png qv4l2_16x16.png qv4l2_32x32.png qv4l2.desktop qv4l2.qrc record.png \
   saveraw.png qv4l2.pro
diff --git a/utils/qv4l2/alsa_stream.c b/utils/qv4l2/alsa_stream.c
index fbff4cb..dd01d1a 100644
--- a/utils/qv4l2/alsa_stream.c
+++ b/utils/qv4l2/alsa_stream.c
@@ -26,9 +26,10 @@
  *
  */
 
-#include "config.h"
+#include <config.h>
 
-#ifdef HAVE_ALSA_ASOUNDLIB_H
+#ifdef HAVE_ALSA
+#include "alsa_stream.h"
 
 #include <stdio.h>
 #include <stdlib.h>
@@ -40,12 +41,12 @@
 #include <alsa/asoundlib.h>
 #include <sys/time.h>
 #include <math.h>
-#include "alsa_stream.h"
 
 #define ARRAY_SIZE(a) (sizeof(a)/sizeof(*(a)))
 
 /* Private vars to control alsa thread status */
 static int stop_alsa = 0;
+static snd_htimestamp_t timestamp;
 
 /* Error handlers */
 snd_output_t *output = NULL;
@@ -202,6 +203,13 @@ static int setparams_set(snd_pcm_t *handle,
 		id, snd_strerror(err));
 	return err;
     }
+
+    err = snd_pcm_sw_params_set_tstamp_mode(handle, swparams, SND_PCM_TSTAMP_ENABLE);
+    if (err < 0) {
+	fprintf(error_fp, "alsa: Unable to enable timestamps for %s: %s\n",
+		id, snd_strerror(err));
+    }
+
     err = snd_pcm_sw_params(handle, swparams);
     if (err < 0) {
 	fprintf(error_fp, "alsa: Unable to set sw params for %s: %s\n",
@@ -422,7 +430,8 @@ static int setparams(snd_pcm_t *phandle, snd_pcm_t *chandle,
 static snd_pcm_sframes_t readbuf(snd_pcm_t *handle, char *buf, long len)
 {
     snd_pcm_sframes_t r;
-
+    snd_pcm_uframes_t frames;
+    snd_pcm_htimestamp(handle, &frames, &timestamp);
     r = snd_pcm_readi(handle, buf, len);
     if (r < 0 && r != -EAGAIN) {
 	r = snd_pcm_recover(handle, r, 0);
@@ -453,6 +462,7 @@ static snd_pcm_sframes_t writebuf(snd_pcm_t *handle, char *buf, long len)
 	len -= r;
 	snd_pcm_wait(handle, 100);
     }
+    return -1;
 }
 
 static int alsa_stream(const char *pdevice, const char *cdevice, int latency)
@@ -642,4 +652,14 @@ int alsa_thread_is_running(void)
     return alsa_is_running;
 }
 
+void alsa_thread_timestamp(struct timeval *tv)
+{
+	if (alsa_thread_is_running()) {
+		tv->tv_sec = timestamp.tv_sec;
+		tv->tv_usec = timestamp.tv_nsec / 1000;
+	} else {
+		tv->tv_sec = 0;
+		tv->tv_usec = 0;
+	}
+}
 #endif
diff --git a/utils/qv4l2/alsa_stream.h b/utils/qv4l2/alsa_stream.h
index c68fd6d..b736ec3 100644
--- a/utils/qv4l2/alsa_stream.h
+++ b/utils/qv4l2/alsa_stream.h
@@ -1,5 +1,12 @@
-int alsa_thread_startup(const char *pdevice, const char *cdevice, int latency,
-			FILE *__error_fp,
-			int __verbose);
+#ifndef ALSA_STREAM_H
+#define ALSA_STREAM_H
+
+#include <stdio.h>
+#include <sys/time.h>
+
+int alsa_thread_startup(const char *pdevice, const char *cdevice,
+			int latency, FILE *__error_fp, int __verbose);
 void alsa_thread_stop(void);
 int alsa_thread_is_running(void);
+void alsa_thread_timestamp(struct timeval *tv);
+#endif
-- 
1.8.3.2

