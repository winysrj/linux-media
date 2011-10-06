Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:59029 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab1JFGl0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 02:41:26 -0400
Date: Thu, 6 Oct 2011 09:41:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jarod Wilson <jarod@redhat.com>,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	"open list:MEDIA INPUT INFRA..." <linux-media@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] rc/ir-lirc-codec: cleanup __user tags
Message-ID: <20111006064106.GB2615@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The code here treated user pointers correctly, but the __user tags
weren't used correctly so it caused Sparse warnings:

drivers/media/rc/ir-lirc-codec.c:122:29: warning: incorrect type in argument 1 (different address spaces)
drivers/media/rc/ir-lirc-codec.c:122:29:    expected void const [noderef] <asn:1>*<noident>
drivers/media/rc/ir-lirc-codec.c:122:29:    got char const *buf
drivers/media/rc/ir-lirc-codec.c:160:23: warning: incorrect type in argument 1 (different address spaces)
drivers/media/rc/ir-lirc-codec.c:160:23:    expected void const volatile [noderef] <asn:1>*<noident>
drivers/media/rc/ir-lirc-codec.c:160:23:    got unsigned int [usertype] *<noident>
drivers/media/rc/ir-lirc-codec.c:269:23: warning: incorrect type in argument 1 (different address spaces)
drivers/media/rc/ir-lirc-codec.c:269:23:    expected void const volatile [noderef] <asn:1>*<noident>
drivers/media/rc/ir-lirc-codec.c:269:23:    got unsigned int [usertype] *<noident>
drivers/media/rc/ir-lirc-codec.c:286:27: warning: incorrect type in initializer (incompatible argument 2 (different address spaces))
drivers/media/rc/ir-lirc-codec.c:286:27:    expected long ( *write )( ... )
drivers/media/rc/ir-lirc-codec.c:286:27:    got long ( static [toplevel] *<noident> )( ... )
drivers/media/rc/ir-lirc-codec.c:287:27: warning: incorrect type in initializer (incompatible argument 3 (different address spaces))
drivers/media/rc/ir-lirc-codec.c:287:27:    expected long ( *unlocked_ioctl )( ... )
drivers/media/rc/ir-lirc-codec.c:287:27:    got long ( static [toplevel] *<noident> )( ... )
drivers/media/rc/ir-lirc-codec.c:289:27: warning: incorrect type in initializer (incompatible argument 3 (different address spaces))
drivers/media/rc/ir-lirc-codec.c:289:27:    expected long ( *compat_ioctl )( ... )
drivers/media/rc/ir-lirc-codec.c:289:27:    got long ( static [toplevel] *<noident> )( ... )
drivers/media/rc/ir-lirc-codec.c:160:23: warning: dereference of noderef expression
drivers/media/rc/ir-lirc-codec.c:265:55: warning: dereference of noderef expression
drivers/media/rc/ir-lirc-codec.c:269:23: warning: dereference of noderef expression

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 165ea8f..5faba2a 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -99,7 +99,7 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	return 0;
 }
 
-static ssize_t ir_lirc_transmit_ir(struct file *file, const char *buf,
+static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 				   size_t n, loff_t *ppos)
 {
 	struct lirc_codec *lirc;
@@ -141,10 +141,11 @@ out:
 }
 
 static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
-			unsigned long __user arg)
+			unsigned long arg)
 {
 	struct lirc_codec *lirc;
 	struct rc_dev *dev;
+	u32 __user *argp = (u32 __user *)(arg);
 	int ret = 0;
 	__u32 val = 0, tmp;
 
@@ -157,7 +158,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 		return -EFAULT;
 
 	if (_IOC_DIR(cmd) & _IOC_WRITE) {
-		ret = get_user(val, (__u32 *)arg);
+		ret = get_user(val, argp);
 		if (ret)
 			return ret;
 	}
@@ -266,7 +267,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 	}
 
 	if (_IOC_DIR(cmd) & _IOC_READ)
-		ret = put_user(val, (__u32 *)arg);
+		ret = put_user(val, argp);
 
 	return ret;
 }
