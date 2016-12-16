Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:60030 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1759654AbcLPLjy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 06:39:54 -0500
Subject: Re: [PATCH 2/2] media: omap3isp change to devm for resources
To: Shuah Khan <shuahkh@osg.samsung.com>, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org
References: <cover.1481829721.git.shuahkh@osg.samsung.com>
 <98a3d1794bc001f312a7db31ad03465ba697bb36.1481829722.git.shuahkh@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56d66910-1776-26a5-53fc-20e44fea490b@xs4all.nl>
Date: Fri, 16 Dec 2016 12:39:49 +0100
MIME-Version: 1.0
In-Reply-To: <98a3d1794bc001f312a7db31ad03465ba697bb36.1481829722.git.shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15/12/16 20:40, Shuah Khan wrote:
> Using devm resources that have external dependencies such as a dev
> for a file handler could result in devm resources getting released
> durin unbind while an application has the file open holding pointer
> to the devm resource. This results in use-after-free errors when the
> application exits.

That's solving the wrong problem.

The real problem is that when registering a video_device it should do
this:

devnode->cdev.kobj.parent = &devnode->dev.kobj;

(taken from cec-core.c)

This will prevent isp->dev from being released as long as there is a
filehandle still open.

After that change I believe that this will work correctly, but this
has to be tested first!

Regards,

	Hans

