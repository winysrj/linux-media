Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.pmeerw.net ([87.118.82.44]:50415 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757587AbaGWJ6Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 05:58:25 -0400
Date: Wed, 23 Jul 2014 11:58:24 +0200 (CEST)
From: Peter Meerwald <pmeerw@pmeerw.net>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, sylwester.nawrocki@gmail.com
Subject: Re: Media bus pixel code and pixel format enumeration (was: )
In-Reply-To: <20140723084703.GS16460@valkosipuli.retiisi.org.uk>
Message-ID: <alpine.DEB.2.01.1407231142420.6322@pmeerw.net>
References: <alpine.DEB.2.01.1407211419320.18226@pmeerw.net> <20140723084703.GS16460@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sakari,

thank you for your reply (and finding a nice subject for this)!

> On Mon, Jul 21, 2014 at 02:35:39PM +0200, Peter Meerwald wrote:
> > how can I query the supported pixel format(s) of a sensor connected via 
> > media-ctl and exposed via /dev/videoX
> > 
> > there is 
> > VIDIOC_ENUM_FMT (which fails)
> > and
> > VIDIOC_SUBDEV_ENUM_MBUS_CODE (which works, but on a subdev, not on 
> > /dev/videoX)
> > 
> > v4l2_subdev_video_ops has .enum_mbus_fmt (this is SoC camera stuff?)
> > 
> > v4l2_subdev_pad_ops has .enum_mbus_code
> > 
> > 
> > the application just sees /dev/videoX and cannot do VIDIOC_ENUM_FMT
> > what is the logic behind this?
> > shouldn't a compabatibility layer be added turning VIDIOC_ENUM_FMT into 
> > VIDIOC_SUBDEV_ENUM_MBUS_CODE?
> 
> The issue has been that enumerating should not change the state of the
> device. Within a single device node things are fine, but in this case the
> media bus pixel code at the other end of the link affects the result of the
> enumeration.

good to know this has been considered before
 
> There hasn't been really a solution for this in the past; what has been
> discussed as possible options have been (at least to my recollection) but
> none has been implemented:
> 
> 1) Use the media bux pixel code from the other end of the link. As there is
> no common file handle to share the state with, the link configuration and
> setting the media bus pixel code are necessary state changes before the
> enumeration can take place, and the two must not be changed during the it.
> This breaks the separation between configuration and enumeration. (There has
> been a patch to the omap3isp driver which essentially did this long time ago
> AFAIR.)
> 
> 2) Use a reserved field in struct v4l2_fmtdesc to tell the pixel code. This
> way enumeration can stay separate from configuration and is probably easier
> for the user space as well. I vote for this: it's clean, simple and gets the
> job done.

I not sure if I fully understand your suggestion

let's assume the following setup: 
sensor (subdev8) <-> OMAP3 CCDC (subdev2) <-> output (video2)

userspace would query VIDIOC_ENUM_FMT on video2; what is the expected 
answer? and how would it be obtained?

for me it would be good enough if first configuration via media-ctl is 
done, and ENUM_FMT video2 would just return at least one FMT that can be 
set

so configuration would be fixed, I'm not interested in all possible FMTs

regards, p.

-- 

Peter Meerwald
+43-664-2444418 (mobile)
