Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:50455 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab1F2N03 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 09:26:29 -0400
Date: Wed, 29 Jun 2011 07:26:27 -0600
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
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH/RFC] media: vb2: change queue initialization order
Message-ID: <20110629072627.10081454@bike.lwn.net>
In-Reply-To: <1309340946-5658-1-git-send-email-m.szyprowski@samsung.com>
References: <1309340946-5658-1-git-send-email-m.szyprowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 29 Jun 2011 11:49:06 +0200
Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> This patch introduces VB2_STREAMON_WITHOUT_BUFFERS io flag and changes
> the order of operations during stream on operation. Now the buffer are
> first queued to the driver and then the start_streaming method is called.

Thanks for addressing this.  But I do have to wonder if this flag is really
necessary.  The effort to set a "they want to start streaming" flag and
start things for real in buf_queue() is not *that* great; if doing so
avoids causing failures in applications which are following the rules, it
seems worth it.

>  	/*
> +	 * If any buffers were queued before streamon,
> +	 * we can now pass them to driver for processing.
> +	 */
> +	list_for_each_entry(vb, &q->queued_list, queued_entry)
> +		__enqueue_in_driver(vb);
> +
> +	/*
>  	 * Let driver notice that streaming state has been enabled.
>  	 */
>  	ret = call_qop(q, start_streaming, q);

I do still wonder why this is an issue - why not pass the buffers through
to the driver at VIDIOC_QBUF time?  I assume there must be a reason for
doing things this way, I'd like to understand what it is.

Thanks,

jon
