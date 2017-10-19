Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:60410 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751264AbdJSG70 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 02:59:26 -0400
Subject: Re: [PATCH v2 3/4] media: i2c: Add TDA1997x HDMI receiver driver
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tim Harvey <tharvey@gateworks.com>, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        shawnguo@kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1507783506-3884-1-git-send-email-tharvey@gateworks.com>
 <1507783506-3884-4-git-send-email-tharvey@gateworks.com>
 <230ceb18-1d69-7fa8-acb0-c810094f8e50@xs4all.nl>
Message-ID: <015aad32-6b3e-31a8-4fa0-1b249c46d137@xs4all.nl>
Date: Thu, 19 Oct 2017 08:59:19 +0200
MIME-Version: 1.0
In-Reply-To: <230ceb18-1d69-7fa8-acb0-c810094f8e50@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/18/2017 02:04 PM, Hans Verkuil wrote:
> Hi Tim,
> 
> Here is my review of this v2:
> 
> On 10/12/17 06:45, Tim Harvey wrote:
>> Add support for the TDA1997x HDMI receivers.
>>
>> Cc: Hans Verkuil <hverkuil@xs4all.nl>
>> Signed-off-by: Tim Harvey <tharvey@gateworks.com>
>> ---
>> v2:
>>  - implement dv timings enum/cap
>>  - remove deprecated g_mbus_config op
>>  - fix dv_query_timings
>>  - add EDID get/set handling
>>  - remove max-pixel-rate support
>>  - add audio codec DAI support
>>  - use new audio bindings
>>
>> ---
>>  drivers/media/i2c/Kconfig            |    9 +
>>  drivers/media/i2c/Makefile           |    1 +
>>  drivers/media/i2c/tda1997x.c         | 3336 ++++++++++++++++++++++++++++++++++
>>  include/dt-bindings/media/tda1997x.h |   78 +
>>  include/media/i2c/tda1997x.h         |   53 +
>>  5 files changed, 3477 insertions(+)
>>  create mode 100644 drivers/media/i2c/tda1997x.c
>>  create mode 100644 include/dt-bindings/media/tda1997x.h
>>  create mode 100644 include/media/i2c/tda1997x.h
>>

<snip>

