Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:58706 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbcDHXK3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Apr 2016 19:10:29 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	ldv-project@linuxtesting.org
Subject: [PATCH] [media] bt8xx: remove needless module refcounting
Date: Sat,  9 Apr 2016 02:09:49 +0300
Message-Id: <1460156989-14404-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is responsibility of a caller of fops->open(),
to make sure an owner of the fops is available until file is closed.
So, there is no need to lock THIS_MODULE explicitly.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/pci/bt8xx/dst_ca.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/pci/bt8xx/dst_ca.c b/drivers/media/pci/bt8xx/dst_ca.c
index da8b414fd824..8681b9143a35 100644
--- a/drivers/media/pci/bt8xx/dst_ca.c
+++ b/drivers/media/pci/bt8xx/dst_ca.c
@@ -655,7 +655,6 @@ static long dst_ca_ioctl(struct file *file, unsigned int cmd, unsigned long ioct
 static int dst_ca_open(struct inode *inode, struct file *file)
 {
 	dprintk(verbose, DST_CA_DEBUG, 1, " Device opened [%p] ", file);
-	try_module_get(THIS_MODULE);
 
 	return 0;
 }
@@ -663,7 +662,6 @@ static int dst_ca_open(struct inode *inode, struct file *file)
 static int dst_ca_release(struct inode *inode, struct file *file)
 {
 	dprintk(verbose, DST_CA_DEBUG, 1, " Device closed.");
-	module_put(THIS_MODULE);
 
 	return 0;
 }
-- 
1.9.1

