Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60508 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751287AbeAYIlM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 03:41:12 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Akash Gajjar <gajjar04akash@gmail.com>
Cc: Akash Gajjar <Akash_Gajjar@mentor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: leds: as3645a: Add CONFIG_OF support
Date: Thu, 25 Jan 2018 10:41:23 +0200
Message-ID: <2323687.o0R8R58l7d@avalon>
In-Reply-To: <1516865677-16006-1-git-send-email-gajjar04akash@gmail.com>
References: <1516865677-16006-1-git-send-email-gajjar04akash@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Akash,

Thank you for the patch.

On Thursday, 25 January 2018 09:34:36 EET Akash Gajjar wrote:
> From: Akash Gajjar <Akash_Gajjar@mentor.com>
> 
> Witth this changes, the driver builds with CONFIG_OF support

Does the driver fail to build with CONFIG_OF at the moment ?

> Signed-off-by: Akash Gajjar <gajjar04akash@gmail.com>
> ---
>  drivers/media/i2c/as3645a.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/media/i2c/as3645a.c b/drivers/media/i2c/as3645a.c
> index af5db71..24233fa 100644
> --- a/drivers/media/i2c/as3645a.c
> +++ b/drivers/media/i2c/as3645a.c
> @@ -858,6 +858,14 @@ static int as3645a_remove(struct i2c_client *client)
>  };
>  MODULE_DEVICE_TABLE(i2c, as3645a_id_table);
> 
> +#if IS_ENABLED(CONFIG_OF)
> +static const struct of_device_id as3645a_of_match[] = {
> +	{ .compatible = "ams,as3645a", },

As far as I know I2C can match the compatible string's device name after the 
comma with the I2C device IDs table without requiring an of_device_id array.

Furthermore, given the following check

        if (client->dev.platform_data == NULL)
                return -ENODEV;

at the beginning of the probe function, I doubt the driver will be functional.

> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(of, as3645a_of_match);
> +#endif
> +
>  static const struct dev_pm_ops as3645a_pm_ops = {
>  	.suspend = as3645a_suspend,
>  	.resume = as3645a_resume,
> @@ -867,6 +875,7 @@ static int as3645a_remove(struct i2c_client *client)
>  	.driver	= {
>  		.name = AS3645A_NAME,
>  		.pm   = &as3645a_pm_ops,
> +		.of_match_table = of_match_ptr(as3645a_of_match),
>  	},
>  	.probe	= as3645a_probe,
>  	.remove	= as3645a_remove,

-- 
Regards,

Laurent Pinchart
