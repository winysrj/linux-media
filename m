Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:18934 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627Ab1DHNJL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2011 09:09:11 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LJC00IBV4J8V8@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 08 Apr 2011 14:09:09 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LJC009604J750@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 08 Apr 2011 14:09:08 +0100 (BST)
Date: Fri, 08 Apr 2011 15:09:02 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [RFC/PATCH 1/2] v4l: videobuf2: Handle buf_queue errors
In-reply-to: <201104081453.21999.laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Sylwester Nawrocki' <snjw23@gmail.com>
Cc: 'Pawel Osciak' <pawel@osciak.com>, linux-media@vger.kernel.org,
	hverkuil@xs4all.nl, Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <000001cbf5ee$21cbff70$6563fe50$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1298830353-9797-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <4D9CC780.3000902@gmail.com> <4D9CE37D.6000202@gmail.com>
 <201104081453.21999.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Friday, April 08, 2011 2:53 PM Laurent Pinchart wrote:

> > ...
> >
> > > As buf_queue callback is called by vb2 only after start_streaming,
> > > for a camera snapshot capture I needed to start a pipeline only from
> the
> > > buf_queue handler level, i.e. subdev's video s_stream op was called
> from
> > > within buf_queue. s_stream couldn't be done in the start_streaming
> > > handler as at the time it is invoked there is always no buffer
> available
> > > in the bridge H/W.
> > > It's a consequence of how the vb2_streamon() is designed.
> > >
> > > Before, I used to simply call s_stream in start_streaming, only
> deferring
> > > the actual bridge DMA enable till a buf_queue call, thus letting first
> > > frames in the stream to be lost. This of course cannot be done in case
> > > of single-frame capture.
> > >
> > > To make a long story short, it would be useful in my case to have the
> > > ability to return error codes as per VIDIOC_STREAMON through buf_queue
> > > in the driver (when the first buffer is queued).
> > > At the moment mainly EPIPE comes to my mind. This error code has no
> > > meaning in the API for QBUF though. Should the pipeline be started from
> > > buf_queue
> >
> > Hmm, the pipeline validation could still be done in start_streaming()
> > so we can return any EPIPE error from there directly and effectively
> > in VIDIOC_STREAMON.
> 
> That's correct, and that's what the OMAP3 ISP driver does.
> 
> > So the only remaining errors are those related to I2C communication etc.
> > when streaming is actually enabled in the subdev.
> 
> buf_queue is called with a spinlock help, so you can't perform I2C
> communication there.

In videobuf2 buf_queue() IS NOT called with any spinlock held. buf_queue can
call functions that require sleeping. This makes a lot of sense especially
for drivers that need to perform a lot of operations for enabling/disabling
hardware.

I remember we discussed your solution where you wanted to add a spinlock for
calling buf_queue. This case shows one more reason not go that way. :)

AFAIR buf_queue callback in old videobuf was called with spinlock held.

I agree that we definitely need more documentation for vb2 and clarification
what is allowed in each callback...

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

