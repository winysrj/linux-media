Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33199 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752018AbdI0OLe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 10:11:34 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        mjpeg-users@lists.sourceforge.net, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [media] zoran: make zoran_template const
Date: Wed, 27 Sep 2017 19:41:19 +0530
Message-Id: <1506521479-18217-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make this constas it is only used in a copy operation in the file
referencing it. Make the declaration const too.

Done using Coccinelle.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/pci/zoran/zoran_card.h   | 2 +-
 drivers/media/pci/zoran/zoran_driver.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/zoran/zoran_card.h b/drivers/media/pci/zoran/zoran_card.h
index 81cba17..0cdb7d3 100644
--- a/drivers/media/pci/zoran/zoran_card.h
+++ b/drivers/media/pci/zoran/zoran_card.h
@@ -37,7 +37,7 @@
 /* Anybody who uses more than four? */
 #define BUZ_MAX 4
 
-extern struct video_device zoran_template;
+extern const struct video_device zoran_template;
 
 extern int zoran_check_jpg_settings(struct zoran *zr,
 				    struct zoran_jpg_settings *settings,
diff --git a/drivers/media/pci/zoran/zoran_driver.c b/drivers/media/pci/zoran/zoran_driver.c
index a11cb50..d078400 100644
--- a/drivers/media/pci/zoran/zoran_driver.c
+++ b/drivers/media/pci/zoran/zoran_driver.c
@@ -2839,7 +2839,7 @@ static int zoran_s_jpegcomp(struct file *file, void *__fh,
 	.poll = zoran_poll,
 };
 
-struct video_device zoran_template = {
+const struct video_device zoran_template = {
 	.name = ZORAN_NAME,
 	.fops = &zoran_fops,
 	.ioctl_ops = &zoran_ioctl_ops,
-- 
1.9.1
