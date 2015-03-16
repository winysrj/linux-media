Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43598 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbbCPAAU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 20:00:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Josh Wu <josh.wu@atmel.com>, Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH/RFC 4/4] soc-camera: Skip v4l2 clock registration if host doesn't provide clk ops
Date: Mon, 16 Mar 2015 02:00:25 +0200
Message-ID: <1634321.iE70ufz1gl@avalon>
In-Reply-To: <Pine.LNX.4.64.1503151845220.13027@axis700.grange>
References: <1425883176-29859-1-git-send-email-laurent.pinchart@ideasonboard.com> <1425883176-29859-5-git-send-email-laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1503151845220.13027@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Sunday 15 March 2015 18:56:44 Guennadi Liakhovetski wrote:
> On Mon, 9 Mar 2015, Laurent Pinchart wrote:
> > If the soc-camera host doesn't provide clock start and stop operations
> > registering a v4l2 clock is pointless. Don't do it.
> 
> This can introduce breakage only for camera-host drivers, that don't
> provide .clock_start() or .clock_stop(). After your other 3 patches from
> this patch set there will be one such driver in the tree - rcar_vin.c. I
> wouldn't mind this patch as long as we can have an ack from an rcar_vin.c
> maintainer. Since I don't see one in MAINTAINERS, who can ack this? Simon?

I don't think we have an official maintainer. Maybe a Tested-by would be 
enough in this case ?

> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/platform/soc_camera/soc_camera.c | 51 +++++++++++++++------
> >  1 file changed, 33 insertions(+), 18 deletions(-)
> > 
> > This requires proper review and testing, please don't apply it blindly.
> > 
> > diff --git a/drivers/media/platform/soc_camera/soc_camera.c
> > b/drivers/media/platform/soc_camera/soc_camera.c index 0943125..f3ea911
> > 100644
> > --- a/drivers/media/platform/soc_camera/soc_camera.c
> > +++ b/drivers/media/platform/soc_camera/soc_camera.c
> > @@ -1374,10 +1374,13 @@ static int soc_camera_i2c_init(struct
> > soc_camera_device *icd,> 
> >  	snprintf(clk_name, sizeof(clk_name), "%d-%04x",
> >  	
> >  		 shd->i2c_adapter_id, shd->board_info->addr);
> > 
> > -	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, "mclk",
> > icd);
> > -	if (IS_ERR(icd->clk)) {
> > -		ret = PTR_ERR(icd->clk);
> > -		goto eclkreg;
> > +	if (ici->ops->clock_start && ici->ops->clock_stop) {
> > +		icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name,
> > +					     "mclk", icd);
> > +		if (IS_ERR(icd->clk)) {
> > +			ret = PTR_ERR(icd->clk);
> > +			goto eclkreg;
> > +		}
> > 
> >  	}
> >  	
> >  	subdev = v4l2_i2c_new_subdev_board(&ici->v4l2_dev, adap,
> > 
> > @@ -1394,8 +1397,10 @@ static int soc_camera_i2c_init(struct
> > soc_camera_device *icd,> 
> >  	return 0;
> >  
> >  ei2cnd:
> > -	v4l2_clk_unregister(icd->clk);
> > -	icd->clk = NULL;
> > +	if (icd->clk) {
> > +		v4l2_clk_unregister(icd->clk);
> > +		icd->clk = NULL;
> > +	}
> > 
> >  eclkreg:
> >  	kfree(ssdd);
> >  
> >  ealloc:
> > @@ -1420,8 +1425,10 @@ static void soc_camera_i2c_free(struct
> > soc_camera_device *icd)> 
> >  	i2c_unregister_device(client);
> >  	i2c_put_adapter(adap);
> >  	kfree(ssdd);
> > 
> > -	v4l2_clk_unregister(icd->clk);
> > -	icd->clk = NULL;
> > +	if (icd->clk) {
> > +		v4l2_clk_unregister(icd->clk);
> > +		icd->clk = NULL;
> > +	}
> > 
> >  }
> >  
> >  /*
> > 
> > @@ -1555,17 +1562,21 @@ static int scan_async_group(struct soc_camera_host
> > *ici,> 
> >  	snprintf(clk_name, sizeof(clk_name), "%d-%04x",
> >  	
> >  		 sasd->asd.match.i2c.adapter_id, sasd->asd.match.i2c.address);
> > 
> > -	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, "mclk",
> > icd);
> > -	if (IS_ERR(icd->clk)) {
> > -		ret = PTR_ERR(icd->clk);
> > -		goto eclkreg;
> > +	if (ici->ops->clock_start && ici->ops->clock_stop) {
> > +		icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name,
> > +					     "mclk", icd);
> > +		if (IS_ERR(icd->clk)) {
> > +			ret = PTR_ERR(icd->clk);
> > +			goto eclkreg;
> > +		}
> > 
> >  	}
> >  	
> >  	ret = v4l2_async_notifier_register(&ici->v4l2_dev, &sasc->notifier);
> >  	if (!ret)
> >  	
> >  		return 0;
> > 
> > -	v4l2_clk_unregister(icd->clk);
> > +	if (icd->clk)
> > +		v4l2_clk_unregister(icd->clk);
> > 
> >  eclkreg:
> >  	icd->clk = NULL;
> >  	platform_device_del(sasc->pdev);
> > 
> > @@ -1660,17 +1671,21 @@ static int soc_of_bind(struct soc_camera_host
> > *ici,
> > 
> >  		snprintf(clk_name, sizeof(clk_name), "of-%s",
> >  		
> >  			 of_node_full_name(remote));
> > 
> > -	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, "mclk",
> > icd);
> > -	if (IS_ERR(icd->clk)) {
> > -		ret = PTR_ERR(icd->clk);
> > -		goto eclkreg;
> > +	if (ici->ops->clock_start && ici->ops->clock_stop) {
> > +		icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name,
> > +					     "mclk", icd);
> > +		if (IS_ERR(icd->clk)) {
> > +			ret = PTR_ERR(icd->clk);
> > +			goto eclkreg;
> > +		}
> > 
> >  	}
> >  	
> >  	ret = v4l2_async_notifier_register(&ici->v4l2_dev, &sasc->notifier);
> >  	if (!ret)
> >  	
> >  		return 0;
> > 
> > -	v4l2_clk_unregister(icd->clk);
> > +	if (icd->clk)
> > +		v4l2_clk_unregister(icd->clk);
> > 
> >  eclkreg:
> >  	icd->clk = NULL;
> >  	platform_device_del(sasc->pdev);

-- 
Regards,

Laurent Pinchart

