Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48500 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759615AbcBTW74 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Feb 2016 17:59:56 -0500
Date: Sun, 21 Feb 2016 00:59:50 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 2/5] media: Always keep a graph walk large enough
 around
Message-ID: <20160220225950.GS32612@valkosipuli.retiisi.org.uk>
References: <1453906078-29087-1-git-send-email-sakari.ailus@iki.fi>
 <1453906078-29087-3-git-send-email-sakari.ailus@iki.fi>
 <20160219120341.076478ef@recife.lan>
 <20160219144046.GQ32612@valkosipuli.retiisi.org.uk>
 <20160219141423.56264355@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160219141423.56264355@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Fri, Feb 19, 2016 at 02:14:23PM -0200, Mauro Carvalho Chehab wrote:
> Em Fri, 19 Feb 2016 16:40:46 +0200
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> > Hi Mauro,
> > 
> > On Fri, Feb 19, 2016 at 12:03:41PM -0200, Mauro Carvalho Chehab wrote:
> > > Hi Sakari,
> > > 
> > > Em Wed, 27 Jan 2016 16:47:55 +0200
> > > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> > >   
> > > > Re-create the graph walk object as needed in order to have one large enough
> > > > available for all entities in the graph.
> > > > 
> > > > This enumeration is used for pipeline power management in the future.
> > > > 
> > > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > > ---
> > > >  drivers/media/media-device.c | 21 +++++++++++++++++++++
> > > >  include/media/media-device.h |  5 +++++
> > > >  2 files changed, 26 insertions(+)
> > > > 
> > > > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > > > index 4d1c13d..52d7809 100644
> > > > --- a/drivers/media/media-device.c
> > > > +++ b/drivers/media/media-device.c
> > > > @@ -577,6 +577,26 @@ int __must_check media_device_register_entity(struct media_device *mdev,
> > > >  
> > > >  	spin_unlock(&mdev->lock);
> > > >  
> > > > +	mutex_lock(&mdev->graph_mutex);
> > > > +	if (mdev->entity_internal_idx_max
> > > > +	    >= mdev->pm_count_walk.ent_enum.idx_max) {
> > > > +		struct media_entity_graph new = { 0 };
> > > > +
> > > > +		/*
> > > > +		 * Initialise the new graph walk before cleaning up
> > > > +		 * the old one in order not to spoil the graph walk
> > > > +		 * object of the media device if graph walk init fails.
> > > > +		 */
> > > > +		ret = media_entity_graph_walk_init(&new, mdev);
> > > > +		if (ret) {
> > > > +			mutex_unlock(&mdev->graph_mutex);
> > > > +			return ret;
> > > > +		}
> > > > +		media_entity_graph_walk_cleanup(&mdev->pm_count_walk);
> > > > +		mdev->pm_count_walk = new;
> > > > +	}
> > > > +	mutex_unlock(&mdev->graph_mutex);
> > > > +  
> > > 
> > > I don't like the idea of creating a new graph init and destroying the
> > > previous one every time. In principle, this needs to be done only
> > > when trying to start the graph - or just before registering the
> > > MC devnode, if the driver needs/wants to optimize it.  
> > 
> > It's not every time --- with the previous patch, that's every 32 or 64
> > additional entity, depending on how many bits the unsigned long is.
> 
> Still it will be called a lot of times for DVB devices. Why doing that,
> if such alloc can be done only after finishing registering all devices?

The intent is to prepare for being able to dynamically allocate and remove
entities, and still not allocate excessive amounts of memory for the graph.
With this set, there's a guarantee that the graph walk will always be
successful even if entities were added to or removed from the graph.

That's important as there are operations that may not fail such as
decrementing the use count of an entity (and possibly other entities as well
as a result; video nodes in practice).

I'd still like to claim that this will not have noticeable adverse effect on
the time it takes to register the necessary entities.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