>> +/* parse an infoframe and do some sanity checks on it */
>> +static unsigned int
>> +tda1997x_parse_infoframe(struct tda1997x_state *state, u16 addr)
>> +{
>> +	struct v4l2_subdev *sd = &state->sd;
>> +	union hdmi_infoframe frame;
>> +	u8 buffer[40];
>> +	u8 reg;
>> +	int len, err;
>> +
>> +	/* read data */
>> +	len = io_readn(sd, addr, sizeof(buffer), buffer);
>> +	err = hdmi_infoframe_unpack(&frame, buffer);
>> +	if (err) {
>> +		v4l_err(state->client,
>> +			"failed parsing %d byte infoframe: 0x%04x/0x%02x\n",
>> +			len, addr, buffer[0]);
>> +		return err;
>> +	}
>> +	if (debug > 1)
>> +		hdmi_infoframe_log(KERN_INFO, &state->client->dev, &frame);
>> +	switch (frame.any.type) {
>> +	/* Audio InfoFrame: see HDMI spec 8.2.2 */
>> +	case HDMI_INFOFRAME_TYPE_AUDIO:
>> +		/* sample rate */
>> +		switch (frame.audio.sample_frequency) {
>> +		case HDMI_AUDIO_SAMPLE_FREQUENCY_32000:
>> +			state->audio_samplerate = 32000;
>> +			break;
>> +		case HDMI_AUDIO_SAMPLE_FREQUENCY_44100:
>> +			state->audio_samplerate = 44100;
>> +			break;
>> +		case HDMI_AUDIO_SAMPLE_FREQUENCY_48000:
>> +			state->audio_samplerate = 48000;
>> +			break;
>> +		case HDMI_AUDIO_SAMPLE_FREQUENCY_88200:
>> +			state->audio_samplerate = 88200;
>> +			break;
>> +		case HDMI_AUDIO_SAMPLE_FREQUENCY_96000:
>> +			state->audio_samplerate = 96000;
>> +			break;
>> +		case HDMI_AUDIO_SAMPLE_FREQUENCY_176400:
>> +			state->audio_samplerate = 176400;
>> +			break;
>> +		case HDMI_AUDIO_SAMPLE_FREQUENCY_192000:
>> +			state->audio_samplerate = 192000;
>> +			break;
>> +		default:
>> +		case HDMI_AUDIO_SAMPLE_FREQUENCY_STREAM:
>> +			break;
>> +		}
>> +
>> +		/* sample size */
>> +		switch (frame.audio.sample_size) {
>> +		case HDMI_AUDIO_SAMPLE_SIZE_16:
>> +			state->audio_samplesize = 16;
>> +			break;
>> +		case HDMI_AUDIO_SAMPLE_SIZE_20:
>> +			state->audio_samplesize = 20;
>> +			break;
>> +		case HDMI_AUDIO_SAMPLE_SIZE_24:
>> +			state->audio_samplesize = 24;
>> +			break;
>> +		case HDMI_AUDIO_SAMPLE_SIZE_STREAM:
>> +		default:
>> +			break;
>> +		}
>> +
>> +		/* Channel Count */
>> +		state->audio_channels = frame.audio.channels;
>> +		if (frame.audio.channel_allocation &&
>> +		    frame.audio.channel_allocation != state->audio_ch_alloc) {
>> +			/* use the channel assignment from the infoframe */
>> +			state->audio_ch_alloc = frame.audio.channel_allocation;
>> +			tda1997x_configure_audout(sd, state->audio_ch_alloc);
>> +			/* reset the audio FIFO */
>> +			tda1997x_hdmi_info_reset(sd, RESET_AUDIO, false);
>> +		}
>> +		break;
>> +
>> +	/* Source Product Descriptor information (SPD) */
>> +	case HDMI_INFOFRAME_TYPE_SPD:
>> +		strncpy(frame.spd.vendor, state->vendor,
>> +			sizeof(frame.spd.vendor));
>> +		strncpy(frame.spd.product, state->product,
>> +			sizeof(frame.spd.product));
>> +		v4l_info(state->client, "Source Product Descriptor: %s %s\n",
>> +			 state->vendor, state->product);
> 
> Use hdmi_infoframe_log() for logging infoframes.
> 
>> +		break;
>> +
>> +	/* Auxiliary Video information (AVI) InfoFrame: see HDMI spec 8.2.1 */
>> +	case HDMI_INFOFRAME_TYPE_AVI:
>> +		state->colorspace = frame.avi.colorspace;
>> +		state->colorimetry = frame.avi.colorimetry;
>> +		/*
>> +		 * If colorimetry not specified, conversion depends on res type:
>> +		 *  - SDTV: ITU601 for SD (480/576/240/288 line resolution)
>> +		 *  - HDTV: ITU709 for HD (720/1080 line resolution)
>> +		 *  -   PC: sRGB
>> +		 * see HDMI specification section 6.7
>> +		 */
>> +		if ((state->colorspace == HDMI_COLORSPACE_YUV422 ||
>> +		     state->colorspace == HDMI_COLORSPACE_YUV444) &&
>> +		    (state->colorimetry == HDMI_COLORIMETRY_EXTENDED ||
>> +		     state->colorimetry == HDMI_COLORIMETRY_NONE)) {
>> +			switch (state->timings.bt.height) {
>> +			case 480:
>> +			case 576:
>> +			case 240:
>> +			case 288:
>> +				state->colorimetry = HDMI_COLORIMETRY_ITU_601;
>> +				break;
>> +			case 720:
>> +			case 1080:
>> +				state->colorimetry = HDMI_COLORIMETRY_ITU_709;
>> +				break;
>> +			default:
>> +				state->colorimetry = HDMI_COLORIMETRY_NONE;
> 
> Missing break.
> 
>> +			}
>> +		}
>> +		v4l_dbg(1, debug, state->client,
>> +			"Colorspace=%d Colorimetry=%d\n",
>> +			state->colorspace, state->colorimetry);
>> +
>> +		/* configure upsampler: 0=bypass 1=repeatchroma 2=interpolate */
>> +		reg = io_read(sd, REG_PIX_REPEAT);
>> +		reg &= ~PIX_REPEAT_MASK_UP_SEL;
>> +		if (state->colorspace == HDMI_COLORSPACE_YUV422)
>> +			reg |= (PIX_REPEAT_CHROMA << PIX_REPEAT_SHIFT);
>> +		io_write(sd, REG_PIX_REPEAT, reg);
>> +
>> +		/* ConfigurePixelRepeater: repeat n-times each pixel */
>> +		reg = io_read(sd, REG_PIX_REPEAT);
>> +		reg &= ~PIX_REPEAT_MASK_REP;
>> +		reg |= frame.avi.pixel_repeat;
>> +		io_write(sd, REG_PIX_REPEAT, reg);
>> +
>> +		/* configure the receiver with the new colorspace */
>> +		tda1997x_configure_conv(sd, state->colorspace,
>> +					state->colorimetry);
> 
> What I am missing here is handling of the RGB quantization range.
> An HDMI receiver will typically send full range RGB or limited range YUV
> to the SoC. The HDMI source can however send full or limited range RGB
> or limited range YUV (full range YUV is theoretically possible, but nobody
> does that).
> 
> For a Full HD receiver the rules when receiving RGB video are as follows:
> 
> If the EDID supports selectable RGB Quantization Range, then check if the
> source explicitly sets the RGB quantization range in the AVI InfoFrame and
> use that value.

A small correction here: while ideally you should indeed check if the current
EDID supports selectable RGB Quantization Range, in practice you don't need
to. If the source explicitly sets the RGB quantization range, then just use
that.

Note: some hardware can do this automatically (adv7604) by detecting what is
transmitted in the AVI InfoFrame. That's probably not the case here since you
have to provide a conversion matrix.

> 
> Otherwise fall back to the default rules:
> 
> if VIC == 0, then expect full range RGB, otherwise expect limited range RGB.
> 
> It gets even more complicated with 4k video, but this is full HD only.
> 
> In addition, you may also want to implement the V4L2_CID_DV_RX_RGB_RANGE control
> to let userspace override the autodetection.

To clarify: this control makes it possible to override the default rules. Too
many sources (Hi Apple!) make a mess of this and send e.g. full range when they
should be sending limited range or vice versa.

> 
> RGB Quantization Range handling is *the* biggest headache for HDMI receivers.
> 
> If you happen to attend the Embedded Linux Conference Europe in Prague next
> week, then attend my presentation on HDMI 4k Video on the Wednesday for all
> the reasons why this is so tricky.

If you have any questions, feel free to ask. This is a nasty corner of the HDMI
spec but unfortunately one that is very visible to the user if you do it wrong.

Regards,

	Hans
