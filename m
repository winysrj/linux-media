Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60850 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab2FWQha (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jun 2012 12:37:30 -0400
Received: by mail-bk0-f46.google.com with SMTP id ji2so2283417bkc.19
        for <linux-media@vger.kernel.org>; Sat, 23 Jun 2012 09:37:30 -0700 (PDT)
From: Gregor Jasny <gjasny@googlemail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Gregor Jasny <gjasny@googlemail.com>
Subject: [PATCH 3/3] keytable: first search table in userdir, then in systemdir
Date: Sat, 23 Jun 2012 18:36:47 +0200
Message-Id: <1340469407-25580-4-git-send-email-gjasny@googlemail.com>
In-Reply-To: <1340469407-25580-1-git-send-email-gjasny@googlemail.com>
References: <1340469407-25580-1-git-send-email-gjasny@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Gregor Jasny <gjasny@googlemail.com>
---
 configure.ac               |    5 ++++-
 utils/keytable/Makefile.am |    2 ++
 utils/keytable/keytable.c  |   27 +++++++++++++++++++++------
 3 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/configure.ac b/configure.ac
index 661eb20..a1230b2 100644
--- a/configure.ac
+++ b/configure.ac
@@ -153,7 +153,8 @@ libv4l2privdir="$libdir/$libv4l2subdir"
 libv4l2plugindir="$libv4l2privdir/plugins"
 libv4lconvertprivdir="$libdir/$libv4lconvertsubdir"
 
-keytablesystemdir="$sysconfdir/rc_keymaps"
+keytablesystemdir="$udevdir/rc_keymaps"
+keytableuserdir="$sysconfdir/rc_keymaps"
 udevrulesdir="$udevdir/rules.d"
 pkgconfigdir="$libdir/pkgconfig"
 
@@ -162,6 +163,7 @@ AC_SUBST(libv4l2privdir)
 AC_SUBST(libv4l2plugindir)
 AC_SUBST(libv4lconvertprivdir)
 AC_SUBST(keytablesystemdir)
+AC_SUBST(keytableuserdir)
 AC_SUBST(udevrulesdir)
 AC_SUBST(pkgconfigdir)
 
@@ -171,6 +173,7 @@ AC_DEFINE_DIR([LIBV4L2_PRIV_DIR], [libv4l2privdir], [libv4l2 private lib directo
 AC_DEFINE_DIR([LIBV4L2_PLUGIN_DIR], [libv4l2plugindir], [libv4l2 plugin directory])
 AC_DEFINE_DIR([LIBV4LCONVERT_PRIV_DIR], [libv4lconvertprivdir], [libv4lconvert private lib directory])
 AC_DEFINE_DIR([IR_KEYTABLE_SYSTEM_DIR], [keytablesystemdir], [ir-keytable preinstalled tables directory])
+AC_DEFINE_DIR([IR_KEYTABLE_USER_DIR], [keytableuserdir], [ir-keytable user defined tables directory])
 
 # options
 
diff --git a/utils/keytable/Makefile.am b/utils/keytable/Makefile.am
index 4505fc1..886d800 100644
--- a/utils/keytable/Makefile.am
+++ b/utils/keytable/Makefile.am
@@ -10,6 +10,8 @@ ir_keytable_LDFLAGS = $(ARGP_LIBS)
 EXTRA_DIST = 70-infrared.rules rc_keymaps gen_keytables.pl ir-keytable.1 rc_maps.cfg
 
 # custom target
+install-data-local:
+	$(install_sh) -d "$(DESTDIR)$(keytableuserdir)"
 
 sync-with-kernel:
 	@if [ ! -f $(KERNEL_DIR)/include/linux/input.h ]; then \
diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index 31376f3..bccd325 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -194,7 +194,6 @@ static error_t parse_keyfile(char *fname, char **table)
 
 	fin = fopen(fname, "r");
 	if (!fin) {
-		perror("opening keycode file");
 		return errno;
 	}
 
@@ -1512,15 +1511,31 @@ int main(int argc, char *argv[])
 				cur->fname);
 		if (cur->fname[0] == '/' || ((cur->fname[0] == '.') && strchr(cur->fname, '/'))) {
 			fname = cur->fname;
+			rc = parse_keyfile(fname, &name);
+			if (rc < 0) {
+				fprintf(stderr, "Can't load %s table\n", fname);
+				return -1;
+			}
 		} else {
-			fname = malloc(strlen(cur->fname) + strlen(IR_KEYTABLE_SYSTEM_DIR) + 2);
-			strcpy(fname, IR_KEYTABLE_SYSTEM_DIR);
+			fname = malloc(strlen(cur->fname) + strlen(IR_KEYTABLE_USER_DIR) + 2);
+			strcpy(fname, IR_KEYTABLE_USER_DIR);
 			strcat(fname, "/");
 			strcat(fname, cur->fname);
+			rc = parse_keyfile(fname, &name);
+			if (rc != 0) {
+				fname = malloc(strlen(cur->fname) + strlen(IR_KEYTABLE_SYSTEM_DIR) + 2);
+				strcpy(fname, IR_KEYTABLE_SYSTEM_DIR);
+				strcat(fname, "/");
+				strcat(fname, cur->fname);
+				rc = parse_keyfile(fname, &name);
+			}
+			if (rc != 0) {
+				fprintf(stderr, "Can't load %s table from %s or %s\n", cur->fname, IR_KEYTABLE_USER_DIR, IR_KEYTABLE_SYSTEM_DIR);
+				return -1;
+			}
 		}
-		rc = parse_keyfile(fname, &name);
-		if (rc < 0 || !keys.next) {
-			fprintf(stderr, "Can't load %s table or empty table\n", fname);
+		if (!keys.next) {
+			fprintf(stderr, "Empty table %s\n", fname);
 			return -1;
 		}
 		clear = 1;
-- 
1.7.10

