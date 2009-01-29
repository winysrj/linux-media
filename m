Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59951 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751651AbZA2Lw2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 06:52:28 -0500
Date: Thu, 29 Jan 2009 12:52:35 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Compiler warnings in pxa_camera.c
In-Reply-To: <200901291241.28756.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0901291247210.5474@axis700.grange>
References: <200901291029.27243.hverkuil@xs4all.nl>
 <Pine.LNX.4.64.0901291110100.5474@axis700.grange> <200901291241.28756.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 29 Jan 2009, Hans Verkuil wrote:

> On Thursday 29 January 2009 11:19:39 Guennadi Liakhovetski wrote:
> >
> > soc-camera drivers so far only include embedded platforms, and there you
> > most usually have to work with complete kernel sources, and, to be
> > honest, this backwards compatibility patching only adds work for me -
> > when trying to merge patches created with git against a complete kernel
> > git tree, because often so created patches don't apply cleanly (or at
> > all) because of the compatibility delta. And then this delta has to be
> > cleaned up by Mauro again before pushing upstream. Yes, Mauro does use
> > scripts for this, still, separating original patches from the
> > compatibility code can be non-trivial, I think, and, I guess, those
> > scripts do not manage it in 100% of cases - as we have seen with a recent
> > breakage exactly with these PXA register definitions.
> >
> > So, I would be perfectly happy if we find a way to only allow compilation
> > of soc-camera drivers against the "current" kernel, and remove all the
> > compatibility code from them.
> 
> No problem, I've modified it so that the daily build only compiles this 
> driver from 2.6.29 and up.

Great, thanks. Can we also set this for other soc-camera drivers and 
remove all backwards compatibility patches from them? I.e. keep them 
exactly like upstream?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
