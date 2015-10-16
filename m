Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:51275 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbbJPS0B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2015 14:26:01 -0400
Received: from linux.local ([178.10.176.231]) by mail.gmx.com (mrgmx103) with
 ESMTPSA (Nemesis) id 0MDzGN-1ZmObZ2xl1-00HSUY for
 <linux-media@vger.kernel.org>; Fri, 16 Oct 2015 20:25:58 +0200
From: Peter Seiderer <ps.report@gmx.net>
To: linux-media@vger.kernel.org
Subject: [PATCH v1] dvb/keytable: fix libintl linking
Date: Fri, 16 Oct 2015 20:25:57 +0200
Message-Id: <1445019957-31061-1-git-send-email-ps.report@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix libintl linking for uclibc (see [1] for details).

[1] http://lists.busybox.net/pipermail/buildroot/2015-October/142032.html

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
---
 utils/dvb/Makefile.am      | 8 ++++----
 utils/keytable/Makefile.am | 1 +
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/utils/dvb/Makefile.am b/utils/dvb/Makefile.am
index 6aae408..a96a1a2 100644
--- a/utils/dvb/Makefile.am
+++ b/utils/dvb/Makefile.am
@@ -2,19 +2,19 @@ bin_PROGRAMS = dvb-fe-tool dvbv5-zap dvbv5-scan dvb-format-convert
 man_MANS = dvb-fe-tool.1 dvbv5-zap.1 dvbv5-scan.1 dvb-format-convert.1
 
 dvb_fe_tool_SOURCES = dvb-fe-tool.c
-dvb_fe_tool_LDADD = ../../lib/libdvbv5/libdvbv5.la
+dvb_fe_tool_LDADD = ../../lib/libdvbv5/libdvbv5.la @LIBINTL@
 dvb_fe_tool_LDFLAGS = $(ARGP_LIBS) -lm
 
 dvbv5_zap_SOURCES = dvbv5-zap.c
-dvbv5_zap_LDADD = ../../lib/libdvbv5/libdvbv5.la
+dvbv5_zap_LDADD = ../../lib/libdvbv5/libdvbv5.la @LIBINTL@
 dvbv5_zap_LDFLAGS = $(ARGP_LIBS) -lm
 
 dvbv5_scan_SOURCES = dvbv5-scan.c
-dvbv5_scan_LDADD = ../../lib/libdvbv5/libdvbv5.la
+dvbv5_scan_LDADD = ../../lib/libdvbv5/libdvbv5.la @LIBINTL@
 dvbv5_scan_LDFLAGS = $(ARGP_LIBS) -lm
 
 dvb_format_convert_SOURCES = dvb-format-convert.c
-dvb_format_convert_LDADD = ../../lib/libdvbv5/libdvbv5.la
+dvb_format_convert_LDADD = ../../lib/libdvbv5/libdvbv5.la @LIBINTL@
 dvb_format_convert_LDFLAGS = $(ARGP_LIBS) -lm
 
 EXTRA_DIST = README
diff --git a/utils/keytable/Makefile.am b/utils/keytable/Makefile.am
index 925c8ea..8444ac2 100644
--- a/utils/keytable/Makefile.am
+++ b/utils/keytable/Makefile.am
@@ -5,6 +5,7 @@ keytablesystem_DATA = $(srcdir)/rc_keymaps/*
 udevrules_DATA = 70-infrared.rules
 
 ir_keytable_SOURCES = keytable.c parse.h
+ir_keytable_LDADD = @LIBINTL@
 ir_keytable_LDFLAGS = $(ARGP_LIBS)
 
 EXTRA_DIST = 70-infrared.rules rc_keymaps rc_keymaps_userspace gen_keytables.pl ir-keytable.1 rc_maps.cfg
-- 
2.1.4

