Return-path: <mchehab@pedra>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2321 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab1FTRSw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 13:18:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: vb2: holding buffers until after start_streaming()
Date: Mon, 20 Jun 2011 19:18:33 +0200
Cc: "'Pawel Osciak'" <pawel@osciak.com>,
	"'Jonathan Corbet'" <corbet@lwn.net>, linux-media@vger.kernel.org
References: <20110617125713.293f484d@bike.lwn.net> <BANLkTimPrkXUuTGCfrp8KyqhFNvfjoCzSw@mail.gmail.com> <003101cc2f0b$207f9680$617ec380$%szyprowski@samsung.com>
In-Reply-To: <003101cc2f0b$207f9680$617ec380$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201106201918.33817.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday, June 20, 2011 07:30:11 Marek Szyprowski wrote:
> Hello,
> 
> On Monday, June 20, 2011 3:28 AM Pawel Osciak wrote:
> 
> > On Fri, Jun 17, 2011 at 11:57, Jonathan Corbet <corbet@lwn.net> wrote:
> > > Here's another videobuf2 question...I've been trying to track down some
> > > weird behavior, the roots of which were in the fact that
> > start_streaming()
> > > gets called even though no buffers have been queued.  This behavior is
> > > quite explicit in the code:
> > >
> > >        /*
> > >         * Let driver notice that streaming state has been enabled.
> > >         */
> > >        ret = call_qop(q, start_streaming, q);
> > >        if (ret) {
> > >                dprintk(1, "streamon: driver refused to start
> > streaming\n");
> > >                return ret;
> > >        }
> > >
> > >        q->streaming = 1;
> > >
> > >        /*
> > >         * If any buffers were queued before streamon,
> > >         * we can now pass them to driver for processing.
> > >         */
> > >        list_for_each_entry(vb, &q->queued_list, queued_entry)
> > >                __enqueue_in_driver(vb);
> > >
> > > Pretty much every v4l2 capture application I've ever encountered passes
> > all
> > > of its buffers to VIDIOC_QBUF before starting streaming for a reason - it
> > > makes little sense to start if there's nothing to stream to.  It's really
> > > tempting to reorder that code, but...  it seems you must have done things
> > > this way for a reason.  Why did you need to reorder the operations in
> > this
> > > way?
> > >
> > 
> > I don't see a reason why these couldn't be reordered (Marek should be
> > able to confirm, he wrote those lines). But this wouldn't fix
> > everything, as the V4L2 API permits streamon without queuing any
> > buffers first (for capture devices). So even reordered, it's possible
> > for start_streaming to be called without passing any buffers to the
> > driver first.
> 
> The problem is the fact that you cannot guarantee the opposite order
> in all cases. Even if you swap __enqueue_in_driver and 
> call_qop(start_streaming), user might call respective ioctl in the
> opposite order and you will end with start_streaming before 
> __enqueue_in_driver. Calling VIDIOC_STREAMON without previous call
> to VIDIOC_QBUF is legal from v4l2 api definition.

But not all drivers support this. So the api does allow for it, but I
don't believe it is mandatory (or if it is, then many, many drivers are
not compliant).

> Because of that I decided to call start_streaming first, before the 
> __enqueue_in_driver() to ensure the drivers will get their methods
> called always in the same order, whatever used does. 

The problem with doing this is that in order to start streaming several
drivers need to have the queued buffers available. For example, the davinci
capture drivers (vpif_capture.c) can start the DMA if there is only one
buffer queued, but that will overwrite that buffer until another one is
queued. If it has two buffers or more, then it can start the DMA in a more
optimal fashion. (As an aside, looking at that driver I think it actually
always starts the DMA as if there is only one buffer available, thus
introducing an unnecessarily extra frame delay.)

Anyway, what I'm trying to say is that some hardware needs to have the
queued buffers in order to start DMA in the best possible way.

> Start_streaming was designed to perform time consuming operations
> like enabling the power, configuring the pipeline, setting up the
> tuner, etc. Some of these can fail and it is really good to report
> the failure asap.

Reordering doesn't affect that.
 
> If you cannot start your hardware (the dma engine) without queued
> buffers then you probably need to move dma starting routine to the
> first buffer_queue call. The problem is much more complex than it
> initially looks. 

I don't believe that this is mandatory. And if the spec says so, then I think
that spec should be changed since it doesn't reflect reality.

> Please note that in videobuf2 buffer_queue method is allowed to sleep,
> unlike it was designed in old videobuf.

Hmmm, I hope the driver will remember to release and reacquire and locks
when it goes to sleep. Something to document.

> Usually drivers require at least two buffers and always keep at 
> least one in the dma engine, which overwrites it with incoming frames
> until next buffer have been queued. However there are also devices
> (like camera sensors) that might be used to capture only one single
> frame or a few consecutive frames (for example a series of pictures).
> They need to dequeue the last buffer once it got filled with video
> data, so the design with overwriting the buffer makes no sense.
> Right now it is really driver dependent and no generic solution 
> exist.

What's wrong with keeping this driver specific?

> We have been discussing it but no consensus has been made yet, so
> right now I've decided to keep the current design. We probably needs
> some additional flag somewhere to configure the driver either to
> continuously overwrite last buffer until next one has been queued
> or stop the dma engine and return the buffer to user. Once

Something is missing here :-)

Anyway, I believe that it should be up to the driver to decide whether it will
allow STREAMON with no buffers queued. But the start_streaming implementation
*does* need to be called after the ownership of any pre-queued buffers has been
passed from vb2 to the driver, so that the driver can use them to start DMA in
an optimal manner (this is true for both capture and display, BTW).

Regards,

	Hans
