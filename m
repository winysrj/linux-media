Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:5767 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbZDQUcv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 16:32:51 -0400
Received: from jdelvare.pck.nerim.net ([62.212.121.182] helo=hyperion.delvare)
	by services.gcu-squad.org (GCU Mailer Daemon) with esmtpsa id 1LuvpE-00029H-9L
	(TLSv1:AES256-SHA:256)
	(envelope-from <khali@linux-fr.org>)
	for linux-media@vger.kernel.org; Fri, 17 Apr 2009 23:42:20 +0200
Date: Fri, 17 Apr 2009 22:32:45 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Subject: [PATCH 4/6] ir-kbd-i2c: Don't assume all IR receivers are supported
Message-ID: <20090417223245.6af63a45@hyperion.delvare>
In-Reply-To: <20090417222927.7a966350@hyperion.delvare>
References: <20090417222927.7a966350@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The code in ir_probe makes the dangerous assumption that all IR
receivers are supported by the driver. The new i2c model makes it
possible for bridge drivers to instantiate IR devices before they are
supported, therefore the ir-kbd-i2c drivers must be made more robust
to not spam the logs or even crash on unsupported IR devices. Simply,
the driver will not bind to the unsupported devices.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Andy Walls <awalls@radix.net>
---
 linux/drivers/media/video/ir-kbd-i2c.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- v4l-dvb.orig/linux/drivers/media/video/ir-kbd-i2c.c	2009-04-07 21:35:53.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/ir-kbd-i2c.c	2009-04-07 22:49:10.000000000 +0200
@@ -307,7 +307,7 @@ static void ir_work(struct work_struct *
 static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	IR_KEYTAB_TYPE *ir_codes = NULL;
-	const char *name;
+	const char *name = NULL;
 	int ir_type;
 	struct IR_i2c *ir;
 	struct input_dev *input_dev;
@@ -389,8 +389,7 @@ static int ir_probe(struct i2c_client *c
 		ir_codes    = ir_codes_avermedia_cardbus;
 		break;
 	default:
-		/* shouldn't happen */
-		printk(DEVNAME ": Huh? unknown i2c address (0x%02x)?\n", addr);
+		dprintk(1, DEVNAME ": Unsupported i2c address 0x%02x\n", addr);
 		err = -ENODEV;
 		goto err_out_free;
 	}
@@ -405,6 +404,14 @@ static int ir_probe(struct i2c_client *c
 		ir->get_key = init_data->get_key;
 	}
 
+	/* Make sure we are all setup before going on */
+	if (!name || !ir->get_key || !ir_codes) {
+		dprintk(1, DEVNAME ": Unsupported device at address 0x%02x\n",
+			addr);
+		err = -ENODEV;
+		goto err_out_free;
+	}
+
 	/* Sets name */
 	snprintf(ir->name, sizeof(ir->name), "i2c IR (%s)", name);
 	ir->ir_codes = ir_codes;

-- 
Jean Delvare
