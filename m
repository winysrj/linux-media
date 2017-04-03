Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:60851 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751829AbdDCLxs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Apr 2017 07:53:48 -0400
From: Ismo Puustinen <ismo.puustinen@intel.com>
To: linux-media@vger.kernel.org
Cc: Ismo Puustinen <ismo.puustinen@intel.com>
Subject: [PATCH v4l-utils] buildsystem: do not assume building in source tree.
Date: Mon,  3 Apr 2017 14:53:37 +0300
Message-Id: <20170403115337.26585-1-ismo.puustinen@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use $(top_srcdir) as reference for include paths and buildtime scripts.
Otherwise compilation outside of project root directory will fail
because header and script paths are wrong.

To reproduce: mkdir b; cd b; ../configure; make

Signed-off-by: Ismo Puustinen <ismo.puustinen@intel.com>
---
 utils/cec-compliance/Makefile.am  | 2 +-
 utils/cec-ctl/Makefile.am         | 2 +-
 utils/cec-follower/Makefile.am    | 4 ++--
 utils/qv4l2/Makefile.am           | 2 +-
 utils/v4l2-compliance/Makefile.am | 2 +-
 utils/v4l2-ctl/Makefile.am        | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/utils/cec-compliance/Makefile.am b/utils/cec-compliance/Makefile.am
index ec5de51..8331aa0 100644
--- a/utils/cec-compliance/Makefile.am
+++ b/utils/cec-compliance/Makefile.am
@@ -7,7 +7,7 @@ cec_compliance_LDFLAGS = -lrt
 cec-compliance.cpp: cec-table.h
 
 cec-table.h: ../cec-ctl/msg2ctl.pl ../../include/linux/cec.h ../../include/linux/cec-funcs.h
-	../cec-ctl/msg2ctl.pl 2 ../../include/linux/cec.h ../../include/linux/cec-funcs.h >$@
+	$(top_srcdir)/utils/cec-ctl/msg2ctl.pl 2 $(top_srcdir)/include/linux/cec.h $(top_srcdir)/include/linux/cec-funcs.h >$@
 
 cec-compliance.cpp: version.h
 
diff --git a/utils/cec-ctl/Makefile.am b/utils/cec-ctl/Makefile.am
index 0a7ef22..6afb6c9 100644
--- a/utils/cec-ctl/Makefile.am
+++ b/utils/cec-ctl/Makefile.am
@@ -7,7 +7,7 @@ cec_ctl_LDFLAGS = -lrt
 cec-ctl.cpp: cec-ctl-gen.h
 
 cec-ctl-gen.h: msg2ctl.pl ../../include/linux/cec.h ../../include/linux/cec-funcs.h
-	./msg2ctl.pl 0 ../../include/linux/cec.h ../../include/linux/cec-funcs.h >$@
+	$(top_srcdir)/utils/cec-ctl/msg2ctl.pl 0 $(top_srcdir)/include/linux/cec.h $(top_srcdir)/include/linux/cec-funcs.h >$@
 
 clean-local:
 	-rm -vf cec-ctl-gen.h
diff --git a/utils/cec-follower/Makefile.am b/utils/cec-follower/Makefile.am
index 538edb2..fdbf3d9 100644
--- a/utils/cec-follower/Makefile.am
+++ b/utils/cec-follower/Makefile.am
@@ -7,12 +7,12 @@ cec_follower_LDFLAGS = -lrt
 cec-log.cpp: cec-log.h
 
 cec-log.h: ../cec-ctl/msg2ctl.pl ../../include/linux/cec.h ../../include/linux/cec-funcs.h
-	../cec-ctl/msg2ctl.pl 1 ../../include/linux/cec.h ../../include/linux/cec-funcs.h >$@
+	$(top_srcdir)/utils/cec-ctl/msg2ctl.pl 1 $(top_srcdir)/include/linux/cec.h $(top_srcdir)/include/linux/cec-funcs.h >$@
 
 cec-follower.cpp: cec-table.h version.h
 
 cec-table.h: ../cec-ctl/msg2ctl.pl ../../include/linux/cec.h ../../include/linux/cec-funcs.h
