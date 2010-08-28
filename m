Return-path: <mchehab@pedra>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2476 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab0H1Kbg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Aug 2010 06:31:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC/PATCH v4 03/11] media: Entities, pads and links
Date: Sat, 28 Aug 2010 12:31:29 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1282318153-18885-1-git-send-email-laurent.pinchart@ideasonboard.com> <1282318153-18885-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1282318153-18885-4-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008281231.29930.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

> +#define MEDIA_ENTITY_TYPE_NODE			(1 << MEDIA_ENTITY_TYPE_SHIFT)
> +#define MEDIA_ENTITY_TYPE_NODE_V4L		(MEDIA_ENTITY_TYPE_NODE + 1)
> +#define MEDIA_ENTITY_TYPE_NODE_FB		(MEDIA_ENTITY_TYPE_NODE + 2)
> +#define MEDIA_ENTITY_TYPE_NODE_ALSA		(MEDIA_ENTITY_TYPE_NODE + 3)
> +#define MEDIA_ENTITY_TYPE_NODE_DVB		(MEDIA_ENTITY_TYPE_NODE + 4)

During discussions at work I realized that another type that might be needed
in the future (not needed in the first version, I think) is NODE_MTB for flash
memory. There are devices that have flash memory on board (basically a kind of
BIOS) and it would be handy for a flash utility to find the corresponding mtd
device.

It shouldn't be hard to add this when needed.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
