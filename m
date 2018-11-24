Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50897 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbeKXX5W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Nov 2018 18:57:22 -0500
Received: by mail-wm1-f66.google.com with SMTP id 125so14092394wmh.0
        for <linux-media@vger.kernel.org>; Sat, 24 Nov 2018 05:08:57 -0800 (PST)
From: Fabrice Fontaine <fontaine.fabrice@gmail.com>
To: linux-media@vger.kernel.org
Cc: Fabrice Fontaine <fontaine.fabrice@gmail.com>
Subject: [PATCH v4l-utils] Build sdlcam only if jpeg is enabled
Date: Sat, 24 Nov 2018 14:08:23 +0100
Message-Id: <20181124130823.8356-1-fontaine.fabrice@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes:
 - http://autobuild.buildroot.net/results/1eded8b44cc369550566c6ce0b3c042f1aec8d44

Signed-off-by: Fabrice Fontaine <fontaine.fabrice@gmail.com>
---
 contrib/test/Makefile.am | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/contrib/test/Makefile.am b/contrib/test/Makefile.am
index 0188fe21..c7c38e7a 100644
--- a/contrib/test/Makefile.am
+++ b/contrib/test/Makefile.am
@@ -17,8 +17,10 @@ noinst_PROGRAMS += v4l2gl
 endif
 
 if HAVE_SDL
+if HAVE_JPEG
 noinst_PROGRAMS += sdlcam
 endif
+endif
 
 driver_test_SOURCES = driver-test.c
 driver_test_LDADD = ../../utils/libv4l2util/libv4l2util.la
-- 
2.14.1
