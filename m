Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40245 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab2FGAhH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2012 20:37:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	g.liakhovetski@gmx.de
Subject: Re: [PATCH 04/12] v4l: vb2-dma-contig: add setup of sglist for MMAP buffers
Date: Thu, 07 Jun 2012 02:36:59 +0200
Message-ID: <3066605.JkMnQZX3Q6@avalon>
In-Reply-To: <4FCF457A.9000201@samsung.com>
References: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com> <2101386.6sj5B2hAyl@avalon> <4FCF457A.9000201@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Wednesday 06 June 2012 13:56:42 Tomasz Stanislawski wrote:
> On 06/06/2012 10:06 AM, Laurent Pinchart wrote:
> > On Wednesday 23 May 2012 15:07:27 Tomasz Stanislawski wrote:
> >> This patch adds the setup of sglist list for MMAP buffers.
> >> It is needed for buffer exporting via DMABUF mechanism.
> >> 
> >> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> ---
> >> 
> >>  drivers/media/video/videobuf2-dma-contig.c |   70 +++++++++++++++++++++-
> >>  1 file changed, 68 insertions(+), 2 deletions(-)
> >> 
> >> diff --git a/drivers/media/video/videobuf2-dma-contig.c
> >> b/drivers/media/video/videobuf2-dma-contig.c index 52b4f59..ae656be
> >> 100644
> >> --- a/drivers/media/video/videobuf2-dma-contig.c
> >> +++ b/drivers/media/video/videobuf2-dma-contig.c

[snip]

> >> +static int vb2_dc_kaddr_to_pages(unsigned long kaddr,
> >> +	struct page **pages, unsigned int n_pages)
> >> +{
> >> +	unsigned int i;
> >> +	unsigned long pfn;
> >> +	struct vm_area_struct vma = {
> >> +		.vm_flags = VM_IO | VM_PFNMAP,
> >> +		.vm_mm = current->mm,
> >> +	};
> >> +
> >> +	for (i = 0; i < n_pages; ++i, kaddr += PAGE_SIZE) {
> > 
> > The follow_pfn() kerneldoc mentions that it looks up a PFN for a user
> > address. The only users I've found in the kernel sources pass a user
> > address. Is it legal to use it for kernel addresses ?
> 
> It is not completely legal :). As I understand the mm code, the follow_pfn
> works only for IO/PFN mappings. This is the typical case (every case?) of
> mappings created by dma_alloc_coherent.
> 
> In order to make this function work for a kernel pointer, one has to create
> an artificial VMA that has IO/PFN bits on.
> 
> This solution is a hack-around for dma_get_pages (aka dma_get_sgtable). This
> way the dependency on dma_get_pages was broken giving a small hope of
> merging vb2 exporting.
> 
> Marek prepared a patchset 'ARM: DMA-mapping: new extensions for buffer
> sharing' that adds dma buffers with no kernel mappings and dma_get_sgtable
> function.
> 
> However this patchset is still in a RFC state.

That's totally understood :-) I'm fine with keeping the hack for now until the 
dma_get_sgtable() gets in a usable/mergeable state, please just mention it in 
the code with something like

/* HACK: This is a temporary workaround until the dma_get_sgtable() function 
becomes available. */

> I have prepared a patch that removes vb2_dc_kaddr_to_pages and substitutes
> it with dma_get_pages. It will become a part of vb2-exporter patches just
> after dma_get_sgtable is merged (or at least acked by major maintainers).

-- 
Regards,

Laurent Pinchart

