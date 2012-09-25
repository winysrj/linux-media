Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57997 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab2IYLIk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 07:08:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	remi@remlab.net, daniel-gl@gmx.net, sylwester.nawrocki@gmail.com
Subject: Re: [RFC] Timestamps and V4L2
Date: Tue, 25 Sep 2012 13:09:16 +0200
Message-ID: <15868105.EeGOpqSRKh@avalon>
In-Reply-To: <201209251254.34483.hverkuil@xs4all.nl>
References: <20120920202122.GA12025@valkosipuli.retiisi.org.uk> <1581681.Un0gYsdTxg@avalon> <201209251254.34483.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tuesday 25 September 2012 12:54:34 Hans Verkuil wrote:
> On Tue 25 September 2012 12:48:01 Laurent Pinchart wrote:
> > On Tuesday 25 September 2012 08:47:45 Hans Verkuil wrote:
> > > On Tue September 25 2012 02:00:55 Laurent Pinchart wrote:
> > > BTW, I think we should also fix the description of the timestamp in the
> > > spec. Currently it says:
> > > 
> > > "For input streams this is the system time (as returned by the
> > > gettimeofday() function) when the first data byte was captured. For
> > > output streams the data will not be displayed before this time,
> > > secondary to the nominal frame rate determined by the current video
> > > standard in enqueued order. Applications can for example zero this field
> > > to display frames as soon as possible. The driver stores the time at
> > > which the first data byte was actually sent out in the timestamp field.
> > > This permits applications to monitor the drift between the video and
> > > system clock."
> > > 
> > > To my knowledge all capture drivers set the timestamp to the time the
> > > *last* data byte was captured, not the first.
> > 
> > The uvcvideo driver uses the time the first image packet is received :-)
> > Most other drivers use the time the last byte was *received*, not
> > captured.
>
> Unless the hardware buffers more than a few lines there is very little
> difference between the time the last byte was received and when it was
> captured.

It won't differ much, but if we want to change the spec to reflect the 
reality, then we should be as precise as possible.
 
> But you are correct, it is typically the time the last byte was received.
> 
> Should we signal this as well? First vs last byte? Or shall we standardize?

Good question. On one hand forcing drivers to report the timestamp of the last 
captured byte when they can report the first is a step back, on the other hand 
I'm not sure if it would be worth it to report what the device does exactly. 
This could all fit in a couple of new clock-related ioctls though. I wasn't a 
big fan of ioctls instead of a control for clock source selection, but if we 
start to shove more information in there ioctls begin to make sense.

> BTW, the human mind is amazingly tolerant when it comes to A/V
> synchronization. Audio can be up to 50 ms ahead of the video and up to I
> believe 120 ms lagging behind the video before most people will notice. So
> being off by one frame won't be noticable at all.

-- 
Regards,

Laurent Pinchart

