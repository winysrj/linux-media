Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:47080 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab1EZOpS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 10:45:18 -0400
Date: Thu, 26 May 2011 17:45:12 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	David Rusling <david.rusling@linaro.org>
Subject: Re: [GIT PATCH FOR 2.6.40] uvcvideo patches
Message-ID: <20110526144512.GB3547@valkosipuli.localdomain>
References: <201105150948.24956.laurent.pinchart@ideasonboard.com>
 <4DDD95AF.4010004@redhat.com>
 <201105261054.59914.laurent.pinchart@ideasonboard.com>
 <201105261120.41282.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105261120.41282.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Arnd and others,

On Thu, May 26, 2011 at 11:20:41AM +0200, Arnd Bergmann wrote:
> On Thursday 26 May 2011, Laurent Pinchart wrote:
> > On Thursday 26 May 2011 01:50:07 Mauro Carvalho Chehab wrote:
> > > Em 25-05-2011 20:43, Laurent Pinchart escreveu:
> > > > Issues arise when devices have floating point registers. And yes, that
> > > > happens, I've learnt today about an I2C sensor with floating point
> > > > registers (in this specific case it should probably be put in the broken
> > > > design category, but it exists :-)).
> > > 
> > > Huh! Yeah, an I2C sensor with FP registers sound weird. We need more
> > > details in order to address those.
> > 
> > Fortunately for the sensor I'm talking about most of those registers are read-
> > only and contain large values that can be handled as integers, so all we need 
> > to do is convert the 32-bit IEEE float value into an integer. Other hardware 
> > might require more complex FP handling.
> 
> As an additional remark here, most architectures can handle float in the
> kernel in some way, but they all do it differently, so it's basically
> impossible to do in a cross-architecture device driver.

Yeah, I noticed this also. Luckily, usually no other operations are needed
on floating point numbers than converting them to integers.

> > > I'm all about showing the industry in with direction we would like it to
> > > go. We want that all Linux-supported architectures/sub-architectures
> > > support inter-core communications in kernelspace, in a more efficient way
> > > that it would happen if such communication would happen in userspace.
> > 
> > I agree with that. My concern is about things like
> > 
> > "Standardizing on the OpenMax media libraries and the GStreamer framework is 
> > the direction that Linaro is going." (David Rusling, Linaro CTO, quoted on 
> > lwn.net)
> > 
> > We need to address this now, otherwise it will be too late.
> 
> Absolutely agreed. OpenMAX needs to die as an interface abstraction layer.
> 
> IIRC, the last time we discussed this in Linaro, the outcome was basically
> that we want to have an OpenMAX compatible library on top of V4L, so that the
> Linaro members can have a checkmark in their product specs that lists them
> as compatible, but we wouldn't do anything hardware specific in there, or
> advocate the use of OpenMAX over v4l2 or gstreamer.

I strongly favour GStreamer below OpenMAX rather than V4L2. Naturally the
GStreamer source plugins do use V4L2 where applicable.

Much of the high level functionality in cameras that applications are
interested in (for example) is best implemented in GStreamer rather than
V4L2 which is quite low level interface in some cases. While some closed
source components will likely remain, the software stack is still primarily
Open Source software. The closed components are well isolated and
replaceable where they exist; essentially this means individual GStreamer
plugins.

Using GStreamer also would have the benefit that in practice most of the
code using V4L2 would be Open Source as well, not to mention fostering
development as people work on common software components rather than
everyone having their own, as in various OpenMAX implementations.

I wonder if vendors really are looking to provide new designs supporting
OpenMAX while NOT using V4L2, with the possible exception of the OMAP 5.
But, there's a project to develop a V4L2 driver for the OMAP 4 ISS which
hopefully would support OMAP 5 as well. Of course, this direction of
development must be supported where we can.

I think the goal should be that OpenMAX provides no useful functionality at
all. It should be just a legacy interface layer for applications dependent
on it. All the functionality should be implemented in V4L2 drivers and
GStreamer below OpenMAX.

Just my 5 euro cents.

Cheers,

-- 
Sakari Ailus
sakari dot ailus at iki dot fi
