Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:38696 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbaIYOHA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 10:07:00 -0400
Message-ID: <542421DF.9060000@googlemail.com>
Date: Thu, 25 Sep 2014 16:08:31 +0200
From: =?windows-1252?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] em28xx-input: NULL dereference on error
References: <20140925113941.GB3708@mwanda>
In-Reply-To: <20140925113941.GB3708@mwanda>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

Am 25.09.2014 um 13:39 schrieb Dan Carpenter:
> We call "kfree(ir->i2c_client);" in the error handling and that doesn't
> work if "ir" is NULL.
>
> Fixes: 78e719a5f30b ('[media] em28xx-input: i2c IR decoders: improve i2c_client handling')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
> index 581f6da..23f8f6a 100644
> --- a/drivers/media/usb/em28xx/em28xx-input.c
> +++ b/drivers/media/usb/em28xx/em28xx-input.c
> @@ -712,8 +712,10 @@ static int em28xx_ir_init(struct em28xx *dev)
>  	em28xx_info("Registering input extension\n");
>  
>  	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
> +	if (!ir)
> +		return -ENOMEM;
>  	rc = rc_allocate_device();
> -	if (!ir || !rc)
> +	if (!rc)
>  		goto error;
>  
>  	/* record handles to ourself */
I would prefer to fix it where the actual problem is located.
Can you send an updated version that changes the code to do

...
error:
if (ir)
  kfree(ir->i2c_client);
...

This makes the code less prone to future error handling changes.

Thanks !

Regards,
Frank

