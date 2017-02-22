Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:60053 "EHLO
        aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934429AbdBVUXp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Feb 2017 15:23:45 -0500
Subject: Re: [PATCH 2/3] [media] tc358743: Add OF device ID table
To: Javier Martinez Canillas <javier@osg.samsung.com>
References: <20170222161129.28613-1-javier@osg.samsung.com>
 <20170222161129.28613-2-javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
From: "Mats Randgaard (matrandg)" <matrandg@cisco.com>
Message-ID: <033d29c6-7215-50cb-3e78-6fd005d0fd19@cisco.com>
Date: Wed, 22 Feb 2017 21:11:02 +0100
MIME-Version: 1.0
In-Reply-To: <20170222161129.28613-2-javier@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CC: Philipp Zabel who added device tree support to this driver

Regards,

Mats Randgaard


On 02/22/2017 05:11 PM, Javier Martinez Canillas wrote:
> The driver doesn't have a struct of_device_id table but supported devices
> are registered via Device Trees. This is working on the assumption that a
> I2C device registered via OF will always match a legacy I2C device ID and
> that the MODALIAS reported will always be of the form i2c:<device>.
>
> But this could change in the future so the correct approach is to have an
> OF device ID table if the devices are registered via OF.
>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> ---
>
>   drivers/media/i2c/tc358743.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
>
> diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
> index f569a05fe105..76baf7a7bd57 100644
> --- a/drivers/media/i2c/tc358743.c
> +++ b/drivers/media/i2c/tc358743.c
> @@ -1951,9 +1951,18 @@ static struct i2c_device_id tc358743_id[] = {
>   
>   MODULE_DEVICE_TABLE(i2c, tc358743_id);
>   
> +#if IS_ENABLED(CONFIG_OF)
> +static const struct of_device_id tc358743_of_match[] = {
> +	{ .compatible = "toshiba,tc358743" },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, tc358743_of_match);
> +#endif
> +
>   static struct i2c_driver tc358743_driver = {
>   	.driver = {
>   		.name = "tc358743",
> +		.of_match_table = of_match_ptr(tc358743_of_match),
>   	},
>   	.probe = tc358743_probe,
>   	.remove = tc358743_remove,
