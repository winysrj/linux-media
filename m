Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40098 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaLIIHE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Dec 2014 03:07:04 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com,
	linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
	devicetree@vger.kernel.org
Subject: Re: [PATCH 3/5] media: ov2640: add primary dt support
Date: Tue, 09 Dec 2014 10:07:47 +0200
Message-ID: <4259882.xUnFntZnaF@avalon>
In-Reply-To: <54866809.7020402@atmel.com>
References: <1418038147-13221-1-git-send-email-josh.wu@atmel.com> <13013762.Jqm1jQRnFM@avalon> <54866809.7020402@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

On Tuesday 09 December 2014 11:10:01 Josh Wu wrote:
> On 12/9/2014 2:39 AM, Laurent Pinchart wrote:
> > Hi Josh,
> > 
> > Thank you for the patch.
> > 
> > On Monday 08 December 2014 19:29:05 Josh Wu wrote:
> >> Add device tree support for ov2640.
> >> 
> >> Cc: devicetree@vger.kernel.org
> >> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> >> ---
> >> 
> >> v1 -> v2:
> >>    1. use gpiod APIs.
> >>    2. change the gpio pin's name according to datasheet.
> >>    3. reduce the delay for .reset() function.
> >>   
> >>   drivers/media/i2c/soc_camera/ov2640.c | 86 +++++++++++++++++++++++++---
> >>   1 file changed, 80 insertions(+), 6 deletions(-)
> >> 
> >> diff --git a/drivers/media/i2c/soc_camera/ov2640.c
> >> b/drivers/media/i2c/soc_camera/ov2640.c index 9ee910d..2a57979 100644
> >> --- a/drivers/media/i2c/soc_camera/ov2640.c
> >> +++ b/drivers/media/i2c/soc_camera/ov2640.c

[snip]

> >> +static int ov2640_probe_dt(struct i2c_client *client,
> >> +		struct ov2640_priv *priv)
> >> +{
> >> +	priv->resetb_gpio = devm_gpiod_get_optional(&client->dev, "resetb",
> >> +			GPIOD_OUT_HIGH);
> >> +	if (!priv->resetb_gpio)
> >> +		dev_warn(&client->dev, "resetb gpio not found!\n");
> > 
> > No need to warn here, it's perfectly fine if the reset signal isn't
> > connected to a GPIO.
> 
> I want to print some information if no GPIO is assigned. So I'd like use
> dev_dbg() here.
> What do you feel?

If you want to print a message in that case dev_dbg is the most appropriate 
log level. I would skip it completely, but that's up to you.

> >> +	else if (IS_ERR(priv->resetb_gpio))
> >> +		return -EINVAL;
> >> +
> >> +	priv->pwdn_gpio = devm_gpiod_get_optional(&client->dev, "pwdn",
> >> +			GPIOD_OUT_HIGH);
> >> +	if (!priv->pwdn_gpio)
> >> +		dev_warn(&client->dev, "pwdn gpio not found!\n");
> > 
> > Same here.
> 
> ditto.
> 
> >> +	else if (IS_ERR(priv->pwdn_gpio))
> >> +		return -EINVAL;
> >> +
> >> +	/* Initialize the soc_camera_subdev_desc */
> >> +	priv->ssdd_dt.power = ov2640_hw_power;
> >> +	priv->ssdd_dt.reset = ov2640_hw_reset;
> >> +	client->dev.platform_data = &priv->ssdd_dt;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >>   /*
> >>    * i2c_driver functions
> >>    */

-- 
Regards,

Laurent Pinchart

