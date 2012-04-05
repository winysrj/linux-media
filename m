Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44018 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab2DEOHi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2012 10:07:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 4/4] omap3isp: preview: Shorten shadow update delay
Date: Thu, 05 Apr 2012 16:07:41 +0200
Message-ID: <5151597.4Olyp2nfFk@avalon>
In-Reply-To: <20120402215703.GF922@valkosipuli.localdomain>
References: <1332936001-32603-1-git-send-email-laurent.pinchart@ideasonboard.com> <2856992.ve4AGyBgA4@avalon> <20120402215703.GF922@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday 03 April 2012 00:57:03 Sakari Ailus wrote:
> On Fri, Mar 30, 2012 at 02:30:34AM +0200, Laurent Pinchart wrote:
> > On Thursday 29 March 2012 23:34:17 Sakari Ailus wrote:
> > > On Wed, Mar 28, 2012 at 02:00:01PM +0200, Laurent Pinchart wrote:

[snip]

> > > > @@ -887,19 +897,19 @@ static int preview_config(struct isp_prev_device
> > > > *prev,>
> > > > 
> > > >  {
> > > >  
> > > >  	struct prev_params *params;
> > > >  	struct preview_update *attr;
> > > > 
> > > > +	unsigned long flags;
> > > > 
> > > >  	int i, bit, rval = 0;
> > > > 
> > > > -	params = &prev->params;
> > > > 
> > > >  	if (cfg->update == 0)
> > > >  	
> > > >  		return 0;
> > > > 
> > > > -	if (prev->state != ISP_PIPELINE_STREAM_STOPPED) {
> > > > -		unsigned long flags;
> > > > +	spin_lock_irqsave(&prev->params.lock, flags);
> > > > +	params = prev->params.shadow;
> > > > +	memcpy(params, prev->params.active, sizeof(*params));
> > > 
> > > Why memcpy()? Couldn't the same be achieved by swapping the pointers?
> > 
> > I would prefer just swapping pointers as well, but that wouldn't work.
> > 
> > We have two sets of parameters, A and B. At initialization time we fill
> > set A with initial values, and make active point to A and shadow to B.
> > Let's assume we also fill set B with the same initial values as set A.
> > 
> > Let's imagine the user calls preview_config() to configure the gamma
> > table. Set B is updated with new gamma table values. The active and shadow
> > pointers are then swapped at the end of the function (assuming no
> > interrupt is occuring at the same time). The active pointer points to set
> > B, and the shadow pointer to set A. Set A contains outdated gamma table
> > values compared to set B.
> > 
> > The user now calls preview_config() a second time before the interrupt
> > handler gets a chance to run, to configure white balance. We udpate set A
> > with new white balance values and swap the pointers. The active pointer
> > points to set A, and the shadow pointer to set B.
> > 
> > The interrupt handler now runs, and configures the hardware with the white
> > balance parameters from set A. The gamma table values from set B are not
> > applied.
> > 
> > Another issue is omap3isp_preview_restore_context(), which must restore
> > the whole preview engine context with all the latest parameters. If
> > they're scattered around set A and set B, that will be more complex.
> > 
> > Of course, if you can think of a better way to handle this than a memcpy,
> > I'm all ears :-)
> 
> I think it's time to summarise the problem before solutions. :-)
> 
> We've got a single IOCTL which is used to configure an array of properties
> defined by structs like omap3isp_prev_nf and omap3isp_prev_dcor. The
> configuration of any single property may be set by the user of any point of
> time, and should be applied as quickly as possible in the next frame
> blanking period. The user may set the properties either by a single IOCTL
> call or many of them --- still the end result should be the same. There may
> well be more than two of these calls.
> 
> This means that just considering two complete parameter sets isn't enough to
> cover these cases. Instead, the parameters the IOCTL configures should be
> considered independent of the struct prev_params which they were
> configured.
> 
> I think it's probably easiest to present each individual parameter structs
> belonging to two queues: one queue is called "free" and the other one is
> "waiting". The free queue contains structs that are not used i.e. they may
> be used by the preview_config() to copy new settings to from the user space
> struct, after which they are put to the "waiting" queue. If the waiting
> queue was not empty, its old contents are thrown to free queue and replaced
> by the fresh parameter struct. The ISR will then remove struct from the
> waiting queue, apply the settings in parameter struct and put it back to
> free queue.

I wouldn't use queues, just active and shadow pointers, but the general idea 
of having per-parameter pointers remains the same.

> It's possible to implement the same with just a few flags without involving
> linked lists.
> 
> What do you think?

I think there's no way I can disagree with you, even if not doing so means I 
will have to rework the code :-) I'll post v3 when it will be ready.

-- 
Regards,

Laurent Pinchart

