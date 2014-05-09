Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4697 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359AbaEIIlH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 May 2014 04:41:07 -0400
Message-ID: <536C948B.8080106@xs4all.nl>
Date: Fri, 09 May 2014 10:40:43 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>,
	m.chehab@samsung.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/5] em28xx: fix i2c_set_adapdata() call in em28xx_i2c_register()
References: <1395493263-2158-1-git-send-email-fschaefer.oss@googlemail.com> <1395493263-2158-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1395493263-2158-2-git-send-email-fschaefer.oss@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Frank,

I've got a comment about this patch:

On 03/22/2014 02:01 PM, Frank Schäfer wrote:
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/usb/em28xx/em28xx-i2c.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
> index ba6433c..04e8577 100644
> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
> @@ -939,7 +939,7 @@ int em28xx_i2c_register(struct em28xx *dev, unsigned bus,
>  	dev->i2c_bus[bus].algo_type = algo_type;
>  	dev->i2c_bus[bus].dev = dev;
>  	dev->i2c_adap[bus].algo_data = &dev->i2c_bus[bus];
> -	i2c_set_adapdata(&dev->i2c_adap[bus], &dev->v4l2_dev);
> +	i2c_set_adapdata(&dev->i2c_adap[bus], dev);

As far as I can see nobody is calling i2c_get_adapdata. Should this line be removed
altogether?

If it is used somewhere, can you point me that?

I'm taking the other patches from this series (using the v2 version of patch 4/5) since
those look fine.

Regards,

	Hans

>  
>  	retval = i2c_add_adapter(&dev->i2c_adap[bus]);
>  	if (retval < 0) {
> 

