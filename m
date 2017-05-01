Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:41252 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757788AbdEAQDx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 12:03:53 -0400
Subject: [PATCH 03/16] lirc_dev: correct error handling
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Mon, 01 May 2017 18:03:51 +0200
Message-ID: <149365463117.12922.15518669536847504845.stgit@zeus.hardeman.nu>
In-Reply-To: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
References: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If an error is generated, nonseekable_open() shouldn't be called.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/lirc_dev.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 05f600bd6c67..7f13ed479e1c 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -431,7 +431,7 @@ EXPORT_SYMBOL(lirc_unregister_driver);
 int lirc_dev_fop_open(struct inode *inode, struct file *file)
 {
 	struct irctl *ir;
-	int retval = 0;
+	int retval;
 
 	if (iminor(inode) >= MAX_IRCTL_DEVICES) {
 		pr_err("open result for %d is -ENODEV\n", iminor(inode));
@@ -475,9 +475,11 @@ int lirc_dev_fop_open(struct inode *inode, struct file *file)
 
 	ir->open++;
 
-error:
 	nonseekable_open(inode, file);
 
+	return 0;
+
+error:
 	return retval;
 }
 EXPORT_SYMBOL(lirc_dev_fop_open);
