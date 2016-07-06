Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:37356 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbcGFJoB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 05:44:01 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Joe Perches <joe@perches.com>, Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH v3 15/15] [media] lirc_dev: use LIRC_CAN_REC() define to check
 if the device can receive
Date: Wed, 06 Jul 2016 18:01:27 +0900
Message-id: <1467795687-10737-16-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1467795687-10737-1-git-send-email-andi.shyti@samsung.com>
References: <1467795687-10737-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The LIRC_CAN_REC() returns a boolean "flag & LIRC_CAN_REC_MASK"
to check whether the device can receive data.

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/lirc_dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 8cf5e6b..809a867 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -586,7 +586,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		result = put_user(ir->d.features, (__u32 __user *)arg);
 		break;
 	case LIRC_GET_REC_MODE:
-		if (!(ir->d.features & LIRC_CAN_REC_MASK)) {
+		if (LIRC_CAN_REC(ir->d.features)) {
 			result = -ENOTTY;
 			break;
 		}
@@ -596,7 +596,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 				  (__u32 __user *)arg);
 		break;
 	case LIRC_SET_REC_MODE:
-		if (!(ir->d.features & LIRC_CAN_REC_MASK)) {
+		if (LIRC_CAN_REC(ir->d.features)) {
 			result = -ENOTTY;
 			break;
 		}
-- 
2.8.1

