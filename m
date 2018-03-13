Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:45387 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932240AbeCMW1W (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 18:27:22 -0400
Date: Tue, 13 Mar 2018 23:27:20 +0100
From: Matthias Reichl <hias@horus.com>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Carlo Caione <carlo@caione.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Alex Deryskyba <alex@codesnake.com>,
        Jonas Karlman <jonas@kwiboo.se>, linux-media@vger.kernel.org,
        linux-amlogic@lists.infradead.org
Subject: Re: [PATCH] media: rc: meson-ir: lower timeout and make configurable
Message-ID: <20180313222719.tox73pp25adqvktu@camel2.lan>
References: <20180306174122.6017-1-hias@horus.com>
 <20180308164327.ihhmvm6ntzvnsjy7@gofer.mess.org>
 <20180309155451.gbocsaj4s3puc4cq@camel2.lan>
 <20180310112744.plfxkmqbgvii7n7r@gofer.mess.org>
 <20180310173828.7lwyicxzar22dyb7@camel2.lan>
 <20180311125518.pcob4wii43odmana@gofer.mess.org>
 <20180312132000.oqrj4xjdi7lvupnu@camel2.lan>
 <20180312135811.g25jjzhmh3jnvgjr@gofer.mess.org>
 <20180312214840.rnuflajm6n6kozxt@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180312214840.rnuflajm6n6kozxt@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 12, 2018 at 09:48:40PM +0000, Sean Young wrote:
> A timeout of 200ms is much longer than necessary, and delays the decoding
> decoding of a single scancode and the last scancode when a button is being
> held. This makes the remote seem sluggish.
> 
> If the min_timeout and max_timeout values are set, the timeout is
> configurable via the LIRC_SET_REC_TIMEOUT ioctl.
> 
> Signed-off-by: Sean Young <sean@mess.org>

Tested-by: Matthias Reichl <hias@horus.com>

Thanks a lot, this is working fine!

so long,

Hias

> ---
>  drivers/media/rc/meson-ir.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/rc/meson-ir.c b/drivers/media/rc/meson-ir.c
> index 64b0aa4f4db7..f449b35d25e7 100644
> --- a/drivers/media/rc/meson-ir.c
> +++ b/drivers/media/rc/meson-ir.c
> @@ -144,7 +144,9 @@ static int meson_ir_probe(struct platform_device *pdev)
>  	ir->rc->map_name = map_name ? map_name : RC_MAP_EMPTY;
>  	ir->rc->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
>  	ir->rc->rx_resolution = US_TO_NS(MESON_TRATE);
> -	ir->rc->timeout = MS_TO_NS(200);
> +	ir->rc->min_timeout = 1;
> +	ir->rc->timeout = IR_DEFAULT_TIMEOUT;
> +	ir->rc->max_timeout = 10 * IR_DEFAULT_TIMEOUT;
>  	ir->rc->driver_name = DRIVER_NAME;
>  
>  	spin_lock_init(&ir->lock);
> -- 
> 2.14.3
> 
