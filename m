Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7.mo2.mail-out.ovh.net ([188.165.48.182]:55159 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755263Ab1IFUvw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 16:51:52 -0400
Received: from mail616.ha.ovh.net (b6.ovh.net [213.186.33.56])
	by mo2.mail-out.ovh.net (Postfix) with SMTP id A07C7DC3D59
	for <linux-media@vger.kernel.org>; Tue,  6 Sep 2011 22:27:06 +0200 (CEST)
Date: Tue, 6 Sep 2011 22:05:12 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Josh Wu <josh.wu@atmel.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] [media] at91: add code to initialize and manage the
 ISI_MCK for Atmel ISI driver.
Message-ID: <20110906200512.GA15083@game.jcrosoft.org>
References: <1315288601-22384-1-git-send-email-josh.wu@atmel.com>
 <Pine.LNX.4.64.1109060803590.14818@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1109060803590.14818@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08:54 Tue 06 Sep     , Guennadi Liakhovetski wrote:
> On Tue, 6 Sep 2011, Josh Wu wrote:
> 
> > This patch enable the configuration for ISI_MCK, which is provided by programmable clock.
> > 
> > Signed-off-by: Josh Wu <josh.wu@atmel.com>
> > ---
> >  drivers/media/video/atmel-isi.c |   60 ++++++++++++++++++++++++++++++++++++++-
> >  include/media/atmel-isi.h       |    4 ++
> >  2 files changed, 63 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
> > index 7b89f00..768bf59 100644
> > --- a/drivers/media/video/atmel-isi.c
> > +++ b/drivers/media/video/atmel-isi.c
> > @@ -90,7 +90,10 @@ struct atmel_isi {
> >  	struct isi_dma_desc		dma_desc[MAX_BUFFER_NUM];
> >  
> >  	struct completion		complete;
> > +	/* ISI peripherial clock */
> >  	struct clk			*pclk;
> > +	/* ISI_MCK, provided by PCK */
> > +	struct clk			*mck;
> >  	unsigned int			irq;
> >  
> >  	struct isi_platform_data	*pdata;
> > @@ -763,6 +766,10 @@ static int isi_camera_add_device(struct soc_camera_device *icd)
> >  	if (ret)
> >  		return ret;
> >  
> > +	ret = clk_enable(isi->mck);
> > +	if (ret)
> > +		return ret;
> > +
> 
> Don't you have to disable the pixel clock (isi->pclk), that you just have 
> enabled above this hunk, on the above error path?
> 
> >  	isi->icd = icd;
> >  	dev_dbg(icd->parent, "Atmel ISI Camera driver attached to camera %d\n",
> >  		 icd->devnum);
> > @@ -776,6 +783,7 @@ static void isi_camera_remove_device(struct soc_camera_device *icd)
> >  
> >  	BUG_ON(icd != isi->icd);
> >  
> > +	clk_disable(isi->mck);
> >  	clk_disable(isi->pclk);
> >  	isi->icd = NULL;
> >  
> > @@ -882,6 +890,49 @@ static struct soc_camera_host_ops isi_soc_camera_host_ops = {
> >  };
> >  
> >  /* -----------------------------------------------------------------------*/
> > +/* Initialize ISI_MCK clock, called by atmel_isi_probe() function */
> > +static int initialize_mck(struct platform_device *pdev,
> > +			struct atmel_isi *isi)
> > +{
> > +	struct device *dev = &pdev->dev;
> > +	struct isi_platform_data *pdata = dev->platform_data;
> > +	struct clk *pck_parent;
> > +	int ret;
> > +
> > +	if (!strlen(pdata->pck_name) || !strlen(pdata->pck_parent_name))
> > +		return -EINVAL;
> > +
> > +	/* ISI_MCK is provided by PCK clock */
> > +	isi->mck = clk_get(dev, pdata->pck_name);
> 
> I think, it's still not what Russell meant. Look at 
or what I ask you too
> drivers/mmc/host/atmel-mci.c:
> 
> 	host->mck = clk_get(&pdev->dev, "mci_clk");
> 
> and in arch/arm/mach-at91/at91sam9g45.c they've got
> 
> 	CLKDEV_CON_DEV_ID("mci_clk", "atmel_mci.0", &mmc0_clk),
> 	CLKDEV_CON_DEV_ID("mci_clk", "atmel_mci.1", &mmc1_clk),
> 
> where
> 
> #define CLKDEV_CON_DEV_ID(_con_id, _dev_id, _clk)	\
> 	{						\
> 		.con_id = _con_id,			\
> 		.dev_id = _dev_id,			\
> 		.clk = _clk,				\
> 	}
> 
> I.e., in the device driver (mmc in this case) you only use the (platform) 
> device instance, whose dev_name(dev) is then matched against one of clock 
> lookups above, and a connection ID, which is used in case your device is 
> using more than one clock. In the ISI case, your pck1 clock, that you seem 
> to need here, doesn't have a clock lookup object, so, you might have to 
> add one, and then use its connection ID.
> 
> > +	if (IS_ERR(isi->mck)) {
> > +		dev_err(dev, "Failed to get PCK: %s\n", pdata->pck_name);
> > +		return PTR_ERR(isi->mck);
> > +	}
> > +
> > +	pck_parent = clk_get(dev, pdata->pck_parent_name);
> > +	if (IS_ERR(pck_parent)) {
> > +		ret = PTR_ERR(pck_parent);
> > +		dev_err(dev, "Failed to get PCK parent: %s\n",
> > +				pdata->pck_parent_name);
> > +		goto err_init_mck;
> > +	}
> > +
> > +	ret = clk_set_parent(isi->mck, pck_parent);
> 
> I'm not entirely sure on this one, but as we had a similar situation with 
> clocks, we decided to extablish the clock hierarchy in the board code, and 
> only deal with the actual device clocks in the driver itself. I.e., we 
> moved all clk_set_parent() and setting up the parent clock into the board. 
> And I do think, this makes more sense, than doing this in the driver, not 
> all users of this driver will need to manage the parent clock, right?
I don't like to manage the clock in the board except if it's manadatory otherwise
we manage this at soc level

the driver does not have to manage the clock hierachy or detail implementation
but manage the clock enable/disable and speed depending on it's need

Best Regards,
J.
