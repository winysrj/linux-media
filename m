Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:59756 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751370AbZDUX0w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2009 19:26:52 -0400
Subject: Re: +
	drivers-media-video-saa7134-add-tuner-support-for-avermedia-studio-505.patch
	added to -mm tree
From: hermann pitton <hermann-pitton@arcor.de>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, vaka@newmail.ru, mchehab@infradead.org,
	mkrufky@linuxtv.org, hartmut.hackmann@t-online.de,
	linux-media@vger.kernel.org
In-Reply-To: <200904202021.n3KKLGvd000469@imap1.linux-foundation.org>
References: <200904202021.n3KKLGvd000469@imap1.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 01:21:18 +0200
Message-Id: <1240356078.22263.33.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

Am Montag, den 20.04.2009, 13:21 -0700 schrieb
akpm@linux-foundation.org:
> The patch titled
>      drivers/media/video/saa7134: add tuner support for AverMedia Studio 505
> has been added to the -mm tree.  Its filename is
>      drivers-media-video-saa7134-add-tuner-support-for-avermedia-studio-505.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: drivers/media/video/saa7134: add tuner support for AverMedia Studio 505
> From: Vasiliy Temnikov <vaka@newmail.ru>
> 
> Add tuner support AverMedia AverTV Studio 505.
> 
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Hermann Pitton <hermann-pitton@arcor.de>
> Cc: Michael Krufky <mkrufky@linuxtv.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  Documentation/video4linux/CARDLIST.saa7134  |    1 
>  drivers/media/video/saa7134/saa7134-cards.c |   43 ++++++++++++++++++
>  drivers/media/video/saa7134/saa7134-input.c |    1 
>  drivers/media/video/saa7134/saa7134-video.c |    2 
>  drivers/media/video/saa7134/saa7134.h       |    1 
>  5 files changed, 47 insertions(+), 1 deletion(-)
> 
> diff -puN Documentation/video4linux/CARDLIST.saa7134~drivers-media-video-saa7134-add-tuner-support-for-avermedia-studio-505 Documentation/video4linux/CARDLIST.saa7134
> --- a/Documentation/video4linux/CARDLIST.saa7134~drivers-media-video-saa7134-add-tuner-support-for-avermedia-studio-505
> +++ a/Documentation/video4linux/CARDLIST.saa7134
> @@ -156,3 +156,4 @@
>  155 -> Hauppauge WinTV-HVR1120 ATSC/QAM-Hybrid  [0070:6706,0070:6708]
>  156 -> Hauppauge WinTV-HVR1110r3                [0070:6707,0070:6709,0070:670a]
>  157 -> Avermedia AVerTV Studio 507UA            [1461:a11b]
> +158 -> AverMedia AverTV Studio 505              [1461:a115]
> diff -puN drivers/media/video/saa7134/saa7134-cards.c~drivers-media-video-saa7134-add-tuner-support-for-avermedia-studio-505 drivers/media/video/saa7134/saa7134-cards.c
> --- a/drivers/media/video/saa7134/saa7134-cards.c~drivers-media-video-saa7134-add-tuner-support-for-avermedia-studio-505
> +++ a/drivers/media/video/saa7134/saa7134-cards.c
> @@ -1364,6 +1364,42 @@ struct saa7134_board saa7134_boards[] = 
>  			.amux = LINE1,
>  		},
>  	},
> +	[SAA7134_BOARD_AVERMEDIA_STUDIO_505] = {
> +		/* Vasiliy Temnikov <vaka@newmail.ru> */
> +		.name           = "AverMedia AverTV Studio 505",
> +		.audio_clock    = 0x00187de7,
> +		.tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
> +		.radio_type     = UNSET,
> +		.tuner_addr	= ADDR_UNSET,
> +		.radio_addr	= ADDR_UNSET,
> +		.tda9887_conf   = TDA9887_PRESENT,
> +		.inputs         = {{
> +			.name = name_tv,
> +			.vmux = 1,
> +			.amux = LINE2,
> +			.tv   = 1,
> +		},{
> +			.name = name_comp1,
> +			.vmux = 0,
> +			.amux = LINE2,
> +		},{
> +			.name = name_comp2,
> +			.vmux = 3,
> +			.amux = LINE2,
> +		},{
> +			.name = name_svideo,
> +			.vmux = 8,
> +			.amux = LINE2,
> +		}},
> +		.radio = {
> +			.name = name_radio,
> +			.amux = LINE2,
> +		},
> +		.mute = {
> +			.name = name_mute,
> +			.amux = LINE1,
> +		},
> +	},
>  	[SAA7134_BOARD_UPMOST_PURPLE_TV] = {
>  		.name           = "UPMOST PURPLE TV",
>  		.audio_clock    = 0x00187de7,
> @@ -5049,6 +5085,12 @@ struct pci_device_id saa7134_pci_tbl[] =
>  		.vendor       = PCI_VENDOR_ID_PHILIPS,
>  		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
>  		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
> +		.subdevice    = 0xa115,
> +		.driver_data  = SAA7134_BOARD_AVERMEDIA_STUDIO_505,
> +	},{
> +		.vendor       = PCI_VENDOR_ID_PHILIPS,
> +		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
> +		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
>  		.subdevice    = 0x2108,
>  		.driver_data  = SAA7134_BOARD_AVERMEDIA_305,
>  	},{
> @@ -6144,6 +6186,7 @@ int saa7134_board_init1(struct saa7134_d
>  	case SAA7134_BOARD_KWORLD_VSTREAM_XPERT:
>  	case SAA7134_BOARD_KWORLD_XPERT:
>  	case SAA7134_BOARD_AVERMEDIA_STUDIO_305:
> +	case SAA7134_BOARD_AVERMEDIA_STUDIO_505:
>  	case SAA7134_BOARD_AVERMEDIA_305:
>  	case SAA7134_BOARD_AVERMEDIA_STUDIO_307:
>  	case SAA7134_BOARD_AVERMEDIA_307:
> diff -puN drivers/media/video/saa7134/saa7134-input.c~drivers-media-video-saa7134-add-tuner-support-for-avermedia-studio-505 drivers/media/video/saa7134/saa7134-input.c
> --- a/drivers/media/video/saa7134/saa7134-input.c~drivers-media-video-saa7134-add-tuner-support-for-avermedia-studio-505
> +++ a/drivers/media/video/saa7134/saa7134-input.c
> @@ -445,6 +445,7 @@ int saa7134_input_init1(struct saa7134_d
>  	case SAA7134_BOARD_AVERMEDIA_305:
>  	case SAA7134_BOARD_AVERMEDIA_307:
>  	case SAA7134_BOARD_AVERMEDIA_STUDIO_305:
> +	case SAA7134_BOARD_AVERMEDIA_STUDIO_505:
>  	case SAA7134_BOARD_AVERMEDIA_STUDIO_307:
>  	case SAA7134_BOARD_AVERMEDIA_STUDIO_507:
>  	case SAA7134_BOARD_AVERMEDIA_STUDIO_507UA:
> diff -puN drivers/media/video/saa7134/saa7134-video.c~drivers-media-video-saa7134-add-tuner-support-for-avermedia-studio-505 drivers/media/video/saa7134/saa7134-video.c
> --- a/drivers/media/video/saa7134/saa7134-video.c~drivers-media-video-saa7134-add-tuner-support-for-avermedia-studio-505
> +++ a/drivers/media/video/saa7134/saa7134-video.c
> @@ -39,7 +39,7 @@ static unsigned int gbuffers      = 8;
>  static unsigned int noninterlaced; /* 0 */
>  static unsigned int gbufsize      = 720*576*4;
>  static unsigned int gbufsize_max  = 720*576*4;
> -static char secam[] = "--";
> +static char secam[] = "dk";
>  module_param(video_debug, int, 0644);
>  MODULE_PARM_DESC(video_debug,"enable debug messages [video]");
>  module_param(gbuffers, int, 0444);
> diff -puN drivers/media/video/saa7134/saa7134.h~drivers-media-video-saa7134-add-tuner-support-for-avermedia-studio-505 drivers/media/video/saa7134/saa7134.h
> --- a/drivers/media/video/saa7134/saa7134.h~drivers-media-video-saa7134-add-tuner-support-for-avermedia-studio-505
> +++ a/drivers/media/video/saa7134/saa7134.h
> @@ -159,6 +159,7 @@ struct saa7134_format {
>  #define SAA7134_BOARD_AVERMEDIA_DVD_EZMAKER 33
>  #define SAA7134_BOARD_NOVAC_PRIMETV7133 34
>  #define SAA7134_BOARD_AVERMEDIA_STUDIO_305 35
> +#define SAA7134_BOARD_AVERMEDIA_STUDIO_505 158
>  #define SAA7134_BOARD_UPMOST_PURPLE_TV 36
>  #define SAA7134_BOARD_ITEMS_MTV005     37
>  #define SAA7134_BOARD_CINERGY200       38
> _
> 
> Patches currently in -mm which might be from vaka@newmail.ru are
> 
> drivers-media-video-saa7134-add-tuner-support-for-avermedia-studio-505.patch
> 

Vasily, your change in saa7134-video.c has broken support for all other
SECAM standards and users can't change them from the applications
anymore.

After years of trouble, it has very good reasons that we have it as it
is and it was a lot of work to make it usable for all, since different
Secam auto detection through the tvaudio kernelthread turned out to be
impossible.

Here is Hartmut's original patch, on which you touch, after working for
a weekend with a signal generator to find a resolution suitable for all.
http://linuxtv.org/hg/v4l-dvb/rev/84a832a5ffc9

Also please don't jump around with the card #define in saa7134.h.
We keep it there like they historically do appear.

That also the external audio inputs are on LINE2, is very unlikely.
This is only known from cards with an external audio mux chip in front
of the saa713x, but controlled by the gpio pins of the saa713x.
On the other hand the saa7130 is known for crude stuff, since mono only
for TV and not necessarily uses the stereo pair on a LINE input.

Did you really test that?

Hmm, do we try to fix/improve it on Andrew's tree or take it over to
mercurial v4l-dvb and send back from there?

It is some years back being on .mm and likely need to RTFM.

Anyway, thanks for helping us on the saa7134 and keep on doing so!

Cheers,
Hermann






