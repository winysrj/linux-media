Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:38910 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbZCPTg3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 15:36:29 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] pxa_camera: Redesign DMA handling
References: <1236986240-24115-1-git-send-email-robert.jarzmik@free.fr>
	<1236986240-24115-2-git-send-email-robert.jarzmik@free.fr>
	<1236986240-24115-3-git-send-email-robert.jarzmik@free.fr>
	<1236986240-24115-4-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0903161153200.4409@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Mon, 16 Mar 2009 20:36:17 +0100
In-Reply-To: <Pine.LNX.4.64.0903161153200.4409@axis700.grange> (Guennadi Liakhovetski's message of "Mon\, 16 Mar 2009 12\:22\:34 +0100 \(CET\)")
Message-ID: <87hc1tdzv2.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> What is QIF? Do you mean Quick Capture Interface - QCI? I also see CIF 
> used in the datasheet, probably, for "Capture InterFace," but I don't see 
> QIF anywhere. Also, please explain the first time you use the 
> abbreviation. Also fix it in the commit message to patch 1/4.
OK, will replace with QCI, my bad.

And OK for all the other typos in pxa_camera.txt

>> +static void pxa_dma_update_sg_tail(struct pxa_camera_dev *pcdev,
>> +				   struct pxa_buffer *buf)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < pcdev->channels; i++)
>> +		pcdev->sg_tail[i] = buf->dmas[i].sg_cpu + buf->dmas[i].sglen;
>> +}
>> +
>> +static void pxa_dma_add_tail_buf(struct pxa_camera_dev *pcdev,
>> +				 struct pxa_buffer *buf)
>> +{
>> +	int i;
>> +	struct pxa_dma_desc *buf_last_desc;
>> +
>> +	for (i = 0; i < pcdev->channels; i++) {
>> +		buf_last_desc = buf->dmas[i].sg_cpu + buf->dmas[i].sglen;
>> +		buf_last_desc->ddadr = DDADR_STOP;
>> +
>> +		if (!pcdev->sg_tail[i])
>> +			continue;
>> +		pcdev->sg_tail[i]->ddadr = buf->dmas[i].sg_dma;
>> +	}
>> +
>> +	pxa_dma_update_sg_tail(pcdev, buf);
>
> pxa_dma_update_sg_tail is called only here, why not inline it and also put 
> inside one loop?
As for the inline, I'm pretty sure you know it is automatically done by gcc.

As for moving it inside the loop, that would certainly improve performance. Yet
I find it more readable/maintainable that way, and will leave it. But I won't be
bothered at all if you retransform it back to your view, that's up to you.

Cheers.

--
Robert
