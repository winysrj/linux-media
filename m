Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43327 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754291AbZDQHvR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 03:51:17 -0400
Date: Fri, 17 Apr 2009 09:51:21 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [PATCH 0/5] soc-camera: convert to platform device
In-Reply-To: <aec7e5c30904170040p6ec1721aj6885ef16573cd484@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0904170950320.5119@axis700.grange>
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
 <aec7e5c30904170040p6ec1721aj6885ef16573cd484@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 17 Apr 2009, Magnus Damm wrote:

> Hi Guennadi,
> 
> On Wed, Apr 15, 2009 at 9:17 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > This patch series is a preparation for the v4l2-subdev conversion. Please,
> > review and test. My current patch-stack in the form of a
> > (manually-created) quilt-series is at
> > http://www.open-technology.de/download/20090415/ based on linux-next
> > history branch, commit ID in 0000-base file. Don't be surprised, that
> > patch-set also contains a few not directly related patches.
> 
> Testing on Migo-R board with 2.6.30-rc2-git-something and the
> following cherry-picked patches:
> 
> 0007-driver-core-fix-driver_match_device.patch
> 0033-soc-camera-host-driver-cleanup.patch
> 0034-soc-camera-remove-an-extra-device-generation-from-s.patch
> 0035-soc-camera-simplify-register-access-routines-in-mul.patch
> and part of 0036 (avoiding rejects, ap325 seems broken btw)

Have I broken it or is it unrelated?

> It compiles just fine, boots up allright, but I can't open /dev/video0 anymore.
> 
> It's still supposed to work with all drivers compiled-in, right?
> 
> I'll investigate a bit more and update to latest linux-2.6 git.

Ok, if you don't find the reason soon enough, you can just leave it and 
I'll look at it myself.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
