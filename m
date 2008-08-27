Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7R9f6xM008694
	for <video4linux-list@redhat.com>; Wed, 27 Aug 2008 05:41:06 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.172])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7R9f4fG031733
	for <video4linux-list@redhat.com>; Wed, 27 Aug 2008 05:41:04 -0400
Received: by wf-out-1314.google.com with SMTP id 25so2393552wfc.6
	for <video4linux-list@redhat.com>; Wed, 27 Aug 2008 02:41:03 -0700 (PDT)
Message-ID: <aec7e5c30808270241x12bac614lc573293ce84d608e@mail.gmail.com>
Date: Wed, 27 Aug 2008 18:41:03 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Geert Uytterhoeven" <geert@linux-m68k.org>
In-Reply-To: <Pine.LNX.4.64.0808262035310.7910@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080814195522.ad74990c.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0808262035310.7910@anakin>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Mundt <lethal@linux-sh.org>, video4linux-list@redhat.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] VIDEO_SH_MOBILE_CEU should depend on HAS_DMA (was: Re:
	m68k allmodconfig)
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

On Wed, Aug 27, 2008 at 4:37 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>        Hi Andrew,
>
> On Thu, 14 Aug 2008, Andrew Morton wrote:
>> ERROR: "dma_alloc_coherent" [drivers/media/video/videobuf-dma-contig.ko] undefined!
>> ERROR: "dma_sync_single_for_cpu" [drivers/media/video/videobuf-dma-contig.ko] undefined!
>> ERROR: "dma_free_coherent" [drivers/media/video/videobuf-dma-contig.ko] undefined!
>
> M68k allmodconfig still selects Sun-3, which sets NO_DMA.
> I guess you're also seeing this on the other NO_DMA platforms (h8300, m32r,
> s390, and PCI-less SPARC)?
>
> Below is a patch.
>
> Shouldn't it also (or instead) depend on SUPERH or some SuperH platform?
> Or is this not done to have more compile-coverage?
>
> Subject: [PATCH] VIDEO_SH_MOBILE_CEU should depend on HAS_DMA
>
> commit 0d3244d6439c8c31d2a29efd587c7aca9042c8aa ("V4L/DVB (8342):
> sh_mobile_ceu_camera: Add SuperH Mobile CEU driver V3") introduced
> VIDEO_SH_MOBILE_CEU, which selects VIDEOBUF_DMA_CONTIG. This circumvents the
> dependency on HAS_DMA of VIDEOBUF_DMA_CONTIG.
>
> Add a dependency on HAS_DMA to VIDEO_SH_MOBILE_CEU to fix this.

Thank you!

> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Magnus Damm <damm@igel.co.jp>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
