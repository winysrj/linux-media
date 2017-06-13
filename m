Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59543 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753371AbdFMMWp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 08:22:45 -0400
Subject: Re: [PATCH v4 1/2] media: i2c: adv748x: add adv748x driver
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Kieran Bingham <kbingham@kernel.org>
References: <cover.d0545e32d322ca1b939fa2918694173629e680eb.1497313626.git-series.kieran.bingham+renesas@ideasonboard.com>
 <865b71d4fcf6ce407a94a10d5dcb06944ddb6dcb.1497313626.git-series.kieran.bingham+renesas@ideasonboard.com>
 <20170613073320.GA16566@bigcity.dyn.berto.se>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        sakari.ailus@iki.fi,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reply-To: kieran.bingham@ideasonboard.com
Message-ID: <e11bb67f-42b2-5792-2ecf-4a8e237e5d1a@ideasonboard.com>
Date: Tue, 13 Jun 2017 13:22:33 +0100
MIME-Version: 1.0
In-Reply-To: <20170613073320.GA16566@bigcity.dyn.berto.se>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas

On 13/06/17 08:33, Niklas Söderlund wrote:
> Hi Kieran,
> 
> Thanks for your patch, and great work!

Thanks for taking a look.

> On 2017-06-13 01:35:07 +0100, Kieran Bingham wrote:
>> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>> Provide support for the ADV7481 and ADV7482.
>>
>> The driver is modelled with 4 subdevices to allow simultaneous streaming
>> from the AFE (Analog front end) and HDMI inputs though two CSI TX
>> entities.
>>
>> The HDMI entity is linked to the TXA CSI bus, whilst the AFE is linked
>> to the TXB CSI bus.
>>
>> The driver is based on a prototype by Koji Matsuoka in the Renesas BSP,
>> and an earlier rework by Niklas Söderlund.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>

<snip>

>> +static int adv748x_afe_get_format(struct v4l2_subdev *sd,
>> +				      struct v4l2_subdev_pad_config *cfg,
>> +				      struct v4l2_subdev_format *sdformat)
>> +{
>> +	struct adv748x_afe *afe = adv748x_sd_to_afe(sd);
>> +	struct v4l2_mbus_framefmt *mbusformat;
>> +
>> +	/* The format of the analog sink pads is nonsensical */
>> +	if (sdformat->pad != ADV748X_AFE_SOURCE)
>> +		return -EINVAL;
>> +
>> +	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY) {
>> +		mbusformat = v4l2_subdev_get_try_format(sd, cfg, sdformat->pad);
>> +		sdformat->format = *mbusformat;
>> +	} else {
>> +		adv748x_afe_fill_format(afe, &sdformat->format);
>> +		adv748x_afe_set_pixelrate(afe);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int adv748x_afe_set_format(struct v4l2_subdev *sd,
>> +				      struct v4l2_subdev_pad_config *cfg,
>> +				      struct v4l2_subdev_format *sdformat)
>> +{
>> +	struct v4l2_mbus_framefmt *mbusformat;
>> +
>> +	/* The format of the analog sink pads is nonsensical */
>> +	if (sdformat->pad != ADV748X_AFE_SOURCE)
>> +		return -EINVAL;
>> +
>> +	if (sdformat->which == V4L2_SUBDEV_FORMAT_ACTIVE)
>> +		return adv748x_afe_get_format(sd, cfg, sdformat);
>> +
>> +	mbusformat = v4l2_subdev_get_try_format(sd, cfg, sdformat->pad);
>> +	*mbusformat = sdformat->format;
> 
> Hum, for the V4L2_SUBDEV_FORMAT_TRY case will this not accept any format 
> provided to the function? Should you not limit this to the device 
> capabilities before assigning it to mbusformat ?

Hrmmm maybe it got too late last night :)

I was trying to remove the effect of the active setting on the TRY format, and
I've gone too far :)

> 
>> +
>> +	return 0;
>> +}

<snip>


