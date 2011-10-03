Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55921 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab1JCIdV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Oct 2011 04:33:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v2 2/2] v4l: Add v4l2 subdev driver for S5K6AAFX sensor
Date: Mon, 3 Oct 2011 10:33:24 +0200
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
References: <1316627107-18709-1-git-send-email-s.nawrocki@samsung.com> <4E86DAA7.4@gmail.com> <20111002072011.GJ6180@valkosipuli.localdomain>
In-Reply-To: <20111002072011.GJ6180@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110031033.25963.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester and Sakari,

On Sunday 02 October 2011 09:20:11 Sakari Ailus wrote:
> On Sat, Oct 01, 2011 at 11:17:27AM +0200, Sylwester Nawrocki wrote:
> > On 09/27/2011 10:55 PM, Sakari Ailus wrote:
> > > Sylwester Nawrocki wrote:
> > >> On 09/25/2011 12:08 PM, Sakari Ailus wrote:
> > >>> On Fri, Sep 23, 2011 at 12:12:58PM +0200, Sylwester Nawrocki wrote:
> > >>>> On 09/23/2011 12:02 AM, Sakari Ailus wrote:
> > >>>>> Hi Sylwester,
> > >>>>> On Wed, Sep 21, 2011 at 07:45:07PM +0200, Sylwester Nawrocki wrote:

[snip]

> > > I'm not sure if this makes it easier for the user space. The user space
> > > must know about such a think and aslo which parameters it applies to.
> > > I don't
> > 
> > Yes, I agree on this entirely.
> > 
> > > think this ocnforms to V4L2 either, but I might have misunderstood
> > > something.
> > 
> > If there is anything in the code not conforming to V4L2 please indicate
> > it clearly.
> 
> Ok, what the driver currently implements, does conform to V4L2. But getting
> advantage (which I'd like to argue might be irrelevant) using different
> presets would be challenging to implement while obeying the V4L2 spec.

That's why we probably need to extend the V4L2 spec :-)

"Snapshot" mode is currently ill-defined.

At the hardware level, the name is used to describe different concepts 
depending on the sensor. This can cover a wide range of features, from 
enabling external trigger to using different register sets. Some of those 
features (such as registers set) are even not restricted to 
preview/snapshot/capture modes and can be used for other purpose.

At the application level, capturing a snapshot image usually involve much more 
than just selecting a snapshot mode, especially when ISPs (either on the 
sensor side or on the host side) are involved.

Snapshot mode will be discussed in Prague. Given the complexity of the issue 
we won't solve it there, but I hope to at least gather a list of requirements 
and use cases (and if possible a list that everybody agrees on :-)). It would 
be nice if every person interested in the subject could prepare such a list 
beforehand, as we will have little time to discuss the topic.

> > >> Anyway, I've taken a closer look at what I need in the single user
> > >> configuration set data structure and reworked the driver quite
> > >> extensively. Should post that in the coming week, unless some
> > >> unexpected disasters occur;)
> > >> 
> > >> Do you see any problem in defining real still capture interface in V4L
> > >> ? It's probably just a small set of new controls, new capability,
> > >> plus multi-size buffer queue Guennadi has been working on. Some
> > >> devices will require explicitly switching between preview and capture
> > >> mode, and it may make difference if they are programmed in advance or
> > >> on demand.

For this specific use case, it's probably "just" that. If we take other use 
cases into account, it isn't. I don't think we should rush in API support for 
snapshot capture mode in V4L2 without a proper understanding of all (or most) 
use cases.

> > > I don't think V4L2 should have a still capture interface. Still capture
> > > is just one use case as viewfinder and video. V4L2 deals with frames,
> > > formats and parameters that are all generic and use case independent.
> > > Instead of use cases, we have independent configurable settings and
> > > that's the way I think it should stay.
> > > 
> > > If your hardware requires switching mode to "still" before taking a
> > > still image, then the driver should expose this functionality as such.
> > > I'd be
> > 
> > Yeah, of course this should work. But I don't quite see how would I
> > expose the "still"/"normal" switch control with existing API. Aren't you
> > going to blackball this as just another 'use case' ? :)
> 
> That's fine because it's implemented by the sensor already. My point is
> that we should only show this fact in V4L2 API as little as possible.

