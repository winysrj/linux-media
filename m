Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:40717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756598Ab1GAOAd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2011 10:00:33 -0400
Message-ID: <4E0DD2FD.4070606@redhat.com>
Date: Fri, 01 Jul 2011 11:00:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jonathan Liu <net147@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Leadtek CoolCommand Y0400046
References: <4E0DBC7C.5030106@gmail.com>
In-Reply-To: <4E0DBC7C.5030106@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 01-07-2011 09:24, Jonathan Liu escreveu:
> Hi Mauro,
> 
> I had a problem with my the Y0400046 remote control not working properly with my Leadtek WinFast TV2000 XP Deluxe.
> It seems the keycode mask is incorrect for my particular card.
> I have attached a patch which fixes the issue for me but i'm not sure if it is the correct way to do it.
> If you have some time can you take a look at the patch?

(c/c Linux media ML)

> 
> Any help is greatly appreciated.
> 
> Regards,
> Jonathan
> 
> 0001-media-bttv-input-Fix-WinFast-2000-keycode-mask.patch
> 
> 
> From caa0c6ad14ef361dbaba01e9b6844d2606f5411a Mon Sep 17 00:00:00 2001
> From: Jonathan Liu <net147@gmail.com>
> Date: Fri, 1 Jul 2011 22:08:46 +1000
> Subject: [PATCH] [media] bttv-input: Fix WinFast 2000 keycode mask
> 
> The remote control for Leadtek WinFast TV2000 XP Deluxe doesn't work
> as the keycode mask is incorrect. This fixes the keycode mask so the
> remote control codes are correctly interpreted.
> 
> Signed-off-by: Jonathan Liu <net147@gmail.com>
> ---
>  drivers/media/video/bt8xx/bttv-input.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/bt8xx/bttv-input.c b/drivers/media/video/bt8xx/bttv-input.c
> index 677d70c..f861a00 100644
> --- a/drivers/media/video/bt8xx/bttv-input.c
> +++ b/drivers/media/video/bt8xx/bttv-input.c
> @@ -469,7 +469,7 @@ int bttv_input_init(struct bttv *btv)
>  
>  	case BTTV_BOARD_WINFAST2000:
>  		ir_codes         = RC_MAP_WINFAST;
> -		ir->mask_keycode = 0x1f8;
> +		ir->mask_keycode = (btv->cardid == 0x6606107d) ? 0x8f8: 0x1f8;
>  		break;
>  	case BTTV_BOARD_MAGICTVIEW061:
>  	case BTTV_BOARD_MAGICTVIEW063:
> -- 1.7.6

Hmm.. I see, there are a few different models using the same board entry:

drivers/media/video/bt8xx/bttv-cards.c:   { 0x6606107d, BTTV_BOARD_WINFAST2000,   "Leadtek WinFast TV 2000" },
drivers/media/video/bt8xx/bttv-cards.c:   { 0x6609107d, BTTV_BOARD_WINFAST2000,   "Leadtek TV 2000 XP" },
drivers/media/video/bt8xx/bttv-cards.c:   { 0x217d6606, BTTV_BOARD_WINFAST2000,   "Leadtek WinFast TV 2000" },
drivers/media/video/bt8xx/bttv-cards.c:   { 0xfff6f6ff, BTTV_BOARD_WINFAST2000,   "Leadtek WinFast TV 2000" },

What we generally do, on such cases is to create a separate entry for the board that
has something different. This helps to track the differences between them.

Yet, your solution seems to work fine. I'm wandering if the other board models may
also have a problem with the keycode mask.

Well, for now, I'll apply your patch as-is, but it would be good to have some feedback
from other users with similar boards.

Thanks,
Mauro
