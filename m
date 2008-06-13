Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5DIJWlO006851
	for <video4linux-list@redhat.com>; Fri, 13 Jun 2008 14:19:32 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5DIJ1un012440
	for <video4linux-list@redhat.com>; Fri, 13 Jun 2008 14:19:01 -0400
Date: Fri, 13 Jun 2008 15:18:43 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Zbynek Hrabovsky <hrabosh@t-email.cz>
Message-ID: <20080613151843.240a62cb@gaivota>
In-Reply-To: <20080207002224.e26d6bb1.hrabosh@t-email.cz>
References: <20080207002224.e26d6bb1.hrabosh@t-email.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Michel Lespinasse <walken@zoy.org>, Nicolas
	Marot <nicolas.marot@gmail.com>, linux-kernel@vger.kernel.org,
	nicolas <nicolas@nikoland.homelinux.org>
Subject: Re: [PATCH][RESEND] New type of DTV2000H TV Card
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


On Thu, 7 Feb 2008 00:22:24 +0100
Zbynek Hrabovsky <hrabosh@t-email.cz> wrote:

> 		Hello all,
> 
> I bought Leadtek WinFast DTV2000H, but it didn't work. I found, that there are two types of this card. Type I (older), and type J (latest) ... and only type I is supported by the module.
> 
> Type J is not autodetected, and if you force card type (card = 51), DVB-T works, but there is no sound in analogue television. I know why (multiplexer, which is switching between the radio, TV, and external sound is driven by GPIO pins ... and setting of this pins is wrong), and I wrote a patch, which makes this card (DTV2000H type J) works. 
> 
> With this patch, card is autodetected, I'm having sound in analogue television, I can switch between antenna, and cable signal input, and I can see video from external S-video and composite video input.
> 
> So ... I'm sending this patch to you. I think it will be good to add support for this card to the cx88xx module.
> 
> Bye,
> 	Zbynek Hrabovsky, Brno, Czech Republic
> 
> PS .. sorry for my English.

Hi Zbynek,

Sorry for not answering earlier. Your patch got lost on my inbox. As Nicolas
pointed it to me, I've took a look on it. It seems sane. 

Yet, a few style corrections were needed. Also, the patch doesn't apply
anymore, since board 57 is already defined.

Generally, I would ask you to check it, using checkpatch.pl and fix the issues.
But, as this patch is old, I decided to fix it and resubmit for you to check
and test it.

Please let me know if everything is ok for me to commit it and send upstream.
Also, please send your Signed-off-by:

Nicolas,

It would be nice if you can review the patch and send us a reviewed-by: line.

Cheers,
Mauro

---

From: Zbynek Hrabovsky <hrabosh@t-email.cz>

I bought Leadtek WinFast DTV2000H, but it didn't work. I found, that there are
two types of this card. Type I (older), and type J (latest) ... and only type I
is supported by the module.

Type J is not autodetected, and if you force card type (card = 51), DVB-T
works, but there is no sound in analogue television. I know why (multiplexer,
which is switching between the radio, TV, and external sound is driven by GPIO
pins ... and setting of this pins is wrong), and I wrote a patch, which makes
this card (DTV2000H type J) works.

With this patch, card is autodetected, I'm having sound in analogue television,
I can switch between antenna, and cable signal input, and I can see video from
external S-video and composite video input.

So ... I'm sending this patch to you. I think it will be good to add support
for this card to the cx88xx module.

Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>

diff -r 04ddbe145932 linux/drivers/media/video/cx88/cx88-cards.c
--- a/linux/drivers/media/video/cx88/cx88-cards.c	Tue Jun 10 15:27:29 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-cards.c	Fri Jun 13 15:07:33 2008 -0300
@@ -1284,7 +1284,7 @@
 	},
 	[CX88_BOARD_WINFAST_DTV2000H] = {
 		/* video inputs and radio still in testing */
-		.name           = "WinFast DTV2000 H",
+		.name           = "WinFast DTV2000 H ver. I (old)",
 		.tuner_type     = TUNER_PHILIPS_FMD1216ME_MK3,
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
@@ -1298,6 +1298,45 @@
 			.gpio2  = 0x00017304,
 			.gpio3  = 0x02000000,
 		}},
