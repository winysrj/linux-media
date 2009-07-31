Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:41962 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750774AbZGaNaG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2009 09:30:06 -0400
Subject: Re: [PATCH] - For MSI TV@nywhere Satellite Pro DVB-S
From: hermann pitton <hermann-pitton@arcor.de>
To: Roland Schnabl <roland.schnabl@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <fc61f2400907300333x5502e021h56ec808a99a7c7ef@mail.gmail.com>
References: <fc61f2400907300333x5502e021h56ec808a99a7c7ef@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-GX+Fvrg5EHK2PYuQhDsu"
Date: Fri, 31 Jul 2009 15:20:16 +0200
Message-Id: <1249046417.3931.66.camel@pc07.localdom.local>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-GX+Fvrg5EHK2PYuQhDsu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Roland,

Am Donnerstag, den 30.07.2009, 12:33 +0200 schrieb Roland Schnabl:
> Hello I have written a patch for the MSI TV@nywhere Satellite Pro
> my enviroment is debian etch with kernel 2.6.28.9
> 01: PCI 107.0: 11200 TV Card
>   [Created at pci.281]
>   Unique ID: 2_DJ.cZjSSo5ZA4B
>   Parent ID: 8otl.Ao4TF0pWC38
>   SysFS ID: /devices/pci0000:00/0000:00:04.0/0000:01:07.0
>   SysFS BusID: 0000:01:07.0
>   Hardware Class: tv card
>   Model: "Micro-Star International SAA7134 Video Broadcast Decoder"
>   Vendor: pci 0x1131 "Philips Semiconductors"
>   Device: pci 0x7134 "SAA7134 Video Broadcast Decoder"
>   SubVendor: pci 0x1462 "Micro-Star International Co., Ltd."
>   SubDevice: pci 0x8811
>   Revision: 0x01
>   Driver: "saa7134"
>   Driver Modules: "saa7134"
>   Memory Range: 0xfafff000-0xfafff3ff (rw,non-prefetchable)
>   IRQ: 17 (no events)
>   Module Alias: "pci:v00001131d00007134sv00001462sd00008811bc04sc80i00"
>   Driver Info #0:
>     Driver Status: saa7134 is active
>     Driver Activation Cmd: "modprobe saa7134"
>   Config Status: cfg=new, avail=yes, need=no, active=unknown
>   Attached to: #15 (PCI bridge)
> 
> 01:07.0 Multimedia controller [0480]: Philips Semiconductors
> SAA7134/SAA7135HL Video Broadcast Decoder [1131:7134] (rev 01)
>         Subsystem: Micro-Star International Co., Ltd. Unknown device [1462:8811]
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 32 (21000ns min, 8000ns max)
>         Interrupt: pin A routed to IRQ 17
>         Region 0: Memory at fafff000 (32-bit, non-prefetchable) [size=1K]
>         Capabilities: [40] Power Management version 1
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=1 PME-
> 
> here is the diff:

thanks for working on it and providing patches.

Looks quite good so far, but there are some issues.

Most important, we need a 
Signed-off-by: your name <your email address>
line from you to forward the patch.

Read on the wiki about how to add information about new cards.
I had to crawl the web to find your prior activities on the card.
http://www.vdr-portal.de/board/thread.php?threadid=88020

Your patch inline now has broken lines, so I copied from vdr-portal.
Do also attach it, if your mailer is not safe for patches.

Minimum to provide is "dmesg" for the card with "i2c_scan=1", a listing
of the chips present and of all connectors. I still don't know, how the
remote is connected. On that analog input breakout cable?

The indentation in saa7134-dvb.c was one tab too deep,
also you forgot to check, if the isl6124 is present on your board.

I have removed a wprintk there for the card and your nickname and did
instead add your name and email at saa7134-cards.c at the usual place.
Is this OK with you? We need it only at your Signed-off-by line.

The card is moved to the current end of all related functions to make
later reviews easier.

It is currently removed from the i2c remotes, because it has no further
details in saa7134-input, ir-common or ir-i2c-kbd.

