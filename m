Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:44750 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab3GYOm2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 10:42:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [PATCH] V4L: Add driver for Samsung S5K5BAF camera sensor
Date: Thu, 25 Jul 2013 16:42:21 +0200
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	linux-samsung-soc@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>
References: <1374688263-31907-1-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1374688263-31907-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201307251642.21451.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 24 July 2013 19:51:03 Sylwester Nawrocki wrote:
> From: Andrzej Hajda <a.hajda@samsung.com>
> 
> This patch adds V4L2 subdev driver for Samsung S5K5BAF CMOS
> image sensor with embedded SoC ISP.
> 
> The driver exposes two V4L2 subdevices:
> - S5K5BAF-CIS - pure CMOS Image Sensor, fixed 1600x1200 format,
>   no controls.
> - S5K5BAF-ISP - Image Signal Processor, formats up to 1600x1200,
>   pre/post ISP cropping, downscaling via selection API, controls.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> v4:
> - endpoint node presence is now optional,
> - added asynchronous subdev registration support and clock
>   handling,
> - GPL changed to GPLv2,
> - bitfields replaced by u8,
> - corrected s_stream flow,
> - gpio pins are no longer exported,
> - added I2C addresses to subdev names,
> - CIS subdev registration postponed after succesfull
>   HW initialization,
> - added enums for pads,
> - selections are initialized only during probe,
> - default resolution changed to 1600x1200,
> - state->error pattern removed from few other functions,
> - entity link creation moved to registered callback,
> - some cosmetic changes.
> 
> v3:
> - narrowed state->error usage to i2c and power errors,
> - private gain controls replaced by red/blue balance user controls,
> - added checks to devicetree gpio node parsing
> 
> v2:
> - lower-cased driver name,
> - removed underscore from regulator names,
> - removed platform data code,
> - v4l controls grouped in anonymous structs,
> - added s5k5baf_clear_error function,
> - private controls definitions moved to uapi header file,
> - added v4l2-controls.h reservation for private controls,
> - corrected subdev registered/unregistered code,
> - .log_status sudbev op set to v4l2 helper,
> - moved entity link creation to probe routines,
> - added cleanup on error to probe function.
> ---
>  .../devicetree/bindings/media/samsung-s5k5baf.txt  |   58 +
>  MAINTAINERS                                        |    7 +
>  drivers/media/i2c/Kconfig                          |    7 +
>  drivers/media/i2c/Makefile                         |    1 +
>  drivers/media/i2c/s5k5baf.c                        | 2048 ++++++++++++++++++++
>  5 files changed, 2121 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/samsung-s5k5baf.txt
>  create mode 100644 drivers/media/i2c/s5k5baf.c
> 

<snip>

