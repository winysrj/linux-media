Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:39617 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751335AbdKUTUW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Nov 2017 14:20:22 -0500
Date: Tue, 21 Nov 2017 20:20:19 +0100
From: Matthias Reichl <hias@horus.com>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: rc: double keypresses due to timeout expiring to
 early
Message-ID: <20171121192019.y7srcsiy4othnpxb@camel2.lan>
References: <20171116152700.filid3ask3gowegl@camel2.lan>
 <20171116163920.ouxinvde5ai4fle3@gofer.mess.org>
 <20171116215451.min7sqdo7itiyyif@gofer.mess.org>
 <20171117145249.wc4ql2hw46enxu7d@camel2.lan>
 <20171119215727.slnzxumlun5lh6ae@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171119215727.slnzxumlun5lh6ae@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean!

On Sun, Nov 19, 2017 at 09:57:27PM +0000, Sean Young wrote:
> I think for now the best solution is to revert to 250ms for all protocols
> (except for cec which needs 550ms), and reconsider for another kernel.

Thanks, this sounds like a good idea!

> >>From 2f1135f3f9873778ca5c013d1118710152840cb2 Mon Sep 17 00:00:00 2001
> From: Sean Young <sean@mess.org>
> Date: Sun, 19 Nov 2017 21:11:17 +0000
> Subject: [PATCH] media: rc: partial revert of "media: rc: per-protocol repeat
>  period"
> 
> Since commit d57ea877af38 ("media: rc: per-protocol repeat period"), most
> IR protocols have a lower keyup timeout. This causes problems on the
> ite-cir, which has default IR timeout of 200ms.
> 
> Since the IR decoders read the trailing space, with a IR timeout of 200ms,
> the last keydown will have at least a delay of 200ms. This is more than
> the protocol timeout of e.g. rc-6 (which is 164ms). As a result the last
> IR will be interpreted as a new keydown event, and we get two keypresses.
> 
> Revert the protocol timeout to 250ms, except for cec which needs a timeout
> of 550ms.
> 
> Fixes: d57ea877af38 ("media: rc: per-protocol repeat period")
> Cc: <stable@vger.kernel.org> # 4.14
> Signed-off-by: Sean Young <sean@mess.org>

Tested-by: Matthias Reichl <hias@horus.com>

I tested this locally with gpio-ir configured to 200ms timeout and
we also received feedback from 2 users that this change fixed the
issue with the ite-cir receiver.

https://forum.kodi.tv/showthread.php?tid=298462&pid=2670637#pid2670637

Thanks a lot for fixing this so quickly!

so long,

Hias
> ---
>  drivers/media/rc/rc-main.c | 32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index 17950e29d4e3..5057b2ba0c10 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -39,41 +39,41 @@ static const struct {
>  	[RC_PROTO_UNKNOWN] = { .name = "unknown", .repeat_period = 250 },
>  	[RC_PROTO_OTHER] = { .name = "other", .repeat_period = 250 },
>  	[RC_PROTO_RC5] = { .name = "rc-5",
> -		.scancode_bits = 0x1f7f, .repeat_period = 164 },
> +		.scancode_bits = 0x1f7f, .repeat_period = 250 },
>  	[RC_PROTO_RC5X_20] = { .name = "rc-5x-20",
> -		.scancode_bits = 0x1f7f3f, .repeat_period = 164 },
> +		.scancode_bits = 0x1f7f3f, .repeat_period = 250 },
>  	[RC_PROTO_RC5_SZ] = { .name = "rc-5-sz",
> -		.scancode_bits = 0x2fff, .repeat_period = 164 },
> +		.scancode_bits = 0x2fff, .repeat_period = 250 },
>  	[RC_PROTO_JVC] = { .name = "jvc",
>  		.scancode_bits = 0xffff, .repeat_period = 250 },
>  	[RC_PROTO_SONY12] = { .name = "sony-12",
> -		.scancode_bits = 0x1f007f, .repeat_period = 100 },
> +		.scancode_bits = 0x1f007f, .repeat_period = 250 },
>  	[RC_PROTO_SONY15] = { .name = "sony-15",
> -		.scancode_bits = 0xff007f, .repeat_period = 100 },
> +		.scancode_bits = 0xff007f, .repeat_period = 250 },
>  	[RC_PROTO_SONY20] = { .name = "sony-20",
> -		.scancode_bits = 0x1fff7f, .repeat_period = 100 },
> +		.scancode_bits = 0x1fff7f, .repeat_period = 250 },
>  	[RC_PROTO_NEC] = { .name = "nec",
> -		.scancode_bits = 0xffff, .repeat_period = 160 },
> +		.scancode_bits = 0xffff, .repeat_period = 250 },
>  	[RC_PROTO_NECX] = { .name = "nec-x",
> -		.scancode_bits = 0xffffff, .repeat_period = 160 },
> +		.scancode_bits = 0xffffff, .repeat_period = 250 },
>  	[RC_PROTO_NEC32] = { .name = "nec-32",
> -		.scancode_bits = 0xffffffff, .repeat_period = 160 },
> +		.scancode_bits = 0xffffffff, .repeat_period = 250 },
>  	[RC_PROTO_SANYO] = { .name = "sanyo",
>  		.scancode_bits = 0x1fffff, .repeat_period = 250 },
>  	[RC_PROTO_MCIR2_KBD] = { .name = "mcir2-kbd",
> -		.scancode_bits = 0xffff, .repeat_period = 150 },
> +		.scancode_bits = 0xffff, .repeat_period = 250 },
>  	[RC_PROTO_MCIR2_MSE] = { .name = "mcir2-mse",
> -		.scancode_bits = 0x1fffff, .repeat_period = 150 },
> +		.scancode_bits = 0x1fffff, .repeat_period = 250 },
>  	[RC_PROTO_RC6_0] = { .name = "rc-6-0",
> -		.scancode_bits = 0xffff, .repeat_period = 164 },
> +		.scancode_bits = 0xffff, .repeat_period = 250 },
>  	[RC_PROTO_RC6_6A_20] = { .name = "rc-6-6a-20",
> -		.scancode_bits = 0xfffff, .repeat_period = 164 },
> +		.scancode_bits = 0xfffff, .repeat_period = 250 },
>  	[RC_PROTO_RC6_6A_24] = { .name = "rc-6-6a-24",
> -		.scancode_bits = 0xffffff, .repeat_period = 164 },
> +		.scancode_bits = 0xffffff, .repeat_period = 250 },
>  	[RC_PROTO_RC6_6A_32] = { .name = "rc-6-6a-32",
> -		.scancode_bits = 0xffffffff, .repeat_period = 164 },
> +		.scancode_bits = 0xffffffff, .repeat_period = 250 },
>  	[RC_PROTO_RC6_MCE] = { .name = "rc-6-mce",
> -		.scancode_bits = 0xffff7fff, .repeat_period = 164 },
> +		.scancode_bits = 0xffff7fff, .repeat_period = 250 },
>  	[RC_PROTO_SHARP] = { .name = "sharp",
>  		.scancode_bits = 0x1fff, .repeat_period = 250 },
>  	[RC_PROTO_XMP] = { .name = "xmp", .repeat_period = 250 },
> -- 
> 2.14.3
> 
