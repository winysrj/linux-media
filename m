Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6F8SNKm025443
	for <video4linux-list@redhat.com>; Tue, 15 Jul 2008 04:28:23 -0400
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.183])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6F8SCVg027442
	for <video4linux-list@redhat.com>; Tue, 15 Jul 2008 04:28:12 -0400
Received: by py-out-1112.google.com with SMTP id a29so2820479pyi.0
	for <video4linux-list@redhat.com>; Tue, 15 Jul 2008 01:28:12 -0700 (PDT)
Message-ID: <aec7e5c30807150128p4a4d3ec6v64bf7e98af6b0469@mail.gmail.com>
Date: Tue, 15 Jul 2008 17:28:12 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>, "Magnus Damm" <magnus.damm@gmail.com>,
	"Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	"Paulius Zaleckas" <paulius.zaleckas@teltonika.lt>,
	video4linux-list@redhat.com, linux-sh@vger.kernel.org
In-Reply-To: <20080715034850.GA3722@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080705025335.27137.98068.sendpatchset@rx1.opensource.se>
	<20080705025405.27137.16206.sendpatchset@rx1.opensource.se>
	<48737AA3.3080902@teltonika.lt>
	<Pine.LNX.4.64.0807112307570.26439@axis700.grange>
	<aec7e5c30807132051r16e51d71w177e410063ccefb@mail.gmail.com>
	<20080715034850.GA3722@linux-sh.org>
Cc: 
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

On Tue, Jul 15, 2008 at 12:48 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> On Mon, Jul 14, 2008 at 12:51:55PM +0900, Magnus Damm wrote:
>> Both (__pa(mem->vaddr) >> PAGE_SHIFT) and (mem->dma_handle >>
>> PAGE_SHIFT) work well with the current dma_alloc_coherent()
>> implementation on SuperH. I do however lean towards using
>> __pa(mem->vaddr) over mem->dma_handle, since I suspect that
>> mem->dma_handle doesn't have to be a physical address.
>>
>> Paul, any thoughts about this? Can we assume that the dma_handle
>> returned from dma_alloc_coherent() is a physical address, or is it
>> better to use __pa() on the virtual address to get the pfn?
>>
> It's a physical address as far as the dma_handle users are concerned, how
> that actually translates across the bus is another matter. (The corner
> cases end up being things like Cell that DMA in to virtual addresses via
> IOMMU translations).
>
> Documentation/DMA-API.txt simply states:
>
>        This routine allocates a region of <size> bytes of consistent memory.
>        It also returns a <dma_handle> which may be cast to an unsigned
>        integer the same width as the bus and used as the physical address
>        base of the region.
>
> so as far as we are concerned, using dma_handle is saner than going the __pa()
> route.

Ok, thanks for the clarification. V3 should be correct already then. I
guess I mixed up the regular dma handle with the bus address of
dma_declare_coherent_memory(). =)

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
