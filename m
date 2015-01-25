Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:39424 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbbAYUh5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2015 15:37:57 -0500
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id 3703625C00A9
	for <linux-media@vger.kernel.org>; Sun, 25 Jan 2015 21:37:56 +0100 (CET)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3kVmHS0TzNz5vNH
	for <linux-media@vger.kernel.org>; Sun, 25 Jan 2015 21:37:56 +0100 (CET)
Date: Sun, 25 Jan 2015 21:36:36 +0100
From: Felix Janda <felix.janda@posteo.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/4] Wrap LFS64 functions only if __GLIBC__
Message-ID: <20150125203636.GC11999@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The functions open64 and mmap64 are glibc specific.

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 lib/libv4l1/v4l1compat.c  | 4 ++--
 lib/libv4l2/v4l2convert.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/libv4l1/v4l1compat.c b/lib/libv4l1/v4l1compat.c
index 282173b..c78adb4 100644
--- a/lib/libv4l1/v4l1compat.c
+++ b/lib/libv4l1/v4l1compat.c
@@ -61,7 +61,7 @@ LIBV4L_PUBLIC int open(const char *file, int oflag, ...)
 	return fd;
 }
 
-#ifdef linux
+#ifdef __GLIBC__
 LIBV4L_PUBLIC int open64(const char *file, int oflag, ...)
 {
 	int fd;
@@ -120,7 +120,7 @@ LIBV4L_PUBLIC void *mmap(void *start, size_t length, int prot, int flags, int fd
 	return v4l1_mmap(start, length, prot, flags, fd, offset);
 }
 
-#ifdef linux
+#ifdef __GLIBC__
 LIBV4L_PUBLIC void *mmap64(void *start, size_t length, int prot, int flags, int fd,
 		off64_t offset)
 {
diff --git a/lib/libv4l2/v4l2convert.c b/lib/libv4l2/v4l2convert.c
index c79f9da..9345641 100644
--- a/lib/libv4l2/v4l2convert.c
+++ b/lib/libv4l2/v4l2convert.c
@@ -86,7 +86,7 @@ LIBV4L_PUBLIC int open(const char *file, int oflag, ...)
 	return fd;
 }
 
-#ifdef linux
+#ifdef __GLIBC__
 LIBV4L_PUBLIC int open64(const char *file, int oflag, ...)
 {
 	int fd;
@@ -148,7 +148,7 @@ LIBV4L_PUBLIC void *mmap(void *start, size_t length, int prot, int flags, int fd
 	return v4l2_mmap(start, length, prot, flags, fd, offset);
 }
 
-#ifdef linux
+#ifdef __GLIBC__
 LIBV4L_PUBLIC void *mmap64(void *start, size_t length, int prot, int flags, int fd,
 		off64_t offset)
 {
-- 
2.0.5

