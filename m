Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:41315 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758718AbdEAQEp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 12:04:45 -0400
Subject: [PATCH 10/16] lirc_dev: remove superfluous get/put_device() calls
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Mon, 01 May 2017 18:04:26 +0200
Message-ID: <149365466682.12922.11735486114121409407.stgit@zeus.hardeman.nu>
In-Reply-To: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
References: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

device_add() and friends alredy manage the references to the parent device so
these calls aren't necessary.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/lirc_dev.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 574f4dd416b8..34bd3f8bf30d 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -69,8 +69,6 @@ static void lirc_release(struct device *ld)
 {
 	struct irctl *ir = container_of(ld, struct irctl, dev);
 
-	put_device(ir->dev.parent);
-
 	if (ir->buf_internal) {
 		lirc_buffer_free(ir->buf);
 		kfree(ir->buf);
@@ -230,8 +228,6 @@ int lirc_register_driver(struct lirc_driver *d)
 
 	mutex_unlock(&lirc_dev_lock);
 
-	get_device(ir->dev.parent);
-
 	dev_info(ir->d.dev, "lirc_dev: driver %s registered at minor = %d\n",
 		 ir->d.name, ir->d.minor);
 
