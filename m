Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58856 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1427552AbcBSQO3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2016 11:14:29 -0500
Date: Fri, 19 Feb 2016 14:14:23 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 2/5] media: Always keep a graph walk large enough
 around
Message-ID: <20160219141423.56264355@recife.lan>
In-Reply-To: <20160219144046.GQ32612@valkosipuli.retiisi.org.uk>
References: <1453906078-29087-1-git-send-email-sakari.ailus@iki.fi>
	<1453906078-29087-3-git-send-email-sakari.ailus@iki.fi>
	<20160219120341.076478ef@recife.lan>
	<20160219144046.GQ32612@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 19 Feb 2016 16:40:46 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Fri, Feb 19, 2016 at 12:03:41PM -0200, Mauro Carvalho Chehab wrote:
> > Hi Sakari,
> > 
> > Em Wed, 27 Jan 2016 16:47:55 +0200
> > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> >   
> > > Re-create the graph walk object as needed in order to have one large enough
> > > available for all entities in the graph.
> > > 
> > > This enumeration is used for pipeline power management in the future.
> > > 
> > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > ---
> > >  drivers/media/media-device.c | 21 +++++++++++++++++++++
> > >  include/media/media-device.h |  5 +++++
> > >  2 files changed, 26 insertions(+)
> > > 
> > > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > > index 4d1c13d..52d7809 100644
> > > --- a/drivers/media/media-device.c
> > > +++ b/drivers/media/media-device.c
> > > @@ -577,6 +577,26 @@ int __must_check media_device_register_entity(struct media_device *mdev,
> > >  
> > >  	spin_unlock(&mdev->lock);
> > >  
> > > +	mutex_lock(&mdev->graph_mutex);
> > > +	if (mdev->entity_internal_idx_max
> > > +	    >= mdev->pm_count_walk.ent_enum.idx_max) {
> > > +		struct media_entity_graph new = { 0 };
> > > +
> > > +		/*
> > > +		 * Initialise the new graph walk before cleaning up
> > > +		 * the old one in order not to spoil the graph walk
> > > +		 * object of the media device if graph walk init fails.
> > > +		 */
> > > +		ret = media_entity_graph_walk_init(&new, mdev);
> > > +		if (ret) {
> > > +			mutex_unlock(&mdev->graph_mutex);
> > > +			return ret;
> > > +		}
> > > +		media_entity_graph_walk_cleanup(&mdev->pm_count_walk);
> > > +		mdev->pm_count_walk = new;
> > > +	}
> > > +	mutex_unlock(&mdev->graph_mutex);
> > > +  
> > 
> > I don't like the idea of creating a new graph init and destroying the
> > previous one every time. In principle, this needs to be done only
> > when trying to start the graph - or just before registering the
> > MC devnode, if the driver needs/wants to optimize it.  
> 
> It's not every time --- with the previous patch, that's every 32 or 64
> additional entity, depending on how many bits the unsigned long is.

Still it will be called a lot of times for DVB devices. Why doing that,
if such alloc can be done only after finishing registering all devices?

> 
> > 
> > As kbuildtest also didn't like this patch, I'm not applying it
> > for now.  
> 
> For missing KernelDoc documentation for a struct field.
> 
> Other fields in the struct don't have KernelDoc documentation either, and I
> didn't feel it'd fit well for this patch. I can add a patch to change the
> field documentation to the set if you like.

Ok, it could be done on a separate patch. Feel free to submit it.

Thanks!
Mauro
