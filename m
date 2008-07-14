Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6E3qBGc003328
	for <video4linux-list@redhat.com>; Sun, 13 Jul 2008 23:52:11 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6E3q0aS026565
	for <video4linux-list@redhat.com>; Sun, 13 Jul 2008 23:52:00 -0400
Received: by yw-out-2324.google.com with SMTP id 5so2027063ywb.81
	for <video4linux-list@redhat.com>; Sun, 13 Jul 2008 20:51:55 -0700 (PDT)
Message-ID: <aec7e5c30807132051r16e51d71w177e410063ccefb@mail.gmail.com>
Date: Mon, 14 Jul 2008 12:51:55 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0807112307570.26439@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080705025335.27137.98068.sendpatchset@rx1.opensource.se>
	<20080705025405.27137.16206.sendpatchset@rx1.opensource.se>
	<48737AA3.3080902@teltonika.lt>
	<Pine.LNX.4.64.0807112307570.26439@axis700.grange>
Cc: video4linux-list@redhat.com,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 03/04] videobuf: Add physically contiguous queue code V2
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Sat, Jul 12, 2008 at 6:33 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Tue, 8 Jul 2008, Paulius Zaleckas wrote:
>
>> Magnus Damm wrote:
>> > This is V2 of the physically contiguous videobuf queues patch.
>> > Useful for hardware such as the SuperH Mobile CEU which doesn't
>> > support scatter gatter bus mastering.
>
> [snip]
>
>> > +   /* Try to remap memory */
>> > +
>> > +   size = vma->vm_end - vma->vm_start;
>> > +   size = (size < mem->size) ? size : mem->size;
>> > +
>> > +   vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>> > +   retval = remap_pfn_range(vma, vma->vm_start,
>> > +                            __pa(mem->vaddr) >> PAGE_SHIFT,
>>
>> __pa(mem->vaddr) doesn't work on ARM architecture... It is a long story
>> about handling memory allocations and mapping for ARM (there is
>> dma_mmap_coherent to deal with this), but there is a workaround:
>>
>> mem->dma_handle >> PAGE_SHIFT,
>>
>> It is safe to do it this way and also saves some CPU instructions :)
>
> Paulius, even if the story is so long, could you perhaps point us to some
> ML-threads or elaborate a bit? I did find one example in
> drivers/media/video/atmel-isi.c (not in mainline), just would be
> interesting to find out more.
>
> Magnus, have you investigated this further?

Both (__pa(mem->vaddr) >> PAGE_SHIFT) and (mem->dma_handle >>
PAGE_SHIFT) work well with the current dma_alloc_coherent()
implementation on SuperH. I do however lean towards using
__pa(mem->vaddr) over mem->dma_handle, since I suspect that
mem->dma_handle doesn't have to be a physical address.

Paul, any thoughts about this? Can we assume that the dma_handle
returned from dma_alloc_coherent() is a physical address, or is it
better to use __pa() on the virtual address to get the pfn?

Thanks,

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
