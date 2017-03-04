Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33888 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751814AbdCDPdt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 4 Mar 2017 10:33:49 -0500
Date: Sat, 4 Mar 2017 17:33:41 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Pavel Machek <pavel@ucw.cz>, mchehab@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] omap3isp: wait for regulators to come up
Message-ID: <20170304153340.GZ3220@valkosipuli.retiisi.org.uk>
References: <20161228183036.GA13139@amd>
 <20170302101603.GE27818@amd>
 <20170302124532.GA29046@amd>
 <1546676.OUenhTMaLy@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1546676.OUenhTMaLy@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 02, 2017 at 04:46:42PM +0200, Laurent Pinchart wrote:
> Hi Pavel,
> 
> Thank you for the patch.
> 
> On Thursday 02 Mar 2017 13:45:32 Pavel Machek wrote:
> > If regulator returns -EPROBE_DEFER, we need to return it too, so that
> > omap3isp will be re-probed when regulator is ready.
> > 
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > 
> > diff --git a/drivers/media/platform/omap3isp/ispccp2.c
> > b/drivers/media/platform/omap3isp/ispccp2.c index ca09523..b6e055e 100644
> > --- a/drivers/media/platform/omap3isp/ispccp2.c
> > +++ b/drivers/media/platform/omap3isp/ispccp2.c
> > @@ -1137,10 +1159,12 @@ int omap3isp_ccp2_init(struct isp_device *isp)
> >  	if (isp->revision == ISP_REVISION_2_0) {
> >  		ccp2->vdds_csib = devm_regulator_get(isp->dev, "vdds_csib");
> >  		if (IS_ERR(ccp2->vdds_csib)) {
> > +			if (PTR_ERR(ccp2->vdds_csib) == -EPROBE_DEFER)
> > +				return -EPROBE_DEFER;
> 
> This looks good to me, but it will result in the caller printing a "CCP2 
> initialization failed" error message, which I'm not sure is right. Maybe we 
> should move that message to the omap3isp_ccp2_init() function ?
> 
> In any case, this change is fine, so
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Applied to ccp2 branch with the error message moved. The old message is
still printed if the error code is different.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
