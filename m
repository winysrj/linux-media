Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:37356 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752691AbdK2LZl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 06:25:41 -0500
Date: Wed, 29 Nov 2017 12:25:37 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [RFC] v4l: i2c: ov7670: Implement mbus configuration
Message-ID: <20171129112537.GC17767@w540>
References: <1511778413-27348-1-git-send-email-jacopo+renesas@jmondi.org>
 <20171129110430.rqydysqrfaxu7ufc@valkosipuli.retiisi.org.uk>
 <20171129110648.vkqj2ijnryuhl4dq@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20171129110648.vkqj2ijnryuhl4dq@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,
   thanks for the reply

On Wed, Nov 29, 2017 at 01:06:49PM +0200, Sakari Ailus wrote:
> On Wed, Nov 29, 2017 at 01:04:30PM +0200, Sakari Ailus wrote:
> > Hi Jacopo,
> >
> > On Mon, Nov 27, 2017 at 11:26:53AM +0100, Jacopo Mondi wrote:
> > > ov7670 currently supports configuration of a few parameters only through
> > > platform data. Implement media bus configuration by parsing DT properties
> > > at probe() time and opportunely configure REG_COM10 during s_format().
> > >
> > > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > >
> > > ---
> > >
> > > Hi linux-media,
> > >    I'm using this sensor to test the CEU driver I have submitted some time ago
> > > and I would like to change synchronization signal polarities to test them in
> > > combination with that driver.
> > >
> > > So I added support for retrieving some properties listed in the device tree
> > > bindings documentation from sensor's DT node and made a patch, BUT I'm
> > > slightly confused about this (and that's why this is an RFC).
> > >
> > > I did a grep for "sync-active" in drivers/media/i2c/ and no sensor driver
> > > implements any property parsing, so I guess I'm doing something wrong here.
> >
> > :-)
> >
> > The standard properties are parsed in the V4L2 fwnode framework, and
> > gathered to v4l2_fwnode_endpoint struct for drivers to use. Please see e.g.
> > the smiapp driver how to do this.
> >
> > You'll still need to parse device specific properties in the driver.

I totally misinterpreted this!

My understanding was that v4l2_fwnode_endpoint_parse() was supposed to
be used to parse the -remote- endpoint configuration, so that a
platform driver would know how the sensor is configured and adjust its
settings accordingly (and eventually configure the remote endpoint with
s_mbus_confi()).

Instead, if I got this right, -both- sensor and platform parse
their own endpoints, and they don't care how the remote is configured
because of, as you said, wirings..

I'm going to re-submit this using the v4l2_fwnode framework utilities
in the sensor driver!

Thanks for the clarification
   j

