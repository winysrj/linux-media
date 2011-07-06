Return-path: <mchehab@localhost>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:20715 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab1GFOGl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2011 10:06:41 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-2
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LNX00KLI0J42280@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Jul 2011 15:06:40 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNX00ENW0J2AI@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Jul 2011 15:06:39 +0100 (BST)
Date: Wed, 06 Jul 2011 16:06:35 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH/RFC] media: vb2: change queue initialization order
In-reply-to: <20110630161803.04e1db20@bike.lwn.net>
To: 'Jonathan Corbet' <corbet@lwn.net>
Cc: linux-media@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Pawel Osciak' <pawel@osciak.com>,
	=?iso-8859-2?Q?'Uwe_Kleine-K=F6nig'?=
	<u.kleine-koenig@pengutronix.de>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Marin Mitov' <mitov@issp.bas.bg>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Guennadi Liakhovetski' <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <006a01cc3be5$eab323e0$c0196ba0$%szyprowski@samsung.com>
Content-language: pl
References: <1309340946-5658-1-git-send-email-m.szyprowski@samsung.com>
 <20110629072627.10081454@bike.lwn.net>
 <003501cc3666$5725a230$0570e690$%szyprowski@samsung.com>
 <20110630161803.04e1db20@bike.lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hello,

On Friday, July 01, 2011 12:18 AM Jonathan Corbet wrote:

> On Wed, 29 Jun 2011 16:10:45 +0200
> Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> 
> > > I do still wonder why this is an issue - why not pass the buffers
> through
> > > to the driver at VIDIOC_QBUF time?  I assume there must be a reason for
> > > doing things this way, I'd like to understand what it is.
> >
> > I want to delay giving the ownership of the buffers to the driver until
> it
> > is certain that start_streaming method will be called. This way I achieve
> > a well defined states of the queued buffers:
> >
> > 1. successful start_streaming() -> the driver is processing the queue
> buffers
> > 2. unsuccessful start_streaming() -> the driver is responsible to discard
> all
> >    queued buffers
> > 3. stop_streaming() called -> the driver has finished or discarded all
> queued
> >    buffers
> 
> So it's a buffer ownership thing.  I wonder if there would be value in
> adding a buf_give_them_all_back_now() callback?  You have an implicit
> change of buffer ownership now that seems easy for drivers to mess up.  It
> might be better to send an explicit signal at such times and, perhaps,
> even require the driver to explicitly hand each buffer back to vb2?  That
> would make the rules clear and give some flexibility - stopping and
> starting streaming without needing to start over with buffers, for example.

You are right that this will make the rules more clear, but wonder if we
really need it now in videbuf2.

The current V4L2 API states that all buffers are automatically discarded
after calling STREAM_OFF, so it is not really possible to implement true
pause-like functionality. Maybe we should schedule this for V4L3? ;)

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



