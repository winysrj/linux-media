Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758827Ab2CTCCO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 22:02:14 -0400
Message-ID: <4F67E4FD.2070709@redhat.com>
Date: Mon, 19 Mar 2012 23:01:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, mchehab@infradead.org,
	kernel@pengutronix.de, Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] video: mx3_camera: Allocate camera object via kzalloc
References: <1329761467-14417-1-git-send-email-festevam@gmail.com> <Pine.LNX.4.64.1202201916410.2836@axis700.grange> <CAOMZO5AAeqHZFqpZYB_riSCQvCRSjQtR2EqpZvC5V3TRyzuWJQ@mail.gmail.com>
In-Reply-To: <CAOMZO5AAeqHZFqpZYB_riSCQvCRSjQtR2EqpZvC5V3TRyzuWJQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-02-2012 16:23, Fabio Estevam escreveu:
> On Mon, Feb 20, 2012 at 4:17 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
>> On Mon, 20 Feb 2012, Fabio Estevam wrote:
>>
>>> Align mx3_camera driver with the other soc camera driver implementations
>>> by allocating the camera object via kzalloc.
>>
>> Sorry, any specific reason, why you think this "aligning" is so important?
> 
> Not really.
> 
> Just compared it with all other soc camera drivers I found and
> mx3_camera was the only one that uses "vzalloc"
> 
> Any specific reason that requires mx3_camera to use "vzalloc" instead
> of "kzalloc"?

kzalloc() is more restrictive than vzalloc(). With v*alloc, it will allocate
a virtual memory area, with can be discontinuous, while kzalloc will get
a continuous area.

The DMA logic need to be prepared for virtual memory, if v*alloc() is used
(e. g. using videobuf2-vmalloc).

As it is currently including media/videobuf2-dma-contig.h, I this patch
makes sense on my eyes.

> 
> Tested with kzalloc and it worked fine on my mx31pdk.

If the driver is working with vzalloc, then maybe it is due to some arch-specific
implementation for v*alloc. It shouldn't be working like that.

Regards,
Mauro
> 
> Regards,
> 
> Fabio Estevam
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

