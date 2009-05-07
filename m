Return-path: <linux-media-owner@vger.kernel.org>
Received: from hroch.hdata.cz ([81.19.13.14]:4902 "EHLO holub.hdata.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758930AbZEGIVe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 May 2009 04:21:34 -0400
Received: from localhost (unknown [127.0.0.1])
	by holub.hdata.cz (Postfix) with ESMTP id 57E5046CC6
	for <linux-media@vger.kernel.org>; Thu,  7 May 2009 08:01:25 +0000 (UTC)
Received: from [192.168.234.4] (unknown [81.19.12.177])
	by holub.hdata.cz (Postfix) with ESMTP id C9BD346C7F
	for <linux-media@vger.kernel.org>; Thu,  7 May 2009 10:01:24 +0200 (CEST)
Message-ID: <4A029572.2090904@post.cz>
Date: Thu, 07 May 2009 10:01:54 +0200
From: Michal Pastor <mike.fly@post.cz>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] MSI TV@nywhere A/D (not 1.1!) IR remote control
Content-Type: multipart/mixed;
 boundary="------------040309070600000505000202"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040309070600000505000202
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit

Hi, I just made the IR remote control for MSI TV@nywhere A/D work and I 
want to test it on some other cards, so I decided to send this patch to 
this mailing list.

This patch is originally created against kernel sources 2.6.29.1.

I was unable to detect remote, because i2c port is not answering without 
some inicialization, so I add parameter to module "ir-kbd-i2c". 
Parameter is called "i2cport" and for my MSI TV@nywhere A/D must be set 
to "0x0b". (modprobe ir-kbd-i2c i2cport=0x0b)
I also added new card type 222 (just for testing) whitch is detected 
automatically with PCI device 4e42:3306, because this card is supposet 
to be clone of LifeWiev FlyDVB-T Hybrid, but when I tested some patches 
for this card, sometimes it doesn't work, so I think, there can be some 
differences.

So please if you have this card, can you test it and respond? (you can 
try it with LifeView FlyDVB-T Hybrid too)

Thank all developers of V4L for great work and sorry for my terrible 
english :)

Mike Fly
Czech republic

--------------040309070600000505000202
Content-Type: text/plain;
 name="msitvanywheread.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="msitvanywheread.patch"

diff -upr drivers/media/common/ir-keymaps.c drivers/media/common/ir-keymaps.c
--- drivers/media/common/ir-keymaps.c	2009-04-02 22:55:27.000000000 +0200
+++ drivers/media/common/ir-keymaps.c	2009-05-06 07:58:10.000000000 +0200
@@ -2604,3 +2604,41 @@ IR_KEYTAB_TYPE ir_codes_ati_tv_wonder_hd
 };
 
 EXPORT_SYMBOL_GPL(ir_codes_ati_tv_wonder_hd_600);
+
+IR_KEYTAB_TYPE ir_codes_msi_tvanywhere_ad[IR_KEYTAB_SIZE] = {
+       [ 0x00 ] = KEY_POWER,
+       [ 0x01 ] = KEY_F,
+       [ 0x03 ] = KEY_1,
+       [ 0x04 ] = KEY_2,
+       [ 0x05 ] = KEY_3,
+       [ 0x07 ] = KEY_4,
+       [ 0x08 ] = KEY_5,
+       [ 0x09 ] = KEY_6,
+       [ 0x0b ] = KEY_7,
+       [ 0x0c ] = KEY_8,
+       [ 0x0d ] = KEY_9,
+       [ 0x0f ] = KEY_0,
+       [ 0x06 ] = KEY_F1,
+       [ 0x10 ] = KEY_MUTE,
+       [ 0x02 ] = KEY_F2,
+       [ 0x1b ] = KEY_F3,
+       [ 0x12 ] = KEY_UP,
+       [ 0x13 ] = KEY_DOWN,
+       [ 0x17 ] = KEY_LEFT,
+       [ 0x14 ] = KEY_RIGHT,
+       [ 0x1d ] = KEY_ENTER,
+       [ 0x1a ] = KEY_F4,
+       [ 0x18 ] = KEY_F5,
+       [ 0x1e ] = KEY_RECORD,
+       [ 0x15 ] = KEY_F6,
+       [ 0x1c ] = KEY_F7,
+       [ 0x19 ] = KEY_REWIND,
+       [ 0x0a ] = KEY_PAUSE,
+       [ 0x1f ] = KEY_FORWARD,
+       [ 0x16 ] = KEY_BACK,
+       [ 0x11 ] = KEY_STOP,
+       [ 0x0e ] = KEY_END,
+};
+EXPORT_SYMBOL_GPL(ir_codes_msi_tvanywhere_ad);
+
diff -upr drivers/media/video/saa7134/saa7134-cards.c drivers/media/video/saa7134/saa7134-cards.c
--- drivers/media/video/saa7134/saa7134-cards.c	2009-04-02 22:55:27.000000000 +0200
+++ drivers/media/video/saa7134/saa7134-cards.c	2009-05-06 07:26:52.000000000 +0200
@@ -4673,6 +4673,40 @@ struct saa7134_board saa7134_boards[] = 
 			.amux = TV,
 			.gpio = 0x01,
 		},
