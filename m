Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54740 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754609Ab2JOT7L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 15:59:11 -0400
Date: Mon, 15 Oct 2012 22:59:06 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Chris MacGregor <chris@cybermato.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl, remi@remlab.net,
	daniel-gl@gmx.net, sylwester.nawrocki@gmail.com
Subject: Re: [RFC] Timestamps and V4L2
Message-ID: <20121015195906.GG21261@valkosipuli.retiisi.org.uk>
References: <20120920202122.GA12025@valkosipuli.retiisi.org.uk>
 <20121015160549.GE21261@valkosipuli.retiisi.org.uk>
 <2316067.OFTCziv4Z5@avalon>
 <507C5BC4.7060700@cybermato.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507C5BC4.7060700@cybermato.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chris,

On Mon, Oct 15, 2012 at 11:53:56AM -0700, Chris MacGregor wrote:
> On 10/15/2012 11:45 AM, Laurent Pinchart wrote:
> >Hi Sakari,
> >
> >On Monday 15 October 2012 19:05:49 Sakari Ailus wrote:
> >>Hi all,
> >>
> >>As a summar from the discussion, I think we have reached the following
> >>conclusion. Please say if you agree or disagree with what's below. :-)
> >>
> >>- The drivers will be moved to use monotonic timestamps for video buffers.
> >>- The user space will learn about the type of the timestamp through buffer
> >>flags.
> >>- The timestamp source may be made selectable in the future, but buffer
> >>flags won't be the means for this, primarily since they're not available on
> >>subdevs. Possible way to do this include a new V4L2 control or a new IOCTL.
> >That's my understanding as well. For the concept,
> >
> >Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> I wasn't able to participate in the discussion that led to this, but
> I'd like to suggest and request now that an explicit requirement (of
> whatever scheme is selected) be that a userspace app have a
> reasonable and straightforward way to translate the timestamps to
> real wall-clock time, ideally with enough precision to allow
> synchronization of cameras across multiple computers.
> 
> In the systems I work on, for instance, we are recording real-world
> biological processes, some of which vary based on the time of day,
> and it is important to know when a given frame was captured so that
> information can be stored with the raw frame and the data derived
> from it. For many such purposes, an accuracy measured in multiple
> seconds (or even minutes) is fine.
> 
> However, when we are using multiple cameras on multiple computers
> (e.g., two or more BeagleBoard xM's, each with a camera connected),
> we would want to synchronize with an accuracy of less than 1 frame
> time - e.g. 10 ms or less.

I think you have two use cases actually: knowing when an image has been
taken, and synchronisation of images from multiple sources. The first one is
easy: you just call clock_gettime() for the realtime clock. The precision
will certainly be enough.

For the latter the realtime clock fits poorly to begin with: it jumps around
e.g. when the daylight saving time changes.

I think what I'd do is this: figure out the difference between the monotonic
clocks of your systems and use that as basis for synchronisation. I wonder
if there are existing solutions for this based e.g. on the NTP.

The pace of the monotonic clocks on different systems is the same as the
real-time ones; the same NTP adjustments are done to the monotonic clock as
well. As an added bonus you also won't be affected by daylight saving time
or someone setting the clock manually.

The conversion of the two clocks requires the knowledge of the values of
kernel internal variables, so performing the conversion in user space later
on is not an option.

Alternatively you could just call clock_gettime() after every DQBUF call,
but that's indeed less precise than if the driver would get the timestamp
for you.

How would this work for you?

Best regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
