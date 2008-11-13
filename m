Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAD1KUd7025405
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 20:20:30 -0500
Received: from mail-in-11.arcor-online.net (mail-in-11.arcor-online.net
	[151.189.21.51])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAD1KEDc007956
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 20:20:15 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Dirk Heer <D.Heer@phytec.de>, Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <OF45DBB1DF.D820068E-ONC12574FD.002E8F63-C12574FD.00310D0D@phytec.de>
References: <OF45DBB1DF.D820068E-ONC12574FD.002E8F63-C12574FD.00310D0D@phytec.de>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 13 Nov 2008 02:17:57 +0100
Message-Id: <1226539077.3996.36.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] bttv
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

Hi Dirk,

Am Montag, den 10.11.2008, 09:55 +0100 schrieb Dirk Heer:
> Hello,
> 
> hear i have a patch for v4l. 
> I hope someone can put them into the Kernel.
> 

always post a copy directly to Mauro too, if you think a patch is ready
for bttv. Done now.

Only posted to the list it can get lost for review.

Inline you have some broken lines and the attachment should have better
a .patch format to enable preview in mail clients.

Else it looks OK, except of a new empty line in bttv.h,
but did not try to apply it yet and no further checks.

Might be a start if Mauro finds some time.
Consider to use "hg diff > my.patch" with "mercurial" installed.

Cheers,
Hermann


