Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:42829 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751070AbcLBRRJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Dec 2016 12:17:09 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: Andi Shyti <andi.shyti@samsung.com>, <stable@vger.kernel.org>
Subject: [PATCH 2/8] [media] lirc_dev: LIRC_{G,S}ET_REC_MODE do not work
Date: Fri,  2 Dec 2016 17:16:08 +0000
Message-Id: <1480698974-9093-2-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since "273b902 [media] lirc_dev: use LIRC_CAN_REC() define" these
ioctls no longer work.

Signed-off-by: Sean Young <sean@mess.org>
Cc: Andi Shyti <andi.shyti@samsung.com>
Cc: <stable@vger.kernel.org> # v4.8+
---
 drivers/media/rc/lirc_dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 3854809..7f5d109 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -582,7 +582,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		result = put_user(ir->d.features, (__u32 __user *)arg);
 		break;
 	case LIRC_GET_REC_MODE:
-		if (LIRC_CAN_REC(ir->d.features)) {
+		if (!LIRC_CAN_REC(ir->d.features)) {
 			result = -ENOTTY;
 			break;
 		}
@@ -592,7 +592,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 				  (__u32 __user *)arg);
 		break;
 	case LIRC_SET_REC_MODE:
-		if (LIRC_CAN_REC(ir->d.features)) {
+		if (!LIRC_CAN_REC(ir->d.features)) {
 			result = -ENOTTY;
 			break;
 		}
-- 
2.9.3

