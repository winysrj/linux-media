Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58039 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754744Ab3AWMJv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 07:09:51 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Txz9Y-0001BQ-8x
	for linux-media@vger.kernel.org; Wed, 23 Jan 2013 13:10:04 +0100
Received: from 81-236-238-187-no38.tbcn.telia.com ([81.236.238.187])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2013 13:10:04 +0100
Received: from richardson.leao by 81-236-238-187-no38.tbcn.telia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2013 13:10:04 +0100
To: linux-media@vger.kernel.org
From: Richardson Leao <richardson.leao@neuro.ufrn.br>
Subject: Re: hacking MT9P031 for i.mx
Date: Tue, 22 Jan 2013 01:41:25 +0000 (UTC)
Message-ID: <loom.20130122T023430-993@post.gmane.org>
References: <ade8080d-dbbf-4b60-804c-333d7340c01e@googlegroups.com> <4301383.IPfSC38GGz@avalon> <1350043843.3730.32.camel@mars> <2180583.3hl5tPmpSx@avalon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 Laurent Pinchart <laurent.pinchart <at> ideasonboard.com> writes:

> 
> On Friday 12 October 2012 14:10:43 Christoph Fritz wrote:
> > On Mon, 2012-07-02 at 14:48 +0200, Laurent Pinchart wrote:
> > > On Thursday 28 June 2012 21:41:16 Chris MacGregor wrote:
> > > > > Where did you get the Aptina board code patch from ?
> > > >  
> > > >  From here: https://github.com/Aptina/BeagleBoard-xM
> > > 
> > > That's definitely outdated, the code is based on a very old OMAP3 ISP
> > > driver that was more or less broken by design. Nowadays anything other
> > > than the mainline version isn't supported by the community.
> > 
> > Is there a current (kernel ~3.6) git tree which shows how to add mt9p031
> > to platform code?
> 
> Yes, at 
> http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp-
> sensors-board
> 
> > I'm also curious if it's possible to glue mt9p031 to a freescale i.mx35
> > platform. As far as I can see,
> > drivers/media/platform/soc_camera/mx3_camera.c would need v4l2_subdev
> > support?
> 


Dear Laurent,

sorry to bother you with this but I am stuck now for a couple of weeks trying to
make the LI-5M03 camera to work on the bb xm rev c. I am trying to build a
system to track neurons under a microscope. at the moment, I have the kernel
3.7.3 installed w the mt9p03 driver (I believe that it is a version that you
made) compiled as a module and ubuntu 12.10. The module loads fine, no complains
but I do not have /dev/mediaX or dev/videoX or any /dev/v4lXXX

I wonder if there are any tricks to have the device properly loaded. My linux
kernel and rootfs came from here:

http://www.eewiki.net/display/linuxonarm/BeagleBoard#BeagleBoard-LinuxBuildScript%3A

thanks immensely for your help!

richardson

