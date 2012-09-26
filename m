Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41934 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab2IZLhr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 07:37:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: RFC: use of timestamp/sequence in v4l2_buffer
Date: Wed, 26 Sep 2012 13:38:24 +0200
Message-ID: <1837406.v5M1NO1NMK@avalon>
In-Reply-To: <20120913184448.GJ6834@valkosipuli.retiisi.org.uk>
References: <201209041238.07000.hverkuil@xs4all.nl> <20120913184448.GJ6834@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Thursday 13 September 2012 21:44:48 Sakari Ailus wrote:
> On Tue, Sep 04, 2012 at 12:38:06PM +0200, Hans Verkuil wrote:
> > Hi all,
> > 
> > During the Media Workshop last week we discussed how the timestamp and
> > sequence fields in struct v4l2_buffer should be used.
> > 
> > While trying to document the exact behavior I realized that there are a
> > few missing pieces.
> > 
> > Open questions with regards to the sequence field:
> > 
> > 1) Should the first frame that was captured or displayed after starting
> > streaming for the first time always start with sequence index 0? In my
> > opinion it should.
> 
> I agree.

Agreed.

> > 2) Should the sequence counter be reset to 0 after a STREAMOFF? Or should
> > it only be reset to 0 after REQBUFS/CREATE_BUFS is called?
> 
> Definitely not after CREATE_BUFS. Streaming may be ongoing when the IOCTL is
> called, and this will cause a great deal of trouble. I'd propose resetting
> it to zero at streamon (or streamoff) time.

Agreed.

> > 3) Should the sequence counter behave differently for mem2mem devices?
> > With the current definition both the capture and display sides of a
> > mem2mem device just have their own independent sequence counter.

They need to be independent, as one frame can be encoded/decoded to several 
frames (or the other way around).

> > 4) If frames are skipped, should the sequence counter skip as well? In my
> > opinion it shouldn't.
> 
> Do you mean skipping incrementing the counter, or skipping the frame number?
> :-) In my opinion the sequence number must be increased in this case. Not
> doing so would make it difficult to figure out frames have been skipped in
> the first place. That may be important in some cases. I can't think of any
> adverse effects this could result; the OMAP 3 ISP driver does so, for
> example.

I agree, I think the sequence counter should be incremented for skipped 
frames. Not all drivers can detect frame skips though, or how many frames are 
skipped.

> On the side of additional positive effects, consider the following quite
> realistic scenario: A frame is skipped on a single buffer queue of a device
> producing two streams of the same source, e.g. a sensor, whereas no frame is
> skipped on the second video buffer queue. Not incrementing the sequence
> would make the sequence numbers out-of-sync, and the situation would even
> be difficult to detect from the user space --- frame sequence numbers are
> important in associating buffers from different streams to the same
> original captured image.
> 
> > 5) Should the sequence counter always be monotonically increasing? I think
> > it should.
> 
> With the exception of the above, in my opinion yes. I.e. you're not supposed
> to have a decrease in field_count until it wraps around.
> 
> > Open questions with regards to the timestamp field:
> > 
> > 6) For output devices the timestamp field can be used to determine when to
> > transmit the frame. In practice there are no output drivers that support
> > this. It is also unclear how this would work: if the timestamp is 1 hour
> > into the future, should the driver hold on to that frame for one hour? If
> > another frame is queued with a timestamp that's earlier than the previous
> > frame, should that frame be output first?
> > 
> > I am inclined to drop this behavior from the spec. Should we get drivers
> > that actually implement this, then we need to clarify the spec and add a
> > new capability flag somewhere to tell userspace that you can actually use
> > the timestamp for this purpose.
> > 
> > 7) Should the timestamp field always be monotonically increasing? Or it is
> > possible to get timestamps that jump around? This makes sense for encoders
> > that create B-frames referring to frames captured earlier than an I-frame.
> 
> And for decoders that need to hold a key frame longer than others. (Or to
> save system memory resources, return it to the user space with the proposed
> READ_ONLY flag not agreed on yet.)

-- 
Regards,

Laurent Pinchart

