Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3PF4UiE008751
	for <video4linux-list@redhat.com>; Fri, 25 Apr 2008 11:04:30 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3PF4H9G027677
	for <video4linux-list@redhat.com>; Fri, 25 Apr 2008 11:04:17 -0400
Date: Fri, 25 Apr 2008 12:03:07 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Michael Krufky" <mkrufky@linuxtv.org>
Message-ID: <20080425120307.69a71e17@gaivota>
In-Reply-To: <37219a840804250740k6b1bb64er633cff7a4e377798@mail.gmail.com>
References: <480A5CC3.6030408@pickworth.me.uk> <480B26FC.50204@hccnet.nl>
	<480B3673.3040707@pickworth.me.uk>
	<1208696771.3349.49.camel@pc10.localdom.local>
	<480B6CD8.7040702@hccnet.nl>
	<1208726202.5682.44.camel@pc10.localdom.local>
	<1209009328.3402.9.camel@pc10.localdom.local>
	<20080425105618.08c5c471@gaivota>
	<37219a840804250740k6b1bb64er633cff7a4e377798@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, DVB ML <linux-dvb@linuxtv.org>,
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

On Fri, 25 Apr 2008 10:40:14 -0400
"Michael Krufky" <mkrufky@linuxtv.org> wrote:

> On Fri, Apr 25, 2008 at 9:56 AM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
> > On Thu, 24 Apr 2008 05:55:28 +0200
> >  hermann pitton <hermann-pitton@arcor.de> wrote:
> >
> >  > > > >>>> I am testing a kernel upgrade from 2.6.24.to 2.6.25, and the drivers
> >  > > > >>>> for   the Hauppauge WinTV appear to have suffered some regression
> >  > > > >>>> between the two kernel versions.
> >
> >
> > > do you see the auto detection issue?
> >  >
> >  > Either tell it is just nothing, what I very seriously doubt, or please
> >  > comment.
> >  >
> >  > I don't like to end up on LKML again getting told that written rules
> >  > don't exist ;)
> >
> >  Sorry for now answer earlier. Too busy here, due to the merge window.
> >
> >  This seems to be an old bug. On several cases, tuner_type information came from
> >  some sort of autodetection schema, but the proper setup is not sent to tuner.
> >
> >  Please test the enclosed patch. It warrants that TUNER_SET_TYPE_ADDR is called
> >  at saa7134_board_init2() for all those boards:
> >
> >  SAA7134_BOARD_ADS_DUO_CARDBUS_PTV331
> >  SAA7134_BOARD_ASUS_EUROPA2_HYBRID
> >  SAA7134_BOARD_ASUSTeK_P7131_DUAL
> >  SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA
> >  SAA7134_BOARD_AVERMEDIA_SUPER_007
> >  SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM
> >  SAA7134_BOARD_BMK_MPEX_NOTUNER
> >  SAA7134_BOARD_BMK_MPEX_TUNER
> >  SAA7134_BOARD_CINERGY_HT_PCI
> >  SAA7134_BOARD_CINERGY_HT_PCMCIA
> >  SAA7134_BOARD_CREATIX_CTX953
> >  SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS
> >  SAA7134_BOARD_FLYDVB_TRIO
> >  SAA7134_BOARD_HAUPPAUGE_HVR1110
> >  SAA7134_BOARD_KWORLD_ATSC110
> >  SAA7134_BOARD_KWORLD_DVBT_210
> >  SAA7134_BOARD_MD7134
> >  SAA7134_BOARD_MEDION_MD8800_QUADRO
> >  SAA7134_BOARD_PHILIPS_EUROPA
> >  SAA7134_BOARD_PHILIPS_TIGER
> >  SAA7134_BOARD_PHILIPS_TIGER_S
> >  SAA7134_BOARD_PINNACLE_PCTV_310i
> >  SAA7134_BOARD_TEVION_DVBT_220RF
> >  SAA7134_BOARD_TWINHAN_DTV_DVB_3056
> >  SAA7134_BOARD_VIDEOMATE_DVBT_200
> >  SAA7134_BOARD_VIDEOMATE_DVBT_200A
> >  SAA7134_BOARD_VIDEOMATE_DVBT_300
> >
> >  It is important to test the above boards, to be sure that no regression is
> >  caused.
> >
> >  Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
> >
> >  diff -r 60110897e86a linux/drivers/media/video/saa7134/saa7134-cards.c
> >  --- a/linux/drivers/media/video/saa7134/saa7134-cards.c Fri Apr 25 08:04:54 2008 -0300
> >  +++ b/linux/drivers/media/video/saa7134/saa7134-cards.c Fri Apr 25 10:44:16 2008 -0300
> 
> Mauro,
> 
> I didn't review your patch yet, and it needs to be tested, however,
> the bug reported in this thread deals with the same regression that
> you are attempting to repair, but on the cx88 driver -- not the
> saa7134 driver.
> 
> Both drivers need to be tested to make sure that this regression has been fixed.

