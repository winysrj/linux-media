Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44318 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbaICUd3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:29 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 37/46] [media] bt8xx: just return 0 instead of using a var
Date: Wed,  3 Sep 2014 17:33:09 -0300
Message-Id: <f672fd1dec9efb4ee27f9d155f12272326597f1a.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of allocating a var to store 0 and just return it,
change the code to return 0 directly.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 750bdab8aacb..4a8176c09fc9 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -1531,7 +1531,6 @@ bttv_switch_overlay(struct bttv *btv, struct bttv_fh *fh,
 {
 	struct bttv_buffer *old;
 	unsigned long flags;
-	int retval = 0;
 
 	dprintk("switch_overlay: enter [new=%p]\n", new);
 	if (new)
@@ -1551,7 +1550,7 @@ bttv_switch_overlay(struct bttv *btv, struct bttv_fh *fh,
 	if (NULL == new)
 		free_btres_lock(btv,fh,RESOURCE_OVERLAY);
 	dprintk("switch_overlay: done\n");
-	return retval;
+	return 0;
 }
 
 /* ----------------------------------------------------------------------- */
diff --git a/drivers/media/pci/bt8xx/dst_ca.c b/drivers/media/pci/bt8xx/dst_ca.c
index 0e788fca992c..c22c4ae06844 100644
--- a/drivers/media/pci/bt8xx/dst_ca.c
+++ b/drivers/media/pci/bt8xx/dst_ca.c
@@ -674,11 +674,9 @@ static int dst_ca_release(struct inode *inode, struct file *file)
 
 static ssize_t dst_ca_read(struct file *file, char __user *buffer, size_t length, loff_t *offset)
 {
-	ssize_t bytes_read = 0;
-
 	dprintk(verbose, DST_CA_DEBUG, 1, " Device read.");
 
-	return bytes_read;
+	return 0;
 }
 
 static ssize_t dst_ca_write(struct file *file, const char __user *buffer, size_t length, loff_t *offset)
-- 
1.9.3

