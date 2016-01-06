Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38209 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbcAFNsa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jan 2016 08:48:30 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Enrico Butera <ebutera@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Eduard Gavin <egavinc@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 10/10] [media] tvp5150: Configure data interface via pdata or DT
Date: Wed, 06 Jan 2016 15:48 +0200
Message-ID: <1895052.dqIgFQaCHk@avalon>
In-Reply-To: <568CFA1E.6060309@osg.samsung.com>
References: <1451910332-23385-1-git-send-email-javier@osg.samsung.com> <1743151.ozK6T8LOF3@avalon> <568CFA1E.6060309@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Wednesday 06 January 2016 08:27:26 Javier Martinez Canillas wrote:
> On 01/06/2016 07:56 AM, Laurent Pinchart wrote:
> > On Monday 04 January 2016 09:25:32 Javier Martinez Canillas wrote:
> >> The video decoder supports either 8-bit 4:2:2 YUV with discrete syncs
> >> or 8-bit ITU-R BT.656 with embedded syncs output format but currently
> >> BT.656 it's always reported. Allow to configure the format to use via
> >> either platform data or a device tree definition.
> >> 
> >> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> >> ---
> >> 
> >>  drivers/media/i2c/tvp5150.c | 61 +++++++++++++++++++++++++++++++++++++--
> >>  include/media/i2c/tvp5150.h |  5 ++++
> >>  2 files changed, 64 insertions(+), 2 deletions(-)
> >> 
> >> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> >> index fed89a811ab7..8bce45a6e264 100644
> >> --- a/drivers/media/i2c/tvp5150.c
> >> +++ b/drivers/media/i2c/tvp5150.c

[snip]

> >> @@ -940,6 +948,16 @@ static int tvp5150_cropcap(struct v4l2_subdev *sd,
> >> struct v4l2_cropcap *a)
> >>  static int tvp5150_g_mbus_config(struct v4l2_subdev *sd,
> >>  				 struct v4l2_mbus_config *cfg)
> >>  {
> >> +	struct tvp5150_platform_data *pdata = to_tvp5150(sd)->pdata;
> >> +
> >> +	if (pdata) {
> >> +		cfg->type = pdata->bus_type;
> >> +		cfg->flags = pdata->parallel_flags;
> > 
> > The clock and sync signals polarity don't seem configurable, shouldn't
> > they just be hardcoded as currently done ?
> 
> That's a very good question, I added the flags because according to
> Documentation/devicetree/bindings/media/video-interfaces.txt, the way
> to define that the output format will be BT.656 is to avoid defining
> {hsync,vsync,field-even}-active properties.
> 
> IOW, if parallel sync is used, then these properties have to be defined
> and it felt strange to not use in the driver what is defined in the DT.

In that case we should restrict the values of the properties to what the 
hardware actually supports. I would hardcode the flags here, and check them 
when parsing the endpoint to make sure they're valid.

If you find a register I have missed in the documentation with which 
polarities could be configured then please also feel free to prove me wrong 
:-)

> >> +		return 0;
> >> +	}
> >> +
> >> +	/* Default values if no platform data was provided */
> >>  	cfg->type = V4L2_MBUS_BT656;
> >>  	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_PCLK_SAMPLE_RISING
> >>  		   | V4L2_MBUS_FIELD_EVEN_LOW | V4L2_MBUS_DATA_ACTIVE_HIGH;

[snip]

> >> @@ -1228,11 +1253,42 @@ static inline int tvp5150_init(struct i2c_client
> >> *c) return 0;
> >> 
> >>  }
> >> 
> >> +static struct tvp5150_platform_data *tvp5150_get_pdata(struct device
> >> *dev)
> >> +{
> >> +	struct tvp5150_platform_data *pdata = dev_get_platdata(dev);
> >> +	struct v4l2_of_endpoint bus_cfg;
> >> +	struct device_node *ep;
> >> +
> >> +	if (pdata)
> >> +		return pdata;
> > 
> > Nobody uses platform data today, I wonder whether we shouldn't postpone
> > adding support for it until we have a use case. Embedded systems (at
> > least the ARM- based ones) should use DT.
> 
> Yes, I just added it for completeness since in other subsystems I've been
> yelled in the past that not all the world is DT and that I needed a pdata :)
> 
> But I'll gladly remove it since it means less code which is always good.
> 
> >> +	if (IS_ENABLED(CONFIG_OF) && dev->of_node) {
> >> +		pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> >> +		if (!pdata)
> >> +			return NULL;
> >> +
> >> +		ep = of_graph_get_next_endpoint(dev->of_node, NULL);
> >> +		if (!ep)
> >> +			return NULL;
> >> +
> >> +		v4l2_of_parse_endpoint(ep, &bus_cfg);
> > 
> > Shouldn't you check the return value of the function ?
> 
> Right, the v4l2_of_parse_endpoint() kernel doc says "Return: 0." and most
> drivers are not checking the return value so I thought that it couldn't
> fail. But now looking at the implementation I see that's not true so I'll
> add a check in v2.
> 
> I'll also post patches to update v4l2_of_parse_endpoint() kernel-doc and
> the drivers that are not currently checking for this return value.

Thank you for that.

> >> +
> >> +		pdata->bus_type = bus_cfg.bus_type;
> >> +		pdata->parallel_flags = bus_cfg.bus.parallel.flags;
> > 
> > The V4L2_MBUS_DATA_ACTIVE_HIGH flags set returned by
> > tvp5150_g_mbus_config() when pdata is NULL is never set by
> > v4l2_of_parse_endpoint(), should you add it unconditionally ?
> 
> But v4l2_of_parse_endpoint() calls v4l2_of_parse_parallel_bus() which does
> it or did I read the code incorrectly?

No, you're right, I had overlooked the V4L2_MBUS_DATA_ACTIVE_HIGH flag when 
reading v4l2_of_parse_parallel_bus(), probably a typo when searching. Please 
ignore that comment.

-- 
Regards,

Laurent Pinchart

