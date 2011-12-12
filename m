Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:35162 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab1LLLJc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 06:09:32 -0500
Received: from epcpsbgm1.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LW3007W98BU00Z0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Dec 2011 20:09:30 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp1.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0LW300I7A8BPX010@mmp1.samsung.com>
 for linux-media@vger.kernel.org; Mon, 12 Dec 2011 20:09:30 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Cc: 'Sakari Ailus' <sakari.ailus@iki.fi>,
	'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	=?iso-8859-1?Q?'Sebastian_Dr=F6ge'?=
	<sebastian.droege@collabora.co.uk>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <ADF13DA15EB3FE4FBA487CCC7BEFDF36225500763A@bssrvexch01>
 <20111206143538.GD938@valkosipuli.localdomain>
 <00da01ccb428$3c9522c0$b5bf6840$%debski@samsung.com>
 <201112121159.03471.laurent.pinchart@ideasonboard.com>
In-reply-to: <201112121159.03471.laurent.pinchart@ideasonboard.com>
Subject: RE: [RFC] Resolution change support in video codecs in v4l2
Date: Mon, 12 Dec 2011 12:09:23 +0100
Message-id: <003901ccb8be$84c19d40$8e44d7c0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: 12 December 2011 11:59
> 
> Hi Kamil,
> 
> On Tuesday 06 December 2011 16:03:33 Kamil Debski wrote:
> > On 06 December 2011 15:36 Sakari Ailus wrote:
> > > On Fri, Dec 02, 2011 at 02:50:17PM -0200, Mauro Carvalho Chehab wrote:
> > > > On 02-12-2011 11:57, Sakari Ailus wrote:
> > > > > Some codecs need to be able to access buffers which have already
> been
> > > > > decoded to decode more buffers. Key frames, simply.
> > > >
> > > > Ok, but let's not add unneeded things at the API if you're not sure.
> If
> > > > we have such need for a given hardware, then add it. Otherwise, keep
> it
> > > > simple.
> > >
> > > This is not so much dependent on hardware but on the standards which the
> > > cdoecs implement.
> > >
> > > > > The user space still wants to be able to show these buffers, so a
> new
> > > > > flag would likely be required --- V4L2_BUF_FLAG_READ_ONLY, for
> > > > > example.
> > > >
> > > > Huh? Assuming a capture device, when kernel makes a buffer available
> to
> > > > userspace, kernel should not touch on it anymore (not even for read -
> > > > although reading from it probably won't cause any issues, as video
> > > > applications in general don't write into those buffers). The opposite
> is
> > > > true for output devices: once userspace fills it, and queues, it
> should
> > > > not touch that buffer again.
> > > >
> > > > This is part of the queue/dequeue logic. I can't see any need for an
> > > > extra flag to explicitly say that.
> > >
> > > There is a reason to do so. An example of this is below. The
> > > memory-to-memory device has two queues, output can capture. A video
> > > decoder memory-to-memory device's output queue handles compressed video
> > > and the capture queue provides the application decoded frames.
> > >
> > > Certain frames in the stream are key frames, meaning that the decoding
> of
> > > the following non-key frames requires access to the key frame. The
> number
> > > of non-key frame can be relatively large, say 16, depending on the
> > > codec.
> > >
> > > If the user should wait for all the frames to be decoded before the key
> > > frame can be shown, then either the key frame is to be skipped or
> > > delayed. Both of the options are highly undesirable.
> >
> > I don't think that such a delay is worrisome. This is only initial delay.
> > The hw will process these N buffers and after that it works exactly the
> > same as it would without the delay in terms of processing time.
> 
> For offline video decoding (such as playing a movie for instance) that's
> probably not a big issue. For online video decoding (video conferencing)
> where
> you want to minimize latency it can be.

In this use case it would be good to setup the encoder to use as little 
reference frames as possible. The lesser reference frames are used the shorter
is the delay. The stream used for video conferencing should definitely be
different
from the one used in DVD/Blu-ray.

Also you can set the display delay to 0 then you will get the frames as soon as
possible, but it's up to the application to display them in the right order and
to make sure that they are not modified.
 
> > > Alternatively one could allocate the double number of buffers required.
> > > At 1080p and 16 buffers this could be roughly 66 MB. Additionally,
> > > starting the playback is delayed for the duration for the decoding of
> > > those frames. I think we should not force users to do so.
> >
> > I really don't think it is necessary to allocate twice as many buffers.
> > Assuming that hw needs K buffers you may alloc N (= K + L) and the
> > application may use all these L buffers at a time.
> 

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

