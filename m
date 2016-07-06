Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:56504 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbcGFJoG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 05:44:06 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Joe Perches <joe@perches.com>, Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH v3 12/15] [media] lirc_dev: fix error return value
Date: Wed, 06 Jul 2016 18:01:24 +0900
Message-id: <1467795687-10737-13-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1467795687-10737-1-git-send-email-andi.shyti@samsung.com>
References: <1467795687-10737-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If ioctl is called, it cannot be a case of invalid system call
number (ENOSYS), that is a ENOTTY case which means that the
device doesn't support that specific ioctl command.
Replace ENOSYS with EPERM.

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/lirc_dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index c2b32e0..ac00433 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -582,7 +582,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		break;
 	case LIRC_GET_REC_MODE:
 		if (!(ir->d.features & LIRC_CAN_REC_MASK)) {
-			result = -ENOSYS;
+			result = -ENOTTY;
 			break;
 		}
 
@@ -592,7 +592,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		break;
 	case LIRC_SET_REC_MODE:
 		if (!(ir->d.features & LIRC_CAN_REC_MASK)) {
-			result = -ENOSYS;
+			result = -ENOTTY;
 			break;
 		}
 
@@ -610,7 +610,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case LIRC_GET_MIN_TIMEOUT:
 		if (!(ir->d.features & LIRC_CAN_SET_REC_TIMEOUT) ||
 		    ir->d.min_timeout == 0) {
-			result = -ENOSYS;
+			result = -ENOTTY;
 			break;
 		}
 
@@ -619,7 +619,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case LIRC_GET_MAX_TIMEOUT:
 		if (!(ir->d.features & LIRC_CAN_SET_REC_TIMEOUT) ||
 		    ir->d.max_timeout == 0) {
-			result = -ENOSYS;
+			result = -ENOTTY;
 			break;
 		}
 
-- 
2.8.1

