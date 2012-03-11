Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:39329 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab2CKOnD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Mar 2012 10:43:03 -0400
Date: Sun, 11 Mar 2012 16:42:57 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: Re: [PATCH v6] v4l: Add driver for Micron MT9M032 camera sensor
Message-ID: <20120311144257.GI1591@valkosipuli.localdomain>
References: <1331324481-9926-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1331476421-4402-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331476421-4402-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch.

On Sun, Mar 11, 2012 at 03:33:41PM +0100, Laurent Pinchart wrote:
> From: Martin Hostettler <martin@neutronstar.dyndns.org>
> 
> The MT9M032 is a parallel 1.6MP sensor from Micron controlled through I2C.
> 
> The driver creates a V4L2 subdevice. It currently supports cropping, gain,
> exposure and v/h flipping controls in monochrome mode with an
> external pixel clock.
> 
> Signed-off-by: Martin Hostettler <martin@neutronstar.dyndns.org>
> [Lots of clean up, fixes and enhancements]
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/Kconfig   |    8 +
>  drivers/media/video/Makefile  |    1 +
>  drivers/media/video/mt9m032.c |  864 +++++++++++++++++++++++++++++++++++++++++
>  include/media/mt9m032.h       |   36 ++
>  4 files changed, 909 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/mt9m032.c
>  create mode 100644 include/media/mt9m032.h

...

> +static int mt9m032_update_timing(struct mt9m032 *sensor,
> +				 struct v4l2_fract *interval)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> +	struct v4l2_rect *crop = &sensor->crop;
> +	unsigned int min_vblank;
> +	unsigned int vblank;
> +	u32 row_time;
> +
> +	if (!interval)
> +		interval = &sensor->frame_interval;
> +
> +	row_time = mt9m032_row_time(sensor, crop->width);
> +
> +	vblank = div_u64(1000000000ULL * interval->numerator,
> +			 (u64)row_time * interval->denominator)
> +	       - crop->height;

Shouldn't you check interval->denominator isn't zero? I don't think it's
being done here or elsewhere, so dividing by zero looks possible here.

> +	if (vblank > MT9M032_VBLANK_MAX) {
> +		/* hardware limits to 11 bit values */
> +		interval->denominator = 1000;
> +		interval->numerator =
> +			div_u64((crop->height + MT9M032_VBLANK_MAX) *
> +				(u64)row_time * interval->denominator,
> +				1000000000ULL);
> +		vblank = div_u64(1000000000ULL * interval->numerator,
> +				 (u64)row_time * interval->denominator)
> +		       - crop->height;
> +	}
> +	/* enforce minimal 1.6ms blanking time. */
> +	min_vblank = 1600000 / row_time;
> +	vblank = clamp_t(unsigned int, vblank, min_vblank, MT9M032_VBLANK_MAX);
> +
> +	return mt9m032_write(client, MT9M032_VBLANK, vblank);
> +}
> +

After addressing the above issue,

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
