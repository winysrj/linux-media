Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:37511 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760689AbZFQNbX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 09:31:23 -0400
Date: Wed, 17 Jun 2009 06:31:25 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Darius Augulis <augulis.darius@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] adding support for setting bus parameters in sub device
In-Reply-To: <Pine.LNX.4.64.0906171043120.4218@axis700.grange>
Message-ID: <Pine.LNX.4.58.0906170626240.32713@shell2.speakeasy.net>
References: <52243.62.70.2.252.1245227586.squirrel@webmail.xs4all.nl>
 <Pine.LNX.4.64.0906171043120.4218@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 17 Jun 2009, Guennadi Liakhovetski wrote:
> On Wed, 17 Jun 2009, Hans Verkuil wrote:
> > It is my strong opinion that while autonegotiation is easy to use, it is
> > not a wise choice to make. Filling in a single struct with the bus
> > settings to use for each board-subdev combination (usually there is only
> > one) is simple, straight-forward and unambiguous. And I really don't see
> > why that should take much time at all. And I consider it a very good point
> > that the programmer is forced to think about this for a bit.
>
> Ok, my opinion is, that we should keep autonegotiation, but if you like,
> we can print a BIG-FAT-WARNING if both polarities are supported and no
> platform preference is set.
>
> I think, we've heard all opinions, unless someone would like to add
> something? Would it be fair to ask Mauro to make a decision? Or we can
> just count votes (which I would obviously prefer), but I'll accept Mauro's
> decision too.

There is a similar situation in the networking code, where there is a
driver for a PHY and another driver for a MAC, much like a sensor and
bridge.  phylib will find the common subset of the supported modes between
the MAC and the detected PHY and use that to configure aneg advertisement
settings.
