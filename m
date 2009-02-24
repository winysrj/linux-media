Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1OCUPXE015407
	for <video4linux-list@redhat.com>; Tue, 24 Feb 2009 07:30:25 -0500
Received: from mail-bw0-f160.google.com (mail-bw0-f160.google.com
	[209.85.218.160])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n1OCUAWJ024373
	for <video4linux-list@redhat.com>; Tue, 24 Feb 2009 07:30:10 -0500
Received: by bwz4 with SMTP id 4so6168338bwz.3
	for <video4linux-list@redhat.com>; Tue, 24 Feb 2009 04:30:09 -0800 (PST)
Date: Tue, 24 Feb 2009 21:30:58 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Message-ID: <20090224213058.13cd1737@glory.loctelecom.ru>
In-Reply-To: <1235477424.3334.15.camel@pc10.localdom.local>
References: <20090224160642.2200eb25@glory.loctelecom.ru>
	<1235477424.3334.15.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/BdS7iei/Q1_c4XEN7qM3E/p"
Cc: V4L <video4linux-list@redhat.com>
Subject: Re: new tuner
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

--MP_/BdS7iei/Q1_c4XEN7qM3E/p
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi hermann

> Hi Dmitry,
> 
> on a first look.
> 
> Am Dienstag, den 24.02.2009, 16:06 +0900 schrieb Dmitri Belimov:
> > Hi All.
> > 
> > How I can add new type of tuner to video4linux??
> > 
> > I add new definition into  linux/include/media/tuner.h
> > #define TUNER_PHILIPS_FM1216MK5		79
> > 
> > add some data to
> > /linux/drivers/media/common/tuners/tuner-types.c
> > 
> > /* ------------ TUNER_PHILIPS_FM1216MK5 - Philips PAL ------------
> > */
> > 
> > static struct tuner_range tuner_fm1216mk5_pal_ranges[] = {
> > 	{ 16 * 158.00 /*MHz*/, 0x8e, 0x01, },
> > 	{ 16 * 442.00 /*MHz*/, 0x8e, 0x02, },
> > 	{ 16 * 999.99        , 0x8e, 0x04, },
> > };
> 
> This is wrong, since you only duplicate fm1216me_mk3_pal_ranges which
> you should just use instead.

Yes, I know. My first step is duplicate all function of mk3 in new tuner. When all is build done and work
without regression I add special part for MK5.
 
