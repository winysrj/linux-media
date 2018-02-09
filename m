Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:51295 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750863AbeBIIIj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Feb 2018 03:08:39 -0500
Subject: Re: [PATCH v10 6/8] media: i2c: Add TDA1997x HDMI receiver driver
To: Tim Harvey <tharvey@gateworks.com>, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        shawnguo@kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1518157956-14220-1-git-send-email-tharvey@gateworks.com>
 <1518157956-14220-7-git-send-email-tharvey@gateworks.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <cf5c51f4-ca86-e468-ba16-d47d224a2428@xs4all.nl>
Date: Fri, 9 Feb 2018 09:08:34 +0100
MIME-Version: 1.0
In-Reply-To: <1518157956-14220-7-git-send-email-tharvey@gateworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tim,

We're almost there. Two more comments:

On 02/09/2018 07:32 AM, Tim Harvey wrote:
> +static int
> +tda1997x_detect_std(struct tda1997x_state *state,
> +		    struct v4l2_dv_timings *timings)
> +{
> +	struct v4l2_subdev *sd = &state->sd;
> +	u32 vper;
> +	u16 hper;
> +	u16 hsper;
> +	int i;
> +
> +	/*
> +	 * Read the FMT registers
> +	 *   REG_V_PER: Period of a frame (or two fields) in MCLK(27MHz) cycles
> +	 *   REG_H_PER: Period of a line in MCLK(27MHz) cycles
> +	 *   REG_HS_WIDTH: Period of horiz sync pulse in MCLK(27MHz) cycles
> +	 */
> +	vper = io_read24(sd, REG_V_PER) & MASK_VPER;
> +	hper = io_read16(sd, REG_H_PER) & MASK_HPER;
> +	hsper = io_read16(sd, REG_HS_WIDTH) & MASK_HSWIDTH;
> +	if (!vper || !hper || !hsper)
> +		return -ENOLINK;

See my comment for g_input_status below. This condition looks more like a
ENOLCK.

Or perhaps it should be:

	if (!vper && !hper && !hsper)
		return -ENOLINK;
	if (!vper || !hper || !hsper)
		return -ENOLCK;

I would recommend that you test a bit with no signal and a bad signal (perhaps
one that uses a pixelclock that is too high for this device?).

> +	v4l2_dbg(1, debug, sd, "Signal Timings: %u/%u/%u\n", vper, hper, hsper);
> +
> +	for (i = 0; v4l2_dv_timings_presets[i].bt.width; i++) {
> +		const struct v4l2_bt_timings *bt;
> +		u32 lines, width, _hper, _hsper;
> +		u32 vmin, vmax, hmin, hmax, hsmin, hsmax;
> +		bool vmatch, hmatch, hsmatch;
> +
> +		bt = &v4l2_dv_timings_presets[i].bt;
> +		width = V4L2_DV_BT_FRAME_WIDTH(bt);
> +		lines = V4L2_DV_BT_FRAME_HEIGHT(bt);
> +		_hper = (u32)bt->pixelclock / width;
> +		if (bt->interlaced)
> +			lines /= 2;
> +		/* vper +/- 0.7% */
> +		vmin = ((27000000 / 1000) * 993) / _hper * lines;
> +		vmax = ((27000000 / 1000) * 1007) / _hper * lines;
> +		/* hper +/- 1.0% */
> +		hmin = ((27000000 / 100) * 99) / _hper;
> +		hmax = ((27000000 / 100) * 101) / _hper;
> +		/* hsper +/- 2 (take care to avoid 32bit overflow) */
> +		_hsper = 27000 * bt->hsync / ((u32)bt->pixelclock/1000);
> +		hsmin = _hsper - 2;
> +		hsmax = _hsper + 2;
> +
> +		/* vmatch matches the framerate */
> +		vmatch = ((vper <= vmax) && (vper >= vmin)) ? 1 : 0;
> +		/* hmatch matches the width */
> +		hmatch = ((hper <= hmax) && (hper >= hmin)) ? 1 : 0;
> +		/* hsmatch matches the hswidth */
> +		hsmatch = ((hsper <= hsmax) && (hsper >= hsmin)) ? 1 : 0;
> +		if (hmatch && vmatch && hsmatch) {
> +			*timings = v4l2_dv_timings_presets[i];
> +			v4l2_print_dv_timings(sd->name, "Detected format: ",
> +					      timings, false);
> +			return 0;
> +		}
> +	}
> +
> +	v4l_err(state->client, "no resolution match for timings: %d/%d/%d\n",
> +		vper, hper, hsper);
> +	return -EINVAL;
> +}

-EINVAL isn't the correct error code here. I would go for -ERANGE. It's not
perfect, but close enough.

-EINVAL indicates that the user filled in wrong values, but that's not the
case here.

> +static int
> +tda1997x_g_input_status(struct v4l2_subdev *sd, u32 *status)
> +{
> +	struct tda1997x_state *state = to_state(sd);
> +	u32 vper;
> +	u16 hper;
> +	u16 hsper;
> +
> +	mutex_lock(&state->lock);
> +	v4l2_dbg(1, debug, sd, "inputs:%d/%d\n",
> +		 state->input_detect[0], state->input_detect[1]);
> +	if (state->input_detect[0] || state->input_detect[1])

I'm confused. This device has two HDMI inputs?

Does 'detecting input' equate to 'I see a signal and I am locked'?
I gather from the irq function that sets these values that it is closer
to 'I see a signal' and that 'I am locked' is something you would test
by looking at the vper/hper/hsper.

> +		*status = 0;
> +	else {
> +		vper = io_read24(sd, REG_V_PER) & MASK_VPER;
> +		hper = io_read16(sd, REG_H_PER) & MASK_HPER;
> +		hsper = io_read16(sd, REG_HS_WIDTH) & MASK_HSWIDTH;
> +		v4l2_dbg(1, debug, sd, "timings:%d/%d/%d\n", vper, hper, hsper);
> +		if (!vper || !hper || !hsper)
> +			*status |= V4L2_IN_ST_NO_SYNC;
> +		else
> +			*status |= V4L2_IN_ST_NO_SIGNAL;

So if we have valid vper, hper and hsper, then there is no signal? That doesn't
make sense.

I'd expect to see something like this:

	if (!input_detect[0] && !input_detect[1])
		// no signal
	else if (!vper || !hper || !vsper)
		// no sync
	else
		// have signal and sync

I'm not sure about the precise meaning of input_detect, so I might be wrong about
that bit.

Regards,

	Hans
