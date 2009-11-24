Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44611 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933199AbZKXPHY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Nov 2009 10:07:24 -0500
Message-ID: <4B0BF68C.10602@infradead.org>
Date: Tue, 24 Nov 2009 13:06:52 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: =?UTF-8?B?THVrw6HFoSBLYXJhcw==?= <lukas.karas@centrum.cz>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] add support for IR on FlyDVB Trio (saa7134)
References: <200909101412.07415.lukas.karas@centrum.cz> <20091027100622.6de8899d@pedra.chehab.org> <200910271426.56878.lukas.karas@centrum.cz>
In-Reply-To: <200910271426.56878.lukas.karas@centrum.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lukáš,

Lukáš Karas wrote:
> Hi Mauro, 
> 
> That isn't problem. Would it help you, if I send this patch as attachment?
> 
> Regards, 
> Lukas
> 
> Dne Út 27. října 2009 13:06:22 jste napsal(a): 
>> Hi Kukáš,
>>
>> Your patch were line-wrapped, so, I can't apply it. Could you please
>>  re-submit if it weren't already merged?
>>
>> Cheers,
>> Mauro.
>>
>> Em Thu, 10 Sep 2009 14:12:07 +0200
>>
>> Lukáš Karas <lukas.karas@centrum.cz> escreveu:
>>> Hi all, here is patch for driver saa7134, that add support for IR
>>> reciever on card LifeView FlyDVB Trio.
>>>
>>> I tested it on kernel 2.6.30
>>>
>>>
>>> Signed-off-by: Lukas Karas <lukas.karas@centrum.cz>

Your patch had some troubles to compile against upstream. Also, there were some CodingStyle
issues.

Could you please see if the fixes I've made didn't break it?

---

saa7134: Add support for IR reciever on card LifeView FlyDVB Trio

From: Lukas Karas <lukas.karas@centrum.cz>

Priority: normal

[mchehab@redhat.com: CodingStyle fixes and ported upstream]