> +
> +enum selection_rect { R_CIS, R_CROP_SINK, R_COMPOSE, R_CROP_SOURCE, R_INVALID };
> +
> +static enum selection_rect s5k5baf_get_sel_rect(u32 pad, u32 target)
> +{
> +	switch (target) {
> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> +		return pad ? R_COMPOSE : R_CIS;
> +	case V4L2_SEL_TGT_CROP:
> +		return pad ? R_CROP_SOURCE : R_CROP_SINK;
> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> +		return pad ? R_INVALID : R_CROP_SINK;
> +	case V4L2_SEL_TGT_COMPOSE:
> +		return pad ? R_INVALID : R_COMPOSE;
> +	default:
> +		return R_INVALID;
> +	}
> +}
> +
> +static int s5k5baf_is_bound_target(u32 target)
> +{
> +	return (target == V4L2_SEL_TGT_CROP_BOUNDS ||
> +		target == V4L2_SEL_TGT_COMPOSE_BOUNDS);
> +}
> +
> +static int s5k5baf_get_selection(struct v4l2_subdev *sd,
> +				 struct v4l2_subdev_fh *fh,
> +				 struct v4l2_subdev_selection *sel)
> +{
> +	static enum selection_rect rtype;
> +	struct s5k5baf *state = to_s5k5baf(sd);
> +
> +	rtype = s5k5baf_get_sel_rect(sel->pad, sel->target);
> +
> +	switch (rtype) {
> +	case R_INVALID:
> +		return -EINVAL;
> +	case R_CIS:
> +		sel->r = s5k5baf_cis_rect;
> +		return 0;
> +	default:
> +		break;
> +	}
> +
> +	if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		if (rtype == R_COMPOSE)
> +			sel->r = *v4l2_subdev_get_try_compose(fh, sel->pad);
> +		else
> +			sel->r = *v4l2_subdev_get_try_crop(fh, sel->pad);
> +		return 0;
> +	}
> +
> +	mutex_lock(&state->lock);
> +	switch (rtype) {
> +	case R_CROP_SINK:
> +		sel->r = state->crop_sink;
> +		break;
> +	case R_COMPOSE:
> +		sel->r = state->compose;
> +		break;
> +	case R_CROP_SOURCE:
> +		sel->r = state->crop_source;
> +		break;
> +	default:
> +		break;
> +	}
> +	if (s5k5baf_is_bound_target(sel->target)) {
> +		sel->r.left = 0;
> +		sel->r.top = 0;
> +	}
> +	mutex_unlock(&state->lock);
> +
> +	return 0;
> +}
> +
> +/* bounds range [start, start+len) to [0, max) and aligns to 2 */
> +static void s5k5baf_bound_range(u32 *start, u32 *len, u32 max)
> +{
> +	if (*len > max)
> +		*len = max;
> +	if (*start + *len > max)
> +		*start = max - *len;
> +	*start &= ~1;
> +	*len &= ~1;
> +	if (*len < S5K5BAF_WIN_WIDTH_MIN)
> +		*len = S5K5BAF_WIN_WIDTH_MIN;
> +}
> +
> +static void s5k5baf_bound_rect(struct v4l2_rect *r, u32 width, u32 height)
> +{
> +	s5k5baf_bound_range(&r->left, &r->width, width);
> +	s5k5baf_bound_range(&r->top, &r->height, height);
> +}
> +
> +static void s5k5baf_set_rect_and_adjust(struct v4l2_rect **rects,
> +					enum selection_rect first,
> +					struct v4l2_rect *v)
> +{
> +	struct v4l2_rect *r, *br;
> +	enum selection_rect i = first;
> +
> +	*rects[first] = *v;
> +	do {
> +		r = rects[i];
> +		br = rects[i - 1];
> +		s5k5baf_bound_rect(r, br->width, br->height);
> +	} while (++i != R_INVALID);
> +	*v = *rects[first];
> +}
> +
> +static bool s5k5baf_cmp_rect(const struct v4l2_rect *r1,
> +			     const struct v4l2_rect *r2)
> +{
> +	return !memcmp(r1, r2, sizeof(*r1));
> +}
> +
> +static int s5k5baf_set_selection(struct v4l2_subdev *sd,
> +				 struct v4l2_subdev_fh *fh,
> +				 struct v4l2_subdev_selection *sel)
> +{
> +	static enum selection_rect rtype;
> +	struct s5k5baf *state = to_s5k5baf(sd);
> +	struct v4l2_rect **rects;
> +	int ret = 0;
> +
> +	rtype = s5k5baf_get_sel_rect(sel->pad, sel->target);
> +	if (rtype == R_INVALID || s5k5baf_is_bound_target(sel->target))
> +		return -EINVAL;
> +
> +	/* allow only scaling on compose */
> +	if (rtype == R_COMPOSE) {
> +		sel->r.left = 0;
> +		sel->r.top = 0;
> +	}
> +
> +	if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		rects = (struct v4l2_rect * []) {
> +				&s5k5baf_cis_rect,
> +				v4l2_subdev_get_try_crop(fh, PAD_CIS),
> +				v4l2_subdev_get_try_compose(fh, PAD_CIS),
> +				v4l2_subdev_get_try_crop(fh, PAD_OUT)
> +			};
> +		s5k5baf_set_rect_and_adjust(rects, rtype, &sel->r);
> +		return 0;
> +	}
> +
> +	rects = (struct v4l2_rect * []) {
> +			&s5k5baf_cis_rect,
> +			&state->crop_sink,
> +			&state->compose,
> +			&state->crop_source
> +		};
> +	mutex_lock(&state->lock);
> +	if (state->streaming) {
> +		/* adjust sel->r to avoid output resolution change */
> +		if (rtype < R_CROP_SOURCE) {
> +			if (sel->r.width < state->crop_source.width)
> +				sel->r.width = state->crop_source.width;
> +			if (sel->r.height < state->crop_source.height)
> +				sel->r.height = state->crop_source.height;
> +		} else {
> +			sel->r.width = state->crop_source.width;
> +			sel->r.height = state->crop_source.height;
> +		}
> +	}
> +	s5k5baf_set_rect_and_adjust(rects, rtype, &sel->r);
> +	if (!s5k5baf_cmp_rect(&state->crop_sink, &s5k5baf_cis_rect) ||
> +	    !s5k5baf_cmp_rect(&state->compose, &s5k5baf_cis_rect))
> +		state->apply_crop = 1;
> +	if (state->streaming)
> +		ret = s5k5baf_hw_set_crop_rects(state);
> +	mutex_unlock(&state->lock);
> +
> +	return ret;
> +}

Would it be an idea to create a library with rectangle manipulation functions?
Looking at this driver and similar ones as well that I had to deal with that
support cropping/scaling/composing I see a lot of rectangle manipulation.

Moving that into a separate source that can be shared should simplify
development.

This is just an idea and it's not blocking for this particular driver.

Regards,

	Hans
