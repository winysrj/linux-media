Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:48447 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab1F2OLJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 10:11:09 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-2
Received: from spt2.w1.samsung.com ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LNK00B2F22I1GB0@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Jun 2011 15:11:06 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNK00J5F22HY9@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Jun 2011 15:11:06 +0100 (BST)
Date: Wed, 29 Jun 2011 16:10:45 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH/RFC] media: vb2: change queue initialization order
In-reply-to: <20110629072627.10081454@bike.lwn.net>
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
Message-id: <003501cc3666$5725a230$0570e690$%szyprowski@samsung.com>
Content-language: pl
References: <1309340946-5658-1-git-send-email-m.szyprowski@samsung.com>
 <20110629072627.10081454@bike.lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Wednesday, June 29, 2011 3:26 PM wrote:

> On Wed, 29 Jun 2011 11:49:06 +0200
> Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> 
> > This patch introduces VB2_STREAMON_WITHOUT_BUFFERS io flag and changes
> > the order of operations during stream on operation. Now the buffer are
> > first queued to the driver and then the start_streaming method is called.
> 
> Thanks for addressing this.  But I do have to wonder if this flag is really
> necessary.  The effort to set a "they want to start streaming" flag and
> start things for real in buf_queue() is not *that* great; if doing so
> avoids causing failures in applications which are following the rules, it
> seems worth it.
> 
> >  	/*
> > +	 * If any buffers were queued before streamon,
> > +	 * we can now pass them to driver for processing.
> > +	 */
> > +	list_for_each_entry(vb, &q->queued_list, queued_entry)
> > +		__enqueue_in_driver(vb);
> > +
> > +	/*
> >  	 * Let driver notice that streaming state has been enabled.
> >  	 */
> >  	ret = call_qop(q, start_streaming, q);
> 
> I do still wonder why this is an issue - why not pass the buffers through
> to the driver at VIDIOC_QBUF time?  I assume there must be a reason for
> doing things this way, I'd like to understand what it is.

I want to delay giving the ownership of the buffers to the driver until it
is certain that start_streaming method will be called. This way I achieve
a well defined states of the queued buffers:

1. successful start_streaming() -> the driver is processing the queue buffers
2. unsuccessful start_streaming() -> the driver is responsible to discard all
   queued buffers
3. stop_streaming() called -> the driver has finished or discarded all queued
   buffers

If we assume that the buffers are given to the driver in QBUF then we need
to address somehow the following call sequence:

1. REQBUFS(n1) -> allocated n1 buffers
2. QBUF(buffer 1) -> gives buffer to the driver
3. QBUF(buffer 2) -> gives buffer to the driver
4. REQBUFS(n2) -> frees all buffers (driver still keeps 2 already queued
                  buffers) and allocates n2 new buffers

There is no way to tell the driver to discard the old buffers. Additional 
call to stop_streaming method might solve it, but I really don't like
to abuse it here if delaying the ownership transfer just solves the issue.

If you ask why there is a start_streaming callback at all then the reason 
is simple - I would like to have a single place in the driver, where the
streaming is started (streaming might be started as a result of STREAMON
ioctl, read() call or recently discussed poll()).

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


