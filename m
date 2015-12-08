Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:46740 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbbLHRWK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2015 12:22:10 -0500
Date: Tue, 8 Dec 2015 15:22:04 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	devel@driverdev.osuosl.org
Subject: Re: [PATCH v8 36/55] [media] davinci_vbpe: stop
 MEDIA_ENT_T_V4L2_SUBDEV abuse
Message-ID: <20151208152204.67458a4c@recife.lan>
In-Reply-To: <1764940.OloRuAWqP2@avalon>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
	<d3cc1b1e74a7a8bd0379afefb4695257f0a0d308.1440902901.git.mchehab@osg.samsung.com>
	<1764940.OloRuAWqP2@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 06 Dec 2015 03:52:01 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Sunday 30 August 2015 00:06:47 Mauro Carvalho Chehab wrote:
> > This driver is abusing MEDIA_ENT_T_V4L2_SUBDEV:
> > 
> > - it uses a hack to check if the remote entity is a subdev;
> 
> Same comment as for "omap4iss: stop MEDIA_ENT_T_V4L2_SUBDEV abuse", this isn't 
> a hack.
> 
> > - it still uses the legacy entity subtype check macro, that
> >   will be removed soon.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
> > b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c index
> > b89a057b8b7e..7fd78329e3e1 100644
> > --- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
> > +++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
> > @@ -1711,8 +1711,11 @@ ipipe_link_setup(struct media_entity *entity, const
> > struct media_pad *local, struct vpfe_device *vpfe_dev =
> > to_vpfe_device(ipipe);
> >  	u16 ipipeif_sink = vpfe_dev->vpfe_ipipeif.input;
> > 
> > -	switch (local->index | media_entity_type(remote->entity)) {
> > -	case IPIPE_PAD_SINK | MEDIA_ENT_T_V4L2_SUBDEV:
> > +	if (!is_media_entity_v4l2_subdev(remote->entity))
> > +		return -EINVAL;
> 
> You can drop the check (even though the implementation in the switch looks 
> dubious to me, but that's not your fault).

I prefer to keep the above check, as it shouldn't hurt. 

As I said on a previous comment on your reviews, if someone adds later
some non-V4L2 entities to the media pipeline where the DaVinci media
driver belongs, it could be a problem without the above check.

> 
> > +	switch (local->index) {
> > +	case IPIPE_PAD_SINK:
> >  		if (!(flags & MEDIA_LNK_FL_ENABLED)) {
> >  			ipipe->input = IPIPE_INPUT_NONE;
> >  			break;
> > @@ -1725,7 +1728,7 @@ ipipe_link_setup(struct media_entity *entity, const
> > struct media_pad *local, ipipe->input = IPIPE_INPUT_CCDC;
> >  		break;
> > 
> > -	case IPIPE_PAD_SOURCE | MEDIA_ENT_T_V4L2_SUBDEV:
> > +	case IPIPE_PAD_SOURCE:
> >  		/* out to RESIZER */
> >  		if (flags & MEDIA_LNK_FL_ENABLED)
> >  			ipipe->output = IPIPE_OUTPUT_RESIZER;
> > diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> > b/drivers/staging/media/davinci_vpfe/vpfe_video.c index
> > 9eef64e0f0ab..2dbf14b9bb5f 100644
> > --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> > +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> > @@ -88,7 +88,7 @@ vpfe_video_remote_subdev(struct vpfe_video_device *video,
> > u32 *pad) {
> >  	struct media_pad *remote = media_entity_remote_pad(&video->pad);
> > 
> > -	if (remote == NULL || remote->entity->type != MEDIA_ENT_T_V4L2_SUBDEV)
> > +	if (!remote || !is_media_entity_v4l2_subdev(remote->entity))
> >  		return NULL;
> >  	if (pad)
> >  		*pad = remote->index;
> > @@ -243,8 +243,7 @@ static int vpfe_video_validate_pipeline(struct
> > vpfe_pipeline *pipe)
> > 
> >  		/* Retrieve the source format */
> >  		pad = media_entity_remote_pad(pad);
> > -		if (pad == NULL ||
> > -			pad->entity->type != MEDIA_ENT_T_V4L2_SUBDEV)
> > +		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
> >  			break;
> > 
> >  		subdev = media_entity_to_v4l2_subdev(pad->entity);
> 