+		.mpeg           = CX88_MPEG_DVB,
+	},
+	[CX88_BOARD_WINFAST_DTV2000H_2] = {
+		/* this is just a try */
+		.name           = "WinFast DTV2000 H ver. J (new)",
+		.tuner_type     = TUNER_PHILIPS_FMD1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.input          = { {
+			.type   = CX88_VMUX_TELEVISION,
+			.vmux   = 0,
+			.gpio0  = 0x00017300,
+			.gpio1  = 0x00008207,
+			.gpio2	= 0x00000000,
+			.gpio3  = 0x02000000,
+		}, {
+			.type   = CX88_VMUX_TELEVISION,
+			.vmux   = 0,
+			.gpio0  = 0x00018300,
+			.gpio1  = 0x0000f207,
+			.gpio2	= 0x00017304,
+			.gpio3  = 0x02000000,
+		}, {
+			.type   = CX88_VMUX_COMPOSITE1,
+			.vmux   = 1,
+			.gpio0  = 0x00018301,
+			.gpio1  = 0x0000f207,
+			.gpio2	= 0x00017304,
+			.gpio3  = 0x02000000,
+		}, {
+			.type   = CX88_VMUX_SVIDEO,
+			.vmux   = 2,
+			.gpio0  = 0x00018301,
+			.gpio1  = 0x0000f207,
+			.gpio2	= 0x00017304,
+			.gpio3  = 0x02000000,
+		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
 	[CX88_BOARD_GENIATECH_DVBS] = {
@@ -1963,6 +2002,10 @@
 		.subdevice = 0x665e,
 		.card      = CX88_BOARD_WINFAST_DTV2000H,
 	},{
+		.subvendor = 0x107d,
+		.subdevice = 0x6f2b,
+		.card      = CX88_BOARD_WINFAST_DTV2000H_2,
+	}, {
 		.subvendor = 0x18ac,
 		.subdevice = 0xd800, /* FusionHDTV 3 Gold (original revision) */
 		.card      = CX88_BOARD_DVICO_FUSIONHDTV_3_GOLD_Q,
diff -r 04ddbe145932 linux/drivers/media/video/cx88/cx88-dvb.c
--- a/linux/drivers/media/video/cx88/cx88-dvb.c	Tue Jun 10 15:27:29 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-dvb.c	Fri Jun 13 15:07:34 2008 -0300
@@ -561,6 +561,7 @@
 		}
 		break;
 	case CX88_BOARD_WINFAST_DTV2000H:
+	case CX88_BOARD_WINFAST_DTV2000H_2:
 	case CX88_BOARD_HAUPPAUGE_HVR1100:
 	case CX88_BOARD_HAUPPAUGE_HVR1100LP:
 	case CX88_BOARD_HAUPPAUGE_HVR1300:
diff -r 04ddbe145932 linux/drivers/media/video/cx88/cx88-input.c
--- a/linux/drivers/media/video/cx88/cx88-input.c	Tue Jun 10 15:27:29 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-input.c	Fri Jun 13 15:07:34 2008 -0300
@@ -242,6 +242,7 @@
 		ir->sampling = 1;
 		break;
 	case CX88_BOARD_WINFAST_DTV2000H:
+	case CX88_BOARD_WINFAST_DTV2000H_2:
 		ir_codes = ir_codes_winfast;
 		ir->gpio_addr = MO_GP0_IO;
 		ir->mask_keycode = 0x8f8;
diff -r 04ddbe145932 linux/drivers/media/video/cx88/cx88-mpeg.c
--- a/linux/drivers/media/video/cx88/cx88-mpeg.c	Tue Jun 10 15:27:29 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88-mpeg.c	Fri Jun 13 15:07:34 2008 -0300
@@ -148,6 +148,12 @@
 			cx_write(TS_SOP_STAT, 0);
 			cx_write(TS_VALERR_CNTRL, 0);
 			udelay(100);
+			break;
+		case CX88_BOARD_WINFAST_DTV2000H_2:
+			/* switch signal input to antena */
+			cx_write(MO_GP0_IO, 0x00017300);
+
+			cx_write(TS_SOP_STAT, 0x00);
 			break;
 		default:
 			cx_write(TS_SOP_STAT, 0x00);
diff -r 04ddbe145932 linux/drivers/media/video/cx88/cx88.h
--- a/linux/drivers/media/video/cx88/cx88.h	Tue Jun 10 15:27:29 2008 -0300
+++ b/linux/drivers/media/video/cx88/cx88.h	Fri Jun 13 15:07:34 2008 -0300
@@ -224,6 +224,7 @@
 #define CX88_BOARD_DVICO_FUSIONHDTV_7_GOLD 65
 #define CX88_BOARD_PROLINK_PV_8000GT       66
 #define CX88_BOARD_KWORLD_ATSC_120         67
+#define CX88_BOARD_WINFAST_DTV2000H_2      68
 
 enum cx88_itype {
 	CX88_VMUX_COMPOSITE1 = 1,

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
