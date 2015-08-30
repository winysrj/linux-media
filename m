Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:16628 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbbH3TjY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2015 15:39:24 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] media: pxa_camera: conversion to dmaengine
References: <1438198744-6150-1-git-send-email-robert.jarzmik@free.fr>
	<1438198744-6150-5-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.1508301440460.29683@axis700.grange>
Date: Sun, 30 Aug 2015 21:34:54 +0200
In-Reply-To: <Pine.LNX.4.64.1508301440460.29683@axis700.grange> (Guennadi
	Liakhovetski's message of "Sun, 30 Aug 2015 14:55:04 +0200 (CEST)")
Message-ID: <87613w1sf5.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

>> +	last_buf = list_entry(pcdev->capture.prev,
>> +			      struct pxa_buffer, vb.queue);
>
> You can use list_last_entry()
Ok.

>> +	last_status = dma_async_is_tx_complete(pcdev->dma_chans[chan],
>> +					       last_buf->cookie[chan],
>> +					       NULL, &last_issued);
>> +	if (camera_status & overrun &&
>> +	    last_status != DMA_COMPLETE) {
>> +		dev_dbg(dev, "FIFO overrun! CISR: %x\n",
>> +			camera_status);
>> +		pxa_camera_stop_capture(pcdev);
>> +		list_for_each_entry(buf, &pcdev->capture, vb.queue)
>> +			pxa_dma_add_tail_buf(pcdev, buf);
>
> Why have you added this loop? Is it a bug in the current implementation or 
> is it only needed with the switch to dmaengine?
It's a consequence of the switch.

With dmaengine, a dmaengine_terminate_all() removes all queued txs. It is
therefore necessary to requeue them. In the previous implementation, the
chaining was still good, and it was "enough" to just queue the first
videobuffer : the other buffers would follow by chaining.

Cheers.

-- 
Robert
