Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:42036 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757115Ab1FQS5P (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2011 14:57:15 -0400
Date: Fri, 17 Jun 2011 12:57:13 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: vb2: holding buffers until after start_streaming()
Message-ID: <20110617125713.293f484d@bike.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Here's another videobuf2 question...I've been trying to track down some
weird behavior, the roots of which were in the fact that start_streaming()
gets called even though no buffers have been queued.  This behavior is
quite explicit in the code:

	/*
	 * Let driver notice that streaming state has been enabled.
	 */
	ret = call_qop(q, start_streaming, q);
	if (ret) {
		dprintk(1, "streamon: driver refused to start streaming\n");
		return ret;
	}

	q->streaming = 1;

	/*
	 * If any buffers were queued before streamon,
	 * we can now pass them to driver for processing.
	 */
	list_for_each_entry(vb, &q->queued_list, queued_entry)
		__enqueue_in_driver(vb);

Pretty much every v4l2 capture application I've ever encountered passes all
of its buffers to VIDIOC_QBUF before starting streaming for a reason - it
makes little sense to start if there's nothing to stream to.  It's really
tempting to reorder that code, but...  it seems you must have done things
this way for a reason.  Why did you need to reorder the operations in this
way?

(Yes, my driver's current tendency to go oops when start_streaming() gets
called with no buffers is a bug, I'll fix it regardless).

Thanks,

jon
