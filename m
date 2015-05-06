Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:48623 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751103AbbEFMIH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 May 2015 08:08:07 -0400
Message-ID: <554A041F.5000107@xs4all.nl>
Date: Wed, 06 May 2015 14:07:59 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: matrandg@cisco.com, linux-media@vger.kernel.org
CC: hansverk@cisco.com, p.zabel@pengutronix.de, kernel@pengutronix.de
Subject: Re: [PATCH] Driver for Toshiba TC358743 HDMI to CSI-2 bridge
References: <1430904429-24899-1-git-send-email-matrandg@cisco.com>
In-Reply-To: <1430904429-24899-1-git-send-email-matrandg@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mats,

Here is one more:

On 05/06/15 11:27, matrandg@cisco.com wrote:
> From: Mats Randgaard <matrandg@cisco.com>
> 
> The driver is tested on our hardware and all the implemented features
> works as expected.
> 
> Missing features:
> - CEC support
> - HDCP repeater support
> - IR support
> 
> Signed-off-by: Mats Randgaard <matrandg@cisco.com>
> ---
>  MAINTAINERS                        |    6 +
>  drivers/media/i2c/Kconfig          |    9 +
>  drivers/media/i2c/Makefile         |    1 +
>  drivers/media/i2c/tc358743.c       | 1838 ++++++++++++++++++++++++++++++++++++
>  drivers/media/i2c/tc358743_regs.h  |  680 +++++++++++++
>  include/media/tc358743.h           |   92 ++
>  include/uapi/linux/v4l2-controls.h |    4 +
>  7 files changed, 2630 insertions(+)
>  create mode 100644 drivers/media/i2c/tc358743.c
>  create mode 100644 drivers/media/i2c/tc358743_regs.h
>  create mode 100644 include/media/tc358743.h
> 

<snip>

> +static int tc358743_set_fmt(struct v4l2_subdev *sd,
> +		struct v4l2_subdev_pad_config *cfg,
> +		struct v4l2_subdev_format *format)
> +{
> +	struct tc358743_state *state = to_state(sd);
> +
> +	if (format->pad != 0)
> +		return -EINVAL;
> +
> +	switch (format->format.code) {
> +	case MEDIA_BUS_FMT_RGB888_1X24:
> +	case MEDIA_BUS_FMT_UYVY8_1X16:
> +		state->mbus_fmt_code = format->format.code;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	enable_stream(sd, false);
> +	tc358743_set_pll(sd);
> +	tc358743_set_csi(sd);
> +	tc358743_set_csi_color_space(sd);
> +
> +	return 0;
> +}

I'd rewrite this as follows:

static int tc358743_set_fmt(struct v4l2_subdev *sd,
		struct v4l2_subdev_pad_config *cfg,
		struct v4l2_subdev_format *format)
{
	struct tc358743_state *state = to_state(sd);
	u32 code = format->format.code; /* is overwritten by get_fmt */
	int ret = tc358743_get_fmt(sd, cfg, format);

	format->format.code = code;

	if (ret)
		return ret;

	switch (code) {
	case MEDIA_BUS_FMT_RGB888_1X24:
	case MEDIA_BUS_FMT_UYVY8_1X16:
		break;
	default:
		return -EINVAL;
	}

	if (format->which == V4L2_SUBDEV_FORMAT_TRY)
		return 0;

	enable_stream(sd, false);
	tc358743_set_pll(sd);
	tc358743_set_csi(sd);
	tc358743_set_csi_color_space(sd);

	return 0;
}

The call to tc358743_get_fmt() ensures that all the other fields are
filled in correctly, and the FORMAT_TRY check ensures that calling this
with FORMAT_TRY doesn't actually change anything.

Obviously, set_fmt should be moved after get_fmt so that it can call
the get_fmt function, and like get_fmt it should be moved to the PAD OPS
section.

<snip>

Regards,

	Hans

