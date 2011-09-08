Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:55959 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932673Ab1IHNWH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2011 09:22:07 -0400
Date: Thu, 8 Sep 2011 16:21:57 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	hechtb@googlemail.com
Subject: Re: [RFC] New class for low level sensors controls?
Message-ID: <20110908132157.GD1724@valkosipuli.localdomain>
References: <20110906113653.GF1393@valkosipuli.localdomain>
 <201109061341.11991.laurent.pinchart@ideasonboard.com>
 <20110906122226.GH1393@valkosipuli.localdomain>
 <Pine.LNX.4.64.1109081409380.31156@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1109081409380.31156@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 08, 2011 at 02:35:54PM +0200, Guennadi Liakhovetski wrote:
> On Tue, 6 Sep 2011, Sakari Ailus wrote:
> 
> > On Tue, Sep 06, 2011 at 01:41:11PM +0200, Laurent Pinchart wrote:
> > > Hi Sakari,
> > > 
> > > On Tuesday 06 September 2011 13:36:53 Sakari Ailus wrote:
> > > > Hi all,
> > > > 
> > > > We are beginning to have raw bayer image sensor drivers in the mainline.
> 
> Well, we've been "beginning" since several years now;-) But why only 
> Bayer? Don't we want to have the same controls available on sensors, 
> sending processed  YUV / RGB data, or for those, capable of both Bayer and 
> processed?

I agree. Many smart sensors just don't offer those controls, at least not
for the purpose of using host side white balance algorithm, so on smart
sensors those typically are already covered.

My wording was bad; what I meant to say was that that these controls are not
standardised.

> > > > Typically such sensors are not controlled by general purpose applications
> > > > but e.g. require a camera control algorithm framework in user space. This
> > > > needs to be implemented in libv4l for general purpose applications to work
> > > > properly on this kind of hardware.
> > > > 
> > > > These sensors expose controls such as
> > > > 
> > > > - Per-component gain controls. Red, blue, green (blue) and green (red)
> > > >   gains.
> > > >
> > > > - Link frequency. The frequency of the data link from the sensor to the
> > > >   bridge.
> > > > 
> > > > - Horizontal and vertical blanking.
> > > 
> > > Other controls often found in bayer sensors are black level compensation and 
> > > test pattern.
> 
> May I suggest a couple more:
> 
> (1) snapshot mode (I really badly want this one, please;-))

Sounds good.

> (2) flash controls (yes, I know we already have V4L2_CTRL_CLASS_FLASH, I 
>     just have the impression, that these controls are mostly meant for 
>     either pure software implementations, or for external controllers, I 
>     think it should also be possible to have them exported by a normal 
>     sensor driver, but wasn't really sure. So, wanted to point out to this 
>     possibility once again.)

There was a lengthy discussion during the review process. Do you see that
something would be missing from the current interface?

I vaguely remember that you had a sensor that expected to be controlled by
the flash controller considering the flash timing, rather than the other way
around.

> (3) AEC / AGC regions

This might get tricky. I wonder how we could eventually standardise these
ones.

> (4) stereo (3D anyone?;)) - no, don't think we need it now...

I wonder what is needed to support this on V4L2. It might also depend on how
the hardware will look like.

> > > > None of these controls are suitable for use of general purpose applications
> > > > (let alone the end user!) but for the camera control algorithms.
> > > > 
> > > > We have a control class called V4L2_CTRL_CLASS_CAMERA for camera controls.
> > > > However, the controls in this class are relatively high level controls
> > > > which are suitable for end user. The algorithms in the libv4l or a webcam
> > > > could implement many of these controls whereas I see that only
> > > > V4L2_CID_EXPOSURE_ABSOLUTE might be implemented by raw bayer sensors.
> > > > 
> > > > My question is: would it make sense to create a new class of controls for
> > > > the low level sensor controls in a similar fashion we have a control class
> > > > for the flash controls?
> > > 
> > > I think it would, but I'm not sure how we should name that class. 
> > > V4L2_CTRL_CLASS_SENSOR is tempting, but many of the controls that will be 
> > > found there (digital gains, black leverl compensation, test pattern, ...) can 
> > > also be found in ISPs or other hardware blocks.
> > 
> > I don't think ISPs typically implement test patterns. Do you know of any?
> 
> Yes, i.MX31.

Good to know that.

But you already know I'm with Laurent in believing that the controls should
be classified based on what they do, not where they are implemented. :-)

> > Should we separate controls which clearly apply to sensors only from the
> > rest?
> > 
> > For sensors only:
> > 
> > - Analog gain(s)
> > - Horizontal and vertical blanking
> > - Link frequency
> > - Test pattern
> > 
> > The following can be implemented also on ISPs:
> > 
> > - Per-component gains
> > - Black level compensation
> > 
> > Do we have more to add to the list?
> > 
> > If we keep the two the same class, I could propose the following names:
> > 
> > V4L2_CTRL_CLASS_LL_CAMERA (for low level camera)
> > V4L2_CTRL_CLASS_SOURCE
> > V4L2_CTRL_CLASS_IMAGE_SOURCE
> > 
> > The last one would be a good name for the sensor control class, as far as I
> > understand some are using tuners with the OMAP 3 ISP these days. For the
> > another one, I propose V4L2_CTRL_CLASS_ISP.
> > 
> > Better names are always welcome. :-)
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
