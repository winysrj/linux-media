Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:53788 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030461Ab2CFMJe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 07:09:34 -0500
Date: Tue, 6 Mar 2012 14:09:30 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com
Subject: Re: [PATCH v4 16/34] media: Collect entities that are part of the
 pipeline before link validation
Message-ID: <20120306120930.GE1075@valkosipuli.localdomain>
References: <20120302173219.GA15695@valkosipuli.localdomain>
 <1330709442-16654-16-git-send-email-sakari.ailus@iki.fi>
 <7119876.zcxcmOKuSu@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7119876.zcxcmOKuSu@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, Mar 05, 2012 at 12:13:39PM +0100, Laurent Pinchart wrote:
> On Friday 02 March 2012 19:30:24 Sakari Ailus wrote:
> > Make information available which entities are part of the pipeline before
> > link_validate() ops are being called.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  drivers/media/media-entity.c |   23 ++++++++++++++++++++---
> >  include/media/media-entity.h |    1 +
> >  2 files changed, 21 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index d6d0e81..55f66c6 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -220,12 +220,19 @@ __must_check int media_entity_pipeline_start(struct
> > media_entity *entity, struct media_device *mdev = entity->parent;
> >  	struct media_entity_graph graph;
> >  	struct media_entity *entity_err = entity;
> > +	struct {
> > +		struct media_entity *entity;
> > +		struct media_link *link;
> > +	} to_validate[MEDIA_ENTITY_ENUM_MAX_DEPTH];
> > +	int nto_validate = 0;
> >  	int ret;
> > 
> >  	mutex_lock(&mdev->graph_mutex);
> > 
> >  	media_entity_graph_walk_start(&graph, entity);
> > 
> > +	pipe->entities = 0;
> > +
> >  	while ((entity = media_entity_graph_walk_next(&graph))) {
> >  		unsigned int i;
> > 
> > @@ -237,6 +244,8 @@ __must_check int media_entity_pipeline_start(struct
> > media_entity *entity, if (entity->stream_count > 1)
> >  			continue;
> > 
> > +		pipe->entities |= 1 << entity->id;
> > +
> >  		if (!entity->ops || !entity->ops->link_validate)
> >  			continue;
> > 
> > @@ -251,12 +260,20 @@ __must_check int media_entity_pipeline_start(struct
> > media_entity *entity, if (link->sink->entity != entity)
> >  				continue;
> > 
> > -			ret = entity->ops->link_validate(link);
> > -			if (ret < 0 && ret != -ENOIOCTLCMD)
> > -				goto error;
> > +			BUG_ON(nto_validate >= MEDIA_ENTITY_ENUM_MAX_DEPTH);
> > +			to_validate[nto_validate].entity = entity;
> > +			to_validate[nto_validate].link = link;
> > +			nto_validate++;
> >  		}
> >  	}
> > 
> > +	for (nto_validate--; nto_validate >= 0; nto_validate--) {
> > +		ret = to_validate[nto_validate].entity->ops->
> > +			link_validate(to_validate[nto_validate].link);
> > +		if (ret < 0 && ret != -ENOIOCTLCMD)
> > +			goto error;
> > +	}
> > +
> >  	mutex_unlock(&mdev->graph_mutex);
> > 
> >  	return 0;
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > index 0c16f51..bbfc8f2 100644
> > --- a/include/media/media-entity.h
> > +++ b/include/media/media-entity.h
> > @@ -27,6 +27,7 @@
> >  #include <linux/media.h>
> > 
> >  struct media_pipeline {
> > +	u32 entities;
> 
> This assume there will be no more than 32 entities. I don't think that's a 
> safe assumption, especially with ALSA devices. I'm not sure I would put this 
> in the media controller core just yet.

Based our discussion online, I'm dropping this patch and replacing it with
another which is specific to the omap3isp driver.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
