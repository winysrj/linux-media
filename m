Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:9456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757262Ab0KLN3N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 08:29:13 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oACDTDdB000599
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 12 Nov 2010 08:29:13 -0500
Received: from pedra (vpn-229-188.phx2.redhat.com [10.3.229.188])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id oACDTBbX004220
	for <linux-media@vger.kernel.org>; Fri, 12 Nov 2010 08:29:12 -0500
Date: Fri, 12 Nov 2010 11:28:37 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] [media] cx231xx: Fix i2c support at cx231xx-input
Message-ID: <20101112112837.3ebf2905@pedra>
In-Reply-To: <cover.1289568397.git.mchehab@redhat.com>
References: <cover.1289568397.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

There was a bug at cx231xx-input, where it were registering the remote
controls twice, one via ir-kbd-i2c and another directly.
Also, the patch that added rc_register_device() broke compilation for it.

This patch fixes cx231xx-input by fixing the depends on, to point to the
new symbol, and initializing the scanmask via platform_data.

While here, also fix Kconfig symbol change for IR core dependencies.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx231xx/Kconfig b/drivers/media/video/cx231xx/Kconfig
index ab7d5df..d6a2350 100644
--- a/drivers/media/video/cx231xx/Kconfig
+++ b/drivers/media/video/cx231xx/Kconfig
@@ -16,7 +16,7 @@ config VIDEO_CX231XX
 
 config VIDEO_CX231XX_RC
 	bool "Conexant cx231xx Remote Controller additional support"
-	depends on VIDEO_IR
+	depends on IR_CORE
 	depends on VIDEO_CX231XX
 	default y
 	---help---
