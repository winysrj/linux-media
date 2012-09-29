Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:56248 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab2I2XbD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Sep 2012 19:31:03 -0400
Date: Sun, 30 Sep 2012 01:30:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Jonathan Corbet <corbet@lwn.net>
cc: Albert Wang <twang13@marvell.com>, linux-media@vger.kernel.org,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [PATCH 2/4] [media] marvell-ccic: core: add soc camera support
 on marvell-ccic mcam-core
In-Reply-To: <20120929134041.343c3d56@hpe.lwn.net>
Message-ID: <Pine.LNX.4.64.1209300128020.20390@axis700.grange>
References: <1348840040-21390-1-git-send-email-twang13@marvell.com>
 <20120929134041.343c3d56@hpe.lwn.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 29 Sep 2012, Jonathan Corbet wrote:

> On Fri, 28 Sep 2012 21:47:20 +0800
> Albert Wang <twang13@marvell.com> wrote:
> 
> > This patch adds the support of Soc Camera on marvell-ccic mcam-core.
> > The Soc Camera mode does not compatible with current mode.
> > Only one mode can be used at one time.
> > 
> > To use Soc Camera, CONFIG_VIDEO_MMP_SOC_CAMERA should be defined.
> > What's more, the platform driver should support Soc camera at the same time.
> > 
> > Also add MIPI interface and dual CCICs support in Soc Camera mode.
> 
> I'm glad this work is being done, but I have some high-level grumbles
> to start with.
> 
> This patch is too big, and does several things. I think there needs to
> be one to add SOC support (but see below), one to add planar formats,
> one to add MIPI, one for the second CCIC, etc. That will make them all
> easier to review.
> 
> The SOC camera stuff could maybe use a little more thought. Why does
> this driver *need* to be a SOC camera driver?

It probably doesn't, but if the author wishes to do so - we can try to do 
this cleanly.

> If that is truly
> necessary (or sufficiently beneficial), can we get to the point where
> that's the only mode?  I really dislike the two modes; we're
> essentially perpetuating the two-drivers concept in a #ifdef'd form; it
> would be good not to do that.
> 
> If there is truly some reason why both modes need to exist, can we
> arrange things so that the core doesn't know the difference?  I'd like
> to see no new ifdefs there if possible, it already has way too many.

A strong +1. Ideally we should identify common code, add soc-camera mode 
as a separate file and re-use the common stuff.

> That, I think, is how I'd like to go toward a cleaner, more reviewable,
> more maintainable solution.  Make sense?

Definitely!

Thanks
Guennadi

> Thanks,
> 
> jon
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
