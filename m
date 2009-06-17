Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57923 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932855AbZFQIq6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 04:46:58 -0400
Date: Wed, 17 Jun 2009 10:46:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Magnus Damm <magnus.damm@gmail.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Darius Augulis <augulis.darius@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] adding support for setting bus parameters in sub device
In-Reply-To: <52243.62.70.2.252.1245227586.squirrel@webmail.xs4all.nl>
Message-ID: <Pine.LNX.4.64.0906171043120.4218@axis700.grange>
References: <52243.62.70.2.252.1245227586.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 17 Jun 2009, Hans Verkuil wrote:

> It is my strong opinion that while autonegotiation is easy to use, it is
> not a wise choice to make. Filling in a single struct with the bus
> settings to use for each board-subdev combination (usually there is only
> one) is simple, straight-forward and unambiguous. And I really don't see
> why that should take much time at all. And I consider it a very good point
> that the programmer is forced to think about this for a bit.

Ok, my opinion is, that we should keep autonegotiation, but if you like, 
we can print a BIG-FAT-WARNING if both polarities are supported and no 
platform preference is set.

I think, we've heard all opinions, unless someone would like to add 
something? Would it be fair to ask Mauro to make a decision? Or we can 
just count votes (which I would obviously prefer), but I'll accept Mauro's 
decision too.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
