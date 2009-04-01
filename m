Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.mavian.it ([84.246.147.253])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <roa@libero.it>) id 1Lp74b-000786-I7
	for linux-dvb@linuxtv.org; Wed, 01 Apr 2009 22:30:11 +0200
From: ROASCIO Paolo <roa@libero.it>
To: linux-dvb@linuxtv.org
Date: Wed, 1 Apr 2009 22:29:31 +0200
References: <49646315.20709@cdmon.com>
In-Reply-To: <49646315.20709@cdmon.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_r680JBF5i+r5IIc"
Message-Id: <200904012229.31367.roa@libero.it>
Subject: Re: [linux-dvb] support for remote in lifeview pci trio
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_r680JBF5i+r5IIc
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Il Wednesday 07 January 2009 09:08:53 Jordi Moles Blanco ha scritto:
> hi,
>
> i've been googling and trying some things during days with no luck.
>
> i want to get the remote which comes with this card working, and i only
> found old posts like this one:
>
> http://www.spinics.net/lists/vfl/msg29862.html
>
> which assures that the patch gets the remote to work on that card.

Hello, attached is the patch ported to 2.6.28, note that this is my very first 
time in c coding, then this may be an ugly piece of code (but at least works 
for me)...

> i downloaded the latest v4l source code and tried to patch it with the
> code proposed on that post, but var names have changed and i don't have
> a clue on how to apply it properly.
>
> i haven't seen any more recent post, so i guess it may still be in a
> to-do list, or may be it was rejected for some reason to go into the
> main-line.
>
> Could anyone tell me if this patch will ever be included? or... what v4l
> version could i download to be able to patch it as described?

No, the reason is the polling code as already discussed on this list, then the 
patch is only for use of who want to apply it himself without any support...

> Thanks.

Bye Paolo



--Boundary-00=_r680JBF5i+r5IIc
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="flydvb_trio_remote_final_2.6.28.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="flydvb_trio_remote_final_2.6.28.diff"

diff -U 3 -H -d -r -N -- linux-2.6.28.orig/drivers/media/video/ir-kbd-i2c.c linux-2.6.28/drivers/media/video/ir-kbd-i2c.c
--- linux-2.6.28.orig/drivers/media/video/ir-kbd-i2c.c	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28/drivers/media/video/ir-kbd-i2c.c	2009-03-23 20:16:59.000000000 +0100
@@ -340,6 +340,7 @@
 		ir_type     = IR_TYPE_RC5;
 		ir_codes    = ir_codes_fusionhdtv_mce;
 		break;
+	case 0x0b:
 	case 0x7a:
 	case 0x47:
 	case 0x71:
@@ -450,16 +451,18 @@
 	*/
 
 	static const int probe_bttv[] = { 0x1a, 0x18, 0x4b, 0x64, 0x30, -1};
-	static const int probe_saa7134[] = { 0x7a, 0x47, 0x71, 0x2d, -1 };
+	static const int probe_saa7134[] = {0x0b, 0x7a, 0x47, 0x71, 0x2d, -1 };
 	static const int probe_em28XX[] = { 0x30, 0x47, -1 };
 	static const int probe_cx88[] = { 0x18, 0x6b, 0x71, -1 };
 	static const int probe_cx23885[] = { 0x6b, -1 };
-	const int *probe;
+	const int *probe = NULL;
+	struct i2c_client c;
 	struct i2c_msg msg = {
 		.flags = I2C_M_RD,
 		.len = 0,
 		.buf = NULL,
 	};
+	unsigned char buf;
 	int i, rc;
 
 	switch (adap->id) {
@@ -485,8 +488,21 @@
 		return 0;
 	}
 
