Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:59570 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab1KXJHJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 04:07:09 -0500
Date: Thu, 24 Nov 2011 12:06:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jarod Wilson <jarod@redhat.com>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 1/2] staging/media: lirc_imon: add a __user annotation
Message-ID: <20111124090621.GA22994@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This silences the following Sparse warnings:

lirc_imon.c:404:32: warning: incorrect type in argument 1 (different address spaces)
lirc_imon.c:404:32:    expected void const [noderef] <asn:1>*<noident>
lirc_imon.c:404:32:    got char const *buf
lirc_imon.c:117:28: warning: incorrect type in initializer (incompatible argument 2 (different address spaces))
lirc_imon.c:117:28:    expected long ( *write )( ... )
lirc_imon.c:117:28:    got long ( static [toplevel] *<noident> )( ... )

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
index f682180..5f7f8cd 100644
--- a/drivers/staging/media/lirc/lirc_imon.c
+++ b/drivers/staging/media/lirc/lirc_imon.c
@@ -63,7 +63,7 @@ static int display_open(struct inode *inode, struct file *file);
 static int display_close(struct inode *inode, struct file *file);
 
 /* VFD write operation */
-static ssize_t vfd_write(struct file *file, const char *buf,
+static ssize_t vfd_write(struct file *file, const char __user *buf,
 			 size_t n_bytes, loff_t *pos);
 
 /* LIRC driver function prototypes */
@@ -369,7 +369,7 @@ static int send_packet(struct imon_context *context)
  * than 32 bytes are provided spaces will be appended to
  * generate a full screen.
  */
-static ssize_t vfd_write(struct file *file, const char *buf,
+static ssize_t vfd_write(struct file *file, const char __user *buf,
 			 size_t n_bytes, loff_t *pos)
 {
 	int i;
