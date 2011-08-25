Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50633 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab1HYNvB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Aug 2011 09:51:01 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LQH00JZNL4ZG0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Aug 2011 14:50:59 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LQH00F2QL4YG9@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Aug 2011 14:50:58 +0100 (BST)
Date: Thu, 25 Aug 2011 15:48:11 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH v2/RFC] media: vb2: change queue initialization order
In-reply-to: <20110825072717.6a0fa218@bike.lwn.net>
To: 'Jonathan Corbet' <corbet@lwn.net>
Cc: linux-media@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Pawel Osciak' <pawel@osciak.com>,
	=?iso-8859-2?Q?'Uwe_Kleine-K=F6nig'?=
	<u.kleine-koenig@pengutronix.de>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Marin Mitov' <mitov@issp.bas.bg>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Guennadi Liakhovetski' <g.liakhovetski@gmx.de>
Message-id: <022101cc632d$a11a8650$e34f92f0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1314269531-30080-1-git-send-email-m.szyprowski@samsung.com>
 <20110825072717.6a0fa218@bike.lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Thursday, August 25, 2011 3:27 PM Jonathan Corbet wrote:

> On Thu, 25 Aug 2011 12:52:11 +0200
> Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> 
> > This patch changes the order of operations during stream on call. Now the
> > buffers are first queued to the driver and then the start_streaming method
> > is called.
> 
> This seems good to me (I guess it should, since I'm the guy who griped
> about it before :).
> 
> > This resolves the most common case when the driver needs to know buffer
> > addresses to enable dma engine and start streaming. Additional parameters
> > to start_streaming and buffer_queue methods have been added to simplify
> > drivers code. The driver are now obliged to check if the number of queued
> > buffers is enough to enable hardware streaming. If not - it should return
> > an error. In such case all the buffers that have been pre-queued are
> > invalidated.
> 
> I'd suggest that drivers that worked in the old scheme, where the buffers
> arrived after the start_streaming() call, should continue to work.  Why
> not?

Such change might have some side effect - the logic in buf_queue usually
assumed that the code from start_streaming has been called earlier, so some
additional checks or changes might be needed.
 
> > Drivers that are able to start/stop streaming on-fly, can control dma
> > engine directly in buf_queue callback. In this case start_streaming
> > callback can be considered as optional. The driver can also assume that
> > after a few first buf_queue calls with zero 'streaming' parameter, the core
> > will finally call start_streaming callback.
> 
> This part I like a bit less.  In your patch, almost none of the changed
> drivers use that parameter.  start_streaming() is a significant state
> change, I don't think it's asking a lot of a driver to provide a callback
> and actually remember whether it's supposed to be streaming or not.

I would like to get some more comments on this. Usually this matters only to
the drivers that are able to be in streaming state without any buffers
(usually some camera capture interfaces), which might need to enable dma
engine from buf_queue callback. Other drivers only adds the buffer to the
internal list and don't care about streaming state at all.

> Beyond that, what happens to a driver without a start_streaming() callback
> if the application first queues all its buffers, then does its
> VIDIOC_STREAMON call?  I see:
> 
> > +	list_for_each_entry(vb, &q->queued_list, queued_entry)
> > +		__enqueue_in_driver(vb, 0);
> 
> (So we get streaming=0 for all queued buffers).
> 
> >  	/*
> >  	 * Let driver notice that streaming state has been enabled.
> >  	 */
> > -	ret = call_qop(q, start_streaming, q);
> > +	ret = call_qop(q, start_streaming, q, atomic_read(&q->queued_count));
> >  	if (ret) {
> >  		dprintk(1, "streamon: driver refused to start streaming\n");
> > +		__vb2_queue_cancel(q);
> >  		return ret;
> >  	}
> 
> The driver will have gotten all of the buffers with streaming=0, then will
> never get a call again; I don't think that will lead to the desired result.
> Am I missing something?

Hmmm. Looks that I missed something. The driver will need to ignore streaming
parameter in such case...

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