But the reason, why it is not simply treated as a clone of
LifeView FlyDVB-S /Acorp TV134DS is exactly the IR chip on it.

I read KS012. (else saa7134, isl6421, tda826x, tda10086)
We have support on the MSI TV@nywhere Plus for KS003. KS007 is also
known to function.

However the KS003 needed some write attempt to another address at the
bus to become visible functional then at 0x30.

Please test the recent version of the patch, make further suggestions
and/or send us your Signed-off-by, if OK so far.

Also please provide relevant "dmesg" with i2c_scan=1 for saa7134 to see
if there is any trace of the KS012.

If not, you still can try to add the card back to the i2c remotes and
also to the case statement for the MSI TV@nywhere Plus in
saa7134-input.c and watch out, if something changes. KS012 seems to be
untested so far.

	case SAA7134_BOARD_MSI_TVATANYWHERE_PLUS:
#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)
		snprintf(ir->c.name, sizeof(ir->c.name), "MSI TV@nywhere Plus");
		ir->get_key  = get_key_msi_tvanywhere_plus;
		ir->ir_codes = ir_codes_msi_tvanywhere_plus;
#else
		init_data.name = "MSI TV@nywhere Plus";
		init_data.get_key = get_key_msi_tvanywhere_plus;
		init_data.ir_codes = ir_codes_msi_tvanywhere_plus;
		info.addr = 0x30;
		/* MSI TV@nywhere Plus controller doesn't seem to
		   respond to probes unless we read something from
		   an existing device. Weird...
		   REVISIT: might no longer be needed */
		rc = i2c_transfer(&dev->i2c_adap, &msg_msi, 1);
		dprintk(KERN_DEBUG "probe 0x%02x @ %s: %s\n",
			msg_msi.addr, dev->i2c_adap.name,
			(1 == rc) ? "yes" : "no");
#endif
		break;

Good luck for the IR!
Did you try card=97. Should work, except for the remote, I guess.

Cheers,
Hermann

saa7134: add support for MSI TV@nywhere Satellite Pro
Patch v2, also attached.

If OK, please sign here.



diff -r 3f2dffde2429 linux/Documentation/video4linux/CARDLIST.saa7134
--- a/linux/Documentation/video4linux/CARDLIST.saa7134	Thu Jul 30 20:00:44 2009 -0300
+++ b/linux/Documentation/video4linux/CARDLIST.saa7134	Fri Jul 31 13:38:21 2009 +0200
@@ -167,3 +167,4 @@
 166 -> Beholder BeholdTV 607 RDS                [5ace:6073]
 167 -> Beholder BeholdTV 609 RDS                [5ace:6092]
 168 -> Beholder BeholdTV 609 RDS                [5ace:6093]
+169 -> MSI TV@nywhere Satellite Pro             [1462:8811]
diff -r 3f2dffde2429 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Jul 30 20:00:44 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Jul 31 13:38:21 2009 +0200
@@ -5155,6 +5155,25 @@
 			.gpio = 0x00,
 		},
 	},
+	[SAA7134_BOARD_MSI_TVATANYWHERE_SATELLITE_PRO] = {
+		/* Roland Schnabl <roland.schnabl@gmail.com> */
+		.name           = "MSI TV@nywhere Satellite Pro",
+		.audio_clock    = 0x00200000,
+		.tuner_type     = TUNER_ABSENT,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.mpeg           = SAA7134_MPEG_DVB,
+		.inputs = {{
+			.name   = name_comp1,
+			.vmux   = 3,
+			.amux   = LINE1,
+		}, {
+			.name   = name_svideo,
+			.vmux   = 8,
+			.amux   = LINE1,
+		} },
+	},
 };
 
 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -6262,7 +6281,12 @@
 		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
 		.subdevice    = 0xf31d,
 		.driver_data  = SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS,
-
+	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
+		.subvendor    = 0x1462,
+		.subdevice    = 0x8811,
+		.driver_data  = SAA7134_BOARD_MSI_TVATANYWHERE_SATELLITE_PRO,
 	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