> > static struct tuner_params tuner_fm1216mk5_params[] = {
> > 	{
> > 		.type   = TUNER_PARAM_TYPE_PAL,
> > 		.ranges = tuner_fm1216mk5_pal_ranges,
> > 		.count  = ARRAY_SIZE(tuner_fm1216mk5_pal_ranges),
> >  		.cb_first_if_lower_freq = 1,
> >  		.has_tda9887 = 1,
> >  		.port1_active = 1,
> >  		.initdata = tua603x_agc112,
> >  		.sleepdata = (u8[]){ 4, 0x9c, 0x60, 0x85, 0x54 },
> >  	},
> 
> Since you do not send a diff, I assume you are not in struct tunertype
> tuners[] here. Also initdata and sleepdata should be there
> 
> > 		[TUNER_PHILIPS_FM1216MK5] = { /* Philips PAL */
> > 		.name   = "Philips PAL/SECAM multi (FM1216 MK5)",
> > 		.params = tuner_fm1216mk5_params,
> > 		.count  = ARRAY_SIZE(tuner_fm1216mk5_params),
> > 	},
> > 
> > But when I change type of tuner to new model build exit with error.
> > Incorrect tuner name.
> > 
> > What is wrong??
> > 
> > With my best regards, Dmitry.
> > 
> 
> You also miss to set it up for the radio mode switch in tuner-simple
> and did not look into tveeprom.c, where you can see that we use the 
> TUNER_PHILIPS_FM1216ME_MK3 for it since long without complaints. MK4
> is also the same.
> 
> If you don't have the detailed programming tables for every supported
> TV standard and detailed instructions for radio mode, I would assume
> that you reduce the quality of support for that tuner a lot with your
> current attempt.

I have all documentation to this tuner under NDA. I want add support of MK5 to v4l.
MK3 and MK5 has some incompatible registers and control messages.

Some of our TV card has two different tuners: MK3 and MK5. Some customers can has
some problem with one model of TV card with different tuners.

See attache. I split our card to different types and add new tuner.

> For example SECAM-L would not work without port2=0 and radio without
> high sensitivity set is also very poor.
> 
> Cheers,
> Hermann

With my best regards, Dmitry.

--MP_/BdS7iei/Q1_c4XEN7qM3E/p
Content-Type: text/x-patch; name=mk5_01.diff
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=mk5_01.diff

diff -r 43dbc8ebb5a2 linux/drivers/media/common/tuners/tuner-simple.c
--- a/linux/drivers/media/common/tuners/tuner-simple.c	Tue Jan 27 23:47:50 2009 -0200
+++ b/linux/drivers/media/common/tuners/tuner-simple.c	Fri Jan 30 09:59:20 2009 +0900
@@ -140,6 +140,7 @@
 {
 	switch (type) {
 	case TUNER_PHILIPS_FM1216ME_MK3:
+	case TUNER_PHILIPS_FM1216MK5:
 	case TUNER_PHILIPS_FM1236_MK3:
 	case TUNER_PHILIPS_FM1256_IH3:
 	case TUNER_LG_NTSC_TAPE:
@@ -511,6 +512,7 @@
 			  "Most cards have a TEA5767 for FM\n");
 		return 0;
 	case TUNER_PHILIPS_FM1216ME_MK3:
+	case TUNER_PHILIPS_FM1216MK5:
 	case TUNER_PHILIPS_FM1236_MK3:
 	case TUNER_PHILIPS_FMD1216ME_MK3:
 	case TUNER_PHILIPS_FMD1216MEX_MK3:
diff -r 43dbc8ebb5a2 linux/drivers/media/common/tuners/tuner-types.c
--- a/linux/drivers/media/common/tuners/tuner-types.c	Tue Jan 27 23:47:50 2009 -0200
+++ b/linux/drivers/media/common/tuners/tuner-types.c	Fri Jan 30 09:59:20 2009 +0900
@@ -567,6 +567,31 @@
 		.type   = TUNER_PARAM_TYPE_PAL,
 		.ranges = tuner_fm1216me_mk3_pal_ranges,
 		.count  = ARRAY_SIZE(tuner_fm1216me_mk3_pal_ranges),
+		.cb_first_if_lower_freq = 1,
+		.has_tda9887 = 1,
+		.port1_active = 1,
+		.port2_active = 1,
+		.port2_invert_for_secam_lc = 1,
+		.port1_fm_high_sensitivity = 1,
+		.default_top_mid = -2,
+		.default_top_secam_mid = -2,
+		.default_top_secam_high = -2,
+	},
+};
+
+/* ------------ TUNER_PHILIPS_FM1216MK5 - Philips PAL ------------ */
+
+static struct tuner_range tuner_fm1216mk5_pal_ranges[] = {
+	{ 16 * 158.00 /*MHz*/, 0x8e, 0x01, },
+	{ 16 * 442.00 /*MHz*/, 0x8e, 0x02, },
+	{ 16 * 999.99        , 0x8e, 0x04, },
+};
+
+static struct tuner_params tuner_fm1216mk5_params[] = {
+	{
+		.type   = TUNER_PARAM_TYPE_PAL,
+		.ranges = tuner_fm1216mk5_pal_ranges,
+		.count  = ARRAY_SIZE(tuner_fm1216mk5_pal_ranges),
 		.cb_first_if_lower_freq = 1,
 		.has_tda9887 = 1,
 		.port1_active = 1,
@@ -1695,6 +1720,11 @@
 		.initdata = tua603x_agc112,
 		.sleepdata = (u8[]){ 4, 0x9c, 0x60, 0x85, 0x54 },
 	},
+		[TUNER_PHILIPS_FM1216MK5] = { /* Philips PAL */
+		.name   = "Philips PAL/SECAM multi (FM1216 MK5)",
+		.params = tuner_fm1216mk5_params,
+		.count  = ARRAY_SIZE(tuner_fm1216mk5_params),
+	},
 };
 EXPORT_SYMBOL(tuners);
 