>> +
>> +static int adv748x_setup_links(struct adv748x_state *state)
>> +{
>> +	int ret;
>> +	int enabled = MEDIA_LNK_FL_ENABLED;
>> +
>> +/*
>> + * HACK/Workaround:
>> + *
>> + * Currently non-immutable link resets go through the RVin
>> + * driver, and cause the links to fail, due to not being part of RVIN.
>> + * As a temporary workaround until the RVIN driver knows better than to parse
>> + * links that do not belong to it, use static immutable links for our internal
>> + * media paths.
>> + */
> 
> The problem is a bigger then just the VIN ignoring the links not 
> belonging to it self I think. The ADV7482 driver must have a link 
> notification handler to deal with the links that belong to it.
> 
> Else if all links of the media device is reset there is no way to setup 
> the links between the different ADV7482 subdevices, or am I missing 
> something?

Ahhh -- this function shouldn't even be in here ! It's not meant to be used -
Links are now created in adv748x_csi2_register_link() so now I'm concerned why I
didn't get an unused function compiler warning :)

However - your point still stands.

> 
>> +#define ADV748x_DEV_STATIC_LINKS
>> +#ifdef ADV748x_DEV_STATIC_LINKS
>> +	enabled |= MEDIA_LNK_FL_IMMUTABLE;
>> +#endif
>> +
>> +	/* TXA - Default link is with HDMI */
>> +	ret = media_create_pad_link(&state->hdmi.sd.entity, 1,
>> +				    &state->txa.sd.entity, 0, enabled);
>> +	if (ret) {
>> +		adv_err(state, "Failed to create HDMI-TXA pad link");
>> +		return ret;
>> +	}
>> +
>> +#ifndef ADV748x_DEV_STATIC_LINKS
>> +	ret = media_create_pad_link(&state->afe.sd.entity, ADV748X_AFE_SOURCE,
>> +				    &state->txa.sd.entity, 0, 0);
>> +	if (ret) {
>> +		adv_err(state, "Failed to create AFE-TXA pad link");
>> +		return ret;
>> +	}
>> +#endif
>> +
>> +	/* TXB - Can only output from the AFE */
>> +	ret = media_create_pad_link(&state->afe.sd.entity, ADV748X_AFE_SOURCE,
>> +				    &state->txb.sd.entity, 0, enabled);
>> +	if (ret) {
>> +		adv_err(state, "Failed to create AFE-TXB pad link");
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +int adv748x_register_subdevs(struct adv748x_state *state,
>> +			     struct v4l2_device *v4l2_dev)

And that's why I didn't get a function unused warning from the compiler.
adv748x_setup_links() is called by adv748x_register_subdevs() which is not
static, but is never used.

I've just removed these two functions. - the new linking mechanism is handled
during the registration of the CSI2 entitiy.

However your consideration about links resetting is still valid - as I have only
been testing with immutable links which will have prevented me from seeing the
issues.


>> +{
>> +	int ret;
>> +
>> +	ret = v4l2_device_register_subdev(v4l2_dev, &state->hdmi.sd);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = v4l2_device_register_subdev(v4l2_dev, &state->afe.sd);
>> +	if (ret < 0)
>> +		goto err_unregister_hdmi;
>> +
>> +	ret = adv748x_setup_links(state);
>> +	if (ret < 0)
>> +		goto err_unregister_afe;
>> +
>> +	return 0;
>> +
>> +err_unregister_afe:
>> +	v4l2_device_unregister_subdev(&state->afe.sd);
>> +err_unregister_hdmi:
>> +	v4l2_device_unregister_subdev(&state->hdmi.sd);
>> +
>> +	return ret;
>> +}
>> +

<snip>

>> +static int adv748x_csi2_get_format(struct v4l2_subdev *sd,
>> +				   struct v4l2_subdev_pad_config *cfg,
>> +				   struct v4l2_subdev_format *sdformat)
>> +{
>> +	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
>> +	struct adv748x_state *state = tx->state;
>> +	struct v4l2_mbus_framefmt *mbusformat;
>> +
>> +	mbusformat = adv748x_csi2_get_pad_format(sd, cfg, sdformat->pad,
>> +						 sdformat->which);
>> +	if (!mbusformat)
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&state->mutex);
> 
> Why do you need to take the lock here? I'm not saying it's wrong just 
> curious :-)
> 

I think the get/set formats are both userspace API's that 'could' be accessed in
parallel which read/modify the same context ...


>> +
>> +	sdformat->format = *mbusformat;
>> +
>> +	mutex_unlock(&state->mutex);
>> +
>> +	return 0;
>> +}
>> +
>> +static int adv748x_csi2_set_format(struct v4l2_subdev *sd,
>> +				   struct v4l2_subdev_pad_config *cfg,
>> +				   struct v4l2_subdev_format *sdformat)
>> +{
>> +	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
>> +	struct adv748x_state *state = tx->state;
>> +	struct v4l2_mbus_framefmt *mbusformat;
>> +	int ret = 0;
>> +
>> +	mbusformat = adv748x_csi2_get_pad_format(sd, cfg, sdformat->pad,
>> +						 sdformat->which);
>> +	if (!mbusformat)
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&state->mutex);
> 
> Also why you need to lock here?

