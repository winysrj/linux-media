Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:38609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932998Ab0JHVMn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Oct 2010 17:12:43 -0400
Date: Fri, 8 Oct 2010 17:12:35 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org, lirc-list@lists.sourceforge.net
Cc: Joris van Rantwijk <jorispubl@xs4all.nl>
Subject: [PATCH 1/2] IR/lirc: further ioctl portability fixups
Message-ID: <20101008211235.GF5165@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Joris van Rantwijk <jorispubl@xs4all.nl>

----8<----
I tested lirc_serial and found that it works fine.
Except the LIRC ioctls do not work in my 64-bit-kernel/32-bit-user
setup. I added compat_ioctl entries in the drivers to fix this.

While doing so, I noticed inconsistencies in the argument type of
the LIRC ioctls. All ioctls are declared in lirc.h as having argument
type __u32, however there are a few places where the driver calls
get_user/put_user with an unsigned long argument.

The patch below changes lirc_dev and lirc_serial to use __u32 for all
ioctl arguments, and adds compat_ioctl entries.
It should probably also be done in the other low-level drivers,
but I don't have hardware to test those.
----8<----

I've dropped the .compat_ioctl addition from Joris' original patch,
as I swear the non-compat definition should now work for both 32-bit
and 64-bit userspace. Technically, I think we still need/want a
Signed-off-by: from Joris here. Joris? (And sorry for the lengthy delay
in getting a reply to you).

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/ir-lirc-codec.c |   10 +++++-----
 drivers/media/IR/lirc_dev.c      |   14 +++++++-------
 include/media/lirc_dev.h         |    4 ++--
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/IR/ir-lirc-codec.c b/drivers/media/IR/ir-lirc-codec.c
index e63f757..c6d5b3e 100644
--- a/drivers/media/IR/ir-lirc-codec.c
+++ b/drivers/media/IR/ir-lirc-codec.c
@@ -102,7 +102,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 	struct ir_input_dev *ir_dev;
 	int ret = 0;
 	void *drv_data;
-	unsigned long val = 0;
+	__u32 val = 0;
 
 	lirc = lirc_get_pdata(filep);
 	if (!lirc)
@@ -115,7 +115,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 	drv_data = ir_dev->props->priv;
 
 	if (_IOC_DIR(cmd) & _IOC_WRITE) {
-		ret = get_user(val, (unsigned long *)arg);
+		ret = get_user(val, (__u32 *)arg);
 		if (ret)
 			return ret;
 	}
@@ -135,14 +135,14 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 	/* TX settings */
 	case LIRC_SET_TRANSMITTER_MASK:
 		if (ir_dev->props->s_tx_mask)
-			ret = ir_dev->props->s_tx_mask(drv_data, (u32)val);
+			ret = ir_dev->props->s_tx_mask(drv_data, val);
 		else
 			return -EINVAL;
 		break;
 
 	case LIRC_SET_SEND_CARRIER:
 		if (ir_dev->props->s_tx_carrier)
-			ir_dev->props->s_tx_carrier(drv_data, (u32)val);
+			ir_dev->props->s_tx_carrier(drv_data, val);
 		else
 			return -EINVAL;
 		break;
@@ -212,7 +212,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 	}
 
 	if (_IOC_DIR(cmd) & _IOC_READ)
-		ret = put_user(val, (unsigned long *)arg);
+		ret = put_user(val, (__u32 *)arg);
 
 	return ret;
 }
diff --git a/drivers/media/IR/lirc_dev.c b/drivers/media/IR/lirc_dev.c
index 0572053..e4e4d99 100644
--- a/drivers/media/IR/lirc_dev.c
+++ b/drivers/media/IR/lirc_dev.c
@@ -524,7 +524,7 @@ EXPORT_SYMBOL(lirc_dev_fop_poll);
 
 long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	unsigned long mode;
+	__u32 mode;
 	int result = 0;
 	struct irctl *ir = file->private_data;
 
@@ -541,7 +541,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	switch (cmd) {
 	case LIRC_GET_FEATURES:
-		result = put_user(ir->d.features, (unsigned long *)arg);
+		result = put_user(ir->d.features, (__u32 *)arg);
 		break;
 	case LIRC_GET_REC_MODE:
 		if (!(ir->d.features & LIRC_CAN_REC_MASK)) {
@@ -551,7 +551,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 		result = put_user(LIRC_REC2MODE
 				  (ir->d.features & LIRC_CAN_REC_MASK),
-				  (unsigned long *)arg);
+				  (__u32 *)arg);
 		break;
 	case LIRC_SET_REC_MODE:
 		if (!(ir->d.features & LIRC_CAN_REC_MASK)) {
@@ -559,7 +559,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			break;
 		}
 
-		result = get_user(mode, (unsigned long *)arg);
+		result = get_user(mode, (__u32 *)arg);
 		if (!result && !(LIRC_MODE2REC(mode) & ir->d.features))
 			result = -EINVAL;
 		/*
@@ -568,7 +568,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		 */
 		break;
 	case LIRC_GET_LENGTH:
-		result = put_user(ir->d.code_length, (unsigned long *)arg);
+		result = put_user(ir->d.code_length, (__u32 *)arg);
 		break;
 	case LIRC_GET_MIN_TIMEOUT:
 		if (!(ir->d.features & LIRC_CAN_SET_REC_TIMEOUT) ||
@@ -577,7 +577,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			break;
 		}
 
-		result = put_user(ir->d.min_timeout, (unsigned long *)arg);
+		result = put_user(ir->d.min_timeout, (__u32 *)arg);
 		break;
 	case LIRC_GET_MAX_TIMEOUT:
 		if (!(ir->d.features & LIRC_CAN_SET_REC_TIMEOUT) ||
@@ -586,7 +586,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			break;
 		}
 
-		result = put_user(ir->d.max_timeout, (unsigned long *)arg);
+		result = put_user(ir->d.max_timeout, (__u32 *)arg);
 		break;
 	default:
 		result = -EINVAL;
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index 71a896e..54780a5 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -125,10 +125,10 @@ static inline unsigned int lirc_buffer_write(struct lirc_buffer *buf,
 struct lirc_driver {
 	char name[40];
 	int minor;
-	unsigned long code_length;
+	__u32 code_length;
 	unsigned int buffer_size; /* in chunks holding one code each */
 	int sample_rate;
-	unsigned long features;
+	__u32 features;
 
 	unsigned int chunk_size;
 
-- 
1.7.1

-- 
Jarod Wilson
jarod@redhat.com

