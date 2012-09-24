Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.mlbassoc.com ([65.100.170.105]:38642 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921Ab2IXOl2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 10:41:28 -0400
From: Gary Thomas <gary@mlbassoc.com>
To: linux-media@vger.kernel.org
Cc: Gary Thomas <gary@mlbassoc.com>
Subject: [PATCH] media-ctl: Fix build error with newer autotools
Date: Mon, 24 Sep 2012 08:34:24 -0600
Message-Id: <1348497264-9667-1-git-send-email-gary@mlbassoc.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 Rename configure.in to be configure.ac - required for newer
 versions of autotools (older versions silently handled
 this, now it's an error)

Signed-off-by: Gary Thomas <gary@mlbassoc.com>
---
 configure.ac |   93 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 configure.in |   93 ----------------------------------------------------------
 2 files changed, 93 insertions(+), 93 deletions(-)
 create mode 100644 configure.ac
 delete mode 100644 configure.in

diff --git a/configure.ac b/configure.ac
new file mode 100644
index 0000000..98459d4
--- /dev/null
+++ b/configure.ac
@@ -0,0 +1,93 @@
+AC_PREREQ([2.61])
+AC_INIT([media-ctl], [0.0.1], [laurent.pinchart@ideasonboard.com])
+AC_CONFIG_SRCDIR([src/main.c])
+AC_CONFIG_AUX_DIR([config])
+AC_CONFIG_HEADERS([config.h])
+AC_CONFIG_MACRO_DIR([m4])
+
+AM_INIT_AUTOMAKE([-Wall -Werror foreign])
+
+# Checks for programs.
+AC_PROG_CC
+AM_PROG_CC_C_O
+# automake 1.12 seems to require this, but automake 1.11 doesn't recognize it
+m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
+AC_PROG_LIBTOOL
+
+# Checks for libraries.
+
+AC_ARG_WITH([libudev],
+    AS_HELP_STRING([--with-libudev],
+        [Enable libudev to detect a device name]))
+
+AS_IF([test "x$with_libudev" = "xyes"],
+    [PKG_CHECK_MODULES(libudev, libudev, have_libudev=yes, have_libudev=no)],
+    [have_libudev=no])
+
+AS_IF([test "x$have_libudev" = "xyes"],
+    [
+        AC_DEFINE([HAVE_LIBUDEV], [], [Use libudev])
+        LIBUDEV_CFLAGS="$libudev_CFLAGS"
+        LIBUDEV_LIBS="$libudev_LIBS"
+        AC_SUBST(LIBUDEV_CFLAGS)
+        AC_SUBST(LIBUDEV_LIBS)
+    ],
+    [AS_IF([test "x$with_libudev" = "xyes"],
+        [AC_MSG_ERROR([libudev requested but not found])
+    ])
+])
+
+
+# Kernel headers path.
+AC_ARG_WITH(kernel-headers,
+    [AC_HELP_STRING([--with-kernel-headers=DIR],
+        [specify path of Linux kernel headers [/usr/src/kernel-headers]])],
+    [case "${withval}" in
+        yes | no) AC_MSG_ERROR([bad value ${withval} for --with-kernel-headers]) ;;
+        *)   KERNEL_HEADERS_DIR="${withval}" ;;
+     esac],
+    [KERNEL_HEADERS_DIR="/usr/src/kernel-headers"])
+
+CPPFLAGS="-I$KERNEL_HEADERS_DIR/include"
+
+# Checks for header files.
+AC_CHECK_HEADERS([linux/media.h \
+		  linux/types.h \
+		  linux/v4l2-mediabus.h \
+		  linux/v4l2-subdev.h \
+		  linux/videodev2.h],
+		  [],
+		  [echo "ERROR: Kernel header file not found or not usable!"; exit 1])
+
+AC_CHECK_HEADERS([fcntl.h \
+		  stdlib.h \
+		  string.h \
+		  sys/ioctl.h \
+		  sys/time.h \
+		  unistd.h],
+		  [],
+		  [echo "ERROR: Header file not found or not usable!"; exit 1])
+
+# Checks for typedefs, structures, and compiler characteristics.
+AC_C_INLINE
+AC_TYPE_SIZE_T
+AC_CHECK_MEMBERS([struct stat.st_rdev])
+
+# Checks for library functions.
+AC_HEADER_MAJOR
+AS_IF([test "x$cross_compiling" != "xyes"],
+    [
+        AC_FUNC_MALLOC
+        AC_FUNC_REALLOC
+    ])
+AC_CHECK_FUNCS([memset strerror strrchr strtoul])
+
+AC_CONFIG_FILES([
+ Makefile
+ src/Makefile
+ libmediactl.pc
+ libv4l2subdev.pc
+])
+
+AC_OUTPUT
+
diff --git a/configure.in b/configure.in
deleted file mode 100644
index 98459d4..0000000
--- a/configure.in
+++ /dev/null
@@ -1,93 +0,0 @@
-AC_PREREQ([2.61])
-AC_INIT([media-ctl], [0.0.1], [laurent.pinchart@ideasonboard.com])
-AC_CONFIG_SRCDIR([src/main.c])
-AC_CONFIG_AUX_DIR([config])
-AC_CONFIG_HEADERS([config.h])
-AC_CONFIG_MACRO_DIR([m4])
-
-AM_INIT_AUTOMAKE([-Wall -Werror foreign])
-
-# Checks for programs.
-AC_PROG_CC
-AM_PROG_CC_C_O
-# automake 1.12 seems to require this, but automake 1.11 doesn't recognize it
-m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
-AC_PROG_LIBTOOL
-
-# Checks for libraries.
-
-AC_ARG_WITH([libudev],
-    AS_HELP_STRING([--with-libudev],
-        [Enable libudev to detect a device name]))
-
-AS_IF([test "x$with_libudev" = "xyes"],
-    [PKG_CHECK_MODULES(libudev, libudev, have_libudev=yes, have_libudev=no)],
-    [have_libudev=no])
-
-AS_IF([test "x$have_libudev" = "xyes"],
-    [
-        AC_DEFINE([HAVE_LIBUDEV], [], [Use libudev])
-        LIBUDEV_CFLAGS="$libudev_CFLAGS"
-        LIBUDEV_LIBS="$libudev_LIBS"
-        AC_SUBST(LIBUDEV_CFLAGS)
-        AC_SUBST(LIBUDEV_LIBS)
-    ],
-    [AS_IF([test "x$with_libudev" = "xyes"],
-        [AC_MSG_ERROR([libudev requested but not found])
-    ])
-])
-
-
-# Kernel headers path.
-AC_ARG_WITH(kernel-headers,
-    [AC_HELP_STRING([--with-kernel-headers=DIR],
-        [specify path of Linux kernel headers [/usr/src/kernel-headers]])],
-    [case "${withval}" in
-        yes | no) AC_MSG_ERROR([bad value ${withval} for --with-kernel-headers]) ;;
-        *)   KERNEL_HEADERS_DIR="${withval}" ;;
-     esac],
-    [KERNEL_HEADERS_DIR="/usr/src/kernel-headers"])
-
-CPPFLAGS="-I$KERNEL_HEADERS_DIR/include"
-
-# Checks for header files.
-AC_CHECK_HEADERS([linux/media.h \
-		  linux/types.h \
-		  linux/v4l2-mediabus.h \
-		  linux/v4l2-subdev.h \
-		  linux/videodev2.h],
-		  [],
-		  [echo "ERROR: Kernel header file not found or not usable!"; exit 1])
-
-AC_CHECK_HEADERS([fcntl.h \
-		  stdlib.h \
-		  string.h \
-		  sys/ioctl.h \
-		  sys/time.h \
-		  unistd.h],
-		  [],
-		  [echo "ERROR: Header file not found or not usable!"; exit 1])
-
-# Checks for typedefs, structures, and compiler characteristics.
-AC_C_INLINE
-AC_TYPE_SIZE_T
-AC_CHECK_MEMBERS([struct stat.st_rdev])
-
-# Checks for library functions.
-AC_HEADER_MAJOR
-AS_IF([test "x$cross_compiling" != "xyes"],
-    [
-        AC_FUNC_MALLOC
-        AC_FUNC_REALLOC
-    ])
-AC_CHECK_FUNCS([memset strerror strrchr strtoul])
-
-AC_CONFIG_FILES([
- Makefile
- src/Makefile
- libmediactl.pc
- libv4l2subdev.pc
-])
-
-AC_OUTPUT
-
-- 
1.7.7.6

