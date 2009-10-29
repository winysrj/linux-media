Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:48509
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbZJ2PD3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2009 11:03:29 -0400
Subject: Re: [PATCH]
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <4AE9ABE6.90706@gmail.com>
Date: Thu, 29 Oct 2009 11:03:28 -0400
Cc: linux-media@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <45AE5B2F-A7C9-4274-846C-467D24B0C140@wilsonet.com>
References: <4AE9ABE6.90706@gmail.com>
To: flinkdeldinky <flinkdeldinky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Oct 29, 2009, at 10:51 AM, flinkdeldinky wrote:

> The following patch provides functionality for the STLabs PCI card.
> It's a saa7134 card.

The patch is also horribly mangled by line-wrapping. Please resubmit  
it without the line wrapping, and with a useful subject.


> I may be the only guy still using it!  I've been
> compiling it the code for each kernel I use for years now.
>
> Iif you guys accept this patch you may want to add the following
> documentation somewhere (I don't know where to put it):
> This card is auto detected as a 10 MOONS card, that doesn't work  
> though.
>
> I load saa7134 as follows:
> saa7134 card=175 tuner=5
>
> Everything on the card seems to function and that includes the  
> firewire
> port.  I don't know about the remote control though.
>
> Tuners 3, 5, 14, 20, 28, 29, 24, 48 seem to work equally well. Those  
> are
> all
> the PAL BG tuners. I spot checked several non PAL BG tuners and none  
> worked.
>
>
> diff -r d6c09c3711b5
> linux/drivers/media/video/saa7134/saa7134-cards.c
> --- a/linux/drivers/media/video/saa7134/saa7134-cards.c Sun Sep 20
> 15:14:21 2009
> +0000
>
> +++ b/linux/drivers/media/video/saa7134/saa7134-cards.c Thu Oct 29
> 14:54:31 2009
> +0700
>
> @@ -5342,7 +5342,38
> @@
>                        .amux   =
> LINE2,
>                }
> },
>
> },
> -
>
> +       [SAA7134_BOARD_STLAB_PCI_TV7130] =
> {
> +       /* "Aidan Gill"
> */
> +               .name = "ST Lab ST Lab PCI-TV7130
> ",
> +               .audio_clock =
> 0x00200000,
> +               .tuner_type =
> TUNER_LG_PAL_NEW_TAPC,
> +               .radio_type     =
> UNSET,
> +               .tuner_addr     =
> ADDR_UNSET,
> +               .radio_addr     =
> ADDR_UNSET,
> +               .gpiomask =
> 0x7000,
> +               .inputs =
> {{
> +                       .name =
> name_tv,
> +                       .vmux =
> 1,
> +                       .amux =
> LINE2,
> +                       .gpio =
> 0x0000,
> +                       .tv =
> 1,
> +               },
> {
> +                       .name =
> name_comp1,
> +                       .vmux =
> 3,
> +                       .amux =
> LINE1,
> +                       .gpio =
> 0x2000,
> +               },
> {
> +                       .name =
> name_svideo,
> +                       .vmux =
> 0,
> +                       .amux =
> LINE1,
> +                       .gpio =
> 0x2000,
> +               }
> },
> +               .mute =
> {
> +                       .name =
> name_mute,
> +                       .amux =
> TV,
> +                       .gpio =
> 0x3000,
> +
> },
> +
> },
> };
>
>
>
> const unsigned int saa7134_bcount =
> ARRAY_SIZE(saa7134_boards);
> @@ -6487,6 +6518,12
> @@
>                .subdevice    =
> 0x4847,
>                .driver_data  =
> SAA7134_BOARD_ASUS_EUROPA_HYBRID,
>        },
> {
> +               .vendor       =
> PCI_VENDOR_ID_PHILIPS,
> +               .device       =
> PCI_DEVICE_ID_PHILIPS_SAA7130,
> +               .subvendor    =
> PCI_VENDOR_ID_PHILIPS,
> +               .subdevice    = 0x2001,
> +               .driver_data  = SAA7134_BOARD_STLAB_PCI_TV7130,
> +       }, {
>                /* --- boards without eeprom + subsystem ID --- */
>                .vendor       = PCI_VENDOR_ID_PHILIPS,
>                .device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
> diff -r d6c09c3711b5 linux/drivers/media/video/saa7134/saa7134.h
> --- a/linux/drivers/media/video/saa7134/saa7134.h       Sun Sep 20
> 15:14:21 2009 +0000
> +++ b/linux/drivers/media/video/saa7134/saa7134.h       Thu Oct 29
> 14:54:31 2009 +0700
> @@ -299,6 +299,7 @@
> #define SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM 172
> #define SAA7134_BOARD_ZOLID_HYBRID_PCI         173
> #define SAA7134_BOARD_ASUS_EUROPA_HYBRID       174
> +#define SAA7134_BOARD_STLAB_PCI_TV7130         175
>
> #define SAA7134_MAXBOARDS 32
> #define SAA7134_INPUT_MAX 8
>
> Signed-off-by: Michael Wellman <flinkdeldinky@gmail.com>

-- 
Jarod Wilson
jarod@wilsonet.com



