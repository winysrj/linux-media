Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59503 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab3IKJdB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Sep 2013 05:33:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ulrich Hecht <ulrich.hecht@gmail.com>, linux-sh@vger.kernel.org,
	magnus.damm@gmail.com, Hans Verkuil <hverkuil@xs4all.nl>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [RFC 01/10] drm: ADV7511 i2c HDMI encoder driver
Date: Wed, 11 Sep 2013 11:33:01 +0200
Message-ID: <2961877.x7cCDQoeAl@avalon>
In-Reply-To: <52271AC6.1020906@metafoo.de>
References: <1377866264-21110-1-git-send-email-ulrich.hecht@gmail.com> <2603252.pOSLifSPDx@avalon> <52271AC6.1020906@metafoo.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lars-Peter,

On Wednesday 04 September 2013 13:34:30 Lars-Peter Clausen wrote:
> [...]
> 
> >> +
> >> +/**
> >> + * enum adv7511_input_color_depth - Selects the input format color depth
> >> + * @ADV7511_INPUT_COLOR_DEPTH_8BIT: Input format color depth is 8 bits
> >> per channel
> >> + * @ADV7511_INPUT_COLOR_DEPTH_10BIT: Input format color dpeth is 10 bits
> >> per channel
> >> + * @ADV7511_INPUT_COLOR_DEPTH_12BIT: Input format color depth is 12 bits
> >> per channel
> >> + **/
> >> +enum adv7511_input_color_depth {
> >> +	ADV7511_INPUT_COLOR_DEPTH_8BIT = 3,
> >> +	ADV7511_INPUT_COLOR_DEPTH_10BIT = 1,
> >> +	ADV7511_INPUT_COLOR_DEPTH_12BIT = 2,
> >> +};
> > 
> > Those enums describe the video format at the chip input. This can be
> > configured statically from platform data or DT, but some platforms might
> > need to setup formats dynamically at runtime. For instance the ADV7511
> > could be driven by a mux with two inputs using different formats.
> > 
> > For these reasons I would combine all those enums in a single one that
> > lists all possible input formats. The formats should be standardized and
> > moved to a separate header file. Get and set format operations will be
> > needed (this is something CDF will address :-)).
> 
> Since most these settings are orthogonal to each other putting them in one
> enum gives you 3 * 3 * 6 * 3 = 162 entries. These enums configure to which
> pins of the ADV7511 what signal is connected. Standardizing this would
> require that other chips use the same layouts for connecting the pins.

The problem is, this information needs to be shared between devices. Formats 
on the bus could very well be dynamic, the ADV7511 video source could be able 
to generate multiple formats that would be runtime configurable. To support 
this, platform data and DT bindings should describe how signals are connected 
(which would thus filter the list of supported formats), and a runtime API 
will be needed to get and set formats.  The formats thus need to be 
standardized

We had a similar issue in V4L2 and have introduced a media bus format 
enumeration to solve it (see include/uapi/linux/v4l2-mediabus.h). I believe 
something similar is needed here.

Of course this won't solve the issue of how to select a format on the bus when 
both endpoints support multiple formats. This should probably be selected by 
userspace somehow, but we're missing an API to do so at the moment. A default 
value would thus need to be computed somehow, and possibly given by platform 
data and DT bindings (although it doesn't describe the hardware as such, and 
should thus not be part of the DT bindings).

> >> +/**
> >> + * enum adv7511_up_conversion - Selects the upscaling conversion method
> >> + * @ADV7511_UP_CONVERSION_ZERO_ORDER: Use zero order up conversion
> >> + * @ADV7511_UP_CONVERSION_FIRST_ORDER: Use first order up conversion
> >> + *
> >> + * This used when converting from a 4:2:2 format to a 4:4:4 format.
> >> + **/
> >> +enum adv7511_up_conversion {
> >> +    ADV7511_UP_CONVERSION_ZERO_ORDER = 0,
> >> +    ADV7511_UP_CONVERSION_FIRST_ORDER = 1,
> >> +};
> > 
> > How is the upscaling conversion method supposed to be selected ? What does
> > it depend on ?
> 
> It's probably up to the system designer to say which method yields better
> results for their system.

And what would a system designer base his/her decision on ? :-)

