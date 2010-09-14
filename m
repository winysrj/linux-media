Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:38883 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab0INN7Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Sep 2010 09:59:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC/PATCH v4 04/11] media: Entity graph traversal
Date: Tue, 14 Sep 2010 15:59:23 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1282318153-18885-1-git-send-email-laurent.pinchart@ideasonboard.com> <1282318153-18885-5-git-send-email-laurent.pinchart@ideasonboard.com> <4C882E75.8060906@redhat.com>
In-Reply-To: <4C882E75.8060906@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009141559.24358.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Thursday 09 September 2010 02:46:45 Mauro Carvalho Chehab wrote:
> Em 20-08-2010 12:29, Laurent Pinchart escreveu:
> > From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> > 
> > Add media entity graph traversal. The traversal follows active links by
> > depth first. Traversing graph backwards is prevented by comparing the
> > next possible entity in the graph with the previous one. Multiply
> > connected graphs are thus not supported.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Signed-off-by: Vimarsh Zutshi <vimarsh.zutshi@nokia.com>
> > ---
> > 
> >  Documentation/media-framework.txt |   40 +++++++++++++
> >  drivers/media/media-entity.c      |  115
> >  +++++++++++++++++++++++++++++++++++++ include/media/media-entity.h     
> >  |   15 +++++
> >  3 files changed, 170 insertions(+), 0 deletions(-)
> > 
> > diff --git a/Documentation/media-framework.txt
> > b/Documentation/media-framework.txt index 35d74e4..a599824 100644
> > --- a/Documentation/media-framework.txt
> > +++ b/Documentation/media-framework.txt
> > @@ -238,3 +238,43 @@ Links have flags that describe the link capabilities
> > and state.
> > 
> >  	MEDIA_LINK_FLAG_ACTIVE must also be set since an immutable link is
> >  	always active.
> > 
> > +
> > +Graph traversal
> > +---------------
> > +
> > +The media framework provides APIs to iterate over entities in a graph.
> > +
> > +To iterate over all entities belonging to a media device, drivers can
> > use the +media_device_for_each_entity macro, defined in
> > include/media/media-device.h. +
> > +	struct media_entity *entity;
> > +
> > +	media_device_for_each_entity(entity, mdev) {
> > +		/* entity will point to each entity in turn */
> > +		...
> > +	}
> > +
> > +Drivers might also need to iterate over all entities in a graph that can
> > be +reached only through active links starting at a given entity. The
> > media +framework provides a depth-first graph traversal API for that
> > purpose. +
> > +Note that graphs with cycles (whether directed or undirected) are *NOT*
> > +supported by the graph traversal API.
> 
> Please document that a maximum depth exists to prevent loops, currently
> defined as 16 (MEDIA_ENTITY_ENUM_MAX_DEPTH).

Good idea, will do.

-- 
Regards,

Laurent Pinchart
