Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3206 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999Ab2IMU5X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 16:57:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFCv2 API PATCH 12/28] v4l2-core: Add new V4L2_CAP_MONOTONIC_TS capability.
Date: Thu, 13 Sep 2012 22:56:41 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com> <20120913203814.GK6834@valkosipuli.retiisi.org.uk> <10295113.chWiZVzcZs@avalon>
In-Reply-To: <10295113.chWiZVzcZs@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209132256.41941.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu September 13 2012 22:50:32 Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Thursday 13 September 2012 23:38:14 Sakari Ailus wrote:
> > On Fri, Sep 07, 2012 at 03:29:12PM +0200, Hans Verkuil wrote:
> > > From: Hans Verkuil <hans.verkuil@cisco.com>
> > > 
> > > Add a new flag that tells userspace that the monotonic clock is used
> > > for timestamps and update the documentation accordingly.
> > > 
> > > We decided on this new flag during the 2012 Media Workshop.
> > > 
> > > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > ---
> > > 
> > >  Documentation/DocBook/media/v4l/io.xml              |   10 +++++++---
> > >  Documentation/DocBook/media/v4l/vidioc-dqevent.xml  |    3 ++-
> > >  Documentation/DocBook/media/v4l/vidioc-querycap.xml |    7 +++++++
> > >  include/linux/videodev2.h                           |    1 +
> > >  4 files changed, 17 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/Documentation/DocBook/media/v4l/io.xml
> > > b/Documentation/DocBook/media/v4l/io.xml index 2dc39d8..b680d66 100644
> > > --- a/Documentation/DocBook/media/v4l/io.xml
> > > +++ b/Documentation/DocBook/media/v4l/io.xml
> > > @@ -582,10 +582,14 @@ applications when an output stream.</entry>
> > > 
> > >  	    <entry>struct timeval</entry>
> > >  	    <entry><structfield>timestamp</structfield></entry>
> > >  	    <entry></entry>
> > > 
> > > -	    <entry><para>For input streams this is the
> > > +	    <entry><para>This is either the
> > > 
> > >  system time (as returned by the <function>gettimeofday()</function>
> > > 
> > > -function) when the first data byte was captured. For output streams
> > > -the data will not be displayed before this time, secondary to the
> > > +function) or a monotonic timestamp (as returned by the
> > > +<function>clock_gettime(CLOCK_MONOTONIC, &amp;ts)</function> function).
> > > +A monotonic timestamp is used if the
> > > <constant>V4L2_CAP_MONOTONIC_TS</constant> +capability is set, otherwise
> > > the system time is used.
> > > +For input streams this is the timestamp when the first data byte was
> > > captured. +For output streams the data will not be displayed before this
> > > time, secondary to the
> > I have an alternative proposal.
> > 
> > The type of the desired timestamps depend on the use case, not the driver
> > used to capture the buffers. Thus we could also give the choice to the user
> > by means of e.g. a control.
> 
> Or a buffer flag. I will need something similar to select device-specific 
> timestamps.
> 
> However, for wall clock vs. monotonic clock, I don't think there's a reason to 
> let applications decide to use the wall clock. It would be a broken use case. 
> I don't think we should let applications decide in this case.

I agree.

> On the other hand, reporting a timespec instead of a timeval would be a good 
> idea. I'm tempted.

Microsecond precision seems more than sufficient to me for video frames. I see
no good reason for messing around with the v4l2_buffer struct just to get a
timespec in.

Regards,

	Hans
