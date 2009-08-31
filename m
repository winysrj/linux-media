Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41285 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753414AbZHaJV7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 05:21:59 -0400
Date: Mon, 31 Aug 2009 11:22:07 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <j.w.r.degoede@hhs.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] Pixel format definition on the "image" bus
In-Reply-To: <2b7b07f52f0ab6fa4d3f1cacc19bf31f.squirrel@webmail.xs4all.nl>
Message-ID: <Pine.LNX.4.64.0908311113520.4189@axis700.grange>
References: <Pine.LNX.4.64.0908261452460.7670@axis700.grange>   
 <200908270851.27073.hverkuil@xs4all.nl>    <Pine.LNX.4.64.0908270857230.4808@axis700.grange>
    <6d6c955a28219f061dd31af4e0473415.squirrel@webmail.xs4all.nl>   
 <Pine.LNX.4.64.0908271017280.4808@axis700.grange>
 <2b7b07f52f0ab6fa4d3f1cacc19bf31f.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 27 Aug 2009, Hans Verkuil wrote:

> It's my opinion that we have to be careful in trying to be too
> intelligent. There is simply too much variation in hardware out there to
> ever hope to be able to do that.

An opinion has been expressed, that my proposed API was too complex, that, 
for example, the .packing parameter was not needed. Just to give an 
argument, why it is indeed needed, OMAP 3 can pack raw 10, 12, (and 14?) 
bit data in two ways in RAM, so, a sensor would use the .packing parameter 
to specify how its data has to be arranged in RAM to produce a specific 
fourcc code.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
