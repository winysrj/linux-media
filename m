Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:31523 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbZDDM2r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Apr 2009 08:28:47 -0400
Date: Sat, 4 Apr 2009 14:28:37 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Andy Walls <awalls@radix.net>, Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely <isely@pobox.com>
Subject: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
 model
Message-ID: <20090404142837.3e12824c@hyperion.delvare>
In-Reply-To: <20090404142427.6e81f316@hyperion.delvare>
References: <20090404142427.6e81f316@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Let card drivers probe for IR receiver devices and instantiate them if
found. Ultimately it would be better if we could stop probing
completely, but I suspect this won't be possible for all card types.

There's certainly room for cleanups. For example, some drivers are
sharing I2C adapter IDs, so they also had to share the list of I2C
addresses being probed for an IR receiver. Now that each driver
explicitly says which addresses should be probed, maybe some addresses
can be dropped from some drivers.

Also, the special cases in saa7134-i2c should probably be handled on a
per-board basis. This would be more efficient and less risky than always
probing extra addresses on all boards. I'll give it a try later.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andy Walls <awalls@radix.net>
Cc: Mike Isely <isely@pobox.com>
---
 linux/drivers/media/video/bt8xx/bttv-i2c.c           |   21 +
 linux/drivers/media/video/cx18/cx18-i2c.c            |   30 ++
 linux/drivers/media/video/cx231xx/cx231xx-cards.c    |    5 
 linux/drivers/media/video/cx23885/cx23885-i2c.c      |   12 +
 linux/drivers/media/video/cx88/cx88-i2c.c            |   13 +
 linux/drivers/media/video/em28xx/em28xx-cards.c      |   20 +
 linux/drivers/media/video/em28xx/em28xx-i2c.c        |    3 
 linux/drivers/media/video/em28xx/em28xx-input.c      |    6 
 linux/drivers/media/video/em28xx/em28xx.h            |    1 
 linux/drivers/media/video/ir-kbd-i2c.c               |  198 ++----------------
 linux/drivers/media/video/ivtv/ivtv-i2c.c            |   31 ++
 linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c |   24 ++
 linux/drivers/media/video/saa7134/saa7134-i2c.c      |    3 
 linux/drivers/media/video/saa7134/saa7134-input.c    |   86 ++++++-
 linux/drivers/media/video/saa7134/saa7134.h          |    1 
 linux/drivers/media/video/usbvision/usbvision-i2c.c  |   24 ++
 linux/include/media/ir-kbd-i2c.h                     |    2 
 17 files changed, 284 insertions(+), 196 deletions(-)

--- v4l-dvb.orig/linux/drivers/media/video/bt8xx/bttv-i2c.c	2009-04-04 10:53:08.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/bt8xx/bttv-i2c.c	2009-04-04 10:58:36.000000000 +0200
@@ -405,6 +405,27 @@ int __devinit init_bttv_i2c(struct bttv
 	}
 	if (0 == btv->i2c_rc && i2c_scan)
 		do_i2c_scan(btv->c.v4l2_dev.name, &btv->i2c_client);
+
+	/* Instantiate the IR receiver device, if present */
+	if (0 == btv->i2c_rc) {
+		struct i2c_board_info info;
+		/* The external IR receiver is at i2c address 0x34 (0x35 for
+		   reads).  Future Hauppauge cards will have an internal
+		   receiver at 0x30 (0x31 for reads).  In theory, both can be
+		   fitted, and Hauppauge suggest an external overrides an
+		   internal.
+
+		   That's why we probe 0x1a (~0x34) first. CB
+		*/
+		const unsigned short addr_list[] = {
+			0x1a, 0x18, 0x4b, 0x64, 0x30,
+			I2C_CLIENT_END
+		};
+
+		memset(&info, 0, sizeof(struct i2c_board_info));
+		strlcpy(info.type, "ir-kbd", I2C_NAME_SIZE);
+		i2c_new_probed_device(&btv->c.i2c_adap, &info, addr_list);
+	}
 	return btv->i2c_rc;
 }
 
--- v4l-dvb.orig/linux/drivers/media/video/cx18/cx18-i2c.c	2009-04-04 10:53:15.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/cx18/cx18-i2c.c	2009-04-04 10:58:36.000000000 +0200
@@ -211,7 +211,32 @@ static struct i2c_algo_bit_data cx18_i2c
 	.timeout	= CX18_ALGO_BIT_TIMEOUT*HZ /* jiffies */
 };
 