Signed-off-by: Lukas Karas <lukas.karas@centrum.cz>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/linux/drivers/media/video/ir-kbd-i2c.c b/linux/drivers/media/video/ir-kbd-i2c.c
--- a/linux/drivers/media/video/ir-kbd-i2c.c
+++ b/linux/drivers/media/video/ir-kbd-i2c.c
@@ -437,6 +437,7 @@ static int ir_probe(struct i2c_client *c
 		ir_type     = IR_TYPE_RC5;
 		ir_codes    = &ir_codes_fusionhdtv_mce_table;
 		break;
+	case 0x0b:
 	case 0x47:
 	case 0x71:
 		if (adap->id == I2C_HW_B_CX2388x ||
@@ -507,7 +508,7 @@ static int ir_probe(struct i2c_client *c
 
 	/* Make sure we are all setup before going on */
 	if (!name || !ir->get_key || !ir_type || !ir_codes) {
-		dprintk(1, DEVNAME ": Unsupported device at address 0x%02x\n",
+		dprintk(1, ": Unsupported device at address 0x%02x\n",
 			addr);
 		err = -ENODEV;
 		goto err_out_free;
@@ -715,6 +716,33 @@ static int ir_probe(struct i2c_adapter *
 			ir_attach(adap, msg[0].addr, 0, 0);
 	}
 
+	/* special case for LifeView FlyDVB Trio */
+	if (adap->id == I2C_HW_SAA7134) {
+		u8 temp = 0;
+		msg.buf = &temp;
+		msg.addr = 0x0b;
+		msg.len = 1;
+		msg.flags = 0;
+
+		/*
+		 * send weak up message to pic16C505 chip
+		 * @ LifeView FlyDVB Trio
+		 */
+		if (1 != i2c_transfer(adap, &msg, 1)) {
+			dprintk(1, "send wake up byte to pic16C505 failed\n");
+		} else {
+			msg.flags = I2C_M_RD;
+			rc = i2c_transfer(adap, &msg, 1);
+			dprintk(1, "probe 0x%02x @ %s: %s\n",
+					msg.addr, adap->name,
+					(1 == rc) ? "yes" : "no");
+			if (1 == rc)
+				ir_attach(adap, msg.addr, 0, 0);
+		}
+		msg.len = 0;
+		msg.flags = I2C_M_RD;
+	}
+
 	return 0;
 }
 #else
diff --git a/linux/drivers/media/video/saa7134/saa7134-cards.c b/linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c
@@ -7295,9 +7295,31 @@ int saa7134_board_init2(struct saa7134_d
 	}
 	case SAA7134_BOARD_FLYDVB_TRIO:
 	{
+		u8 temp = 0;
+		int rc;
 		u8 data[] = { 0x3c, 0x33, 0x62};
 		struct i2c_msg msg = {.addr=0x09, .flags=0, .buf=data, .len = sizeof(data)};
 		i2c_transfer(&dev->i2c_adap, &msg, 1);
+
+		/*
+		 * send weak up message to pic16C505 chip
+		 * @ LifeView FlyDVB Trio
+		 */
+		msg.buf = &temp;
+		msg.addr = 0x0b;
+		msg.len = 1;
+		if (1 != i2c_transfer(&dev->i2c_adap, &msg, 1)) {
+			printk(KERN_WARNING "%s: send wake up byte to pic16C505"
+					"(IR chip) failed\n", dev->name);
+		} else {
+			msg.flags = I2C_M_RD;
+			rc = i2c_transfer(&dev->i2c_adap, &msg, 1);
+			printk(KERN_INFO "%s: probe IR chip @ i2c 0x%02x: %s\n",
+				   dev->name, msg.addr,
+				   (1 == rc) ? "yes" : "no");
+			if (rc == 1)
+				dev->has_remote = SAA7134_REMOTE_I2C;
+		}
 		break;
 	}
 	case SAA7134_BOARD_ADS_DUO_CARDBUS_PTV331:
diff --git a/linux/drivers/media/video/saa7134/saa7134-input.c b/linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c
@@ -132,6 +132,77 @@ static int build_key(struct saa7134_dev 
 
 /* --------------------- Chip specific I2C key builders ----------------- */
 
+static int get_key_flydvb_trio(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+{
+	int gpio;
+	int attempt = 0;
+	unsigned char b;
+
+	/* We need this to access GPI Used by the saa_readl macro. */
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)
+	struct saa7134_dev *dev = ir->c.adapter->algo_data;
+#else
+	struct saa7134_dev *dev = ir->c->adapter->algo_data;
+#endif
+
+	if (dev == NULL) {
+		dprintk("get_key_flydvb_trio: "
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)
+			 "gir->c.adapter->algo_data is NULL!\n");
+#else
+			 "gir->c->adapter->algo_data is NULL!\n");
+#endif
+		return -EIO;
+	}
+
+	/* rising SAA7134_GPIGPRESCAN reads the status */
+	saa_clearb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
+	saa_setb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
+
+	gpio = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2);
+
+	if (0x40000 & ~gpio)
+		return 0; /* No button press */
+
+	/* No button press - only before first key pressed */
+	if (b == 0xFF)
+		return 0;
+
+	/* poll IR chip */
+	/* weak up the IR chip */
+	b = 0;
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)
+	while (1 != i2c_master_send(&ir->c, &b, 1)) {
+#else
+	while (1 != i2c_master_send(ir->c, &b, 1)) {
+#endif
+		if ((attempt++) < 10) {
+			/*
+			 * wait a bit for next attempt -
+			 * I don't know how make it better
+			 */
+			msleep(10);
+			continue;
+		}
+		i2cdprintk("send wake up byte to pic16C505 (IR chip)"
+			   "failed %dx\n", attempt);
+		return -EIO;
+	}
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)
+	if (1 != i2c_master_recv(&ir->c, &b, 1)) {
+#else
+	if (1 != i2c_master_recv(ir->c, &b, 1)) {
+#endif
+		i2cdprintk("read error\n");
+		return -EIO;
+	}
+
+	*ir_key = b;
+	*ir_raw = b;
+	return 1;
+}
+
 static int get_key_msi_tvanywhere_plus(struct IR_i2c *ir, u32 *ir_key,
 				       u32 *ir_raw)
 {
@@ -663,6 +734,7 @@ int saa7134_input_init1(struct saa7134_d
 		mask_keyup   = 0x020000;
 		polling      = 50; /* ms */
 		break;
+	break;
 	}
 	if (NULL == ir_codes) {
 		printk("%s: Oops: IR config error [card=%d]\n",
@@ -881,6 +953,18 @@ void saa7134_probe_i2c_ir(struct saa7134
 		info.addr = 0x40;
 		break;
 #endif
+	case SAA7134_BOARD_FLYDVB_TRIO:
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)
+		snprintf(ir->c.name, sizeof(ir->c.name), "FlyDVB Trio");
+		ir->get_key   = get_key_flydvb_trio;
+		ir->ir_codes  = ir_codes_flydvb_table;
+#else
+		dev->init_data.name = "FlyDVB Trio";
+		dev->init_data.get_key = get_key_flydvb_trio;
+		dev->init_data.ir_codes = &ir_codes_flydvb_table;
+		info.addr = 0x0b;
+#endif
+		break;
 	default:
 		dprintk("No I2C IR support for board %x\n", dev->board);
 		return;

