Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:55706 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab1HYN1T (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Aug 2011 09:27:19 -0400
Date: Thu, 25 Aug 2011 07:27:17 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Uwe =?ISO-8859-1?B?S2xlaW5lLUv2bmln?=
	<u.kleine-koenig@pengutronix.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Marin Mitov <mitov@issp.bas.bg>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v2/RFC] media: vb2: change queue initialization order
Message-ID: <20110825072717.6a0fa218@bike.lwn.net>
In-Reply-To: <1314269531-30080-1-git-send-email-m.szyprowski@samsung.com>
References: <1314269531-30080-1-git-send-email-m.szyprowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 25 Aug 2011 12:52:11 +0200
Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> This patch changes the order of operations during stream on call. Now the
> buffers are first queued to the driver and then the start_streaming method
> is called.

This seems good to me (I guess it should, since I'm the guy who griped
about it before :).

> This resolves the most common case when the driver needs to know buffer
> addresses to enable dma engine and start streaming. Additional parameters
> to start_streaming and buffer_queue methods have been added to simplify
> drivers code. The driver are now obliged to check if the number of queued
> buffers is enough to enable hardware streaming. If not - it should return
> an error. In such case all the buffers that have been pre-queued are
> invalidated.

I'd suggest that drivers that worked in the old scheme, where the buffers
arrived after the start_streaming() call, should continue to work.  Why
not? 
 
> Drivers that are able to start/stop streaming on-fly, can control dma
> engine directly in buf_queue callback. In this case start_streaming
> callback can be considered as optional. The driver can also assume that
> after a few first buf_queue calls with zero 'streaming' parameter, the core
> will finally call start_streaming callback.

This part I like a bit less.  In your patch, almost none of the changed
drivers use that parameter.  start_streaming() is a significant state
change, I don't think it's asking a lot of a driver to provide a callback
and actually remember whether it's supposed to be streaming or not.

Beyond that, what happens to a driver without a start_streaming() callback
if the application first queues all its buffers, then does its
VIDIOC_STREAMON call?  I see:

> +	list_for_each_entry(vb, &q->queued_list, queued_entry)
> +		__enqueue_in_driver(vb, 0);

(So we get streaming=0 for all queued buffers).

>  	/*
>  	 * Let driver notice that streaming state has been enabled.
>  	 */
> -	ret = call_qop(q, start_streaming, q);
> +	ret = call_qop(q, start_streaming, q, atomic_read(&q->queued_count));
>  	if (ret) {
>  		dprintk(1, "streamon: driver refused to start streaming\n");
> +		__vb2_queue_cancel(q);
>  		return ret;
>  	}

The driver will have gotten all of the buffers with streaming=0, then will
never get a call again; I don't think that will lead to the desired result.
Am I missing something?

Thanks,

jon
