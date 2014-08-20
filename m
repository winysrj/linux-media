Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3025 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbaHTW7s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 18:59:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 29/29] lirc_dev: fix sparse warnings
Date: Thu, 21 Aug 2014 00:59:28 +0200
Message-Id: <1408575568-20562-30-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
References: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/rc/lirc_dev.c:598:26: warning: incorrect type in argument 1 (different address spaces)
drivers/media/rc/lirc_dev.c:606:26: warning: incorrect type in argument 1 (different address spaces)
drivers/media/rc/lirc_dev.c:616:26: warning: incorrect type in argument 1 (different address spaces)
drivers/media/rc/lirc_dev.c:625:26: warning: incorrect type in argument 1 (different address spaces)
drivers/media/rc/lirc_dev.c:634:26: warning: incorrect type in argument 1 (different address spaces)
drivers/media/rc/lirc_dev.c:643:26: warning: incorrect type in argument 1 (different address spaces)
drivers/media/rc/lirc_dev.c:739:45: warning: cast removes address space of expression
drivers/media/rc/lirc_dev.c:739:58: warning: incorrect type in argument 1 (different address spaces)

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/rc/lirc_dev.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index dc5cbff..249d2fb 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -595,7 +595,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	switch (cmd) {
 	case LIRC_GET_FEATURES:
-		result = put_user(ir->d.features, (__u32 *)arg);
+		result = put_user(ir->d.features, (__u32 __user *)arg);
 		break;
 	case LIRC_GET_REC_MODE:
 		if (!(ir->d.features & LIRC_CAN_REC_MASK)) {
@@ -605,7 +605,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 		result = put_user(LIRC_REC2MODE
 				  (ir->d.features & LIRC_CAN_REC_MASK),
-				  (__u32 *)arg);
+				  (__u32 __user *)arg);
 		break;
 	case LIRC_SET_REC_MODE:
 		if (!(ir->d.features & LIRC_CAN_REC_MASK)) {
@@ -613,7 +613,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			break;
 		}
 
-		result = get_user(mode, (__u32 *)arg);
+		result = get_user(mode, (__u32 __user *)arg);
 		if (!result && !(LIRC_MODE2REC(mode) & ir->d.features))
 			result = -EINVAL;
 		/*
@@ -622,7 +622,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		 */
 		break;
 	case LIRC_GET_LENGTH:
-		result = put_user(ir->d.code_length, (__u32 *)arg);
+		result = put_user(ir->d.code_length, (__u32 __user *)arg);
 		break;
 	case LIRC_GET_MIN_TIMEOUT:
 		if (!(ir->d.features & LIRC_CAN_SET_REC_TIMEOUT) ||
@@ -631,7 +631,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			break;
 		}
 
-		result = put_user(ir->d.min_timeout, (__u32 *)arg);
+		result = put_user(ir->d.min_timeout, (__u32 __user *)arg);
 		break;
 	case LIRC_GET_MAX_TIMEOUT:
 		if (!(ir->d.features & LIRC_CAN_SET_REC_TIMEOUT) ||
@@ -640,7 +640,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			break;
 		}
 
-		result = put_user(ir->d.max_timeout, (__u32 *)arg);
+		result = put_user(ir->d.max_timeout, (__u32 __user *)arg);
 		break;
 	default:
 		result = -EINVAL;
@@ -736,7 +736,7 @@ ssize_t lirc_dev_fop_read(struct file *file,
 			}
 		} else {
 			lirc_buffer_read(ir->buf, buf);
-			ret = copy_to_user((void *)buffer+written, buf,
+			ret = copy_to_user((void __user *)buffer+written, buf,
 					   ir->buf->chunk_size);
 			if (!ret)
 				written += ir->buf->chunk_size;
-- 
2.1.0.rc1

