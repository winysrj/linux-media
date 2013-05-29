Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:64194 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965107Ab3E2JyP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 05:54:15 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNK00I9M0SZ7J20@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 May 2013 10:54:13 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Philipp Zabel' <p.zabel@pengutronix.de>,
	linux-media@vger.kernel.org
Cc: 'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	'Pawel Osciak' <pawel@osciak.com>,
	'John Sheu' <sheu@google.com>,
	'Hans Verkuil' <hans.verkuil@cisco.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
References: <1369217856-10385-1-git-send-email-p.zabel@pengutronix.de>
In-reply-to: <1369217856-10385-1-git-send-email-p.zabel@pengutronix.de>
Subject: RE: [RFC] [media] mem2mem: add support for hardware buffered queue
Date: Wed, 29 May 2013 11:54:05 +0200
Message-id: <01f401ce5c52$75dcee90$6196cbb0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp, Hans,

> On mem2mem decoders with a hardware bitstream ringbuffer, to drain the
> buffer at the end of the stream, remaining frames might need to be
> decoded without additional input buffers being provided, and after
> calling streamoff on the v4l2 output queue. This also allows a driver
> to copy input buffers into their bitstream ringbuffer and immediately
> mark them as done to be dequeued.
> 
> The motivation for this patch is hardware assisted h.264 reordering
> support in the coda driver. For high profile streams, the coda can hold
> back out-of-order frames, causing a few mem2mem device runs in the
> beginning, that don't produce any decompressed buffer at the v4l2
> capture side. At the same time, the last few frames can be decoded from
> the bitstream with mem2mem device runs that don't need a new input
> buffer at the v4l2 output side. A streamoff on the v4l2 output side can
> be used to put the decoder into the ringbuffer draining end-of-stream
> mode.

If I remember correctly the main goal of introducing the m2m framework
was to support simple mem2mem devices where one input buffer = one output
buffer. In other cases m2m was not to be used. 

An example of such mem2mem driver, which does not use m2m framework is
MFC. It uses videobuf2 directly and it is wholly up to the driver how
will it control the queues, stream on/off and so on. You can then have
one OUTPUT buffer generate multiple CAPTURE buffer, multiple OUTPUT
buffers generate a single CAPTURE buffer. Consume OUTPUT buffer without
generating CAPTURE buffer (e.g. when starting decoding) and produce
CAPTURE buffers without consuming OUTPUT buffers (e.g. when finishing
decoding).

I think that stream off should not be used to signal EOS. For this we
have EOS event. You mentioned the EOS buffer flag. This is the idea
originally proposed by Andrzej Hajda, after some lengthy discussions
with v4l community this idea was changed to use an EOS event.

I was all for the EOS buffer flag, but after discussion with Mauro I
understood his arguments. We can get back to this discussion, if we
are sure that events are not enough. Please also note that we need to
keep backward compatibility.

Original EOS buffer flag patches by Andrzej and part of the discussion
can be found here:
1) https://linuxtv.org/patch/10624/
2) https://linuxtv.org/patch/11373/

Best wishes,
Kamil Debski


