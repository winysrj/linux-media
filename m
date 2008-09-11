Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8BLFnva018009
	for <video4linux-list@redhat.com>; Thu, 11 Sep 2008 17:15:50 -0400
Received: from QMTA01.emeryville.ca.mail.comcast.net
	(qmta01.emeryville.ca.mail.comcast.net [76.96.30.16])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8BLEaOj020568
	for <video4linux-list@redhat.com>; Thu, 11 Sep 2008 17:14:36 -0400
Message-ID: <48C98A3D.2090709@comcast.net>
Date: Thu, 11 Sep 2008 14:14:37 -0700
From: Brian Rogers <brian_rogers@comcast.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
References: <48C4FC1F.40509@comcast.net>
	<20080911103801.52629349@mchehab.chehab.org>
In-Reply-To: <20080911103801.52629349@mchehab.chehab.org>
Content-Type: multipart/mixed; boundary="------------090606040703090503030101"
Cc: video4linux-list@redhat.com, Henry Wong <henry@stuffedcow.net>,
	Mark Schultz <n9xmj@yahoo.com>
Subject: Re: [PATCH] Add support for MSI TV@nywhere Plus remote
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

This is a multi-part message in MIME format.
--------------090606040703090503030101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Mauro Carvalho Chehab wrote:
> The patch looks good. However, it has two issues:
> 	1) Your emailer corrupted it, by replacing tabs by spaces, and wrapping
> lines. So, the patch doesn't apply:
>
> $ patch -p1 -i /tmp/patches --dry-run -d linux
> patching file drivers/media/common/ir-keymaps.c
> patch: **** malformed patch at line 68:      [ 0x00 ] = KEY_0,
>   
OK, I'm attaching the file this time.
> The better is to check your patch against the checkpatch.pl script (at kernel
> tree and at v4l/scripts/checkpatch.pl). If you have a tree cloned from hg, the
> easiest way is to apply your patch at the tree and use "make checkpatch" before
> committing it).
>
> Side note: Yes, I know that there are a large amount of style violations at the
> current drivers. The idea is trying to avoid adding even more ;)
>   
I actually ran that tool, but I skipped over the rules that were being 
broken at almost every opportunity, for consistency. :) This time I 
fixed everything.


--------------090606040703090503030101
Content-Type: text/x-patch;
 name="tvanywhere-plus-ir.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="tvanywhere-plus-ir.patch"

Add support for the MSI TV@nywhere Plus remote

The IR controller has a couple quirks. It won't respond until some other
device on the bus is probed. To work around that, probe 0x50 first.
Then, since it won't respond to a zero-byte read, probe with a one-byte read.

Signed-off-by: Brian Rogers <brian_rogers@comcast.net>

diff --git a/drivers/media/common/ir-keymaps.c b/drivers/media/common/ir-keymaps.c
index 8fa91f8..4a6ed61 100644
--- a/drivers/media/common/ir-keymaps.c
+++ b/drivers/media/common/ir-keymaps.c
@@ -467,7 +467,8 @@ EXPORT_SYMBOL_GPL(ir_codes_adstech_dvb_t_pci);
 
 /* ---------------------------------------------------------------------- */
 
