Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:50840 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738AbZLPOdx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2009 09:33:53 -0500
Message-ID: <4B28F041.2040603@gmail.com>
Date: Wed, 16 Dec 2009 15:35:45 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] V4L/DVB: use correct size in put_v4l2_window32()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Although these sizes may be the same it is better to calculate the size of
the source, than the destiny.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index 997975d..23ad218 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -288,7 +288,7 @@ static int get_v4l2_window32(struct v4l2_window *kp, struct v4l2_window32 __user
 
 static int put_v4l2_window32(struct v4l2_window *kp, struct v4l2_window32 __user *up)
 {
-	if (copy_to_user(&up->w, &kp->w, sizeof(up->w)) ||
+	if (copy_to_user(&up->w, &kp->w, sizeof(kp->w)) ||
 		put_user(kp->field, &up->field) ||
 		put_user(kp->chromakey, &up->chromakey) ||
 		put_user(kp->clipcount, &up->clipcount))
