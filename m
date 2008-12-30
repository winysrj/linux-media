Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBUCQMG2013398
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 07:26:22 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBUCQ9bf017972
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 07:26:09 -0500
Date: Tue, 30 Dec 2008 10:26:01 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Nam =?UTF-8?B?UGjhuqFtIFRow6BuaA==?=" <phamthanhnam.ptn@gmail.com>
Message-ID: <20081230102601.4ba511ce@pedra.chehab.org>
In-Reply-To: <2ac79fa40812260631r7f34d2a5nc49233866d010047@mail.gmail.com>
References: <2ac79fa40812260631r7f34d2a5nc49233866d010047@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] Add support for Avermedia AVerTV GO 007 FM Plus
 (1461:f31d)
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

On Fri, 26 Dec 2008 21:31:41 +0700
"Nam Phạm Thành" <phamthanhnam.ptn@gmail.com> wrote:

> Hi all
> I've tested carefully this patch on 4 cards (one is mine and 3 other
> cards from 3 different stores (I can borrow them freely)) with kernel
> 2.6.27. I don't need any additional configuration, just patch the
> module, reboot and they work (auto detected). TV, radio, sound, infrared
> remote, S-Video, Line... almost work perfectly.
> So, please add this support to make it easy for me and to help many
> people in the world who have this TV card.
> Best regards.

Hi Nam,

You need to send your Signed-off-by: together with your patch, as described on 
http://linuxtv.org/hg/v4l-dvb/raw-file/tip/README.patches.

Also, your patch didn't apply on my tree. Probably, your emailer did something
bad, like replacing tabs with white spaces.

Could you please re-generate it?

Cheers,
Mauro.

> diff -ur 2c6835aaa8ea linux/Documentation/video4linux/CARDLIST.saa7134
> --- a/linux/Documentation/video4linux/CARDLIST.saa7134    2008-12-22
> 17:54:05.000000000 +0700
> +++ b/linux/Documentation/video4linux/CARDLIST.saa7134    2008-12-22
> 19:33:06.000000000 +0700
> @@ -152,3 +152,4 @@
>  151 -> ADS Tech Instant HDTV                    [1421:0380]
>  152 -> Asus Tiger Rev:1.00                      [1043:4857]
>  153 -> Kworld Plus TV Analog Lite PCI           [17de:7128]
> +154 -> Avermedia AVerTV GO 007 FM Plus          [1461:f31d]
> diff -ur 2c6835aaa8ea linux/drivers/media/video/saa7134/saa7134-cards.c
> --- a/linux/drivers/media/video/saa7134/saa7134-cards.c    2008-12-22
> 17:54:05.000000000 +0700
> +++ b/linux/drivers/media/video/saa7134/saa7134-cards.c    2008-12-23
> 16:23:35.000000000 +0700
> @@ -4682,6 +4682,38 @@
>              .amux = 2,
>          },
>      },
> +    [SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS] = {
> +        .name           = "Avermedia AVerTV GO 007 FM Plus",
> +        .audio_clock    = 0x00187de7,
> +        .tuner_type     = TUNER_PHILIPS_TDA8290,
> +        .radio_type     = UNSET,
> +        .tuner_addr    = ADDR_UNSET,
> +        .radio_addr    = ADDR_UNSET,
> +        .gpiomask       = 0x00300003,
> +        /* .gpiomask       = 0x8c240003, */
> +        .inputs         = {{
> +            .name = name_tv,
> +            .vmux = 1,
> +            .amux = TV,
> +            .tv   = 1,
> +            .gpio = 0x01,
> +        },{
> +            .name = name_svideo,
> +            .vmux = 6,
> +            .amux = LINE1,
> +            .gpio = 0x02,
> +        }},
> +        .radio = {
> +            .name = name_radio,
> +            .amux = TV,
> +            .gpio = 0x00300001,
> +        },
> +        .mute = {
> +            .name = name_mute,
> +            .amux = TV,
> +            .gpio = 0x01,
> +        },
> +    },
>  };
> 
>  const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
> @@ -5741,6 +5773,13 @@
>          .subdevice    = 0x7128,
>          .driver_data  = SAA7134_BOARD_KWORLD_PLUS_TV_ANALOG,
>      }, {
> +        .vendor       = PCI_VENDOR_ID_PHILIPS,
> +        .device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
> +        .subvendor    = 0x1461, /* Avermedia Technologies Inc */
> +        .subdevice    = 0xf31d,
> +        .driver_data  = SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS,
> +
> +    }, {
>          /* --- boards without eeprom + subsystem ID --- */
>          .vendor       = PCI_VENDOR_ID_PHILIPS,
>          .device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
> @@ -6029,6 +6068,7 @@
>      case SAA7134_BOARD_GENIUS_TVGO_A11MCE:
>      case SAA7134_BOARD_REAL_ANGEL_220:
>      case SAA7134_BOARD_KWORLD_PLUS_TV_ANALOG:
> +    case SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS:
>          dev->has_remote = SAA7134_REMOTE_GPIO;
>          break;
>      case SAA7134_BOARD_FLYDVBS_LR300:
> diff -ur 2c6835aaa8ea linux/drivers/media/video/saa7134/saa7134.h
> --- a/linux/drivers/media/video/saa7134/saa7134.h    2008-12-22
> 17:54:05.000000000 +0700
> +++ b/linux/drivers/media/video/saa7134/saa7134.h    2008-12-22
> 19:07:32.000000000 +0700
> @@ -277,6 +277,7 @@
>  #define SAA7134_BOARD_ADS_INSTANT_HDTV_PCI  151
>  #define SAA7134_BOARD_ASUSTeK_TIGER         152
>  #define SAA7134_BOARD_KWORLD_PLUS_TV_ANALOG 153
> +#define SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS 154
> 
>  #define SAA7134_MAXBOARDS 32
>  #define SAA7134_INPUT_MAX 8
> diff -ur 2c6835aaa8ea linux/drivers/media/video/saa7134/saa7134-input.c
> --- a/linux/drivers/media/video/saa7134/saa7134-input.c    2008-12-22
> 17:54:05.000000000 +0700
> +++ b/linux/drivers/media/video/saa7134/saa7134-input.c    2008-12-23
> 08:25:28.000000000 +0700
> @@ -449,6 +449,7 @@
>      case SAA7134_BOARD_AVERMEDIA_STUDIO_507:
>      case SAA7134_BOARD_AVERMEDIA_GO_007_FM:
>      case SAA7134_BOARD_AVERMEDIA_M102:
> +    case SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS:
>          ir_codes     = ir_codes_avermedia;
>          mask_keycode = 0x0007C8;
>          mask_keydown = 0x000010;
> 
> Signed-off-by: Pham Thanh Nam <phamthanhnam.ptn@gmail.com>




Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
