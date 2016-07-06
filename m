Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:55244 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbcGFJoF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 05:44:05 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Joe Perches <joe@perches.com>, Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH v3 13/15] [media] lirc_dev: extremely trivial comment style fix
Date: Wed, 06 Jul 2016 18:01:25 +0900
Message-id: <1467795687-10737-14-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1467795687-10737-1-git-send-email-andi.shyti@samsung.com>
References: <1467795687-10737-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/lirc_dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index ac00433..c78fe2b 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -687,7 +687,8 @@ ssize_t lirc_dev_fop_read(struct file *file,
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

