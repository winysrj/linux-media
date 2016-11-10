Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:55715 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932845AbcKJOS6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Nov 2016 09:18:58 -0500
Date: Thu, 10 Nov 2016 14:18:55 +0000
From: Sean Young <sean@mess.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] ir-kbd-i2c: fix uninitialized variable reference
Message-ID: <20161110141855.GA22393@gofer.mess.org>
References: <c149b7bf-fd3f-678e-64d4-c4b752bed3d2@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c149b7bf-fd3f-678e-64d4-c4b752bed3d2@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 10, 2016 at 08:45:24AM +0100, Hans Verkuil wrote:
> Fix compiler warning about uninitialized variable reference:
> 
> ir-kbd-i2c.c: In function 'get_key_haup_common.isra.3':
> ir-kbd-i2c.c:62:2: warning: 'toggle' may be used uninitialized in this function [-Wmaybe-uninitialized]
>   printk(KERN_DEBUG MODULE_NAME ": " fmt , ## arg)
>   ^~~~~~
> ir-kbd-i2c.c:70:20: note: 'toggle' was declared here
>   int start, range, toggle, dev, code, ircode, vendor;
>                     ^~~~~~

Again this patch already exists (which does exactly the same).

https://patchwork.linuxtv.org/patch/37930/


Sean

> 
> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
> ---
> diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
> index f95a6bc..cede397 100644
> --- a/drivers/media/i2c/ir-kbd-i2c.c
> +++ b/drivers/media/i2c/ir-kbd-i2c.c
> @@ -118,7 +118,7 @@ static int get_key_haup_common(struct IR_i2c *ir, enum rc_type *protocol,
>  			*protocol = RC_TYPE_RC6_MCE;
>  			dev &= 0x7f;
>  			dprintk(1, "ir hauppauge (rc6-mce): t%d vendor=%d dev=%d code=%d\n",
> -						toggle, vendor, dev, code);
> +						*ptoggle, vendor, dev, code);
>  		} else {
>  			*ptoggle = 0;
>  			*protocol = RC_TYPE_RC6_6A_32;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
