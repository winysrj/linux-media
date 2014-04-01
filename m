Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:43098 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaDANpP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Apr 2014 09:45:15 -0400
Received: by mail-pa0-f48.google.com with SMTP id hz1so9906596pad.35
        for <linux-media@vger.kernel.org>; Tue, 01 Apr 2014 06:45:15 -0700 (PDT)
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: Lad Prabhakar <prabhakar.csengg@gmail.com>
Subject: [PATCH] v4l2-compliance: fix function pointer prototype
Date: Tue,  1 Apr 2014 19:15:06 +0530
Message-Id: <1396359906-6311-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

There was a conflict between the mmap function pointer prototype of
struct v4l_fd and the actual function used. Make sure it is in sync
with the prototype of v4l2_mmap.

This patch fixes following build error,

v4l2-compliance.cpp: In function 'void v4l_fd_test_init(v4l_fd*, int)':
v4l2-compliance.cpp:132: error: invalid conversion from
'void* (*)(void*, size_t, int, int, int, int64_t)' to
'void* (*)(void*, size_t, int, int, int, off_t)'

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 utils/v4l2-compliance/v4l-helpers.h     |    2 +-
 utils/v4l2-compliance/v4l2-compliance.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/utils/v4l2-compliance/v4l-helpers.h b/utils/v4l2-compliance/v4l-helpers.h
index 48ea602..b2ce6c0 100644
--- a/utils/v4l2-compliance/v4l-helpers.h
+++ b/utils/v4l2-compliance/v4l-helpers.h
@@ -10,7 +10,7 @@ struct v4l_fd {
 	int fd;
 	int (*ioctl)(int fd, unsigned long cmd, ...);
 	void *(*mmap)(void *addr, size_t length, int prot, int flags,
-		      int fd, int64_t offset);
+		      int fd, off_t offset);
 	int (*munmap)(void *addr, size_t length);
 };
 
diff --git a/utils/v4l2-compliance/v4l2-compliance.h b/utils/v4l2-compliance/v4l2-compliance.h
index f2f7072..b6d4dae 100644
--- a/utils/v4l2-compliance/v4l2-compliance.h
+++ b/utils/v4l2-compliance/v4l2-compliance.h
@@ -137,7 +137,7 @@ static inline int test_ioctl(int fd, unsigned long cmd, ...)
 }
 
 static inline void *test_mmap(void *start, size_t length, int prot, int flags,
-		int fd, int64_t offset)
+		int fd, off_t offset)
 {
  	return wrapper ? v4l2_mmap(start, length, prot, flags, fd, offset) :
 		mmap(start, length, prot, flags, fd, offset);
-- 
1.7.9.5

