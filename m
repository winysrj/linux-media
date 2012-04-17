Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34967 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751874Ab2DQSlH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 14:41:07 -0400
Date: Tue, 17 Apr 2012 21:41:01 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v3 9/9] omap3isp: preview: Shorten shadow update delay
Message-ID: <20120417184100.GH5356@valkosipuli.localdomain>
References: <1334582994-6967-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1334582994-6967-10-git-send-email-laurent.pinchart@ideasonboard.com>
 <20120417142600.GD5356@valkosipuli.localdomain>
 <2049798.AIViuaqhSZ@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2049798.AIViuaqhSZ@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Apr 17, 2012 at 06:09:27PM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Tuesday 17 April 2012 17:26:00 Sakari Ailus wrote:
> > Hi Laurent,
> > 
> > Many thanks for the patch!!
> 
> And thank you for the review.
> 
> > On Mon, Apr 16, 2012 at 03:29:54PM +0200, Laurent Pinchart wrote:
> > > When applications modify preview engine parameters, the new values are
> > > applied to the hardware by the preview engine interrupt handler during
> > > vertical blanking. If the parameters are being changed when the
> > > interrupt handler is called, it just delays applying the parameters
> > > until the next frame.
> > > 
> > > If an application modifies the parameters for every frame, and the
> > > preview engine interrupt is triggerred synchronously, the parameters are
> > > never applied to the hardware.
> > > 
> > > Fix this by storing new parameters in a shadow copy, and switch the
> > > active parameters with the shadow values atomically.
> > > 
> > > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > ---
> > > 
> > >  drivers/media/video/omap3isp/isppreview.c |  298 +++++++++++++++---------
> > >  drivers/media/video/omap3isp/isppreview.h |   21 ++-
> > >  2 files changed, 212 insertions(+), 107 deletions(-)
> > > 
> > > diff --git a/drivers/media/video/omap3isp/isppreview.c
> > > b/drivers/media/video/omap3isp/isppreview.c index e12df2c..5ccfe46 100644
> > > --- a/drivers/media/video/omap3isp/isppreview.c
> > > +++ b/drivers/media/video/omap3isp/isppreview.c
> > > @@ -649,12 +649,18 @@ preview_config_rgb_to_ycbcr(struct isp_prev_device
> > > *prev, const void *prev_csc)
> >
> > Not related to this patch, but shouldn't the above function be called
> > preview_config_csc()?
> 
> That would make sense, yes. I'll add a patch for that.
> 
> > >  static void
> > >  preview_update_contrast(struct isp_prev_device *prev, u8 contrast)
> > >  {
> > > -	struct prev_params *params = &prev->params;
> > > +	struct prev_params *params;
> > > +	unsigned long flags;
> > > +
> > > +	spin_lock_irqsave(&prev->params.lock, flags);
> > > +	params = (prev->params.active & OMAP3ISP_PREV_CONTRAST)
> > > +	       ? &prev->params.params[0] : &prev->params.params[1];
> > > 
> > >  	if (params->contrast != (contrast * ISPPRV_CONTRAST_UNITS)) {
> > >  		params->contrast = contrast * ISPPRV_CONTRAST_UNITS;
> > > -		prev->update |= OMAP3ISP_PREV_CONTRAST;
> > > +		params->update |= OMAP3ISP_PREV_CONTRAST;
> > >  	}
> > > +	spin_unlock_irqrestore(&prev->params.lock, flags);
> > >  }
> > >  
> > >  /*
> > > @@ -681,12 +687,18 @@ preview_config_contrast(struct isp_prev_device
> > > *prev, const void *params)
> > >  static void
> > >  preview_update_brightness(struct isp_prev_device *prev, u8 brightness)
> > >  {
> > > -	struct prev_params *params = &prev->params;
> > > +	struct prev_params *params;
> > > +	unsigned long flags;
> > > +
> > > +	spin_lock_irqsave(&prev->params.lock, flags);
> > > +	params = (prev->params.active & OMAP3ISP_PREV_CONTRAST)
> > > +	       ? &prev->params.params[0] : &prev->params.params[1];
> > 
> > params = prev->params.params[!(prev->params.active &
> > OMAP3ISP_PREV_CONTRAST)];
> 
> I've thought about that, but it doesn't fit on a single line. After being 
> split in two lines the result is less readable in my opinion. Do you think I 
> should change it nonetheless ?

I would do it as you use similar constructs elsewhere. It's up to you.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
