Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:41681 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab2IYKy7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 06:54:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] Timestamps and V4L2
Date: Tue, 25 Sep 2012 12:54:34 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	remi@remlab.net, daniel-gl@gmx.net, sylwester.nawrocki@gmail.com
References: <20120920202122.GA12025@valkosipuli.retiisi.org.uk> <201209250847.45104.hverkuil@xs4all.nl> <1581681.Un0gYsdTxg@avalon>
In-Reply-To: <1581681.Un0gYsdTxg@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209251254.34483.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 25 September 2012 12:48:01 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Tuesday 25 September 2012 08:47:45 Hans Verkuil wrote:
> > On Tue September 25 2012 02:00:55 Laurent Pinchart wrote:
> > BTW, I think we should also fix the description of the timestamp in the
> > spec. Currently it says:
> > 
> > "For input streams this is the system time (as returned by the
> > gettimeofday() function) when the first data byte was captured. For output
> > streams the data will not be displayed before this time, secondary to the
> > nominal frame rate determined by the current video standard in enqueued
> > order. Applications can for example zero this field to display frames as
> > soon as possible. The driver stores the time at which the first data byte
> > was actually sent out in the timestamp field. This permits applications to
> > monitor the drift between the video and system clock."
> > 
> > To my knowledge all capture drivers set the timestamp to the time the *last*
> > data byte was captured, not the first.
> 
> The uvcvideo driver uses the time the first image packet is received :-) Most 
> other drivers use the time the last byte was *received*, not captured.

Unless the hardware buffers more than a few lines there is very little
difference between the time the last byte was received and when it was captured.

But you are correct, it is typically the time the last byte was received.

Should we signal this as well? First vs last byte? Or shall we standardize?

BTW, the human mind is amazingly tolerant when it comes to A/V synchronization.
Audio can be up to 50 ms ahead of the video and up to I believe 120 ms lagging
behind the video before most people will notice. So being off by one frame won't
be noticable at all.

Regards,

	Hans

> That's 
> a very important difference, as it influences audio/video synchronization. 
> Providing the time at which the first byte was captured is better than the 
> time the last byte was captured in my opinion. Unfortunately when images are 
> transferred by DMA it's often impossible to get any meaningful timestamp.
> 
> > And there are no output drivers able to handle a non-zero timestamp. And the
> > output drivers also set the timestamp to the time the *last* data byte was
> > sent out.
> > 
> > I think the spec should be updated to reflect this.
> 
> 
