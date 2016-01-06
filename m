Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37385 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176AbcAFL1f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Jan 2016 06:27:35 -0500
Subject: Re: [PATCH 10/10] [media] tvp5150: Configure data interface via pdata
 or DT
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1451910332-23385-1-git-send-email-javier@osg.samsung.com>
 <1451910332-23385-11-git-send-email-javier@osg.samsung.com>
 <1743151.ozK6T8LOF3@avalon>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Enrico Butera <ebutera@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Eduard Gavin <egavinc@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Message-ID: <568CFA1E.6060309@osg.samsung.com>
Date: Wed, 6 Jan 2016 08:27:26 -0300
MIME-Version: 1.0
In-Reply-To: <1743151.ozK6T8LOF3@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent,

Thanks a lot for your feedback.

On 01/06/2016 07:56 AM, Laurent Pinchart wrote:
> Hi Javier,
> 
> Thank you for the patch.
> 
> On Monday 04 January 2016 09:25:32 Javier Martinez Canillas wrote:
>> The video decoder supports either 8-bit 4:2:2 YUV with discrete syncs
>> or 8-bit ITU-R BT.656 with embedded syncs output format but currently
>> BT.656 it's always reported. Allow to configure the format to use via
>> either platform data or a device tree definition.
>>
>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>> ---
>>  drivers/media/i2c/tvp5150.c | 61 ++++++++++++++++++++++++++++++++++++++++--
>>  include/media/i2c/tvp5150.h |  5 ++++
>>  2 files changed, 64 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
>> index fed89a811ab7..8bce45a6e264 100644
>> --- a/drivers/media/i2c/tvp5150.c
>> +++ b/drivers/media/i2c/tvp5150.c
>> @@ -6,6 +6,7 @@
>>   */
>>
>>  #include <linux/of_gpio.h>
>> +#include <linux/of_graph.h>
>>  #include <linux/i2c.h>
>>  #include <linux/slab.h>
>>  #include <linux/videodev2.h>
>> @@ -15,6 +16,7 @@
>>  #include <media/v4l2-device.h>
>>  #include <media/i2c/tvp5150.h>
>>  #include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-of.h>
>>
>>  #include "tvp5150_reg.h"
>>
>> @@ -39,6 +41,7 @@ struct tvp5150 {
>>  	struct media_pad pad;
>>  	struct v4l2_ctrl_handler hdl;
>>  	struct v4l2_rect rect;
>> +	struct tvp5150_platform_data *pdata;
> 
> How about embedding tvp5150_platform_data instead of pointing to it ? It would 
> save an allocation and you could get rid of the pdata != NULL checks.
>

Agreed.
 
>>  	v4l2_std_id norm;	/* Current set standard */
>>  	u32 input;
>> @@ -757,6 +760,7 @@ static int tvp5150_s_std(struct v4l2_subdev *sd,
>> v4l2_std_id std) static int tvp5150_reset(struct v4l2_subdev *sd, u32 val)
>>  {
>>  	struct tvp5150 *decoder = to_tvp5150(sd);
>> +	struct tvp5150_platform_data *pdata = decoder->pdata;
>>
>>  	/* Initializes TVP5150 to its default values */
>>  	tvp5150_write_inittab(sd, tvp5150_init_default);
>> @@ -774,6 +778,10 @@ static int tvp5150_reset(struct v4l2_subdev *sd, u32
>> val) v4l2_ctrl_handler_setup(&decoder->hdl);
>>
>>  	tvp5150_set_std(sd, decoder->norm);
>> +
>> +	if (pdata && pdata->bus_type == V4L2_MBUS_PARALLEL)
>> +		tvp5150_write(sd, TVP5150_DATA_RATE_SEL, 0x40);
>> +
>>  	return 0;
>>  };
>>
>> @@ -940,6 +948,16 @@ static int tvp5150_cropcap(struct v4l2_subdev *sd,
>> struct v4l2_cropcap *a) static int tvp5150_g_mbus_config(struct v4l2_subdev
>> *sd,
>>  				 struct v4l2_mbus_config *cfg)
>>  {
>> +	struct tvp5150_platform_data *pdata = to_tvp5150(sd)->pdata;
>> +
>> +	if (pdata) {
>> +		cfg->type = pdata->bus_type;
>> +		cfg->flags = pdata->parallel_flags;
> 
> The clock and sync signals polarity don't seem configurable, shouldn't they 
> just be hardcoded as currently done ?
>

That's a very good question, I added the flags because according to
Documentation/devicetree/bindings/media/video-interfaces.txt, the way
to define that the output format will be BT.656 is to avoid defining
{hsync,vsync,field-even}-active properties.

IOW, if parallel sync is used, then these properties have to be defined
and it felt strange to not use in the driver what is defined in the DT.

>> +		return 0;
>> +	}
>> +
>> +	/* Default values if no platform data was provided */
>>  	cfg->type = V4L2_MBUS_BT656;
>>  	cfg->flags = V4L2_MBUS_MASTER | V4L2_MBUS_PCLK_SAMPLE_RISING
>>
>>  		   | V4L2_MBUS_FIELD_EVEN_LOW | V4L2_MBUS_DATA_ACTIVE_HIGH;
>>
>> @@ -986,13 +1004,20 @@ static int tvp5150_enum_frame_size(struct v4l2_subdev
>> *sd,
>>
>>  static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
>>  {
>> +	struct tvp5150_platform_data *pdata = to_tvp5150(sd)->pdata;
>> +	/* Output format: 8-bit ITU-R BT.656 with embedded syncs */
>> +	int val = 0x09;
>> +
>> +	/* Output format: 8-bit 4:2:2 YUV with discrete sync */
>> +	if (pdata && pdata->bus_type == V4L2_MBUS_PARALLEL)
>> +		val = 0x0d;
>> +
>>  	/* Initializes TVP5150 to its default values */
>>  	/* # set PCLK (27MHz) */
>>  	tvp5150_write(sd, TVP5150_CONF_SHARED_PIN, 0x00);
>>
>> -	/* Output format: 8-bit ITU-R BT.656 with embedded syncs */
>>  	if (enable)
>> -		tvp5150_write(sd, TVP5150_MISC_CTL, 0x09);
>> +		tvp5150_write(sd, TVP5150_MISC_CTL, val);
>>  	else
>>  		tvp5150_write(sd, TVP5150_MISC_CTL, 0x00);
>>
>> @@ -1228,11 +1253,42 @@ static inline int tvp5150_init(struct i2c_client *c)
>> return 0;
>>  }
>>
>> +static struct tvp5150_platform_data *tvp5150_get_pdata(struct device *dev)
>> +{
>> +	struct tvp5150_platform_data *pdata = dev_get_platdata(dev);
>> +	struct v4l2_of_endpoint bus_cfg;
>> +	struct device_node *ep;
>> +
>> +	if (pdata)
>> +		return pdata;
> 
> Nobody uses platform data today, I wonder whether we shouldn't postpone adding 
> support for it until we have a use case. Embedded systems (at least the ARM-
> based ones) should use DT.
>

Yes, I just added it for completeness since in other subsystems I've been
yelled in the past that not all the world is DT and that I needed a pdata :)

But I'll gladly remove it since it means less code which is always good.

>> +	if (IS_ENABLED(CONFIG_OF) && dev->of_node) {
>> +		pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
>> +		if (!pdata)
>> +			return NULL;
>> +
>> +		ep = of_graph_get_next_endpoint(dev->of_node, NULL);
>> +		if (!ep)
>> +			return NULL;
>> +
>> +		v4l2_of_parse_endpoint(ep, &bus_cfg);
> 
> Shouldn't you check the return value of the function ?
>

Right, the v4l2_of_parse_endpoint() kernel doc says "Return: 0." and most
drivers are not checking the return value so I thought that it couldn't
fail. But now looking at the implementation I see that's not true so I'll
add a check in v2.

I'll also post patches to update v4l2_of_parse_endpoint() kernel-doc and
the drivers that are not currently checking for this return value.

>> +
>> +		pdata->bus_type = bus_cfg.bus_type;
>> +		pdata->parallel_flags = bus_cfg.bus.parallel.flags;
> 
> The V4L2_MBUS_DATA_ACTIVE_HIGH flags set returned by tvp5150_g_mbus_config() 
> when pdata is NULL is never set by v4l2_of_parse_endpoint(), should you add it 
> unconditionally ?
>

But v4l2_of_parse_endpoint() calls v4l2_of_parse_parallel_bus() which does
it or did I read the code incorrectly?

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