-/* MSI TV@nywhere remote */
+/* MSI TV@nywhere MASTER remote */
+
 IR_KEYTAB_TYPE ir_codes_msi_tvanywhere[IR_KEYTAB_SIZE] = {
 	/* Keys 0 to 9 */
 	[ 0x00 ] = KEY_0,
@@ -501,6 +502,95 @@ EXPORT_SYMBOL_GPL(ir_codes_msi_tvanywhere);
 
 /* ---------------------------------------------------------------------- */
 
+/*
+  Keycodes for remote on the MSI TV@nywhere Plus. The controller IC on the card
+  is marked "KS003". The controller is I2C at address 0x30, but does not seem
+  to respond to probes until a read is performed from a valid device.
+  I don't know why...
+
+  Note: This remote may be of similar or identical design to the
+  Pixelview remote (?).  The raw codes and duplicate button codes
+  appear to be the same.
+
+  Henry Wong <henry@stuffedcow.net>
+  Some changes to formatting and keycodes by Mark Schultz <n9xmj@yahoo.com>
+
+*/
+
+IR_KEYTAB_TYPE ir_codes_msi_tvanywhere_plus[IR_KEYTAB_SIZE] = {
+
+/*  ---- Remote Button Layout ----
+
+    POWER   SOURCE  SCAN    MUTE
+    TV/FM   1       2       3
+    |>      4       5       6
+    <|      7       8       9
+    ^^UP    0       +       RECALL
+    vvDN    RECORD  STOP    PLAY
+
+	MINIMIZE          ZOOM
+
+		  CH+
+      VOL-                   VOL+
+		  CH-
+
+	SNAPSHOT           MTS
+
+     <<      FUNC    >>     RESET
+*/
+
+	[0x01] = KEY_KP1,             /* 1 */
+	[0x0b] = KEY_KP2,             /* 2 */
+	[0x1b] = KEY_KP3,             /* 3 */
+	[0x05] = KEY_KP4,             /* 4 */
+	[0x09] = KEY_KP5,             /* 5 */
+	[0x15] = KEY_KP6,             /* 6 */
+	[0x06] = KEY_KP7,             /* 7 */
+	[0x0a] = KEY_KP8,             /* 8 */
+	[0x12] = KEY_KP9,             /* 9 */
+	[0x02] = KEY_KP0,             /* 0 */
+	[0x10] = KEY_KPPLUS,          /* + */
+	[0x13] = KEY_AGAIN,           /* Recall */
+
+	[0x1e] = KEY_POWER,           /* Power */
+	[0x07] = KEY_TUNER,           /* Source */
+	[0x1c] = KEY_SEARCH,          /* Scan */
+	[0x18] = KEY_MUTE,            /* Mute */
+
+	[0x03] = KEY_RADIO,           /* TV/FM */
+	/* The next four keys are duplicates that appear to send the
+	   same IR code as Ch+, Ch-, >>, and << .  The raw code assigned
+	   to them is the actual code + 0x20 - they will never be
+	   detected as such unless some way is discovered to distinguish
+	   these buttons from those that have the same code. */
+	[0x3f] = KEY_RIGHT,           /* |> and Ch+ */
+	[0x37] = KEY_LEFT,            /* <| and Ch- */
+	[0x2c] = KEY_UP,              /* ^^Up and >> */
+	[0x24] = KEY_DOWN,            /* vvDn and << */
+
+	[0x00] = KEY_RECORD,          /* Record */
+	[0x08] = KEY_STOP,            /* Stop */
+	[0x11] = KEY_PLAY,            /* Play */
+
+	[0x0f] = KEY_CLOSE,           /* Minimize */
+	[0x19] = KEY_ZOOM,            /* Zoom */
+	[0x1a] = KEY_SHUFFLE,         /* Snapshot */
+	[0x0d] = KEY_LANGUAGE,        /* MTS */
+
+	[0x14] = KEY_VOLUMEDOWN,      /* Vol- */
+	[0x16] = KEY_VOLUMEUP,        /* Vol+ */
+	[0x17] = KEY_CHANNELDOWN,     /* Ch- */
+	[0x1f] = KEY_CHANNELUP,       /* Ch+ */
+
+	[0x04] = KEY_REWIND,          /* << */
+	[0x0e] = KEY_MENU,            /* Function */
+	[0x0c] = KEY_FASTFORWARD,     /* >> */
+	[0x1d] = KEY_RESTART,         /* Reset */
+};
+EXPORT_SYMBOL_GPL(ir_codes_msi_tvanywhere_plus);
+
+/* ---------------------------------------------------------------------- */
+
 /* Cinergy 1400 DVB-T */
 IR_KEYTAB_TYPE ir_codes_cinergy_1400[IR_KEYTAB_SIZE] = {
 	[ 0x01 ] = KEY_POWER,
diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index a30254b..6a3e6f2 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -12,6 +12,10 @@
  *      Markus Rechberger <mrechberger@gmail.com>
  * modified for DViCO Fusion HDTV 5 RT GOLD by
  *      Chaogui Zhang <czhang1974@gmail.com>
+ * modified for MSI TV@nywhere Plus by
+ *      Henry Wong <henry@stuffedcow.net>
+ *      Mark Schultz <n9xmj@yahoo.com>
+ *      Brian Rogers <brian_rogers@comcast.net>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -224,9 +228,15 @@ static void ir_timer(unsigned long data)
 static void ir_work(struct work_struct *work)
 {
 	struct IR_i2c *ir = container_of(work, struct IR_i2c, work);
+	int polling_interval = 100;
+
+	/* MSI TV@nywhere Plus requires more frequent polling
+	   otherwise it will miss some keypresses */
+	if (ir->c.adapter->id == I2C_HW_SAA7134 && ir->c.addr == 0x30)
+		polling_interval = 50;
 
 	ir_key_poll(ir);
-	mod_timer(&ir->timer, jiffies + msecs_to_jiffies(100));
+	mod_timer(&ir->timer, jiffies + msecs_to_jiffies(polling_interval));
 }
 
 /* ----------------------------------------------------------------------- */
@@ -465,9 +475,37 @@ static int ir_probe(struct i2c_adapter *adap)
 			(1 == rc) ? "yes" : "no");
 		if (1 == rc) {
 			ir_attach(adap, probe[i], 0, 0);
-			break;
+			return 0;
 		}
 	}
