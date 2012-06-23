Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60850 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949Ab2FWQh0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jun 2012 12:37:26 -0400
Received: by mail-bk0-f46.google.com with SMTP id ji2so2283417bkc.19
        for <linux-media@vger.kernel.org>; Sat, 23 Jun 2012 09:37:25 -0700 (PDT)
From: Gregor Jasny <gjasny@googlemail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Gregor Jasny <gjasny@googlemail.com>
Subject: [PATCH 1/3] keytable: Make udev rules dir configurable
Date: Sat, 23 Jun 2012 18:36:45 +0200
Message-Id: <1340469407-25580-2-git-send-email-gjasny@googlemail.com>
In-Reply-To: <1340469407-25580-1-git-send-email-gjasny@googlemail.com>
References: <1340469407-25580-1-git-send-email-gjasny@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Gregor Jasny <gjasny@googlemail.com>
---
 configure.ac               |    7 +++++--
 utils/keytable/Makefile.am |    1 -
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/configure.ac b/configure.ac
index 8e166b1..1a12abd 100644
--- a/configure.ac
+++ b/configure.ac
@@ -145,13 +145,16 @@ AC_ARG_WITH(libv4l2subdir, AS_HELP_STRING(--with-libv4l2subdir=DIR,set libv4l2 l
 AC_ARG_WITH(libv4lconvertsubdir, AS_HELP_STRING(--with-libv4lconvertsubdir=DIR,set libv4lconvert library subdir [default=libv4l]),
    libv4lconvertsubdir=$withval, libv4lconvertsubdir="libv4l")
 
+AC_ARG_WITH(udevdir, AS_HELP_STRING(--with-udevdir=DIR,set udev directory [default=/lib/udev]),
+   udevdir=$withval, udevdir="/lib/udev")
+
 libv4l1privdir="$libdir/$libv4l1subdir"
 libv4l2privdir="$libdir/$libv4l2subdir"
 libv4l2plugindir="$libv4l2privdir/plugins"
 libv4lconvertprivdir="$libdir/$libv4lconvertsubdir"
 
 rootetcdir="/etc"
-rootlibdir="/lib"
+udevrulesdir="$udevdir/rules.d"
 pkgconfigdir="$libdir/pkgconfig"
 
 AC_SUBST(libv4l1privdir)
@@ -159,7 +162,7 @@ AC_SUBST(libv4l2privdir)
 AC_SUBST(libv4l2plugindir)
 AC_SUBST(libv4lconvertprivdir)
 AC_SUBST(rootetcdir)
-AC_SUBST(rootlibdir)
+AC_SUBST(udevrulesdir)
 AC_SUBST(pkgconfigdir)
 
 AC_DEFINE_UNQUOTED([V4L_UTILS_VERSION], ["$PACKAGE_VERSION"], [v4l-utils version string])
diff --git a/utils/keytable/Makefile.am b/utils/keytable/Makefile.am
index 0321a57..3d510e0 100644
--- a/utils/keytable/Makefile.am
+++ b/utils/keytable/Makefile.am
@@ -1,4 +1,3 @@
-udevrulesdir="/lib/udev/rules.d"
 rootetcdir="/etc"
 
 bin_PROGRAMS = ir-keytable
-- 
1.7.10

