Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50286 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752717AbZHaRxI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 13:53:08 -0400
Date: Mon, 31 Aug 2009 19:53:19 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Muralidharan Karicheri <m-karicheri2@ti.com>,
	Laurent Pinchart <laurent.pinchart@skynet.be>
Subject: Re: RFC: bus configuration setup for sub-devices
In-Reply-To: <200908311942.20926.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0908311950310.4189@axis700.grange>
References: <200908291631.13696.hverkuil@xs4all.nl> <4A9BF22A.1000608@maxwell.research.nokia.com>
 <200908311942.20926.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 31 Aug 2009, Hans Verkuil wrote:

> The image format is something that should be setup by a separate API. Guennadi
> has a proposal for that which is being discussed. Although I wonder whether
> these two APIs should perhaps be combined into one. Don't know yet.
> 
> In particular I wonder whether the bus width shouldn't become part of the image
> format API rather than the bus configuration.

I'd be happy to offer free unlimited accommodation to the bus 
configuration API in my v4l2-imagebus.c and share the imgbus namespace 
with it:-) Indeed, it also looks logical to me for the two to share the 
file, the namespace, and, probably, some code too.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
