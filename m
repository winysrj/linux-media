Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57226 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965211AbbHKQ1S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 12:27:18 -0400
Date: Tue, 11 Aug 2015 13:27:12 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] rc-core: improve the lirc protocol reporting
Message-ID: <20150811132712.52cf4e4b@recife.lan>
In-Reply-To: <20150722205524.1907.37521.stgit@zeus.muc.hardeman.nu>
References: <20150722205524.1907.37521.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi David,

Em Wed, 22 Jul 2015 22:55:24 +0200
David Härdeman <david@hardeman.nu> escreveu:

> Commit 275ddb40bcf686d210d86c6718e42425a6a0bc76 removed the lirc
> "protocol" but kept backwards compatibility by always listing
> the protocol as present and enabled. This patch further improves
> the logic by only listing the protocol if the lirc module is loaded
> (or if lirc is builtin).

Makes sense, but see below.

> 
> Signed-off-by: David Härdeman <david@hardeman.nu>
> ---
>  drivers/media/rc/rc-main.c |   19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index ecaee02..3f0f71a 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -828,6 +828,23 @@ struct rc_filter_attribute {
>  		.mask = (_mask),					\
>  	}
>  
> +static bool lirc_is_present(void)
> +{
> +#if defined(CONFIG_LIRC_MODULE)
> +	struct module *lirc;
> +
> +	mutex_lock(&module_mutex);
> +	lirc = find_module("lirc_dev");
> +	mutex_unlock(&module_mutex);

I don't think it would be a good idea to play with the module mutex
lock here or calling find_module(). This is something that no other driver
does (well, except for FB DRM driver, that dynamically loads a module
if not found).

Perhaps we could use some simpler logic, like storing some value if lirc
got loaded or not (worse case, we might use a static atomic var at rc core).

> +
> +	return lirc ? true : false;
> +#elif defined(CONFIG_LIRC)
> +	return true;
> +#else
> +	return false;
> +#endif
> +}
> +
>  /**
>   * show_protocols() - shows the current/wakeup IR protocol(s)
>   * @device:	the device descriptor
> @@ -882,7 +899,7 @@ static ssize_t show_protocols(struct device *device,
>  			allowed &= ~proto_names[i].type;
>  	}
>  
> -	if (dev->driver_type == RC_DRIVER_IR_RAW)
> +	if (dev->driver_type == RC_DRIVER_IR_RAW && lirc_is_present())
>  		tmp += sprintf(tmp, "[lirc] ");
>  
>  	if (tmp != buf)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
