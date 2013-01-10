Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51134 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308Ab3AJAZp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2013 19:25:45 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [PATCH v1.2 1/4] v4l: Define video buffer flags for timestamp types
Date: Thu, 10 Jan 2013 01:27:23 +0100
Message-ID: <37718646.Wp4FcFoKX0@avalon>
In-Reply-To: <20121202205351.GK31879@valkosipuli.retiisi.org.uk>
References: <1353098995-1319-1-git-send-email-sakari.ailus@iki.fi> <5788992.si3u8AaYMi@avalon> <20121202205351.GK31879@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Sunday 02 December 2012 22:53:51 Sakari Ailus wrote:
> On Tue, Nov 27, 2012 at 05:04:29PM +0100, Laurent Pinchart wrote:
> > On Thursday 22 November 2012 01:59:00 Sakari Ailus wrote:
> > > On Wed, Nov 21, 2012 at 11:53:02PM +0100, Hans Verkuil wrote:
> ,,,
> 
> > > > What do you think?
> > > 
> > > Fine for me. Sylwester also brought memory-to-memory devices (and
> > > memory-to-memory processing whether the device is classified as such in
> > > API or not) to my attention. For those devices it likely wouldn't matter
> > > at all what's the system time when the frame is processed since the
> > > frame wasn't captured at that time anyway.
> > > 
> > > In those cases it might makes sense to use timestamp that e.g. comes
> > > from the compressed stream, or pass encoder timestamps that are going to
> > > be part of the compressed stream. I think MPEG-related use cases were
> > > briefly mentioned in the timestamp discussion earlier.
> > 
> > When uncompressing a stream you will get the MPEG embedded timestamp on
> > the capture side. The timestamp returned to userspace at QBUF time on the
> > output side will still be unused. I don't really see a use case for
> > returning the timestamp at which the frame is expected to be processed by
> > the codec, so we could just make the field reserved for future use in
> > that case.
> 
> Is the timestamp embedded in the compressed data itself in that case, or
> where?

Yes, it's embedded in the compressed stream.

> Could this be codec-dependent?

Of course, it would be too easy otherwise :-)

> > > > > The driver stores the time at which
> > > > > +	    the first data byte was actually sent out in the
> > > > > +	    <structfield>timestamp</structfield> field.
> > > > 
> > > > Same problem as with the capture time: does the timestamp refer to the
> > > > first or last byte that's sent out? I think all output drivers set it
> > > > to the time of the last byte (== when the DMA of the frame is
> > > > finished).
> > > 
> > > I haven't actually even seen a capture driver that would do otherwise,
> > > but that could be just me not knowing many enough. :-) Would we actually
> > > break something if we changed the definition to say that this is the
> > > timestamp taken when the frame is done?
> > 
> > For software timestamps we could do that, but for hardware timestamps the
> > exact timestamping time may vary.
> 
> Should we then do this for the timestamps that are obtained from the system
> clock? We also haven't defined other kinds of tiemstamps yet.

That sounds good to me.

> For timestamp types that are hardware-dependent we could have exceptions.

-- 
Regards,

Laurent Pinchart

