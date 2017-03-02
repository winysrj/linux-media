Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33021 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbdCBUJp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 15:09:45 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, mchehab@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] omap3isp: wait for regulators to come up
Date: Thu, 02 Mar 2017 16:46:42 +0200
Message-ID: <1546676.OUenhTMaLy@avalon>
In-Reply-To: <20170302124532.GA29046@amd>
References: <20161228183036.GA13139@amd> <20170302101603.GE27818@amd> <20170302124532.GA29046@amd>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

Thank you for the patch.

On Thursday 02 Mar 2017 13:45:32 Pavel Machek wrote:
> If regulator returns -EPROBE_DEFER, we need to return it too, so that
> omap3isp will be re-probed when regulator is ready.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> diff --git a/drivers/media/platform/omap3isp/ispccp2.c
> b/drivers/media/platform/omap3isp/ispccp2.c index ca09523..b6e055e 100644
> --- a/drivers/media/platform/omap3isp/ispccp2.c
> +++ b/drivers/media/platform/omap3isp/ispccp2.c
> @@ -1137,10 +1159,12 @@ int omap3isp_ccp2_init(struct isp_device *isp)
>  	if (isp->revision == ISP_REVISION_2_0) {
>  		ccp2->vdds_csib = devm_regulator_get(isp->dev, "vdds_csib");
>  		if (IS_ERR(ccp2->vdds_csib)) {
> +			if (PTR_ERR(ccp2->vdds_csib) == -EPROBE_DEFER)
> +				return -EPROBE_DEFER;

This looks good to me, but it will result in the caller printing a "CCP2 
initialization failed" error message, which I'm not sure is right. Maybe we 
should move that message to the omap3isp_ccp2_init() function ?

In any case, this change is fine, so

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  			dev_dbg(isp->dev,
>  				"Could not get regulator vdds_csib\n");
>  			ccp2->vdds_csib = NULL;
>  		}
>  	} else if (isp->revision == ISP_REVISION_15_0) {
>  		ccp2->phy = &isp->isp_csiphy1;
>  	}

-- 
Regards,

Laurent Pinchart
