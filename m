Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47051 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933284AbbCRNcU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 09:32:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	Carlos =?ISO-8859-1?Q?Sanmart=EDn?= Bustos <carsanbu@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v3 2/2] v4l: mt9v032: Add OF support
Date: Wed, 18 Mar 2015 15:32:28 +0200
Message-ID: <2768138.CXiK86JdWh@avalon>
In-Reply-To: <20150315002107.GA11954@valkosipuli.retiisi.org.uk>
References: <1426345057-2752-1-git-send-email-laurent.pinchart@ideasonboard.com> <1426345057-2752-2-git-send-email-laurent.pinchart@ideasonboard.com> <20150315002107.GA11954@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Sunday 15 March 2015 02:21:07 Sakari Ailus wrote:
> On Sat, Mar 14, 2015 at 04:57:37PM +0200, Laurent Pinchart wrote:
> ...
> 
> > diff --git a/Documentation/devicetree/bindings/media/i2c/mt9v032.txt
> > b/Documentation/devicetree/bindings/media/i2c/mt9v032.txt new file mode
> > 100644
> > index 0000000..68b134e
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/i2c/mt9v032.txt
> > @@ -0,0 +1,45 @@
> > +* Aptina 1/3-Inch WVGA CMOS Digital Image Sensor
> > +
> > +The Aptina MT9V032 is a 1/3-inch CMOS active pixel digital image sensor
> > with +an active array size of 752H x 480V. It is programmable through a
> > simple +two-wire serial interface.
> > +
> > +Required Properties:
> > +
> > +- compatible: value should be either one among the following
> > +	(a) "aptina,mt9v022" for MT9V022 color sensor
> > +	(b) "aptina,mt9v022m" for MT9V022 monochrome sensor
> > +	(c) "aptina,mt9v024" for MT9V024 color sensor
> > +	(d) "aptina,mt9v024m" for MT9V024 monochrome sensor
> > +	(e) "aptina,mt9v032" for MT9V032 color sensor
> > +	(f) "aptina,mt9v032m" for MT9V032 monochrome sensor
> > +	(g) "aptina,mt9v034" for MT9V034 color sensor
> > +	(h) "aptina,mt9v034m" for MT9V034 monochrome sensor
> > +
> > +Optional Properties:
> > +
> > +- link-frequencies: List of allowed link frequencies in Hz. Each
> > frequency is +	expressed as a 64-bit big-endian integer.
> > +
> > +For further reading on port node refer to
> > +Documentation/devicetree/bindings/media/video-interfaces.txt.
> > +
> > +Example:
> > +
> > +	i2c0@1c22000 {
> > +		...
> > +		...
> > +		mt9v032@5c {
> > +			compatible = "aptina,mt9v032";
> > +			reg = <0x5c>;
> > +
> > +			port {
> > +				mt9v032_1: endpoint {
> > +					link-frequencies =
> > +						<0 13000000>, <0 26600000>,
> 
> How about:
> 
> /bits/ 64 <13000000> ...

Absolutely.

> > +						<0 27000000>;
> > +				};
> > +			};
> > +		};
> > +		...
> > +	};
> > diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> > index 255ea91..139eeef 100644
> > --- a/drivers/media/i2c/mt9v032.c
> > +++ b/drivers/media/i2c/mt9v032.c

[snip]

> > @@ -876,10 +879,59 @@ static const struct regmap_config
> > mt9v032_regmap_config = {> 
> >   * Driver initialization and probing
> >   */
> > 
> > +static struct mt9v032_platform_data *
> > +mt9v032_get_pdata(struct i2c_client *client)
> > +{
> > +	struct mt9v032_platform_data *pdata;
> > +	struct v4l2_of_endpoint endpoint;
> > +	struct device_node *np;
> > +	struct property *prop;
> > +
> > +	if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
> > +		return client->dev.platform_data;
> > +
> > +	np = of_graph_get_next_endpoint(client->dev.of_node, NULL);
> > +	if (!np)
> > +		return NULL;
> > +
> > +	if (v4l2_of_parse_endpoint(np, &endpoint) < 0)
> > +		goto done;
> > +
> > +	pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
> > +	if (!pdata)
> > +		goto done;
> > +
> > +	prop = of_find_property(np, "link-frequencies", NULL);
> > +	if (prop) {
> > +		size_t size = prop->length / 8;
> > +		u64 *link_freqs;
> > +
> > +		link_freqs = devm_kzalloc(&client->dev,
> > +					  size * sizeof(*link_freqs),
> 
> You could simply use prop->length here. I think that'd look nicer.

How about devm_kcalloc(&client->dev, size, sizeof(*link_freqs)) as this is 
allocating an array ?

> > +					  GFP_KERNEL);
> > +		if (!link_freqs)
> > +			goto done;
> > +
> > +		if (of_property_read_u64_array(np, "link-frequencies",
> > +					       link_freqs, size) < 0)
> > +			goto done;
> > +
> > +		pdata->link_freqs = link_freqs;
> > +		pdata->link_def_freq = link_freqs[0];
> > +	}
> > +
> > +	pdata->clk_pol = !!(endpoint.bus.parallel.flags &
> > +			    V4L2_MBUS_PCLK_SAMPLE_RISING);
> > +
> > +done:
> > +	of_node_put(np);
> > +	return pdata;
> > +}

-- 
Regards,

Laurent Pinchart

