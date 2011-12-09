Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:50904 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab1LITyp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2011 14:54:45 -0500
Date: Fri, 9 Dec 2011 21:54:40 +0200
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
Message-ID: <20111209195440.GB1967@valkosipuli.localdomain>
References: <ADF13DA15EB3FE4FBA487CCC7BEFDF36225500763A@bssrvexch01>
 <4ED8C61C.3060404@redhat.com>
 <20111202135748.GO29805@valkosipuli.localdomain>
 <4ED901C9.2050109@redhat.com>
 <20111206143538.GD938@valkosipuli.localdomain>
 <00da01ccb428$3c9522c0$b5bf6840$%debski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00da01ccb428$3c9522c0$b5bf6840$%debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

On Tue, Dec 06, 2011 at 04:03:33PM +0100, Kamil Debski wrote:
...
> > > >The user space still wants to be able to show these buffers, so a new
> > flag
> > > >would likely be required --- V4L2_BUF_FLAG_READ_ONLY, for example.
> > >
> > > Huh? Assuming a capture device, when kernel makes a buffer available to
> > userspace,
> > > kernel should not touch on it anymore (not even for read - although
> > reading from
> > > it probably won't cause any issues, as video applications in general don't
> > write
> > > into those buffers). The opposite is true for output devices: once
> > userspace fills it,
> > > and queues, it should not touch that buffer again.
> > >
> > > This is part of the queue/dequeue logic. I can't see any need for an extra
> > > flag to explicitly say that.
> > 
> > There is a reason to do so. An example of this is below. The
> > memory-to-memory device has two queues, output can capture. A video decoder
> > memory-to-memory device's output queue handles compressed video and the
> > capture queue provides the application decoded frames.
> > 
> > Certain frames in the stream are key frames, meaning that the decoding of
> > the following non-key frames requires access to the key frame. The number of
> > non-key frame can be relatively large, say 16, depending on the codec.
> > 
> > If the user should wait for all the frames to be decoded before the key
> > frame can be shown, then either the key frame is to be skipped or delayed.
> > Both of the options are highly undesirable.
> 
> I don't think that such a delay is worrisome. This is only initial delay.
> The hw will process these N buffers and after that it works exactly the same
> as it would without the delay in terms of processing time.

Well, yes, but consider that the decoder also processes key frames when the
decoding is in progress. The dequeueing of the key frames (and any further
frames as long as the key frame is needed by the decoder) will be delayed
until the key frame is no longer required.

You need extra buffers to cope with such a situation, and in the worst case,
or when the decoder is just as fast as you want to show the frames on the
display, you need double the amount of buffers compared to what you'd really
need for decoding. To make matters worse, this tends to happen at largest
resolutions.

I think we'd like to avoid this.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