As above...

if this is extraneous I'll remove it.


>> +
>> +static int adv748x_hdmi_read_pixelclock(struct adv748x_state *state)
>> +{
>> +	int a, b;
>> +
>> +	a = hdmi_read(state, ADV748X_HDMI_TMDS_1);
>> +	b = hdmi_read(state, ADV748X_HDMI_TMDS_2);
>> +	if (a < 0 || b < 0)
>> +		return -ENODATA;
>> +
>> +	/*
>> +	 * The High 9 bits store TMDS frequency measurement in MHz
> 
> s/High/high/
> 

fixed.


>> +	 * The low 7 bits of TMDS_2 store the 7-bit TMDS fractional frequency
>> +	 * measurement in 1/128 MHz
>> +	 */
>> +	return ((a << 1) | (b >> 7)) * 1000000 + (b & 0x7f) * 1000000 / 128;
>> +}
>> +
>> +/*

<snip>

>> +
>> +static int adv748x_hdmi_g_dv_timings(struct v4l2_subdev *sd,
>> +				     struct v4l2_dv_timings *timings)
>> +{
>> +	struct adv748x_hdmi *hdmi = adv748x_sd_to_hdmi(sd);
>> +	struct adv748x_state *state = adv748x_hdmi_to_state(hdmi);
>> +
>> +	mutex_lock(&state->mutex);
> 
> Why you need to take the lock here?

User accessible get/setters...

But it doesn't look like other drivers do the same here.

Maybe I went overkill adding extra locking earlier.

> 
>> +
>> +	*timings = hdmi->timings;
>> +
>> +	mutex_unlock(&state->mutex);
>> +
>> +	return 0;
>> +}
>> +
>> +static int adv748x_hdmi_query_dv_timings(struct v4l2_subdev *sd,
>> +					 struct v4l2_dv_timings *timings)
>> +{
>> +	struct adv748x_hdmi *hdmi = adv748x_sd_to_hdmi(sd);
>> +	struct adv748x_state *state = adv748x_hdmi_to_state(hdmi);
>> +	struct v4l2_bt_timings *bt = &timings->bt;
>> +	int pixelclock;
>> +	int polarity;
>> +
>> +	if (!timings)
>> +		return -EINVAL;
>> +
>> +	memset(timings, 0, sizeof(struct v4l2_dv_timings));
>> +
>> +	if (!adv748x_hdmi_has_signal(state))
>> +		return -ENOLINK;
>> +
>> +	pixelclock = adv748x_hdmi_read_pixelclock(state);
>> +	if (pixelclock < 0)
>> +		return -ENODATA;
>> +
>> +	timings->type = V4L2_DV_BT_656_1120;
>> +
>> +	bt->pixelclock = pixelclock;
>> +	bt->interlaced = hdmi_read(state, ADV748X_HDMI_F1H1) &
>> +				ADV748X_HDMI_F1H1_INTERLACED ?
>> +				V4L2_DV_INTERLACED : V4L2_DV_PROGRESSIVE;
>> +	bt->width = hdmi_read16(state, ADV748X_HDMI_LW1,
>> +				ADV748X_HDMI_LW1_WIDTH_MASK);
>> +	bt->height = hdmi_read16(state, ADV748X_HDMI_F0H1,
>> +				 ADV748X_HDMI_F0H1_HEIGHT_MASK);
>> +	bt->hfrontporch = hdmi_read16(state, ADV748X_HDMI_HFRONT_PORCH,
>> +				      ADV748X_HDMI_HFRONT_PORCH_MASK);
>> +	bt->hsync = hdmi_read16(state, ADV748X_HDMI_HSYNC_WIDTH,
>> +				ADV748X_HDMI_HSYNC_WIDTH_MASK);
>> +	bt->hbackporch = hdmi_read16(state, ADV748X_HDMI_HBACK_PORCH,
>> +				     ADV748X_HDMI_HBACK_PORCH_MASK);
>> +	bt->vfrontporch = hdmi_read16(state, ADV748X_HDMI_VFRONT_PORCH,
>> +				      ADV748X_HDMI_VFRONT_PORCH_MASK) / 2;
>> +	bt->vsync = hdmi_read16(state, ADV748X_HDMI_VSYNC_WIDTH,
>> +				ADV748X_HDMI_VSYNC_WIDTH_MASK) / 2;
>> +	bt->vbackporch = hdmi_read16(state, ADV748X_HDMI_VBACK_PORCH,
>> +				     ADV748X_HDMI_VBACK_PORCH_MASK) / 2;
>> +
> 
> Extra newline.

Ah yes,

I just found a nice sed to catch and remove these automatically.

  sed 'N;/^\n$/D;P;D;'

Picked up 2 more lines from -core.c :)

That should be part of checkpatch.pl somewhere ... Then I'd catch them as I commit.


> 
>> +
>> +	polarity = hdmi_read(state, 0x05);
>> +	bt->polarities = (polarity & BIT(4) ? V4L2_DV_VSYNC_POS_POL : 0) |
>> +		(polarity & BIT(5) ? V4L2_DV_HSYNC_POS_POL : 0);
>> +
>> +	if (bt->interlaced == V4L2_DV_INTERLACED) {
>> +		bt->height += hdmi_read16(state, 0x0b, 0x1fff);
>> +		bt->il_vfrontporch = hdmi_read16(state, 0x2c, 0x3fff) / 2;
>> +		bt->il_vsync = hdmi_read16(state, 0x30, 0x3fff) / 2;
>> +		bt->il_vbackporch = hdmi_read16(state, 0x34, 0x3fff) / 2;
>> +	}
>> +
>> +	adv748x_fill_optional_dv_timings(timings);
>> +
>> +	/*
>> +	 * No interrupt handling is implemented yet.
>> +	 * There should be an IRQ when a cable is plugged and the new timings
>> +	 * should be figured out and stored to state.
>> +	 */
>> +	hdmi->timings = *timings;
>> +
>> +	return 0;
>> +}
>> +
>> +static int adv748x_hdmi_g_input_status(struct v4l2_subdev *sd, u32 *status)
>> +{
>> +	struct adv748x_hdmi *hdmi = adv748x_sd_to_hdmi(sd);
>> +	struct adv748x_state *state = adv748x_hdmi_to_state(hdmi);
>> +
>> +	mutex_lock(&state->mutex);
> 
> Lock ? :-)
> 

