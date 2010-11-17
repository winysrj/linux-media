Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33082 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab0KQFOF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 00:14:05 -0500
Date: Wed, 17 Nov 2010 08:13:39 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jarod Wilson <jarod@redhat.com>,
	Zimny Lech <napohybelskurwysynom2010@gmail.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 2/3] [media] lirc_dev: add some __user annotations
Message-ID: <20101117051339.GE31724@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Sparse complains because there are no __user annotations.

drivers/media/IR/lirc_dev.c:156:27: warning:
	incorrect type in initializer (incompatible argument 2 (different address spaces))
drivers/media/IR/lirc_dev.c:156:27:    expected int ( *read )( ... )
drivers/media/IR/lirc_dev.c:156:27:    got int ( extern [toplevel] *<noident> )( ... )

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index 54780a5..630e702 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -217,9 +217,9 @@ int lirc_dev_fop_open(struct inode *inode, struct file *file);
 int lirc_dev_fop_close(struct inode *inode, struct file *file);
 unsigned int lirc_dev_fop_poll(struct file *file, poll_table *wait);
 long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
-ssize_t lirc_dev_fop_read(struct file *file, char *buffer, size_t length,
+ssize_t lirc_dev_fop_read(struct file *file, char __user *buffer, size_t length,
 			  loff_t *ppos);
-ssize_t lirc_dev_fop_write(struct file *file, const char *buffer, size_t length,
-			   loff_t *ppos);
+ssize_t lirc_dev_fop_write(struct file *file, const char __user *buffer,
+			   size_t length, loff_t *ppos);
 
 #endif
diff --git a/drivers/media/IR/lirc_dev.c b/drivers/media/IR/lirc_dev.c
index 8ab9d87..fbca94f 100644
--- a/drivers/media/IR/lirc_dev.c
+++ b/drivers/media/IR/lirc_dev.c
@@ -627,7 +627,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 EXPORT_SYMBOL(lirc_dev_fop_ioctl);
 
 ssize_t lirc_dev_fop_read(struct file *file,
-			  char *buffer,
+			  char __user *buffer,
 			  size_t length,
 			  loff_t *ppos)
 {
@@ -742,7 +742,7 @@ void *lirc_get_pdata(struct file *file)
 EXPORT_SYMBOL(lirc_get_pdata);
 
 
-ssize_t lirc_dev_fop_write(struct file *file, const char *buffer,
+ssize_t lirc_dev_fop_write(struct file *file, const char __user *buffer,
 			   size_t length, loff_t *ppos)
 {
 	struct irctl *ir = irctls[iminor(file->f_dentry->d_inode)];
