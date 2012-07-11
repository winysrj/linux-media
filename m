Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:43315 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757087Ab2GKKSG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 06:18:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH 1/2] media: Add mem2mem deinterlacing driver.
Date: Wed, 11 Jul 2012 12:17:52 +0200
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	mchehab@infradead.org, kernel@pengutronix.de,
	linux@arm.linux.org.uk
References: <1341996904-22893-1-git-send-email-javier.martin@vista-silicon.com> <201207111145.51858.hverkuil@xs4all.nl> <CACKLOr1xgjuGp-jshCaCBZwG4pbWsBSt9Cq9jUdd3PGjpHiXEQ@mail.gmail.com>
In-Reply-To: <CACKLOr1xgjuGp-jshCaCBZwG4pbWsBSt9Cq9jUdd3PGjpHiXEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207111217.52973.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 11 July 2012 12:02:48 javier Martin wrote:
> Hi Hans,
> thank you for your comments.
> 
> On 11 July 2012 11:45, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > Hi Javier!
> >
> > Thanks for the patch.
> >
> > On Wed 11 July 2012 10:55:03 Javier Martin wrote:
> >> Some video decoders such as tvp5150 provide separate
> >> video fields (V4L2_FIELD_SEQ_TB). This driver uses
> >> dmaengine to convert this format to V4L2_FIELD_INTERLACED_TB
> >> (weaving) or V4L2_FIELD_NONE (line doubling)
> >
> > Which field is used for the line doubling? Top or bottom? Or is each field
> > doubled, thus doubling the framerate?
> 
> No, just top field is used.
> I don't know if it's worth defining a new field format for doubling fields.

Probably not, but just make sure it is clearly documented.

> > I also recommend adding SEQ_BT/INTERLACED_BT support: NTSC transmits the bottom
> > field first, so it is useful to have support for that.
> 
> Adding that is quite easy but I cannot test it.
> Maybe someone could add it later?

It shouldn't be too hard to test: make the top field red and the bottom field blue
and check if the resulting image is correct.

Regards,

	Hans
