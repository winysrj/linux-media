Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60850 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab2FWQh2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jun 2012 12:37:28 -0400
Received: by mail-bk0-f46.google.com with SMTP id ji2so2283417bkc.19
        for <linux-media@vger.kernel.org>; Sat, 23 Jun 2012 09:37:28 -0700 (PDT)
From: Gregor Jasny <gjasny@googlemail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Gregor Jasny <gjasny@googlemail.com>
Subject: [PATCH 2/3] keytable: Preinstall keytables relative to sysconfdir
Date: Sat, 23 Jun 2012 18:36:46 +0200
Message-Id: <1340469407-25580-3-git-send-email-gjasny@googlemail.com>
In-Reply-To: <1340469407-25580-1-git-send-email-gjasny@googlemail.com>
References: <1340469407-25580-1-git-send-email-gjasny@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Gregor Jasny <gjasny@googlemail.com>
---
 configure.ac               |    5 +++--
 utils/keytable/Makefile.am |    5 ++---
 utils/keytable/keytable.c  |    7 ++-----
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/configure.ac b/configure.ac
index 1a12abd..661eb20 100644
--- a/configure.ac
+++ b/configure.ac
@@ -153,7 +153,7 @@ libv4l2privdir="$libdir/$libv4l2subdir"
 libv4l2plugindir="$libv4l2privdir/plugins"
 libv4lconvertprivdir="$libdir/$libv4lconvertsubdir"
 
-rootetcdir="/etc"
+keytablesystemdir="$sysconfdir/rc_keymaps"
 udevrulesdir="$udevdir/rules.d"
 pkgconfigdir="$libdir/pkgconfig"
 
@@ -161,7 +161,7 @@ AC_SUBST(libv4l1privdir)
 AC_SUBST(libv4l2privdir)
 AC_SUBST(libv4l2plugindir)
 AC_SUBST(libv4lconvertprivdir)
-AC_SUBST(rootetcdir)
+AC_SUBST(keytablesystemdir)
 AC_SUBST(udevrulesdir)
 AC_SUBST(pkgconfigdir)
 
@@ -170,6 +170,7 @@ AC_DEFINE_DIR([LIBV4L1_PRIV_DIR], [libv4l1privdir], [libv4l1 private lib directo
 AC_DEFINE_DIR([LIBV4L2_PRIV_DIR], [libv4l2privdir], [libv4l2 private lib directory])
 AC_DEFINE_DIR([LIBV4L2_PLUGIN_DIR], [libv4l2plugindir], [libv4l2 plugin directory])
 AC_DEFINE_DIR([LIBV4LCONVERT_PRIV_DIR], [libv4lconvertprivdir], [libv4lconvert private lib directory])
+AC_DEFINE_DIR([IR_KEYTABLE_SYSTEM_DIR], [keytablesystemdir], [ir-keytable preinstalled tables directory])
 
 # options
 
diff --git a/utils/keytable/Makefile.am b/utils/keytable/Makefile.am
index 3d510e0..4505fc1 100644
--- a/utils/keytable/Makefile.am
+++ b/utils/keytable/Makefile.am
@@ -1,8 +1,7 @@
-rootetcdir="/etc"
-
 bin_PROGRAMS = ir-keytable
 man_MANS = ir-keytable.1
-nobase_rootetc_DATA = rc_maps.cfg $(srcdir)/rc_keymaps/*
+sysconf_DATA = rc_maps.cfg
+keytablesystem_DATA = $(srcdir)/rc_keymaps/*
 udevrules_DATA = 70-infrared.rules
 
 ir_keytable_SOURCES = keytable.c parse.h
diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index fbf9c03..31376f3 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -28,9 +28,6 @@
 
 #include "parse.h"
 
-/* Default place where the keymaps will be stored */
-#define CFGDIR "/etc/rc_keymaps"
-
 struct input_keymap_entry_v2 {
 #define KEYMAP_BY_INDEX	(1 << 0)
 	u_int8_t  flags;
@@ -1516,8 +1513,8 @@ int main(int argc, char *argv[])
 		if (cur->fname[0] == '/' || ((cur->fname[0] == '.') && strchr(cur->fname, '/'))) {
 			fname = cur->fname;
 		} else {
-			fname = malloc(strlen(cur->fname) + strlen(CFGDIR) + 2);
-			strcpy(fname, CFGDIR);
+			fname = malloc(strlen(cur->fname) + strlen(IR_KEYTABLE_SYSTEM_DIR) + 2);
+			strcpy(fname, IR_KEYTABLE_SYSTEM_DIR);
 			strcat(fname, "/");
 			strcat(fname, cur->fname);
 		}
-- 
1.7.10