+
+	/* Special case for MSI TV@nywhere Plus remote */
+	if (adap->id == I2C_HW_SAA7134) {
+		u8 temp;
+
+		/* MSI TV@nywhere Plus controller doesn't seem to
+		   respond to probes unless we read something from
+		   an existing device. Weird... */
+
+		msg.addr = 0x50;
+		rc = i2c_transfer(adap, &msg, 1);
+			dprintk(1, "probe 0x%02x @ %s: %s\n",
+			msg.addr, adap->name,
+			(1 == rc) ? "yes" : "no");
+
+		/* Now do the probe. The controller does not respond
+		   to 0-byte reads, so we use a 1-byte read instead. */
+		msg.addr = 0x30;
+		msg.len = 1;
+		msg.buf = &temp;
+		rc = i2c_transfer(adap, &msg, 1);
+		dprintk(1, "probe 0x%02x @ %s: %s\n",
+			msg.addr, adap->name,
+			(1 == rc) ? "yes" : "no");
+		if (1 == rc)
+			ir_attach(adap, msg.addr, 0, 0);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/video/saa7134/saa7134-cards.c
index 98364d1..e8f4589 100644
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -5745,6 +5745,7 @@ int saa7134_board_init1(struct saa7134_dev *dev)
 	case SAA7134_BOARD_PINNACLE_PCTV_110i:
 	case SAA7134_BOARD_PINNACLE_PCTV_310i:
 	case SAA7134_BOARD_UPMOST_PURPLE_TV:
+	case SAA7134_BOARD_MSI_TVATANYWHERE_PLUS:
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
 	case SAA7134_BOARD_BEHOLD_607_9FM:
 	case SAA7134_BOARD_BEHOLD_M6:
diff --git a/drivers/media/video/saa7134/saa7134-i2c.c b/drivers/media/video/saa7134/saa7134-i2c.c
index 5f713e6..926e898 100644
--- a/drivers/media/video/saa7134/saa7134-i2c.c
+++ b/drivers/media/video/saa7134/saa7134-i2c.c
@@ -337,6 +337,7 @@ static int attach_inform(struct i2c_client *client)
 		case 0x47:
 		case 0x71:
 		case 0x2d:
+		case 0x30:
 		{
 			struct IR_i2c *ir = i2c_get_clientdata(client);
 			d1printk("%s i2c IR detected (%s).\n",
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index ad08d13..2174995 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -115,6 +115,54 @@ static int build_key(struct saa7134_dev *dev)
 
 /* --------------------- Chip specific I2C key builders ----------------- */
 
+static int get_key_msi_tvanywhere_plus(struct IR_i2c *ir, u32 *ir_key,
+				       u32 *ir_raw)
+{
+	unsigned char b;
+	int rc;
+	int gpio;
+
+	/* <dev> is needed to access GPIO. Used by the saa_readl macro. */
+	struct saa7134_dev *dev = ir->c.adapter->algo_data;
+	if (dev == NULL) {
+		dprintk("get_key_msi_tvanywhere_plus: "
+			"gir->c.adapter->algo_data is NULL!\n");
+		return -EIO;
+	}
+
+	/* rising SAA7134_GPIO_GPRESCAN reads the status */
+
+	saa_clearb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
+	saa_setb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
+
+	gpio = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2);
+
+	/* GPIO&0x40 is pulsed low when a button is pressed. Don't do
+	   I2C receive if gpio&0x40 is not low. */
+
+	if (gpio & 0x40)
+		return 0;       /* No button press */
+
+	/* GPIO says there is a button press. Get it. */
+
+	if (1 != i2c_master_recv(&ir->c, &b, 1)) {
+		i2cdprintk("read error\n");
+		return -EIO;
+	}
+
+	/* No button press */
+
+	if (b == 0xff)
+		return 0;
+
+	/* Button pressed */
+
+	dprintk("get_key_msi_tvanywhere_plus: Key = 0x%02X\n", b);
+	*ir_key = b;
+	*ir_raw = b;
+	return 1;
+}
+
 static int get_key_purpletv(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 {
 	unsigned char b;
@@ -612,6 +660,11 @@ void saa7134_set_i2c_ir(struct saa7134_dev *dev, struct IR_i2c *ir)
 		ir->get_key   = get_key_purpletv;
 		ir->ir_codes  = ir_codes_purpletv;
 		break;
+	case SAA7134_BOARD_MSI_TVATANYWHERE_PLUS:
+		snprintf(ir->c.name, sizeof(ir->c.name), "MSI TV@nywhere Plus");
+		ir->get_key  = get_key_msi_tvanywhere_plus;
+		ir->ir_codes = ir_codes_msi_tvanywhere_plus;
+		break;
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
 		snprintf(ir->c.name, sizeof(ir->c.name), "HVR 1110");
 		ir->get_key   = get_key_hvr1110;
diff --git a/include/media/ir-common.h b/include/media/ir-common.h
index b8e8aa9..e70362b 100644
--- a/include/media/ir-common.h
+++ b/include/media/ir-common.h
@@ -147,6 +147,7 @@ extern IR_KEYTAB_TYPE ir_codes_pinnacle_pctv_hd[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_genius_tvgo_a11mce[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_powercolor_real_angel[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_avermedia_a16d[IR_KEYTAB_SIZE];
+extern IR_KEYTAB_TYPE ir_codes_msi_tvanywhere_plus[IR_KEYTAB_SIZE];
 
 #endif
 

--------------090606040703090503030101
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------090606040703090503030101--