>
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/platform/omap3isp/isp.c         | 71 +++++++++++++++++++--------
>  drivers/media/platform/omap3isp/ispccp2.c     | 10 +++-
>  drivers/media/platform/omap3isp/isph3a_aewb.c | 21 +++++---
>  drivers/media/platform/omap3isp/isph3a_af.c   | 21 +++++---
>  drivers/media/platform/omap3isp/isphist.c     |  5 +-
>  5 files changed, 92 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> index 0321d84..a11c509 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -1374,7 +1374,7 @@ static int isp_get_clocks(struct isp_device *isp)
>  	unsigned int i;
>
>  	for (i = 0; i < ARRAY_SIZE(isp_clocks); ++i) {
> -		clk = devm_clk_get(isp->dev, isp_clocks[i]);
> +		clk = clk_get(isp->dev, isp_clocks[i]);
>  		if (IS_ERR(clk)) {
>  			dev_err(isp->dev, "clk_get %s failed\n", isp_clocks[i]);
>  			return PTR_ERR(clk);
> @@ -1386,6 +1386,14 @@ static int isp_get_clocks(struct isp_device *isp)
>  	return 0;
>  }
>
> +static void isp_put_clocks(struct isp_device *isp)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(isp_clocks); ++i)
> +		clk_put(isp->clock[i]);
> +}
> +
>  /*
>   * omap3isp_get - Acquire the ISP resource.
>   *
> @@ -2015,6 +2023,11 @@ static int isp_remove(struct platform_device *pdev)
>
>  	media_entity_enum_cleanup(&isp->crashed);
>
> +	regulator_put(isp->isp_csiphy2.vdd);
> +	regulator_put(isp->isp_csiphy1.vdd);
> +
> +	isp_put_clocks(isp);
> +	kfree(isp);
>  	return 0;
>  }
>
> @@ -2107,8 +2120,8 @@ static int isp_of_parse_nodes(struct device *dev,
>  {
>  	struct device_node *node = NULL;
>
> -	notifier->subdevs = devm_kcalloc(
> -		dev, ISP_MAX_SUBDEVS, sizeof(*notifier->subdevs), GFP_KERNEL);
> +	notifier->subdevs = kcalloc(
> +		ISP_MAX_SUBDEVS, sizeof(*notifier->subdevs), GFP_KERNEL);
>  	if (!notifier->subdevs)
>  		return -ENOMEM;
>
> @@ -2116,11 +2129,9 @@ static int isp_of_parse_nodes(struct device *dev,
>  	       (node = of_graph_get_next_endpoint(dev->of_node, node))) {
>  		struct isp_async_subdev *isd;
>
> -		isd = devm_kzalloc(dev, sizeof(*isd), GFP_KERNEL);
> -		if (!isd) {
> -			of_node_put(node);
> +		isd = kzalloc(sizeof(*isd), GFP_KERNEL);
> +		if (!isd)
>  			return -ENOMEM;
> -		}
>
>  		notifier->subdevs[notifier->num_subdevs] = &isd->asd;
>
> @@ -2204,7 +2215,7 @@ static int isp_probe(struct platform_device *pdev)
>  	int ret;
>  	int i, m;
>
> -	isp = devm_kzalloc(&pdev->dev, sizeof(*isp), GFP_KERNEL);
> +	isp = kzalloc(sizeof(*isp), GFP_KERNEL);
>  	if (!isp) {
>  		dev_err(&pdev->dev, "could not allocate memory\n");
>  		return -ENOMEM;
> @@ -2213,21 +2224,23 @@ static int isp_probe(struct platform_device *pdev)
>  	ret = of_property_read_u32(pdev->dev.of_node, "ti,phy-type",
>  				   &isp->phy_type);
>  	if (ret)
> -		return ret;
> +		goto error_release_isp;
>
>  	isp->syscon = syscon_regmap_lookup_by_phandle(pdev->dev.of_node,
>  						      "syscon");
> -	if (IS_ERR(isp->syscon))
> -		return PTR_ERR(isp->syscon);
> +	if (IS_ERR(isp->syscon)) {
> +		ret = PTR_ERR(isp->syscon);
> +		goto error_release_isp;
> +	}
>
>  	ret = of_property_read_u32_index(pdev->dev.of_node, "syscon", 1,
>  					 &isp->syscon_offset);
>  	if (ret)
> -		return ret;
> +		goto error_release_isp;
>
>  	ret = isp_of_parse_nodes(&pdev->dev, &isp->notifier);
>  	if (ret < 0)
> -		return ret;
> +		goto error_release_isp;
>
>  	isp->autoidle = autoidle;
>
> @@ -2244,8 +2257,18 @@ static int isp_probe(struct platform_device *pdev)
>  	platform_set_drvdata(pdev, isp);
>
>  	/* Regulators */
> -	isp->isp_csiphy1.vdd = devm_regulator_get(&pdev->dev, "vdd-csiphy1");
> -	isp->isp_csiphy2.vdd = devm_regulator_get(&pdev->dev, "vdd-csiphy2");
> +	isp->isp_csiphy1.vdd = regulator_get(&pdev->dev, "vdd-csiphy1");
> +	if (IS_ERR(isp->isp_csiphy1.vdd)) {
> +		ret = PTR_ERR(isp->isp_csiphy1.vdd);
> +		isp->isp_csiphy1.vdd = NULL;
> +		goto error;
> +	}
> +	isp->isp_csiphy2.vdd = regulator_get(&pdev->dev, "vdd-csiphy2");
> +	if (IS_ERR(isp->isp_csiphy2.vdd)) {
> +		ret = PTR_ERR(isp->isp_csiphy2.vdd);
> +		isp->isp_csiphy2.vdd = NULL;
> +		goto error_put_vdd_csiphy1;
> +	}
>
>  	/* Clocks
>  	 *
> @@ -2264,16 +2287,17 @@ static int isp_probe(struct platform_device *pdev)
>  		isp->mmio_base[map_idx] =
>  			devm_ioremap_resource(isp->dev, mem);
>  		if (IS_ERR(isp->mmio_base[map_idx]))
> -			return PTR_ERR(isp->mmio_base[map_idx]);
> +			ret = PTR_ERR(isp->mmio_base[map_idx]);
> +			goto error_put_vdd_csiphy2;
>  	}
>
>  	ret = isp_get_clocks(isp);
>  	if (ret < 0)
> -		goto error;
> +		goto error_put_vdd_csiphy2;
>
>  	ret = clk_enable(isp->clock[ISP_CLK_CAM_ICK]);
>  	if (ret < 0)
> -		goto error;
> +		goto error_put_vdd_csiphy2;
>
>  	isp->revision = isp_reg_readl(isp, OMAP3_ISP_IOMEM_MAIN, ISP_REVISION);
>  	dev_info(isp->dev, "Revision %d.%d found\n",
> @@ -2283,7 +2307,7 @@ static int isp_probe(struct platform_device *pdev)
>
>  	if (__omap3isp_get(isp, false) == NULL) {
>  		ret = -ENODEV;
> -		goto error;
> +		goto error_put_vdd_csiphy2;
>  	}
>
>  	ret = isp_reset(isp);
> @@ -2334,7 +2358,7 @@ static int isp_probe(struct platform_device *pdev)
>  	}
>  	isp->irq_num = ret;
>
> -	if (devm_request_irq(isp->dev, isp->irq_num, isp_isr, IRQF_SHARED,
> +	if (request_irq(isp->irq_num, isp_isr, IRQF_SHARED,
>  			     "OMAP3 ISP", isp)) {
>  		dev_err(isp->dev, "Unable to request IRQ\n");
>  		ret = -EINVAL;
> @@ -2375,8 +2399,15 @@ static int isp_probe(struct platform_device *pdev)
>  error_isp:
>  	isp_xclk_cleanup(isp);
>  	__omap3isp_put(isp, false);
> +error_put_vdd_csiphy2:
> +	regulator_put(isp->isp_csiphy2.vdd);
> +error_put_vdd_csiphy1:
> +	regulator_put(isp->isp_csiphy1.vdd);
>  error:
>  	mutex_destroy(&isp->isp_mutex);
> +	isp_put_clocks(isp);
> +error_release_isp:
> +	kfree(isp);
>
>  	return ret;
>  }
> diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
> index 4c1e7f0..adf4191 100644
> --- a/drivers/media/platform/omap3isp/ispccp2.c
> +++ b/drivers/media/platform/omap3isp/ispccp2.c
> @@ -1135,7 +1135,7 @@ int omap3isp_ccp2_init(struct isp_device *isp)
>  	 * TODO: Don't hardcode the usage of PHY1 (shared with CSI2c).
>  	 */
>  	if (isp->revision == ISP_REVISION_2_0) {
> -		ccp2->vdds_csib = devm_regulator_get(isp->dev, "vdds_csib");
> +		ccp2->vdds_csib = regulator_get(isp->dev, "vdds_csib");
>  		if (IS_ERR(ccp2->vdds_csib)) {
>  			dev_dbg(isp->dev,
>  				"Could not get regulator vdds_csib\n");
> @@ -1147,10 +1147,15 @@ int omap3isp_ccp2_init(struct isp_device *isp)
>
>  	ret = ccp2_init_entities(ccp2);
>  	if (ret < 0)
> -		return ret;
> +		goto error_put_vdds_csib;
>
>  	ccp2_reset(ccp2);
>  	return 0;
> +
> +error_put_vdds_csib:
> +	regulator_put(ccp2->vdds_csib);
> +
> +	return ret;
>  }
>
>  /*
> @@ -1162,4 +1167,5 @@ void omap3isp_ccp2_cleanup(struct isp_device *isp)
>  	struct isp_ccp2_device *ccp2 = &isp->isp_ccp2;
>
>  	omap3isp_video_cleanup(&ccp2->video_in);
> +	regulator_put(ccp2->vdds_csib);
>  }
> diff --git a/drivers/media/platform/omap3isp/isph3a_aewb.c b/drivers/media/platform/omap3isp/isph3a_aewb.c
> index ccaf92f..042de3e 100644
> --- a/drivers/media/platform/omap3isp/isph3a_aewb.c
> +++ b/drivers/media/platform/omap3isp/isph3a_aewb.c
> @@ -289,9 +289,10 @@ int omap3isp_h3a_aewb_init(struct isp_device *isp)
>  {
>  	struct ispstat *aewb = &isp->isp_aewb;
>  	struct omap3isp_h3a_aewb_config *aewb_cfg;
> -	struct omap3isp_h3a_aewb_config *aewb_recover_cfg;
> +	struct omap3isp_h3a_aewb_config *aewb_recover_cfg = NULL;
> +	int ret;
>
> -	aewb_cfg = devm_kzalloc(isp->dev, sizeof(*aewb_cfg), GFP_KERNEL);
> +	aewb_cfg = kzalloc(sizeof(*aewb_cfg), GFP_KERNEL);
>  	if (!aewb_cfg)
>  		return -ENOMEM;
>
> @@ -301,12 +302,12 @@ int omap3isp_h3a_aewb_init(struct isp_device *isp)
>  	aewb->isp = isp;
>
>  	/* Set recover state configuration */
> -	aewb_recover_cfg = devm_kzalloc(isp->dev, sizeof(*aewb_recover_cfg),
> -					GFP_KERNEL);
> +	aewb_recover_cfg = kzalloc(sizeof(*aewb_recover_cfg), GFP_KERNEL);
>  	if (!aewb_recover_cfg) {
>  		dev_err(aewb->isp->dev, "AEWB: cannot allocate memory for "
>  					"recover configuration.\n");
> -		return -ENOMEM;
> +		ret = -ENOMEM;
> +		goto err_release_aewb_cfg;
>  	}
>
>  	aewb_recover_cfg->saturation_limit = OMAP3ISP_AEWB_MAX_SATURATION_LIM;
> @@ -323,13 +324,21 @@ int omap3isp_h3a_aewb_init(struct isp_device *isp)
>  	if (h3a_aewb_validate_params(aewb, aewb_recover_cfg)) {
>  		dev_err(aewb->isp->dev, "AEWB: recover configuration is "
>  					"invalid.\n");
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto err_release_aewb_recover_cfg;
>  	}
>
>  	aewb_recover_cfg->buf_size = h3a_aewb_get_buf_size(aewb_recover_cfg);
>  	aewb->recover_priv = aewb_recover_cfg;
>
>  	return omap3isp_stat_init(aewb, "AEWB", &h3a_aewb_subdev_ops);
> +
> +err_release_aewb_recover_cfg:
> +	kfree(aewb_recover_cfg);
> +err_release_aewb_cfg:
> +	kfree(aewb_cfg);
> +
> +	return ret;
>  }
>
>  /*
> diff --git a/drivers/media/platform/omap3isp/isph3a_af.c b/drivers/media/platform/omap3isp/isph3a_af.c
> index 92937f7..1919cb2 100644
> --- a/drivers/media/platform/omap3isp/isph3a_af.c
> +++ b/drivers/media/platform/omap3isp/isph3a_af.c
> @@ -352,9 +352,10 @@ int omap3isp_h3a_af_init(struct isp_device *isp)
>  {
>  	struct ispstat *af = &isp->isp_af;
>  	struct omap3isp_h3a_af_config *af_cfg;
> -	struct omap3isp_h3a_af_config *af_recover_cfg;
> +	struct omap3isp_h3a_af_config *af_recover_cfg = NULL;
> +	int ret;
>
> -	af_cfg = devm_kzalloc(isp->dev, sizeof(*af_cfg), GFP_KERNEL);
> +	af_cfg = kzalloc(sizeof(*af_cfg), GFP_KERNEL);
>  	if (af_cfg == NULL)
>  		return -ENOMEM;
>
> @@ -364,12 +365,12 @@ int omap3isp_h3a_af_init(struct isp_device *isp)
>  	af->isp = isp;
>
>  	/* Set recover state configuration */
> -	af_recover_cfg = devm_kzalloc(isp->dev, sizeof(*af_recover_cfg),
> -				      GFP_KERNEL);
> +	af_recover_cfg = kzalloc(sizeof(*af_recover_cfg), GFP_KERNEL);
>  	if (!af_recover_cfg) {
>  		dev_err(af->isp->dev, "AF: cannot allocate memory for recover "
>  				      "configuration.\n");
> -		return -ENOMEM;
> +		ret = -ENOMEM;
> +		goto err_release_af_cfg;
>  	}
>
>  	af_recover_cfg->paxel.h_start = OMAP3ISP_AF_PAXEL_HZSTART_MIN;
> @@ -381,13 +382,21 @@ int omap3isp_h3a_af_init(struct isp_device *isp)
>  	if (h3a_af_validate_params(af, af_recover_cfg)) {
>  		dev_err(af->isp->dev, "AF: recover configuration is "
>  				      "invalid.\n");
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto err_release_af_recover_cfg;
>  	}
>
>  	af_recover_cfg->buf_size = h3a_af_get_buf_size(af_recover_cfg);
>  	af->recover_priv = af_recover_cfg;
>
>  	return omap3isp_stat_init(af, "AF", &h3a_af_subdev_ops);
> +
> +err_release_af_recover_cfg:
> +	kfree(af_recover_cfg);
> +err_release_af_cfg:
> +	kfree(af_cfg);
> +
> +	return ret;
>  }
>
>  void omap3isp_h3a_af_cleanup(struct isp_device *isp)
> diff --git a/drivers/media/platform/omap3isp/isphist.c b/drivers/media/platform/omap3isp/isphist.c
> index 7138b04..5d8f04b 100644
> --- a/drivers/media/platform/omap3isp/isphist.c
> +++ b/drivers/media/platform/omap3isp/isphist.c
> @@ -477,9 +477,9 @@ int omap3isp_hist_init(struct isp_device *isp)
>  {
>  	struct ispstat *hist = &isp->isp_hist;
>  	struct omap3isp_hist_config *hist_cfg;
> -	int ret = -1;
> +	int ret = 0;
>
> -	hist_cfg = devm_kzalloc(isp->dev, sizeof(*hist_cfg), GFP_KERNEL);
> +	hist_cfg = kzalloc(sizeof(*hist_cfg), GFP_KERNEL);
>  	if (hist_cfg == NULL)
>  		return -ENOMEM;
>
> @@ -517,6 +517,7 @@ int omap3isp_hist_init(struct isp_device *isp)
>  	if (ret) {
>  		if (hist->dma_ch)
>  			dma_release_channel(hist->dma_ch);
> +		kfree(hist_cfg);
>  	}
>
>  	return ret;
>

