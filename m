Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3PDvjRH020520
	for <video4linux-list@redhat.com>; Fri, 25 Apr 2008 09:57:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3PDvX7h006953
	for <video4linux-list@redhat.com>; Fri, 25 Apr 2008 09:57:33 -0400
Date: Fri, 25 Apr 2008 10:56:18 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: hermann pitton <hermann-pitton@arcor.de>
Message-ID: <20080425105618.08c5c471@gaivota>
In-Reply-To: <1209009328.3402.9.camel@pc10.localdom.local>
References: <480A5CC3.6030408@pickworth.me.uk> <480B26FC.50204@hccnet.nl>
	<480B3673.3040707@pickworth.me.uk>
	<1208696771.3349.49.camel@pc10.localdom.local>
	<480B6CD8.7040702@hccnet.nl>
	<1208726202.5682.44.camel@pc10.localdom.local>
	<1209009328.3402.9.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: DVB ML <linux-dvb@linuxtv.org>, video4linux-list@redhat.com,
	Michael Krufky <mkrufky@linuxtv.org>,
	Gert Vervoort <gert.vervoort@hccnet.nl>
Subject: Re: Hauppauge WinTV regreession from 2.6.24 to 2.6.25
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

On Thu, 24 Apr 2008 05:55:28 +0200
hermann pitton <hermann-pitton@arcor.de> wrote:

> > > >>>> I am testing a kernel upgrade from 2.6.24.to 2.6.25, and the drivers 
> > > >>>> for   the Hauppauge WinTV appear to have suffered some regression 
> > > >>>> between the two kernel versions.

> do you see the auto detection issue?
> 
> Either tell it is just nothing, what I very seriously doubt, or please
> comment.
> 
> I don't like to end up on LKML again getting told that written rules
> don't exist ;)

Sorry for now answer earlier. Too busy here, due to the merge window.

This seems to be an old bug. On several cases, tuner_type information came from
some sort of autodetection schema, but the proper setup is not sent to tuner.

Please test the enclosed patch. It warrants that TUNER_SET_TYPE_ADDR is called
at saa7134_board_init2() for all those boards:

SAA7134_BOARD_ADS_DUO_CARDBUS_PTV331
SAA7134_BOARD_ASUS_EUROPA2_HYBRID
SAA7134_BOARD_ASUSTeK_P7131_DUAL
SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA
SAA7134_BOARD_AVERMEDIA_SUPER_007
SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM
SAA7134_BOARD_BMK_MPEX_NOTUNER
SAA7134_BOARD_BMK_MPEX_TUNER
SAA7134_BOARD_CINERGY_HT_PCI
SAA7134_BOARD_CINERGY_HT_PCMCIA
SAA7134_BOARD_CREATIX_CTX953
SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS
SAA7134_BOARD_FLYDVB_TRIO
SAA7134_BOARD_HAUPPAUGE_HVR1110
SAA7134_BOARD_KWORLD_ATSC110
SAA7134_BOARD_KWORLD_DVBT_210
SAA7134_BOARD_MD7134
SAA7134_BOARD_MEDION_MD8800_QUADRO
SAA7134_BOARD_PHILIPS_EUROPA
SAA7134_BOARD_PHILIPS_TIGER
SAA7134_BOARD_PHILIPS_TIGER_S
SAA7134_BOARD_PINNACLE_PCTV_310i
SAA7134_BOARD_TEVION_DVBT_220RF
SAA7134_BOARD_TWINHAN_DTV_DVB_3056
SAA7134_BOARD_VIDEOMATE_DVBT_200
SAA7134_BOARD_VIDEOMATE_DVBT_200A
SAA7134_BOARD_VIDEOMATE_DVBT_300

It is important to test the above boards, to be sure that no regression is
caused.

Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>

