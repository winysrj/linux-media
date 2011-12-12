Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:25468 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1LLKRO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 05:17:14 -0500
Received: from epcpsbgm1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LW300BKU5WB1YS0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Dec 2011 19:17:12 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp1.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0LW300HFH5WJ0300@mmp1.samsung.com>
 for linux-media@vger.kernel.org; Mon, 12 Dec 2011 19:17:12 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sakari Ailus' <sakari.ailus@iki.fi>
Cc: 'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	=?iso-8859-1?Q?'Sebastian_Dr=F6ge'?=
	<sebastian.droege@collabora.co.uk>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <ADF13DA15EB3FE4FBA487CCC7BEFDF36225500763A@bssrvexch01>
 <4ED8C61C.3060404@redhat.com> <20111202135748.GO29805@valkosipuli.localdomain>
 <4ED901C9.2050109@redhat.com> <20111206143538.GD938@valkosipuli.localdomain>
 <00da01ccb428$3c9522c0$b5bf6840$%debski@samsung.com>
 <20111209195440.GB1967@valkosipuli.localdomain>
In-reply-to: <20111209195440.GB1967@valkosipuli.localdomain>
Subject: RE: [RFC] Resolution change support in video codecs in v4l2
Date: Mon, 12 Dec 2011 11:17:06 +0100
Message-id: <003501ccb8b7$3617d800$a2478800$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 8BIT
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: 'Sakari Ailus' [mailto:sakari.ailus@iki.fi]
> Sent: 09 December 2011 20:55
> To: Kamil Debski
> Cc: 'Mauro Carvalho Chehab'; linux-media@vger.kernel.org; 'Laurent Pinchart';
> 'Sebastian Dröge'; Sylwester Nawrocki; Marek Szyprowski
> Subject: Re: [RFC] Resolution change support in video codecs in v4l2
> 
> Hi Kamil,
> 
> On Tue, Dec 06, 2011 at 04:03:33PM +0100, Kamil Debski wrote:
> ...
> > > > >The user space still wants to be able to show these buffers, so a new
> > > flag
> > > > >would likely be required --- V4L2_BUF_FLAG_READ_ONLY, for example.
> > > >
> > > > Huh? Assuming a capture device, when kernel makes a buffer available
> to
> > > userspace,
> > > > kernel should not touch on it anymore (not even for read - although
> > > reading from
> > > > it probably won't cause any issues, as video applications in general
> don't
> > > write
> > > > into those buffers). The opposite is true for output devices: once
> > > userspace fills it,
> > > > and queues, it should not touch that buffer again.
> > > >
> > > > This is part of the queue/dequeue logic. I can't see any need for an
> extra
> > > > flag to explicitly say that.
> > >
> > > There is a reason to do so. An example of this is below. The
> > > memory-to-memory device has two queues, output can capture. A video
> decoder
> > > memory-to-memory device's output queue handles compressed video and the
> > > capture queue provides the application decoded frames.
> > >
> > > Certain frames in the stream are key frames, meaning that the decoding
> of
> > > the following non-key frames requires access to the key frame. The
> number of
> > > non-key frame can be relatively large, say 16, depending on the codec.
> > >
> > > If the user should wait for all the frames to be decoded before the key
> > > frame can be shown, then either the key frame is to be skipped or
> delayed.
> > > Both of the options are highly undesirable.
> >
> > I don't think that such a delay is worrisome. This is only initial delay.
> > The hw will process these N buffers and after that it works exactly the
> same
> > as it would without the delay in terms of processing time.
> 
> Well, yes, but consider that the decoder also processes key frames when the
> decoding is in progress. The dequeueing of the key frames (and any further
> frames as long as the key frame is needed by the decoder) will be delayed
> until the key frame is no longer required.
> 
> You need extra buffers to cope with such a situation, and in the worst case,
> or when the decoder is just as fast as you want to show the frames on the
> display, you need double the amount of buffers compared to what you'd really
> need for decoding. To make matters worse, this tends to happen at largest
> resolutions.
> 
> I think we'd like to avoid this.

I really, really, don’t see why you say that we would need double the number of
buffers?

Let's suppose that the stream may reference 2 previous frames.

Frame number:     123456789ABCDEF
Returned frame:     123456789ABCDEF
Buffers returned:   123123123123... (in case we have only 3 buffers)

See? After we decode frame number 3 we can return frame number 3. Thus we need
minimum of 3 buffers. If we want to have 4 for simultaneous the use of
application
we allocate 7. 

The current codec handling system has been build on the following assumptions:
- the buffers should be dequeued in order
- the buffers should be only dequeued when they are no longer is use

This takes care of the delay related problems by requiring more buffers.
You have an initial delay then the frames are returned with a constant rate.

Dequeuing of any frame will be delayed until it is no longer used - it doesn't
matter whether it is a key (I) frame, P frame o r a B frame. Actually B frames
shouldn't be used as reference. Usually a frame is referencing only 2-3 previous
and maybe 1 ahead (for B-frames) frames and they don't need to be I-frames. Still
the interval between I-frames may be 16 or even many, many, more.

In your other email you have mentioned "acceleration". I can agree with you that
it makes the process faster than decoding the same compressed stream many times.
I have never seen any implementation that would process the same compressed
stream more than once. Thus I would not say it's purely for acceleration. This is
the way it is done - you keep older decompressed frames for reference.
Reprocessing
the compressed stream would be too computation demanding I suppose.

Anyway I can definitely recommend the book "H.264 and MPEG-4 video compression:
Video coding for next-generation multimedia" by Iain E.G. Richardson. It is a
good
book about video coding and modern codecs with many things explained. It would
help
to get you around with codecs and could answer many of your questions.
http://www.amazon.com/H-264-MPEG-4-Video-Compression-Generation/dp/0470848375

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

