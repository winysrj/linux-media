Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:56660 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab1IMO0H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 10:26:07 -0400
Date: Tue, 13 Sep 2011 16:26:03 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	s.nawrocki@samsung.com, hechtb@googlemail.com
Subject: Re: [RFC] New class for low level sensors controls?
In-Reply-To: <201109131231.18178.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1109131618310.17902@axis700.grange>
References: <20110906113653.GF1393@valkosipuli.localdomain>
 <20110906122226.GH1393@valkosipuli.localdomain> <Pine.LNX.4.64.1109081409380.31156@axis700.grange>
 <201109131231.18178.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 13 Sep 2011, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Thursday 08 September 2011 14:35:54 Guennadi Liakhovetski wrote:
> > On Tue, 6 Sep 2011, Sakari Ailus wrote:
> > > On Tue, Sep 06, 2011 at 01:41:11PM +0200, Laurent Pinchart wrote:
> > > > On Tuesday 06 September 2011 13:36:53 Sakari Ailus wrote:
> 
> [snip]
> 
> > > > > Typically such sensors are not controlled by general purpose
> > > > > applications but e.g. require a camera control algorithm framework
> > > > > in user space. This needs to be implemented in libv4l for general
> > > > > purpose applications to work properly on this kind of hardware.
> > > > > 
> > > > > These sensors expose controls such as
> > > > > 
> > > > > - Per-component gain controls. Red, blue, green (blue) and green
> > > > > (red) gains.
> > > > > 
> > > > > - Link frequency. The frequency of the data link from the sensor to
> > > > > the bridge.
> > > > > 
> > > > > - Horizontal and vertical blanking.
> > > > 
> > > > Other controls often found in bayer sensors are black level
> > > > compensation and test pattern.
> > 
> > May I suggest a couple more:
> > 
> > (1) snapshot mode (I really badly want this one, please;-))
> 
> What do you mean exactly by snapshot mode ? Is that just external trigger, or 
> does it cover more features than that ?

I mean flipping the "snapshot" bit in the respective sensor configuration 
register. There are variants, of course. On some sensors there's just one 
such bit and all it does is enable the flash strobe. On others it also 
switches the configuration registers to immediately start recording a 
different frame size. On some other sensors, I think, there are more than 
2 sets of such configurations, then you need more than one control to 
switch between them. On yet other sensors you can program, how many frames 
you want to take in this mode (before switching back or before halting). I 
think, as a minimum we would expect from this control: switch flash strobe 
on & switch to the snapshot frame size, driver implementation details 
depend on the hardware capabilities, of course.

Thanks
Guennadi

> 
> > (2) flash controls (yes, I know we already have V4L2_CTRL_CLASS_FLASH, I
> >     just have the impression, that these controls are mostly meant for
> >     either pure software implementations, or for external controllers, I
> >     think it should also be possible to have them exported by a normal
> >     sensor driver, but wasn't really sure. So, wanted to point out to this
> >     possibility once again.)
> 
> As Sakari told you in his answer, we can add new controls to the flash class.
> 
> > (3) AEC / AGC regions
> 
> This will get tricky. I'm tempted to propose the idea of v4l2_rect controls 
> and control arrays again :-)
> 
> > (4) stereo (3D anyone?;)) - no, don't think we need it now...
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
