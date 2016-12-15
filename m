Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55668 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755988AbcLOLkB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 06:40:01 -0500
Date: Thu, 15 Dec 2016 13:39:56 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        mchehab@osg.samsung.com, shuahkh@osg.samsung.com
Subject: Re: [RFC v3 21/21] omap3isp: Don't rely on devm for memory resource
 management
Message-ID: <20161215113956.GF16630@valkosipuli.retiisi.org.uk>
References: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com>
 <1472255009-28719-22-git-send-email-sakari.ailus@linux.intel.com>
 <1551037.Hfmqsgr3In@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1551037.Hfmqsgr3In@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the review!

On Thu, Dec 15, 2016 at 01:23:50PM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Saturday 27 Aug 2016 02:43:29 Sakari Ailus wrote:
> > devm functions are fine for managing resources that are directly related
> > to the device at hand and that have no other dependencies. However, a
> > process holding a file handle to a device created by a driver for a device
> > may result in the file handle left behind after the device is long gone.
> > This will result in accessing released (and potentially reallocated)
> > memory.
> > 
> > Instead, rely on the media device which will stick around until all users
> > are gone.
> 
> Could you move this patch to the beginning of the series to show that 
> converting the driver away from devm_* isn't enough to fix the problem that 
> the series tries to address ?

Unfortunately not. The patch depends on the previous patch; the
isp_release() function is called once the last user of the device nodes (MC,
V4L2 and V4L2 sub-dev) is gone.

I'll also see what could be done based on Mauro's suggestion to move
streamoff to device removal. That could fix a number of problems (but not
all of them).