+	},	
+	[SAA7134_BOARD_MSI_TVANYWHERE_AD] = {
+		.name		= "LifeView FlyDVB-T Hybrid Cardbus/MSI TV @nywhere A/D NB",
+		.audio_clock    = 0x00200000,
+		.tuner_type     = TUNER_PHILIPS_TDA8290,
+		.radio_type     = UNSET,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr	= ADDR_UNSET,
+		.mpeg           = SAA7134_MPEG_DVB,
+		.gpiomask       = 0x00600000, /* Bit 21 0=Radio, Bit 22 0=TV */
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = TV,
+			.gpio = 0x200000,	/* GPIO21=High for TV input */
+			.tv   = 1,
+		},{
+			.name = name_svideo,	/* S-Video signal on S-Video input */
+			.vmux = 8,
+			.amux = LINE2,
+		},{
+			.name = name_comp1,	/* Composite signal on S-Video input */
+			.vmux = 0,
+			.amux = LINE2,
+		},{
+			.name = name_comp2,	/* Composite input */
+			.vmux = 3,
+			.amux = LINE2,
+		}},
+		.radio = {
+			.name = name_radio,
+			.amux = TV,
+			.gpio = 0x000000,	/* GPIO21=Low for FM radio antenna */
+		},
 	},
 };
 
@@ -5291,6 +5325,12 @@ struct pci_device_id saa7134_pci_tbl[] =
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x4e42,
+		.subdevice    = 0x3306,
+		.driver_data  = SAA7134_BOARD_MSI_TVANYWHERE_AD,
+	},{
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x5168,
 		.subdevice    = 0x3502,  /* whats the difference to 0x3306 ?*/
 		.driver_data  = SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS,
@@ -6007,6 +6047,13 @@ int saa7134_board_init1(struct saa7134_d
 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2, 0x08000000, 0x08000000);
 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x08000000, 0x00000000);
 		break;
+	case SAA7134_BOARD_MSI_TVANYWHERE_AD:
+		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2, 0x08000000, 0x08000000);
+		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x08000000, 0x00000000);
+		printk("Setting SAA7134 I2C remote");
+		dev->has_remote = SAA7134_REMOTE_I2C;
+
+		break;
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS:
 	case SAA7134_BOARD_AVERMEDIA_M115:
 		/* power-down tuner chip */
@@ -6342,6 +6389,15 @@ int saa7134_board_init2(struct saa7134_d
 		i2c_transfer(&dev->i2c_adap, &msg, 1);
 		break;
 	}
