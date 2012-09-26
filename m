Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58610 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab2IZJMY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 05:12:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	remi@remlab.net, daniel-gl@gmx.net, sylwester.nawrocki@gmail.com
Subject: Re: [RFC] Timestamps and V4L2
Date: Wed, 26 Sep 2012 11:13:01 +0200
Message-ID: <84293169.Vi1CrtjK0W@avalon>
In-Reply-To: <50621010.3070703@iki.fi>
References: <20120920202122.GA12025@valkosipuli.retiisi.org.uk> <201209251254.34483.hverkuil@xs4all.nl> <50621010.3070703@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday 25 September 2012 23:12:00 Sakari Ailus wrote:
> Hans Verkuil wrote:
> > On Tue 25 September 2012 12:48:01 Laurent Pinchart wrote:
> >> On Tuesday 25 September 2012 08:47:45 Hans Verkuil wrote:
> >>> On Tue September 25 2012 02:00:55 Laurent Pinchart wrote:
> >>> BTW, I think we should also fix the description of the timestamp in the
> >>> spec. Currently it says:
> >>> 
> >>> "For input streams this is the system time (as returned by the
> >>> gettimeofday() function) when the first data byte was captured. For
> >>> output streams the data will not be displayed before this time,
> >>> secondary to the nominal frame rate determined by the current video
> >>> standard in enqueued order. Applications can for example zero this field
> >>> to display frames as soon as possible. The driver stores the time at
> >>> which the first data byte was actually sent out in the timestamp field.
> >>> This permits applications to monitor the drift between the video and
> >>> system clock."
> >>> 
> >>> To my knowledge all capture drivers set the timestamp to the time the
> >>> *last* data byte was captured, not the first.
> >> 
> >> The uvcvideo driver uses the time the first image packet is received :-)
> >> Most other drivers use the time the last byte was *received*, not
> >> captured.
> >
> > Unless the hardware buffers more than a few lines there is very little
> > difference between the time the last byte was received and when it was
> > captured.
> > 
> > But you are correct, it is typically the time the last byte was received.
> > 
> > Should we signal this as well? First vs last byte? Or shall we
> > standardize?
> 
> My personal opinion would be to change the spec to say what almost every
> driver does: it's the timestamp from the moment the last pixel has been
> received. We have the frame sync event for telling when the frame starts
> btw. The same event could be used for signalling whenever a given line
> starts. I don't see frame end fitting to that quite as nicely but I
> guess it could be possible.

The uvcvideo driver can timestamp the buffers with the system time at which 
the first packet in the frame is received, but has no way to generate a frame 
start event: the frame start event should correspond to the time the frame 
starts, not to the time the first packet in the frame is received. That 
information isn't available to the driver.

> > BTW, the human mind is amazingly tolerant when it comes to A/V
> > synchronization. Audio can be up to 50 ms ahead of the video and up to I
> > believe 120 ms lagging behind the video before most people will notice.
> > So being off by one frame won't be noticable at all.
> 
> I wonder if this is what most DVD players do. What they do is not
> pretty. The difference could be more, though. ;-)

-- 
Regards,

Laurent Pinchart

