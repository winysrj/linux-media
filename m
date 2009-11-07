Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:49555 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbZKGQAK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Nov 2009 11:00:10 -0500
Received: by fg-out-1718.google.com with SMTP id e12so668353fga.1
        for <linux-media@vger.kernel.org>; Sat, 07 Nov 2009 08:00:14 -0800 (PST)
Message-ID: <4AF5998A.6060602@googlemail.com>
Date: Sat, 07 Nov 2009 17:00:10 +0100
From: e9hack <e9hack@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: bug in changeset 13239:54535665f94b ?
References: <4AEDB05E.1090704@googlemail.com>	<20091107104113.0df4593b@pedra.chehab.org>	<4AF57E8E.5070109@googlemail.com> <20091107124922.7fbf8445@pedra.chehab.org>
In-Reply-To: <20091107124922.7fbf8445@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab schrieb:
> Em Sat, 07 Nov 2009 15:05:02 +0100
> e9hack <e9hack@googlemail.com> escreveu:
> 
>> Mauro Carvalho Chehab schrieb:
>>
>>> I agree. We need first to stop DMA activity, and then release the page tables.
>>>
>>> Could you please test if the enclosed patch fixes the issue?
>> Hi Mauro,
>>
>> your patch doesn't solve the problem, because saa7146_dma_free() doesn't stop a running
>> dma transfer of the saa7146.
> 
> Well, it should be stopping it. The logic is to wait for an incoming dma
> transfer and then disable dma transfers:
> 
> void saa7146_dma_free(struct saa7146_dev *dev,struct videobuf_queue *q,
>                                                 struct saa7146_buf *buf)
> {
>         struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
>         DEB_EE(("dev:%p, buf:%p\n",dev,buf));
> 
>         BUG_ON(in_interrupt());
> 
>         videobuf_waiton(&buf->vb,0,0);
>         videobuf_dma_unmap(q, dma);
>         videobuf_dma_free(dma);
>         buf->vb.state = VIDEOBUF_NEEDS_INIT;
> }

In my case, videobuf_queue_cancel() is called previously. videobuf_queue_cancel() wakes up
all buffers, but it doesn't handle the currently by the saa7146 used buffer. queue->curr
points to this buffer. Waiting for an incoming dma transfer in saa7146_dma_free() has no
effect for such a buffer.

Regards,
Hartmut
