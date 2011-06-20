Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:46407 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab1FTFaV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 01:30:21 -0400
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LN200826PYJOG60@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 20 Jun 2011 06:30:19 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LN2006WPPYIHN@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 20 Jun 2011 06:30:18 +0100 (BST)
Date: Mon, 20 Jun 2011 07:30:11 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: vb2: holding buffers until after start_streaming()
In-reply-to: <BANLkTimPrkXUuTGCfrp8KyqhFNvfjoCzSw@mail.gmail.com>
To: 'Pawel Osciak' <pawel@osciak.com>,
	'Jonathan Corbet' <corbet@lwn.net>
Cc: linux-media@vger.kernel.org
Message-id: <003101cc2f0b$207f9680$617ec380$%szyprowski@samsung.com>
Content-language: pl
Content-transfer-encoding: 8BIT
References: <20110617125713.293f484d@bike.lwn.net>
 <BANLkTimPrkXUuTGCfrp8KyqhFNvfjoCzSw@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Monday, June 20, 2011 3:28 AM Pawel Osciak wrote:

> On Fri, Jun 17, 2011 at 11:57, Jonathan Corbet <corbet@lwn.net> wrote:
> > Here's another videobuf2 question...I've been trying to track down some
> > weird behavior, the roots of which were in the fact that
> start_streaming()
> > gets called even though no buffers have been queued.  This behavior is
> > quite explicit in the code:
> >
> >        /*
> >         * Let driver notice that streaming state has been enabled.
> >         */
> >        ret = call_qop(q, start_streaming, q);
> >        if (ret) {
> >                dprintk(1, "streamon: driver refused to start
> streaming\n");
> >                return ret;
> >        }
> >
> >        q->streaming = 1;
> >
> >        /*
> >         * If any buffers were queued before streamon,
> >         * we can now pass them to driver for processing.
> >         */
> >        list_for_each_entry(vb, &q->queued_list, queued_entry)
> >                __enqueue_in_driver(vb);
> >
> > Pretty much every v4l2 capture application I've ever encountered passes
> all
> > of its buffers to VIDIOC_QBUF before starting streaming for a reason - it
> > makes little sense to start if there's nothing to stream to.  It's really
> > tempting to reorder that code, but...  it seems you must have done things
> > this way for a reason.  Why did you need to reorder the operations in
> this
> > way?
> >
> 
> I don't see a reason why these couldn't be reordered (Marek should be
> able to confirm, he wrote those lines). But this wouldn't fix
> everything, as the V4L2 API permits streamon without queuing any
> buffers first (for capture devices). So even reordered, it's possible
> for start_streaming to be called without passing any buffers to the
> driver first.

The problem is the fact that you cannot guarantee the opposite order
in all cases. Even if you swap __enqueue_in_driver and 
call_qop(start_streaming), user might call respective ioctl in the
opposite order and you will end with start_streaming before 
__enqueue_in_driver. Calling VIDIOC_STREAMON without previous call
to VIDIOC_QBUF is legal from v4l2 api definition.

Because of that I decided to call start_streaming first, before the 
__enqueue_in_driver() to ensure the drivers will get their methods
called always in the same order, whatever used does. 

Start_streaming was designed to perform time consuming operations
like enabling the power, configuring the pipeline, setting up the
tuner, etc. Some of these can fail and it is really good to report
the failure asap.

If you cannot start your hardware (the dma engine) without queued
buffers then you probably need to move dma starting routine to the
first buffer_queue call. The problem is much more complex than it
initially looks. 

Please note that in videobuf2 buffer_queue method is allowed to sleep,
unlike it was designed in old videobuf.

Usually drivers require at least two buffers and always keep at 
least one in the dma engine, which overwrites it with incoming frames
until next buffer have been queued. However there are also devices
(like camera sensors) that might be used to capture only one single
frame or a few consecutive frames (for example a series of pictures).
They need to dequeue the last buffer once it got filled with video
data, so the design with overwriting the buffer makes no sense.
Right now it is really driver dependent and no generic solution 
exist.

We have been discussing it but no consensus has been made yet, so
right now I've decided to keep the current design. We probably needs
some additional flag somewhere to configure the driver either to
continuously overwrite last buffer until next one has been queued
or stop the dma engine and return the buffer to user. Once


Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