diff -r 60110897e86a linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Apr 25 08:04:54 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Apr 25 10:44:16 2008 -0300
@@ -5688,16 +5688,19 @@
 int saa7134_board_init2(struct saa7134_dev *dev)
 {
 	unsigned char buf;
-	int board;
+	int board, need_init_tuner = 1;
 	struct tuner_setup tun_setup;
 	tun_setup.config = 0;
 	tun_setup.tuner_callback = saa7134_tuner_callback;
+	tun_setup.mode_mask = T_RADIO     |
+			      T_ANALOG_TV |
+			      T_DIGITAL_TV;
 
 	switch (dev->board) {
 	case SAA7134_BOARD_BMK_MPEX_NOTUNER:
 	case SAA7134_BOARD_BMK_MPEX_TUNER:
 		dev->i2c_client.addr = 0x60;
-		board = (i2c_master_recv(&dev->i2c_client,&buf,0) < 0)
+		board = (i2c_master_recv(&dev->i2c_client, &buf, 0) < 0)
 			? SAA7134_BOARD_BMK_MPEX_NOTUNER
 			: SAA7134_BOARD_BMK_MPEX_TUNER;
 		if (board == dev->board)
@@ -5707,21 +5710,9 @@
 		saa7134_boards[dev->board].name);
 		dev->tuner_type = saa7134_boards[dev->board].tuner_type;
 
-		if (TUNER_ABSENT != dev->tuner_type) {
-			tun_setup.mode_mask = T_RADIO     |
-					      T_ANALOG_TV |
-					      T_DIGITAL_TV;
-			tun_setup.type = dev->tuner_type;
-			tun_setup.addr = ADDR_UNSET;
-			tun_setup.tuner_callback = saa7134_tuner_callback;
-
-			saa7134_i2c_call_clients(dev,
-						 TUNER_SET_TYPE_ADDR,
-						 &tun_setup);
-		}
 		break;
 	case SAA7134_BOARD_MD7134:
-		{
+	{
 		u8 subaddr;
 		u8 data[3];
 		int ret, tuner_t;
@@ -5787,17 +5778,8 @@
 			saa7134_i2c_call_clients(dev, TUNER_SET_CONFIG,
 						 &tda9887_cfg);
 		}
-
-		tun_setup.mode_mask = T_RADIO     |
-				      T_ANALOG_TV |
-				      T_DIGITAL_TV;
-		tun_setup.type = dev->tuner_type;
-		tun_setup.addr = ADDR_UNSET;
-
-		saa7134_i2c_call_clients(dev,
-					 TUNER_SET_TYPE_ADDR, &tun_setup);
-		}
-		break;
+		break;
+	}
 	case SAA7134_BOARD_PHILIPS_EUROPA:
 		if (dev->autodetected && (dev->eedata[0x41] == 0x1c)) {
 			/* Reconfigure board as Snake reference design */
@@ -5809,24 +5791,20 @@
 		}
 	case SAA7134_BOARD_VIDEOMATE_DVBT_300:
 	case SAA7134_BOARD_ASUS_EUROPA2_HYBRID:
+	{
+
 		/* The Philips EUROPA based hybrid boards have the tuner connected through
 		 * the channel decoder. We have to make it transparent to find it
 		 */
-		{
 		u8 data[] = { 0x07, 0x02};
 		struct i2c_msg msg = {.addr=0x08, .flags=0, .buf=data, .len = sizeof(data)};
 		i2c_transfer(&dev->i2c_adap, &msg, 1);
 
-		tun_setup.mode_mask = T_ANALOG_TV | T_DIGITAL_TV;
-		tun_setup.type = dev->tuner_type;
-		tun_setup.addr = dev->tuner_addr;
-
-		saa7134_i2c_call_clients (dev, TUNER_SET_TYPE_ADDR,&tun_setup);
-		}
-		break;
+		break;
+	}
 	case SAA7134_BOARD_PHILIPS_TIGER:
 	case SAA7134_BOARD_PHILIPS_TIGER_S:
-		{
+	{
 		u8 data[] = { 0x3c, 0x33, 0x60};
 		struct i2c_msg msg = {.addr=0x08, .flags=0, .buf=data, .len = sizeof(data)};
 		if(dev->autodetected && (dev->eedata[0x49] == 0x50)) {
@@ -5835,17 +5813,23 @@
 				dev->name, saa7134_boards[dev->board].name);
 		}
 		if(dev->board == SAA7134_BOARD_PHILIPS_TIGER_S) {
-			tun_setup.mode_mask = T_ANALOG_TV | T_DIGITAL_TV;
-			tun_setup.type = TUNER_PHILIPS_TDA8290;
-			tun_setup.addr = 0x4b;
+			dev->tuner_type = TUNER_PHILIPS_TDA8290;
+			dev->tuner_addr = 0x4b;
+
+			tun_setup.type = dev->tuner_type;
+			tun_setup.addr = dev->tuner_addr;
 			tun_setup.config = 2;
 
-			saa7134_i2c_call_clients (dev, TUNER_SET_TYPE_ADDR,&tun_setup);
+			saa7134_i2c_call_clients(dev, TUNER_SET_TYPE_ADDR,
+						 &tun_setup);
+			need_init_tuner = 0;
+
 			data[2] = 0x68;
 		}
 		i2c_transfer(&dev->i2c_adap, &msg, 1);
-		}
-		break;
+
+		break;
+	}
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
 		hauppauge_eeprom(dev, dev->eedata+0x80);
 		/* break intentionally omitted */