diff --git a/drivers/media/video/cx231xx/cx231xx-input.c b/drivers/media/video/cx231xx/cx231xx-input.c
index 6725244..65d951e 100644
--- a/drivers/media/video/cx231xx/cx231xx-input.c
+++ b/drivers/media/video/cx231xx/cx231xx-input.c
@@ -29,6 +29,8 @@ static int get_key_isdbt(struct IR_i2c *ir, u32 *ir_key,
 {
 	u8	cmd;
 
+	dev_dbg(&ir->rc->input_dev->dev, "%s\n", __func__);
+
 		/* poll IR chip */
 	if (1 != i2c_master_recv(ir->c, &cmd, 1))
 		return -EIO;
@@ -40,7 +42,7 @@ static int get_key_isdbt(struct IR_i2c *ir, u32 *ir_key,
 	if (cmd == 0xff)
 		return 0;
 
-	dev_dbg(&ir->input->dev, "scancode = %02x\n", cmd);
+	dev_dbg(&ir->rc->input_dev->dev, "scancode = %02x\n", cmd);
 
 	*ir_key = cmd;
 	*ir_raw = cmd;
@@ -49,9 +51,7 @@ static int get_key_isdbt(struct IR_i2c *ir, u32 *ir_key,
 
 int cx231xx_ir_init(struct cx231xx *dev)
 {
-	struct input_dev *input_dev;
 	struct i2c_board_info info;
-	int rc;
 	u8 ir_i2c_bus;
 
 	dev_dbg(&dev->udev->dev, "%s\n", __func__);
@@ -60,34 +60,18 @@ int cx231xx_ir_init(struct cx231xx *dev)
 	if (!cx231xx_boards[dev->model].rc_map)
 		return -ENODEV;
 
-	input_dev = input_allocate_device();
-	if (!input_dev)
-		return -ENOMEM;
-
 	request_module("ir-kbd-i2c");
 
 	memset(&info, 0, sizeof(struct i2c_board_info));
-	memset(&dev->ir.init_data, 0, sizeof(dev->ir.init_data));
+	memset(&dev->init_data, 0, sizeof(dev->init_data));
+	dev->init_data.rc_dev = rc_allocate_device();
+	if (!dev->init_data.rc_dev)
+		return -ENOMEM;
 
-	dev->ir.input_dev = input_dev;
-	dev->ir.init_data.name = cx231xx_boards[dev->model].name;
-	dev->ir.props.priv = dev;
-	dev->ir.props.allowed_protos = IR_TYPE_NEC;
-	snprintf(dev->ir.name, sizeof(dev->ir.name),
-		 "cx231xx IR (%s)", cx231xx_boards[dev->model].name);
-	usb_make_path(dev->udev, dev->ir.phys, sizeof(dev->ir.phys));
-	strlcat(dev->ir.phys, "/input0", sizeof(dev->ir.phys));
+	dev->init_data.name = cx231xx_boards[dev->model].name;
 
 	strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
-	info.platform_data = &dev->ir.init_data;
-
-	input_dev->name = dev->ir.name;
-	input_dev->phys = dev->ir.phys;
-	input_dev->dev.parent = &dev->udev->dev;
-	input_dev->id.bustype = BUS_USB;
-	input_dev->id.version = 1;
-	input_dev->id.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
-	input_dev->id.product = le16_to_cpu(dev->udev->descriptor.idProduct);
+	info.platform_data = &dev->init_data;
 
 	/*
 	 * Board-dependent values
@@ -95,28 +79,23 @@ int cx231xx_ir_init(struct cx231xx *dev)
 	 * For now, there's just one type of hardware design using
 	 * an i2c device.
 	 */
-	dev->ir.init_data.get_key = get_key_isdbt;
-	dev->ir.init_data.ir_codes = cx231xx_boards[dev->model].rc_map;
+	dev->init_data.get_key = get_key_isdbt;
+	dev->init_data.ir_codes = cx231xx_boards[dev->model].rc_map;
 	/* The i2c micro-controller only outputs the cmd part of NEC protocol */
-	dev->ir.props.scanmask = 0xff;
+	dev->init_data.rc_dev->scanmask = 0xff;
+	dev->init_data.rc_dev->driver_name = "cx231xx";
+	dev->init_data.type = IR_TYPE_NEC;
 	info.addr = 0x30;
 
-	rc = ir_input_register(input_dev, cx231xx_boards[dev->model].rc_map,
-			       &dev->ir.props, MODULE_NAME);
-	if (rc < 0)
-		return rc;
-
 	/* Load and bind ir-kbd-i2c */
 	ir_i2c_bus = cx231xx_boards[dev->model].ir_i2c_master;
+	dev_dbg(&dev->udev->dev, "Trying to bind ir at bus %d, addr 0x%02x\n",
+		ir_i2c_bus, info.addr);
 	i2c_new_device(&dev->i2c_bus[ir_i2c_bus].i2c_adap, &info);
 
-	return rc;
+	return 0;
 }
 
 void cx231xx_ir_exit(struct cx231xx *dev)
 {
-	if (dev->ir.input_dev) {
-		ir_input_unregister(dev->ir.input_dev);
-		dev->ir.input_dev = NULL;
-	}
 }
diff --git a/drivers/media/video/cx231xx/cx231xx.h b/drivers/media/video/cx231xx/cx231xx.h
index c439e77..fcccc9d 100644
--- a/drivers/media/video/cx231xx/cx231xx.h
+++ b/drivers/media/video/cx231xx/cx231xx.h
@@ -602,25 +602,6 @@ struct cx231xx_tsport {
 	void                       *port_priv;
 };
 
-struct cx231xx_ir_t {
-	struct input_dev *input_dev;
-	char name[40];
-	char phys[32];
-
-#if 0	
-	/*
-	 * Due to a Kconfig change, cx231xx-input is not being compiled.
-	 * This structure disappeared, but other fixes are also needed.
-	 * So, as a workaround, let's just comment this struct and let a
-	 * latter patch fix it.
-	 */
-	struct ir_dev_props props;
-#endif
-
-	/* I2C keyboard data */
-	struct IR_i2c_init_data    init_data;
-};
-
 /* main device struct */
 struct cx231xx {
 	/* generic device properties */
@@ -631,7 +612,7 @@ struct cx231xx {
 	struct cx231xx_board board;
 
 	/* For I2C IR support */
-	struct cx231xx_ir_t ir;
+	struct IR_i2c_init_data    init_data;
 
 	unsigned int stream_on:1;	/* Locks streams */
 	unsigned int vbi_stream_on:1;	/* Locks streams for VBI */
-- 
1.7.1

