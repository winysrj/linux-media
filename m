Return-path: <mchehab@localhost>
Received: from perceval.irobotique.be ([92.243.18.41]:39526 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab0IANvq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Sep 2010 09:51:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH v4 03/11] media: Entities, pads and links
Date: Wed, 1 Sep 2010 15:51:47 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1282318153-18885-1-git-send-email-laurent.pinchart@ideasonboard.com> <1282318153-18885-4-git-send-email-laurent.pinchart@ideasonboard.com> <201008281231.29930.hverkuil@xs4all.nl>
In-Reply-To: <201008281231.29930.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009011551.47738.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

Hi Hans,

On Saturday 28 August 2010 12:31:29 Hans Verkuil wrote:
> > +#define MEDIA_ENTITY_TYPE_NODE			(1 << MEDIA_ENTITY_TYPE_SHIFT)
> > +#define MEDIA_ENTITY_TYPE_NODE_V4L		(MEDIA_ENTITY_TYPE_NODE + 1)
> > +#define MEDIA_ENTITY_TYPE_NODE_FB		(MEDIA_ENTITY_TYPE_NODE + 2)
> > +#define MEDIA_ENTITY_TYPE_NODE_ALSA		(MEDIA_ENTITY_TYPE_NODE + 3)
> > +#define MEDIA_ENTITY_TYPE_NODE_DVB		(MEDIA_ENTITY_TYPE_NODE + 4)
> 
> During discussions at work I realized that another type that might be
> needed in the future (not needed in the first version, I think) is
> NODE_MTB for flash memory. There are devices that have flash memory on
> board (basically a kind of BIOS) and it would be handy for a flash utility
> to find the corresponding mtd device.
> 
> It shouldn't be hard to add this when needed.

Agreed.

-- 
Regards,

Laurent Pinchart
