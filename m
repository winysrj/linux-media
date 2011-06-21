Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:16117 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab1FUQHN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2011 12:07:13 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LN500A7TE3Z8UA0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 21 Jun 2011 17:07:11 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LN500C0FE3YKQ@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 21 Jun 2011 17:07:10 +0100 (BST)
Date: Tue, 21 Jun 2011 18:07:03 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: vb2: holding buffers until after start_streaming()
In-reply-to: <20110620094838.56daf754@bike.lwn.net>
To: 'Jonathan Corbet' <corbet@lwn.net>
Cc: 'Pawel Osciak' <pawel@osciak.com>, linux-media@vger.kernel.org
Message-id: <005601cc302d$427c0f70$c7742e50$%szyprowski@samsung.com>
Content-language: pl
References: <20110617125713.293f484d@bike.lwn.net>
 <BANLkTimPrkXUuTGCfrp8KyqhFNvfjoCzSw@mail.gmail.com>
 <003101cc2f0b$207f9680$617ec380$%szyprowski@samsung.com>
 <20110620094838.56daf754@bike.lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Monday, June 20, 2011 5:49 PM Jonathan Corbet wrote:

> On Mon, 20 Jun 2011 07:30:11 +0200
> Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> 
> > Because of that I decided to call start_streaming first, before the
> > __enqueue_in_driver() to ensure the drivers will get their methods
> > called always in the same order, whatever used does.
> 
> It still seems like the "wrong" order to me; it means that
> start_streaming() can't actually start streaming.  But, as has been
> pointed out, the driver can't count on the buffers being there in any
> case.  This ordering does, at least, expose situations where the driver
> author didn't think that buffers might not have been queued yet.
> 
> (BTW, lest people think I'm complaining too much, let it be said that vb2
> is, indeed, a big improvement over its predecessor.)

I'm aware of this issue and I definitely don't threat your comments as
complaining. Right now there are just a few drivers that use vb2 so it
is quite easy to fix or change some design ideas.

I've thought a bit more about the current design and I must confess that
in fact it is suboptimal. Probably during vb2 development I've focused too
much on vivi and mem2mem devices which were used for testing the framework.

Usually for mem2mem case streamon() operations don't touch DMA engines,
so I've missed the point that DMA engine for typical capture or output
device should be activated there with some buffers already queued.

Now we also know that there are drivers that may need to start dma engine
in buffer_queue and stop it in the isr (before buffer_done). Capturing a 
single frame with camera sensor (taking a picture) is one of such
examples.

I have an idea to introduce a new flags to let device driver tell vb2
weather it supports 'streaming without buffers' or not. This way the
order of operations in vb2_streamon() function can be switched and vb2
can also return an error if one will try to enable streaming on device
that cannot do it without buffers pre-queued. This way most of typical
capture and output drivers will be happy. They will just use the 
'overwrite last frame' technique to guarantee that there is at least
one buffer for the dma engine all the time when streaming is enable. 
Mem2mem (and these special 'streaming without buffers' capable) drivers
will just set these flags and continue enabling/disabling dma engine 
per-frame basis.

I will try to post the patches soon.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



