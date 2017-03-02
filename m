Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43982 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754066AbdCBOl5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Mar 2017 09:41:57 -0500
Date: Thu, 2 Mar 2017 16:16:17 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: subdevice config into pointer (was Re: [PATCH 1/4] v4l2:
 device_register_subdev_nodes: allow calling multiple times)
Message-ID: <20170302141617.GG3220@valkosipuli.retiisi.org.uk>
References: <d315073f004ce46e0198fd614398e046ffe649e7.1487111824.git.pavel@ucw.cz>
 <20170220103114.GA9800@amd>
 <20170220130912.GT16975@valkosipuli.retiisi.org.uk>
 <20170220135636.GU16975@valkosipuli.retiisi.org.uk>
 <20170221110721.GD5021@amd>
 <20170221111104.GD16975@valkosipuli.retiisi.org.uk>
 <20170225000918.GB23662@amd>
 <20170225134444.6qzumpvasaow5qoj@ihha.localdomain>
 <20170302090727.GC27818@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170302090727.GC27818@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Thu, Mar 02, 2017 at 10:07:27AM +0100, Pavel Machek wrote:
> Hi!
> 
> > Making the sub-device bus configuration a pointer should be in a separate
> > patch. It makes sense since the entire configuration is not valid for all
> > sub-devices attached to the ISP anymore. I think it originally was a
> > separate patch, but they probably have been merged at some point. I can't
> > find it right now anyway.
> 
> Something like this?
> 									Pavel
> 
> commit df9141c66678b549fac9d143bd55ed0b242cf36e
> Author: Pavel <pavel@ucw.cz>
> Date:   Wed Mar 1 13:27:56 2017 +0100
> 
>     Turn bus in struct isp_async_subdev into pointer; some of our subdevs
>     (flash, focus) will not need bus configuration.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

I applied this to the ccp2 branch with an improved patch description.

> 
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> index 8a456d4..36bd359 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -2030,12 +2030,18 @@ enum isp_of_phy {
>  static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwn,
>  			    struct isp_async_subdev *isd)
>  {
> -	struct isp_bus_cfg *buscfg = &isd->bus;
> +	struct isp_bus_cfg *buscfg;
>  	struct v4l2_fwnode_endpoint vfwn;
>  	unsigned int i;
>  	int ret;
>  	bool csi1 = false;
>  
> +	buscfg = devm_kzalloc(dev, sizeof(*isd->bus), GFP_KERNEL);
> +	if (!buscfg)
> +		return -ENOMEM;
> +
> +	isd->bus = buscfg;
> +
>  	ret = v4l2_fwnode_endpoint_parse(fwn, &vfwn);
>  	if (ret)
>  		return ret;
> @@ -2246,7 +2252,7 @@ static int isp_subdev_notifier_bound(struct v4l2_async_notifier *async,
>  		container_of(asd, struct isp_async_subdev, asd);
>  
>  	isd->sd = subdev;
> -	isd->sd->host_priv = &isd->bus;
> +	isd->sd->host_priv = isd->bus;
>  
>  	return 0;
>  }
> diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
> index 7e6f663..c0b9d1d 100644
> --- a/drivers/media/platform/omap3isp/isp.h
> +++ b/drivers/media/platform/omap3isp/isp.h
> @@ -228,7 +228,7 @@ struct isp_device {
>  
>  struct isp_async_subdev {
>  	struct v4l2_subdev *sd;
> -	struct isp_bus_cfg bus;
> +	struct isp_bus_cfg *bus;
>  	struct v4l2_async_subdev asd;
>  };
>  
> diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c b/drivers/media/platform/omap3isp/ispcsiphy.c
> index f20abe8..be23408 100644
> --- a/drivers/media/platform/omap3isp/ispcsiphy.c
> +++ b/drivers/media/platform/omap3isp/ispcsiphy.c
> @@ -202,7 +202,7 @@ static int omap3isp_csiphy_config(struct isp_csiphy *phy)
>  		struct isp_async_subdev *isd =
>  			container_of(pipe->external->asd,
>  				     struct isp_async_subdev, asd);
> -		buscfg = &isd->bus;
> +		buscfg = isd->bus;
>  	}
>  
>  	if (buscfg->interface == ISP_INTERFACE_CCP2B_PHY1
> 
> 

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
