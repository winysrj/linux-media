Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39813 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219Ab2I0Kyx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 06:54:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	remi@remlab.net, daniel-gl@gmx.net, sylwester.nawrocki@gmail.com
Subject: Re: [RFC] Timestamps and V4L2
Date: Thu, 27 Sep 2012 12:55:31 +0200
Message-ID: <2042961.UTB0pRMYu0@avalon>
In-Reply-To: <506354C2.1030805@iki.fi>
References: <20120920202122.GA12025@valkosipuli.retiisi.org.uk> <84293169.Vi1CrtjK0W@avalon> <506354C2.1030805@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Wednesday 26 September 2012 22:17:22 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> > On Tuesday 25 September 2012 23:12:00 Sakari Ailus wrote:
> >> Hans Verkuil wrote:
> >>> On Tue 25 September 2012 12:48:01 Laurent Pinchart wrote:
> >>>> On Tuesday 25 September 2012 08:47:45 Hans Verkuil wrote:
> >>>>> On Tue September 25 2012 02:00:55 Laurent Pinchart wrote:
> >>>>> BTW, I think we should also fix the description of the timestamp in
> >>>>> the spec. Currently it says:
> >>>>> 
> >>>>> "For input streams this is the system time (as returned by the
> >>>>> gettimeofday() function) when the first data byte was captured. For
> >>>>> output streams the data will not be displayed before this time,
> >>>>> secondary to the nominal frame rate determined by the current video
> >>>>> standard in enqueued order. Applications can for example zero this
> >>>>> field to display frames as soon as possible. The driver stores the
> >>>>> time at which the first data byte was actually sent out in the
> >>>>> timestamp field. This permits applications to monitor the drift
> >>>>> between the video and system clock."
> >>>>> 
> >>>>> To my knowledge all capture drivers set the timestamp to the time the
> >>>>> *last* data byte was captured, not the first.
> >>>> 
> >>>> The uvcvideo driver uses the time the first image packet is received
> >>>> :-)
> >>>> Most other drivers use the time the last byte was *received*, not
> >>>> captured.
> >>> 
> >>> Unless the hardware buffers more than a few lines there is very little
> >>> difference between the time the last byte was received and when it was
> >>> captured.
> >>> 
> >>> But you are correct, it is typically the time the last byte was
> >>> received.
> >>> 
> >>> Should we signal this as well? First vs last byte? Or shall we
> >>> standardize?
> >> 
> >> My personal opinion would be to change the spec to say what almost every
> >> driver does: it's the timestamp from the moment the last pixel has been
> >> received. We have the frame sync event for telling when the frame starts
> >> btw. The same event could be used for signalling whenever a given line
> >> starts. I don't see frame end fitting to that quite as nicely but I
> >> guess it could be possible.
> > 
> > The uvcvideo driver can timestamp the buffers with the system time at
> > which the first packet in the frame is received, but has no way to
> > generate a frame start event: the frame start event should correspond to
> > the time the frame starts, not to the time the first packet in the frame
> > is received. That information isn't available to the driver.
> 
> Aren't the two about equal, apart from the possible delays caused by the
> USB bus?

Apart from the possible delays caused by buffering on the device side, by 
transfers and by interrupt latency. For some applications that can matter. 
That's why we need support for device timestamps in the first place.

> The spec says about the frame sync event that it's "Triggered immediately
> when the reception of a frame has begun."

Then the OMAP3 ISP driver got it wrong, as we send the event when the hardware 
detects a vertical sync pulse :-)

We will never be able to implement the exact same behaviour for all devices. 
USB drivers typically don't receive VS events from the devices but can 
generate an event when they receive the first packet of a frame. On the other 
hand, DMA-based devices (PCI, SoC) usually only get notified of the end of the 
transfer (as opposed to the beginning of the transfer), and often (?) support 
generating an interrupt on VS detection. I think the best we can do is 
document in the spec that those different behaviours exist. We could add a 
capability flag to inform applications of the exact behaviour, but I don't 
think that's really worth it.

-- 
Regards,

Laurent Pinchart

