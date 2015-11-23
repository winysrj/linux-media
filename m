Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39386 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbbKWWUi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2015 17:20:38 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v8 48/55] [media] media_device: add a topology version field
Date: Tue, 24 Nov 2015 00:20:47 +0200
Message-ID: <2807639.maRzWhRfBJ@avalon>
In-Reply-To: <55E448A8.6060004@xs4all.nl>
References: <cover.1440902901.git.mchehab@osg.samsung.com> <e8cb8de5ad8f2da3c32418d67340fe4bb663ce5c.1440902901.git.mchehab@osg.samsung.com> <55E448A8.6060004@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro and Hans,

On Monday 31 August 2015 14:29:28 Hans Verkuil wrote:
> On 08/30/2015 05:06 AM, Mauro Carvalho Chehab wrote:
> > Every time a graph object is added or removed, the version
> > of the topology changes. That's a requirement for the new
> > MEDIA_IOC_G_TOPOLOGY, in order to allow userspace to know
> > that the topology has changed after a previous call to it.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> I think this should be postponed until we actually have dynamic
> reconfigurable graphs.
> 
> I would also like to reserve version 0: if 0 is returned, then the graph is
> static.
> 
> In G_TOPOLOGY we'd return always 0 for now.

So would I. We need a way to group graph modifications to avoid incrementing 
the version number and generating an event for every entity, link or pad added 
or removed. As this patch doesn't address that I don't see a use for the 
version number now other than making our life more difficult when we'll 
implement dynamic updates by forcing us to consider backward compatibility 
with something that we know won't do the job.

> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index c89f51bc688d..c18f4af52771 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -185,6 +185,9 @@ void media_gobj_init(struct media_device *mdev,
> >  		list_add_tail(&gobj->list, &mdev->interfaces);
> >  		break;
> >  	}
> > +
> > +	mdev->topology_version++;
> > +
> >  	dev_dbg_obj(__func__, gobj);
> >  }
> > 
> > @@ -199,6 +202,8 @@ void media_gobj_remove(struct media_gobj *gobj)
> >  {
> >  	dev_dbg_obj(__func__, gobj);
> > 
> > +	gobj->mdev->topology_version++;
> > +
> >  	/* Remove the object from mdev list */
> >  	list_del(&gobj->list);
> >  }
> > diff --git a/include/media/media-device.h b/include/media/media-device.h
> > index 0d1b9c687454..1b12774a9ab4 100644
> > --- a/include/media/media-device.h
> > +++ b/include/media/media-device.h
> > @@ -41,6 +41,8 @@ struct device;
> >   * @bus_info:	Unique and stable device location identifier
> >   * @hw_revision: Hardware device revision
> >   * @driver_version: Device driver version
> > + * @topology_version: Monotonic counter for storing the version of the
> > graph
> > + *		topology. Should be incremented each time the topology changes.
> >   * @entity_id:	Unique ID used on the last entity registered
> >   * @pad_id:	Unique ID used on the last pad registered
> >   * @link_id:	Unique ID used on the last link registered
> > @@ -74,6 +76,8 @@ struct media_device {
> >  	u32 hw_revision;
> >  	u32 driver_version;
> > 
> > +	u32 topology_version;
> > +
> >  	u32 entity_id;
> >  	u32 pad_id;
> >  	u32 link_id;

-- 
Regards,

Laurent Pinchart

