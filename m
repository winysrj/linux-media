Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:48725 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab0INNvt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Sep 2010 09:51:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC/PATCH v4 03/11] media: Entities, pads and links
Date: Tue, 14 Sep 2010 15:51:47 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1282318153-18885-1-git-send-email-laurent.pinchart@ideasonboard.com> <1282318153-18885-4-git-send-email-laurent.pinchart@ideasonboard.com> <4C882D52.9020508@redhat.com>
In-Reply-To: <4C882D52.9020508@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009141551.48344.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Thursday 09 September 2010 02:41:54 Mauro Carvalho Chehab wrote:
> Em 20-08-2010 12:29, Laurent Pinchart escreveu:

[snip]

> > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > index 781c641..eeb002e 100644
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c

[snip]

> > +/**
> > + * media_device_register_entity - Register an entity with a media device
> > + * @mdev:	The media device
> > + * @entity:	The entity
> > + */
> > +int __must_check media_device_register_entity(struct media_device *mdev,
> > +					      struct media_entity *entity)
> > +{
> > +	/* Warn if we apparently re-register an entity */
> > +	WARN_ON(entity->parent != NULL);
> 
> Instead, it should just return -EINVAL and use __must_check.
> 
> What's the sense of allowing registering it twice?

It's a driver bug. Entities must not be registered twice. The WARN_ON is meant 
as a way to catch driver bugs. I can replace it with a BUG_ON.

[snip]

> > +EXPORT_SYMBOL(media_entity_init);
> 
> Just use EXPORT_SYMBOL_GPL() for all symbols that needs to be exported.

OK.

-- 
Regards,

Laurent Pinchart
