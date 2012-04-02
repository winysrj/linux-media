Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56023 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750992Ab2DBV5H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Apr 2012 17:57:07 -0400
Date: Tue, 3 Apr 2012 00:57:03 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 4/4] omap3isp: preview: Shorten shadow update delay
Message-ID: <20120402215703.GF922@valkosipuli.localdomain>
References: <1332936001-32603-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1332936001-32603-5-git-send-email-laurent.pinchart@ideasonboard.com>
 <20120329203417.GC922@valkosipuli.localdomain>
 <2856992.ve4AGyBgA4@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2856992.ve4AGyBgA4@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Mar 30, 2012 at 02:30:34AM +0200, Laurent Pinchart wrote:
> On Thursday 29 March 2012 23:34:17 Sakari Ailus wrote:
> > On Wed, Mar 28, 2012 at 02:00:01PM +0200, Laurent Pinchart wrote:
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
> > >  drivers/media/video/omap3isp/isppreview.c |  137
> > >  +++++++++++++++++++++-------- drivers/media/video/omap3isp/isppreview.h
> > >  |   21 +++--
> > >  2 files changed, 112 insertions(+), 46 deletions(-)
> > > 
> > > diff --git a/drivers/media/video/omap3isp/isppreview.c
> > > b/drivers/media/video/omap3isp/isppreview.c index 2b5c137..3267d83 100644
> > > --- a/drivers/media/video/omap3isp/isppreview.c
> > > +++ b/drivers/media/video/omap3isp/isppreview.c
> 
> [snip]
> 
> > > @@ -887,19 +897,19 @@ static int preview_config(struct isp_prev_device
> > > *prev,> 
> > >  {
> > >  	struct prev_params *params;
> > >  	struct preview_update *attr;
> > > +	unsigned long flags;
> > >  	int i, bit, rval = 0;
> > > 
> > > -	params = &prev->params;
> > > 
> > >  	if (cfg->update == 0)
> > >  		return 0;
> > > 
> > > -	if (prev->state != ISP_PIPELINE_STREAM_STOPPED) {
> > > -		unsigned long flags;
> > > +	spin_lock_irqsave(&prev->params.lock, flags);
> > > +	params = prev->params.shadow;
> > > +	memcpy(params, prev->params.active, sizeof(*params));
> > 
> > Why memcpy()? Couldn't the same be achieved by swapping the pointers?
> 
> I would prefer just swapping pointers as well, but that wouldn't work.
> 
> We have two sets of parameters, A and B. At initialization time we fill set A 
> with initial values, and make active point to A and shadow to B. Let's assume 
> we also fill set B with the same initial values as set A.
> 
> Let's imagine the user calls preview_config() to configure the gamma table. 
> Set B is updated with new gamma table values. The active and shadow pointers 
> are then swapped at the end of the function (assuming no interrupt is occuring 
> at the same time). The active pointer points to set B, and the shadow pointer 
> to set A. Set A contains outdated gamma table values compared to set B.
> 
> The user now calls preview_config() a second time before the interrupt handler 
> gets a chance to run, to configure white balance. We udpate set A with new 
> white balance values and swap the pointers. The active pointer points to set 
> A, and the shadow pointer to set B.
> 
> The interrupt handler now runs, and configures the hardware with the white 
> balance parameters from set A. The gamma table values from set B are not 
> applied.
> 
> Another issue is omap3isp_preview_restore_context(), which must restore the 
> whole preview engine context with all the latest parameters. If they're 
> scattered around set A and set B, that will be more complex.
> 
> Of course, if you can think of a better way to handle this than a memcpy, I'm 
> all ears :-)

I think it's time to summarise the problem before solutions. :-)

We've got a single IOCTL which is used to configure an array of properties
defined by structs like omap3isp_prev_nf and omap3isp_prev_dcor. The
configuration of any single property may be set by the user of any point of
time, and should be applied as quickly as possible in the next frame
blanking period. The user may set the properties either by a single IOCTL
call or many of them --- still the end result should be the same. There may
well be more than two of these calls.

This means that just considering two complete parameter sets isn't enough to
cover these cases. Instead, the parameters the IOCTL configures should be
considered independent of the struct prev_params which they were
configured.

I think it's probably easiest to present each individual parameter structs
belonging to two queues: one queue is called "free" and the other one is
"waiting". The free queue contains structs that are not used i.e. they may
be used by the preview_config() to copy new settings to from the user space
struct, after which they are put to the "waiting" queue. If the waiting
queue was not empty, its old contents are thrown to free queue and replaced
by the fresh parameter struct. The ISR will then remove struct from the
waiting queue, apply the settings in parameter struct and put it back to
free queue.

It's possible to implement the same with just a few flags without involving
linked lists.

What do you think?

> [snip]
> 
> > > @@ -1249,12 +1283,18 @@ static void preview_print_status(struct
> > > isp_prev_device *prev)> 
> > >  /*
> > >  
> > >   * preview_init_params - init image processing parameters.
> > >   * @prev: pointer to previewer private structure
> > > - * return none
> > > + *
> > > + * Returns 0 on success or -ENOMEM if parameters memory can't be
> > > allocated.
> >
> > This comment no longer needs to be changed.
> 
> Indeed. And the function doesn't need to return a value anymore.

Good point. I agree.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
