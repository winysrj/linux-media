Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53447 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751862AbdHIK3w (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Aug 2017 06:29:52 -0400
Subject: Re: [PATCH] media: i2c: adv748x: Export I2C device table entries as
 module aliases
To: Javier Martinez Canillas <javierm@redhat.com>,
        linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
References: <20170809093731.3572-1-javierm@redhat.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <e446df61-defc-4c9e-0f5a-d7afce878156@ideasonboard.com>
Date: Wed, 9 Aug 2017 11:29:47 +0100
MIME-Version: 1.0
In-Reply-To: <20170809093731.3572-1-javierm@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Thankyou for the patch

On 09/08/17 10:37, Javier Martinez Canillas wrote:
> The I2C core always reports a MODALIAS of the form i2c:<foo> even if the
> device was registered via OF, and the driver is only exporting the OF ID
> table entries as module aliases.
> 
> So if the driver is built as module, autoload won't work since udev/kmod
> won't be able to match the registered OF device with its driver module.

Good catch, and perhaps I should have known better :D

I've only worked on this driver as a built-in so far :-) #BadExcuses

> Before this patch:
> 
> $ modinfo drivers/media/i2c/adv748x/adv748x.ko | grep alias
> alias:          of:N*T*Cadi,adv7482C*
> alias:          of:N*T*Cadi,adv7482
> alias:          of:N*T*Cadi,adv7481C*
> alias:          of:N*T*Cadi,adv7481
> 
> After this patch:
> 
> modinfo drivers/media/i2c/adv748x/adv748x.ko | grep alias
> alias:          of:N*T*Cadi,adv7482C*
> alias:          of:N*T*Cadi,adv7482
> alias:          of:N*T*Cadi,adv7481C*
> alias:          of:N*T*Cadi,adv7481
> alias:          i2c:adv7482
> alias:          i2c:adv7481
> 
> Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
> 
>  drivers/media/i2c/adv748x/adv748x-core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> index aeb6ae80cb18..5ee14f2c2747 100644
> --- a/drivers/media/i2c/adv748x/adv748x-core.c
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -807,6 +807,7 @@ static const struct i2c_device_id adv748x_id[] = {
>  	{ "adv7482", 0 },
>  	{ },
>  };
> +MODULE_DEVICE_TABLE(i2c, adv748x_id);
>  
>  static const struct of_device_id adv748x_of_table[] = {
>  	{ .compatible = "adi,adv7481", },
> 
