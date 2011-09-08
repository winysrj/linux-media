Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39960 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400Ab1IHJvI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2011 05:51:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFC] New class for low level sensors controls?
Date: Thu, 8 Sep 2011 11:51:06 +0200
Cc: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	hechtb@googlemail.com, g.liakhovetski@gmx.de
References: <20110906113653.GF1393@valkosipuli.localdomain> <201109061341.11991.laurent.pinchart@ideasonboard.com> <20110906122226.GH1393@valkosipuli.localdomain>
In-Reply-To: <20110906122226.GH1393@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109081151.06667.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday 06 September 2011 14:22:27 Sakari Ailus wrote:
> On Tue, Sep 06, 2011 at 01:41:11PM +0200, Laurent Pinchart wrote:
> > On Tuesday 06 September 2011 13:36:53 Sakari Ailus wrote:
> > > Hi all,
> > > 
> > > We are beginning to have raw bayer image sensor drivers in the
> > > mainline. Typically such sensors are not controlled by general purpose
> > > applications but e.g. require a camera control algorithm framework in
> > > user space. This needs to be implemented in libv4l for general purpose
> > > applications to work properly on this kind of hardware.
> > > 
> > > These sensors expose controls such as
> > > 
> > > - Per-component gain controls. Red, blue, green (blue) and green (red)
> > > 
> > >   gains.
> > > 
> > > - Link frequency. The frequency of the data link from the sensor to the
> > > 
> > >   bridge.
> > > 
> > > - Horizontal and vertical blanking.
> > 
> > Other controls often found in bayer sensors are black level compensation
> > and test pattern.
> > 
> > > None of these controls are suitable for use of general purpose
> > > applications (let alone the end user!) but for the camera control
> > > algorithms.
> > > 
> > > We have a control class called V4L2_CTRL_CLASS_CAMERA for camera
> > > controls. However, the controls in this class are relatively high
> > > level controls which are suitable for end user. The algorithms in the
> > > libv4l or a webcam could implement many of these controls whereas I
> > > see that only V4L2_CID_EXPOSURE_ABSOLUTE might be implemented by raw
> > > bayer sensors.
> > > 
> > > My question is: would it make sense to create a new class of controls
> > > for the low level sensor controls in a similar fashion we have a
> > > control class for the flash controls?
> > 
> > I think it would, but I'm not sure how we should name that class.
> > V4L2_CTRL_CLASS_SENSOR is tempting, but many of the controls that will be
> > found there (digital gains, black leverl compensation, test pattern, ...)
> > can also be found in ISPs or other hardware blocks.
> 
> I don't think ISPs typically implement test patterns. Do you know of any?

Not from the top of my head, but I don't think it would be too uncommon.

> Should we separate controls which clearly apply to sensors only from the
> rest?
> 
> For sensors only:
> 
> - Analog gain(s)
> - Horizontal and vertical blanking
> - Link frequency
> - Test pattern
> 
> The following can be implemented also on ISPs:
> 
> - Per-component gains
> - Black level compensation
> 
> Do we have more to add to the list?

Not right now.

> If we keep the two the same class, I could propose the following names:
> 
> V4L2_CTRL_CLASS_LL_CAMERA (for low level camera)
> V4L2_CTRL_CLASS_SOURCE
> V4L2_CTRL_CLASS_IMAGE_SOURCE
> 
> The last one would be a good name for the sensor control class, as far as I
> understand some are using tuners with the OMAP 3 ISP these days. For the
> another one, I propose V4L2_CTRL_CLASS_ISP.

The issue with ISP is that pretty much any digital-based control can fall into 
that class.

Maybe we should group controls by what they do, instead of the kind of 
component that implements them ?

-- 
Regards,

Laurent Pinchart
