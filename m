Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39595 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab3H0Lun (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Aug 2013 07:50:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH v7] s5k5baf: add camera sensor driver
Date: Tue, 27 Aug 2013 13:52:04 +0200
Message-ID: <1424546.lJXUZLPMUj@avalon>
In-Reply-To: <521B4B4D.50209@samsung.com>
References: <1377096091-7284-1-git-send-email-a.hajda@samsung.com> <1544715.uKei6kdjbJ@avalon> <521B4B4D.50209@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrejz,

On Monday 26 August 2013 14:34:21 Andrzej Hajda wrote:
> On 08/23/2013 02:53 PM, Laurent Pinchart wrote:
> > On Wednesday 21 August 2013 16:41:31 Andrzej Hajda wrote:
> >> Driver for Samsung S5K5BAF UXGA 1/5" 2M CMOS Image Sensor
> >> with embedded SoC ISP.
> >> The driver exposes the sensor as two V4L2 subdevices:
> >> - S5K5BAF-CIS - pure CMOS Image Sensor, fixed 1600x1200 format,
> >>   no controls.
> >> 
> >> - S5K5BAF-ISP - Image Signal Processor, formats up to 1600x1200,
> >>   pre/post ISP cropping, downscaling via selection API, controls.
> >> 
> >> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> >> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> ---
> >> Hi,
> >> 
> >> This patch incorporates Stephen's suggestions, thanks.
> >> 
> >> Regards
> >> Andrzej
> >> 
> >> v7
> >> - changed description of 'clock-frequency' DT property
> >> 
> >> v6
> >> - endpoint node presence is now optional,
> >> - added asynchronous subdev registration support and clock
> >> 
> >>   handling,
> >> 
> >> - use named gpios in DT bindings
> >> 
> >> v5
> >> - removed hflip/vflip device tree properties
> >> 
> >> v4
> >> - GPL changed to GPLv2,
> >> - bitfields replaced by u8,
> >> - cosmetic changes,
> >> - corrected s_stream flow,
> >> - gpio pins are no longer exported,
> >> - added I2C addresses to subdev names,
> >> - CIS subdev registration postponed after
> >> 
> >>   succesfull HW initialization,
> >> 
> >> - added enums for pads,
> >> - selections are initialized only during probe,
> >> - default resolution changed to 1600x1200,
> >> - state->error pattern removed from few other functions,
> >> - entity link creation moved to registered callback.
> >> 
> >> v3:
> >> - narrowed state->error usage to i2c and power errors,
> >> - private gain controls replaced by red/blue balance user controls,
> >> - added checks to devicetree gpio node parsing
> >> 
> >> v2:
> >> - lower-cased driver name,
> >> - removed underscore from regulator names,
> >> - removed platform data code,
> >> - v4l controls grouped in anonymous structs,
> >> - added s5k5baf_clear_error function,
> >> - private controls definitions moved to uapi header file,
> >> - added v4l2-controls.h reservation for private controls,
> >> - corrected subdev registered/unregistered code,
> >> - .log_status sudbev op set to v4l2 helper,
> >> - moved entity link creation to probe routines,
> >> - added cleanup on error to probe function.
> >> ---
> >> 
> >>  .../devicetree/bindings/media/samsung-s5k5baf.txt  |   59 +
> >>  MAINTAINERS                                        |    7 +
> >>  drivers/media/i2c/Kconfig                          |    7 +
> >>  drivers/media/i2c/Makefile                         |    1 +
> >>  drivers/media/i2c/s5k5baf.c                        | 2045 ++++++++++++++
> >>  5 files changed, 2119 insertions(+)
> >>  create mode 100644
> >> 
> >> Documentation/devicetree/bindings/media/samsung-s5k5baf.txt create mode
> >> 100644 drivers/media/i2c/s5k5baf.c
> > 
> > [snip]
> > 
> >> diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
> >> new file mode 100644
> >> index 0000000..f21d9f1
> >> --- /dev/null
> >> +++ b/drivers/media/i2c/s5k5baf.c

[snip]

> >> +static void s5k5baf_write_arr_seq(struct s5k5baf *state, u16 addr,
> >> +				  u16 count, const u16 *seq)
> >> +{
> >> +	struct i2c_client *c = v4l2_get_subdevdata(&state->sd);
> >> +	u16 buf[count + 1];
> >> +	int ret, n;
> >> +
> >> +	s5k5baf_i2c_write(state, REG_CMDWR_ADDR, addr);
> >> +	if (state->error)
> >> +		return;
> > 
> > I would have a preference for returning an error directly from the write
> > function instead of storing it in state->error, that would be more
> > explicit. The same is true for all read/write functions.
> 
> I have introduced state->error to avoid code bloat. With this 'pattern'
> error is checked in about 10 places in the code, of course without
> scarifying code correctness.
> Replacing this pattern with classic 'return error directly from function'
> would result with adding error checks after all calls to i2c i/o functions
> and after calls to many functions which those i2c i/o calls contains.
> According to my rough estimates it is about 70 places.
> 
> Similar pattern is used already in v4l2_ctrl_handler::error.
> 
> >> +	buf[0] = __constant_htons(REG_CMD_BUF);
> >> +	for (n = 1; n <= count; ++n)
> >> +		buf[n] = htons(*seq++);
> > 
> > cpu_to_be16()/be16_to_cpu() here as well ?
> 
> OK
> 
> >> +
> >> +	n *= 2;
> >> +	ret = i2c_master_send(c, (char *)buf, n);
> >> +	v4l2_dbg(3, debug, c, "i2c_write_seq(count=%d): %*ph\n", count,
> >> +		 min(2 * count, 64), seq - count);
> >> +
> >> +	if (ret != n) {
> >> +		v4l2_err(c, "i2c_write_seq: error during transfer (%d)\n", ret);
> >> +		state->error = ret;
> >> +	}
> >> +}

[snip]

> >> +static int s5k5baf_hw_set_video_bus(struct s5k5baf *state)
> >> +{
> >> +	u16 en_packets;
> >> +
> >> +	switch (state->bus_type) {
> >> +	case V4L2_MBUS_CSI2:
> >> +		en_packets = EN_PACKETS_CSI2;
> >> +		break;
> >> +	case V4L2_MBUS_PARALLEL:
> >> +		en_packets = 0;
> >> +		break;
> >> +	default:
> >> +		v4l2_err(&state->sd, "unknown video bus: %d\n",
> >> +			 state->bus_type);
> >> +		return -EINVAL;
> > 
> > Can this happen ?
> 
> Yes, in case of incorrect DT bindings.

Shouldn't it be caught at probe time instead then ?

> >> +	};
> >> +
> >> +	s5k5baf_write_seq(state, REG_OIF_EN_MIPI_LANES,
> >> +			  state->nlanes, en_packets, 1);
> >> +
> >> +	return s5k5baf_clear_error(state);
> >> +}
> > 
> > [snip]
> > 
> >> +static int s5k5baf_s_stream(struct v4l2_subdev *sd, int on)
> >> +{
> >> +	struct s5k5baf *state = to_s5k5baf(sd);
> >> +	int ret;
> >> +
> >> +	if (state->streaming == !!on)
> >> +		return 0;
> >> +
> >> +	mutex_lock(&state->lock);
> > 
> > Shouldn't the lock protect the state->streaming check above ?
> 
> Yes, will be corrected.
> 
> >> +	if (on) {
> >> +		s5k5baf_hw_set_config(state);
> >> +		ret = s5k5baf_hw_set_crop_rects(state);
> >> +		if (ret < 0)
> >> +			goto out;
> >> +		s5k5baf_hw_set_stream(state, 1);
> >> +		s5k5baf_i2c_write(state, 0xb0cc, 0x000b);
> >> +	} else {
> >> +		s5k5baf_hw_set_stream(state, 0);
> >> +	}
> >> +	ret = s5k5baf_clear_error(state);
> >> +	if (!ret)
> >> +		state->streaming = !state->streaming;
> >> +
> >> +out:
> >> +	mutex_unlock(&state->lock);
> >> +
> >> +	return ret;
> >> +}

[snip]

> >> +static int s5k5baf_registered(struct v4l2_subdev *sd)
> >> +{
> >> +	struct s5k5baf *state = to_s5k5baf(sd);
> >> +	int ret;
> >> +
> >> +	ret = v4l2_device_register_subdev(sd->v4l2_dev, &state->cis_sd);
> >> +	if (ret < 0)
> >> +		v4l2_err(sd, "failed to register subdev %s\n",
> >> +			 state->cis_sd.name);
> >> +	else
> >> +		ret = media_entity_create_link(&state->cis_sd.entity, PAD_CIS,
> >> +					       &state->sd.entity, PAD_CIS,
> >> +					       MEDIA_LNK_FL_IMMUTABLE |
> >> +					       MEDIA_LNK_FL_ENABLED);
> >> +	return ret;
> >> +}
> >> +
> >> +static void s5k5baf_unregistered(struct v4l2_subdev *sd)
> >> +{
> >> +	struct s5k5baf *state = to_s5k5baf(sd);
> >> +	v4l2_device_unregister_subdev(&state->cis_sd);
> > 
> > The unregistered operation is called from v4l2_device_unregister_subdev().
> > Calling it again will be a no-op, the function will return immediately.
> > You can thus get rid of the unregistered operation completely.
> > 
> > Similarly, the registered operation is called from
> > v4l2_device_register_subdev(). You can get rid of it as well and just
> > create the link in the probe function.
> 
> The sensor exposes two subdevs: s5k5baf_cis and s5k5baf_isp.
> v4l2_device is not aware of it - he registers only the subdev bound to
> i2c client - isp.
> The registration of cis subdev is performed by the sensor in .registered
> callback. Without .registered callback cis subdev will not be registered.

You're right, my bad. I had overlooked that, I thought you were registering 
the ISP subdev. Could you please add a comment to the .registered() handler to 
document this ?

> This is similar solution to smiapp and s5c73m3 drivers.
> 
> Regarding .unregistered callback, it seems that removing it would not harm -
> there should be added only check in .registered to avoid its re-
> registration. On the other hand IMO if sensor driver is responsible for
> registration it should be responsible for unregistration of subdev, what do
> you think about it?

I agree.

> And about links: v4l2_device_unregister_subdev calls
> media_entity_remove_links,
> so in case device is re-registered driver should re-create them.
> 
> >> +}

[snip]

-- 
Regards,

Laurent Pinchart
