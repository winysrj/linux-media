Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33538 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953Ab1EZIw2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 04:52:28 -0400
Date: Thu, 26 May 2011 11:52:01 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jarod Wilson <jarod@redhat.com>,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Dmitry Torokhov <dtor@mail.ru>,
	"open list:MEDIA INPUT INFRA..." <linux-media@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] rc: double unlock in rc_register_device()
Message-ID: <20110526085201.GF14591@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

If change_protocol() fails and we goto out_raw, then it calls unlock
twice.  I noticed that the other time we called change_protocol() we
held the &dev->lock, so I changed it to hold it here too.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Compile tested only.

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index f57cd56..136a6c6 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1097,7 +1097,6 @@ int rc_register_device(struct rc_dev *dev)
 		if (rc < 0)
 			goto out_input;
 	}
-	mutex_unlock(&dev->lock);
 
 	if (dev->change_protocol) {
 		rc = dev->change_protocol(dev, rc_map->rc_type);
@@ -1105,6 +1104,8 @@ int rc_register_device(struct rc_dev *dev)
 			goto out_raw;
 	}
 
+	mutex_unlock(&dev->lock);
+
 	IR_dprintk(1, "Registered rc%ld (driver: %s, remote: %s, mode %s)\n",
 		   dev->devno,
 		   dev->driver_name ? dev->driver_name : "unknown",
