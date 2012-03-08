Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:54944 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab2CHRRv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2012 12:17:51 -0500
Date: Thu, 8 Mar 2012 19:17:46 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: Re: [PATCH v3 5/5] v4l: Add driver for Micron MT9M032 camera sensor
Message-ID: <20120308171745.GE1591@valkosipuli.localdomain>
References: <1331051559-13841-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1331051559-13841-6-git-send-email-laurent.pinchart@ideasonboard.com>
 <20120306231633.GO1075@valkosipuli.localdomain>
 <2041187.ucBOt7zOjI@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2041187.ucBOt7zOjI@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Wed, Mar 07, 2012 at 12:31:34PM +0100, Laurent Pinchart wrote:
...
> > > +static u32 mt9m032_row_time(struct mt9m032 *sensor, unsigned int width)
> > > +{
> > > +	unsigned int effective_width;
> > > +	u32 ns;
> > > +
> > > +	effective_width = width + 716; /* emperical value */
> > 
> > Why empirical value? This should be directly related to image width
> > (before binning) and horizontal blanking.
> 
> Ask Martin :-)
> 
> I don't have access to the documentation nor the hardware, so I'd rather keep 
> the value as-is for now.

Ok. Let's keep this one then.

> > > +	ns = div_u64(1000000000ULL * effective_width, sensor->pix_clock);
> > > +	dev_dbg(to_dev(sensor),	"MT9M032 line time: %u ns\n", ns);
> > > +	return ns;
> > > +}
> 
> [snip]
> 
> > > +static int mt9m032_setup_pll(struct mt9m032 *sensor)
> > > +{
> > > +	static const struct aptina_pll_limits limits = {
> > > +		.ext_clock_min = 8000000,
> > > +		.ext_clock_max = 16500000,
> > > +		.int_clock_min = 2000000,
> > > +		.int_clock_max = 24000000,
> > > +		.out_clock_min = 322000000,
> > > +		.out_clock_max = 693000000,
> > > +		.pix_clock_max = 99000000,
> > > +		.n_min = 1,
> > > +		.n_max = 64,
> > > +		.m_min = 16,
> > > +		.m_max = 255,
> > > +		.p1_min = 1,
> > > +		.p1_max = 128,
> > > +	};
> > > +
> > > +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> > > +	struct mt9m032_platform_data *pdata = sensor->pdata;
> > > +	struct aptina_pll pll;
> > > +	int ret;
> > > +
> > > +	pll.ext_clock = pdata->ext_clock;
> > > +	pll.pix_clock = pdata->pix_clock;
> > 
> > You could initialise these in the declaration.
> 
> Yes, but I would find that less readable :-)

Ok.

...

> > > +	rect.width = min(rect.width, MT9M032_PIXEL_ARRAY_WIDTH - rect.left);
> > > +	rect.height = min(rect.height, MT9M032_PIXEL_ARRAY_HEIGHT - 
> rect.top);
> > > +
> > > +	__crop = __mt9m032_get_pad_crop(sensor, fh, crop->which);
> > > +
> > > +	if (rect.width != __crop->width || rect.height != __crop->height) {
> > > +		/* Reset the output image size if the crop rectangle size has
> > > +		 * been modified.
> > > +		 */
> > > +		format = __mt9m032_get_pad_format(sensor, fh, crop->which);
> > > +		format->width = rect.width;
> > > +		format->height = rect.height;
> > 
> > I think you can do this unconditionally.
> 
> I could, but I hope to add binning/skipping support to this driver soon. The 
> check will be needed then.

Sounds fine for me.

> > > +	}
> > > +
> > > +	*__crop = rect;
> > > +	crop->rect = rect;
> > > +
> > > +	if (crop->which != V4L2_SUBDEV_FORMAT_ACTIVE)
> > > +		return 0;
> > > +
> > > +	return mt9m032_update_geom_timing(sensor);
> > > +}
> 
> [snip]
> 
> > > +static int mt9m032_set_frame_interval(struct v4l2_subdev *subdev,
> > > +				      struct v4l2_subdev_frame_interval *fi)
> > > +{
> > > +	struct mt9m032 *sensor = to_mt9m032(subdev);
> > > +	int ret;
> > > +
> > > +	if (sensor->streaming)
> > > +		return -EBUSY;
> > > +
> > > +	memset(fi->reserved, 0, sizeof(fi->reserved));
> > 
> > I'm not quite sure these should be touched.
> 
> Why not ? Do you think this could cause a regression in the future when the 
> fields won't be reserved anymore ?

The user is responsible for setting those fields to zero. If we set them to
zero for them they will start relying on that. At some point that might not
hold true anymore.

> > > +	ret = mt9m032_update_timing(sensor, &fi->interval);
> > > +	if (!ret)
> > > +		sensor->frame_interval = fi->interval;
> > > +
> > > +	return ret;
> > > +}
> 
> 
> > > +static int mt9m032_set_ctrl(struct v4l2_ctrl *ctrl)
> > > +{
> > > +	struct mt9m032 *sensor =
> > > +		container_of(ctrl->handler, struct mt9m032, ctrls);
> > > +	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
> > > +	int ret;
> > > +
> > > +	switch (ctrl->id) {
> > > +	case V4L2_CID_GAIN:
> > > +		return mt9m032_set_gain(sensor, ctrl->val);
> > 
> > The gain control only touches analogue gain. Shouldn't you use
> > V4L2_CID_ANALOGUE_GAIN (or something alike) instead?
> 
> If there was such a control in mainline, sure ;-)
> 
> I plan to revisit controls in the various Aptina sensor drivers I maintain in 
> the near future. Analog/digital gains will be on my to-do list.

Fine for me. Let's think these after 3.4 merge window.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
