Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:46925 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387491AbeKFTtQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Nov 2018 14:49:16 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: Gregor Jasny <gjasny@googlemail.com>
Subject: [PATCH] configure: build without BPF support in ir-keytable
Date: Tue,  6 Nov 2018 10:24:43 +0000
Message-Id: <20181106102443.31980-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It currently does not build on mips and some platforms do not have
BPF support yet (risc-v, for example).

Signed-off-by: Sean Young <sean@mess.org>
---
 configure.ac | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 387f8539..4100db06 100644
--- a/configure.ac
+++ b/configure.ac
@@ -170,7 +170,14 @@ AC_SUBST([X11_CFLAGS])
 AC_SUBST([X11_LIBS])
 AM_CONDITIONAL([HAVE_X11], [test x$x11_pkgconfig = xyes])
 
-PKG_CHECK_MODULES([LIBELF], [libelf], [libelf_pkgconfig=yes], [libelf_pkgconfig=no])
+AC_ARG_WITH([bpf],
+            AS_HELP_STRING([--without-bpf],
+			   [Do not build with BPF IR decoder support]),
+            [],
+            [with_bpf=yes])
+
+AS_IF([test "x$with_bpf" != xno],
+      PKG_CHECK_MODULES([LIBELF], [libelf], [libelf_pkgconfig=yes], [libelf_pkgconfig=no]), [libelf_pkgconfig=no])
 AC_SUBST([LIBELF_CFLAGS])
 AC_SUBST([LIBELF_LIBS])
 AM_CONDITIONAL([HAVE_LIBELF], [test x$libelf_pkgconfig = xyes])
-- 
2.17.2