diff -r 3f2dffde2429 linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Thu Jul 30 20:00:44 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Fri Jul 31 13:38:21 2009 +0200
@@ -1477,6 +1477,24 @@
 			}
 		}
 		break;
+	case SAA7134_BOARD_MSI_TVATANYWHERE_SATELLITE_PRO:
+		fe0->dvb.frontend = dvb_attach(tda10086_attach, &flydvbs,
+							&dev->i2c_adap);
+		if (fe0->dvb.frontend) {
+			if (dvb_attach(tda826x_attach, fe0->dvb.frontend, 0x60,
+					&dev->i2c_adap, 0) == NULL) {
+				wprintk("%s: MSI TV@nywhere Satellite Pro, no "
+						"tda826x found!\n", __func__);
+				goto dettach_frontend;
+			}
+			if (dvb_attach(isl6421_attach, fe0->dvb.frontend,
+					&dev->i2c_adap, 0x08, 0, 0) == NULL) {
+				wprintk("%s: MSI TV@nywhere Satellite Pro, no "
+						"isl6421 found!\n", __func__);
+				goto dettach_frontend;
+			}
+		}
+		break;
 	default:
 		wprintk("Huh? unknown DVB card?\n");
 		break;
diff -r 3f2dffde2429 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Thu Jul 30 20:00:44 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Fri Jul 31 13:38:21 2009 +0200
@@ -293,6 +293,7 @@
 #define SAA7134_BOARD_BEHOLD_607RDS_MK5     166
 #define SAA7134_BOARD_BEHOLD_609RDS_MK3     167
 #define SAA7134_BOARD_BEHOLD_609RDS_MK5     168
+#define SAA7134_BOARD_MSI_TVATANYWHERE_SATELLITE_PRO  169
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8