> 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/media/platform/omap3isp/isp.c         | 38 +++++++++++++++++-------
> >  drivers/media/platform/omap3isp/ispccp2.c     |  3 ++-
> >  drivers/media/platform/omap3isp/isph3a_aewb.c | 20 +++++++++-----
> >  drivers/media/platform/omap3isp/isph3a_af.c   | 20 +++++++++-----
> >  drivers/media/platform/omap3isp/isphist.c     |  5 ++--
> >  drivers/media/platform/omap3isp/ispstat.c     |  2 ++
> >  6 files changed, 63 insertions(+), 25 deletions(-)
> > 
> > diff --git a/drivers/media/platform/omap3isp/isp.c
> > b/drivers/media/platform/omap3isp/isp.c index 689efe8..262ddf7 100644
> > --- a/drivers/media/platform/omap3isp/isp.c
> > +++ b/drivers/media/platform/omap3isp/isp.c
> > @@ -1370,7 +1370,7 @@ static int isp_get_clocks(struct isp_device *isp)
> >  	unsigned int i;
> > 
> >  	for (i = 0; i < ARRAY_SIZE(isp_clocks); ++i) {
> > -		clk = devm_clk_get(isp->dev, isp_clocks[i]);
> > +		clk = clk_get(isp->dev, isp_clocks[i]);
> >  		if (IS_ERR(clk)) {
> >  			dev_err(isp->dev, "clk_get %s failed\n", 
> isp_clocks[i]);
> >  			return PTR_ERR(clk);
> > @@ -1382,6 +1382,14 @@ static int isp_get_clocks(struct isp_device *isp)
> >  	return 0;
> >  }
> > 
> > +static void isp_put_clocks(struct isp_device *isp)
> > +{
> > +	unsigned int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(isp_clocks); ++i)
> > +		clk_put(isp->clock[i]);
> > +}
> > +
> >  /*
> >   * omap3isp_get - Acquire the ISP resource.
> >   *
> > @@ -1596,7 +1604,6 @@ static void isp_unregister_entities(struct isp_device
> > *isp) omap3isp_stat_unregister_entities(&isp->isp_af);
> >  	omap3isp_stat_unregister_entities(&isp->isp_hist);
> > 
> > -	v4l2_device_unregister(&isp->v4l2_dev);
> 
> This isn't correct. The v4l2_device instance should be unregistered here, to 
> make sure that the subdev nodes are unregistered too. And even if moving the 

Good point, I'll fix that for the next revision.

> function call was correct, it should be done in a separate patch as it's 
> unrelated to $SUBJECT.
> 
> >  	media_device_unregister(isp->media_dev);
> >  	media_device_put(isp->media_dev);
> >  }
> > @@ -1951,6 +1958,8 @@ static void isp_release(struct media_device *mdev)
> >  {
> >  	struct isp_device *isp = media_device_priv(mdev);
> > 
> > +	v4l2_device_unregister(&isp->v4l2_dev);
> > +
> >  	isp_cleanup_modules(isp);
> >  	isp_xclk_cleanup(isp);
> > 
> > @@ -1959,6 +1968,10 @@ static void isp_release(struct media_device *mdev)
> >  	__omap3isp_put(isp, false);
> > 
> >  	media_entity_enum_cleanup(&isp->crashed);
> > +
> > +	isp_put_clocks(isp);
> > +
> > +	kfree(isp);
> >  }
> > 
> >  static int isp_attach_iommu(struct isp_device *isp)
> > @@ -2211,7 +2224,7 @@ static int isp_probe(struct platform_device *pdev)
> >  	int ret;
> >  	int i, m;
> > 
> > -	isp = devm_kzalloc(&pdev->dev, sizeof(*isp), GFP_KERNEL);
> > +	isp = kzalloc(sizeof(*isp), GFP_KERNEL);
> >  	if (!isp) {
> >  		dev_err(&pdev->dev, "could not allocate memory\n");
> >  		return -ENOMEM;
> > @@ -2220,21 +2233,23 @@ static int isp_probe(struct platform_device *pdev)
> >  	ret = of_property_read_u32(pdev->dev.of_node, "ti,phy-type",
> >  				   &isp->phy_type);
> >  	if (ret)
> > -		return ret;
> > +		goto error_release_isp;
> 
> I propose reorganizing this a bit more and moving DT parsing after the 
> platform_set_drvdata() call. That way you can pass the ISP device to 
> isp_of_parse_nodes() (which by the way also calls devm_* functions) and group 
> the mutex_destroy() and various kfree() calls under a single error label. You 
> might want to split this reorganization in a separate patch.

Ack.

> 
> >  	isp->syscon = syscon_regmap_lookup_by_phandle(pdev->dev.of_node,
> >  						      "syscon");
> > -	if (IS_ERR(isp->syscon))
> > -		return PTR_ERR(isp->syscon);
> > +	if (IS_ERR(isp->syscon)) {
> > +		ret = PTR_ERR(isp->syscon);
> > +		goto error_release_isp;
> > +	}
> > 
> >  	ret = of_property_read_u32_index(pdev->dev.of_node, "syscon", 1,
> >  					 &isp->syscon_offset);
> >  	if (ret)
> > -		return ret;
> > +		goto error_release_isp;
> > 
> >  	ret = isp_of_parse_nodes(&pdev->dev, &isp->notifier);
> >  	if (ret < 0)
> > -		return ret;
> > +		goto error_release_isp;
> > 
> >  	isp->autoidle = autoidle;
> > 
> > @@ -2251,8 +2266,8 @@ static int isp_probe(struct platform_device *pdev)
> >  	platform_set_drvdata(pdev, isp);
> > 
> >  	/* Regulators */
> > -	isp->isp_csiphy1.vdd = devm_regulator_get(&pdev->dev, "vdd-csiphy1");
> > -	isp->isp_csiphy2.vdd = devm_regulator_get(&pdev->dev, "vdd-csiphy2");
> > +	isp->isp_csiphy1.vdd = regulator_get(&pdev->dev, "vdd-csiphy1");
> > +	isp->isp_csiphy2.vdd = regulator_get(&pdev->dev, "vdd-csiphy2");
> 
> How about moving this to omap3isp_csiphy_init() ? You also need to release 
> those regulators.
> 
> However, I wonder whether we couldn't keep devm_* for the clocks and 
> regulators, as they shouldn't be touched anymore after remove() time.

