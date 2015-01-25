Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:39516 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbbAYUiF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2015 15:38:05 -0500
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id ADB5225C008A
	for <linux-media@vger.kernel.org>; Sun, 25 Jan 2015 21:38:04 +0100 (CET)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3kVmHc3wpWz5vMp
	for <linux-media@vger.kernel.org>; Sun, 25 Jan 2015 21:38:04 +0100 (CET)
Date: Sun, 25 Jan 2015 21:36:45 +0100
From: Felix Janda <felix.janda@posteo.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/4] contrib/test: Add missing LIB_ARGP
Message-ID: <20150125203645.GD11999@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2gl and v4l2grab need argp.

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 contrib/test/Makefile.am | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/contrib/test/Makefile.am b/contrib/test/Makefile.am
index 0bfa33e..7f84435 100644
--- a/contrib/test/Makefile.am
+++ b/contrib/test/Makefile.am
@@ -23,10 +23,11 @@ pixfmt_test_CFLAGS = $(X11_CFLAGS)
 pixfmt_test_LDFLAGS = $(X11_LIBS)
 
 v4l2grab_SOURCES = v4l2grab.c
+v4l2grab_LDFLAGS = $(ARGP_LIBS)
 v4l2grab_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la -lpthread
 
 v4l2gl_SOURCES = v4l2gl.c
-v4l2gl_LDFLAGS = $(X11_LIBS) $(GL_LIBS) $(GLU_LIBS)
+v4l2gl_LDFLAGS = $(X11_LIBS) $(GL_LIBS) $(GLU_LIBS) $(ARGP_LIBS)
 v4l2gl_LDADD = ../../lib/libv4l2/libv4l2.la ../../lib/libv4lconvert/libv4lconvert.la
 
 ioctl_test_SOURCES = ioctl-test.c ioctl-test.h ioctl_32.h ioctl_64.h
-- 
2.0.5
