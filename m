Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39616 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751458AbZCIXOk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2009 19:14:40 -0400
Date: Tue, 10 Mar 2009 00:14:40 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/4] pxa_camera: Redesign DMA handling
In-Reply-To: <87sklms9ni.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0903092310510.5857@axis700.grange>
References: <1236282351-28471-1-git-send-email-robert.jarzmik@free.fr>
 <1236282351-28471-2-git-send-email-robert.jarzmik@free.fr>
 <1236282351-28471-3-git-send-email-robert.jarzmik@free.fr>
 <Pine.LNX.4.64.0903091023540.3992@axis700.grange> <87sklms9ni.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'll answer all points tomorrow, but so you can start thinking about it 
earlier and get used to it:-), I'll explain the current driver behaviour 
now:

On Mon, 9 Mar 2009, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > before your patch
> >
> > sg_tail points to the last real DMA descriptor
> > the last real DMA descriptor has DDADR_STOP
> > on queuing of the next buffer we
> >  1. stop DMA
> >  2. link the last real descriptor to the new first descriptor
> >  3. allocate an additional dummy descriptor, fill it with DMA engine's 
> > 	current state and use it to
> >  4. re-start DMA
> Yes, but you forget :
>    5. link the last new buffer descriptor (the called dummy buffer) to the
>    running chain.
> 
> I see it that way, after former pxa_video_queue() :
> 
>  +----------+-----------+------------+
>  | First vb | Second vb | Third vb | |
>  +----^-----+-----------+-----------|+
>       |                             |      +----------------+
>       |                             +----> | New vb | dummy |
>       |                                    +------------|---+
>       |                                                 |
>       +-------------------------------------------------+
> 
> This is my understanding. The DMA is restarted at the dummy descriptor, which
> re-reads the current DMA descriptor (is that correct, if 16 bytes were already
> transfered ?), then comes back to the head of DMA chain.
> Then first vb is finished, then second and third, and then new vb is re-filled.
> 
> Would you comment to see where I'm wrong please ?

IIUYC, you mean, that the dummy descriptor re-starts the interrupted 
transfer from the beginning. This is wrong:

With the current code, let's say we capture frames 80x60=4800 at 1 byte 
per pixel - monochrome or Bayer. Then we allocate 3 sg-elements:

static int pxa_init_dma_channel()
{
	...
	pxa_dma->sg_size = (sglen + 1) * sizeof(struct pxa_dma_desc);
	pxa_dma->sg_cpu = dma_alloc_coherent(pcdev->dev, pxa_dma->sg_size,
					     &pxa_dma->sg_dma, GFP_KERNEL);
	...

and they are initialised

	pxa_dma->sg_cpu[0].dsadr = pcdev->res->start + cibr;
	pxa_dma->sg_cpu[0].dtadr = sg_dma_address(&sg[0]);

	pxa_dma->sg_cpu[0].dcmd =
		DCMD_FLOWSRC | DCMD_BURST8 | DCMD_INCTRGADDR | 4096;
	pxa_dma->sg_cpu[0].ddadr =
		pxa_dma->sg_dma + sizeof(struct pxa_dma_desc);

	pxa_dma->sg_cpu[1].dsadr = pcdev->res->start + cibr;
	pxa_dma->sg_cpu[1].dtadr = sg_dma_address(&sg[1]);

	pxa_dma->sg_cpu[1].dcmd =
		DCMD_FLOWSRC | DCMD_BURST8 | DCMD_INCTRGADDR | 704;
	pxa_dma->sg_cpu[1].ddadr =
		pxa_dma->sg_dma + 2 * sizeof(struct pxa_dma_desc);

	pxa_dma->sg_cpu[1].ddadr = DDADR_STOP;
	pxa_dma->sg_cpu[1].dcmd |= DCMD_ENDIRQEN;

Notice, sg_cpu[2] (the dummy) is not used yet. So, in normal case the DMA 
engine would process 0, 1, and stop.

}

Now, as this buffer is queued in
let's say, the previou

pxa_videobuf_queue()
{
	...

With locked interrupts we stop the DMA engine, and hope, that there's 
still enough space in the FIFO left and that we won't be getting an 
overrun...

	/* Stop DMA engine */
	DCSR(pcdev->dma_chans[i]) = 0;

>From now on we have to be fast until we re-enable DMA.

	/* Add the descriptors we just initialized to
	   the currently running chain */
	pcdev->sg_tail[i]->ddadr = buf_dma->sg_dma;
	pcdev->sg_tail[i] = buf_dma->sg_cpu + buf_dma->sglen - 1;

See, sg_tail is set to point to the last valid (not dummy) PXA DMA 
descriptor, i.e., to sg_cpu[1] in our example. So, before it also pointed 
to the last valid descriptor from the previous buffer, which now links to 
the beginning of our new buffer.

Now, this is the trick: we use a dummy descriptor (actually, the one from 
the new video buffer, but it doesn't matter) to set up a descriptor to 
finish the interrupted transfer. For this we set dtadr to the _current_ 
DTADR to continue filling the buffer exactly where we stopped.

	/* Setup a dummy descriptor with the DMA engines current
	 * state
	 */
	buf_dma->sg_cpu[nents].dsadr =
		pcdev->res->start + 0x28 + i*8; /* CIBRx */
	buf_dma->sg_cpu[nents].dtadr =
		DTADR(pcdev->dma_chans[i]);
	buf_dma->sg_cpu[nents].dcmd =
		DCMD(pcdev->dma_chans[i]);

Now we just check where we should link this our linking partial transfer 
descriptor - either to the first descriptor in our new buffer, if DMA was 
currently processing the last descriptor currently queued, or to the same 
descriptor to which it used to be linked.

	if (DDADR(pcdev->dma_chans[i]) == DDADR_STOP) {
		/* The DMA engine is on the last
		   descriptor, set the next descriptors
		   address to the descriptors we just
		   initialized */
		buf_dma->sg_cpu[nents].ddadr = buf_dma->sg_dma;
	} else {
		buf_dma->sg_cpu[nents].ddadr =
			DDADR(pcdev->dma_chans[i]);
	}

Now we restart DMA at our "dummy" descriptor. Actually, it is not dummy 
any more, it is "linking," "partial," or whatever you call it.

	/* The next descriptor is the dummy descriptor */
	DDADR(pcdev->dma_chans[i]) = buf_dma->sg_dma + nents *
		sizeof(struct pxa_dma_desc);

	DCSR(pcdev->dma_chans[i]) = DCSR_RUN;

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
