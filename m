Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59671 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbbLJTNQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2015 14:13:16 -0500
Date: Thu, 10 Dec 2015 17:13:11 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 12/18] [media] media-entity: must check
 media_create_pad_link()
Message-ID: <20151210171311.5148d2b3@recife.lan>
In-Reply-To: <3963361.pdRumI6NVS@avalon>
References: <cover.1441559233.git.mchehab@osg.samsung.com>
	<4dc311149dc667420c59ba7060846ba993cef507.1441559233.git.mchehab@osg.samsung.com>
	<3963361.pdRumI6NVS@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 23 Nov 2015 19:54:17 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Sunday 06 September 2015 14:30:55 Mauro Carvalho Chehab wrote:
> > Drivers should check if media_create_pad_link() actually
> > worked.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > index 62f882d872b1..8bdc10dcc5e7 100644
> > --- a/include/media/media-entity.h
> > +++ b/include/media/media-entity.h
> > @@ -348,8 +348,9 @@ int media_entity_init(struct media_entity *entity, u16
> > num_pads, struct media_pad *pads);
> >  void media_entity_cleanup(struct media_entity *entity);
> > 
> > -int media_create_pad_link(struct media_entity *source, u16 source_pad,
> > -		struct media_entity *sink, u16 sink_pad, u32 flags);
> > +__must_check int media_create_pad_link(struct media_entity *source,
> > +			u16 source_pad,	struct media_entity *sink,
> 
> s/,\t/, /

Fixed.

> 
> > +			u16 sink_pad, u32 flags);
> 
> And it would make sense to squash this with the patch that introduces 
> media_create_pad_link().

Maybe, but it is too late for that ;) Also, not sure about this 
specific case, but on the other patches adding __must_check, some
things needed to be fixed before actually adding the change.

> 
> >  void __media_entity_remove_links(struct media_entity *entity);
> >  void media_entity_remove_links(struct media_entity *entity);
> 