diff -r 43dbc8ebb5a2 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Jan 27 23:47:50 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Jan 30 09:59:20 2009 +0900
@@ -3976,9 +3976,43 @@
 	[SAA7134_BOARD_BEHOLD_505FM] = {
 		/*       Beholder Intl. Ltd. 2008      */
 		/*Dmitry Belimov <d.belimov@gmail.com> */
-		.name           = "Beholder BeholdTV 505 FM/RDS",
-		.audio_clock    = 0x00200000,
-		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.name           = "Beholder BeholdTV 505 FM",
+		.audio_clock    = 0x00200000,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.gpiomask       = 0x00008000,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 3,
+			.amux = LINE2,
+			.tv   = 1,
+		},{
+			.name = name_comp1,
+			.vmux = 1,
+			.amux = LINE1,
+		},{
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+		}},
+		.mute = {
+			.name = name_mute,
+			.amux = LINE1,
+		},
+		.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+		},
+	},
+	[SAA7134_BOARD_BEHOLD_505RDS] = {
+		/*       Beholder Intl. Ltd. 2008      */
+		/*Dmitry Belimov <d.belimov@gmail.com> */
+		.name           = "Beholder BeholdTV 505 RDS",
+		.audio_clock    = 0x00200000,
+		.tuner_type     = TUNER_PHILIPS_FM1216MK5,
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
@@ -4010,7 +4044,7 @@
 	[SAA7134_BOARD_BEHOLD_507_9FM] = {
 		/*       Beholder Intl. Ltd. 2008      */
 		/*Dmitry Belimov <d.belimov@gmail.com> */
-		.name           = "Beholder BeholdTV 507 FM/RDS / BeholdTV 509 FM",
+		.name           = "Beholder BeholdTV 507 FM / BeholdTV 509 FM",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
 		.radio_type     = UNSET,
@@ -4037,6 +4071,66 @@
 			.amux = LINE2,
 		},
 	},
+	[SAA7134_BOARD_BEHOLD_507RDS_MK5] = {
+		/*       Beholder Intl. Ltd. 2008      */
+		/*Dmitry Belimov <d.belimov@gmail.com> */
+		.name           = "Beholder BeholdTV 507 RDS",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216MK5,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.gpiomask       = 0x00008000,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 3,
+			.amux = TV,
+			.tv   = 1,
+		},{
+			.name = name_comp1,
+			.vmux = 1,
+			.amux = LINE1,
+		},{
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+		}},
+			.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+		},
+	},
+	[SAA7134_BOARD_BEHOLD_507RDS_MK3] = {
+		/*       Beholder Intl. Ltd. 2008      */
+		/*Dmitry Belimov <d.belimov@gmail.com> */
+		.name           = "Beholder BeholdTV 507 RDS",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.gpiomask       = 0x00008000,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 3,
+			.amux = TV,
+			.tv   = 1,
+		},{
+			.name = name_comp1,
+			.vmux = 1,
+			.amux = LINE1,
+		},{
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+		}},
+			.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+		},
+	},
 	[SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM] = {
 		/*       Beholder Intl. Ltd. 2008      */
 		/*Dmitry Belimov <d.belimov@gmail.com> */
@@ -4071,11 +4165,207 @@
 			.gpio = 0x000A8000,
 		},
 	},
