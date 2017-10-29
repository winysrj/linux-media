Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:57411 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932227AbdJ2U77 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 16:59:59 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 28/28] kfifo: DECLARE_KIFO_PTR(fifo, u64) does not work on arm 32 bit
Date: Sun, 29 Oct 2017 20:59:57 +0000
Message-Id: <0a0f8d6e8b8a407e241c7674e54019738832a344.1509309834.git.sean@mess.org>
In-Reply-To: <cover.1509309834.git.sean@mess.org>
References: <cover.1509309834.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If you try to store u64 in a kfifo (or a struct with u64 members),
then the buf member of __STRUCT_KFIFO_PTR will cause 4 bytes
padding due to alignment (note that struct __kfifo is 20 bytes
on 32 bit).

That in turn causes the __is_kfifo_ptr() to fail, which is caught
by kfifo_alloc(), which now returns EINVAL.

So, ensure that __is_kfifo_ptr() compares to the right structure.

Signed-off-by: Sean Young <sean@mess.org>
Acked-by: Stefani Seibold <stefani@seibold.net>
---
 include/linux/kfifo.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
index 41eb6fdf87a8..86b5fb08e96c 100644
--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -113,7 +113,8 @@ struct kfifo_rec_ptr_2 __STRUCT_KFIFO_PTR(unsigned char, 2, void);
  * array is a part of the structure and the fifo type where the array is
  * outside of the fifo structure.
  */
-#define	__is_kfifo_ptr(fifo)	(sizeof(*fifo) == sizeof(struct __kfifo))
+#define	__is_kfifo_ptr(fifo) \
+	(sizeof(*fifo) == sizeof(STRUCT_KFIFO_PTR(typeof(*(fifo)->type))))
 
 /**
  * DECLARE_KFIFO_PTR - macro to declare a fifo pointer object
-- 
2.13.6
