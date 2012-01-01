Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:42187 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab2AAW3e (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Jan 2012 17:29:34 -0500
Date: Mon, 2 Jan 2012 00:29:28 +0200
From: 'Sakari Ailus' <sakari.ailus@iki.fi>
To: Kamil Debski <k.debski@samsung.com>
Cc: 'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Sebastian =?iso-8859-1?Q?Dr=F6ge'?=
	<sebastian.droege@collabora.co.uk>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC] Resolution change support in video codecs in v4l2
Message-ID: <20120101222928.GJ3677@valkosipuli.localdomain>
References: <ADF13DA15EB3FE4FBA487CCC7BEFDF36225500763A@bssrvexch01>
 <4ED8C61C.3060404@redhat.com>
 <20111202135748.GO29805@valkosipuli.localdomain>
 <4ED901C9.2050109@redhat.com>
 <20111206143538.GD938@valkosipuli.localdomain>
 <00da01ccb428$3c9522c0$b5bf6840$%debski@samsung.com>
 <20111209195440.GB1967@valkosipuli.localdomain>
 <003501ccb8b7$3617d800$a2478800$%debski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <003501ccb8b7$3617d800$a2478800$%debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

Apologies for my later reply.

On Mon, Dec 12, 2011 at 11:17:06AM +0100, Kamil Debski wrote:
> > -----Original Message-----
> > From: 'Sakari Ailus' [mailto:sakari.ailus@iki.fi]
> > Sent: 09 December 2011 20:55
> > To: Kamil Debski
> > Cc: 'Mauro Carvalho Chehab'; linux-media@vger.kernel.org; 'Laurent Pinchart';
> > 'Sebastian Dröge'; Sylwester Nawrocki; Marek Szyprowski
> > Subject: Re: [RFC] Resolution change support in video codecs in v4l2
> > 
> > Hi Kamil,
> > 
> > On Tue, Dec 06, 2011 at 04:03:33PM +0100, Kamil Debski wrote:
> > ...
> > > > > >The user space still wants to be able to show these buffers, so a new
> > > > flag
> > > > > >would likely be required --- V4L2_BUF_FLAG_READ_ONLY, for example.
> > > > >
> > > > > Huh? Assuming a capture device, when kernel makes a buffer available
> > to
> > > > userspace,
> > > > > kernel should not touch on it anymore (not even for read - although
> > > > reading from
> > > > > it probably won't cause any issues, as video applications in general
> > don't
> > > > write
> > > > > into those buffers). The opposite is true for output devices: once
> > > > userspace fills it,
> > > > > and queues, it should not touch that buffer again.
> > > > >
> > > > > This is part of the queue/dequeue logic. I can't see any need for an
> > extra
> > > > > flag to explicitly say that.
> > > >
> > > > There is a reason to do so. An example of this is below. The
> > > > memory-to-memory device has two queues, output can capture. A video
> > decoder
> > > > memory-to-memory device's output queue handles compressed video and the
> > > > capture queue provides the application decoded frames.
> > > >
> > > > Certain frames in the stream are key frames, meaning that the decoding
> > of
> > > > the following non-key frames requires access to the key frame. The
> > number of
> > > > non-key frame can be relatively large, say 16, depending on the codec.
> > > >
> > > > If the user should wait for all the frames to be decoded before the key
> > > > frame can be shown, then either the key frame is to be skipped or
> > delayed.
> > > > Both of the options are highly undesirable.
> > >
> > > I don't think that such a delay is worrisome. This is only initial delay.
> > > The hw will process these N buffers and after that it works exactly the
> > same
> > > as it would without the delay in terms of processing time.
> > 
> > Well, yes, but consider that the decoder also processes key frames when the
> > decoding is in progress. The dequeueing of the key frames (and any further
> > frames as long as the key frame is needed by the decoder) will be delayed
> > until the key frame is no longer required.
> > 
> > You need extra buffers to cope with such a situation, and in the worst case,
> > or when the decoder is just as fast as you want to show the frames on the
> > display, you need double the amount of buffers compared to what you'd really
> > need for decoding. To make matters worse, this tends to happen at largest
> > resolutions.
> > 
> > I think we'd like to avoid this.
> 
> I really, really, don’t see why you say that we would need double the number of
> buffers?
> 
> Let's suppose that the stream may reference 2 previous frames.
> 
> Frame number:     123456789ABCDEF
> Returned frame:     123456789ABCDEF
> Buffers returned:   123123123123... (in case we have only 3 buffers)
> 
> See? After we decode frame number 3 we can return frame number 3. Thus we need
> minimum of 3 buffers. If we want to have 4 for simultaneous the use of
> application
> we allocate 7. 
> 
> The current codec handling system has been build on the following assumptions:
> - the buffers should be dequeued in order
> - the buffers should be only dequeued when they are no longer is use

What does "in use" mean to you? Both read and write, or just read?

Assume frame 1 is required to decode frames 2 and 3.

If we delay dequeueing of te first of the above three frames since the codec
accesses it for reading, we will also delay dequeueing of any subsequent
frames until the first frame is decoded. If this is repeated, and assuming
the speed of the decoder is the same as playback of those frames, the player
will require a minimum of six frames to cope with the uneven time interval
the decoder will be able to give those frames to the player. Otherwise, only
three frames would be enough.

> This takes care of the delay related problems by requiring more buffers.
> You have an initial delay then the frames are returned with a constant rate.
> 
> Dequeuing of any frame will be delayed until it is no longer used - it doesn't
> matter whether it is a key (I) frame, P frame o r a B frame. Actually B frames
> shouldn't be used as reference. Usually a frame is referencing only 2-3 previous
> and maybe 1 ahead (for B-frames) frames and they don't need to be I-frames. Still
> the interval between I-frames may be 16 or even many, many, more.

Considering it can be 16 or even more, I see even more reason in returning
frames when hardware only reads them.

I'm not against making it configurable for the user, keeping the traditional
behaviour could be beneficial as well if the user wishes to further precess
the frames in-place.

...

> Anyway I can definitely recommend the book "H.264 and MPEG-4 video compression:
> Video coding for next-generation multimedia" by Iain E.G. Richardson. It is a
> good
> book about video coding and modern codecs with many things explained. It would
> help
> to get you around with codecs and could answer many of your questions.
> http://www.amazon.com/H-264-MPEG-4-Video-Compression-Generation/dp/0470848375

Thanks for the pointer.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
