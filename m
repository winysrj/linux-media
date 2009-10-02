Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:52590 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001AbZJBXKA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Oct 2009 19:10:00 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1MtrGF-0002CN-KB
	for linux-media@vger.kernel.org; Sat, 03 Oct 2009 01:10:03 +0200
Received: from proxysb02.ext.ti.com ([192.94.94.106])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 03 Oct 2009 01:10:03 +0200
Received: from rtivy by proxysb02.ext.ti.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 03 Oct 2009 01:10:03 +0200
To: linux-media@vger.kernel.org
From: Robert Tivy <rtivy@ti.com>
Subject: Re: [RFC] Global video buffers pool
Date: Fri, 2 Oct 2009 22:57:29 +0000 (UTC)
Message-ID: <loom.20091003T005632-488@post.gmane.org>
References: <200909161746.39754.laurent.pinchart@ideasonboard.com> <D019E777779A4345963526A1797F28D409E78C5B57@NOK-EUMSG-02.mgdnok.nokia.com> <200909282354.25563.laurent.pinchart@ideasonboard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart <laurent.pinchart <at> ideasonboard.com> writes:

> 
> Hi Stefan,
> 
> On Monday 28 September 2009 16:04:58 Stefan.Kost <at> nokia.com wrote:
> > hi,
> > 
> > >-----Original Message-----
> > >From: ext Laurent Pinchart [mailto:laurent.pinchart <at> ideasonboard.com]
> > >Sent: 16 September, 2009 18:47
> > >To: linux-media <at> vger.kernel.org; Hans Verkuil; Sakari Ailus;
> > >Cohen David.A (Nokia-D/Helsinki); Koskipaa Antti
> > >(Nokia-D/Helsinki); Zutshi Vimarsh (Nokia-D/Helsinki); Kost
> > >Stefan (Nokia-D/Helsinki)
> > >Subject: [RFC] Global video buffers pool
> > >
> > > Hi everybody,
> > >
> > > I didn't want to miss this year's pretty flourishing RFC
> > > season, so here's another one about a global video buffers pool.
> > 
> > Sorry for ther very late reply.
> 
> No worries, better late than never.
> 
> > I have been thinking about the problem on a bit broader scale and see the
> > need for something more kernel wide. E.g. there is some work done from 
intel
> > for graphics:
> > http://keithp.com/blogs/gem_update/
> > 
> > and this is not so much embedded even. If there buffer pools are
> > v4l2specific then we need to make all those other subsystems like xvideo,
> > opengl, dsp-bridges become v4l2 media controllers.
> 
> The global video buffers pool topic has been discussed during the v4l2 mini-
> summit at Portland last week, and we all agreed that it needs more research.
> 
> The idea of having pools at the media controller level has been dropped in 
> favor of a kernel-wide video buffers pool. Whether we can make the buffers 
> pool not v4l2-specific still needs to be tested. As you have pointed out, we 
> currently have a GPU memory manager in the kernel, and being able to 
interact 
> with it would be very interesting if we want to DMA video data to OpenGL 
> texture buffers for instance. I'm not sure if that would be possible though, 
> as the GPU and the video acquisition hardware might have different memory 
> requirements, at least in the general case. I will contact the GEM guys at 
> Intel to discuss the topic.
> 
> If we can't share the buffers between the GPU and the rest of the system, we 
> could at least create a V4L2 wrapper on top of the DSP bridge core (which 
will 
> require a major cleanup/restructuring), making it possible to share video 
> buffers between the ISP and the DSP.
> 


TI has been providing this sort of contiguous buffer support for quite a few 
years now.  TI provides a SW package named LinuxUtils, and it contains a 
module named CMEM (stand for Contiguous MEMory manager).

Latest LinuxUtils release, contains cdocs of CMEM:
http://software-
dl.ti.com/dsps/dsps_public_sw/sdo_sb/targetcontent/linuxutils/2_24_03/exports/l
inuxutils_2_24_03.tar.gz

And the background/usage article here:
http://tiexpressdsp.com/index.php/CMEM_Overview

CMEM solves lots of the same sorts of things that the driver described in this 
thread does.  However, it doesn't integrate into other drivers, and it's 
accessed through the CMEM user interface.  Also, CMEM alleviates some of the 
issues raised in this thread since it uses memory not known to the kernel 
(user "carves out" a chunk by reducing kernel memory through u-boot mem= 
param), which IMO can be both good and bad (good - alleviates 
locking/unavailable memory issues, bad - doesn't cooperate with the kernel in 
getting memory, requiring user intervention).

Regards,

Robert Tivy
MGTS
Systems Software
Texas Instruments, Santa Barbara



