Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60890 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727999AbeKPXq0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Nov 2018 18:46:26 -0500
Date: Fri, 16 Nov 2018 15:33:59 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Marco Felsch <m.felsch@pengutronix.de>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, robh+dt@kernel.org,
        mark.rutland@arm.com, enrico.scholz@sigma-chemnitz.de,
        akinobu.mita@gmail.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        graphics@pengutronix.de
Subject: Re: [PATCH v2 3/6] media: mt9m111: add support to select formats and
 fps for {Q,SXGA}
Message-ID: <20181116133359.ecni6us77qc7hkxg@valkosipuli.retiisi.org.uk>
References: <20181029182410.18783-1-m.felsch@pengutronix.de>
 <20181029182410.18783-4-m.felsch@pengutronix.de>
 <20181116132610.54elo2dqsrrlydlh@valkosipuli.retiisi.org.uk>
 <e28d74c2-d2de-6450-d572-6d691b7416c7@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e28d74c2-d2de-6450-d572-6d691b7416c7@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Nov 16, 2018 at 02:31:01PM +0100, Hans Verkuil wrote:
> On 11/16/2018 02:26 PM, Sakari Ailus wrote:
> > Hi Marco, Michael,
> > 
> > On Mon, Oct 29, 2018 at 07:24:07PM +0100, Marco Felsch wrote:
> >> From: Michael Grzeschik <m.grzeschik@pengutronix.de>
> >>
> >> This patch implements the framerate selection using the skipping and
> >> readout power-modi features. The power-modi cut the framerate by half
> >> and each context has an independent selection bit. The same applies to
> >> the 2x skipping feature.
> >>
> >> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> >> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> >>
> >> ---
> >> Changelog
> >>
> >> v2:
> >> - fix updating read mode register, use mt9m111_reg_mask() to update the
> >>   relevant bits only. For this purpose add reg_mask field to
> >>   struct mt9m111_mode_info.
> >>
> >>  drivers/media/i2c/mt9m111.c | 163 ++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 163 insertions(+)
> >>
> >> diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
> 
> <snip>
> 
> >> +static const struct mt9m111_mode_info *
> >> +mt9m111_find_mode(struct mt9m111 *mt9m111, unsigned int req_fps,
> >> +		  unsigned int width, unsigned int height)
> >> +{
> >> +	const struct mt9m111_mode_info *mode;
> >> +	struct v4l2_rect *sensor_rect = &mt9m111->rect;
> >> +	unsigned int gap, gap_best = (unsigned int) -1;
> >> +	int i, best_gap_idx = 1;
> >> +
> >> +	/* find best matched fps */
> >> +	for (i = 0; i < MT9M111_NUM_MODES; i++) {
> >> +		unsigned int fps = mt9m111_mode_data[i].max_fps;
> >> +
> >> +		gap = abs(fps - req_fps);
> >> +		if (gap < gap_best) {
> >> +			best_gap_idx = i;
> >> +			gap_best = gap;
> >> +		}
> > 
> > Could you use v4l2_find_nearest_size() instead?
> > 
> > Also see below...
> > 
> >> +	}
> >> +
> >> +	/*
> >> +	 * Use context a/b default timing values instead of calculate blanking
> >> +	 * timing values.
> >> +	 */
> >> +	mode = &mt9m111_mode_data[best_gap_idx];
> >> +	mt9m111->ctx = (best_gap_idx == MT9M111_MODE_QSXGA_30FPS) ? &context_a :
> >> +								    &context_b;
> >> +
> >> +	/*
> >> +	 * Check if current settings support the fps because fps selection is
> >> +	 * based on the row/col skipping mechanism which has some restriction.
> >> +	 */
> >> +	if (sensor_rect->width != mode->sensor_w ||
> >> +	    sensor_rect->height != mode->sensor_h ||
> >> +	    width > mode->max_image_w ||
> >> +	    height > mode->max_image_h) {
> >> +		/* reset sensor window size */
> >> +		mt9m111->rect.left = MT9M111_MIN_DARK_COLS;
> >> +		mt9m111->rect.top = MT9M111_MIN_DARK_ROWS;
> >> +		mt9m111->rect.width = mode->sensor_w;
> >> +		mt9m111->rect.height = mode->sensor_h;
> >> +
> >> +		/* reset image size */
> >> +		mt9m111->width = mode->max_image_w;
> >> +		mt9m111->height = mode->max_image_h;
> >> +
> >> +		dev_warn(mt9m111->subdev.dev,
> >> +			 "Warning: update image size %dx%d[%dx%d] -> %dx%d[%dx%d]\n",
> >> +			 sensor_rect->width, sensor_rect->height, width, height,
> >> +			 mode->sensor_w, mode->sensor_h, mode->max_image_w,
> >> +			 mode->max_image_h);
> > 
> > I wouldn't expect requesting a particular frame rate to change the sensor
> > format. The other way around is definitely fine though.
> > 
> > Cc Hans.
> 
> I agree with Sakari. Changing the framerate should never change the format.
> When you enumerate framerates those framerates are the allowed framerates
> for the mediabus format and the resolution. So changing the framerate should
> never modify the format or resolution. Instead, the framerate should be
> mapped to a framerate that is valid for the format/resolution combo.

I don't think this is actually documented, at least not for the sub-device
API. I can send a patch.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
