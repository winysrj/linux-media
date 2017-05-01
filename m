Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:41347 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760315AbdEAQE7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 12:04:59 -0400
Subject: [PATCH 16/16] lirc_dev: cleanup header
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Mon, 01 May 2017 18:04:57 +0200
Message-ID: <149365469743.12922.720228690283957038.stgit@zeus.hardeman.nu>
In-Reply-To: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
References: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove some stuff from lirc_dev.h which is not used anywhere.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 include/media/lirc_dev.h |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index 11f455a34090..af738d522dec 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -9,10 +9,6 @@
 #ifndef _LINUX_LIRC_DEV_H
 #define _LINUX_LIRC_DEV_H
 
-#define BUFLEN            16
-
-#define mod(n, div) ((n) % (div))
-
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/ioctl.h>
@@ -20,6 +16,8 @@
 #include <linux/kfifo.h>
 #include <media/lirc.h>
 
+#define BUFLEN            16
+
 struct lirc_buffer {
 	wait_queue_head_t wait_poll;
 	spinlock_t fifo_lock;
@@ -89,11 +87,6 @@ static inline int lirc_buffer_empty(struct lirc_buffer *buf)
 	return !lirc_buffer_len(buf);
 }
 
-static inline int lirc_buffer_available(struct lirc_buffer *buf)
-{
-	return buf->size - (lirc_buffer_len(buf) / buf->chunk_size);
-}
-
 static inline unsigned int lirc_buffer_read(struct lirc_buffer *buf,
 					    unsigned char *dest)
 {
