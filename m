Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:59773 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751510AbbKWIsg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2015 03:48:36 -0500
Subject: Re: Interrupt handler responsibility
To: Ran Shalit <ranshalit@gmail.com>, linux-media@vger.kernel.org
References: <CAJ2oMhL93kMM8i9Mc9ayRmtAkCyN1Stq2SRsjNpeLrVvR5DWNw@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5652D2DD.2040903@xs4all.nl>
Date: Mon, 23 Nov 2015 09:48:29 +0100
MIME-Version: 1.0
In-Reply-To: <CAJ2oMhL93kMM8i9Mc9ayRmtAkCyN1Stq2SRsjNpeLrVvR5DWNw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/21/2015 11:20 PM, Ran Shalit wrote:
> Hello,
> 
> I am trying to understand the interrupt handler responsibility in
> v4l2, also with respect to dma usage. I see that it is not defined as
> part of the videobuf2 API.
> 
> This is what I understand this far:
> 1. start_streaming is responsible for getting into "streaming" state.
> dma start should be trigggered at this point.

Right.

> 2. interrupt handler: is responsible for passing back the buffer to
> user using vb2_buffer_done() call.

Right.

> 
> But what is the exact reponsibility of interrupt handler with respect
> to dma usage  ?

Typically when the DMA has finished DMAing a frame it will generate an interrupt.
The interrupt handler will then call vb2_buffer_done() handing the buffer back
to the vb2 framework. Think of it as who owns the buffer: when buf_queue is called
the buffer is handed from vb2 to the driver, and the driver calls vb2_buffer_done()
when it is finished with the buffer (i.e. the data is DMAed into the buffer) and
it hands it back to vb2.

> In some of the drivers I see that the interrupt start/stop dma, but in
>  v4l2-pci-skeleton.c I don't see any usage of dma in the interrupt
> handler, so I'm not sure.

The interrupt handler is called in response of a DMA interrupt. How that interrupt
is generated is hardware specific, so that's why you don't see it in the skeleton
driver.

Regards,

	Hans
