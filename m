Return-path: <linux-media-owner@vger.kernel.org>
Received: from wmproxy2-g27.free.fr ([212.27.42.92]:18688 "EHLO
	wmproxy2-g27.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbZCJJMJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 05:12:09 -0400
Date: Tue, 10 Mar 2009 10:11:51 +0100 (CET)
From: robert.jarzmik@free.fr
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <1871633271.2933441236676310985.JavaMail.root@zimbra20-e3.priv.proxad.net>
In-Reply-To: <1817982448.2932771236676188034.JavaMail.root@zimbra20-e3.priv.proxad.net>
Subject: Re: [PATCH 2/4] pxa_camera: Redesign DMA handling
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

----- Mail Original -----
De: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
À: "Robert Jarzmik" <robert.jarzmik@free.fr>
Cc: mike@compulab.co.il, "Linux Media Mailing List" <linux-media@vger.kernel.org>
Envoyé: Mardi 10 Mars 2009 00h14:40 GMT +01:00 Amsterdam / Berlin / Berne / Rome / Stockholm / Vienne
Objet: Re: [PATCH 2/4] pxa_camera: Redesign DMA handling

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

> IIUYC, you mean, that the dummy descriptor re-starts the interrupted 
> transfer from the beginning. This is wrong:
OK, I understand better now.

> With the current code, let's say we capture frames 80x60=4800 at 1 byte 
> per pixel - monochrome or Bayer. Then we allocate 3 sg-elements:
Okay, thanks, I understand the explanation.

>	/* Add the descriptors we just initialized to
>	   the currently running chain */
>	pcdev->sg_tail[i]->ddadr = buf_dma->sg_dma;
>	pcdev->sg_tail[i] = buf_dma->sg_cpu + buf_dma->sglen - 1;
>
>See, sg_tail is set to point to the last valid (not dummy) PXA DMA 
>descriptor, i.e., to sg_cpu[1] in our example. So, before it also pointed 
>to the last valid descriptor from the previous buffer, which now links to 
>the beginning of our new buffer.

>Now, this is the trick: we use a dummy descriptor (actually, the one from 
>the new video buffer, but it doesn't matter) to set up a descriptor to 
                                        \
                                         -> that doesn't seem right to me

Have a look at the schema I drew. The DMA restarts at the dummy descriptor,
which finishes the "partial" page transfer interrupted, and resumes at 
"first vb". OK, let's assume this works perfectly. Then the buffer 
"first vb", "second vb", "third vb" are processed. But the DMA chain doesn't
 stop, it continues to the "dummy" descritor, then jumps back in the middle
of "first vb", and corrupts it, doesn't it ?

Now consider the "first vb" was unqueued _and_ requeued in the meantime, while
the "new buffer" was under DMA active filling.
Won't we finish with something like :

+-----------------------+  +------------------+
| Former New vb | dummy |  | First vb | dummy |
+-------^-----------|---+  +----^-----+---|---+
        |           |           |         |
        |           +-----------+         |
        |            former link          |
        |                                 |
        |                                 |
        +---------------------------------+
                  new restarter link

> Now we restart DMA at our "dummy" descriptor. Actually, it is not dummy 
> any more, it is "linking," "partial," or whatever you call it.
OK. That's good, now I understand it. I will try to reproduce your DMA link
architecture, because as it is, I don't yet understand why capture_example
fails ...

Would you mind if I changed the pxa descriptors chain for _one_ video buffer into :
 +-----------+------------+------------+-----+---------------+-----------------+
 | restarter | desc-sg[0] | desc-sg[1] | ... | desc-sg[last] | finisher/linker |
 +-----------+------------+------------+-----+---------------+-----------------+
where :
 - desc-sg[n] are descriptors to fill in the image
 - finisher/linker is either the DMA STOP, or just a 0 bytes transfer with next 
   descriptor set up to the desc-sg[0] of the next captured frame
 - restarter is never used (ie. DMA chains start always at desc-sg[0]), excepting
   when restarting a running chain

I know I ask for 1 additionnal descriptor, but I find that easier to maintain.
Would you agree for such a change ?

Cheers.

--
Robert