@@ -5858,52 +5842,55 @@
 	case SAA7134_BOARD_AVERMEDIA_SUPER_007:
 	case SAA7134_BOARD_TWINHAN_DTV_DVB_3056:
 	case SAA7134_BOARD_CREATIX_CTX953:
+	{
 		/* this is a hybrid board, initialize to analog mode
 		 * and configure firmware eeprom address
 		 */
-		{
 		u8 data[] = { 0x3c, 0x33, 0x60};
 		struct i2c_msg msg = {.addr=0x08, .flags=0, .buf=data, .len = sizeof(data)};
 		i2c_transfer(&dev->i2c_adap, &msg, 1);
-		}
-		break;
+		break;
+	}
 	case SAA7134_BOARD_FLYDVB_TRIO:
-		{
+	{
 		u8 data[] = { 0x3c, 0x33, 0x62};
 		struct i2c_msg msg = {.addr=0x09, .flags=0, .buf=data, .len = sizeof(data)};
 		i2c_transfer(&dev->i2c_adap, &msg, 1);
-		}
-		break;
+		break;
+	}
 	case SAA7134_BOARD_ADS_DUO_CARDBUS_PTV331:
 	case SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS:
+	{
 		/* initialize analog mode  */
-		{
 		u8 data[] = { 0x3c, 0x33, 0x6a};
 		struct i2c_msg msg = {.addr=0x08, .flags=0, .buf=data, .len = sizeof(data)};
 		i2c_transfer(&dev->i2c_adap, &msg, 1);
-		}
-		break;
+		break;
+	}
 	case SAA7134_BOARD_CINERGY_HT_PCMCIA:
 	case SAA7134_BOARD_CINERGY_HT_PCI:
+	{
 		/* initialize analog mode */
-		{
 		u8 data[] = { 0x3c, 0x33, 0x68};
 		struct i2c_msg msg = {.addr=0x08, .flags=0, .buf=data, .len = sizeof(data)};
 		i2c_transfer(&dev->i2c_adap, &msg, 1);
-		}
-		break;
+		break;
+	}
 	case SAA7134_BOARD_KWORLD_ATSC110:
-		{
-			/* enable tuner */
-			int i;
-			static const u8 buffer [] = { 0x10,0x12,0x13,0x04,0x16,0x00,0x14,0x04,0x017,0x00 };
-			dev->i2c_client.addr = 0x0a;
-			for (i = 0; i < 5; i++)
-				if (2 != i2c_master_send(&dev->i2c_client,&buffer[i*2],2))
-					printk(KERN_WARNING "%s: Unable to enable tuner(%i).\n",
-					       dev->name, i);
-		}
-		break;
+	{
+		/* enable tuner */
+		int i;
+		static const u8 buffer [] = { 0x10, 0x12, 0x13, 0x04, 0x16,
+					      0x00, 0x14, 0x04, 0x17, 0x00 };
+		dev->i2c_client.addr = 0x0a;
+		for (i = 0; i < 5; i++)
+			if (2 != i2c_master_send(&dev->i2c_client,
+						 &buffer[i*2], 2))
+				printk(KERN_WARNING
+				       "%s: Unable to enable tuner(%i).\n",
+				       dev->name, i);
+		break;
+	}
 	case SAA7134_BOARD_VIDEOMATE_DVBT_200:
 	case SAA7134_BOARD_VIDEOMATE_DVBT_200A:
 		/* The T200 and the T200A share the same pci id.  Consequently,
@@ -5928,7 +5915,7 @@
 		}
 		break;
 	case SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM:
-		{
+	{
 		struct v4l2_priv_tun_config tea5767_cfg;
 		struct tea5767_ctrl ctl;
 
@@ -5939,8 +5926,20 @@
 		tea5767_cfg.tuner = TUNER_TEA5767;
 		tea5767_cfg.priv  = &ctl;
 		saa7134_i2c_call_clients(dev, TUNER_SET_CONFIG, &tea5767_cfg);
-		}
-		break;
+
+		tun_setup.mode_mask &= ~T_RADIO;
+		break;
+	}
+	default:
+		need_init_tuner = 0;
+	} /* switch() */
+
+	if ((TUNER_ABSENT != dev->tuner_type) && need_init_tuner) {
+		tun_setup.type = dev->tuner_type;
+		tun_setup.addr = dev->tuner_addr;
+		tun_setup.tuner_callback = saa7134_tuner_callback;
+
+		saa7134_i2c_call_clients(dev, TUNER_SET_TYPE_ADDR, &tun_setup);
 	}
 
 	if (dev->tuner_type == TUNER_XC2028) {

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
