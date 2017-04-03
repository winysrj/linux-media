Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34799 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751732AbdDCXTo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Apr 2017 19:19:44 -0400
From: Alexey Ignatov <lexszero@gmail.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andi Shyti <andi.shyti@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexey Ignatov <lexszero@gmail.com>
Subject: [PATCH] [media] lirc_dev: fix regression in feature check logic in ioctl
Date: Tue,  4 Apr 2017 02:19:16 +0300
Message-Id: <20170403231916.22881-1-lexszero@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 273b902a5b1bfd6977a73c4de3eb96db3cb103cb removed inversion in
features check conditionals (by accident, perhaps). That change resulted
in erroneous reporting that device can't receive while actually it can.
Fix this.

Signed-off-by: Alexey Ignatov <lexszero@gmail.com>
---
 drivers/media/rc/lirc_dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index e65bc9fd1d23..cd07af05be69 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -591,7 +591,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		result = put_user(ir->d.features, (__u32 __user *)arg);
 		break;
 	case LIRC_GET_REC_MODE:
-		if (LIRC_CAN_REC(ir->d.features)) {
+		if (!LIRC_CAN_REC(ir->d.features)) {
 			result = -ENOTTY;
 			break;
 		}
@@ -601,7 +601,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 				  (__u32 __user *)arg);
 		break;
 	case LIRC_SET_REC_MODE:
-		if (LIRC_CAN_REC(ir->d.features)) {
+		if (!LIRC_CAN_REC(ir->d.features)) {
 			result = -ENOTTY;
 			break;
 		}
-- 
2.11.0
