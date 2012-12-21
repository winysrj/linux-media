Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:51133 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab2LUPip (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Dec 2012 10:38:45 -0500
Received: by mail-bk0-f54.google.com with SMTP id je9so2488887bkc.27
        for <linux-media@vger.kernel.org>; Fri, 21 Dec 2012 07:38:43 -0800 (PST)
Message-ID: <50D48126.8050307@googlemail.com>
Date: Fri, 21 Dec 2012 16:32:54 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] em28xx: input: fix oops on device removal
References: <1355416457-19692-1-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1355416457-19692-1-git-send-email-fschaefer.oss@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 13.12.2012 17:34, schrieb Frank Schäfer:
> When em28xx_ir_init() fails du to an error in em28xx_ir_change_protocol(), it
> frees the memory of struct em28xx_IR *ir, but doesn't set the corresponding
> pointer in the device struct to NULL.
> On device removal, em28xx_ir_fini() gets called, which then calls
> rc_unregister_device() with a pointer to freed memory.
>
> Fixes bug 26572 (http://bugzilla.kernel.org/show_bug.cgi?id=26572)
>
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>
> Cc: stable@kernel.org	# at least all kernels since 2.6.32 (incl.)
> ---
>  drivers/media/usb/em28xx/em28xx-input.c |    9 ++++-----
>  1 Datei geändert, 4 Zeilen hinzugefügt(+), 5 Zeilen entfernt(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
> index 660bf80..5c7d768 100644
> --- a/drivers/media/usb/em28xx/em28xx-input.c
> +++ b/drivers/media/usb/em28xx/em28xx-input.c
> @@ -538,7 +538,7 @@ static int em28xx_ir_init(struct em28xx *dev)
>  	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
>  	rc = rc_allocate_device();
>  	if (!ir || !rc)
> -		goto err_out_free;
> +		goto error;
>  
>  	/* record handles to ourself */
>  	ir->dev = dev;
> @@ -559,7 +559,7 @@ static int em28xx_ir_init(struct em28xx *dev)
>  	rc_type = RC_BIT_UNKNOWN;
>  	err = em28xx_ir_change_protocol(rc, &rc_type);
>  	if (err)
> -		goto err_out_free;
> +		goto error;
>  
>  	/* This is how often we ask the chip for IR information */
>  	ir->polling = 100; /* ms */
> @@ -584,7 +584,7 @@ static int em28xx_ir_init(struct em28xx *dev)
>  	/* all done */
>  	err = rc_register_device(rc);
>  	if (err)
> -		goto err_out_stop;
> +		goto error;
>  
>  	em28xx_register_i2c_ir(dev);
>  
> @@ -597,9 +597,8 @@ static int em28xx_ir_init(struct em28xx *dev)
>  
>  	return 0;
>  
> - err_out_stop:
> +error:
>  	dev->ir = NULL;
> - err_out_free:
>  	rc_free_device(rc);
>  	kfree(ir);
>  	return err;

Ping !?
Mauro, this patch is really easy to review and it fixes a 2 years old bug...
Isn't this one of those patches that should be applied immediately ?

Regards,
Frank





