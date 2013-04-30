Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55674 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758600Ab3D3NxL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Apr 2013 09:53:11 -0400
Date: Tue, 30 Apr 2013 15:53:01 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH v9 02/20] V4L2: support asynchronous subdevice
 registration
Message-ID: <20130430135301.GD16843@pengutronix.de>
References: <1365781240-16149-1-git-send-email-g.liakhovetski@gmx.de>
 <1365781240-16149-3-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365781240-16149-3-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Fri, Apr 12, 2013 at 05:40:22PM +0200, Guennadi Liakhovetski wrote:
> Currently bridge device drivers register devices for all subdevices
> synchronously, tupically, during their probing. E.g. if an I2C CMOS sensor
> is attached to a video bridge device, the bridge driver will create an I2C
> device and wait for the respective I2C driver to probe. This makes linking
> of devices straight forward, but this approach cannot be used with
> intrinsically asynchronous and unordered device registration systems like
> the Flattened Device Tree. To support such systems this patch adds an
> asynchronous subdevice registration framework to V4L2. To use it respective
> (e.g. I2C) subdevice drivers must register themselves with the framework.
> A bridge driver on the other hand must register notification callbacks,
> that will be called upon various related events.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> +
> +static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *notifier,
> +						    struct v4l2_async_subdev_list *asdl)
> +{
> +	struct v4l2_subdev *sd = v4l2_async_to_subdev(asdl);
> +	struct v4l2_async_subdev *asd = NULL;
> +	bool (*match)(struct device *,
> +		      struct v4l2_async_hw_info *);
> +
> +	list_for_each_entry (asd, &notifier->waiting, list) {
> +		struct v4l2_async_hw_info *hw = &asd->hw;
> +
> +		/* bus_type has been verified valid before */
> +		switch (hw->bus_type) {
> +		case V4L2_ASYNC_BUS_CUSTOM:
> +			match = hw->match.custom.match;
> +			if (!match)
> +				/* Match always */
> +				return asd;
> +			break;
> +		case V4L2_ASYNC_BUS_PLATFORM:
> +			match = match_platform;
> +			break;
> +		case V4L2_ASYNC_BUS_I2C:
> +			match = match_i2c;
> +			break;
> +		default:
> +			/* Cannot happen, unless someone breaks us */
> +			WARN_ON(true);
> +			return NULL;
> +		}
> +
> +		if (match && match(sd->dev, hw))
> +			break;
> +	}
> +
> +	return asd;

'asd' can never be NULL here. You have to explicitly return NULL when
leaving the loop without match.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
