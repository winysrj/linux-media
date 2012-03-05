Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:37375 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932379Ab2CEOth (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Mar 2012 09:49:37 -0500
From: "Oleksij Rempel (Alexey Fisher)" <bug-track@fisher-privat.net>
To: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Cc: "Oleksij Rempel (Alexey Fisher)" <bug-track@fisher-privat.net>
Subject: [PATCH] make mmap logs more readable.
Date: Mon,  5 Mar 2012 15:49:27 +0100
Message-Id: <1330958967-31522-1-git-send-email-bug-track@fisher-privat.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Oleksij Rempel (Alexey Fisher)" <bug-track@fisher-privat.net>

Signed-off-by: Oleksij Rempel (Alexey Fisher) <bug-track@fisher-privat.net>
---
 lib/libv4l2/libv4l2.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
index 8dd01ba..f17fa45 100644
--- a/lib/libv4l2/libv4l2.c
+++ b/lib/libv4l2/libv4l2.c
@@ -1533,7 +1533,7 @@ void *v4l2_mmap(void *start, size_t length, int prot, int flags, int fd,
 			start || length != V4L2_FRAME_BUF_SIZE ||
 			((unsigned int)offset & ~0xFFu) != V4L2_MMAP_OFFSET_MAGIC) {
 		if (index != -1)
-			V4L2_LOG("Passing mmap(%p, %d, ..., %x, through to the driver\n",
+			V4L2_LOG("Passing mmap(start: %p, length: %d, offset: %x) through to the driver\n",
 					start, (int)length, (int)offset);
 
 		if (offset & ((1 << MMAP2_PAGE_SHIFT) - 1)) {
@@ -1576,8 +1576,8 @@ void *v4l2_mmap(void *start, size_t length, int prot, int flags, int fd,
 	result = devices[index].convert_mmap_buf +
 		buffer_index * V4L2_FRAME_BUF_SIZE;
 
-	V4L2_LOG("Fake (conversion) mmap buf %u, seen by app at: %p\n",
-			buffer_index, result);
+	V4L2_LOG("Fake (conversion) mmap buf %u, seen by app at: %p, length: %d\n",
+			buffer_index, result, (int)length);
 
 leave:
 	pthread_mutex_unlock(&devices[index].stream_lock);
@@ -1620,13 +1620,13 @@ int v4l2_munmap(void *_start, size_t length)
 			pthread_mutex_unlock(&devices[index].stream_lock);
 
 			if (unmapped) {
-				V4L2_LOG("v4l2 fake buffer munmap %p, %d\n", start, (int)length);
+				V4L2_LOG("v4l2 fake buffer munmap %p, length: %d\n", start, (int)length);
 				return 0;
 			}
 		}
 	}
 
-	V4L2_LOG("v4l2 unknown munmap %p, %d\n", start, (int)length);
+	V4L2_LOG("v4l2 unknown munmap %p, length: %d\n", start, (int)length);
 
 	return SYS_MUNMAP(_start, length);
 }
-- 
1.7.9

