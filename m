Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m38FYGef006322
	for <video4linux-list@redhat.com>; Tue, 8 Apr 2008 11:34:16 -0400
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m38FY21v030761
	for <video4linux-list@redhat.com>; Tue, 8 Apr 2008 11:34:03 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-dvb@linuxtv.org
Date: Tue, 8 Apr 2008 17:33:54 +0200
References: <617be8890804080606y23bc62b7j7495a37c039bd3d6@mail.gmail.com>
In-Reply-To: <617be8890804080606y23bc62b7j7495a37c039bd3d6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_iB5+HvPsmFN33xx"
Message-Id: <200804081733.54539.zzam@gentoo.org>
Cc: video4linux-list@redhat.com, Eduard Huguet <eduardhc@gmail.com>
Subject: Re: [linux-dvb] Any progress on the AverMedia A700 (DVB-S Pro)?
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

--Boundary-00=_iB5+HvPsmFN33xx
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Dienstag, 8. April 2008, Eduard Huguet wrote:
> Hi,
>     Things are very quiet lately regarding this card. Is there any
> possibility that the card gets supported in any near future? I know
> Matthias  Schwarzot had been working on it, but there's no messages from
> him lately on the list.
>
> Best regards,
>   Eduard

I did not made any progress since last time we corresponded.

But: I think we agree that the patch that only adds composite and s-video 
support works.
So we could request pulling it into v4l-dvb repository.

Regards
Matthias

-- 
Matthias Schwarzott (zzam)

--Boundary-00=_iB5+HvPsmFN33xx
Content-Type: text/x-diff; charset="iso-8859-15";
	name="avertv_A700_analog_part.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="avertv_A700_analog_part.diff"

saa7134: add analog support for Avermedia A700 cards

Add support for composite and s-video inputs on
Avermedia DVB-S Pro and DVB-S Hybrid+FM cards
(both labled A700) to the saa7134 driver.

XC2028 support for Hybrid+FM is still missing.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>

Index: v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134-cards.c
+++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c
@@ -4210,7 +4210,47 @@ struct saa7134_board saa7134_boards[] = 
 			.name = name_radio,
 			.amux = TV,
 		}
-	}
+	},
+	[SAA7134_BOARD_AVERMEDIA_A700_PRO] = {
+		/* Matthias Schwarzott <zzam@gentoo.org> */
+		.name           = "Avermedia DVB-S Pro A700",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_ABSENT,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		/* no DVB support for now */
+		/* .mpeg           = SAA7134_MPEG_DVB, */
+		.inputs         = {{
+			.name = name_comp,
+			.vmux = 1,
+			.amux = LINE1,
+		}, {
+			.name = name_svideo,
+			.vmux = 6,
+			.amux = LINE1,
+		}},
+	},
+	[SAA7134_BOARD_AVERMEDIA_A700_HYBRID] = {
+		/* Matthias Schwarzott <zzam@gentoo.org> */
+		.name           = "Avermedia DVB-S Hybrid+FM A700",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_ABSENT, /* TUNER_XC2028 */
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		/* no DVB support for now */
+		/* .mpeg           = SAA7134_MPEG_DVB, */
+		.inputs         = {{
+			.name = name_comp,
+			.vmux = 1,
+			.amux = LINE1,
+		}, {
+			.name = name_svideo,
+			.vmux = 6,
+			.amux = LINE1,
+		}},
+	},
 };
 
 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -4443,6 +4483,18 @@ struct pci_device_id saa7134_pci_tbl[] =
 		.driver_data  = SAA7134_BOARD_MD2819,
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
+		.subdevice    = 0xa7a1,
+		.driver_data  = SAA7134_BOARD_AVERMEDIA_A700_PRO,
+	},{
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
+		.subdevice    = 0xa7a2,
+		.driver_data  = SAA7134_BOARD_AVERMEDIA_A700_HYBRID,
+	},{
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
 		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
 		.subdevice    = 0x2115,
@@ -5567,6 +5619,15 @@ int saa7134_board_init1(struct saa7134_d
 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x8c040007, 0x8c040007);
 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x0c0007cd, 0x0c0007cd);
 		break;
+	case SAA7134_BOARD_AVERMEDIA_A700_PRO:
+	case SAA7134_BOARD_AVERMEDIA_A700_HYBRID:
+		/* write windows gpio values */
+		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x80040100, 0x80040100);
+		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x80040100, 0x00040100);
+		printk("%s: %s: hybrid analog/dvb card\n"
+		       "%s: Sorry, only the analog inputs are supported for now.\n",
+			dev->name,card(dev).name, dev->name);
+		break;
 	}
 	return 0;
 }
Index: v4l-dvb/linux/drivers/media/video/saa7134/saa7134.h
===================================================================
--- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134.h
+++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134.h
@@ -268,6 +268,8 @@ struct saa7134_format {
 #define SAA7134_BOARD_AVERMEDIA_A16D       137
 #define SAA7134_BOARD_AVERMEDIA_M115       138
 #define SAA7134_BOARD_VIDEOMATE_T750       139
+#define SAA7134_BOARD_AVERMEDIA_A700_PRO    140
+#define SAA7134_BOARD_AVERMEDIA_A700_HYBRID 141
 
 
 #define SAA7134_MAXBOARDS 8
Index: v4l-dvb/linux/Documentation/video4linux/CARDLIST.saa7134
===================================================================
--- v4l-dvb.orig/linux/Documentation/video4linux/CARDLIST.saa7134
+++ v4l-dvb/linux/Documentation/video4linux/CARDLIST.saa7134
@@ -138,3 +138,5 @@
 137 -> AVerMedia Hybrid TV/Radio (A16D)         [1461:f936]
 138 -> Avermedia M115                           [1461:a836]
 139 -> Compro VideoMate T750                    [185b:c900]
+140 -> Avermedia DVB-S Pro A700                 [1461:a7a1]
+141 -> Avermedia DVB-S Hybrid+FM A700           [1461:a7a2]

--Boundary-00=_iB5+HvPsmFN33xx
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--Boundary-00=_iB5+HvPsmFN33xx--