-/* init + register i2c algo-bit adapter */
+static void init_cx18_i2c_ir(struct cx18 *cx)
+{
+	struct i2c_board_info info;
+	/* The external IR receiver is at i2c address 0x34 (0x35 for
+	   reads).  Future Hauppauge cards will have an internal
+	   receiver at 0x30 (0x31 for reads).  In theory, both can be
+	   fitted, and Hauppauge suggest an external overrides an
+	   internal.
+
+	   That's why we probe 0x1a (~0x34) first. CB
+	*/
+	const unsigned short addr_list[] = {
+		0x1a, 0x18, 0x64, 0x30,
+		I2C_CLIENT_END
+	};
+
+	memset(&info, 0, sizeof(struct i2c_board_info));
+	strlcpy(info.type, "ir-kbd", I2C_NAME_SIZE);
+
+	/* The IR receiver device can be on either I2C bus */
+	if (i2c_new_probed_device(&cx->i2c_adap[0], &info, addr_list))
+		return;
+	i2c_new_probed_device(&cx->i2c_adap[1], &info, addr_list);
+}
+
+/* init + register i2c adapters + instantiate IR receiver */
 int init_cx18_i2c(struct cx18 *cx)
 {
 	int i, err;
@@ -279,6 +304,9 @@ int init_cx18_i2c(struct cx18 *cx)
 	err = i2c_bit_add_bus(&cx->i2c_adap[1]);
 	if (err)
 		goto err_del_bus_0;
+
+	/* Instantiate the IR receiver device, if present */
+	init_cx18_i2c_ir(cx);
 	return 0;
 
  err_del_bus_0:
--- v4l-dvb.orig/linux/drivers/media/video/cx231xx/cx231xx-cards.c	2009-04-04 10:53:08.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/cx231xx/cx231xx-cards.c	2009-04-04 12:56:26.000000000 +0200
@@ -284,11 +284,6 @@ static void cx231xx_config_tuner(struct
 /* ----------------------------------------------------------------------- */
 void cx231xx_set_ir(struct cx231xx *dev, struct IR_i2c *ir)
 {
-	if (disable_ir) {
-		ir->get_key = NULL;
-		return;
-	}
-
 	/* detect & configure */
 	switch (dev->model) {
 
--- v4l-dvb.orig/linux/drivers/media/video/cx23885/cx23885-i2c.c	2009-04-04 10:53:08.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/cx23885/cx23885-i2c.c	2009-04-04 10:58:36.000000000 +0200
@@ -364,6 +364,18 @@ int cx23885_i2c_register(struct cx23885_
 		printk(KERN_WARNING "%s: i2c bus %d register FAILED\n",
 			dev->name, bus->nr);
 
+	/* Instantiate the IR receiver device, if present */
+	if (0 == bus->i2c_rc) {
+		struct i2c_board_info info;
+		const unsigned short addr_list[] = {
+			0x6b, I2C_CLIENT_END
+		};
+
+		memset(&info, 0, sizeof(struct i2c_board_info));
+		strlcpy(info.type, "ir-kbd", I2C_NAME_SIZE);
+		i2c_new_probed_device(&bus->i2c_adap, &info, addr_list);
+	}
+
 	return bus->i2c_rc;
 }
 
--- v4l-dvb.orig/linux/drivers/media/video/cx88/cx88-i2c.c	2009-04-04 10:53:08.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/cx88/cx88-i2c.c	2009-04-04 10:58:36.000000000 +0200
@@ -186,6 +186,19 @@ int cx88_i2c_init(struct cx88_core *core
 			do_i2c_scan(core->name,&core->i2c_client);
 	} else
 		printk("%s: i2c register FAILED\n", core->name);
+
+	/* Instantiate the IR receiver device, if present */
+	if (0 == core->i2c_rc) {
+		struct i2c_board_info info;
+		const unsigned short addr_list[] = {
+			0x18, 0x6b, 0x71,
+			I2C_CLIENT_END
+		};
+
+		memset(&info, 0, sizeof(struct i2c_board_info));
+		strlcpy(info.type, "ir-kbd", I2C_NAME_SIZE);
+		i2c_new_probed_device(&core->i2c_adap, &info, addr_list);
+	}
 	return core->i2c_rc;
 }
 
--- v4l-dvb.orig/linux/drivers/media/video/em28xx/em28xx-cards.c	2009-04-04 10:57:57.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/em28xx/em28xx-cards.c	2009-04-04 12:56:26.000000000 +0200
@@ -1904,13 +1904,23 @@ static int em28xx_hint_board(struct em28
 }
 
 /* ----------------------------------------------------------------------- */
-void em28xx_set_ir(struct em28xx *dev, struct IR_i2c *ir)
+void em28xx_register_i2c_ir(struct em28xx *dev)
 {
-	if (disable_ir) {
-		ir->get_key = NULL;
-		return ;
-	}
+	struct i2c_board_info info;
+	const unsigned short addr_list[] = {
+		 0x30, 0x47, I2C_CLIENT_END
+	};
+
+	if (disable_ir)
+		return;
+
+	memset(&info, 0, sizeof(struct i2c_board_info));
+	strlcpy(info.type, "ir-kbd", I2C_NAME_SIZE);
+	i2c_new_probed_device(&dev->i2c_adap, &info, addr_list);
+}
 
+void em28xx_set_ir(struct em28xx *dev, struct IR_i2c *ir)
+{
 	/* detect & configure */
 	switch (dev->model) {
 	case (EM2800_BOARD_UNKNOWN):
--- v4l-dvb.orig/linux/drivers/media/video/em28xx/em28xx-i2c.c	2009-04-04 10:53:08.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/em28xx/em28xx-i2c.c	2009-04-04 12:56:26.000000000 +0200
@@ -581,6 +581,9 @@ int em28xx_i2c_register(struct em28xx *d
 	if (i2c_scan)
 		em28xx_do_i2c_scan(dev);
 
+	/* Instantiate the IR receiver device, if present */
+	em28xx_register_i2c_ir(dev);
+
 	return 0;
 }
 
--- v4l-dvb.orig/linux/drivers/media/video/em28xx/em28xx-input.c	2009-04-04 10:57:57.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/em28xx/em28xx-input.c	2009-04-04 10:58:36.000000000 +0200
@@ -86,7 +86,7 @@ int em28xx_get_key_terratec(struct IR_i2
 	unsigned char b;
 
 	/* poll IR chip */
-	if (1 != i2c_master_recv(&ir->c, &b, 1)) {
+	if (1 != i2c_master_recv(ir->c, &b, 1)) {
 		i2cdprintk("read error\n");
 		return -EIO;
 	}
@@ -115,7 +115,7 @@ int em28xx_get_key_em_haup(struct IR_i2c
 	unsigned char code;
 
 	/* poll IR chip */
-	if (2 != i2c_master_recv(&ir->c, buf, 2))
+	if (2 != i2c_master_recv(ir->c, buf, 2))
 		return -EIO;
 
 	/* Does eliminate repeated parity code */
@@ -153,7 +153,7 @@ int em28xx_get_key_pinnacle_usb_grey(str
 
 	/* poll IR chip */
 
-	if (3 != i2c_master_recv(&ir->c, buf, 3)) {
+	if (3 != i2c_master_recv(ir->c, buf, 3)) {
 		i2cdprintk("read error\n");
 		return -EIO;
 	}
--- v4l-dvb.orig/linux/drivers/media/video/em28xx/em28xx.h	2009-04-04 10:53:08.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/em28xx/em28xx.h	2009-04-04 12:56:26.000000000 +0200
@@ -648,6 +648,7 @@ extern void em28xx_card_setup(struct em2
 extern struct em28xx_board em28xx_boards[];
 extern struct usb_device_id em28xx_id_table[];
 extern const unsigned int em28xx_bcount;
+void em28xx_register_i2c_ir(struct em28xx *dev);
 void em28xx_set_ir(struct em28xx *dev, struct IR_i2c *ir);
 int em28xx_tuner_callback(void *ptr, int component, int command, int arg);
 void em28xx_release_resources(struct em28xx *dev);
--- v4l-dvb.orig/linux/drivers/media/video/ir-kbd-i2c.c	2009-04-04 10:57:57.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/ir-kbd-i2c.c	2009-04-04 12:56:26.000000000 +0200
@@ -75,7 +75,7 @@ static int get_key_haup_common(struct IR
 	int start, range, toggle, dev, code, ircode;
 
 	/* poll IR chip */
-	if (size != i2c_master_recv(&ir->c,buf,size))
+	if (size != i2c_master_recv(ir->c, buf, size))
 		return -EIO;
 
 	/* split rc5 data block ... */
@@ -138,7 +138,7 @@ static int get_key_pixelview(struct IR_i
 	unsigned char b;
 
 	/* poll IR chip */
-	if (1 != i2c_master_recv(&ir->c,&b,1)) {
+	if (1 != i2c_master_recv(ir->c, &b, 1)) {
 		dprintk(1,"read error\n");
 		return -EIO;
 	}
@@ -152,7 +152,7 @@ static int get_key_pv951(struct IR_i2c *
 	unsigned char b;
 
 	/* poll IR chip */
-	if (1 != i2c_master_recv(&ir->c,&b,1)) {
+	if (1 != i2c_master_recv(ir->c, &b, 1)) {
 		dprintk(1,"read error\n");
 		return -EIO;
 	}
@@ -172,7 +172,7 @@ static int get_key_fusionhdtv(struct IR_
 	unsigned char buf[4];
 
 	/* poll IR chip */
-	if (4 != i2c_master_recv(&ir->c,buf,4)) {
+	if (4 != i2c_master_recv(ir->c, buf, 4)) {
 		dprintk(1,"read error\n");
 		return -EIO;
 	}
@@ -196,7 +196,7 @@ static int get_key_knc1(struct IR_i2c *i
 	unsigned char b;
 
 	/* poll IR chip */
-	if (1 != i2c_master_recv(&ir->c,&b,1)) {
+	if (1 != i2c_master_recv(ir->c, &b, 1)) {
 		dprintk(1,"read error\n");
 		return -EIO;
 	}
@@ -223,12 +223,12 @@ static int get_key_avermedia_cardbus(str
 				     u32 *ir_key, u32 *ir_raw)
 {
 	unsigned char subaddr, key, keygroup;
-	struct i2c_msg msg[] = { { .addr = ir->c.addr, .flags = 0,
+	struct i2c_msg msg[] = { { .addr = ir->c->addr, .flags = 0,
 				   .buf = &subaddr, .len = 1},
-				 { .addr = ir->c.addr, .flags = I2C_M_RD,
+				 { .addr = ir->c->addr, .flags = I2C_M_RD,
 				  .buf = &key, .len = 1} };
 	subaddr = 0x0d;
-	if (2 != i2c_transfer(ir->c.adapter, msg, 2)) {
+	if (2 != i2c_transfer(ir->c->adapter, msg, 2)) {
 		dprintk(1, "read error\n");
 		return -EIO;
 	}
@@ -238,7 +238,7 @@ static int get_key_avermedia_cardbus(str
 
 	subaddr = 0x0b;
 	msg[1].buf = &keygroup;
-	if (2 != i2c_transfer(ir->c.adapter, msg, 2)) {
+	if (2 != i2c_transfer(ir->c->adapter, msg, 2)) {
 		dprintk(1, "read error\n");
 		return -EIO;
 	}
@@ -295,7 +295,7 @@ static void ir_work(struct work_struct *
 
 	/* MSI TV@nywhere Plus requires more frequent polling
 	   otherwise it will miss some keypresses */
-	if (ir->c.adapter->id == I2C_HW_SAA7134 && ir->c.addr == 0x30)
+	if (ir->c->adapter->id == I2C_HW_SAA7134 && ir->c->addr == 0x30)
 		polling_interval = 50;
 
 	ir_key_poll(ir);
@@ -304,34 +304,15 @@ static void ir_work(struct work_struct *
 
 /* ----------------------------------------------------------------------- */
 
-static int ir_attach(struct i2c_adapter *adap, int addr,
-		      unsigned short flags, int kind);
-static int ir_detach(struct i2c_client *client);
-static int ir_probe(struct i2c_adapter *adap);
-
-static struct i2c_driver driver = {
-	.driver = {
-		.name   = "ir-kbd-i2c",
-	},
-	.id             = I2C_DRIVERID_INFRARED,
-	.attach_adapter = ir_probe,
-	.detach_client  = ir_detach,
-};
-
-static struct i2c_client client_template =
-{
-	.name = "unset",
-	.driver = &driver
-};
-
-static int ir_attach(struct i2c_adapter *adap, int addr,
-		     unsigned short flags, int kind)
+static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	IR_KEYTAB_TYPE *ir_codes = NULL;
 	char *name;
 	int ir_type;
 	struct IR_i2c *ir;
 	struct input_dev *input_dev;
+	struct i2c_adapter *adap = client->adapter;
+	unsigned short addr = client->addr;
 	int err;
 
 	ir = kzalloc(sizeof(struct IR_i2c),GFP_KERNEL);
@@ -341,14 +322,9 @@ static int ir_attach(struct i2c_adapter
 		goto err_out_free;
 	}
 
-	ir->c = client_template;
+	ir->c = client;
 	ir->input = input_dev;
-
-	ir->c.adapter = adap;
-	ir->c.addr    = addr;
-	snprintf(ir->c.name, sizeof(ir->c.name), "ir-kbd");
-
-	i2c_set_clientdata(&ir->c, ir);
+	i2c_set_clientdata(client, ir);
 
 	switch(addr) {
 	case 0x64:
@@ -423,24 +399,9 @@ static int ir_attach(struct i2c_adapter
 	snprintf(ir->name, sizeof(ir->name), "i2c IR (%s)", name);
 	ir->ir_codes = ir_codes;
 
-	/* register i2c device
-	 * At device register, IR codes may be changed to be
-	 * board dependent.
-	 */
-	err = i2c_attach_client(&ir->c);
-	if (err)
-		goto err_out_free;
-
-	/* If IR not supported or disabled, unregisters driver */
-	if (ir->get_key == NULL) {
-		err = -ENODEV;
-		goto err_out_detach;
-	}
-
-	/* Phys addr can only be set after attaching (for ir->c.dev) */
 	snprintf(ir->phys, sizeof(ir->phys), "%s/%s/ir0",
-		 dev_name(&ir->c.adapter->dev),
-		 dev_name(&ir->c.dev));
+		 dev_name(&adap->dev),
+		 dev_name(&client->dev));
 
 	/* init + register input device */
 	ir_input_init(input_dev, &ir->ir, ir_type, ir->ir_codes);
@@ -450,7 +411,7 @@ static int ir_attach(struct i2c_adapter
 
 	err = input_register_device(ir->input);
 	if (err)
-		goto err_out_detach;
+		goto err_out_free;
 
 	printk(DEVNAME ": %s detected at %s [%s]\n",
 	       ir->input->name, ir->input->phys, adap->name);
@@ -465,135 +426,40 @@ static int ir_attach(struct i2c_adapter
 
 	return 0;
 
- err_out_detach:
-	i2c_detach_client(&ir->c);
  err_out_free:
 	input_free_device(input_dev);
 	kfree(ir);
 	return err;
 }
 
-static int ir_detach(struct i2c_client *client)
+static int ir_remove(struct i2c_client *client)
 {
 	struct IR_i2c *ir = i2c_get_clientdata(client);
 
 	/* kill outstanding polls */
 	cancel_delayed_work_sync(&ir->work);
 
-	/* unregister devices */
+	/* unregister device */
 	input_unregister_device(ir->input);
-	i2c_detach_client(&ir->c);
 
 	/* free memory */
 	kfree(ir);
 	return 0;
 }
 
-static int ir_probe(struct i2c_adapter *adap)
-{
-
-	/* The external IR receiver is at i2c address 0x34 (0x35 for
-	   reads).  Future Hauppauge cards will have an internal
-	   receiver at 0x30 (0x31 for reads).  In theory, both can be
-	   fitted, and Hauppauge suggest an external overrides an
-	   internal.
-
-	   That's why we probe 0x1a (~0x34) first. CB
-	*/
-
-	static const int probe_bttv[] = { 0x1a, 0x18, 0x4b, 0x64, 0x30, -1};
-	static const int probe_saa7134[] = { 0x7a, 0x47, 0x71, 0x2d, -1 };
-	static const int probe_em28XX[] = { 0x30, 0x47, -1 };
-	static const int probe_cx88[] = { 0x18, 0x6b, 0x71, -1 };
-	static const int probe_cx23885[] = { 0x6b, -1 };
-	const int *probe;
-	struct i2c_msg msg = {
-		.flags = I2C_M_RD,
-		.len = 0,
-		.buf = NULL,
-	};
-	int i, rc;
-
-	switch (adap->id) {
-	case I2C_HW_B_BT848:
-		probe = probe_bttv;
-		break;
-	case I2C_HW_B_CX2341X:
-		probe = probe_bttv;
-		break;
-	case I2C_HW_SAA7134:
-		probe = probe_saa7134;
-		break;
-	case I2C_HW_B_EM28XX:
-		probe = probe_em28XX;
-		break;
-	case I2C_HW_B_CX2388x:
-		probe = probe_cx88;
-		break;
-	case I2C_HW_B_CX23885:
-		probe = probe_cx23885;
-		break;
-	default:
-		return 0;
-	}
-
-	for (i = 0; -1 != probe[i]; i++) {
-		msg.addr = probe[i];
-		rc = i2c_transfer(adap, &msg, 1);
-		dprintk(1,"probe 0x%02x @ %s: %s\n",
-			probe[i], adap->name,
-			(1 == rc) ? "yes" : "no");
-		if (1 == rc) {
-			ir_attach(adap, probe[i], 0, 0);
-			return 0;
-		}
-	}
-
-	/* Special case for MSI TV@nywhere Plus remote */
-	if (adap->id == I2C_HW_SAA7134) {
-		u8 temp;
-
-		/* MSI TV@nywhere Plus controller doesn't seem to
-		   respond to probes unless we read something from
-		   an existing device. Weird... */
-
-		msg.addr = 0x50;
-		rc = i2c_transfer(adap, &msg, 1);
-			dprintk(1, "probe 0x%02x @ %s: %s\n",
-			msg.addr, adap->name,
-			(1 == rc) ? "yes" : "no");
-
-		/* Now do the probe. The controller does not respond
-		   to 0-byte reads, so we use a 1-byte read instead. */
-		msg.addr = 0x30;
-		msg.len = 1;
-		msg.buf = &temp;
-		rc = i2c_transfer(adap, &msg, 1);
-		dprintk(1, "probe 0x%02x @ %s: %s\n",
-			msg.addr, adap->name,
-			(1 == rc) ? "yes" : "no");
-		if (1 == rc)
-			ir_attach(adap, msg.addr, 0, 0);
-	}
-
-	/* Special case for AVerMedia Cardbus remote */
-	if (adap->id == I2C_HW_SAA7134) {
-		unsigned char subaddr, data;
-		struct i2c_msg msg[] = { { .addr = 0x40, .flags = 0,
-					   .buf = &subaddr, .len = 1},
-					 { .addr = 0x40, .flags = I2C_M_RD,
-					   .buf = &data, .len = 1} };
-		subaddr = 0x0d;
-		rc = i2c_transfer(adap, msg, 2);
-		dprintk(1, "probe 0x%02x/0x%02x @ %s: %s\n",
-			msg[0].addr, subaddr, adap->name,
-			(2 == rc) ? "yes" : "no");
-		if (2 == rc)
-			ir_attach(adap, msg[0].addr, 0, 0);
-	}
+static const struct i2c_device_id ir_kbd_id[] = {
+	{ "ir-kbd", 0 },
+	{ }
+};
 
-	return 0;
-}
+static struct i2c_driver driver = {
+	.driver = {
+		.name   = "ir-kbd-i2c",
+	},
+	.probe          = ir_probe,
+	.remove         = ir_remove,
+	.id_table       = ir_kbd_id,
+};
 
 /* ----------------------------------------------------------------------- */
 
--- v4l-dvb.orig/linux/drivers/media/video/ivtv/ivtv-i2c.c	2009-04-04 10:53:08.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/ivtv/ivtv-i2c.c	2009-04-04 10:58:36.000000000 +0200
@@ -589,9 +589,11 @@ static struct i2c_client ivtv_i2c_client
 	.name = "ivtv internal",
 };
 
-/* init + register i2c algo-bit adapter */
+/* init + register i2c adapter + instantiate IR receiver */
 int init_ivtv_i2c(struct ivtv *itv)
 {
+	int retval;
+
 	IVTV_DEBUG_I2C("i2c init\n");
 
 	/* Sanity checks for the I2C hardware arrays. They must be the
@@ -631,9 +633,32 @@ int init_ivtv_i2c(struct ivtv *itv)
 	ivtv_setsda(itv, 1);
 
 	if (itv->options.newi2c > 0)
-		return i2c_add_adapter(&itv->i2c_adap);
+		retval = i2c_add_adapter(&itv->i2c_adap);
 	else
-		return i2c_bit_add_bus(&itv->i2c_adap);
+		retval = i2c_bit_add_bus(&itv->i2c_adap);
+
+	/* Instantiate the IR receiver device, if present */
+	if (retval == 0) {
+		struct i2c_board_info info;
+		/* The external IR receiver is at i2c address 0x34 (0x35 for
+		   reads).  Future Hauppauge cards will have an internal
+		   receiver at 0x30 (0x31 for reads).  In theory, both can be
+		   fitted, and Hauppauge suggest an external overrides an
+		   internal.
+
+		   That's why we probe 0x1a (~0x34) first. CB
+		*/
+		const unsigned short addr_list[] = {
+			0x1a, 0x18, 0x64, 0x30,
+			I2C_CLIENT_END
+		};
+
+		memset(&info, 0, sizeof(struct i2c_board_info));
+		strlcpy(info.type, "ir-kbd", I2C_NAME_SIZE);
+		i2c_new_probed_device(&itv->i2c_adap, &info, addr_list);
+	}
+
+	return retval;
 }
 
 void exit_ivtv_i2c(struct ivtv *itv)
--- v4l-dvb.orig/linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c	2009-04-04 10:53:08.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c	2009-04-04 10:58:36.000000000 +0200
@@ -649,6 +649,27 @@ static void do_i2c_scan(struct pvr2_hdw
 	printk(KERN_INFO "%s: i2c scan done.\n", hdw->name);
 }
 
+static void pvr2_i2c_register_ir(struct i2c_adapter *i2c_adap)
+{
+	struct i2c_board_info info;
+	/* The external IR receiver is at i2c address 0x34 (0x35 for
+	   reads).  Future Hauppauge cards will have an internal
+	   receiver at 0x30 (0x31 for reads).  In theory, both can be
+	   fitted, and Hauppauge suggest an external overrides an
+	   internal.
+
+	   That's why we probe 0x1a (~0x34) first. CB
+	*/
+	const unsigned short addr_list[] = {
+		0x1a, 0x18, 0x4b, 0x64, 0x30,
+		I2C_CLIENT_END
+	};
+
+	memset(&info, 0, sizeof(struct i2c_board_info));
+	strlcpy(info.type, "ir-kbd", I2C_NAME_SIZE);
+	i2c_new_probed_device(i2c_adap, &info, addr_list);
+}
+
 void pvr2_i2c_core_init(struct pvr2_hdw *hdw)
 {
 	unsigned int idx;
@@ -696,6 +717,9 @@ void pvr2_i2c_core_init(struct pvr2_hdw
 		}
 	}
 	if (i2c_scan) do_i2c_scan(hdw);
+
+	/* Instantiate the IR receiver device, if present */
+	pvr2_i2c_register_ir(&hdw->i2c_adap);
 }
 
 void pvr2_i2c_core_done(struct pvr2_hdw *hdw)
--- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134-i2c.c	2009-04-04 10:53:08.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134-i2c.c	2009-04-04 12:56:26.000000000 +0200
@@ -444,6 +444,9 @@ int saa7134_i2c_register(struct saa7134_
 	saa7134_i2c_eeprom(dev,dev->eedata,sizeof(dev->eedata));
 	if (i2c_scan)
 		do_i2c_scan(dev->name,&dev->i2c_client);
+
+	/* Instantiate the IR receiver device, if present */
+	saa7134_probe_i2c_ir(dev);
 	return 0;
 }
 
--- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134-input.c	2009-04-04 10:57:57.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134-input.c	2009-04-04 12:56:26.000000000 +0200
@@ -134,10 +134,10 @@ static int get_key_msi_tvanywhere_plus(s
 	int gpio;
 
 	/* <dev> is needed to access GPIO. Used by the saa_readl macro. */
-	struct saa7134_dev *dev = ir->c.adapter->algo_data;
+	struct saa7134_dev *dev = ir->c->adapter->algo_data;
 	if (dev == NULL) {
 		dprintk("get_key_msi_tvanywhere_plus: "
-			"gir->c.adapter->algo_data is NULL!\n");
+			"gir->c->adapter->algo_data is NULL!\n");
 		return -EIO;
 	}
 
@@ -156,7 +156,7 @@ static int get_key_msi_tvanywhere_plus(s
 
 	/* GPIO says there is a button press. Get it. */
 
-	if (1 != i2c_master_recv(&ir->c, &b, 1)) {
+	if (1 != i2c_master_recv(ir->c, &b, 1)) {
 		i2cdprintk("read error\n");
 		return -EIO;
 	}
@@ -179,7 +179,7 @@ static int get_key_purpletv(struct IR_i2
 	unsigned char b;
 
 	/* poll IR chip */
-	if (1 != i2c_master_recv(&ir->c,&b,1)) {
+	if (1 != i2c_master_recv(ir->c, &b, 1)) {
 		i2cdprintk("read error\n");
 		return -EIO;
 	}
@@ -202,7 +202,7 @@ static int get_key_hvr1110(struct IR_i2c
 	unsigned char buf[5], cod4, code3, code4;
 
 	/* poll IR chip */
-	if (5 != i2c_master_recv(&ir->c,buf,5))
+	if (5 != i2c_master_recv(ir->c, buf, 5))
 		return -EIO;
 
 	cod4	= buf[4];
@@ -224,7 +224,7 @@ static int get_key_beholdm6xx(struct IR_
 	unsigned char data[12];
 	u32 gpio;
 
-	struct saa7134_dev *dev = ir->c.adapter->algo_data;
+	struct saa7134_dev *dev = ir->c->adapter->algo_data;
 
 	/* rising SAA7134_GPIO_GPRESCAN reads the status */
 	saa_clearb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
@@ -235,9 +235,9 @@ static int get_key_beholdm6xx(struct IR_
 	if (0x400000 & ~gpio)
 		return 0; /* No button press */
 
-	ir->c.addr = 0x5a >> 1;
+	ir->c->addr = 0x5a >> 1;
 
-	if (12 != i2c_master_recv(&ir->c, data, 12)) {
+	if (12 != i2c_master_recv(ir->c, data, 12)) {
 		i2cdprintk("read error\n");
 		return -EIO;
 	}
@@ -267,7 +267,7 @@ static int get_key_pinnacle(struct IR_i2
 	unsigned int start = 0,parity = 0,code = 0;
 
 	/* poll IR chip */
-	if (4 != i2c_master_recv(&ir->c, b, 4)) {
+	if (4 != i2c_master_recv(ir->c, b, 4)) {
 		i2cdprintk("read error\n");
 		return -EIO;
 	}
@@ -682,14 +682,76 @@ void saa7134_input_fini(struct saa7134_d
 	dev->remote = NULL;
 }
 
-void saa7134_set_i2c_ir(struct saa7134_dev *dev, struct IR_i2c *ir)
+void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 {
+	struct i2c_board_info info;
+	const unsigned short addr_list[] = {
+		0x7a, 0x47, 0x71, 0x2d,
+		I2C_CLIENT_END
+	};
+
+	const unsigned short addr_list_msi[] = {
+		0x30, I2C_CLIENT_END
+	};
+	struct i2c_msg msg_msi = {
+		.addr = 0x50,
+		.flags = I2C_M_RD,
+		.len = 0,
+		.buf = NULL,
+	};
+
+	unsigned char subaddr, data;
+	struct i2c_msg msg_avermedia[] = { {
+		.addr = 0x40,
+		.flags = 0,
+		.len = 1,
+		.buf = &subaddr,
+	}, {
+		.addr = 0x40,
+		.flags = I2C_M_RD,
+		.len = 1,
+		.buf = &data,
+	} };
+
+	struct i2c_client *client;
+	int rc;
+
 	if (disable_ir) {
-		dprintk("Found supported i2c remote, but IR has been disabled\n");
-		ir->get_key=NULL;
+		dprintk("IR has been disabled, not probing for i2c remote\n");
+		return;
+	}
+
+	memset(&info, 0, sizeof(struct i2c_board_info));
+	strlcpy(info.type, "ir-kbd", I2C_NAME_SIZE);
+	client = i2c_new_probed_device(&dev->i2c_adap, &info, addr_list);
+	if (client)
 		return;
+
+	/* MSI TV@nywhere Plus controller doesn't seem to
+	   respond to probes unless we read something from
+	   an existing device. Weird... */
+	rc = i2c_transfer(&dev->i2c_adap, &msg_msi, 1);
+	dprintk(KERN_DEBUG "probe 0x%02x @ %s: %s\n",
+		msg_msi.addr, dev->i2c_adap.name,
+		(1 == rc) ? "yes" : "no");
+	client = i2c_new_probed_device(&dev->i2c_adap, &info, addr_list_msi);
+	if (client)
+		return;
+
+	/* Special case for AVerMedia Cardbus remote */
+	subaddr = 0x0d;
+	rc = i2c_transfer(&dev->i2c_adap, msg_avermedia, 2);
+	dprintk(KERN_DEBUG "probe 0x%02x/0x%02x @ %s: %s\n",
+		msg_avermedia[0].addr, subaddr, dev->i2c_adap.name,
+		(2 == rc) ? "yes" : "no");
+	if (2 == rc) {
+		info.addr = msg_avermedia[0].addr;
+		i2c_new_device(&dev->i2c_adap, &info);
 	}
+}
 
+void saa7134_set_i2c_ir(struct saa7134_dev *dev, struct IR_i2c *ir)
+{
 	switch (dev->board) {
 	case SAA7134_BOARD_PINNACLE_PCTV_110i:
 	case SAA7134_BOARD_PINNACLE_PCTV_310i:
--- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134.h	2009-04-04 10:53:08.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134.h	2009-04-04 12:56:26.000000000 +0200
@@ -791,6 +791,7 @@ void saa7134_irq_oss_done(struct saa7134
 int  saa7134_input_init1(struct saa7134_dev *dev);
 void saa7134_input_fini(struct saa7134_dev *dev);
 void saa7134_input_irq(struct saa7134_dev *dev);
+void saa7134_probe_i2c_ir(struct saa7134_dev *dev);
 void saa7134_set_i2c_ir(struct saa7134_dev *dev, struct IR_i2c *ir);
 void saa7134_ir_start(struct saa7134_dev *dev, struct card_ir *ir);
 void saa7134_ir_stop(struct saa7134_dev *dev);
--- v4l-dvb.orig/linux/drivers/media/video/usbvision/usbvision-i2c.c	2009-04-04 10:53:08.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/usbvision/usbvision-i2c.c	2009-04-04 10:58:36.000000000 +0200
@@ -211,6 +211,27 @@ static struct i2c_algorithm usbvision_al
 /* ----------------------------------------------------------------------- */
 static struct i2c_adapter i2c_adap_template;
 
+static void usbvision_i2c_register_ir(struct i2c_adapter *adap)
+{
+	struct i2c_board_info info;
+	/* The external IR receiver is at i2c address 0x34 (0x35 for
+	   reads).  Future Hauppauge cards will have an internal
+	   receiver at 0x30 (0x31 for reads).  In theory, both can be
+	   fitted, and Hauppauge suggest an external overrides an
+	   internal.
+
+	   That's why we probe 0x1a (~0x34) first. CB
+	*/
+	const unsigned short addr_list[] = {
+		0x1a, 0x18, 0x4b, 0x64, 0x30,
+		I2C_CLIENT_END
+	};
+
+	memset(&info, 0, sizeof(struct i2c_board_info));
+	strlcpy(info.type, "ir-kbd", I2C_NAME_SIZE);
+	i2c_new_probed_device(adap, &info, addr_list);
+}
+
 int usbvision_i2c_register(struct usb_usbvision *usbvision)
 {
 	static unsigned short saa711x_addrs[] = {
@@ -277,6 +298,9 @@ int usbvision_i2c_register(struct usb_us
 		}
 	}
 
+	/* Instantiate the IR receiver device, if present */
+	usbvision_i2c_register_ir(&usbvision->i2c_adap);
+
 	return 0;
 }
 
--- v4l-dvb.orig/linux/include/media/ir-kbd-i2c.h	2009-04-04 10:57:57.000000000 +0200
+++ v4l-dvb/linux/include/media/ir-kbd-i2c.h	2009-04-04 12:56:26.000000000 +0200
@@ -7,7 +7,7 @@ struct IR_i2c;
 
 struct IR_i2c {
 	IR_KEYTAB_TYPE         *ir_codes;
-	struct i2c_client      c;
+	struct i2c_client      *c;
 	struct input_dev       *input;
 	struct ir_input_state  ir;
 

-- 
Jean Delvare