> -----------------------------------------------------------------------------------------------------------
> diff -r fd96af63f79b linux/Documentation/video4linux/CARDLIST.saa7134
> --- a/linux/Documentation/video4linux/CARDLIST.saa7134  Fri Jun 19
> 19:56:56 2009 +0000
> +++ b/linux/Documentation/video4linux/CARDLIST.saa7134  Thu Jul 30
> 12:26:05 2009 +0200
> @@ -167,3 +167,4 @@
>  166 -> Beholder BeholdTV 607 RDS                [5ace:6073]
>  167 -> Beholder BeholdTV 609 RDS                [5ace:6092]
>  168 -> Beholder BeholdTV 609 RDS                [5ace:6093]
> +169 -> MSI TV@nywhere Satellite Pro             [1462:8811]
> diff -r fd96af63f79b linux/drivers/media/video/saa7134/saa7134-cards.c
> --- a/linux/drivers/media/video/saa7134/saa7134-cards.c Fri Jun 19
> 19:56:56 2009 +0000
> +++ b/linux/drivers/media/video/saa7134/saa7134-cards.c Thu Jul 30
> 12:26:05 2009 +0200
> @@ -5117,6 +5117,24 @@
>                         .gpio = 0x01,
>                 },
>         },
> +       [SAA7134_BOARD_MSI_TVATANYWHERE_SATELLITE_PRO] = {
> +               .name           = "MSI TV@nywhere Satellite Pro",
> +               .audio_clock    = 0x00200000,
> +               .tuner_type     = TUNER_ABSENT,
> +               .radio_type     = UNSET,
> +               .tuner_addr     = ADDR_UNSET,
> +               .radio_addr     = ADDR_UNSET,
> +               .mpeg           = SAA7134_MPEG_DVB,
> +               .inputs = {{
> +                       .name   = name_comp1,
> +                       .vmux   = 3,
> +                       .amux   = LINE1,
> +               }, {
> +                       .name   = name_svideo,
> +                       .vmux   = 8,
> +                       .amux   = LINE1,
> +               } },
> +       },
>         [SAA7134_BOARD_AVERMEDIA_STUDIO_507UA] = {
>                 /* Andy Shevchenko <andy@smile.org.ua> */
>                 .name           = "Avermedia AVerTV Studio 507UA",
> @@ -6256,6 +6274,12 @@
>                 .subvendor    = 0x17de,
>                 .subdevice    = 0x7128,
>                 .driver_data  = SAA7134_BOARD_KWORLD_PLUS_TV_ANALOG,
> +       }, {
> +               .vendor       = PCI_VENDOR_ID_PHILIPS,
> +               .device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
> +               .subvendor    = 0x1462,
> +               .subdevice    = 0x8811,
> +               .driver_data  = SAA7134_BOARD_MSI_TVATANYWHERE_SATELLITE_PRO,
>         }, {
>                 .vendor       = PCI_VENDOR_ID_PHILIPS,
>                 .device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
> @@ -6743,6 +6767,7 @@
>         case SAA7134_BOARD_PINNACLE_PCTV_310i:
>         case SAA7134_BOARD_UPMOST_PURPLE_TV:
>         case SAA7134_BOARD_MSI_TVATANYWHERE_PLUS:
> +       case SAA7134_BOARD_MSI_TVATANYWHERE_SATELLITE_PRO:
>         case SAA7134_BOARD_HAUPPAUGE_HVR1110:
>         case SAA7134_BOARD_BEHOLD_607FM_MK3:
>         case SAA7134_BOARD_BEHOLD_607FM_MK5:
> diff -r fd96af63f79b linux/drivers/media/video/saa7134/saa7134-dvb.c
> --- a/linux/drivers/media/video/saa7134/saa7134-dvb.c   Fri Jun 19
> 19:56:56 2009 +0000
> +++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c   Thu Jul 30
> 12:26:05 2009 +0200
> @@ -1191,6 +1191,20 @@
>                         }
>                 }
>                 break;
> +       case SAA7134_BOARD_MSI_TVATANYWHERE_SATELLITE_PRO:
> +               wprintk("MSI TV@nywhere Satellite Pro by roli\n");
> +                       fe0->dvb.frontend = dvb_attach(tda10086_attach,
> +                                               &flydvbs, &dev->i2c_adap);
> +                       if (fe0->dvb.frontend) {
> +                               if (dvb_attach(tda826x_attach,
> +                                               fe0->dvb.frontend, 0x60,
> +                                               &dev->i2c_adap, 0) == NULL) {
> +                                       wprintk("%s: MSI TV@nywhere
> Satellite Pro, no "
> +                                               "tda826x found!\n", __func__);
> +                                       goto dettach_frontend;
> +                               }
> +                       }
> +               break;
>         case SAA7134_BOARD_ADS_DUO_CARDBUS_PTV331:
>         case SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS:
>                 fe0->dvb.frontend = dvb_attach(tda10046_attach,
> diff -r fd96af63f79b linux/drivers/media/video/saa7134/saa7134.h
> --- a/linux/drivers/media/video/saa7134/saa7134.h       Fri Jun 19
> 19:56:56 2009 +0000
> +++ b/linux/drivers/media/video/saa7134/saa7134.h       Thu Jul 30
> 12:26:05 2009 +0200
> @@ -293,6 +293,7 @@
>  #define SAA7134_BOARD_BEHOLD_607RDS_MK5     166
>  #define SAA7134_BOARD_BEHOLD_609RDS_MK3     167
>  #define SAA7134_BOARD_BEHOLD_609RDS_MK5     168
> +#define SAA7134_BOARD_MSI_TVATANYWHERE_SATELLITE_PRO  169
> 
>  #define SAA7134_MAXBOARDS 32
>  #define SAA7134_INPUT_MAX 8
> -----------------------------------------------------------------------------------------------------------
> NrybXǧv^)޺{.n+{bj)w*jgݢj/zޖ2ޙ&)ߡaGhj:+vw٥