-	[SAA7134_BOARD_BEHOLD_607_9FM] = {
-		/* Andrey Melnikoff <temnota@kmv.ru> */
-		.name           = "Beholder BeholdTV 607 / BeholdTV 609",
-		.audio_clock    = 0x00187de7,
-		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+	[SAA7134_BOARD_BEHOLD_607FM_MK3] = {
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		.name           = "Beholder BeholdTV 607 FM",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 3,
+			.amux = TV,
+			.tv   = 1,
+		},{
+			.name = name_comp1,
+			.vmux = 1,
+			.amux = LINE1,
+		},{
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+		}},
+		.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+		},
+	},
+	[SAA7134_BOARD_BEHOLD_609FM_MK3] = {
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		.name           = "Beholder BeholdTV 609 FM",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 3,
+			.amux = TV,
+			.tv   = 1,
+		},{
+			.name = name_comp1,
+			.vmux = 1,
+			.amux = LINE1,
+		},{
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+		}},
+		.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+		},
+	},
+	[SAA7134_BOARD_BEHOLD_607FM_MK5] = {
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		.name           = "Beholder BeholdTV 607 FM",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216MK5,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 3,
+			.amux = TV,
+			.tv   = 1,
+		},{
+			.name = name_comp1,
+			.vmux = 1,
+			.amux = LINE1,
+		},{
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+		}},
+		.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+		},
+	},
+	[SAA7134_BOARD_BEHOLD_609FM_MK5] = {
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		.name           = "Beholder BeholdTV 609 FM",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216MK5,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 3,
+			.amux = TV,
+			.tv   = 1,
+		},{
+			.name = name_comp1,
+			.vmux = 1,
+			.amux = LINE1,
+		},{
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+		}},
+		.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+		},
+	},
+	[SAA7134_BOARD_BEHOLD_607RDS_MK3] = {
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		.name           = "Beholder BeholdTV 607 RDS",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 3,
+			.amux = TV,
+			.tv   = 1,
+		},{
+			.name = name_comp1,
+			.vmux = 1,
+			.amux = LINE1,
+		},{
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+		}},
+		.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+		},
+	},
+	[SAA7134_BOARD_BEHOLD_609RDS_MK3] = {
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		.name           = "Beholder BeholdTV 609 RDS",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 3,
+			.amux = TV,
+			.tv   = 1,
+		},{
+			.name = name_comp1,
+			.vmux = 1,
+			.amux = LINE1,
+		},{
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+		}},
+		.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+		},
+	},
+	[SAA7134_BOARD_BEHOLD_607RDS_MK5] = {
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		.name           = "Beholder BeholdTV 607 RDS",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216MK5,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 3,
+			.amux = TV,
+			.tv   = 1,
+		},{
+			.name = name_comp1,
+			.vmux = 1,
+			.amux = LINE1,
+		},{
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+		}},
+		.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+		},
+	},
+	[SAA7134_BOARD_BEHOLD_609RDS_MK5] = {
+		/* Andrey Melnikoff <temnota@kmv.ru> */
+		.name           = "Beholder BeholdTV 609 RDS",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_FM1216MK5,
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
@@ -4177,8 +4467,7 @@
 		/* Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com> */
 		.name           = "Beholder BeholdTV M6 Extra",
 		.audio_clock    = 0x00187de7,
-		/* FIXME: Must be PHILIPS_FM1216ME_MK5*/
-		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+		.tuner_type     = TUNER_PHILIPS_FM1216MK5,
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
@@ -5573,18 +5862,18 @@
 		.subvendor    = 0x0000,
 		.subdevice    = 0x4090,
 		.driver_data  = SAA7134_BOARD_BEHOLD_409,
-	},{
+	},/*{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
 		.subvendor    = 0x0000,
 		.subdevice    = 0x5051,
 		.driver_data  = SAA7134_BOARD_BEHOLD_505FM,
-	},{
+	},*/{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
 		.subvendor    = 0x0000,
 		.subdevice    = 0x505B,
-		.driver_data  = SAA7134_BOARD_BEHOLD_505FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_505RDS,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
@@ -5596,13 +5885,13 @@
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x0000,
 		.subdevice    = 0x5071,
-		.driver_data  = SAA7134_BOARD_BEHOLD_507_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_507RDS_MK3,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x0000,
 		.subdevice    = 0x507B,
-		.driver_data  = SAA7134_BOARD_BEHOLD_507_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_507RDS_MK5,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
@@ -5626,49 +5915,49 @@
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
 		.subvendor    = 0x5ace,
 		.subdevice    = 0x6070,
-		.driver_data  = SAA7134_BOARD_BEHOLD_607_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_607FM_MK3,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
 		.subvendor    = 0x5ace,
 		.subdevice    = 0x6071,
-		.driver_data  = SAA7134_BOARD_BEHOLD_607_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_607FM_MK5,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
 		.subvendor    = 0x5ace,
 		.subdevice    = 0x6072,
-		.driver_data  = SAA7134_BOARD_BEHOLD_607_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_607RDS_MK3,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
 		.subvendor    = 0x5ace,
 		.subdevice    = 0x6073,
-		.driver_data  = SAA7134_BOARD_BEHOLD_607_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_607RDS_MK5,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x5ace,
 		.subdevice    = 0x6090,
-		.driver_data  = SAA7134_BOARD_BEHOLD_607_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_609FM_MK3,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x5ace,
 		.subdevice    = 0x6091,
-		.driver_data  = SAA7134_BOARD_BEHOLD_607_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_609FM_MK5,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x5ace,
 		.subdevice    = 0x6092,
-		.driver_data  = SAA7134_BOARD_BEHOLD_607_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_609RDS_MK3,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x5ace,
 		.subdevice    = 0x6093,
-		.driver_data  = SAA7134_BOARD_BEHOLD_607_9FM,
+		.driver_data  = SAA7134_BOARD_BEHOLD_609RDS_MK5,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
@@ -6063,7 +6352,10 @@
 	case SAA7134_BOARD_BEHOLD_407FM:
 	case SAA7134_BOARD_BEHOLD_409:
 	case SAA7134_BOARD_BEHOLD_505FM:
+	case SAA7134_BOARD_BEHOLD_505RDS:
 	case SAA7134_BOARD_BEHOLD_507_9FM:
+	case SAA7134_BOARD_BEHOLD_507RDS_MK3:
+	case SAA7134_BOARD_BEHOLD_507RDS_MK5:
 	case SAA7134_BOARD_GENIUS_TVGO_A11MCE:
 	case SAA7134_BOARD_REAL_ANGEL_220:
 	case SAA7134_BOARD_KWORLD_PLUS_TV_ANALOG:
@@ -6163,7 +6455,14 @@
 	case SAA7134_BOARD_UPMOST_PURPLE_TV:
 	case SAA7134_BOARD_MSI_TVATANYWHERE_PLUS:
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
-	case SAA7134_BOARD_BEHOLD_607_9FM:
+	case SAA7134_BOARD_BEHOLD_607FM_MK3:
+	case SAA7134_BOARD_BEHOLD_607FM_MK5:
+	case SAA7134_BOARD_BEHOLD_609FM_MK3:
+	case SAA7134_BOARD_BEHOLD_609FM_MK5:
+	case SAA7134_BOARD_BEHOLD_607RDS_MK3:
+	case SAA7134_BOARD_BEHOLD_607RDS_MK5:
+	case SAA7134_BOARD_BEHOLD_609RDS_MK3:
+	case SAA7134_BOARD_BEHOLD_609RDS_MK5:
 	case SAA7134_BOARD_BEHOLD_M6:
 	case SAA7134_BOARD_BEHOLD_M63:
 	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
diff -r 43dbc8ebb5a2 linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Tue Jan 27 23:47:50 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Fri Jan 30 09:59:20 2009 +0900
@@ -506,7 +506,10 @@
 	case SAA7134_BOARD_BEHOLD_407FM:
 	case SAA7134_BOARD_BEHOLD_409:
 	case SAA7134_BOARD_BEHOLD_505FM:
+	case SAA7134_BOARD_BEHOLD_505RDS:
 	case SAA7134_BOARD_BEHOLD_507_9FM:
+	case SAA7134_BOARD_BEHOLD_507RDS_MK3:
+	case SAA7134_BOARD_BEHOLD_507RDS_MK5:
 		ir_codes     = ir_codes_manli;
 		mask_keycode = 0x003f00;
 		mask_keyup   = 0x004000;
@@ -717,7 +720,14 @@
 		ir->get_key   = get_key_hvr1110;
 		ir->ir_codes  = ir_codes_hauppauge_new;
 		break;
-	case SAA7134_BOARD_BEHOLD_607_9FM:
+	case SAA7134_BOARD_BEHOLD_607FM_MK3:
+	case SAA7134_BOARD_BEHOLD_607FM_MK5:
+	case SAA7134_BOARD_BEHOLD_609FM_MK3:
+	case SAA7134_BOARD_BEHOLD_609FM_MK5:
+	case SAA7134_BOARD_BEHOLD_607RDS_MK3:
+	case SAA7134_BOARD_BEHOLD_607RDS_MK5:
+	case SAA7134_BOARD_BEHOLD_609RDS_MK3:
+	case SAA7134_BOARD_BEHOLD_609RDS_MK5:
 	case SAA7134_BOARD_BEHOLD_M6:
 	case SAA7134_BOARD_BEHOLD_M63:
 	case SAA7134_BOARD_BEHOLD_M6_EXTRA:
diff -r 43dbc8ebb5a2 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Tue Jan 27 23:47:50 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Fri Jan 30 09:59:20 2009 +0900
@@ -253,7 +253,7 @@
 #define SAA7134_BOARD_BEHOLD_505FM	126
 #define SAA7134_BOARD_BEHOLD_507_9FM	127
 #define SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM 128
-#define SAA7134_BOARD_BEHOLD_607_9FM	129
+#define SAA7134_BOARD_BEHOLD_607FM_MK3	129
 #define SAA7134_BOARD_BEHOLD_M6		130
 #define SAA7134_BOARD_TWINHAN_DTV_DVB_3056 131
 #define SAA7134_BOARD_GENIUS_TVGO_A11MCE   132
@@ -279,6 +279,16 @@
 #define SAA7134_BOARD_ASUSTeK_TIGER         152
 #define SAA7134_BOARD_KWORLD_PLUS_TV_ANALOG 153
 #define SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS 154
+#define SAA7134_BOARD_BEHOLD_505RDS	155
+#define SAA7134_BOARD_BEHOLD_507RDS_MK3	156
+#define SAA7134_BOARD_BEHOLD_507RDS_MK5	157
+#define SAA7134_BOARD_BEHOLD_607FM_MK5	158
+#define SAA7134_BOARD_BEHOLD_609FM_MK3	159
+#define SAA7134_BOARD_BEHOLD_609FM_MK5	160
+#define SAA7134_BOARD_BEHOLD_607RDS_MK3	161
+#define SAA7134_BOARD_BEHOLD_607RDS_MK5	162
+#define SAA7134_BOARD_BEHOLD_609RDS_MK3	163
+#define SAA7134_BOARD_BEHOLD_609RDS_MK5	164
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8
diff -r 43dbc8ebb5a2 linux/include/media/tuner.h
--- a/linux/include/media/tuner.h	Tue Jan 27 23:47:50 2009 -0200
+++ b/linux/include/media/tuner.h	Fri Jan 30 09:59:20 2009 +0900
@@ -124,6 +124,7 @@
 #define TUNER_XC5000			76	/* Xceive Silicon Tuner */
 #define TUNER_TCL_MF02GIP_5N		77	/* TCL MF02GIP_5N */
 #define TUNER_PHILIPS_FMD1216MEX_MK3	78
+#define TUNER_PHILIPS_FM1216MK5		79
 
 /* tv card specific */
 #define TDA9887_PRESENT 		(1<<0)

--MP_/BdS7iei/Q1_c4XEN7qM3E/p
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--MP_/BdS7iei/Q1_c4XEN7qM3E/p--
