Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33473 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbaIDLK0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Sep 2014 07:10:26 -0400
Date: Thu, 4 Sep 2014 14:10:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] staging: lirc: freeing ERR_PTRs
Message-ID: <20140904111005.GC21504@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We call kfree(data_buf) in the error handling and that will oops if this
is an error pointer.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
index 96c76b3..5441f40 100644
--- a/drivers/staging/media/lirc/lirc_imon.c
+++ b/drivers/staging/media/lirc/lirc_imon.c
@@ -414,6 +414,7 @@ static ssize_t vfd_write(struct file *file, const char __user *buf,
 	data_buf = memdup_user(buf, n_bytes);
 	if (IS_ERR(data_buf)) {
 		retval = PTR_ERR(data_buf);
+		data_buf = NULL;
 		goto exit;
 	}
 
diff --git a/drivers/staging/media/lirc/lirc_sasem.c b/drivers/staging/media/lirc/lirc_sasem.c
index 81f90e1..c32e296 100644
--- a/drivers/staging/media/lirc/lirc_sasem.c
+++ b/drivers/staging/media/lirc/lirc_sasem.c
@@ -392,6 +392,7 @@ static ssize_t vfd_write(struct file *file, const char __user *buf,
 	data_buf = memdup_user((void const __user *)buf, n_bytes);
 	if (IS_ERR(data_buf)) {
 		retval = PTR_ERR(data_buf);
+		data_buf = NULL;
 		goto exit;
 	}
 