--=-GX+Fvrg5EHK2PYuQhDsu
Content-Disposition: inline; filename="saa7134_add_support_for_MSI-TV@nywhere-Satellite-Pro.patch"
Content-Type: text/x-patch; name="saa7134_add_support_for_MSI-TV@nywhere-Satellite-Pro.patch"; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -r 3f2dffde2429 linux/Documentation/video4linux/CARDLIST.saa7134
--- a/linux/Documentation/video4linux/CARDLIST.saa7134	Thu Jul 30 20:00:44 2009 -0300
+++ b/linux/Documentation/video4linux/CARDLIST.saa7134	Fri Jul 31 13:38:21 2009 +0200
@@ -167,3 +167,4 @@
 166 -> Beholder BeholdTV 607 RDS                [5ace:6073]
 167 -> Beholder BeholdTV 609 RDS                [5ace:6092]
 168 -> Beholder BeholdTV 609 RDS                [5ace:6093]
+169 -> MSI TV@nywhere Satellite Pro             [1462:8811]
diff -r 3f2dffde2429 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Jul 30 20:00:44 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Jul 31 13:38:21 2009 +0200
@@ -5155,6 +5155,25 @@
 			.gpio = 0x00,
 		},
 	},
+	[SAA7134_BOARD_MSI_TVATANYWHERE_SATELLITE_PRO] = {
+		/* Roland Schnabl <roland.schnabl@gmail.com> */
+		.name           = "MSI TV@nywhere Satellite Pro",
+		.audio_clock    = 0x00200000,
+		.tuner_type     = TUNER_ABSENT,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.mpeg           = SAA7134_MPEG_DVB,
+		.inputs = {{
+			.name   = name_comp1,
+			.vmux   = 3,
+			.amux   = LINE1,
+		}, {
+			.name   = name_svideo,
+			.vmux   = 8,
+			.amux   = LINE1,
+		} },
+	},
 };
 
 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -6262,7 +6281,12 @@
 		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
 		.subdevice    = 0xf31d,
 		.driver_data  = SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS,
-
+	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
+		.subvendor    = 0x1462,
+		.subdevice    = 0x8811,
+		.driver_data  = SAA7134_BOARD_MSI_TVATANYWHERE_SATELLITE_PRO,
 	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
diff -r 3f2dffde2429 linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Thu Jul 30 20:00:44 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Fri Jul 31 13:38:21 2009 +0200
@@ -1477,6 +1477,24 @@
 			}
 		}
 		break;
+	case SAA7134_BOARD_MSI_TVATANYWHERE_SATELLITE_PRO:
+		fe0->dvb.frontend = dvb_attach(tda10086_attach, &flydvbs,
+							&dev->i2c_adap);
+		if (fe0->dvb.frontend) {
+			if (dvb_attach(tda826x_attach, fe0->dvb.frontend, 0x60,
+					&dev->i2c_adap, 0) == NULL) {
+				wprintk("%s: MSI TV@nywhere Satellite Pro, no "
+						"tda826x found!\n", __func__);
+				goto dettach_frontend;
+			}
+			if (dvb_attach(isl6421_attach, fe0->dvb.frontend,
+					&dev->i2c_adap, 0x08, 0, 0) == NULL) {
+				wprintk("%s: MSI TV@nywhere Satellite Pro, no "
+						"isl6421 found!\n", __func__);
+				goto dettach_frontend;
+			}
+		}
+		break;
 	default:
 		wprintk("Huh? unknown DVB card?\n");
 		break;
diff -r 3f2dffde2429 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Thu Jul 30 20:00:44 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Fri Jul 31 13:38:21 2009 +0200
@@ -293,6 +293,7 @@
 #define SAA7134_BOARD_BEHOLD_607RDS_MK5     166
 #define SAA7134_BOARD_BEHOLD_609RDS_MK3     167
 #define SAA7134_BOARD_BEHOLD_609RDS_MK5     168
+#define SAA7134_BOARD_MSI_TVATANYWHERE_SATELLITE_PRO  169
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8

--=-GX+Fvrg5EHK2PYuQhDsu--

