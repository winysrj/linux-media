Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:59138 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab2JOIDA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 04:03:00 -0400
Date: Mon, 15 Oct 2012 10:02:55 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Albert Wang <twang13@marvell.com>
cc: Jonathan Corbet <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Subject: RE: [PATCH 2/4] [media] marvell-ccic: core: add soc camera support
 on marvell-ccic mcam-core
In-Reply-To: <477F20668A386D41ADCC57781B1F7043083B80D9BC@SC-VEXCH1.marvell.com>
Message-ID: <Pine.LNX.4.64.1210150958170.19333@axis700.grange>
References: <1348840040-21390-1-git-send-email-twang13@marvell.com>
 <20120929134041.343c3d56@hpe.lwn.net> <Pine.LNX.4.64.1209300128020.20390@axis700.grange>
 <477F20668A386D41ADCC57781B1F7043083B80D9BC@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Albert

On Mon, 15 Oct 2012, Albert Wang wrote:

> Hi, Guennadi
> 
> >-----Original Message-----
> >From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
> >Sent: Sunday, 30 September, 2012 07:31
> >To: Jonathan Corbet
> >Cc: Albert Wang; linux-media@vger.kernel.org; Libin Yang
> >Subject: Re: [PATCH 2/4] [media] marvell-ccic: core: add soc camera support on
> >marvell-ccic mcam-core
> >
> >On Sat, 29 Sep 2012, Jonathan Corbet wrote:
> >
> >> On Fri, 28 Sep 2012 21:47:20 +0800
> >> Albert Wang <twang13@marvell.com> wrote:
> >>
> >> > This patch adds the support of Soc Camera on marvell-ccic mcam-core.
> >> > The Soc Camera mode does not compatible with current mode.
> >> > Only one mode can be used at one time.
> >> >
> >> > To use Soc Camera, CONFIG_VIDEO_MMP_SOC_CAMERA should be defined.
> >> > What's more, the platform driver should support Soc camera at the same time.
> >> >
> >> > Also add MIPI interface and dual CCICs support in Soc Camera mode.
> >>
> >> I'm glad this work is being done, but I have some high-level grumbles
> >> to start with.
> >>
> >> This patch is too big, and does several things. I think there needs to
> >> be one to add SOC support (but see below), one to add planar formats,
> >> one to add MIPI, one for the second CCIC, etc. That will make them all
> >> easier to review.
> >>
> >> The SOC camera stuff could maybe use a little more thought. Why does
> >> this driver *need* to be a SOC camera driver?
> >
> >It probably doesn't, but if the author wishes to do so - we can try to do this cleanly.
> >
> >> If that is truly
> >> necessary (or sufficiently beneficial), can we get to the point where
> >> that's the only mode?  I really dislike the two modes; we're
> >> essentially perpetuating the two-drivers concept in a #ifdef'd form;
> >> it would be good not to do that.
> >>
> >> If there is truly some reason why both modes need to exist, can we
> >> arrange things so that the core doesn't know the difference?  I'd like
> >> to see no new ifdefs there if possible, it already has way too many.
> >
> >A strong +1. Ideally we should identify common code, add soc-camera mode as a
> >separate file and re-use the common stuff.
> >
> 
> Now we are working on splitting the patches to smaller ones as you have suggested.

Very good to hear this!

> But today when we git pull the tree to 3.7.rc1, we found that all soc_camera drivers
> (include soc_camera.c) had been moved into: soc_camera/
> 
> So if that means our soc_camera support patches based on marvell-ccic are not reasonable?

I don't think so. Having soc-camera in a separate directory shouldn't make 
it impossible to use it from outside of that directory and, in fact, maybe 
you don't have to. I'm not sure what the best split would be for you, 
maybe put the soc-camera specific part in the soc-camera directory and the 
generic ccic code under the marvell-ccic directory? Or maybe you find more 
convenient to put everything under marvell-ccic, maybe you'll get some 
advise on this. In any case I don't think it changes much in the approach 
we think is best for your work.

Thanks
Guennadi

> But if we used another separate file to support soc_camera for marvell-ccic in soc_camera directory,
> I think we also back to the status months ago when I submitted the mmp_camera patch.
> 
> Like you have said, we can make patch to identify the common code of marvell-ccic firstly,
> then re-use the common stuff in the separate file in soc_camera directory.
> But we think maybe it looks a little weird and also tough.
> That means we must use some stuff in another parallel directory.
> 
> So do you have any constructive suggestion for this knotty situation?
> 
> Thank you very much!
> 
> 
> Thanks
> Albert Wang
> 86-21-61092656
> 
> >> That, I think, is how I'd like to go toward a cleaner, more
> >> reviewable, more maintainable solution.  Make sense?
> >
> >Definitely!
> >
> >Thanks
> >Guennadi
> >
> >> Thanks,
> >>
> >> jon
> >>
> >
> >---
> >Guennadi Liakhovetski, Ph.D.
> >Freelance Open-Source Software Developer http://www.open-technology.de/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
