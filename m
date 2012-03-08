Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:39674 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412Ab2CHNc0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2012 08:32:26 -0500
Date: Thu, 8 Mar 2012 15:29:10 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: Re: [PATCH v5 34/35] smiapp: Generic SMIA++/SMIA PLL calculator
Message-ID: <20120308132910.GB1591@valkosipuli.localdomain>
References: <20120306163239.GN1075@valkosipuli.localdomain>
 <1331051596-8261-34-git-send-email-sakari.ailus@iki.fi>
 <1960253.l1xo097dr7@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1960253.l1xo097dr7@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Wed, Mar 07, 2012 at 01:26:20PM +0100, Laurent Pinchart wrote:
> Thanks for the patch.

Thanks for the comments!

> On Tuesday 06 March 2012 18:33:15 Sakari Ailus wrote:
> > From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> > 
> > Calculate PLL configuration based on input data: sensor configuration, board
> > properties and sensor-specific limits.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> 
> [snip]
> 
> > diff --git a/drivers/media/video/smiapp-pll.c
> > b/drivers/media/video/smiapp-pll.c new file mode 100644
> > index 0000000..3a999c0
> > --- /dev/null
> > +++ b/drivers/media/video/smiapp-pll.c
> 
> [snip]
> 
> > +int smiapp_pll_calculate(struct device *dev, struct smiapp_pll_limits
> > *limits,
> > +			 struct smiapp_pll *pll)
> > +{
> 
> [snip]
> 
> > +	/*
> > +	 * Some sensors perform analogue binning and some do this
> > +	 * digitally. The ones doing this digitally can be roughly be
> > +	 * found out using this formula. The ones doing this digitally
> > +	 * should run at higher clock rate, so smaller divisor is used
> > +	 * on video timing side.
> > +	 */
> > +	if (limits->min_line_length_pck_bin > limits->min_line_length_pck
> > +	    / pll->binning_horizontal)
> > +		vt_op_binning_div = pll->binning_horizontal;
> > +	else
> > +		vt_op_binning_div = 1;
> > +	dev_dbg(dev, "vt_op_binning_div: %d\n", vt_op_binning_div);
> > +
> > +	/*
> > +	 * Profile 2 supports vt_pix_clk_div E [4, 10]
> > +	 *
> > +	 * Horizontal binning can be used as a base for difference in
> > +	 * divisors. One must make sure that horizontal blanking is
> > +	 * enough to accommodate the CSI-2 sync codes.
> > +	 *
> > +	 * Take scaling factor into account as well.
> > +	 *
> > +	 * Find absolute limits for the factor of vt divider.
> > +	 */
> > +	dev_dbg(dev, "scale_m: %d\n", pll->scale_m);
> > +	min_vt_div = DIV_ROUND_UP(pll->op_pix_clk_div * pll->op_sys_clk_div
> > +				  * pll->scale_n,
> 
> I still need
> 
>         if (pll->flags & SMIAPP_PLL_FLAG_DUAL_READOUT)
>                num_readout_paths = 2;
>         else
>                num_readout_paths = 1;
>         min_vt_div = DIV_ROUND_UP(pll->op_pix_clk_div * pll->op_sys_clk_div
>                                  * pll->scale_n * num_readout_paths,
> 
> for the AR0330 driver, but I can add that later.

Here?

That should come from lane_op_clock_ratio if your sensor needs that.

> > +				  lane_op_clock_ratio * vt_op_binning_div
> > +				  * pll->scale_m);
> 
> [snip]
> 
> > +	/*
> > +	 * Find pix_div such that a legal pix_div * sys_div results
> > +	 * into a value which is not smaller than div, the desired
> > +	 * divisor.
> > +	 */
> > +	for (vt_div = min_vt_div; vt_div <= max_vt_div;
> > +	     vt_div += 2 - (vt_div & 1)) {
> > +		for (sys_div = min_sys_div;
> > +		     sys_div <= max_sys_div;
> > +		     sys_div += 2 - (sys_div & 1)) {
> > +			int pix_div = DIV_ROUND_UP(vt_div, sys_div);
> > +
> > +			if (pix_div <
> > +			    limits->min_vt_pix_clk_div
> > +			    || pix_div
> > +			    > limits->max_vt_pix_clk_div) {
> 
> 			if (pix_div < limits->min_vt_pix_clk_div ||
> 			    pix_div > limits->max_vt_pix_clk_div) {

Will fix.

> > +				dev_dbg(dev,
> > +					"pix_div %d too small or too big (%d--%d)\n",
> > +					pix_div,
> > +					limits->min_vt_pix_clk_div,
> > +					limits->max_vt_pix_clk_div);
> > +				continue;
> > +			}
> > +
> > +			/* Check if this one is better. */
> > +			if (pix_div * sys_div
> > +			    <= ALIGN(min_vt_div, best_pix_div))
> > +				best_pix_div = pix_div;
> > +		}
> > +		if (best_pix_div < INT_MAX >> 1)
> > +			break;
> > +	}
> 
> [snip]
> 
> > diff --git a/drivers/media/video/smiapp/smiapp-core.c
> > b/drivers/media/video/smiapp/smiapp-core.c new file mode 100644
> > index 0000000..879fb1e
> > --- /dev/null
> > +++ b/drivers/media/video/smiapp/smiapp-core.c

I think I accidentally combined the two patches. I'll separate them again.

> 
> [snip]
> 
> > +static void smiapp_get_crop_compose(struct v4l2_subdev *subdev,
> > +				    struct v4l2_subdev_fh *fh,
> > +				    struct v4l2_rect **crops,
> > +				    struct v4l2_rect **comps, int which)
> > +{
> > +	struct smiapp_subdev *ssd = to_smiapp_subdev(subdev);
> > +	int i;
> 
> Can you guess ? :-)

Hmm. signed? unsigned? int8_t? bool? :-D

> > +
> > +	if (which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> > +		if (crops)
> > +			for (i = 0; i < subdev->entity.num_pads; i++)
> > +				crops[i] = &ssd->crop[i];
> > +		if (comps)
> > +			*comps = &ssd->compose;
> > +	} else {
> > +		if (crops) {
> > +			for (i = 0; i < subdev->entity.num_pads; i++) {
> > +				crops[i] = v4l2_subdev_get_try_crop(fh, i);
> > +				BUG_ON(!crops[i]);
> > +			}
> > +		}
> > +		if (comps) {
> > +			*comps = v4l2_subdev_get_try_compose(fh,
> > +							     SMIAPP_PAD_SINK);
> > +			BUG_ON(!*comps);
> > +		}
> > +	}
> > +}
> 
> [snip]
> 
> > +static int smiapp_set_format(struct v4l2_subdev *subdev,
> > +			     struct v4l2_subdev_fh *fh,
> > +			     struct v4l2_subdev_format *fmt)
> > +{
> > +	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
> > +	struct smiapp_subdev *ssd = to_smiapp_subdev(subdev);
> > +	struct v4l2_rect *crops[SMIAPP_PADS];
> > +	const struct smiapp_csi_data_format *csi_format = sensor->csi_format;
> > +	int i;
> 
> :-D

I will replace "int" with "unsigned". :-D

> > +
> > +	mutex_lock(&sensor->mutex);
> > +
> > +	smiapp_get_crop_compose(subdev, fh, crops, NULL, fmt->which);
> > +
> > +	if (subdev == &sensor->src->sd && fmt->pad == SMIAPP_PAD_SRC) {
> > +		for (i = 0; i < ARRAY_SIZE(smiapp_csi_data_formats); i++) {
> > +			if (sensor->mbus_frame_fmts & (1 << i) &&
> > +			    smiapp_csi_data_formats[i].code
> > +			    == fmt->format.code) {
> > +				csi_format = &smiapp_csi_data_formats[i];
> > +				if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> > +					sensor->csi_format = csi_format;
> > +				break;
> > +			}
> > +		}
> > +	}
> > +
> > +	if (fmt->pad == ssd->source_pad) {
> > +		int rval;
> > +
> > +		rval = __smiapp_get_format(subdev, fh, fmt);
> > +		fmt->format.code = csi_format->code;
> > +
> > +		mutex_unlock(&sensor->mutex);
> > +		return rval;
> > +	}
> > +
> > +	fmt->format.code = csi_format->code;
> 
> This will result in the format code at the output of the pixel array being
> equal to the format code at the output of the binner/scaler. I don't think
> you want that.

Good point. I created another function to get that information that also
__smiapp_get_format() uses.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
