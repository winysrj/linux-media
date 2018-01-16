Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33577 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751259AbeAPLpo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 06:45:44 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, festevam@gmail.com,
        sakari.ailus@iki.fi, robh+dt@kernel.org, mark.rutland@arm.com,
        pombredanne@nexb.com, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 6/9] media: i2c: ov772x: Remove soc_camera dependencies
Date: Tue, 16 Jan 2018 13:45:47 +0200
Message-ID: <3160666.n1yGRyzbCt@avalon>
In-Reply-To: <d0249577-ebd5-aa4d-b017-c11fae9c612a@xs4all.nl>
References: <1515765849-10345-1-git-send-email-jacopo+renesas@jmondi.org> <1515765849-10345-7-git-send-email-jacopo+renesas@jmondi.org> <d0249577-ebd5-aa4d-b017-c11fae9c612a@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tuesday, 16 January 2018 12:08:17 EET Hans Verkuil wrote:
> On 01/12/2018 03:04 PM, Jacopo Mondi wrote:
> > Remove soc_camera framework dependencies from ov772x sensor driver.
> > - Handle clock and gpios
> > - Register async subdevice
> > - Remove soc_camera specific g/s_mbus_config operations
> > - Change image format colorspace from JPEG to SRGB as the two use the
> > 
> >   same colorspace information but JPEG makes assumptions on color
> >   components quantization that do not apply to the sensor
> > 
> > - Remove sizes crop from get_selection as driver can't scale
> > - Add kernel doc to driver interface header file
> > - Adjust build system
> > 
> > This commit does not remove the original soc_camera based driver as long
> > as other platforms depends on soc_camera-based CEU driver.
> > 
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/i2c/Kconfig  |  11 +++
> >  drivers/media/i2c/Makefile |   1 +
> >  drivers/media/i2c/ov772x.c | 177 ++++++++++++++++++++++++++++------------
> >  include/media/i2c/ov772x.h |   6 +-
> >  4 files changed, 133 insertions(+), 62 deletions(-)

[snip]

> > diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> > index 8063835..df2516c 100644
> > --- a/drivers/media/i2c/ov772x.c
> > +++ b/drivers/media/i2c/ov772x.c

[snip]

> > @@ -1038,12 +1074,11 @@ static int ov772x_probe(struct i2c_client *client,
> >  			const struct i2c_device_id *did)
> >  {
> >  	struct ov772x_priv	*priv;
> > -	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
> > -	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
> > +	struct i2c_adapter	*adapter = client->adapter;
> >  	int			ret;
> > 
> > -	if (!ssdd || !ssdd->drv_priv) {
> > -		dev_err(&client->dev, "OV772X: missing platform data!\n");
> > +	if (!client->dev.platform_data) {
> > +		dev_err(&client->dev, "Missing OV7725 platform data\n");
> 
> Nitpick: I'd prefer lowercase in this string: ov7725. It also should be
> ov772x.

Agreed.

> >  		return -EINVAL;
> >  	
> >  	}

[snip]

> > @@ -1119,6 +1176,6 @@ static struct i2c_driver ov772x_i2c_driver = {
> > 
> >  module_i2c_driver(ov772x_i2c_driver);
> > 
> > -MODULE_DESCRIPTION("SoC Camera driver for ov772x");
> > +MODULE_DESCRIPTION("V4L2 driver for OV772x image sensor");
> 
> Ditto: lower case ov772x.

I'd keep that uppercase. The usual practice (unless I'm mistaken) is to use 
uppercase for chip names and lowercase for driver names. The description 
clearly refers to the chip, so uppercase seems better to me.

> >  MODULE_AUTHOR("Kuninori Morimoto");
> >  MODULE_LICENSE("GPL v2");
> 
> Hmm, shouldn't there be a struct of_device_id as well? So this can be
> used in the device tree?
> 
> I see this sensor was only tested with a non-dt platform. Is it possible
> to test this sensor with the GR-Peach platform (which I gather uses the
> device tree)?
> 
> Making this driver DT compliant can be done as a follow-up patch.

I think it's a good idea, but I'd prefer having that in a separate patch. We 
will also need DT bindings, it's a bit out of scope for this series.

Jacopo, you can keep my ack after addressing Hans' comments.

-- 
Regards,

Laurent Pinchart