> >> +/**
> >> + * struct adv7511_video_config - Describes adv7511 hardware
> >> configuration
> >> + * @csc_enable:			Whether to enable color space conversion
> >> + * @csc_scaling_factor:		Color space conversion scaling factor
> >> + * @csc_coefficents:		Color space conversion coefficents
> >> + * @hdmi_mode:			Whether to use HDMI or DVI output mode
> >> + * @avi_infoframe:		HDMI infoframe
> >> + **/
> >> +struct adv7511_video_config {
> >> +	bool csc_enable;
> > 
> > Shouldn't this be automatically computed based on the input and output
> > formats ?
> 
> If the driver knew the input and output colorspaces and had coefficient
> tables for all possible combinations built in that could be done. This is
> maybe something that could be done in the framework.
> 
> >> +	enum adv7511_csc_scaling csc_scaling_factor;
> >> +	const uint16_t *csc_coefficents;
> > 
> > Do the coefficients need to be configured freely, or could presets do ?
> > 
> >> +	bool hdmi_mode;
> >> +	struct hdmi_avi_infoframe avi_infoframe;
> >> +};
> 
> [...]
> 
> >> +static void adv7511_set_config(struct drm_encoder *encoder, void *c)
> > 
> > Now we're getting to the controversial point.
> > 
> > What bothers me about the DRM encoder slave API is that the display
> > controller driver needs to be aware of the details of the slave encoder,
> > as it needs to pass an encoder-specific configuration structure to the
> > .set_config() operation. The question would thus be, what about using the
> > Common Display Framework ?
> 
> Well, as I said I'd prefer using the CDF for this driver. But even then the
> display controller driver might need to know about the details of the
> encoder. I think we talked about this during the FOSDEM meeting. The
> graphics fabric on the board can easily get complex enough to require a
> board custom driver, similar to what we have in ASoC. I think this
> drm_bridge patchset[1] tries to address a similar issue.
> 
> [1] http://lists.freedesktop.org/archives/dri-devel/2013-August/043237.html
> [...]
> 
> >> +
> >> +		for (i = 0; i < 4; ++i) {
> >> +			ret = i2c_transfer(adv7511->i2c_edid->adapter, xfer,
> >> ARRAY_SIZE(xfer));
> >> +			if (ret < 0)
> >> +				return ret;
> >> +			else if (ret != 2)
> >> +				return -EIO;
> >> +
> >> +			xfer[1].buf += 64;
> >> +			offset += 64;
> >> +		}
> > 
> > Shouldn't you read two times 64 bytes per block, not four times ?
> 
> The controller on the ADV7511 always reads two blocks at once, so it is 256
> bytes.

But this function return 128 bytes to the called. Can't you optimize this by 
reading 128 bytes only from the ADV7511 instead of throwing away 128 bytes 
every time ?

> >> +
> >> +		adv7511->current_edid_segment = block / 2;
> >> +	}
> >> +
> >> +	if (block % 2 == 0)
> >> +		memcpy(buf, adv7511->edid_buf, len);
> >> +	else
> >> +		memcpy(buf, adv7511->edid_buf + 128, len);
> >> +
> >> +	return 0;
> >> +}
> >> +
> 
> [...]
> 
> >> +
> >> +struct edid *adv7511_get_edid(struct drm_encoder *encoder)
> >> +{
> >> +	struct adv7511 *adv7511 = encoder_to_adv7511(encoder);
> >> +
> >> +	if (!adv7511->edid)
> >> +		return NULL;
> >> +
> >> +	return kmemdup(adv7511->edid, sizeof(*adv7511->edid) +
> >> +		adv7511->edid->extensions * 128, GFP_KERNEL);
> >> +}
> >> +EXPORT_SYMBOL_GPL(adv7511_get_edid);
> > 
> > Why do you need to export this function, who will use it ?
> 
> The drm driver using the encoder that wants to know the EDID. E.g. to know
> if the monitor supports HDMI or not. But exporting this function is really
> just a quick hack to compensate for the removal of 'raw_edid', this probably
> wants proper abstraction in the framework.

Yes, we do want a proper abstraction :-)

> >> +/*
> >> +	adi,input-id -
> >> +		0x00:
> >> +		0x01:
> >> +		0x02:
> >> +		0x03:
> >> +		0x04:
> >> +		0x05:
> >> +	adi,sync-pulse - Selects the sync pulse
> >> +		0x00: Use the DE signal as sync pulse
> >> +		0x01: Use the HSYNC signal as sync pulse
> >> +		0x02: Use the VSYNC signal as sync pulse
> >> +		0x03: No external sync pulse
> >> +	adi,bit-justification -
> >> +		0x00: Evently
> >> +		0x01: Right
> >> +		0x02: Left
> >> +	adi,up-conversion -
> >> +		0x00: zero-order up conversion
> >> +		0x01: first-order up conversion
> >> +	adi,timing-generation-sequence -
> >> +		0x00: Sync adjustment first, then DE generation
> >> +		0x01: DE generation first then sync adjustment
> >> +	adi,vsync-polarity - Polarity of the vsync signal
> >> +		0x00: Passthrough
> >> +		0x01: Active low
> >> +		0x02: Active high
> >> +	adi,hsync-polarity - Polarity of the hsync signal
> >> +		0x00: Passthrough
> >> +		0x01: Active low
> >> +		0x02: Active high
> >> +	adi,reverse-bitorder - If set the bitorder is reveresed
> >> +	adi,tmds-clock-inversion - If set use tdms clock inversion
> >> +	adi,clock-delay - Clock delay for the video data clock
> >> +		0x00: -1200 ps
> >> +		0x01:  -800 ps
> >> +		0x02:  -400 ps
> >> +		0x03: no dealy
> >> +		0x04:   400 ps
> >> +		0x05:   800 ps
> >> +		0x06:  1200 ps
> >> +		0x07:  1600 ps
> > 
> > The value should be expressed directly in ps in the DT.
> 
> DT doesn't allow negative values.

Doesn't it ? DT carries values a packed bits, but doesn't really specify how 
the value is to be interpreted. That's the job of the DT bindings. We could 
just tell that the clock-delay should be a 32-bit 2-complement signed value.

-- 
Regards,

Laurent Pinchart

