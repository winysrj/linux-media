Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59715 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbbHYJsv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 05:48:51 -0400
Date: Tue, 25 Aug 2015 06:48:46 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v7 19/44] [media] media: make link debug printk more
 generic
Message-ID: <20150825064846.4b81cf90@recife.lan>
In-Reply-To: <55DC1A3B.2010204@xs4all.nl>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
	<e5b7afddd3087eda9267245fcbfc1d24d059b3a9.1440359643.git.mchehab@osg.samsung.com>
	<55DC1A3B.2010204@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 25 Aug 2015 09:33:15 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 08/23/2015 10:17 PM, Mauro Carvalho Chehab wrote:
> > Remove entity name from the link as this exists only if the object
> > type is PAD on both link ends.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> I am wondering whether it should detect if this is a pad-to-pad link
> or an interface-to-entity link and log this accordingly.
> 
> But I think that is better done as a follow-up patch if we think this
> is useful. So for this patch:
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> > 
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index 9ec9c503caca..5788297cd500 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -106,14 +106,12 @@ static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
> >  		struct media_link *link = gobj_to_link(gobj);
> >  
> >  		dev_dbg(gobj->mdev->dev,
> > -			"%s: id 0x%08x link#%d: '%s' %s#%d ==> '%s' %s#%d\n",
> > +			"%s: id 0x%08x link#%d: %s#%d ==> %s#%d\n",
> >  			event_name, gobj->id, media_localid(gobj),
> >  
> > -			link->source->entity->name,
> >  			gobj_type(media_type(&link->source->graph_obj)),

Actually, here it should be, instead:
		&link->port0;

> >  			media_localid(&link->source->graph_obj),
> >  
> > -			link->sink->entity->name,
> >  			gobj_type(media_type(&link->sink->graph_obj)),

And here it should be, instead:
		&link->port1;

> >  			media_localid(&link->sink->graph_obj));
> >  		break;
> > 
> 
