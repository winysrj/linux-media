Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:22531 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbZGSMsF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 08:48:05 -0400
Date: Sun, 19 Jul 2009 14:47:49 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@radix.net>
Cc: linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Mark Lord <lkml@rtr.ca>, Mike Isely <isely@pobox.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Janne Grunau <j@jannau.net>
Subject: Re: [PATCH 1/3] ir-kbd-i2c: Allow use of ir-kdb-i2c internal
 get_key  funcs and set ir_type
Message-ID: <20090719144749.689c2b3a@hyperion.delvare>
In-Reply-To: <1247862937.10066.21.camel@palomino.walls.org>
References: <1247862585.10066.16.camel@palomino.walls.org>
	<1247862937.10066.21.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Fri, 17 Jul 2009 16:35:37 -0400, Andy Walls wrote:
> This patch augments the init data passed by bridge drivers to ir-kbd-i2c
> so that the ir_type can be set explicitly and so ir-kbd-i2c internal
> get_key functions can be reused without requiring symbols from
> ir-kbd-i2c in the bridge driver.
> 
> 
> Regards,
> Andy

Looks good. Minor suggestion below:

> 
> diff -r d754a2d5a376 linux/drivers/media/video/ir-kbd-i2c.c
> --- a/linux/drivers/media/video/ir-kbd-i2c.c	Wed Jul 15 07:28:02 2009 -0300
> +++ b/linux/drivers/media/video/ir-kbd-i2c.c	Fri Jul 17 16:05:28 2009 -0400
> @@ -478,7 +480,34 @@
>  
>  		ir_codes = init_data->ir_codes;
>  		name = init_data->name;
> +		if (init_data->type)
> +			ir_type = init_data->type;
>  		ir->get_key = init_data->get_key;
> +		switch (init_data->internal_get_key_func) {
> +		case IR_KBD_GET_KEY_PIXELVIEW:
> +			ir->get_key = get_key_pixelview;
> +			break;
> +		case IR_KBD_GET_KEY_PV951:
> +			ir->get_key = get_key_pv951;
> +			break;
> +		case IR_KBD_GET_KEY_HAUP:
> +			ir->get_key = get_key_haup;
> +			break;
> +		case IR_KBD_GET_KEY_KNC1:
> +			ir->get_key = get_key_knc1;
> +			break;
> +		case IR_KBD_GET_KEY_FUSIONHDTV:
> +			ir->get_key = get_key_fusionhdtv;
> +			break;
> +		case IR_KBD_GET_KEY_HAUP_XVR:
> +			ir->get_key = get_key_haup_xvr;
> +			break;
> +		case IR_KBD_GET_KEY_AVERMEDIA_CARDBUS:
> +			ir->get_key = get_key_avermedia_cardbus;
> +			break;
> +		default:
> +			break;
> +		}
>  	}
>  
>  	/* Make sure we are all setup before going on */
> diff -r d754a2d5a376 linux/include/media/ir-kbd-i2c.h
> --- a/linux/include/media/ir-kbd-i2c.h	Wed Jul 15 07:28:02 2009 -0300
> +++ b/linux/include/media/ir-kbd-i2c.h	Fri Jul 17 16:05:28 2009 -0400
> @@ -24,10 +24,27 @@
>  	int                    (*get_key)(struct IR_i2c*, u32*, u32*);
>  };
>  
> +enum ir_kbd_get_key_fn {
> +	IR_KBD_GET_KEY_NONE = 0,

As you never use IR_KBD_GET_KEY_NONE, you might as well not define it
and start with IR_KBD_GET_KEY_PIXELVIEW = 1. This would have the added
advantage that you could get rid of the "default" statement in the
above switch, letting gcc warn you (or any other developer) if you ever
add a new enum value and forget to handle it in ir_probe().

> +	IR_KBD_GET_KEY_PIXELVIEW,
> +	IR_KBD_GET_KEY_PV951,
> +	IR_KBD_GET_KEY_HAUP,
> +	IR_KBD_GET_KEY_KNC1,
> +	IR_KBD_GET_KEY_FUSIONHDTV,
> +	IR_KBD_GET_KEY_HAUP_XVR,
> +	IR_KBD_GET_KEY_AVERMEDIA_CARDBUS,
> +};
> +
>  /* Can be passed when instantiating an ir_video i2c device */
>  struct IR_i2c_init_data {
>  	IR_KEYTAB_TYPE         *ir_codes;
>  	const char             *name;
> +	int                    type; /* IR_TYPE_RC5, IR_TYPE_PD, etc */
> +	/*
> +	 * Specify either a function pointer or a value indicating one of
> +	 * ir_kbd_i2c's internal get_key functions
> +	 */
>  	int                    (*get_key)(struct IR_i2c*, u32*, u32*);
> +	enum ir_kbd_get_key_fn internal_get_key_func;
>  };
>  #endif


-- 
Jean Delvare
