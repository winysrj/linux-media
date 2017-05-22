Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:52102 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752638AbdEVHpi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 May 2017 03:45:38 -0400
Subject: Re: [media-pci-cx25821] question about value overwrite
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20170518170709.Horde.zKHvDFB0L61Od1t7GtHytpR@gator4166.hostgator.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b170bdc6-8c36-936a-a960-2dcde3b64bc5@xs4all.nl>
Date: Mon, 22 May 2017 09:45:31 +0200
MIME-Version: 1.0
In-Reply-To: <20170518170709.Horde.zKHvDFB0L61Od1t7GtHytpR@gator4166.hostgator.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/19/2017 12:07 AM, Gustavo A. R. Silva wrote:
> 
> Hello everybody,
> 
> While looking into Coverity ID 1226903 I ran into the following piece  
> of code at drivers/media/pci/cx25821/cx25821-medusa-video.c:393:
> 
> 393int medusa_set_videostandard(struct cx25821_dev *dev)
> 394{
> 395        int status = 0;
> 396        u32 value = 0, tmp = 0;
> 397
> 398        if (dev->tvnorm & V4L2_STD_PAL_BG || dev->tvnorm & V4L2_STD_PAL_DK)
> 399                status = medusa_initialize_pal(dev);
> 400        else
> 401                status = medusa_initialize_ntsc(dev);
> 402
> 403        /* Enable DENC_A output */
> 404        value = cx25821_i2c_read(&dev->i2c_bus[0], DENC_A_REG_4, &tmp);
> 405        value = setBitAtPos(value, 4);
> 406        status = cx25821_i2c_write(&dev->i2c_bus[0], DENC_A_REG_4, value);
> 407
> 408        /* Enable DENC_B output */
> 409        value = cx25821_i2c_read(&dev->i2c_bus[0], DENC_B_REG_4, &tmp);
> 410        value = setBitAtPos(value, 4);
> 411        status = cx25821_i2c_write(&dev->i2c_bus[0], DENC_B_REG_4, value);
> 412
> 413        return status;
> 414}
> 
> The issue is that the value stored in variable _status_ at lines 399  
> and 401 is overwritten by the one stored at line 406 and then at line  
> 411, before it can be used.
> 
> My question is if the original intention was to ORed the return  
> values, something like in the following patch:
> 
> index 0a9db05..226d14f 100644
> --- a/drivers/media/pci/cx25821/cx25821-medusa-video.c
> +++ b/drivers/media/pci/cx25821/cx25821-medusa-video.c
> @@ -403,12 +403,12 @@ int medusa_set_videostandard(struct cx25821_dev *dev)
>          /* Enable DENC_A output */
>          value = cx25821_i2c_read(&dev->i2c_bus[0], DENC_A_REG_4, &tmp);
>          value = setBitAtPos(value, 4);
> -       status = cx25821_i2c_write(&dev->i2c_bus[0], DENC_A_REG_4, value);
> +       status |= cx25821_i2c_write(&dev->i2c_bus[0], DENC_A_REG_4, value);
> 
>          /* Enable DENC_B output */
>          value = cx25821_i2c_read(&dev->i2c_bus[0], DENC_B_REG_4, &tmp);
>          value = setBitAtPos(value, 4);
> -       status = cx25821_i2c_write(&dev->i2c_bus[0], DENC_B_REG_4, value);
> +       status |= cx25821_i2c_write(&dev->i2c_bus[0], DENC_B_REG_4, value);
> 
>          return status;
>   }

This is a crappy driver, they just couldn't be bothered to check the error from
cx25821_i2c_read/write.

Strictly speaking the return value should be checked after every read/write and
returned in case of an error.

Not sure whether it is worth the effort fixing this.

Regards,

	Hans

> 
> What do you think?
> 
> I'd really appreciate any comment on this.
> 
> Thank you!
> --
> Gustavo A. R. Silva
> 
> 
> 
> 
