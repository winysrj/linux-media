Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:56734 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946411AbbHGXzx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Aug 2015 19:55:53 -0400
Date: Fri, 7 Aug 2015 20:55:34 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH RFC v2 01/16] media: Add some fields to store graph
 objects
Message-ID: <20150807205534.06ea65c2@recife.lan>
In-Reply-To: <20150807231445.GA19840@valkosipuli.retiisi.org.uk>
References: <cover.1438954897.git.mchehab@osg.samsung.com>
	<a3c1d738a55bf2b3b34222125ab0b27de28cbcfb.1438954897.git.mchehab@osg.samsung.com>
	<20150807231445.GA19840@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 8 Aug 2015 02:14:46 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Fri, Aug 07, 2015 at 11:19:59AM -0300, Mauro Carvalho Chehab wrote:
> > We'll need unique IDs for graph objects and a way to associate
> > them with the media interface.
> > 
> > So, add an atomic var to be used to create unique IDs and
> > a list to store such objects.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > index 7b39440192d6..e627b0b905ad 100644
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c
> > @@ -396,6 +396,10 @@ int __must_check __media_device_register(struct media_device *mdev,
> >  		return ret;
> >  	}
> >  
> > +	/* Initialize media graph object list and ID */
> > +	atomic_set(&mdev->last_obj_id, 0);
> > +	INIT_LIST_HEAD(&mdev->object_list);
> > +
> >  	return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(__media_device_register);
> > diff --git a/include/media/media-device.h b/include/media/media-device.h
> > index 6e6db78f1ee2..a9d546716e49 100644
> > --- a/include/media/media-device.h
> > +++ b/include/media/media-device.h
> > @@ -78,6 +78,10 @@ struct media_device {
> >  
> >  	int (*link_notify)(struct media_link *link, u32 flags,
> >  			   unsigned int notification);
> > +
> > +	/* Used by media_graph stuff */
> > +	atomic_t last_obj_id;
> > +	struct list_head object_list;
> >  };
> >  
> >  /* Supported link_notify @notification values. */
> 
> Instead of starting with rework of the MC internals, what would you think of
> separating interfaces from entities first, and see how that would be used by
> a driver (e.g. DVB)? 

Because that won't attend the requirements we've mapped during the
workshop. We did some radical changes there, and we want to keep the
structs more generic, in order to allow MC usage on other subsystems
like IIO.

Also, starting the changes at the drivers would just make a way worse
and harder to work, as it would use a hacky temporary representation
that will need to change as the MC internals change. That would mean
more code to be changed latter and more complex patchsets, as we fix
the MC internals.

You should remind that one of the most complex goals is that we'll need
to support dynamic entity/pad/link/interface creation/removal. That will
require changes at the MC internals anyway. So, it is better to do such
changes first in a way that it would be easier to latter add support for
it, and, once we have a kABI that works, add the needed things at the
drivers side.

With this patch series, the MC internals are better, and will easily
support the new API that was designed during the meeting.

So, my plan for the next week is to test it, in order to be sure that
everything keeps working, and then add interfaces and the new userspace
ioctls.

> I think a simple linked list would do per entity, no
> links would be needed at this point in the internal representation.

The entity/interface links are now represented as linked lists (and
so the pad/pad links). By sharing the same struct, no code duplication,
making easier to maintain. Also, if we need graph traversal, the code
is there.

For now, I opted to use a separate list inside the entity for 
the entity/interface. This is not really needed, but it would mean
a shorter time when checking all entity-interface links. The drawback
is that it makes harder for graph traversal. So, eventually, we might
want to change it in some future, specially if we need to represent
indirect control and do graph traversal for interfaces. I guess we
may need graph traversal for the Kernelspace-userspace sinks, like
ALSA PCM capture interfaces. So, we may need to revisit that.

> I'll review this better during the next week.

Ok.

Regards,
Mauro
