Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34957 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753496Ab0DVJbM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Apr 2010 05:31:12 -0400
Date: Thu, 22 Apr 2010 11:31:10 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Valentin Longchamp <valentin.longchamp@epfl.ch>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] mt9t031: preserve output format on VIDIOC_S_CROP
In-Reply-To: <4BD01373.2040601@epfl.ch>
Message-ID: <Pine.LNX.4.64.1004221128550.4655@axis700.grange>
References: <Pine.LNX.4.64.1004141605110.9388@axis700.grange>
 <Pine.LNX.4.64.1004221048420.4655@axis700.grange> <4BD01373.2040601@epfl.ch>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 22 Apr 2010, Valentin Longchamp wrote:

> Guennadi Liakhovetski wrote:
> > On Wed, 14 Apr 2010, Guennadi Liakhovetski wrote:
> > 
> > > Interpretation of the V4L2 API specification, according to which the
> > > VIDIOC_S_CROP ioctl for capture devices shall set the input window and
> > > preserve the scales, thus possibly changing the output window, seems to be
> > > incorrect. Switch to using a more intuitive definition, i.e., to
> > > preserving the output format while changing scales.
> > > 
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > ---
> > > 
> > > Val, I do not have any mt9t031 hardware any more, could you, please, test
> > > this patch and verify, that it does indeed do, what's described above?
> > 
> > There hasn't been any replies to this, so, I presume, this patch cannot be
> > tested at present. Therefore I'm going to leave it out of my pull requests
> > until it gets tested somehow.
> 
> Sorry Guennadi, the testing is on my todo-list, but I am getting nearer to the
> end of my thesis and I really am very busy at the moment. I hope I can give it
> a spin on a mt9t031 in the coming weeks.

Np, we can push it out with the next development cycle, noone is 
complaining, so, noone actually has a problem with the present version 
either, I just would prefer to get it fixed, but it's not urgent.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
