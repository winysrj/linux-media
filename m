Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705Ab2CTMxu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 08:53:50 -0400
Message-ID: <4F687DCA.4040509@redhat.com>
Date: Tue, 20 Mar 2012 09:53:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Fabio Estevam <festevam@gmail.com>, linux-media@vger.kernel.org,
	mchehab@infradead.org, kernel@pengutronix.de,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] video: mx3_camera: Allocate camera object via kzalloc
References: <1329761467-14417-1-git-send-email-festevam@gmail.com> <Pine.LNX.4.64.1202201916410.2836@axis700.grange> <CAOMZO5AAeqHZFqpZYB_riSCQvCRSjQtR2EqpZvC5V3TRyzuWJQ@mail.gmail.com> <4F67E4FD.2070709@redhat.com> <Pine.LNX.4.64.1203200851300.20315@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1203200851300.20315@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-03-2012 04:57, Guennadi Liakhovetski escreveu:
> On Mon, 19 Mar 2012, Mauro Carvalho Chehab wrote:
> 
>> Em 20-02-2012 16:23, Fabio Estevam escreveu:
>>> On Mon, Feb 20, 2012 at 4:17 PM, Guennadi Liakhovetski
>>> <g.liakhovetski@gmx.de> wrote:
>>>> On Mon, 20 Feb 2012, Fabio Estevam wrote:
>>>>
>>>>> Align mx3_camera driver with the other soc camera driver implementations
>>>>> by allocating the camera object via kzalloc.
>>>>
>>>> Sorry, any specific reason, why you think this "aligning" is so important?
>>>
>>> Not really.
>>>
>>> Just compared it with all other soc camera drivers I found and
>>> mx3_camera was the only one that uses "vzalloc"
>>>
>>> Any specific reason that requires mx3_camera to use "vzalloc" instead
>>> of "kzalloc"?
>>
>> kzalloc() is more restrictive than vzalloc(). With v*alloc, it will allocate
>> a virtual memory area, with can be discontinuous, while kzalloc will get
>> a continuous area.
>>
>> The DMA logic need to be prepared for virtual memory, if v*alloc() is used
>> (e. g. using videobuf2-vmalloc).
>>
>> As it is currently including media/videobuf2-dma-contig.h, I this patch
>> makes sense on my eyes.
> 
> Don't think so. vzalloc() is used in mx3_camera to allocate driver private 
> data objects and are never used for DMA, so, it doesn't have any 
> restrictions on contiguity, coherency, alignment etc.

OK. In this case, using v*alloc()/vfree() won't be that different than k*alloc()/k*free().

> One could argue, that since the struct is anyway smaller than 1 page, it 
> anyway will be allocated in a physically contiguous memory area (will it?) 
> and so, maybe, kmalloc() is less heavy weight than vmalloc() and might 
> save a couple of CPU cycles, but I don't think it's anything important, 
> that we should be optimising for.

Yes. 

There's another aspect to consider there: the vmalloc space is limited
(there's a boot time parameter to regulate its size)[1]. I dunno why, nor
what are the consequences of using a bigger value, but I think a big vmalloc
size creates a big table to map between virtual/physical memory space.

Yet, a single page is far below the vmaloc default max size,
except if the system has very severe memory constraints.

[1] On x86, I think that the default is 256MB. Several video adapters
eat a lot of space there. I use a bigger value here, otherwise my 3-head
system won't initialize all screens.

Regards,
Mauro
