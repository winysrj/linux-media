Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:44592 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755339AbbKCU6t (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Nov 2015 15:58:49 -0500
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Peter Seiderer <ps.report@gmx.net>
Subject: [v4l-utils 5/5] dvb/keytable: fix missing libintl linking
Date: Tue,  3 Nov 2015 21:58:40 +0100
Message-Id: <1446584320-25016-6-git-send-email-thomas.petazzoni@free-electrons.com>
In-Reply-To: <1446584320-25016-1-git-send-email-thomas.petazzoni@free-electrons.com>
References: <1446584320-25016-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Seiderer <ps.report@gmx.net>

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
2.6.2

