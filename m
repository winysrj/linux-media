Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:14310 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757754Ab2INJWD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 05:22:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFCv2 API PATCH 12/28] v4l2-core: Add new V4L2_CAP_MONOTONIC_TS capability.
Date: Fri, 14 Sep 2012 11:21:56 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com> <201209132256.41941.hverkuil@xs4all.nl> <20120914090222.GM6834@valkosipuli.retiisi.org.uk>
In-Reply-To: <20120914090222.GM6834@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209141121.56362.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri 14 September 2012 11:02:22 Sakari Ailus wrote:
> On Thu, Sep 13, 2012 at 10:56:41PM +0200, Hans Verkuil wrote:
> > On Thu September 13 2012 22:50:32 Laurent Pinchart wrote:
> > > Hi Sakari,
> > > 
> > > On Thursday 13 September 2012 23:38:14 Sakari Ailus wrote:
> > > > On Fri, Sep 07, 2012 at 03:29:12PM +0200, Hans Verkuil wrote:
> > > > > From: Hans Verkuil <hans.verkuil@cisco.com>
> > > > > 
> > > > > Add a new flag that tells userspace that the monotonic clock is used
> > > > > for timestamps and update the documentation accordingly.
> > > > > 
> > > > > We decided on this new flag during the 2012 Media Workshop.
> > > > > 
> > > > > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > > > ---
> > > > > 
> > > > >  Documentation/DocBook/media/v4l/io.xml              |   10 +++++++---
> > > > >  Documentation/DocBook/media/v4l/vidioc-dqevent.xml  |    3 ++-
> > > > >  Documentation/DocBook/media/v4l/vidioc-querycap.xml |    7 +++++++
> > > > >  include/linux/videodev2.h                           |    1 +
> > > > >  4 files changed, 17 insertions(+), 4 deletions(-)
> > > > > 
> > > > > diff --git a/Documentation/DocBook/media/v4l/io.xml
> > > > > b/Documentation/DocBook/media/v4l/io.xml index 2dc39d8..b680d66 100644
> > > > > --- a/Documentation/DocBook/media/v4l/io.xml
> > > > > +++ b/Documentation/DocBook/media/v4l/io.xml
> > > > > @@ -582,10 +582,14 @@ applications when an output stream.</entry>
> > > > > 
> > > > >  	    <entry>struct timeval</entry>
> > > > >  	    <entry><structfield>timestamp</structfield></entry>
> > > > >  	    <entry></entry>
> > > > > 
> > > > > -	    <entry><para>For input streams this is the
> > > > > +	    <entry><para>This is either the
> > > > > 
> > > > >  system time (as returned by the <function>gettimeofday()</function>
> > > > > 
> > > > > -function) when the first data byte was captured. For output streams
> > > > > -the data will not be displayed before this time, secondary to the
> > > > > +function) or a monotonic timestamp (as returned by the
> > > > > +<function>clock_gettime(CLOCK_MONOTONIC, &amp;ts)</function> function).
> > > > > +A monotonic timestamp is used if the
> > > > > <constant>V4L2_CAP_MONOTONIC_TS</constant> +capability is set, otherwise
> > > > > the system time is used.
> > > > > +For input streams this is the timestamp when the first data byte was
> > > > > captured. +For output streams the data will not be displayed before this
> > > > > time, secondary to the
> > > > I have an alternative proposal.
> > > > 
> > > > The type of the desired timestamps depend on the use case, not the driver
> > > > used to capture the buffers. Thus we could also give the choice to the user
> > > > by means of e.g. a control.
> > > 
> > > Or a buffer flag. I will need something similar to select device-specific 
> > > timestamps.
> > > 
> > > However, for wall clock vs. monotonic clock, I don't think there's a reason to 
> > > let applications decide to use the wall clock. It would be a broken use case. 
> > > I don't think we should let applications decide in this case.
> > 
> > I agree.
> 
> How about the raw monotonic clock then? You can also tell clock_gettime()
> what kind of timestamp you're interested in. It's also true monotonic
> timestamps are being used elsewhere, so the selection should apply there as
> well.

ALSA only has wallclock time and monotonic clock, not raw monotonic.

The important thing right now is that apps can tell that a driver uses a
monotonic clock. In the future we might want to refine that, but such efforts
should be done together with ALSA.

In other words, let's not add stuff that does not have any users.

Regards,

	Hans

> 
> > > On the other hand, reporting a timespec instead of a timeval would be a good 
> > > idea. I'm tempted.
> > 
> > Microsecond precision seems more than sufficient to me for video frames. I see
> > no good reason for messing around with the v4l2_buffer struct just to get a
> > timespec in.
> 
> The extra precision could be confusing for some existing users.
> 
> Another thing, however not related to this patch, is that the spec mentions
> the timestamp is taken when the "first data byte is captured". In practice
> many (if not most) drivers produce the timestamp when the buffer is ready.
> The reason is that some hardware simply does not produce interrupts at when
> the reception of the frame starts. What kind of timestamps should be used in
> that case? The frame start event can be used to get information on when the
> frame starts.
> 
> Regards,
> 
> 
