Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:52748 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751438AbaKEIR7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Nov 2014 03:17:59 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/8] videobuf: fix sparse warnings
Date: Wed,  5 Nov 2014 09:17:46 +0100
Message-Id: <1415175472-24203-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1415175472-24203-1-git-send-email-hverkuil@xs4all.nl>
References: <1415175472-24203-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

videobuf-core.c:834:23: warning: Using plain integer as NULL pointer
videobuf-core.c:851:28: warning: Using plain integer as NULL pointer

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf-core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf-core.c b/drivers/media/v4l2-core/videobuf-core.c
index b91a266..926836d 100644
--- a/drivers/media/v4l2-core/videobuf-core.c
+++ b/drivers/media/v4l2-core/videobuf-core.c
@@ -51,6 +51,8 @@ MODULE_LICENSE("GPL");
 
 #define CALL(q, f, arg...)						\
 	((q->int_ops->f) ? q->int_ops->f(arg) : 0)
+#define CALLPTR(q, f, arg...)						\
+	((q->int_ops->f) ? q->int_ops->f(arg) : NULL)
 
 struct videobuf_buffer *videobuf_alloc_vb(struct videobuf_queue *q)
 {
@@ -831,7 +833,7 @@ static int __videobuf_copy_to_user(struct videobuf_queue *q,
 				   char __user *data, size_t count,
 				   int nonblocking)
 {
-	void *vaddr = CALL(q, vaddr, buf);
+	void *vaddr = CALLPTR(q, vaddr, buf);
 
 	/* copy to userspace */
 	if (count > buf->size - q->read_off)
@@ -848,7 +850,7 @@ static int __videobuf_copy_stream(struct videobuf_queue *q,
 				  char __user *data, size_t count, size_t pos,
 				  int vbihack, int nonblocking)
 {
-	unsigned int *fc = CALL(q, vaddr, buf);
+	unsigned int *fc = CALLPTR(q, vaddr, buf);
 
 	if (vbihack) {
 		/* dirty, undocumented hack -- pass the frame counter
-- 
2.1.1

