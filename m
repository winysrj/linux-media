Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33474 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751090AbZKLHU5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2009 02:20:57 -0500
Date: Thu, 12 Nov 2009 08:21:13 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Neil Johnson <realdealneil@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Capturing video and still images using one driver
In-Reply-To: <3d7d5c150911111556h253099a4mbc5d65c7b796151d@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0911120818130.4072@axis700.grange>
References: <3d7d5c150911021621g72461dao1e66a654b574af5f@mail.gmail.com>
 <Pine.LNX.4.64.0911032250060.5059@axis700.grange>
 <3d7d5c150911031413i2a3c23a1j8cb136b721b75da1@mail.gmail.com>
 <3d7d5c150911111556h253099a4mbc5d65c7b796151d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(removed the deprecated video ML from CC)

On Wed, 11 Nov 2009, Neil Johnson wrote:

> Guennadi,
> 
> Your suggestions do work well, though my implementation is not ideal.
> However, I am now able to switch between high res capture and low res
> capture using S_FMT.  I made the switch to using user-ptr buffers in
> user space, and now I allocate both large still image buffers and
> smaller video buffers when my app starts.  Then, I switch from video
> to still image capture (always using streaming, not read()), and then
> switch back to video when needed.

You meqn you stop streaming in your application, requeue buffers of 
different size and restart capture?

> Unfortunately, I'm not a huge expert at making my code fit the
> video4linux model, so I've basically introduced some hacks that make
> it work for me.  I'll try to get my hackish code up to spec so that it
> will possibly be useful for others.

Yep, try to make it as good as possible and in any case send it in for 
others to have a look.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
