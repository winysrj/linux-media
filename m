Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:55710 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbcF2NVD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 09:21:03 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH 13/15] lirc_dev: extremely trivial comment style fix
Date: Wed, 29 Jun 2016 22:20:42 +0900
Message-id: <1467206444-9935-14-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1467206444-9935-1-git-send-email-andi.shyti@samsung.com>
References: <1467206444-9935-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/lirc_dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 6f3402c..0a3d65d 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -692,7 +692,8 @@ ssize_t lirc_dev_fop_read(struct file *file,
 			/* According to the read(2) man page, 'written' can be
 			 * returned as less than 'length', instead of blocking
 			 * again, returning -EWOULDBLOCK, or returning
-			 * -ERESTARTSYS */
+			 * -ERESTARTSYS
+			 */
 			if (written)
 				break;
 			if (file->f_flags & O_NONBLOCK) {
-- 
2.8.1

