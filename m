Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:53548 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751133AbdKJQFz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Nov 2017 11:05:55 -0500
Received: by mail-wr0-f196.google.com with SMTP id u40so9001591wrf.10
        for <linux-media@vger.kernel.org>; Fri, 10 Nov 2017 08:05:55 -0800 (PST)
Received: from localhost.localdomain ([62.147.246.169])
        by smtp.gmail.com with ESMTPSA id 56sm5153746wrx.2.2017.11.10.08.05.53
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Nov 2017 08:05:53 -0800 (PST)
From: =?UTF-8?q?Rafa=C3=ABl=20Carr=C3=A9?= <funman@videolan.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] sdlcam: fix linking
Date: Fri, 10 Nov 2017 17:05:46 +0100
Message-Id: <20171110160547.32639-1-funman@videolan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