-	../cec-ctl/msg2ctl.pl 2 ../../include/linux/cec.h ../../include/linux/cec-funcs.h >$@
+	$(top_srcdir)/utils/cec-ctl/msg2ctl.pl 2 $(top_srcdir)/include/linux/cec.h $(top_srcdir)/include/linux/cec-funcs.h >$@
 
 version.h:
 	@if git rev-parse HEAD >/dev/null 2>&1; then \
diff --git a/utils/qv4l2/Makefile.am b/utils/qv4l2/Makefile.am
index fd58486..ccd1a2a 100644
--- a/utils/qv4l2/Makefile.am
+++ b/utils/qv4l2/Makefile.am
@@ -8,7 +8,7 @@ qv4l2_SOURCES = qv4l2.cpp general-tab.cpp ctrl-tab.cpp vbi-tab.cpp capture-win.c
 nodist_qv4l2_SOURCES = moc_qv4l2.cpp moc_general-tab.cpp moc_capture-win.cpp moc_vbi-tab.cpp qrc_qv4l2.cpp
 qv4l2_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la \
   ../libv4l2util/libv4l2util.la ../libmedia_dev/libmedia_dev.la
-qv4l2_CPPFLAGS = -I../common
+qv4l2_CPPFLAGS = -I$(top_srcdir)/utils/common
 
 if WITH_QTGL
 qv4l2_CPPFLAGS += $(QTGL_CFLAGS)
diff --git a/utils/v4l2-compliance/Makefile.am b/utils/v4l2-compliance/Makefile.am
index 03db8df..18b9892 100644
--- a/utils/v4l2-compliance/Makefile.am
+++ b/utils/v4l2-compliance/Makefile.am
@@ -5,7 +5,7 @@ DEFS :=
 v4l2_compliance_SOURCES = v4l2-compliance.cpp v4l2-test-debug.cpp v4l2-test-input-output.cpp \
 	v4l2-test-controls.cpp v4l2-test-io-config.cpp v4l2-test-formats.cpp v4l2-test-buffers.cpp \
 	v4l2-test-codecs.cpp v4l2-test-colors.cpp v4l2-compliance.h
-v4l2_compliance_CPPFLAGS = -I../common
+v4l2_compliance_CPPFLAGS = -I$(top_srcdir)/utils/common
 
 if WITH_V4L2_COMPLIANCE_LIBV4L
 v4l2_compliance_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la -lrt -lpthread
diff --git a/utils/v4l2-ctl/Makefile.am b/utils/v4l2-ctl/Makefile.am
index 955647d..825e53f 100644
--- a/utils/v4l2-ctl/Makefile.am
+++ b/utils/v4l2-ctl/Makefile.am
@@ -7,7 +7,7 @@ v4l2_ctl_SOURCES = v4l2-ctl.cpp v4l2-ctl.h v4l2-ctl-common.cpp v4l2-ctl-tuner.cp
 	v4l2-ctl-overlay.cpp v4l2-ctl-vbi.cpp v4l2-ctl-selection.cpp v4l2-ctl-misc.cpp \
 	v4l2-ctl-streaming.cpp v4l2-ctl-sdr.cpp v4l2-ctl-edid.cpp v4l2-ctl-modes.cpp \
 	v4l2-tpg-colors.c v4l2-tpg-core.c v4l-stream.c
-v4l2_ctl_CPPFLAGS = -I../common
+v4l2_ctl_CPPFLAGS = -I$(top_srcdir)/utils/common
 
 if WITH_V4L2_CTL_LIBV4L
 v4l2_ctl_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la -lrt -lpthread
-- 
2.9.3
