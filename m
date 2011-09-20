Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:42413 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1ITWKh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Sep 2011 18:10:37 -0400
Date: Wed, 21 Sep 2011 01:10:33 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Subject: Re: [PATCH v1 3/3] v4l: Add v4l2 subdev driver for S5K6AAFX sensor
Message-ID: <20110920221033.GO1845@valkosipuli.localdomain>
References: <1316519939-22540-1-git-send-email-s.nawrocki@samsung.com>
 <1316519939-22540-4-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316519939-22540-4-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 20, 2011 at 01:58:59PM +0200, Sylwester Nawrocki wrote:
> This driver exposes preview mode operation of the S5K6AAFX sensor with
> embedded SoC ISP. It uses one of the five user predefined configuration
> register sets. There is yet no support for capture (snapshot) operation.
> Following controls are supported:
> manual/auto exposure and gain, power line frequency (anti-flicker),
> saturation, sharpness, brightness, contrast, white balance temperature,
> color effects. horizontal/vertical image flip, frame interval.

Thanks for the patch, Sylwester!

[clip]
> +	v4l2_ctrl_new_std_menu(hdl, ops, V4L2_CID_POWER_LINE_FREQUENCY,
> +			       V4L2_CID_POWER_LINE_FREQUENCY_AUTO, 0,
> +			       V4L2_CID_POWER_LINE_FREQUENCY_50HZ);
> +
> +	v4l2_ctrl_new_std_menu(hdl, ops, V4L2_CID_COLORFX,
> +			       V4L2_COLORFX_SKETCH, 0x3D0, V4L2_COLORFX_NONE);

New items may be added to standard menus so you should mask out also
undefined bits. Say, ~0x42f (hope I got that right).

Youd also don't need to check for invalid menu ids; the control framework
does this for you.

> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_WHITE_BALANCE_TEMPERATURE,
> +			  0, 256, 1, 0);
> +
> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_SATURATION, -127, 127, 1, 0);
> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_SHARPNESS, -127, 127, 1, 0);
> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_BRIGHTNESS, -127, 127, 1, 0);
> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_CONTRAST, -127, 127, 1, 0);
> +
> +	s5k6aa->sd.ctrl_handler = hdl;

Shoudln't this assignment be done after checking for the error?

> +	if (hdl->error) {
> +		ret = hdl->error;
> +		v4l2_ctrl_handler_free(hdl);
> +	}
> +	return ret;

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
