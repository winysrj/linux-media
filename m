Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:47118 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbbLHSrB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2015 13:47:01 -0500
Date: Tue, 8 Dec 2015 16:46:56 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v8 43/55] [media] media: report if a pad is sink or
 source at debug msg
Message-ID: <20151208164656.3aa3873b@recife.lan>
In-Reply-To: <29589100.xT3BcZGtSY@avalon>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
	<a5724b2c7cac1192cbd5033d90745daa586883aa.1441540862.git.mchehab@osg.samsung.com>
	<29589100.xT3BcZGtSY@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 06 Dec 2015 02:53:57 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Sunday 06 September 2015 09:03:03 Mauro Carvalho Chehab wrote:
> > Sometimes, it is important to see if the created pad is
> > sink or source. Add info to track that.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index d8038a53f945..6ed5eef88593 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -121,8 +121,11 @@ static void dev_dbg_obj(const char *event_name,  struct
> > media_gobj *gobj) struct media_pad *pad = gobj_to_pad(gobj);
> > 
> >  		dev_dbg(gobj->mdev->dev,
> > -			"%s: id 0x%08x pad#%d: '%s':%d\n",
> > -			event_name, gobj->id, media_localid(gobj),
> > +			"%s: id 0x%08x %s%spad#%d: '%s':%d\n",
> > +			event_name, gobj->id,
> > +			pad->flags & MEDIA_PAD_FL_SINK   ? "  sink " : "",
> > +			pad->flags & MEDIA_PAD_FL_SOURCE ? "source " : "",
> 
> I'm wondering if we really need the two leading spaces in "  sink ", as a 
> bidirectional pad would print "  sink source pad" and mess up the alignment 
> anyway.

Good point. Right now, we don't have any bidirectional pad. For now, this
looks nicer and makes easier to check the logs. So, I prefer to keep it
as-is for now.

We can change it later, when we add bidirectional pads.

> 
> > +			media_localid(gobj),
> >  			pad->entity->name, pad->index);
> >  		break;
> >  	}
> 
