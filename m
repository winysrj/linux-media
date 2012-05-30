Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59450 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab2E3NpQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 May 2012 09:45:16 -0400
Received: by yenm10 with SMTP id m10so2992155yen.19
        for <linux-media@vger.kernel.org>; Wed, 30 May 2012 06:42:55 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: <linux-media@vger.kernel.org>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [v4l-utils] Add configure option to allow qv4l2 disable
Date: Wed, 30 May 2012 10:42:44 -0300
Message-Id: <1338385364-2308-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch could ease the job of a few people, 
by providing an option they actually need. 
OpenWRT [1] and Openembedded [2] are already disabling 
qv4l2 by applying ugly patches.

[1] https://dev.openwrt.org/browser/packages/libs/libv4l/patches/004-disable-qv4l2.patch
[2] http://patches.openembedded.org/patch/21469/

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 configure.ac |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/configure.ac b/configure.ac
index 98fad38..92ee050 100644
--- a/configure.ac
+++ b/configure.ac
@@ -83,8 +83,17 @@ AS_IF([test "x$with_jpeg" != xno],
 
 AM_CONDITIONAL([HAVE_JPEG], [$have_jpeg])
 
+AC_ARG_ENABLE(qv4l2,
+  [  --disable-qv4l2         disable qv4l2 compilation],
+  [case "${enableval}" in
+     yes | no ) with_qv4l2="${enableval}" ;;
+     *) AC_MSG_ERROR(bad value ${enableval} for --disable-qv4l2) ;;
+   esac],
+  [with_qv4l2="yes"]
+)
+
 PKG_CHECK_MODULES(QT, [QtCore >= 4.4 QtGui >= 4.4], [qt_pkgconfig=true], [qt_pkgconfig=false])
-if test "x$qt_pkgconfig" = "xtrue"; then
+if test "x$qt_pkgconfig" = "xtrue" && test "x$with_qv4l2" = "xyes"; then
    AC_SUBST(QT_CFLAGS)
    AC_SUBST(QT_LIBS)
    MOC=`$PKG_CONFIG --variable=moc_location QtCore`
-- 
1.7.3.4

