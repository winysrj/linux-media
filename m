Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:56403 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751050AbdFYMbW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 08:31:22 -0400
Subject: [PATCH 01/19] lirc_dev: clarify error handling
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Sun, 25 Jun 2017 14:31:19 +0200
Message-ID: <149839387982.28811.17348183524326346282.stgit@zeus.hardeman.nu>
In-Reply-To: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
References: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If an error is generated, it is more logical to error out ASAP.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/lirc_dev.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index db1e7b70c998..9c1d55e41e34 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -282,7 +282,7 @@ EXPORT_SYMBOL(lirc_unregister_driver);
 int lirc_dev_fop_open(struct inode *inode, struct file *file)
 {
 	struct irctl *ir;
-	int retval = 0;
+	int retval;
 
 	if (iminor(inode) >= MAX_IRCTL_DEVICES) {
 		pr_err("open result for %d is -ENODEV\n", iminor(inode));
@@ -323,9 +323,11 @@ int lirc_dev_fop_open(struct inode *inode, struct file *file)
 
 	ir->open++;
 
-error:
 	nonseekable_open(inode, file);
 
+	return 0;
+
+error:
 	return retval;
 }
 EXPORT_SYMBOL(lirc_dev_fop_open);
