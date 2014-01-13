Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2280 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbaAMSCb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 13:02:31 -0500
Message-ID: <52D42A10.6020007@xs4all.nl>
Date: Mon, 13 Jan 2014 19:01:52 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/2] radio-usb-si4713: make si4713_register_i2c_adapter
 static
References: <1389620181-22601-1-git-send-email-m.chehab@samsung.com> <1389620181-22601-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389620181-22601-2-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/13/2014 02:36 PM, Mauro Carvalho Chehab wrote:
> This function isn't used nowhere outside the same .c file.
> Fixes this warning:
> 
> drivers/media/radio/si4713/radio-usb-si4713.c:418:5: warning: no previous prototype for 'si4713_register_i2c_adapter' [-Wmissing-prototypes]
>  int si4713_register_i2c_adapter(struct si4713_usb_device *radio)
>      ^
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>  drivers/media/radio/si4713/radio-usb-si4713.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/radio/si4713/radio-usb-si4713.c b/drivers/media/radio/si4713/radio-usb-si4713.c
> index d97884494d04..f1e640d71188 100644
> --- a/drivers/media/radio/si4713/radio-usb-si4713.c
> +++ b/drivers/media/radio/si4713/radio-usb-si4713.c
> @@ -415,7 +415,7 @@ static struct i2c_adapter si4713_i2c_adapter_template = {
>  	.algo   = &si4713_algo,
>  };
>  
> -int si4713_register_i2c_adapter(struct si4713_usb_device *radio)
> +static int si4713_register_i2c_adapter(struct si4713_usb_device *radio)
>  {
>  	radio->i2c_adapter = si4713_i2c_adapter_template;
>  	/* set up sysfs linkage to our parent device */
> 

