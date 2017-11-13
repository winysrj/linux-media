Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:54381 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751012AbdKMJTQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Nov 2017 04:19:16 -0500
Received: by mail-wr0-f193.google.com with SMTP id l22so13757992wrc.11
        for <linux-media@vger.kernel.org>; Mon, 13 Nov 2017 01:19:16 -0800 (PST)
From: =?UTF-8?q?Rafa=C3=ABl=20Carr=C3=A9?= <funman@videolan.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        =?UTF-8?q?Rafa=C3=ABl=20Carr=C3=A9?= <funman@videolan.org>
Subject: [PATCH 1/2] sdlcam: fix linking
Date: Mon, 13 Nov 2017 10:19:07 +0100
Message-Id: <20171113091908.23531-1-funman@videolan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Rafaël Carré <funman@videolan.org>
---
 contrib/test/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/contrib/test/Makefile.am b/contrib/test/Makefile.am
index 6a4303d7..0188fe21 100644
--- a/contrib/test/Makefile.am
+++ b/contrib/test/Makefile.am
@@ -37,7 +37,7 @@ v4l2gl_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconver
 
 sdlcam_LDFLAGS = $(JPEG_LIBS) $(SDL2_LIBS) -lm -ldl -lrt
 sdlcam_CFLAGS = -I../.. $(SDL2_CFLAGS)
-sdlcam_LDADD = ../../lib/libv4l2/.libs/libv4l2.a  ../../lib/libv4lconvert/.libs/libv4lconvert.a
+sdlcam_LDADD = ../../lib/libv4l2/libv4l2.la  ../../lib/libv4lconvert/libv4lconvert.la
 
 mc_nextgen_test_CFLAGS = $(LIBUDEV_CFLAGS)
 mc_nextgen_test_LDFLAGS = $(LIBUDEV_LIBS)
-- 
2.14.1
