Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42941 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751374AbZHaKuu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 06:50:50 -0400
Date: Mon, 31 Aug 2009 12:51:00 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <j.w.r.degoede@hhs.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] Pixel format definition on the "image" bus
In-Reply-To: <dbf33f17b45c024b40d0bfb90c63511a.squirrel@webmail.xs4all.nl>
Message-ID: <Pine.LNX.4.64.0908311246040.4189@axis700.grange>
References: <Pine.LNX.4.64.0908261452460.7670@axis700.grange>   
 <200908270851.27073.hverkuil@xs4all.nl>    <Pine.LNX.4.64.0908270857230.4808@axis700.grange>
    <6d6c955a28219f061dd31af4e0473415.squirrel@webmail.xs4all.nl>   
 <Pine.LNX.4.64.0908271017280.4808@axis700.grange>   
 <2b7b07f52f0ab6fa4d3f1cacc19bf31f.squirrel@webmail.xs4all.nl>   
 <Pine.LNX.4.64.0908311113520.4189@axis700.grange>   
 <3e6334da11a2c64cce09bf694dc3b29a.squirrel@webmail.xs4all.nl>   
 <Pine.LNX.4.64.0908311149400.4189@axis700.grange>
 <dbf33f17b45c024b40d0bfb90c63511a.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 31 Aug 2009, Hans Verkuil wrote:

> > Yes, in a way. We agree, that we describe the data from the sensor on the
> > image bus with a unique ID (data format code enum), right? Now, what does
> > this ID tell us? It should tell us what we can get from this format in
> > RAM, right?
> 
> No, it does not. That is only true for the bridge which is actually doing
> the DMA. So calling VIDIOC_S_FMT in the application will indeed request a
> specific memory layout of the image. But you cannot attach that same
> meaning when configuring a sensor or video decoder/encoder device. That
> has no knowledge whatsoever about memory layouts.
> 
> In principle sensor devices (to stay with that example) support certain
> bus configurations and for each configuration they can transfer an image
> in certain formats (the format being the order in which image data is
> transported over the data bus). These formats can be completely unique to
> that sensor, or (much more likely) be one of a set of fairly common
> formats. If unique formats are encountered it is likely to be some sort of
> compressed image. Raw images are unlikely to be unique.
> 
> I do not believe that you can in general autonegotiate this. But there are
> many cases where you can do a decent job of it. To do that the bridge
> needs a mapping of memory layouts (the pixelformat specified with S_FMT)
> and the image format coming in on the data pins (lets call it datapin
> format). Then it can query the sensor which datapin formats it supports
> and select the appropriate one.
> 
> This approach makes the correct split between memory and datapin formats.
> Mixing them is a really bad idea.

I think you just explained in other words exactly what I was trying to 
say. By "It should tell us what we can get from this format in RAM" I 
meant exactly the mapping that you describe above. And further

> > Since codes are unique, this information should be globally
> > available. That's why I'm decoding format codes into (RAM) format
> > descriptors centrally in v4l2-imagebus.c. And then hosts can use those
> > descriptors to decide which packing to use to obtain the required fourcc
> > in RAM.

What I call "decoding" is what you call "mapping."

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