Good point.

> 
> >  	/* Clocks
> >  	 *
> > @@ -2384,6 +2399,9 @@ error_isp:
> >  	__omap3isp_put(isp, false);
> >  error:
> >  	mutex_destroy(&isp->isp_mutex);
> > +	isp_put_clocks(isp);
> > +error_release_isp:
> > +	kfree(isp);
> > 
> >  	return ret;
> >  }
> > diff --git a/drivers/media/platform/omap3isp/ispccp2.c
> > b/drivers/media/platform/omap3isp/ispccp2.c index ca09523..d49ce8a 100644
> > --- a/drivers/media/platform/omap3isp/ispccp2.c
> > +++ b/drivers/media/platform/omap3isp/ispccp2.c
> > @@ -1135,7 +1135,7 @@ int omap3isp_ccp2_init(struct isp_device *isp)
> >  	 * TODO: Don't hardcode the usage of PHY1 (shared with CSI2c).
> >  	 */
> >  	if (isp->revision == ISP_REVISION_2_0) {
> > -		ccp2->vdds_csib = devm_regulator_get(isp->dev, "vdds_csib");
> > +		ccp2->vdds_csib = regulator_get(isp->dev, "vdds_csib");
> >  		if (IS_ERR(ccp2->vdds_csib)) {
> >  			dev_dbg(isp->dev,
> >  				"Could not get regulator vdds_csib\n");
> > @@ -1163,4 +1163,5 @@ void omap3isp_ccp2_cleanup(struct isp_device *isp)
> > 
> >  	omap3isp_video_cleanup(&ccp2->video_in);
> >  	media_entity_cleanup(&ccp2->subdev.entity);
> > +	regulator_put(ccp2->vdds_csib);
> >  }
> > diff --git a/drivers/media/platform/omap3isp/isph3a_aewb.c
> > b/drivers/media/platform/omap3isp/isph3a_aewb.c index ccaf92f..130df8b
> > 100644
> > --- a/drivers/media/platform/omap3isp/isph3a_aewb.c
> > +++ b/drivers/media/platform/omap3isp/isph3a_aewb.c
> 
> Please see my comments on isph3a_af.c below, they apply here too.
> 
> [snip]
> 
> > diff --git a/drivers/media/platform/omap3isp/isph3a_af.c
> > b/drivers/media/platform/omap3isp/isph3a_af.c index 92937f7..7eecf97 100644
> > --- a/drivers/media/platform/omap3isp/isph3a_af.c
> > +++ b/drivers/media/platform/omap3isp/isph3a_af.c
> > @@ -352,9 +352,10 @@ int omap3isp_h3a_af_init(struct isp_device *isp)
> >  {
> >  	struct ispstat *af = &isp->isp_af;
> >  	struct omap3isp_h3a_af_config *af_cfg;
> > -	struct omap3isp_h3a_af_config *af_recover_cfg;
> > +	struct omap3isp_h3a_af_config *af_recover_cfg = NULL;
> > +	int ret;
> > 
> > -	af_cfg = devm_kzalloc(isp->dev, sizeof(*af_cfg), GFP_KERNEL);
> > +	af_cfg = kzalloc(sizeof(*af_cfg), GFP_KERNEL);
> >  	if (af_cfg == NULL)
> >  		return -ENOMEM;
> > 
> > @@ -364,12 +365,12 @@ int omap3isp_h3a_af_init(struct isp_device *isp)
> >  	af->isp = isp;
> > 
> >  	/* Set recover state configuration */
> > -	af_recover_cfg = devm_kzalloc(isp->dev, sizeof(*af_recover_cfg),
> > -				      GFP_KERNEL);
> > +	af_recover_cfg = kzalloc(sizeof(*af_recover_cfg), GFP_KERNEL);
> >  	if (!af_recover_cfg) {
> >  		dev_err(af->isp->dev, "AF: cannot allocate memory for recover 
> "
> >  				      "configuration.\n");
> > -		return -ENOMEM;
> > +		ret = -ENOMEM;
> > +		goto err;
> >  	}
> > 
> >  	af_recover_cfg->paxel.h_start = OMAP3ISP_AF_PAXEL_HZSTART_MIN;
> > @@ -381,13 +382,20 @@ int omap3isp_h3a_af_init(struct isp_device *isp)
> >  	if (h3a_af_validate_params(af, af_recover_cfg)) {
> >  		dev_err(af->isp->dev, "AF: recover configuration is "
> >  				      "invalid.\n");
> 
> Unrelated to this patch, but this shouldn't happen. I wonder whether we could 
> remove the check.
> 
> > -		return -EINVAL;
> > +		ret = -EINVAL;
> > +		goto err;
> >  	}
> > 
> >  	af_recover_cfg->buf_size = h3a_af_get_buf_size(af_recover_cfg);
> >  	af->recover_priv = af_recover_cfg;
> > 
> >  	return omap3isp_stat_init(af, "AF", &h3a_af_subdev_ops);
> 
> You need to catch the omap3isp_stat_init() failures too. Something like
> 
> 	ret = omap3isp_stat_init(af, "AF", &h3a_af_subdev_ops);
> 
> done:
> 	if (ret) {
> 		kfree(af_recover_cfg);
> 		kfree(af_cfg);
> 	}
> 
> 	return ret;
> 
> and replacing the above goto err; with goto done; ?

Ack.

> 
> > +
> > +err:
> > +	kfree(af_cfg);
> > +	kfree(af_recover_cfg);
> > +
> > +	return ret;
> >  }
> > 
> >  void omap3isp_h3a_af_cleanup(struct isp_device *isp)
> > diff --git a/drivers/media/platform/omap3isp/isphist.c
> > b/drivers/media/platform/omap3isp/isphist.c index 7138b04..976cab0 100644
> > --- a/drivers/media/platform/omap3isp/isphist.c
> > +++ b/drivers/media/platform/omap3isp/isphist.c
> > @@ -477,9 +477,9 @@ int omap3isp_hist_init(struct isp_device *isp)
> >  {
> >  	struct ispstat *hist = &isp->isp_hist;
> >  	struct omap3isp_hist_config *hist_cfg;
> > -	int ret = -1;
> > +	int ret;
> > 
> > -	hist_cfg = devm_kzalloc(isp->dev, sizeof(*hist_cfg), GFP_KERNEL);
> > +	hist_cfg = kzalloc(sizeof(*hist_cfg), GFP_KERNEL);
> >  	if (hist_cfg == NULL)
> >  		return -ENOMEM;
> 
> There's a return in the middle of this function that should be turned into a 
> goto done.

Uh-oh. Will fix.

> 
> > @@ -517,6 +517,7 @@ int omap3isp_hist_init(struct isp_device *isp)
> 
> With a done label added right here.
> 
> >  	if (ret) {
> >  		if (hist->dma_ch)
> >  			dma_release_channel(hist->dma_ch);
> > +		kfree(hist_cfg);
> >  	}
> > 
> >  	return ret;
> > diff --git a/drivers/media/platform/omap3isp/ispstat.c
> > b/drivers/media/platform/omap3isp/ispstat.c index 1b9217d..1c1365f 100644
> > --- a/drivers/media/platform/omap3isp/ispstat.c
> > +++ b/drivers/media/platform/omap3isp/ispstat.c
> > @@ -1059,4 +1059,6 @@ void omap3isp_stat_cleanup(struct ispstat *stat)
> >  	mutex_destroy(&stat->ioctl_lock);
> >  	isp_stat_bufs_free(stat);
> >  	kfree(stat->buf);
> > +	kfree(stat->priv);
> > +	kfree(stat->recover_priv);
> >  }
> 

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
