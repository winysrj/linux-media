Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:45890 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbZCKUYf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 16:24:35 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/4] pxa_camera: Redesign DMA handling
References: <1236282351-28471-1-git-send-email-robert.jarzmik@free.fr>
	<1236282351-28471-2-git-send-email-robert.jarzmik@free.fr>
	<1236282351-28471-3-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0903091023540.3992@axis700.grange>
	<87sklms9ni.fsf@free.fr>
	<Pine.LNX.4.64.0903092310510.5857@axis700.grange>
	<87r615hwzb.fsf@free.fr>
	<Pine.LNX.4.64.0903111313320.4818@axis700.grange>
	<87k56vyhc3.fsf@free.fr>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Wed, 11 Mar 2009 21:24:22 +0100
In-Reply-To: <87k56vyhc3.fsf@free.fr> (Robert Jarzmik's message of "Wed\, 11 Mar 2009 20\:45\:00 +0100")
Message-ID: <87vdqfiz9l.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Robert Jarzmik <robert.jarzmik@free.fr> writes:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
>
>>> +	for (i = 0; i < pcdev->channels; i++) {
>>> +		pcdev->sg_tail[i] = buf->dmas[i].sg_cpu + buf->dmas[i].sglen;
>>> +		pcdev->sg_tail[i]->ddadr = DDADR_STOP;
>
>> This function is now called "live" with running DMA, and you first append 
>> the chain, and only then terminate it... It should be ok because it is 
>> done with switched off IRQs, and DMA must be still at tail - 1 to 
>> automatically continue onto the appended chain, so, you should have enough 
>> time in 100% of cases, still it would look better to first terminate the 
>> chain and then append it.

> Correct. I'll invert the 2 assignments.

At second thought, I think I'll change this. The first assignment doesn't append
the chain, it just moves where sg_tail points at. The "chain append" was
previously done in "pxa_dma_add_tail_buf".

So the correct thing to do is to displace the "DDADR_STOP" assignment into
"pxa_dma_add_tail_buf", to make the "STOP" on the last descriptor of the newest
tail buffer. This "STOP" should be set up _before_ the buffer is queued.

I'll amend that.

Cheers.

--
Robert