Ok, this is a cx88 version. Of course, needs testing.

Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>

diff -r 5c9a4decb57b linux/drivers/media/video/cx88/cx88-cards.c
--- a/linux/drivers/media/video/cx88/cx88-cards.c	Fri Apr 25 11:02:29 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-cards.c	Fri Apr 25 12:01:48 2008 -0300
@@ -2495,26 +2495,27 @@
 
 static void cx88_card_setup(struct cx88_core *core)
 {
+	int need_init_tuner = 1;
 	static u8 eeprom[256];
 
 	if (0 == core->i2c_rc) {
 		core->i2c_client.addr = 0xa0 >> 1;
-		tveeprom_read(&core->i2c_client,eeprom,sizeof(eeprom));
+		tveeprom_read(&core->i2c_client, eeprom, sizeof(eeprom));
 	}
 
 	switch (core->boardnr) {
 	case CX88_BOARD_HAUPPAUGE:
 	case CX88_BOARD_HAUPPAUGE_ROSLYN:
 		if (0 == core->i2c_rc)
-			hauppauge_eeprom(core,eeprom+8);
+			hauppauge_eeprom(core, eeprom+8);
 		break;
 	case CX88_BOARD_GDI:
 		if (0 == core->i2c_rc)
-			gdi_eeprom(core,eeprom);
+			gdi_eeprom(core, eeprom);
 		break;
 	case CX88_BOARD_WINFAST2000XP_EXPERT:
 		if (0 == core->i2c_rc)
-			leadtek_eeprom(core,eeprom);
+			leadtek_eeprom(core, eeprom);
 		break;
 	case CX88_BOARD_HAUPPAUGE_NOVASPLUS_S1:
 	case CX88_BOARD_HAUPPAUGE_NOVASE2_S1:
@@ -2524,7 +2525,7 @@
 	case CX88_BOARD_HAUPPAUGE_HVR3000:
 	case CX88_BOARD_HAUPPAUGE_HVR1300:
 		if (0 == core->i2c_rc)
-			hauppauge_eeprom(core,eeprom);
+			hauppauge_eeprom(core, eeprom);
 		break;
 	case CX88_BOARD_KWORLD_DVBS_100:
 		cx_write(MO_GP0_IO, 0x000007f8);
@@ -2605,6 +2606,20 @@
 
 		cx88_call_i2c_clients(core, TUNER_SET_CONFIG, &tea5767_cfg);
 	}
+	default:
+		need_init_tuner = 0;
+	}
+
+	if (need_init_tuner && core->board.tuner_type != TUNER_ABSENT) {
+		struct tuner_setup tun_setup;
+
+		memset (&tun_setup, 0, sizeof(tun_setup));
+
+	        tun_setup.tuner_callback = cx88_tuner_callback;
+	        tun_setup.mode_mask = T_RADIO     |
+        	                      T_ANALOG_TV |
+                	              T_DIGITAL_TV;
+		cx88_call_i2c_clients(core, TUNER_SET_TYPE_ADDR, &tun_setup);
 	}
 
 	if (core->board.tuner_type == TUNER_XC2028) {
@@ -2622,6 +2637,7 @@
 			    ctl.fname);
 		cx88_call_i2c_clients(core, TUNER_SET_CONFIG, &xc2028_cfg);
 	}
+
 }
 
 /* ------------------------------------------------------------------ */

> 
> -Mike




Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
