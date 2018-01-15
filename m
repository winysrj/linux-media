Return-path: <linux-media-owner@vger.kernel.org>
Received: from avasout02.plus.net ([212.159.14.17]:50822 "EHLO
        avasout02.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750716AbeAOTuZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 14:50:25 -0500
From: Chris Mayo <aklhfex@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] [v4l-utils] buildsystem: Fix not reporting if libjpeg is not being used
Date: Mon, 15 Jan 2018 19:50:23 +0000
Message-Id: <20180115195023.28634-1-aklhfex@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Chris Mayo <aklhfex@gmail.com>
---

If configured --without-jpeg, currently see:

compile time options summary
============================

    Host OS                    : linux-gnu
    X11                        : yes
    GL                         : yes
    glu                        : yes
    libjpeg                    : 

 configure.ac | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index dc1e9cbf5..cfbdffd99 100644
--- a/configure.ac
+++ b/configure.ac
@@ -195,7 +195,8 @@ AS_IF([test "x$with_jpeg" != xno],
                                      [have_jpeg=no
                                       AC_MSG_WARN(cannot find libjpeg (v6 or later required))])],
                        [have_jpeg=no
-                        AC_MSG_WARN(cannot find libjpeg)])])
+                        AC_MSG_WARN(cannot find libjpeg)])],
+      [have_jpeg=no])
 
 AM_CONDITIONAL([HAVE_JPEG], [test x$have_jpeg = xyes])
 
-- 
2.13.6
