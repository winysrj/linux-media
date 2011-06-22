Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43599 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab1FVJnU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 05:43:20 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LN600G1FR071P@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Jun 2011 10:43:19 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LN600D4VR06ZP@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Jun 2011 10:43:18 +0100 (BST)
Date: Wed, 22 Jun 2011 11:43:14 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: vb2: holding buffers until after start_streaming()
In-reply-to: <20110621111420.4ef5472e@bike.lwn.net>
To: 'Jonathan Corbet' <corbet@lwn.net>
Cc: 'Pawel Osciak' <pawel@osciak.com>, linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <002801cc30c0$ceb89880$6c29c980$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <20110617125713.293f484d@bike.lwn.net>
 <BANLkTimPrkXUuTGCfrp8KyqhFNvfjoCzSw@mail.gmail.com>
 <003101cc2f0b$207f9680$617ec380$%szyprowski@samsung.com>
 <20110620094838.56daf754@bike.lwn.net>
 <005601cc302d$427c0f70$c7742e50$%szyprowski@samsung.com>
 <20110621111420.4ef5472e@bike.lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Tuesday, June 21, 2011 7:14 PM Jonathan Corbet wrote:

> On Tue, 21 Jun 2011 18:07:03 +0200
> Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> 
> > I have an idea to introduce a new flags to let device driver tell vb2
> > weather it supports 'streaming without buffers' or not. This way the
> > order of operations in vb2_streamon() function can be switched and vb2
> > can also return an error if one will try to enable streaming on device
> > that cannot do it without buffers pre-queued.
> 
> Do you really need a flag?  If a driver absolutely cannot stream without
> buffers queued (and can't be fixed to start streaming for real when the
> buffers show up) it should just return -EINVAL from start_streaming() or
> some such.  The driver must be aware of its limitations regardless, but
> there's no need to push that awareness into vb2 as well.

The main idea behind vb2 was to move all common error handling code to
the framework and provide simple functions that can be used by the driver
directly without the need for additional checks.

> (FWIW, I wouldn't switch the order of operations in vb2_streamon(); I
> would just take out the "if (q->streaming)" test at the end of vb2_qbuf()
> and pass the buffers through directly.  But maybe that's just me.)

I want to keep the current version of vb2_qbuf() and change the order of
operations in streamon().

The only problem that still need to be resolved is what should happen with
the buffers if start_streaming() fails. The ownership for these buffers have
been already given to the driver, but they might have been in dirty state.
Probably vb2 should assume that the buffers are lost and reinitialize them.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



