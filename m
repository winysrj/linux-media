Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40399 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab2KNN3X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 08:29:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [RFC/PATCH] v4l: Add V4L2_CID_FLASH_HW_STROBE_MODE control
Date: Wed, 14 Nov 2012 14:30:19 +0100
Message-ID: <1912245.UolWV1if6X@avalon>
In-Reply-To: <20121113215346.GT25623@valkosipuli.retiisi.org.uk>
References: <1323115006-4385-1-git-send-email-snjw23@gmail.com> <5087AF0B.4030208@samsung.com> <20121113215346.GT25623@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday 13 November 2012 23:53:46 Sakari Ailus wrote:
> On Wed, Oct 24, 2012 at 11:04:11AM +0200, Sylwester Nawrocki wrote:
> > On 10/23/2012 10:07 PM, Sakari Ailus wrote:
> > > On Tue, Oct 16, 2012 at 11:45:59PM +0200, Sylwester Nawrocki wrote:
> > >> On 10/14/2012 08:30 PM, Sakari Ailus wrote:
> > >>> Currently the flash control reference states that "The V4L2 flash
> > >>> controls are intended to provide generic access to flash controller
> > >>> devices. Flash controller devices are typically used in digital
> > >>> cameras".
> > >>> 
> > >>> Whether or not higher level controls should be part of the same class
> > >>> is a valid question. The controls intended to expose certain frames
> > >>> with flash are quite different from those used to control the low-
> > >>> level flash chip: the user is fully responsible for timing and the
> > >>> flash sequence.
> > >>> 
> > >>> For higher level controls that could be implemented using the
> > >>> low-level controls for the end user, the user would likely prefer to
> > >>> say things like "please give me a frame exposed with flash". Since the
> > >>> timing is no longer implemented by the user, the user would need to
> > >>> know which frames have been exposed and how, at least in a general
> > >>> case. Getting around this could involve configuring the sensor before
> > >>> starting streaming. Perhaps this is an assumption we could accept now,
> > >>> before we have proper means for passing frame-related parameters to
> > >>> user space.
> > >> 
> > >> Yes, right. This auto strobe control seems to be a higher level one,
> > >> since we have a firmware program that is taking care of some things
> > >> that normally would be done through the existing Flash class controls
> > >> by a user space application/library.
> > >> 
> > >> I'm not really sure if we need a new class. It's even hard to name it.
> > >> I don't see such an auto strobe control as a high level one, from an
> > >> end application POV. It's more like the existing controls are low
> > >> level.
> > > 
> > > After thinking about it awhile, an alternative I see to this is to put
> > > it to the camera class. It's got other high level controls as well,
> > > those related to e.g. AF. I have to admit I'm not certain which one
> > > would be a better choice in the long run. I'm leaning towards the
> > > camera class, though.
> >
> > At first I thought it might be fine to put this control in the camera
> > class. But didn't we agree we classify controls by functionality, not by
> > where they are used ?
> > Since we already have a Flash controller functionality class it seems to
> > me more correct, or less wrong, to put V4L2_CID_FLASH_STROBE_AUTO there.
> > 
> > In an example configuration, where there is a Flash controller subdev and
> > the Flash controller is strobed in hardware by a camera sensor module, we
> > would have some Flash functionality control at the camera sensor subdev
> > and the Flash subdev. Let's focus on the camera subdev for a moment.
> > It would have V4L2_CID_FLASH_LED_MODE - to switch between Flash and Torch
> > mode, and V4L2_CID_FLASH_STROBE_AUTO - to determine the flash strobing
> > behaviour. It would look fishy to have one of these controls in the Camera
> > class and the other in the Flash class. I would find it hard to explain
> > to someone new learning about v4l2.
> 
> Good points. The flash mode control is still used even if the flash timing
> would be handles by the sensor silently.
> 
> I'm fine with putting it to the flash class.

I agree with that as well. We should update the flash control class 
documentation to explain that flash controls apply to both flash controller 
devices and to devices that control the flash controller such as sensors (with 
a better wording than that of course :-)).

-- 
Regards,

Laurent Pinchart

