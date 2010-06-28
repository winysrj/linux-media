Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:62450 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab0F1Pzs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jun 2010 11:55:48 -0400
Received: from localhost (localhost [127.0.0.1])
	by poutre.nerim.net (Postfix) with ESMTP id A4DA139DC84
	for <linux-media@vger.kernel.org>; Mon, 28 Jun 2010 17:55:43 +0200 (CEST)
Received: from poutre.nerim.net ([127.0.0.1])
	by localhost (poutre.nerim.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z+PLZNuQLdDc for <linux-media@vger.kernel.org>;
	Mon, 28 Jun 2010 17:55:42 +0200 (CEST)
Received: from hyperion.delvare (jdelvare.pck.nerim.net [62.212.121.182])
	by poutre.nerim.net (Postfix) with ESMTP id 6632039DC54
	for <linux-media@vger.kernel.org>; Mon, 28 Jun 2010 17:55:42 +0200 (CEST)
Date: Mon, 28 Jun 2010 17:55:43 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] V4L/DVB: cx88: Move I2C IR initialization
Message-ID: <20100628175543.3996cc2d@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move I2C IR initialization from just after I2C bus setup to right
before non-I2C IR initialization. This is the same as was done for
the bttv driver several months ago. Might solve bugs which have not yet
been reported for some cards. It makes both drivers consistent, and
makes it easier to disable IR support (coming soon.)

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/media/video/cx88/cx88-cards.c |    1 +
 drivers/media/video/cx88/cx88-i2c.c   |    6 +++++-
 drivers/media/video/cx88/cx88.h       |    1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

--- linux-2.6.34-rc3.orig/drivers/media/video/cx88/cx88-cards.c	2010-04-09 10:55:01.000000000 +0200
+++ linux-2.6.34-rc3/drivers/media/video/cx88/cx88-cards.c	2010-04-09 17:53:58.000000000 +0200
@@ -3498,6 +3498,7 @@ struct cx88_core *cx88_core_create(struc
 	}
 
 	cx88_card_setup(core);
+	cx88_i2c_init_ir(core);
 	cx88_ir_init(core, pci);
 
 	return core;
--- linux-2.6.34-rc3.orig/drivers/media/video/cx88/cx88-i2c.c	2010-04-09 14:04:04.000000000 +0200
+++ linux-2.6.34-rc3/drivers/media/video/cx88/cx88-i2c.c	2010-04-09 17:53:58.000000000 +0200
@@ -181,6 +181,11 @@ int cx88_i2c_init(struct cx88_core *core
 	} else
 		printk("%s: i2c register FAILED\n", core->name);
 
+	return core->i2c_rc;
+}
+
+void cx88_i2c_init_ir(struct cx88_core *core)
+{
 	/* Instantiate the IR receiver device, if present */
 	if (0 == core->i2c_rc) {
 		struct i2c_board_info info;
@@ -196,7 +201,6 @@ int cx88_i2c_init(struct cx88_core *core
 		i2c_new_probed_device(&core->i2c_adap, &info, addr_list,
 				      i2c_probe_func_quick_read);
 	}
-	return core->i2c_rc;
 }
 
 /* ----------------------------------------------------------------------- */
--- linux-2.6.34-rc3.orig/drivers/media/video/cx88/cx88.h	2010-04-03 18:40:32.000000000 +0200
+++ linux-2.6.34-rc3/drivers/media/video/cx88/cx88.h	2010-04-09 17:53:58.000000000 +0200
@@ -636,6 +636,7 @@ extern struct videobuf_queue_ops cx8800_
 /* cx88-i2c.c                                                  */
 
 extern int cx88_i2c_init(struct cx88_core *core, struct pci_dev *pci);
+extern void cx88_i2c_init_ir(struct cx88_core *core);
 
 
 /* ----------------------------------------------------------- */


-- 
Jean Delvare
