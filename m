Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:60054 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3F0JZ7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jun 2013 05:25:59 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MP100M6JOTA0000@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 27 Jun 2013 10:25:57 +0100 (BST)
Message-id: <51CC0524.6020703@samsung.com>
Date: Thu, 27 Jun 2013 11:25:56 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>, John Sheu <sheu@google.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <k.debski@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [PATCH v4] [media] mem2mem: add support for hardware buffered queue
References: <1370247828-7219-1-git-send-email-p.zabel@pengutronix.de>
In-reply-to: <1370247828-7219-1-git-send-email-p.zabel@pengutronix.de>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/03/2013 10:23 AM, Philipp Zabel wrote:
> On mem2mem decoders with a hardware bitstream ringbuffer, to drain the
> buffer at the end of the stream, remaining frames might need to be decoded
> from the bitstream buffer without additional input buffers being provided.
> To achieve this, allow a queue to be marked as buffered by the driver, and
> allow scheduling of device_runs when buffered ready queues are empty.
> 
> This also allows a driver to copy input buffers into their bitstream
> ringbuffer and immediately mark them as done to be dequeued.
> 
> The motivation for this patch is hardware assisted h.264 reordering support
> in the coda driver. For high profile streams, the coda can hold back
> out-of-order frames, causing a few mem2mem device runs in the beginning, that
> don't produce any decompressed buffer at the v4l2 capture side. At the same
> time, the last few frames can be decoded from the bitstream with mem2mem device
> runs that don't need a new input buffer at the v4l2 output side. The decoder
> command ioctl can be used to put the decoder into the ringbuffer draining
> end-of-stream mode.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

--
Regards,
Sylwester