Now this one is talking to the i2c bus ... so I want to keep that - although now
I've converted to regmap - it might well be locking the bus for me ... I'll have
to check.

>> +
>> +	*status = adv748x_hdmi_has_signal(state) ? 0 : V4L2_IN_ST_NO_SIGNAL;
>> +
>> +	mutex_unlock(&state->mutex);
>> +
>> +	return 0;
>> +}
>> +

<snip>

>> +
>> +static int adv748x_hdmi_set_format(struct v4l2_subdev *sd,
>> +				   struct v4l2_subdev_pad_config *cfg,
>> +				   struct v4l2_subdev_format *sdformat)
>> +{
>> +	struct v4l2_mbus_framefmt *mbusformat;
>> +
>> +	if (sdformat->pad != ADV748X_HDMI_SOURCE)
>> +		return -EINVAL;
>> +
>> +	if (sdformat->which == V4L2_SUBDEV_FORMAT_ACTIVE)
>> +		return adv748x_hdmi_get_format(sd, cfg, sdformat);
>> +
>> +	mbusformat = v4l2_subdev_get_try_format(sd, cfg, sdformat->pad);
>> +	*mbusformat = sdformat->format;
> 
> Same comment as for adv748x_afe_set_format().

Ack.

> 
>> +
>> +	return 0;
>> +}
>> +


Thanks :)
