Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36389 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933567Ab2C3Aad (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Mar 2012 20:30:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 4/4] omap3isp: preview: Shorten shadow update delay
Date: Fri, 30 Mar 2012 02:30:34 +0200
Message-ID: <2856992.ve4AGyBgA4@avalon>
In-Reply-To: <20120329203417.GC922@valkosipuli.localdomain>
References: <1332936001-32603-1-git-send-email-laurent.pinchart@ideasonboard.com> <1332936001-32603-5-git-send-email-laurent.pinchart@ideasonboard.com> <20120329203417.GC922@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the review.

On Thursday 29 March 2012 23:34:17 Sakari Ailus wrote:
> On Wed, Mar 28, 2012 at 02:00:01PM +0200, Laurent Pinchart wrote:
> > When applications modify preview engine parameters, the new values are
> > applied to the hardware by the preview engine interrupt handler during
> > vertical blanking. If the parameters are being changed when the
> > interrupt handler is called, it just delays applying the parameters
> > until the next frame.
> > 
> > If an application modifies the parameters for every frame, and the
> > preview engine interrupt is triggerred synchronously, the parameters are
> > never applied to the hardware.
> > 
> > Fix this by storing new parameters in a shadow copy, and switch the
> > active parameters with the shadow values atomically.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/video/omap3isp/isppreview.c |  137
> >  +++++++++++++++++++++-------- drivers/media/video/omap3isp/isppreview.h
> >  |   21 +++--
> >  2 files changed, 112 insertions(+), 46 deletions(-)
> > 
> > diff --git a/drivers/media/video/omap3isp/isppreview.c
> > b/drivers/media/video/omap3isp/isppreview.c index 2b5c137..3267d83 100644
> > --- a/drivers/media/video/omap3isp/isppreview.c
> > +++ b/drivers/media/video/omap3isp/isppreview.c

[snip]

> > @@ -887,19 +897,19 @@ static int preview_config(struct isp_prev_device
> > *prev,> 
> >  {
> >  	struct prev_params *params;
> >  	struct preview_update *attr;
> > +	unsigned long flags;
> >  	int i, bit, rval = 0;
> > 
> > -	params = &prev->params;
> > 
> >  	if (cfg->update == 0)
> >  		return 0;
> > 
> > -	if (prev->state != ISP_PIPELINE_STREAM_STOPPED) {
> > -		unsigned long flags;
> > +	spin_lock_irqsave(&prev->params.lock, flags);
> > +	params = prev->params.shadow;
> > +	memcpy(params, prev->params.active, sizeof(*params));
> 
> Why memcpy()? Couldn't the same be achieved by swapping the pointers?

I would prefer just swapping pointers as well, but that wouldn't work.

We have two sets of parameters, A and B. At initialization time we fill set A 
with initial values, and make active point to A and shadow to B. Let's assume 
we also fill set B with the same initial values as set A.

Let's imagine the user calls preview_config() to configure the gamma table. 
Set B is updated with new gamma table values. The active and shadow pointers 
are then swapped at the end of the function (assuming no interrupt is occuring 
at the same time). The active pointer points to set B, and the shadow pointer 
to set A. Set A contains outdated gamma table values compared to set B.

The user now calls preview_config() a second time before the interrupt handler 
gets a chance to run, to configure white balance. We udpate set A with new 
white balance values and swap the pointers. The active pointer points to set 
A, and the shadow pointer to set B.

The interrupt handler now runs, and configures the hardware with the white 
balance parameters from set A. The gamma table values from set B are not 
applied.

Another issue is omap3isp_preview_restore_context(), which must restore the 
whole preview engine context with all the latest parameters. If they're 
scattered around set A and set B, that will be more complex.

Of course, if you can think of a better way to handle this than a memcpy, I'm 
all ears :-)

> I also have a feeling that the implementation is still more complex than
> would really be needed.
> 
> Calls to preview_config() should also be serialised. Otherwise it's possible
> to call this simultaneously from user space. That likely wasn't an issue in
> the old implementation.

I agree. I'll fix that.

> > +	params->busy = true;
> > +	spin_unlock_irqrestore(&prev->params.lock, flags);
> > -		spin_lock_irqsave(&prev->lock, flags);
> > -		prev->shadow_update = 1;
> > -		spin_unlock_irqrestore(&prev->lock, flags);
> > -	}
> > +	params->update = 0;
> > 
> >  	for (i = 0; i < ARRAY_SIZE(update_attrs); i++) {
> >  		attr = &update_attrs[i];
> > @@ -926,11 +936,34 @@ static int preview_config(struct isp_prev_device
> > *prev,> 
> >  			params->features &= ~attr->feature_bit;
> >  		}
> > 
> > -		prev->update |= attr->feature_bit;
> > +		params->update |= attr->feature_bit;
> > +	}
> > +
> > +	if (rval < 0) {
> > +		kfree(params);
> 
> I think this must be a remnant from the earlier version of the patch. :-)

Oops :-)

> > +		return rval;
> >  	}
> > 
> > -	prev->shadow_update = 0;
> > -	return rval;
> > +	spin_lock_irqsave(&prev->params.lock, flags);
> > +	params->busy = false;
> > +
> > +	/* If active parameters are not in use, switch the active and shadow
> > +	 * parameters.
> > +	 */
> > +	if (!prev->params.active->busy) {
> > +		/* Make sure to keep the active update flags as the hardware
> > +		 * hasn't been updated yet. The values have been copied at the
> > +		 * beginning of the function.
> > +		 */
> > +		params->update |= prev->params.active->update;
> > +		prev->params.active->update = 0;
> > +
> > +		prev->params.shadow = prev->params.active;
> > +		prev->params.active = params;
> > +	}
> > +	spin_unlock_irqrestore(&prev->params.lock, flags);
> > +
> > +	return 0;
> > 
> >  }

[snip]

> > @@ -1249,12 +1283,18 @@ static void preview_print_status(struct
> > isp_prev_device *prev)> 
> >  /*
> >  
> >   * preview_init_params - init image processing parameters.
> >   * @prev: pointer to previewer private structure
> > - * return none
> > + *
> > + * Returns 0 on success or -ENOMEM if parameters memory can't be
> > allocated.
>
> This comment no longer needs to be changed.

Indeed. And the function doesn't need to return a value anymore.

> >   */
> > 
> > -static void preview_init_params(struct isp_prev_device *prev)
> > +static int preview_init_params(struct isp_prev_device *prev)
> > 
> >  {
> > -	struct prev_params *params = &prev->params;
> > -	int i = 0;
> > +	struct prev_params *params;
> > +	unsigned int i;
> > +
> > +	spin_lock_init(&prev->params.lock);
> > +
> > +	params = &prev->params.params[0];
> > +	params->busy = false;
> > 
> >  	/* Init values */
> >  	params->contrast = ISPPRV_CONTRAST_DEF * ISPPRV_CONTRAST_UNITS;

-- 
Regards,

Laurent Pinchart

