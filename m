Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46419 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab1HIP4q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Aug 2011 11:56:46 -0400
Date: Tue, 9 Aug 2011 18:52:38 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Oliver Endriss <o.endriss@gmx.de>,
	Ralph Metzler <rmetzler@digitaldevices.de>,
	"open list:MEDIA INPUT INFRA..." <linux-media@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] ddbridge: fix ddb_ioctl()
Message-ID: <20110809155238.GA3830@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There were a several problems in this function:

1) Potential integer overflow in the comparison:
	if (fio.write_len + fio.read_len > 1028) { 

2) If the user gave bogus values for write_len and read_len then
   returning -EINVAL is more appropriate than returning -ENOMEM.

3) wbuf was set to the address of an array and could never be NULL
   so I removed the pointless NULL check.

4) The call to vfree(wbuf) was improper.  That array is part of a
   larger struct and isn't allocated by itself.

5) flashio() can't actually fail, but we may as well add error
   handling in case this changes later.

6) In the default case where an ioctl is not implemented then
   returning -ENOTTY is more appropriate than returning -EFAULT.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/dvb/ddbridge/ddbridge-core.c b/drivers/media/dvb/ddbridge/ddbridge-core.c
index 573d540..fe56703 100644
--- a/drivers/media/dvb/ddbridge/ddbridge-core.c
+++ b/drivers/media/dvb/ddbridge/ddbridge-core.c
@@ -1438,7 +1438,7 @@ static long ddb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct ddb *dev = file->private_data;
 	void *parg = (void *)arg;
-	int res = -EFAULT;
+	int res;
 
 	switch (cmd) {
 	case IOCTL_DDB_FLASHIO:
@@ -1447,29 +1447,29 @@ static long ddb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		u8 *rbuf, *wbuf;
 
 		if (copy_from_user(&fio, parg, sizeof(fio)))
-			break;
-		if (fio.write_len + fio.read_len > 1028) {
-			printk(KERN_ERR "IOBUF too small\n");
-			return -ENOMEM;
-		}
+			return -EFAULT;
+
+		if (fio.write_len > 1028 || fio.read_len > 1028)
+			return -EINVAL;
+		if (fio.write_len + fio.read_len > 1028)
+			return -EINVAL;
+
 		wbuf = &dev->iobuf[0];
-		if (!wbuf)
-			return -ENOMEM;
 		rbuf = wbuf + fio.write_len;
-		if (copy_from_user(wbuf, fio.write_buf, fio.write_len)) {
-			vfree(wbuf);
-			break;
-		}
-		res = flashio(dev, wbuf, fio.write_len,
-			      rbuf, fio.read_len);
+
+		if (copy_from_user(wbuf, fio.write_buf, fio.write_len))
+			return -EFAULT;
+		res = flashio(dev, wbuf, fio.write_len, rbuf, fio.read_len);
+		if (res)
+			return res;
 		if (copy_to_user(fio.read_buf, rbuf, fio.read_len))
-			res = -EFAULT;
+			return -EFAULT;
 		break;
 	}
 	default:
-		break;
+		return -ENOTTY;
 	}
-	return res;
+	return 0;
 }
 
 static const struct file_operations ddb_fops = {
