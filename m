Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58436 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728677AbeJANYq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2018 09:24:46 -0400
Date: Mon, 1 Oct 2018 09:48:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrey Abramov <st5pub@yandex.ru>
Cc: mchehab@kernel.org, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] Staging: media: replaced deprecated probe method
Message-ID: <20181001064813.puc6ky4i55vmgn4q@mwanda>
References: <20180929185150.16657-1-st5pub@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180929185150.16657-1-st5pub@yandex.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 29, 2018 at 09:51:50PM +0300, Andrey Abramov wrote:
> drivers/staging/media/bcm2048/radio-bcm2048.c replaced i2c_driver::probe with i2c_driver::probe_new, because documentation says that i2c_driver::probe "soon to be deprecated"
> 

This needs to be line wrapped at 72 characters.

> Signed-off-by: Andrey Abramov <st5pub@yandex.ru>
> ---
>  drivers/staging/media/bcm2048/radio-bcm2048.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
> index a90b2eb112f9..756f7f08c713 100644
> --- a/drivers/staging/media/bcm2048/radio-bcm2048.c
> +++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
> @@ -2574,8 +2574,7 @@ static const struct video_device bcm2048_viddev_template = {
>  /*
>   *	I2C driver interface
>   */
> -static int bcm2048_i2c_driver_probe(struct i2c_client *client,
> -				    const struct i2c_device_id *id)
> +static int bcm2048_i2c_driver_probe_new(struct i2c_client *client)

Don't rename the function.  Just remove the unused parameter.

regards,
dan carpenter
