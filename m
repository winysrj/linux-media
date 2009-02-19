Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43037 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751921AbZBSMQ0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 07:16:26 -0500
Date: Thu, 19 Feb 2009 13:16:27 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Agustin <gatoguan-os@yahoo.com>
cc: Linux Arm Kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/4] soc-camera: camera host driver for i.MX3x SoCs
In-Reply-To: <900217.19195.qm@web32107.mail.mud.yahoo.com>
Message-ID: <Pine.LNX.4.64.0902191311530.5156@axis700.grange>
References: <900217.19195.qm@web32107.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Agustin,

On Thu, 19 Feb 2009, Agustin wrote:

> Hi Guennadi,
> ---- Mensaje original ----
> > De: Sascha Hauer <s.hauer@pengutronix.de>
> > On Wed, Feb 18, 2009 at 01:03:38AM +0100, Guennadi Liakhovetski wrote:
> > > From: Guennadi Liakhovetski 
> > > 
> > > Tested with 8 bit Bayer and 8 bit monochrome video.
> > > 
> > > Signed-off-by: Guennadi Liakhovetski 
> > > ---
> > 
> > Acked-by: Sascha Hauer 
> > for the platform part. I can't say much to the driver itself.
> > 
> > Sascha
> > 
> > > 
> > > This is how I expect this driver to appear in my pull request. So, please, 
> > > review, test heavily :-)
> 
> I want to test it but while applying to mxc-master branch I observed 
> that you use it on top of, at least, framebuffer stuff: #include 
> <mach/mx3fb.h>.

You probably mean the

[PATCH/FYI 3/4] soc-camera: board bindings for camera host driver for i.MX3x SoCs

patch, not the one you're replying to. And the "3/4" says "FYI", i.e., it 
is not yet for submission, only for reference.

> Should I apply fb patchset in order to make this one work? (Otherwise, I 
> can proceed with a minor merging effort.)

Well, the camera itself doesn't require the framebuffer. So, if you're not 
planning to display your video, you can decide for yourself - whether to 
apply fb patches or to merge camera patches without fb.

> I am already using your drivers in their original version, I can get 
> some new pictures with this one pretty soon.

Great!

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
