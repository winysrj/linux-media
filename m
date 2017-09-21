Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:6536 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751675AbdIUOSF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 10:18:05 -0400
Date: Thu, 21 Sep 2017 15:17:44 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Wolfram Sang <wsa+renesas@sang-engineering.com>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-renesas-soc@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
Subject: Re: [RFC PATCH v5 6/6] i2c: dev: mark RDWR buffers as DMA_SAFE
Message-ID: <20170921151744.000054d0@huawei.com>
In-Reply-To: <20170920185956.13874-7-wsa+renesas@sang-engineering.com>
References: <20170920185956.13874-1-wsa+renesas@sang-engineering.com>
        <20170920185956.13874-7-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 20 Sep 2017 20:59:56 +0200
Wolfram Sang <wsa+renesas@sang-engineering.com> wrote:

> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Makes sense as do the other drivers.

Feel free to add

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

to all of them (though they hardly took a lot of reviewing given how simple
the patches were :)

> ---
>  drivers/i2c/i2c-dev.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
> index 6f638bbc922db4..bbc7aadb4c899d 100644
> --- a/drivers/i2c/i2c-dev.c
> +++ b/drivers/i2c/i2c-dev.c
> @@ -280,6 +280,8 @@ static noinline int i2cdev_ioctl_rdwr(struct i2c_client *client,
>  			res = PTR_ERR(rdwr_pa[i].buf);
>  			break;
>  		}
> +		/* memdup_user allocates with GFP_KERNEL, so DMA is ok */
> +		rdwr_pa[i].flags |= I2C_M_DMA_SAFE;
>  
>  		/*
>  		 * If the message length is received from the slave (similar
