Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:56103 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaBGS36 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Feb 2014 13:29:58 -0500
Received: by mail-ee0-f52.google.com with SMTP id e53so1711303eek.11
        for <linux-media@vger.kernel.org>; Fri, 07 Feb 2014 10:29:56 -0800 (PST)
Received: from [192.168.1.100] ([188.24.80.42])
        by mx.google.com with ESMTPSA id b41sm19392341eef.16.2014.02.07.10.29.54
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 07 Feb 2014 10:29:55 -0800 (PST)
Message-ID: <52F52621.2010602@gmail.com>
Date: Fri, 07 Feb 2014 20:29:53 +0200
From: GEORGE <geoubuntu@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] bttv: Add support for Kworld V-Stream Xpert TV PVR878
References: <52F51E41.7000000@gmail.com>
In-Reply-To: <52F51E41.7000000@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 07.02.2014 19:56, GEORGE wrote:
> From 27c5541a93bee007d41a70b393c97ea19c62ace2 Mon Sep 17 00:00:00 2001
> From: POJAR GEORGE <geoubuntu@gmail.com>
> Date: Fri, 7 Feb 2014 19:34:41 +0200
> Subject: [PATCH] bttv: Add support for Kworld V-Stream Xpert TV PVR878
>
> Signed-off-by: POJAR GEORGE <geoubuntu@gmail.com>
> ---
>  Documentation/video4linux/CARDLIST.bttv |  1 +
>  drivers/media/video/bt8xx/bttv-cards.c  | 16 ++++++++++++++++
>  drivers/media/video/bt8xx/bttv-input.c  |  1 +
>  drivers/media/video/bt8xx/bttv.h        |  1 +
>  4 files changed, 19 insertions(+)
>
> diff --git a/Documentation/video4linux/CARDLIST.bttv 
> b/Documentation/video4linux/CARDLIST.bttv
> index 4739d56..0103fe4 100644
> --- a/Documentation/video4linux/CARDLIST.bttv
> +++ b/Documentation/video4linux/CARDLIST.bttv
> @@ -158,3 +158,4 @@
>  157 -> Geovision GV-800(S) (master) [800a:763d]
>  158 -> Geovision GV-800(S) (slave) [800b:763d,800c:763d,800d:763d]
>  159 -> ProVideo PV183 
> [1830:1540,1831:1540,1832:1540,1833:1540,1834:1540,1835:1540,1836:1540,1837:1540]
> +160 -> Kworld V-Stream Xpert TV PVR878
> diff --git a/drivers/media/video/bt8xx/bttv-cards.c 
> b/drivers/media/video/bt8xx/bttv-cards.c
> index 49efcf6..7e02b8e 100644
> --- a/drivers/media/video/bt8xx/bttv-cards.c
> +++ b/drivers/media/video/bt8xx/bttv-cards.c
> @@ -2916,6 +2916,22 @@ struct tvcard bttv_tvcards[] = {
>          .tuner_type     = TUNER_ABSENT,
>          .tuner_addr    = ADDR_UNSET,
>      },
> +    [BTTV_BOARD_KWORLD_VSTREAM_XPERT] = {
> +        /* POJAR GEORGE <geoubuntu@gmail.com> */
> +        .name           = "Kworld V-Stream Xpert TV PVR878",
> +        .video_inputs   = 3,
> +        /* .audio_inputs= 1, */
> +        .svhs           = 2,
> +        .gpiomask       = 0x001c0007,
> +        .muxsel         = MUXSEL(2, 3, 1, 1),
> +        .gpiomux        = { 0, 1, 2, 2 },
> +        .gpiomute     = 3,
> +        .pll            = PLL_28,
> +        .tuner_type     = TUNER_TENA_9533_DI,
> +        .tuner_addr    = ADDR_UNSET,
> +        .has_remote     = 1,
> +        .has_radio      = 1,
> +    },
>  };
>
>  static const unsigned int bttv_num_tvcards = ARRAY_SIZE(bttv_tvcards);
> diff --git a/drivers/media/video/bt8xx/bttv-input.c 
> b/drivers/media/video/bt8xx/bttv-input.c
> index 6bf05a7..3af1e23 100644
> --- a/drivers/media/video/bt8xx/bttv-input.c
> +++ b/drivers/media/video/bt8xx/bttv-input.c
> @@ -391,6 +391,7 @@ int bttv_input_init(struct bttv *btv)
>      case BTTV_BOARD_ASKEY_CPH03X:
>      case BTTV_BOARD_CONCEPTRONIC_CTVFMI2:
>      case BTTV_BOARD_CONTVFMI:
> +    case BTTV_BOARD_KWORLD_VSTREAM_XPERT:
>          ir_codes         = RC_MAP_PIXELVIEW;
>          ir->mask_keycode = 0x001F00;
>          ir->mask_keyup   = 0x006000;
> diff --git a/drivers/media/video/bt8xx/bttv.h 
> b/drivers/media/video/bt8xx/bttv.h
> index 6fd2a8e..dd926d8 100644
> --- a/drivers/media/video/bt8xx/bttv.h
> +++ b/drivers/media/video/bt8xx/bttv.h
> @@ -184,6 +184,7 @@
>  #define BTTV_BOARD_GEOVISION_GV800S       0x9d
>  #define BTTV_BOARD_GEOVISION_GV800S_SL       0x9e
>  #define BTTV_BOARD_PV183                   0x9f
> +#define BTTV_BOARD_KWORLD_VSTREAM_XPERT    0xa0
>
>
>  /* more card-specific defines */
> Update with INFO about this card
>
> I have a tuner Kworld Xpert TV-PVR 878 [PCI, FM radio, BG + DK, conexant
> 878a].
>
> When I try with options for card:
>
> 78 Jetway TV/Capture JW-TV878-FBK, Kworld KW-TV878RF   [0a01:17de],
>
> can't find any channels, radio and remote not work, so I use btspy to make
> a report:
>
>
> General information:
>
> Name:kworld 878a
> Chip: Bt878 , Rev: 0x00
> Subsystem: 0x00000000
> Vendor: Gammagraphx, Inc.
>
> Values to MUTE audio:
> Mute_GPOE : 0x1c0007
> Mute_GPDATA: 0x000001
> Has TV Tuner: Yes
> TV_Mux : 2
> TV_GPOE : 0x1c0007
> TV_GPDATA: 0x080000
> Number of Composite Ins: 1
> Composite in 1
> Composite1_Mux : 3
> Composite1_GPOE : 0x1c0007
> Composite1_GPDATA: 0x000002
> Has SVideo: Yes
> SVideo_Mux : 1
> SVideo_GPOE : 0x1c0007
> SVideo_GPDATA: 0x000002
> Has Radio: Yes
> Radio_GPOE : 0x1c0007
> Radio_GPDATA: 0x000001
>
>
> and put this configuration:
>
> options bttv card=78 tuner=38 gpiomask=0x1c0007
> audiomux=0x080000,0x000001,0x080000,0x080000,0x000001
>
> With this configuration TV, radio and remote work fine.
>
> So I make above patch to add full support for this card.
>
> from.inf file:
>
> Device ID List
>
> ID Number     Device
>
> 0x350         Bt848
> 0x351         Bt849
> 0x36E         Bt878 (Video Section)
> 0x36F         Bt879 (Video Section)
> 0x370         Bt880 (Video Section)
> 0x878         Bt878 (Audio Section)
> 0x879         Bt879 (Audio Section)
> 0x880         Bt880 (Audio Section)
>
> with EEPROM
>
> BT848.VideoDeviceDesc=BT848.PhilipsNTSC,
> PCI\VEN_109E&DEV_036E&SUBSYS_087817DE
> BT848.VideoDeviceDesc=BT848.PhilipsPAL,
> PCI\VEN_109E&DEV_036E&SUBSYS_087917DE
> BT848.VideoDeviceDesc=BT848.Philips4in1,
> PCI\VEN_109E&DEV_036E&SUBSYS_087A17DE
> BT848.VideoDeviceDesc=BT848.PhilTN5533,
> PCI\VEN_109E&DEV_036E&SUBSYS_087B17DE
> BT848.VideoDeviceDesc=BT848.PhilTN9533,
> PCI\VEN_109E&DEV_036E&SUBSYS_087C17DE
>
> without EEPROM
>
> BT848.VideoDeviceDesc=BT848.PhilipsNTSC,    PCI\VEN_109E&DEV_036E
> BT848.VideoDeviceDesc=BT848.PhilipsNTSC,
> PCI\VEN_109E&DEV_036E&SUBSYS_FFFFFFFF



