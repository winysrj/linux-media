Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54959 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbbHUR1Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 13:27:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-sh@vger.kernel.org
Subject: Re: [PATCH v6 1/8] [media] media: create a macro to get entity ID
Date: Fri, 21 Aug 2015 20:27:19 +0300
Message-ID: <1504949.EhTF6JoeCK@avalon>
In-Reply-To: <20150821054229.4d0d3bcf@recife.lan>
References: <cover.1439981515.git.mchehab@osg.samsung.com> <2334695.Oz27NUDV2a@avalon> <20150821054229.4d0d3bcf@recife.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Friday 21 August 2015 05:42:29 Mauro Carvalho Chehab wrote:
> Em Fri, 21 Aug 2015 03:40:48 +0300 Laurent Pinchart escreveu:
> > On Wednesday 19 August 2015 08:01:48 Mauro Carvalho Chehab wrote:
> > > Instead of accessing directly entity.id, let's create a macro,
> > > as this field will be moved into a common struct later on.
> > > 
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

[snip]

> > > diff --git a/drivers/media/platform/vsp1/vsp1_video.c
> > > b/drivers/media/platform/vsp1/vsp1_video.c index
> > > 17f08973f835..debe4e539df6
> > > 100644
> > > --- a/drivers/media/platform/vsp1/vsp1_video.c
> > > +++ b/drivers/media/platform/vsp1/vsp1_video.c
> > > @@ -352,10 +352,10 @@ static int vsp1_pipeline_validate_branch(struct
> > > vsp1_pipeline *pipe,
> > > 			break;
> > > 
> > >  		/* Ensure the branch has no loop. */
> > > -		if (entities & (1 << entity->subdev.entity.id))
> > > +		if (entities & (1 << media_entity_id(&entity->subdev.entity)))
> > >  			return -EPIPE;
> > > 
> > > -		entities |= 1 << entity->subdev.entity.id;
> > > +		entities |= 1 << media_entity_id(&entity->subdev.entity);
> > > 
> > >  		/* UDS can't be chained. */
> > >  		if (entity->type == VSP1_ENTITY_UDS) {
> > 
> > I would move the modification of the vsp1 driver to Javier's patch that
> > modifies the OMAP3 and OMAP4 drivers. Alternatively you could squash them
> > into this patch, but I believe having a first patch that adds the inline
> > function and a second patch that modifies all drivers to use it would be
> > better.
>
> Squashing will lose Javier's authorship. I guess the better is have a
> first patch with the inline, then my paches and Javier's ones, and
> latter on the patch removing entity->id.

What I meant is

1. This patch without the VSP1 chunk, with your authorship
2. Javier's patches for OMAP3 and OMAP4 + the VSP1 chunk squashed in a single 
patch, with Javier's authorship
3. Javier's patch removing entity->id, with Javier's authorship

I don't see a need to split usage of media_entity_id() into per-driver 
patches.

> I'll do that on the next patch series.
> 
> > > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > > index 8b21a4d920d9..0a66fc225559 100644
> > > --- a/include/media/media-entity.h
> > > +++ b/include/media/media-entity.h
> > > @@ -113,6 +113,11 @@ static inline u32 media_entity_subtype(struct
> > > media_entity *entity) return entity->type & MEDIA_ENT_SUBTYPE_MASK;
> > > 
> > >  }
> > > 
> > > +static inline u32 media_entity_id(struct media_entity *entity)
> > > +{
> > > +	return entity->id;
> > > +}
> > > +
> > > 
> > >  #define MEDIA_ENTITY_ENUM_MAX_DEPTH	16
> > >  #define MEDIA_ENTITY_ENUM_MAX_ID	64

-- 
Regards,

Laurent Pinchart

