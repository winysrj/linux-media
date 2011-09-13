Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42368 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab1IMKbT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 06:31:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC] New class for low level sensors controls?
Date: Tue, 13 Sep 2011 12:31:17 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	s.nawrocki@samsung.com, hechtb@googlemail.com
References: <20110906113653.GF1393@valkosipuli.localdomain> <20110906122226.GH1393@valkosipuli.localdomain> <Pine.LNX.4.64.1109081409380.31156@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1109081409380.31156@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109131231.18178.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Thursday 08 September 2011 14:35:54 Guennadi Liakhovetski wrote:
> On Tue, 6 Sep 2011, Sakari Ailus wrote:
> > On Tue, Sep 06, 2011 at 01:41:11PM +0200, Laurent Pinchart wrote:
> > > On Tuesday 06 September 2011 13:36:53 Sakari Ailus wrote:

[snip]

> > > > Typically such sensors are not controlled by general purpose
> > > > applications but e.g. require a camera control algorithm framework
> > > > in user space. This needs to be implemented in libv4l for general
> > > > purpose applications to work properly on this kind of hardware.
> > > > 
> > > > These sensors expose controls such as
> > > > 
> > > > - Per-component gain controls. Red, blue, green (blue) and green
> > > > (red) gains.
> > > > 
> > > > - Link frequency. The frequency of the data link from the sensor to
> > > > the bridge.
> > > > 
> > > > - Horizontal and vertical blanking.
> > > 
> > > Other controls often found in bayer sensors are black level
> > > compensation and test pattern.
> 
> May I suggest a couple more:
> 
> (1) snapshot mode (I really badly want this one, please;-))

What do you mean exactly by snapshot mode ? Is that just external trigger, or 
does it cover more features than that ?

> (2) flash controls (yes, I know we already have V4L2_CTRL_CLASS_FLASH, I
>     just have the impression, that these controls are mostly meant for
>     either pure software implementations, or for external controllers, I
>     think it should also be possible to have them exported by a normal
>     sensor driver, but wasn't really sure. So, wanted to point out to this
>     possibility once again.)

As Sakari told you in his answer, we can add new controls to the flash class.

> (3) AEC / AGC regions

This will get tricky. I'm tempted to propose the idea of v4l2_rect controls 
and control arrays again :-)

> (4) stereo (3D anyone?;)) - no, don't think we need it now...

-- 
Regards,

Laurent Pinchart