I agree with Sakari here. We need a high level snapshot capture API in 
userspace, something similar to (and not necessarily separate from) 
GstPhotography. The userspace components will of course need proper support 
from V4L2, but that doesn't mean the whole snapshot capture API must be 
implemented in V4L2. I see this more like a collection of V4L2 extensions 
(such as the multi-size buffer queue) that can be used to support snapshot 
capture in userspace.

> I remember Guennadi had sensors which provide something called "snapshot
> mode". A single boolean control to turn this on or off would suffice ---
> snapshot mode is something that's going to be discussed in the Multimedia
> summit if my memory serves me right.
> 
> This could be one option for this sensor as well but the implementation
> might not be quite optimal since you'd still need to switch the
> configuration.
>
> > In fact preview/still mode control seems to be a minimum needed to expose
> > full functionality of the S5K6AAFX device in V4L2 API. But I am not
> > really interested in "still" capture with this device ATM. The current
> > driver is more than enough :)
> > 
> > > really wary of e.g. exposing register configuration flipping to user
> > > space even if the driver can do that.
> > 
> > Nor do I intend to make such attempts in the future, neither there is
> > anything like this in my driver.
> 
> Ack.
> 
> > >> If the hardware (or it's firmware) supports something natively why
> > >> should we go for a less efficient SW emulated replacement? After all,
> > >> preview and capture mode seem pretty basic features that applications
> > >> will want to use.
> > > 
> > > I think it depends on an application. If your application only knows it
> > > wants to do "viewfinder" or "capture" then it might be V4L2 could be a
> > > too low level interface for that job.
> > 
> > Sorry, this is all not about the applications capabilities. Only about
> > the V4L2 API limitations in using the existing devices.
> > 
> > > I might suggest GSTphotography instead.
> > 
> > GstPhotography is not really impressive in its current state:
> > http://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-plugins-bad-
> > plugins/html/GstPhotography.html
> 
> I'm probably not the best person to comment on this, but do you think
> something is e.g. either missing or should be implemented differently?
> 
> > It still belongs to the Bad Plugins group, right ?
> 
> That's right.
> 
> > Although I am not an OpenMAX advocate, it seems top have a better defined
> > interface (chapter 8.9.1).
> > http://www.khronos.org/registry/omxil/specs/OpenMAX_IL_1_1_2_Specificatio
> > n.pdf

The GStreamer Bad Plugins are not necessarily of worse quality than the 
OpenMAX specification ;-) Please also remember that OMX is a userspace API, we 
need something at the userspace level as well.

> > >>> I would rather measure and attempt to optimise the register writes in
> > >>> the driver first before adding complexity to user space interface.
> > >> 
> > >> Yeah, I'm not planning to use the presets plainly for different user
> > >> configurations, just trying to design the driver so those may be
> > >> utilised for the device various operation modes.
> > >> 
> > >>> Or do the presets provide other advantages than just storing
> > >>> configurations?
> > >> 
> > >> The H/W requires different register sets for preview and capture. For
> > >> instance only in the capture mode the flash control is performed. So
> > >> it's important to know whether we start in preview or capture mode,
> > >> and these modes have distinct registers for resolution setup, etc. As
> > >> a side note, I'm not highly interested in supporting snapshot mode
> > >> with S5K6AAFX. The M-5MOLS sensor is a better target for this, for
> > >> instance.
> > > 
> > > As far as I understand, the M-5MOLS indeed needs to know it's capturing
> > > a still image. Raw non-smart sensors, however, don't even recognise
> > > such a concept.
> > 
> > Yes. Although the world is not all made of raw ("non-smart") sensor
> > + local SoC ISP configurations.
> 
> I intended to refer to that as an example only.

-- 
Regards,

Laurent Pinchart
