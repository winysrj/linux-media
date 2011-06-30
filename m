Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:55062 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017Ab1F3WSG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2011 18:18:06 -0400
Date: Thu, 30 Jun 2011 16:18:03 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Pawel Osciak' <pawel@osciak.com>,
	'Uwe =?ISO-8859-1?B?S2xlaW5lLUv2bmlnJw==?=
	<u.kleine-koenig@pengutronix.de>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Marin Mitov' <mitov@issp.bas.bg>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Guennadi Liakhovetski' <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH/RFC] media: vb2: change queue initialization order
Message-ID: <20110630161803.04e1db20@bike.lwn.net>
In-Reply-To: <003501cc3666$5725a230$0570e690$%szyprowski@samsung.com>
References: <1309340946-5658-1-git-send-email-m.szyprowski@samsung.com>
	<20110629072627.10081454@bike.lwn.net>
	<003501cc3666$5725a230$0570e690$%szyprowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 29 Jun 2011 16:10:45 +0200
Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> > I do still wonder why this is an issue - why not pass the buffers through
> > to the driver at VIDIOC_QBUF time?  I assume there must be a reason for
> > doing things this way, I'd like to understand what it is.  
> 
> I want to delay giving the ownership of the buffers to the driver until it
> is certain that start_streaming method will be called. This way I achieve
> a well defined states of the queued buffers:
> 
> 1. successful start_streaming() -> the driver is processing the queue buffers
> 2. unsuccessful start_streaming() -> the driver is responsible to discard all
>    queued buffers
> 3. stop_streaming() called -> the driver has finished or discarded all queued
>    buffers

So it's a buffer ownership thing.  I wonder if there would be value in
adding a buf_give_them_all_back_now() callback?  You have an implicit
change of buffer ownership now that seems easy for drivers to mess up.  It
might be better to send an explicit signal at such times and, perhaps,
even require the driver to explicitly hand each buffer back to vb2?  That
would make the rules clear and give some flexibility - stopping and
starting streaming without needing to start over with buffers, for example.

Dunno, I'm just sort of babbling as I think; what's there now clearly
works.

Thanks,

jon
