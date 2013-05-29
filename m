Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:15503 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965855Ab3E2Mbs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 08:31:48 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNK00IOE7YZ7J40@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 May 2013 13:31:47 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Philipp Zabel' <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
	'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	'Pawel Osciak' <pawel@osciak.com>,
	'John Sheu' <sheu@google.com>,
	'Hans Verkuil' <hans.verkuil@cisco.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
References: <1369217856-10385-1-git-send-email-p.zabel@pengutronix.de>
 <01f401ce5c52$75dcee90$6196cbb0$%debski@samsung.com>
 <1369825995.4050.49.camel@pizza.hi.pengutronix.de>
In-reply-to: <1369825995.4050.49.camel@pizza.hi.pengutronix.de>
Subject: RE: [RFC] [media] mem2mem: add support for hardware buffered queue
Date: Wed, 29 May 2013 14:31:43 +0200
Message-id: <021801ce5c68$7aa6f7c0$6ff4e740$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> -----Original Message-----
> From: Philipp Zabel [mailto:p.zabel@pengutronix.de]
> Sent: Wednesday, May 29, 2013 1:13 PM
> To: Kamil Debski
> Cc: linux-media@vger.kernel.org; 'Mauro Carvalho Chehab'; 'Pawel
> Osciak'; 'John Sheu'; 'Hans Verkuil'; Marek Szyprowski; Andrzej Hajda
> Subject: Re: [RFC] [media] mem2mem: add support for hardware buffered
> queue
> 
> Hi Kamil,
> 
> Am Mittwoch, den 29.05.2013, 11:54 +0200 schrieb Kamil Debski:
> > Hi Philipp, Hans,
> >
> > > On mem2mem decoders with a hardware bitstream ringbuffer, to drain
> > > the buffer at the end of the stream, remaining frames might need to
> > > be decoded without additional input buffers being provided, and
> > > after calling streamoff on the v4l2 output queue. This also allows
> a
> > > driver to copy input buffers into their bitstream ringbuffer and
> > > immediately mark them as done to be dequeued.
> > >
> > > The motivation for this patch is hardware assisted h.264 reordering
> > > support in the coda driver. For high profile streams, the coda can
> > > hold back out-of-order frames, causing a few mem2mem device runs in
> > > the beginning, that don't produce any decompressed buffer at the
> > > v4l2 capture side. At the same time, the last few frames can be
> > > decoded from the bitstream with mem2mem device runs that don't need
> > > a new input buffer at the v4l2 output side. A streamoff on the v4l2
> > > output side can be used to put the decoder into the ringbuffer
> > > draining end-of-stream mode.
> >
> > If I remember correctly the main goal of introducing the m2m
> framework
> > was to support simple mem2mem devices where one input buffer = one
> > output buffer. In other cases m2m was not to be used.
> 
> The m2m context / queue handling and job scheduling are very useful
> even for drivers that don't always produce one CAPTURE buffer from one
> OUTPUT buffer, just as you drescribe below.
> The CODA encoder path fits the m2m model perfectly. I'd prefer not to
> duplicate most of mem2mem just because the decoder doesn't.
> 
> There's two things that this patch allows me to do:
> a) running mem2mem device_run with an empty OUTPUT queue, which is
>    something I'd really like to make possible.
> b) running mem2mem device_run with the OUTPUT queue in STREAM OFF,
> which
>    I needed to get the remaining buffers out. But maybe there is a
>    better way to do this while keeping the output queue streaming.
> 
> > An example of such mem2mem driver, which does not use m2m framework
> is
> > MFC. It uses videobuf2 directly and it is wholly up to the driver how
> > will it control the queues, stream on/off and so on. You can then
> have
> > one OUTPUT buffer generate multiple CAPTURE buffer, multiple OUTPUT
> > buffers generate a single CAPTURE buffer. Consume OUTPUT buffer
> > without generating CAPTURE buffer (e.g. when starting decoding) and
> > produce CAPTURE buffers without consuming OUTPUT buffers (e.g. when
> > finishing decoding).
> >
> > I think that stream off should not be used to signal EOS. For this we
> > have EOS event. You mentioned the EOS buffer flag. This is the idea
> > originally proposed by Andrzej Hajda, after some lengthy discussions
> > with v4l community this idea was changed to use an EOS event.
> 
> I'm not set on using STREAMOFF to signal the stream-end condition to
> the hardware, but after switching to stream-end mode, no new frames
> should be queued, so I thought it fit quite well. It also allows to
> prepare the OUTPUT buffers (S_FMT/REQBUFS) for the next STREAMON while
> the CAPTURE side is still draining the bitstream, although that's
> probably not a very useful feature.
> I could instead have userspace signal the driver via an EOS buffer flag
> or any other mechanism. Then the OUTPUT queue would be kept streaming,
> but hold back all buffers queued via QBUF until the last buffer is
> dequeued from the CAPTURE queue.
> 
> > I was all for the EOS buffer flag, but after discussion with Mauro I
> > understood his arguments. We can get back to this discussion, if we
> > are sure that events are not enough. Please also note that we need to
> > keep backward compatibility.
> 
> Maybe I've missed something, but I thought the EOS signal is only for
> the driver to signal to userspace that the currently dequeued frame is
> the last one?
> I need userspace to signal to the driver that it won't queue any new
> OUTPUT buffers, but still wants to dequeue the remaining CAPTURE
> buffers until the bitstream buffer is empty.

Right, I mixed that with EOS command. EOS command should be used to
signal end of stream. Also queueing a buffer with bytesused = 0 can
signal that to the driver (this is kept for backward compatibility).

> 
> > Original EOS buffer flag patches by Andrzej and part of the
> discussion
> > can be found here:
> > 1) https://linuxtv.org/patch/10624/
> > 2) https://linuxtv.org/patch/11373/
> >
> > Best wishes,
> > Kamil Debski
> 
> regards
> Philipp

Best wishes,
Kamil


