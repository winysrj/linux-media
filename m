Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:56188 "EHLO mail.horus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbcHAMJn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Aug 2016 08:09:43 -0400
Date: Mon, 1 Aug 2016 14:09:00 +0200
From: Matthias Reichl <hias@horus.com>
To: Ole Ernst <olebowle@gmx.com>
Cc: m.chehab@samsung.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] Partly revert "[media] rc-core: allow calling rc_open
 with device not initialized"
Message-ID: <20160801120900.GA6397@camel2.lan>
References: <20160726115225.GA15199@camel2.lan>
 <20160730131927.10308-1-olebowle@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160730131927.10308-1-olebowle@gmx.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 30, 2016 at 03:19:27PM +0200, Ole Ernst wrote:
> This partly reverts commit 078600f514a12fd763ac84c86af68ef5b5267563.
> 
> Due to the relocation of input_register_device() call, holding down a
> button on an IR remote no longer resulted in repeated key down events.
> 
> Signed-off-by: Ole Ernst <olebowle@gmx.com>

Tested-by: Matthias Reichl <hias@horus.com>

I tested on Raspberry Pi model B with kernel 4.7.0, gpio-rc-recv,
rc-hauppauge keymap and with this patch key repeat is working fine
again.

Thanks a lot for the quick fix!

Hias

> ---
>  drivers/media/rc/rc-main.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index 8e7f292..26fd63b 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -1460,6 +1460,10 @@ int rc_register_device(struct rc_dev *dev)
>  	dev->input_dev->phys = dev->input_phys;
>  	dev->input_dev->name = dev->input_name;
>  
> +	rc = input_register_device(dev->input_dev);
> +	if (rc)
> +		goto out_table;
> +
>  	/*
>  	 * Default delay of 250ms is too short for some protocols, especially
>  	 * since the timeout is currently set to 250ms. Increase it to 500ms,
> @@ -1475,11 +1479,6 @@ int rc_register_device(struct rc_dev *dev)
>  	 */
>  	dev->input_dev->rep[REP_PERIOD] = 125;
>  
> -	/* rc_open will be called here */
> -	rc = input_register_device(dev->input_dev);
> -	if (rc)
> -		goto out_table;
> -
>  	path = kobject_get_path(&dev->dev.kobj, GFP_KERNEL);
>  	dev_info(&dev->dev, "%s as %s\n",
>  		dev->input_name ?: "Unspecified device", path ?: "N/A");
> -- 
> 2.9.0
> 
