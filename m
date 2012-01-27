Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:39576 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab2A0Jh3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jan 2012 04:37:29 -0500
Date: Fri, 27 Jan 2012 11:37:25 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, ohad@wizery.com
Subject: Re: [PATCH 1/1] omap3isp: Prevent crash at module unload
Message-ID: <20120127093724.GD15297@valkosipuli.localdomain>
References: <1327655155-6038-1-git-send-email-sakari.ailus@iki.fi>
 <201201271036.02588.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201201271036.02588.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Jan 27, 2012 at 10:36:02AM +0100, Laurent Pinchart wrote:
> On Friday 27 January 2012 10:05:55 Sakari Ailus wrote:
> > iommu_domain_free() was called in isp_remove() before omap3isp_put().
> > omap3isp_put() must not save the context if the IOMMU no longer is there.
> > Fix this.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> > The issue only seems to affect the staging/for_v3.4 branch in
> > media-tree.git.
> > 
> >  drivers/media/video/omap3isp/isp.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/media/video/omap3isp/isp.c
> > b/drivers/media/video/omap3isp/isp.c index 12d5f92..c3ff142 100644
> > --- a/drivers/media/video/omap3isp/isp.c
> > +++ b/drivers/media/video/omap3isp/isp.c
> > @@ -1112,7 +1112,8 @@ isp_restore_context(struct isp_device *isp, struct
> > isp_reg *reg_list) static void isp_save_ctx(struct isp_device *isp)
> >  {
> >  	isp_save_context(isp, isp_reg_list);
> > -	omap_iommu_save_ctx(isp->dev);
> > +	if (isp->domain)
> > +		omap_iommu_save_ctx(isp->dev);
> 
> What about skipping the isp_save_ctx() call completely in omap3isp_put() when 
> isp->domain is NULL ? We don't need to save the ISP context either.

I'm fine with that. I'll resend this then.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
