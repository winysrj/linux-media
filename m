Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:46346 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbcGAIhf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2016 04:37:35 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Joe Perches <joe@perches.com>, Sean Young <sean@mess.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH v2 12/15] [media] lirc_dev: fix error return value
Date: Fri, 01 Jul 2016 17:01:35 +0900
Message-id: <1467360098-12539-13-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1467360098-12539-1-git-send-email-andi.shyti@samsung.com>
References: <1467360098-12539-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If ioctl is called, it cannot be a case of invalid system call
number (ENOSYS), that is an operation not permitted (EPERM).
Replace ENOSYS with EPERM.

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/lirc_dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 689e369..99d1f98 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -587,7 +587,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		break;
 	case LIRC_GET_REC_MODE:
 		if (!(ir->d.features & LIRC_CAN_REC_MASK)) {
-			result = -ENOSYS;
+			result = -EPERM;
 			break;
 		}
 
@@ -597,7 +597,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		break;
 	case LIRC_SET_REC_MODE:
 		if (!(ir->d.features & LIRC_CAN_REC_MASK)) {
-			result = -ENOSYS;
+			result = -EPERM;
 			break;
 		}
 
@@ -615,7 +615,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case LIRC_GET_MIN_TIMEOUT:
 		if (!(ir->d.features & LIRC_CAN_SET_REC_TIMEOUT) ||
 		    ir->d.min_timeout == 0) {
-			result = -ENOSYS;
+			result = -EPERM;
 			break;
 		}
 
@@ -624,7 +624,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case LIRC_GET_MAX_TIMEOUT:
 		if (!(ir->d.features & LIRC_CAN_SET_REC_TIMEOUT) ||
 		    ir->d.max_timeout == 0) {
-			result = -ENOSYS;
+			result = -EPERM;
 			break;
 		}
 
-- 
2.8.1