+	memset(&c,0,sizeof(c));
+	c.adapter = adap;
+
 	for (i = 0; -1 != probe[i]; i++) {
-		msg.addr = probe[i];
+		c.addr = probe[i];
+		msg.addr = c.addr;
+
+		/* if the card is a FlyDVB Trio... */
+		if (c.adapter->id == I2C_HW_SAA7134 && probe[i] == 0x0b) {
+		/* ...enable the ir */
+			buf = 0 ;
+			if (1 != i2c_master_send(&c,&buf,1))
+				dprintk(1,"Unable to enable ir receiver.\n");
+		}
+		
 		rc = i2c_transfer(adap, &msg, 1);
 		dprintk(1,"probe 0x%02x @ %s: %s\n",
 			probe[i], adap->name,
diff -U 3 -H -d -r -N -- linux-2.6.28.orig/drivers/media/video/saa7134/saa7134-cards.c linux-2.6.28/drivers/media/video/saa7134/saa7134-cards.c
--- linux-2.6.28.orig/drivers/media/video/saa7134/saa7134-cards.c	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28/drivers/media/video/saa7134/saa7134-cards.c	2009-04-01 22:17:31.000000000 +0200
@@ -5971,6 +5971,7 @@
 	case SAA7134_BOARD_UPMOST_PURPLE_TV:
 	case SAA7134_BOARD_MSI_TVATANYWHERE_PLUS:
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
+	case SAA7134_BOARD_FLYDVB_TRIO:
 	case SAA7134_BOARD_BEHOLD_607_9FM:
 	case SAA7134_BOARD_BEHOLD_M6:
 	case SAA7134_BOARD_BEHOLD_M63:
diff -U 3 -H -d -r -N -- linux-2.6.28.orig/drivers/media/video/saa7134/saa7134-i2c.c linux-2.6.28/drivers/media/video/saa7134/saa7134-i2c.c
--- linux-2.6.28.orig/drivers/media/video/saa7134/saa7134-i2c.c	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28/drivers/media/video/saa7134/saa7134-i2c.c	2009-03-20 19:03:25.000000000 +0100
@@ -333,6 +333,7 @@
 	/* Am I an i2c remote control? */
 
 	switch (client->addr) {
+		case 0x0b:
 		case 0x7a:
 		case 0x47:
 		case 0x71:
diff -U 3 -H -d -r -N -- linux-2.6.28.orig/drivers/media/video/saa7134/saa7134-input.c linux-2.6.28/drivers/media/video/saa7134/saa7134-input.c
--- linux-2.6.28.orig/drivers/media/video/saa7134/saa7134-input.c	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28/drivers/media/video/saa7134/saa7134-input.c	2009-04-01 21:25:31.000000000 +0200
@@ -118,6 +118,50 @@
 
 /* --------------------- Chip specific I2C key builders ----------------- */
 
+static int get_key_lifeview(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+{
+	unsigned long b;
+	int gpio;
+
+	/* We need this to access GPIO. Used by the saa_readl macro. */
+	struct saa7134_dev *dev = ir->c.adapter->algo_data;
+
+	if (dev == NULL) {
+		dprintk("get_key_lifeview: "
+			"ir->c.adapter->algo_data is NULL!\n");
+		return -EIO;
+	}
+
+	/* rising SAA7134_GPIO_GPRESCAN reads the status */
+	saa_clearb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
+	saa_setb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
+
+	gpio = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2);
+
+	if (0x40000 &~ gpio)
+		return 0;	/* No button press */
+
+	/* No button press - only before first key pressed */
+	if (b == 0xFF)
+		return 0;
+
+	/* poll IR chip */
+	b = 0;
+	if (1 != i2c_master_send(&ir->c, (char *)&b, 1)) {
+		i2cdprintk("send wake up byte to pic16C505 failed\n");
+		return -EIO;
+	}
+	if (1 != i2c_master_recv(&ir->c, (char *)&b, 1)) {
+		i2cdprintk("read error\n");
+		return -EIO;
+	}
+
+	/* Button pressed */
+	*ir_key = b;
+	*ir_raw = b;
+	return 1;
+}
+
 static int get_key_msi_tvanywhere_plus(struct IR_i2c *ir, u32 *ir_key,
 				       u32 *ir_raw)
 {
@@ -688,6 +732,11 @@
 		ir->get_key   = get_key_purpletv;
 		ir->ir_codes  = ir_codes_purpletv;
 		break;
+	case SAA7134_BOARD_FLYDVB_TRIO:
+		snprintf(ir->c.name, sizeof(ir->c.name), "Lifeview");
+		ir->get_key   = get_key_lifeview;
+		ir->ir_codes  = ir_codes_flydvb;
+		break;
 	case SAA7134_BOARD_MSI_TVATANYWHERE_PLUS:
 		snprintf(ir->c.name, sizeof(ir->c.name), "MSI TV@nywhere Plus");
 		ir->get_key  = get_key_msi_tvanywhere_plus;

--Boundary-00=_r680JBF5i+r5IIc
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_r680JBF5i+r5IIc--
