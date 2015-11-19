Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36298 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932882AbbKSNtz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2015 08:49:55 -0500
Date: Thu, 19 Nov 2015 11:49:50 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: linux-media@vger.kernel.org,
	David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Subject: Re: [PATCH 6/8] media: rc: treat lirc like any other protocol
Message-ID: <20151119114950.06a0eb90@recife.lan>
In-Reply-To: <564A3430.5020103@gmail.com>
References: <564A3430.5020103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Heiner,

Em Mon, 16 Nov 2015 20:53:20 +0100
Heiner Kallweit <hkallweit1@gmail.com> escreveu:

> Introduce a protocol bit for lirc and treat it like any other protocol.
> This allows to get rid of all the lirc-specific code.

LIRC were originally handled like a protocol, but, after some discussions,
we decided to handle it in separate, as it is actually an API.

So, I'm not applying this patch.

Patches 1-5 and patch 7 looks OK, so I'm applying them.

Regards,
Mauro

> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/media/rc/ir-lirc-codec.c |  2 +-
>  drivers/media/rc/rc-core-priv.h  | 16 ++--------------
>  drivers/media/rc/rc-ir-raw.c     | 13 +------------
>  drivers/media/rc/rc-main.c       | 37 ++++---------------------------------
>  4 files changed, 8 insertions(+), 60 deletions(-)
> 
> diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
> index a32659f..40c66c8 100644
> --- a/drivers/media/rc/ir-lirc-codec.c
> +++ b/drivers/media/rc/ir-lirc-codec.c
> @@ -421,7 +421,7 @@ static int ir_lirc_unregister(struct rc_dev *dev)
>  }
>  
>  static struct ir_raw_handler lirc_handler = {
> -	.protocols	= 0,
> +	.protocols	= RC_BIT_LIRC,
>  	.decode		= ir_lirc_decode,
>  	.raw_register	= ir_lirc_register,
>  	.raw_unregister	= ir_lirc_unregister,
> diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
> index 071651a..74f2f15 100644
> --- a/drivers/media/rc/rc-core-priv.h
> +++ b/drivers/media/rc/rc-core-priv.h
> @@ -20,6 +20,8 @@
>  #include <linux/spinlock.h>
>  #include <media/rc-core.h>
>  
> +#define RC_BIT_LIRC	(1ULL << 63)
> +
>  struct ir_raw_handler {
>  	struct list_head list;
>  
> @@ -160,18 +162,4 @@ int ir_raw_handler_register(struct ir_raw_handler *ir_raw_handler);
>  void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler);
>  void ir_raw_init(void);
>  
> -/*
> - * Decoder initialization code
> - *
> - * Those load logic are called during ir-core init, and automatically
> - * loads the compiled decoders for their usage with IR raw events
> - */
> -
> -/* from ir-lirc-codec.c */
> -#ifdef CONFIG_IR_LIRC_CODEC_MODULE
> -#define load_lirc_codec()	request_module_nowait("ir-lirc-codec")
> -#else
> -static inline void load_lirc_codec(void) { }
> -#endif
> -
>  #endif /* _RC_CORE_PRIV */
> diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
> index c6433e8..dbd8db5 100644
> --- a/drivers/media/rc/rc-ir-raw.c
> +++ b/drivers/media/rc/rc-ir-raw.c
> @@ -59,8 +59,7 @@ static int ir_raw_event_thread(void *data)
>  
>  		mutex_lock(&ir_raw_handler_lock);
>  		list_for_each_entry(handler, &ir_raw_handler_list, list)
> -			if (raw->dev->enabled_protocols & handler->protocols ||
> -			    !handler->protocols)
> +			if (raw->dev->enabled_protocols & handler->protocols)
>  				handler->decode(raw->dev, ev);
>  		raw->prev_ev = ev;
>  		mutex_unlock(&ir_raw_handler_lock);
> @@ -360,13 +359,3 @@ void ir_raw_handler_unregister(struct ir_raw_handler *ir_raw_handler)
>  	mutex_unlock(&ir_raw_handler_lock);
>  }
>  EXPORT_SYMBOL(ir_raw_handler_unregister);
> -
> -void ir_raw_init(void)
> -{
> -	/* Load the decoder modules */
> -	load_lirc_codec();
> -
> -	/* If needed, we may later add some init code. In this case,
> -	   it is needed to change the CONFIG_MODULE test at rc-core.h
> -	 */
> -}
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index f2d5c50..d1611f1 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -802,6 +802,7 @@ static const struct {
>  	{ RC_BIT_SHARP,		"sharp",	"ir-sharp-decoder"	},
>  	{ RC_BIT_MCE_KBD,	"mce_kbd",	"ir-mce_kbd-decoder"	},
>  	{ RC_BIT_XMP,		"xmp",		"ir-xmp-decoder"	},
> +	{ RC_BIT_LIRC,		"lirc",		"ir-lirc-codec"		},
>  };
>  
>  /**
> @@ -829,23 +830,6 @@ struct rc_filter_attribute {
>  		.mask = (_mask),					\
>  	}
>  
> -static bool lirc_is_present(void)
> -{
> -#if defined(CONFIG_LIRC_MODULE)
> -	struct module *lirc;
> -
> -	mutex_lock(&module_mutex);
> -	lirc = find_module("lirc_dev");
> -	mutex_unlock(&module_mutex);
> -
> -	return lirc ? true : false;
> -#elif defined(CONFIG_LIRC)
> -	return true;
> -#else
> -	return false;
> -#endif
> -}
> -
>  /**
>   * show_protocols() - shows the current/wakeup IR protocol(s)
>   * @device:	the device descriptor
> @@ -900,9 +884,6 @@ static ssize_t show_protocols(struct device *device,
>  			allowed &= ~proto_names[i].type;
>  	}
>  
> -	if (dev->driver_type == RC_DRIVER_IR_RAW && lirc_is_present())
> -		tmp += sprintf(tmp, "[lirc] ");
> -
>  	if (tmp != buf)
>  		tmp--;
>  	*tmp = '\n';
> @@ -954,12 +935,8 @@ static int parse_protocol_change(u64 *protocols, const char *buf)
>  		}
>  
>  		if (i == ARRAY_SIZE(proto_names)) {
> -			if (!strcasecmp(tmp, "lirc"))
> -				mask = 0;
> -			else {
> -				IR_dprintk(1, "Unknown protocol: '%s'\n", tmp);
> -				return -EINVAL;
> -			}
> +			IR_dprintk(1, "Unknown protocol: '%s'\n", tmp);
> +			return -EINVAL;
>  		}
>  
>  		count++;
> @@ -1376,7 +1353,6 @@ EXPORT_SYMBOL_GPL(rc_free_device);
>  
>  int rc_register_device(struct rc_dev *dev)
>  {
> -	static bool raw_init = false; /* raw decoders loaded? */
>  	struct rc_map *rc_map;
>  	const char *path;
>  	int attr = 0;
> @@ -1471,12 +1447,7 @@ int rc_register_device(struct rc_dev *dev)
>  	kfree(path);
>  
>  	if (dev->driver_type == RC_DRIVER_IR_RAW) {
> -		/* Load raw decoders, if they aren't already */
> -		if (!raw_init) {
> -			IR_dprintk(1, "Loading raw decoders\n");
> -			ir_raw_init();
> -			raw_init = true;
> -		}
> +		dev->allowed_protocols |= RC_BIT_LIRC;
>  		/* calls ir_register_device so unlock mutex here*/
>  		mutex_unlock(&dev->lock);
>  		rc = ir_raw_event_register(dev);
