Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:23075 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab1FTIU4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 04:20:56 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LN200ALVXUVY870@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 20 Jun 2011 09:20:55 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LN200JMBXUUUE@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 20 Jun 2011 09:20:54 +0100 (BST)
Date: Mon, 20 Jun 2011 10:20:53 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: vb2: holding buffers until after start_streaming()
In-reply-to: <20110617125713.293f484d@bike.lwn.net>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org
Message-id: <4DFF02E5.8030601@samsung.com>
References: <20110617125713.293f484d@bike.lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Jon

On 06/17/2011 08:57 PM, Jonathan Corbet wrote:
> Here's another videobuf2 question...I've been trying to track down some
> weird behavior, the roots of which were in the fact that start_streaming()
> gets called even though no buffers have been queued.  This behavior is
> quite explicit in the code:
> 
> 	/*
> 	 * Let driver notice that streaming state has been enabled.
> 	 */
> 	ret = call_qop(q, start_streaming, q);
> 	if (ret) {
> 		dprintk(1, "streamon: driver refused to start streaming\n");
> 		return ret;
> 	}
> 
> 	q->streaming = 1;
> 
> 	/*
> 	 * If any buffers were queued before streamon,
> 	 * we can now pass them to driver for processing.
> 	 */
> 	list_for_each_entry(vb, &q->queued_list, queued_entry)
> 		__enqueue_in_driver(vb);
> 
> Pretty much every v4l2 capture application I've ever encountered passes all
> of its buffers to VIDIOC_QBUF before starting streaming for a reason - it
> makes little sense to start if there's nothing to stream to.  It's really
> tempting to reorder that code, but...  it seems you must have done things
> this way for a reason.  Why did you need to reorder the operations in this
> way?

AFAIR one of main reasons for doing the operations in that order was to
create consistent conditions for the drivers, regardless of the call sequence
in the user space.

You may find more information in this thread:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg29348.html


--
Regards,
Sylwester