> >
> > >
> > > I thought that maybe sensor media bus configuration should come from the
> > > platform driver, through the s_mbus_config() operation in v4l2_subdev_video_ops,
>
> It's specified in the sensor's local endpoint. The corresponding
> configuration needs to be present in the remote endpoint. These are not
> necessarily always the same due to e.g. wiring.
>
> > > but that's said to be deprecated. So maybe is the framework providing support
> > > for parsing those properties? Another grep there and I found only v4l2-fwnode.c
> > > has support for parsing serial/parallel bus properties, but my understanding is
> > > that those functions are meant to be used by the platform driver when
> > > parsing the remote fw node.
> > >
> > > So please help me out here: where should I implement media bus configuration
> > > for sensor drivers?
> > >
> > > Thanks
> > >    j
> > >
> > > PS: being this just an RFC I have not updated dt bindings, and only
> > > compile-tested the patch
> > >
> > > ---
> > >  drivers/media/i2c/ov7670.c | 108 ++++++++++++++++++++++++++++++++++++++++++---
> > >  1 file changed, 101 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
> > > index e88549f..7e2de7e 100644
> > > --- a/drivers/media/i2c/ov7670.c
> > > +++ b/drivers/media/i2c/ov7670.c
> > > @@ -88,6 +88,7 @@ MODULE_PARM_DESC(debug, "Debug level (0-1)");
> > >  #define REG_COM10	0x15	/* Control 10 */
> > >  #define   COM10_HSYNC	  0x40	  /* HSYNC instead of HREF */
> > >  #define   COM10_PCLK_HB	  0x20	  /* Suppress PCLK on horiz blank */
> > > +#define   COM10_PCLK_REV  0x10	  /* Latch data on PCLK rising edge */
> > >  #define   COM10_HREF_REV  0x08	  /* Reverse HREF */
> > >  #define   COM10_VS_LEAD	  0x04	  /* VSYNC on clock leading edge */
> > >  #define   COM10_VS_NEG	  0x02	  /* VSYNC negative */
> > > @@ -233,6 +234,7 @@ struct ov7670_info {
> > >  	struct clk *clk;
> > >  	struct gpio_desc *resetb_gpio;
> > >  	struct gpio_desc *pwdn_gpio;
> > > +	unsigned int mbus_config;	/* Media bus configuration flags */
> > >  	int min_width;			/* Filter out smaller sizes */
> > >  	int min_height;			/* Filter out smaller sizes */
> > >  	int clock_speed;		/* External clock speed (MHz) */
> > > @@ -985,7 +987,7 @@ static int ov7670_set_fmt(struct v4l2_subdev *sd,
> > >  	struct ov7670_format_struct *ovfmt;
> > >  	struct ov7670_win_size *wsize;
> > >  	struct ov7670_info *info = to_state(sd);
> > > -	unsigned char com7;
> > > +	unsigned char com7, com10;
> > >  	int ret;
> > >
> > >  	if (format->pad)
> > > @@ -1021,6 +1023,9 @@ static int ov7670_set_fmt(struct v4l2_subdev *sd,
> > >  	ret = 0;
> > >  	if (wsize->regs)
> > >  		ret = ov7670_write_array(sd, wsize->regs);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > >  	info->fmt = ovfmt;
> > >
> > >  	/*
> > > @@ -1033,8 +1038,26 @@ static int ov7670_set_fmt(struct v4l2_subdev *sd,
> > >  	 * to write it unconditionally, and that will make the frame
> > >  	 * rate persistent too.
> > >  	 */
> > > -	if (ret == 0)
> > > -		ret = ov7670_write(sd, REG_CLKRC, info->clkrc);
> > > +	ret = ov7670_write(sd, REG_CLKRC, info->clkrc);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	/* Configure the media bus after the image format */
> > > +	com10 = 0;
> > > +	if (info->mbus_config & V4L2_MBUS_VSYNC_ACTIVE_LOW)
> > > +		com10 |= COM10_VS_NEG;
> > > +	if (info->mbus_config & V4L2_MBUS_HSYNC_ACTIVE_LOW)
> > > +		com10 |= COM10_HS_NEG;
> > > +	if (info->mbus_config & V4L2_MBUS_PCLK_SAMPLE_RISING)
> > > +		com10 |= COM10_PCLK_REV;
> > > +	if (info->pclk_hb_disable)
> > > +		com10 |= COM10_PCLK_HB;
> > > +
> > > +	if (com10)
> > > +		ret = ov7670_write(sd, REG_COM10, com10);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > >  	return 0;
> > >  }
> > >
> > > @@ -1572,6 +1595,29 @@ static int ov7670_init_gpio(struct i2c_client *client, struct ov7670_info *info)
> > >  	return 0;
> > >  }
> > >
> > > +/**
> > > + * ov7670_parse_dt_prop() - parse property "prop_name" in OF node
> > > + *
> > > + * @return The property value or < 0 if property not present
> > > + *	   or wrongly specified.
> > > + */
> > > +static int ov7670_parse_dt_prop(struct device *dev, char *prop_name)
> > > +{
> > > +	struct device_node *np = dev->of_node;
> > > +	u32 prop_val;
> > > +	int ret;
> > > +
> > > +	ret = of_property_read_u32(np, prop_name, &prop_val);
> > > +	if (ret) {
> > > +		if (ret != -EINVAL)
> > > +			dev_err(dev, "Unable to parse property %s: %d\n",
> > > +				prop_name, ret);
> > > +		return ret;
> > > +	}
> > > +
> > > +	return prop_val;
> > > +}
> > > +
> > >  static int ov7670_probe(struct i2c_client *client,
> > >  			const struct i2c_device_id *id)
> > >  {
> > > @@ -1587,7 +1633,58 @@ static int ov7670_probe(struct i2c_client *client,
> > >  	v4l2_i2c_subdev_init(sd, client, &ov7670_ops);
> > >
> > >  	info->clock_speed = 30; /* default: a guess */
> > > -	if (client->dev.platform_data) {
> > > +
> > > +	if (IS_ENABLED(CONFIG_OF) && client->dev.of_node) {
> > > +		/*
> > > +		 * Parse OF properties to initialize media bus configuration.
> > > +		 *
> > > +		 * Use sensor's default configuration if a property is not
> > > +		 * specified (ret == -EINVAL):
> > > +		 */
> > > +		info->mbus_config = 0;
> > > +
> > > +		ret = ov7670_parse_dt_prop(&client->dev, "hsync-active");
> > > +		if (ret < 0 && ret != -EINVAL)
> > > +			return ret;
> > > +		else if (ret == 0)
> > > +			info->mbus_config |= V4L2_MBUS_HSYNC_ACTIVE_LOW;
> > > +		else
> > > +			info->mbus_config |= V4L2_MBUS_HSYNC_ACTIVE_HIGH;
> > > +
> > > +		ret = ov7670_parse_dt_prop(&client->dev, "vsync-active");
> > > +		if (ret < 0 && ret != -EINVAL)
> > > +			return ret;
> > > +		else if (ret == 0)
> > > +			info->mbus_config |= V4L2_MBUS_VSYNC_ACTIVE_LOW;
> > > +		else
> > > +			info->mbus_config |= V4L2_MBUS_VSYNC_ACTIVE_HIGH;
> > > +
> > > +		ret = ov7670_parse_dt_prop(&client->dev, "pclk-sample");
> > > +		if (ret < 0 && ret != -EINVAL)
> > > +			return ret;
> > > +		else if (ret > 0)
> > > +			info->mbus_config |= V4L2_MBUS_PCLK_SAMPLE_RISING;
> > > +		else
> > > +			info->mbus_config |= V4L2_MBUS_PCLK_SAMPLE_FALLING;
> > > +
> > > +		ret = ov7670_parse_dt_prop(&client->dev,
> > > +					    "ov7670,pclk-hb-disable");
> > > +		if (ret < 0 && ret != -EINVAL)
> > > +			return ret;
> > > +		else if (ret > 0)
> > > +			info->pclk_hb_disable = true;
> > > +		else
> > > +			info->pclk_hb_disable = false;
> > > +
> > > +		ret = ov7670_parse_dt_prop(&client->dev, "ov7670,pll-bypass");
> > > +		if (ret < 0 && ret != -EINVAL)
> > > +			return ret;
> > > +		else if (ret > 0)
> > > +			info->pll_bypass = true;
> > > +		else
> > > +			info->pll_bypass = false;
> > > +
> > > +	} else if (client->dev.platform_data) {
> > >  		struct ov7670_config *config = client->dev.platform_data;
> > >
> > >  		/*
> > > @@ -1649,9 +1746,6 @@ static int ov7670_probe(struct i2c_client *client,
> > >  	tpf.denominator = 30;
> > >  	info->devtype->set_framerate(sd, &tpf);
> > >
> > > -	if (info->pclk_hb_disable)
> > > -		ov7670_write(sd, REG_COM10, COM10_PCLK_HB);
> > > -
> > >  	v4l2_ctrl_handler_init(&info->hdl, 10);
> > >  	v4l2_ctrl_new_std(&info->hdl, &ov7670_ctrl_ops,
> > >  			V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
> > > --
> > > 2.7.4
> > >
> >
> > --
> > Sakari Ailus
> > e-mail: sakari.ailus@iki.fi
>
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi
