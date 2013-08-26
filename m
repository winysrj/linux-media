Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:37243 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3HZMe3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Aug 2013 08:34:29 -0400
Message-id: <521B4B4D.50209@samsung.com>
Date: Mon, 26 Aug 2013 14:34:21 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
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
References: <1377096091-7284-1-git-send-email-a.hajda@samsung.com>
 <1544715.uKei6kdjbJ@avalon>
In-reply-to: <1544715.uKei6kdjbJ@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thank you for the review.

On 08/23/2013 02:53 PM, Laurent Pinchart wrote:
> Hi Andrzej,
>
> Thank you for the patch.
>
> On Wednesday 21 August 2013 16:41:31 Andrzej Hajda wrote:
>> Driver for Samsung S5K5BAF UXGA 1/5" 2M CMOS Image Sensor
>> with embedded SoC ISP.
>> The driver exposes the sensor as two V4L2 subdevices:
>> - S5K5BAF-CIS - pure CMOS Image Sensor, fixed 1600x1200 format,
>>   no controls.
>> - S5K5BAF-ISP - Image Signal Processor, formats up to 1600x1200,
>>   pre/post ISP cropping, downscaling via selection API, controls.
>>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>> Hi,
>>
>> This patch incorporates Stephen's suggestions, thanks.
>>
>> Regards
>> Andrzej
>>
>> v7
>> - changed description of 'clock-frequency' DT property
>>
>> v6
>> - endpoint node presence is now optional,
>> - added asynchronous subdev registration support and clock
>>   handling,
>> - use named gpios in DT bindings
>>
>> v5
>> - removed hflip/vflip device tree properties
>>
>> v4
>> - GPL changed to GPLv2,
>> - bitfields replaced by u8,
>> - cosmetic changes,
>> - corrected s_stream flow,
>> - gpio pins are no longer exported,
>> - added I2C addresses to subdev names,
>> - CIS subdev registration postponed after
>>   succesfull HW initialization,
>> - added enums for pads,
>> - selections are initialized only during probe,
>> - default resolution changed to 1600x1200,
>> - state->error pattern removed from few other functions,
>> - entity link creation moved to registered callback.
>>
>> v3:
>> - narrowed state->error usage to i2c and power errors,
>> - private gain controls replaced by red/blue balance user controls,
>> - added checks to devicetree gpio node parsing
>>
>> v2:
>> - lower-cased driver name,
>> - removed underscore from regulator names,
>> - removed platform data code,
>> - v4l controls grouped in anonymous structs,
>> - added s5k5baf_clear_error function,
>> - private controls definitions moved to uapi header file,
>> - added v4l2-controls.h reservation for private controls,
>> - corrected subdev registered/unregistered code,
>> - .log_status sudbev op set to v4l2 helper,
>> - moved entity link creation to probe routines,
>> - added cleanup on error to probe function.
>> ---
>>  .../devicetree/bindings/media/samsung-s5k5baf.txt  |   59 +
>>  MAINTAINERS                                        |    7 +
>>  drivers/media/i2c/Kconfig                          |    7 +
>>  drivers/media/i2c/Makefile                         |    1 +
>>  drivers/media/i2c/s5k5baf.c                        | 2045 +++++++++++++++++
>>  5 files changed, 2119 insertions(+)
>>  create mode 100644
>> Documentation/devicetree/bindings/media/samsung-s5k5baf.txt create mode
>> 100644 drivers/media/i2c/s5k5baf.c
> [snip]
>
>> diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
>> new file mode 100644
>> index 0000000..f21d9f1
>> --- /dev/null
>> +++ b/drivers/media/i2c/s5k5baf.c
> [snip]
>
>> +enum s5k5baf_pads_id {
>> +	PAD_CIS,
>> +	PAD_OUT,
>> +	CIS_PAD_NUM = 1,
>> +	ISP_PAD_NUM = 2
>> +};
> You can just use #define's here, the enum doesn't bring any additional value 
> and isn't very explicit.
OK
>
>> +static struct v4l2_rect s5k5baf_cis_rect = { 0, 0, S5K5BAF_CIS_WIDTH,
>> +				     S5K5BAF_CIS_HEIGHT };
> Shouldn't this be const ?
OK
>
>> +static u16 s5k5baf_i2c_read(struct s5k5baf *state, u16 addr)
>> +{
>> +	struct i2c_client *c = v4l2_get_subdevdata(&state->sd);
>> +	u16 w, r;
> You should declare these variables as __be16.
OK
>
>> +	struct i2c_msg msg[] = {
>> +		{ .addr = c->addr, .flags = 0,
>> +		  .len = 2, .buf = (u8 *)&w },
>> +		{ .addr = c->addr, .flags = I2C_M_RD,
>> +		  .len = 2, .buf = (u8 *)&r },
>> +	};
>> +	int ret;
>> +
>> +	if (state->error)
>> +		return 0;
>> +
>> +	w = htons(addr);
> Wouldln't cpu_to_be16() be more appropriate ?
OK
>
>> +	ret = i2c_transfer(c->adapter, msg, 2);
>> +	r = ntohs(r);
> And be16_to_cpu() here.
OK
>
>> +
>> +	v4l2_dbg(3, debug, c, "i2c_read: 0x%04x : 0x%04x\n", addr, r);
>> +
>> +	if (ret != 2) {
>> +		v4l2_err(c, "i2c_read: error during transfer (%d)\n", ret);
>> +		state->error = ret;
>> +	}
>> +	return r;
>> +}
> [snip]
>
>> +static void s5k5baf_write_arr_seq(struct s5k5baf *state, u16 addr,
>> +				  u16 count, const u16 *seq)
>> +{
>> +	struct i2c_client *c = v4l2_get_subdevdata(&state->sd);
>> +	u16 buf[count + 1];
>> +	int ret, n;
>> +
>> +	s5k5baf_i2c_write(state, REG_CMDWR_ADDR, addr);
>> +	if (state->error)
>> +		return;
> I would have a preference for returning an error directly from the write 
> function instead of storing it in state->error, that would be more explicit. 
> The same is true for all read/write functions.
I have introduced state->error to avoid code bloat. With this 'pattern'
error is checked in about 10 places in the code, of course without
scarifying code correctness.
Replacing this pattern with classic 'return error directly from function'
would result with adding error checks after all calls to i2c i/o functions
and after calls to many functions which those i2c i/o calls contains.
According to my rough estimates it is about 70 places.

Similar pattern is used already in v4l2_ctrl_handler::error.

>
>> +	buf[0] = __constant_htons(REG_CMD_BUF);
>> +	for (n = 1; n <= count; ++n)
>> +		buf[n] = htons(*seq++);
> cpu_to_be16()/be16_to_cpu() here as well ?
OK
>
>> +
>> +	n *= 2;
>> +	ret = i2c_master_send(c, (char *)buf, n);
>> +	v4l2_dbg(3, debug, c, "i2c_write_seq(count=%d): %*ph\n", count,
>> +		 min(2 * count, 64), seq - count);
>> +
>> +	if (ret != n) {
>> +		v4l2_err(c, "i2c_write_seq: error during transfer (%d)\n", ret);
>> +		state->error = ret;
>> +	}
>> +}
> [snip]
>
>> +static void s5k5baf_hw_set_ccm(struct s5k5baf *state)
> A small comment explaining what this function configures would be nice.
OK
>
>> +{
>> +	static const u16 nseq_cfg[] = {
>> +		NSEQ(REG_PTR_CCM_HORIZON,
>> +		REG_ARR_CCM(0), PAGE_IF_SW,
>> +		REG_ARR_CCM(1), PAGE_IF_SW,
>> +		REG_ARR_CCM(2), PAGE_IF_SW,
>> +		REG_ARR_CCM(3), PAGE_IF_SW,
>> +		REG_ARR_CCM(4), PAGE_IF_SW,
>> +		REG_ARR_CCM(5), PAGE_IF_SW),
>> +		NSEQ(REG_PTR_CCM_OUTDOOR,
>> +		REG_ARR_CCM(6), PAGE_IF_SW),
>> +		NSEQ(REG_ARR_CCM(0),
>> +		/* horizon */
>> +		0x010d, 0xffa7, 0xfff5, 0x003b, 0x00ef, 0xff38,
>> +		0xfe42, 0x0270, 0xff71, 0xfeed, 0x0198, 0x0198,
>> +		0xff95, 0xffa3, 0x0260, 0x00ec, 0xff33, 0x00f4,
>> +		/* incandescent */
>> +		0x010d, 0xffa7, 0xfff5, 0x003b, 0x00ef, 0xff38,
>> +		0xfe42, 0x0270, 0xff71, 0xfeed, 0x0198, 0x0198,
>> +		0xff95, 0xffa3, 0x0260, 0x00ec, 0xff33, 0x00f4,
>> +		/* warm white */
>> +		0x01ea, 0xffb9, 0xffdb, 0x0127, 0x0109, 0xff3c,
>> +		0xff2b, 0x021b, 0xff48, 0xff03, 0x0207, 0x0113,
>> +		0xffca, 0xff93, 0x016f, 0x0164, 0xff55, 0x0163,
>> +		/* cool white */
>> +		0x01ea, 0xffb9, 0xffdb, 0x0127, 0x0109, 0xff3c,
>> +		0xff2b, 0x021b, 0xff48, 0xff03, 0x0207, 0x0113,
>> +		0xffca, 0xff93, 0x016f, 0x0164, 0xff55, 0x0163,
>> +		/* daylight 5000K */
>> +		0x0194, 0xffad, 0xfffe, 0x00c5, 0x0103, 0xff5d,
>> +		0xfee3, 0x01ae, 0xff27, 0xff18, 0x018f, 0x00c8,
>> +		0xffe8, 0xffaa, 0x01c8, 0x0132, 0xff3e, 0x0100,
>> +		/* daylight 6500K */
>> +		0x0194, 0xffad, 0xfffe, 0x00c5, 0x0103, 0xff5d,
>> +		0xfee3, 0x01ae, 0xff27, 0xff18, 0x018f, 0x00c8,
>> +		0xffe8, 0xffaa, 0x01c8, 0x0132, 0xff3e, 0x0100,
>> +		/* outdoor */
>> +		0x01cc, 0xffc3, 0x0009, 0x00a2, 0x0106, 0xff3f,
>> +		0xfed8, 0x01fe, 0xff08, 0xfec7, 0x00f5, 0x0119,
>> +		0xffdf, 0x0024, 0x01a8, 0x0170, 0xffad, 0x011b),
>> +		0
>> +	};
>> +	s5k5baf_write_nseq(state, nseq_cfg);
>> +}
>> +
>> +static void s5k5baf_hw_set_cis(struct s5k5baf *state)
> Same here.
That's the magic, but I will add an comment about where it comes from.
>
>> +{
>> +	static const u16 nseq_cfg[] = {
>> +		NSEQ(0xc202, 0x0700),
>> +		NSEQ(0xf260, 0x0001),
>> +		NSEQ(0xf414, 0x0030),
>> +		NSEQ(0xc204, 0x0100),
>> +		NSEQ(0xf402, 0x0092, 0x007f),
>> +		NSEQ(0xf700, 0x0040),
>> +		NSEQ(0xf708,
>> +		0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
>> +		0x0040, 0x0040, 0x0040, 0x0040, 0x0040,
>> +		0x0001, 0x0015, 0x0001, 0x0040),
>> +		NSEQ(0xf48a, 0x0048),
>> +		NSEQ(0xf10a, 0x008b),
>> +		NSEQ(0xf900, 0x0067),
>> +		NSEQ(0xf406, 0x0092, 0x007f, 0x0003, 0x0003, 0x0003),
>> +		NSEQ(0xf442, 0x0000, 0x0000),
>> +		NSEQ(0xf448, 0x0000),
>> +		NSEQ(0xf456, 0x0001, 0x0010, 0x0000),
>> +		NSEQ(0xf41a, 0x00ff, 0x0003, 0x0030),
>> +		NSEQ(0xf410, 0x0001, 0x0000),
>> +		NSEQ(0xf416, 0x0001),
>> +		NSEQ(0xf424, 0x0000),
>> +		NSEQ(0xf422, 0x0000),
>> +		NSEQ(0xf41e, 0x0000),
>> +		NSEQ(0xf428, 0x0000, 0x0000, 0x0000),
>> +		NSEQ(0xf430, 0x0000, 0x0000, 0x0008, 0x0005, 0x000f, 0x0001,
>> +		0x0040, 0x0040, 0x0010),
>> +		NSEQ(0xf4d6, 0x0090, 0x0000),
>> +		NSEQ(0xf47c, 0x000c, 0x0000),
>> +		NSEQ(0xf49a, 0x0008, 0x0000),
>> +		NSEQ(0xf4a2, 0x0008, 0x0000),
>> +		NSEQ(0xf4b2, 0x0013, 0x0000, 0x0013, 0x0000),
>> +		NSEQ(0xf4aa, 0x009b, 0x00fb, 0x009b, 0x00fb),
>> +		0
>> +	};
>> +
>> +	s5k5baf_i2c_write(state, REG_CMDWR_PAGE, PAGE_IF_HW);
>> +	s5k5baf_write_nseq(state, nseq_cfg);
>> +	s5k5baf_i2c_write(state, REG_CMDWR_PAGE, PAGE_IF_SW);
>> +}
> [snip]
>
>> +/* Set auto/manual exposure and total gain */
>> +static void s5k5baf_hw_set_auto_exposure(struct s5k5baf *state, int value)
>> +{
>> +	unsigned int exp_time = state->ctrls.exposure->val;
>> +	u16 auto_alg;
>> +
>> +	auto_alg = s5k5baf_read(state, REG_DBG_AUTOALG_EN);
> Wouldn't it be faster to cache the register value in the state structure 
> instead of reading it back ? By the way, you might want to have a look at 
> regmap.
OK.
>
>> +
>> +	if (value == V4L2_EXPOSURE_AUTO) {
>> +		auto_alg |= AALG_AE_EN | AALG_DIVLEI_EN;
>> +	} else {
>> +		s5k5baf_hw_set_user_exposure(state, exp_time);
>> +		s5k5baf_hw_set_user_gain(state, state->ctrls.gain->val);
>> +		auto_alg &= ~(AALG_AE_EN | AALG_DIVLEI_EN);
>> +	}
>> +
>> +	s5k5baf_write(state, REG_DBG_AUTOALG_EN, auto_alg);
>> +}
>> +static void s5k5baf_hw_set_colorfx(struct s5k5baf *state, int val)
>> +{
>> +	static const u16 colorfx[] = {
>> +		[V4L2_COLORFX_NONE] = 0,
>> +		[V4L2_COLORFX_BW] = 1,
>> +		[V4L2_COLORFX_NEGATIVE] = 2,
>> +		[V4L2_COLORFX_SEPIA] = 3,
>> +		[V4L2_COLORFX_SKY_BLUE] = 4,
>> +		[V4L2_COLORFX_SKETCH] = 5,
>> +	};
>> +
>> +	if (val >= ARRAY_SIZE(colorfx)) {
>> +		v4l2_err(&state->sd, "colorfx(%d) out of range(%d)\n",
>> +			 val, ARRAY_SIZE(colorfx));
>> +		state->error = -EINVAL;
> Can this happen, given the range of admissible values for the control ?
OK, I will remove this check.
>
>> +	} else {
>> +		s5k5baf_write(state, REG_G_SPEC_EFFECTS, colorfx[val]);
>> +	}
>> +}
>> +
>> +static int s5k5baf_find_pixfmt(struct v4l2_mbus_framefmt *mf)
>> +{
>> +	int i, c = -1;
> I tend to use unsigned int for integer variables that store unsigned content 
> (i in this case), but that might just be me.
>
>> +
>> +	for (i = 0; i < ARRAY_SIZE(s5k5baf_formats); i++) {
>> +		if (mf->colorspace != s5k5baf_formats[i].colorspace)
>> +			continue;
>> +		if (mf->code == s5k5baf_formats[i].code)
>> +			return i;
>> +		if (c < 0)
>> +			c = i;
>> +	}
>> +	return (c < 0) ? 0 : c;
>> +}
> [snip]
>
>> +static int s5k5baf_hw_set_video_bus(struct s5k5baf *state)
>> +{
>> +	u16 en_packets;
>> +
>> +	switch (state->bus_type) {
>> +	case V4L2_MBUS_CSI2:
>> +		en_packets = EN_PACKETS_CSI2;
>> +		break;
>> +	case V4L2_MBUS_PARALLEL:
>> +		en_packets = 0;
>> +		break;
>> +	default:
>> +		v4l2_err(&state->sd, "unknown video bus: %d\n",
>> +			 state->bus_type);
>> +		return -EINVAL;
> Can this happen ?
Yes, in case of incorrect DT bindings.
>
>> +	};
>> +
>> +	s5k5baf_write_seq(state, REG_OIF_EN_MIPI_LANES,
>> +			  state->nlanes, en_packets, 1);
>> +
>> +	return s5k5baf_clear_error(state);
>> +}
> [snip]
>
>> +static int s5k5baf_s_stream(struct v4l2_subdev *sd, int on)
>> +{
>> +	struct s5k5baf *state = to_s5k5baf(sd);
>> +	int ret;
>> +
>> +	if (state->streaming == !!on)
>> +		return 0;
>> +
>> +	mutex_lock(&state->lock);
> Shouldn't the lock protect the state->streaming check above ?
Yes, will be corrected.
>
>> +	if (on) {
>> +		s5k5baf_hw_set_config(state);
>> +		ret = s5k5baf_hw_set_crop_rects(state);
>> +		if (ret < 0)
>> +			goto out;
>> +		s5k5baf_hw_set_stream(state, 1);
>> +		s5k5baf_i2c_write(state, 0xb0cc, 0x000b);
>> +	} else {
>> +		s5k5baf_hw_set_stream(state, 0);
>> +	}
>> +	ret = s5k5baf_clear_error(state);
>> +	if (!ret)
>> +		state->streaming = !state->streaming;
>> +
>> +out:
>> +	mutex_unlock(&state->lock);
>> +
>> +	return ret;
>> +}
> [snip]
>
>> +/*
>> + * V4L2 subdev internal operations
>> + */
>> +static int s5k5baf_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
>> +{
>> +	struct v4l2_mbus_framefmt *mf;
>> +
>> +	mf = v4l2_subdev_get_try_format(fh, PAD_CIS);
>> +	s5k5baf_try_cis_format(mf);
>> +
>> +	if (s5k5baf_is_cis_subdev(sd))
>> +		return 0;
> What about defining two open operations instead, one for each subdev ?
They share common code, not much but still :)
I see no gain in separating it.
>
>> +	mf = v4l2_subdev_get_try_format(fh, PAD_OUT);
>> +	mf->colorspace = s5k5baf_formats[0].colorspace;
>> +	mf->code = s5k5baf_formats[0].code;
>> +	mf->width = s5k5baf_cis_rect.width;
>> +	mf->height = s5k5baf_cis_rect.height;
>> +	mf->field = V4L2_FIELD_NONE;
>> +
>> +	*v4l2_subdev_get_try_crop(fh, PAD_CIS) = s5k5baf_cis_rect;
>> +	*v4l2_subdev_get_try_compose(fh, PAD_CIS) = s5k5baf_cis_rect;
>> +	*v4l2_subdev_get_try_crop(fh, PAD_OUT) = s5k5baf_cis_rect;
>> +
>> +	return 0;
>> +}
>> +
>> +static int s5k5baf_check_fw_revision(struct s5k5baf *state)
>> +{
>> +	u16 api_ver = 0, fw_rev = 0, s_id = 0;
>> +	int ret;
>> +
>> +	api_ver = s5k5baf_read(state, REG_FW_APIVER);
>> +	fw_rev = s5k5baf_read(state, REG_FW_REVISION) & 0xff;
>> +	s_id = s5k5baf_read(state, REG_FW_SENSOR_ID);
>> +	ret = s5k5baf_clear_error(state);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	v4l2_info(&state->sd, "FW API=%#x, revision=%#x sensor_id=%#x\n",
>> +		  api_ver, fw_rev, s_id);
>> +
>> +	if (api_ver == S5K5BAF_FW_APIVER)
>> +		return 0;
> I would have dealt with the error inside the if, but that's up to you.
OK
>
>> +	v4l2_err(&state->sd, "FW API version not supported\n");
>> +	return -ENODEV;
>> +}
>> +
>> +static int s5k5baf_registered(struct v4l2_subdev *sd)
>> +{
>> +	struct s5k5baf *state = to_s5k5baf(sd);
>> +	int ret;
>> +
>> +	ret = v4l2_device_register_subdev(sd->v4l2_dev, &state->cis_sd);
>> +	if (ret < 0)
>> +		v4l2_err(sd, "failed to register subdev %s\n",
>> +			 state->cis_sd.name);
>> +	else
>> +		ret = media_entity_create_link(&state->cis_sd.entity, PAD_CIS,
>> +					       &state->sd.entity, PAD_CIS,
>> +					       MEDIA_LNK_FL_IMMUTABLE |
>> +					       MEDIA_LNK_FL_ENABLED);
>> +	return ret;
>> +}
>> +
>> +static void s5k5baf_unregistered(struct v4l2_subdev *sd)
>> +{
>> +	struct s5k5baf *state = to_s5k5baf(sd);
>> +	v4l2_device_unregister_subdev(&state->cis_sd);
> The unregistered operation is called from v4l2_device_unregister_subdev(). 
> Calling it again will be a no-op, the function will return immediately. You 
> can thus get rid of the unregistered operation completely.
>
> Similarly, the registered operation is called from 
> v4l2_device_register_subdev(). You can get rid of it as well and just create 
> the link in the probe function.
The sensor exposes two subdevs: s5k5baf_cis and s5k5baf_isp.
v4l2_device is not aware of it - he registers only the subdev bound to
i2c client - isp.
The registration of cis subdev is performed by the sensor in .registered
callback. Without .registered callback cis subdev will not be registered.

This is similar solution to smiapp and s5c73m3 drivers.

Regarding .unregistered callback, it seems that removing it would not harm -
there should be added only check in .registered to avoid its
re-registration.
On the other hand IMO if sensor driver is responsible for registration
it should
be responsible for unregistration of subdev, what do you think about it?

And about links: v4l2_device_unregister_subdev calls
media_entity_remove_links,
so in case device is re-registered driver should re-create them.

>
>> +}
> [snip]
>
>> +static int s5k5baf_parse_device_node(struct s5k5baf *state, struct device
>> *dev) +{
>> +	struct device_node *node = dev->of_node;
>> +	struct device_node *node_ep;
>> +	struct v4l2_of_endpoint ep;
>> +	int ret;
>> +
>> +	if (!node) {
>> +		dev_err(dev, "no device-tree node provided\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	ret = of_property_read_u32(node, "clock-frequency",
>> +				   &state->mclk_frequency);
>> +	if (ret < 0) {
>> +		state->mclk_frequency = S5K5BAF_DEFAULT_MCLK_FREQ;
>> +		dev_info(dev, "using default %u Hz clock frequency\n",
>> +			 state->mclk_frequency);
>> +	}
>> +
>> +	ret = s5k5baf_parse_gpios(state->gpios, dev);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	node_ep = v4l2_of_get_next_endpoint(node, NULL);
>> +	if (!node_ep) {
>> +		/* Default data bus configuration: MIPI CSI-2, 1 data lane. */
>> +		state->bus_type = V4L2_MBUS_CSI2;
>> +		state->nlanes = S5K5BAF_DEF_NUM_LANES;
>> +		dev_warn(dev, "no endpoint defined at node %s\n",
>> +			 node->full_name);
>> +		return 0;
> Shouldn't this be a fatal error ? If there's no endpoint the sensor isn't part 
> of any media pipeline, so it's unusable anyway.
OK

>
>> +	}
>> +
>> +	v4l2_of_parse_endpoint(node_ep, &ep);
>> +	of_node_put(node_ep);
>> +	state->bus_type = ep.bus_type;
>> +
>> +	if (state->bus_type == V4L2_MBUS_CSI2)
>> +		state->nlanes = ep.bus.mipi_csi2.num_data_lanes;
>> +
>> +	return 0;
>> +}