> **************************************************************************************************************************************
> 
> 
> From:
> Dirk Heer
> Phytec Messtechnik GmbH
> Email: d.heer@phytec.de
> http://www.phytec.de
> 
> This Patch does modify the bttv-cards.c and bttc.h so that the driver 
> supports VD-011, VD-012, VD-012-X1 and VD-012-X2 Framegrabber from Phytec 
> Messtechnik GmbH.
> 
> Priority: normal
> 
> Signed-off-by: Dirk Heer <d.heer@phytec.de>
> 
> diff -u -r 
> v4l-dvb-8486cbf6af4e/linux/drivers/media/video/bt8xx/bttv-cards.c 
> v4l-dvb-8486cbf6af4e_patched//linux/drivers/media/video/bt8xx/bttv-cards.c
> --- v4l-dvb-8486cbf6af4e/linux/drivers/media/video/bt8xx/bttv-cards.c 
> 2008-10-27 00:25:21.000000000 +0100
> +++ 
> v4l-dvb-8486cbf6af4e_patched//linux/drivers/media/video/bt8xx/bttv-cards.c 
> 2008-10-28 13:09:15.000000000 +0100
> @@ -2240,9 +2240,9 @@
>                 .tuner_addr     = ADDR_UNSET,
>                 .radio_addr     = ADDR_UNSET,
>         },
> -       [BTTV_BOARD_VD009X1_MINIDIN] = {
> +       [BTTV_BOARD_VD009X1_VD011_MINIDIN] = {
>                 /* M.Klahr@phytec.de */
> -               .name           = "PHYTEC VD-009-X1 MiniDIN (bt878)",
> +               .name           = "PHYTEC VD-009-X1 VD-011 MiniDIN 
> (bt878)",
>                 .video_inputs   = 4,
>                 .audio_inputs   = 0,
>                 .tuner          = UNSET, /* card has no tuner */
> @@ -2250,14 +2250,14 @@
>                 .gpiomask       = 0x00,
>                 .muxsel         = { 2, 3, 1, 0 },
>                 .gpiomux        = { 0, 0, 0, 0 }, /* card has no audio */
> -               .needs_tvaudio  = 1,
> +               .needs_tvaudio  = 0,
>                 .pll            = PLL_28,
>                 .tuner_type     = UNSET,
>                 .tuner_addr     = ADDR_UNSET,
>                 .radio_addr     = ADDR_UNSET,
>         },
> -       [BTTV_BOARD_VD009X1_COMBI] = {
> -               .name           = "PHYTEC VD-009-X1 Combi (bt878)",
> +       [BTTV_BOARD_VD009X1_VD011_COMBI] = {
> +               .name           = "PHYTEC VD-009-X1 VD-011 Combi (bt878)",
>                 .video_inputs   = 4,
>                 .audio_inputs   = 0,
>                 .tuner          = UNSET, /* card has no tuner */
> @@ -2265,7 +2265,7 @@
>                 .gpiomask       = 0x00,
>                 .muxsel         = { 2, 3, 1, 1 },
>                 .gpiomux        = { 0, 0, 0, 0 }, /* card has no audio */
> -               .needs_tvaudio  = 1,
> +               .needs_tvaudio  = 0,
>                 .pll            = PLL_28,
>                 .tuner_type     = UNSET,
>                 .tuner_addr     = ADDR_UNSET,
> @@ -3093,6 +3093,54 @@
>                 .pll            = PLL_28,
>                 .has_radio      = 1,
>                 .has_remote     = 1,
> +       },
> +               [BTTV_BOARD_VD012] = {
> +               /* D.Heer@Phytec.de */
> +               .name           = "PHYTEC VD-012 (bt878)",
> +               .video_inputs   = 4,
> +               .audio_inputs   = 0,
> +               .tuner          = UNSET, /* card has no tuner */
> +               .svhs           = UNSET, /* card has no s-video */
> +               .gpiomask       = 0x00,
> +               .muxsel         = { 0, 2, 3, 1 },
> +               .gpiomux        = { 0, 0, 0, 0 }, /* card has no audio */
> +               .needs_tvaudio  = 0,
> +               .pll            = PLL_28,
> +               .tuner_type     = UNSET,
> +               .tuner_addr     = ADDR_UNSET,
> +               .radio_addr     = ADDR_UNSET,
> +       },
> +               [BTTV_BOARD_VD012_X1] = {
> +               /* D.Heer@Phytec.de */
> +               .name           = "PHYTEC VD-012-X1 (bt878)",
> +               .video_inputs   = 4,
> +               .audio_inputs   = 0,
> +               .tuner          = UNSET, /* card has no tuner */
> +               .svhs           = 3,
> +               .gpiomask       = 0x00,
> +               .muxsel         = { 2, 3, 1 },
> +               .gpiomux        = { 0, 0, 0, 0 }, /* card has no audio */
> +               .needs_tvaudio  = 0,
> +               .pll            = PLL_28,
> +               .tuner_type     = UNSET,
> +               .tuner_addr     = ADDR_UNSET,
> +               .radio_addr     = ADDR_UNSET,
> +       },
> +               [BTTV_BOARD_VD012_X2] = {
> +               /* D.Heer@Phytec.de */
> +               .name           = "PHYTEC VD-012-X2 (bt878)",
> +               .video_inputs   = 4,
> +               .audio_inputs   = 0,
> +               .tuner          = UNSET, /* card has no tuner */
> +               .svhs           = 3,
> +               .gpiomask       = 0x00,
> +               .muxsel         = { 3, 2, 1 },
> +               .gpiomux        = { 0, 0, 0, 0 }, /* card has no audio */
> +               .needs_tvaudio  = 0,
> +               .pll            = PLL_28,
> +               .tuner_type     = UNSET,
> +               .tuner_addr     = ADDR_UNSET,
> +               .radio_addr     = ADDR_UNSET,
>         }
>  };
>  
> diff -u -r v4l-dvb-8486cbf6af4e/linux/drivers/media/video/bt8xx/bttv.h 
> v4l-dvb-8486cbf6af4e_patched//linux/drivers/media/video/bt8xx/bttv.h
> --- v4l-dvb-8486cbf6af4e/linux/drivers/media/video/bt8xx/bttv.h 2008-10-27 
> 00:25:21.000000000 +0100
> +++ v4l-dvb-8486cbf6af4e_patched//linux/drivers/media/video/bt8xx/bttv.h 
> 2008-10-28 12:35:44.000000000 +0100
> @@ -131,8 +131,8 @@
>  #define BTTV_BOARD_XGUARD                  0x67
>  #define BTTV_BOARD_NEBULA_DIGITV           0x68
>  #define BTTV_BOARD_PV143                   0x69
> -#define BTTV_BOARD_VD009X1_MINIDIN         0x6a
> -#define BTTV_BOARD_VD009X1_COMBI           0x6b
> +#define BTTV_BOARD_VD009X1_VD011_MINIDIN   0x6a
> +#define BTTV_BOARD_VD009X1_VD011_COMBI     0x6b
>  #define BTTV_BOARD_VD009_MINIDIN           0x6c
>  #define BTTV_BOARD_VD009_COMBI             0x6d
>  #define BTTV_BOARD_IVC100                  0x6e
> @@ -178,6 +178,10 @@
>  #define BTTV_BOARD_GEOVISION_GV600        0x96
>  #define BTTV_BOARD_KOZUMI_KTV_01C          0x97
>  #define BTTV_BOARD_ENLTV_FM_2             0x98
> +#define BTTV_BOARD_VD012                  0x99
> +#define BTTV_BOARD_VD012_X1               0x9a
> +#define BTTV_BOARD_VD012_X2               0x9b
> +
>  
>  /* more card-specific defines */
>  #define PT2254_L_CHANNEL 0x10
> Nur in v4l-dvb-8486cbf6af4e_patched/: phytec_bttv_patch.
> Nur in v4l-dvb-8486cbf6af4e_patched//v4l: .config.
> Nur in v4l-dvb-8486cbf6af4e_patched//v4l: Kconfig.
> Nur in v4l-dvb-8486cbf6af4e_patched//v4l: .kconfig.dep.
> Nur in v4l-dvb-8486cbf6af4e_patched//v4l: Kconfig.kern.
> Nur in v4l-dvb-8486cbf6af4e_patched//v4l: Makefile.media.
> Nur in v4l-dvb-8486cbf6af4e_patched//v4l: modules.order.
> Nur in v4l-dvb-8486cbf6af4e_patched//v4l: .myconfig.
> Nur in v4l-dvb-8486cbf6af4e_patched//v4l: oss.
> Nur in v4l-dvb-8486cbf6af4e_patched//v4l: .tmp_versions.
> Nur in v4l-dvb-8486cbf6af4e_patched//v4l: .version.
> 
> 
> 
> 
> **************************************************************************************************************************************
> 
> 
> 
> 
> 
> 
> Yours faithfully / Mit freundlichen Grüßen
> 
> Dipl.-Ing. (FH) Dirk Heer
> 
> 
> ++++++++++++++++++++++++++
> PHYTEC Messtechnik GmbH
> Abteilung Bildverarbeitung
> Robert-Koch-Str. 39
> D-55129 Mainz
> 
> Tel:   +49 (6131) / 9221-0
> Fax:  +49 (6131) / 9221-33
> 
> E-Mail: d.heer@phytec.de
> Internet: http://www.phytec.de
> 
> Handelsregister Mainz HRB 4656
> Geschäftsführer: Dipl.-Ing. Michael Mitezki
> +++++++++++++++++++++++++
> 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