+	case SAA7134_BOARD_MSI_TVANYWHERE_AD:
+	{
+		/* initialize analog mode  */
+		u8 data[] = { 0x3c, 0x33, 0x6a};
+		struct i2c_msg msg = {.addr=0x08, .flags=0, .buf=data, .len = sizeof(data)};
+		i2c_transfer(&dev->i2c_adap, &msg, 1);
+		dev->has_remote = SAA7134_REMOTE_I2C;
+		break;
+	}
 	case SAA7134_BOARD_CINERGY_HT_PCMCIA:
 	case SAA7134_BOARD_CINERGY_HT_PCI:
 	{
diff -upr drivers/media/video/saa7134/saa7134-dvb.c drivers/media/video/saa7134/saa7134-dvb.c
--- drivers/media/video/saa7134/saa7134-dvb.c	2009-04-02 22:55:27.000000000 +0200
+++ drivers/media/video/saa7134/saa7134-dvb.c	2009-05-06 08:24:46.000000000 +0200
@@ -1109,6 +1109,7 @@ static int dvb_init(struct saa7134_dev *
 		break;
 	case SAA7134_BOARD_ADS_DUO_CARDBUS_PTV331:
 	case SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS:
+	case SAA7134_BOARD_MSI_TVANYWHERE_AD:
 		fe0->dvb.frontend = dvb_attach(tda10046_attach,
 					       &ads_tech_duo_config,
 					       &dev->i2c_adap);
diff -upr drivers/media/video/saa7134/saa7134-i2c.c drivers/media/video/saa7134/saa7134-i2c.c
--- drivers/media/video/saa7134/saa7134-i2c.c	2009-04-02 22:55:27.000000000 +0200
+++ drivers/media/video/saa7134/saa7134-i2c.c	2009-05-06 07:28:44.000000000 +0200
@@ -338,6 +338,7 @@ static int attach_inform(struct i2c_clie
 		case 0x71:
 		case 0x2d:
 		case 0x30:
+		case 0x0b:
 		{
 			struct IR_i2c *ir = i2c_get_clientdata(client);
 			d1printk("%s i2c IR detected (%s).\n",
diff -upr drivers/media/video/saa7134/saa7134-input.c drivers/media/video/saa7134/saa7134-input.c
--- drivers/media/video/saa7134/saa7134-input.c	2009-04-02 22:55:27.000000000 +0200
+++ drivers/media/video/saa7134/saa7134-input.c	2009-05-06 08:27:24.000000000 +0200
@@ -174,6 +174,49 @@ static int get_key_msi_tvanywhere_plus(s
 	return 1;
 }
 
+static int get_key_msi_tvanywhere_ad(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+{
+	int gpio;
+	unsigned long b;
+
+	/* We need this to access GPIO. Used by the saa_readl macro. */
+	struct saa7134_dev *dev = ir->c.adapter->algo_data;
+	if (dev == NULL) {
+		dprintk ("ir->c.adapter->algo_data is NULL!\n");
+        return -EIO;
+	}
+
+
+	/* rising SAA7134_GPIO_GPRESCAN reads the status */
+	saa_clearb(SAA7134_GPIO_GPMODE3,SAA7134_GPIO_GPRESCAN);
+	saa_setb(SAA7134_GPIO_GPMODE3,SAA7134_GPIO_GPRESCAN);
+
+	gpio = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2);
+
+	if (0x40000 &~ gpio)
+		return 0;    /* No button press */
+
+	/* No button press - only before first key pressed */
+	if (b == 0xFF)
+		return 0;
+
+	/* poll IR chip */
+	b = 0;
+	if (1 != i2c_master_send(&ir->c,(char *)&b,1)) {
+		i2cdprintk("send wake up byte to pic16C505 failed\n");
+		return -EIO;
+	}
+	if (1 != i2c_master_recv(&ir->c,(char *)&b,1)) {
+		i2cdprintk("read error\n");
+		return -EIO;
+	}
+	*ir_key = b;
+	*ir_raw = b;
+    
+	i2cdprintk("MSI TV @nywhere remote key: %02x\n", b);
+	return 1; 
+}
+
 static int get_key_purpletv(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 {
 	unsigned char b;
@@ -601,6 +644,11 @@ int saa7134_input_init1(struct saa7134_d
 		mask_keycode = 0x7f;
 		polling = 40; /* ms */
 		break;
+	case SAA7134_BOARD_MSI_TVANYWHERE_AD:
+                ir_codes     = ir_codes_msi_tvanywhere_ad;
+	  	mask_keycode = 0x0001F00;
+		mask_keydown = 0x0040000;
+		break;
 	}
 	if (NULL == ir_codes) {
 		printk("%s: Oops: IR config error [card=%d]\n",
@@ -722,7 +770,12 @@ void saa7134_set_i2c_ir(struct saa7134_d
 		ir->get_key   = get_key_beholdm6xx;
 		ir->ir_codes  = ir_codes_behold;
 		break;
-	default:
+	case SAA7134_BOARD_MSI_TVANYWHERE_AD:
+		snprintf(ir->c.name, sizeof(ir->c.name), "MSI TV anywhere a/d");
+		ir->get_key   = get_key_msi_tvanywhere_ad;
+		ir->ir_codes  = ir_codes_msi_tvanywhere_ad;
+		break;
+ 	default:
 		dprintk("Shouldn't get here: Unknown board %x for I2C IR?\n",dev->board);
 		break;
 	}
diff -upr drivers/media/video/saa7134/saa7134.h drivers/media/video/saa7134/saa7134.h
--- drivers/media/video/saa7134/saa7134.h	2009-04-02 22:55:27.000000000 +0200
+++ drivers/media/video/saa7134/saa7134.h	2009-05-06 07:19:58.000000000 +0200
@@ -277,6 +277,7 @@ struct saa7134_format {
 #define SAA7134_BOARD_ASUSTeK_TIGER         152
 #define SAA7134_BOARD_KWORLD_PLUS_TV_ANALOG 153
 #define SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS 154
+#define SAA7134_BOARD_MSI_TVANYWHERE_AD 155
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8
diff -upr include/media/ir-common.h include/media/ir-common.h
--- include/media/ir-common.h	2009-04-02 22:55:27.000000000 +0200
+++ include/media/ir-common.h	2009-05-06 07:59:56.000000000 +0200
@@ -159,6 +159,7 @@ extern IR_KEYTAB_TYPE ir_codes_real_audi
 extern IR_KEYTAB_TYPE ir_codes_msi_tvanywhere_plus[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_ati_tv_wonder_hd_600[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_kworld_plus_tv_analog[IR_KEYTAB_SIZE];
+extern IR_KEYTAB_TYPE ir_codes_msi_tvanywhere_ad[IR_KEYTAB_SIZE];
 #endif
 
 /*
diff -upr drivers/media/video/ir-kbd-i2c.c drivers/media/video/ir-kbd-i2c.c
--- /drivers/media/video/ir-kbd-i2c.c	2009-04-02 22:55:27.000000000 +0200
+++ /drivers/media/video/ir-kbd-i2c.c	2009-05-07 09:26:33.000000000 +0200
@@ -58,6 +58,9 @@ static int hauppauge;
 module_param(hauppauge, int, 0644);    /* Choose Hauppauge remote */
 MODULE_PARM_DESC(hauppauge, "Specify Hauppauge remote: 0=black, 1=grey (defaults to 0)");
 
+static int i2cport;
+module_param(i2cport, int, 0644);    /* manual select i2c port */
+MODULE_PARM_DESC(i2cport, 	"Manual select i2c port - can't do probes :(");
 
 #define DEVNAME "ir-kbd-i2c"
 #define dprintk(level, fmt, arg...)	if (debug >= level) \
@@ -303,7 +306,15 @@ static int ir_attach(struct i2c_adapter 
 	ir->c.addr    = addr;
 
 	i2c_set_clientdata(&ir->c, ir);
-
+	
+	if (i2cport != 0){
+	        name        = "MSI TV anywhere A/D";
+	        ir_type     = IR_TYPE_OTHER;
+	        ir_codes    = ir_codes_msi_tvanywhere_ad;
+		
+	}
+	else
+	{
 	switch(addr) {
 	case 0x64:
 		name        = "Pixelview";
@@ -366,6 +377,7 @@ static int ir_attach(struct i2c_adapter 
 		err = -ENODEV;
 		goto err_out_free;
 	}
+	}
 
 	/* Sets name */
 	snprintf(ir->c.name, sizeof(ir->c.name), "i2c IR (%s)", name);
@@ -496,7 +508,12 @@ static int ir_probe(struct i2c_adapter *
 			return 0;
 		}
 	}
-
+	/* FOR MSI TV anywhere A/D - setup manually i2c address*/
+	if (i2cport != 0) {
+		printk(DEVNAME ": Using MSI TV @nywhere A/D remote - i2c port: 0x%02x\n", i2cport);
+		ir_attach(adap, i2cport, 0, 0);
+	}
+				
 	/* Special case for MSI TV@nywhere Plus remote */
 	if (adap->id == I2C_HW_SAA7134) {
 		u8 temp;

--------------040309070600000505000202--
