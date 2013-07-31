Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48648 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890Ab3GaWrh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Jul 2013 18:47:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Katsuya MATSUBARA <matsu@igel.co.jp>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v4 6/7] vsp1: Fix lack of the sink entity registration for enabled links
Date: Thu, 01 Aug 2013 00:48:39 +0200
Message-ID: <2125039.UCGXb8RZgO@avalon>
In-Reply-To: <20130731212921.GT12281@valkosipuli.retiisi.org.uk>
References: <1375285954-32153-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1375285954-32153-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <20130731212921.GT12281@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thursday 01 August 2013 00:29:21 Sakari Ailus wrote:
> On Wed, Jul 31, 2013 at 05:52:33PM +0200, Laurent Pinchart wrote:
> > From: Katsuya Matsubara <matsu@igel.co.jp>
> > 
> > Each source entity maintains a pointer to the counterpart sink
> > entity while an enabled link connects them. It should be managed by
> > the setup_link callback in the media controller framework at runtime.
> > However, enabled links which connect RPFs and WPFs that have an
> > equivalent index number are created during initialization.
> > This registers the pointer to a sink entity from the source entity
> > when an enabled link is created.
> > 
> > Signed-off-by: Katsuya Matsubara <matsu@igel.co.jp>
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  drivers/media/platform/vsp1/vsp1_drv.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/media/platform/vsp1/vsp1_drv.c
> > b/drivers/media/platform/vsp1/vsp1_drv.c index b05aee1..4d338ce 100644
> > --- a/drivers/media/platform/vsp1/vsp1_drv.c
> > +++ b/drivers/media/platform/vsp1/vsp1_drv.c
> > @@ -101,6 +101,9 @@ static int vsp1_create_links(struct vsp1_device *vsp1,
> > struct vsp1_entity *sink)> 
> >  						       entity, pad, flags);
> >  			
> >  			if (ret < 0)
> >  				return ret;
> > +
> > +			if (flags & MEDIA_LNK_FL_ENABLED)
> > +				source->sink = entity;
> 
> "entity" here is in fact an entity which is a sink. It could have a more
> descriptive name. Up to you; should be changed in the 5th patch first.

There's already a local variable called sink that points to the sink 
vsp1_entity. entity points to the media_entity contained in the vsp1_entity. 
Feel free to propose different names, otherwise I'll keep it as-is.

> Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
-- 
Regards,

Laurent Pinchart

