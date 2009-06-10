Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f200.google.com ([209.85.216.200]:61837 "EHLO
	mail-px0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbZFJPGY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 11:06:24 -0400
Received: by pxi38 with SMTP id 38so760545pxi.33
        for <linux-media@vger.kernel.org>; Wed, 10 Jun 2009 08:06:25 -0700 (PDT)
Subject: Re: how to mmap in  videobuf-dma-sg.c
From: "Figo.zhang" <figo1802@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <1242902911.12072.3.camel@myhost>
References: <1242881164.3824.2.camel@myhost>
	 <20090521073518.1c0c0a5b@pedra.chehab.org>
	 <1242902911.12072.3.camel@myhost>
Content-Type: text/plain
Date: Wed, 10 Jun 2009 23:06:20 +0800
Message-Id: <1244646380.15773.15.camel@myhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-05-21 at 18:48 +0800, Figo.zhang wrote:
> On Thu, 2009-05-21 at 07:35 -0300, Mauro Carvalho Chehab wrote:
> > Em Thu, 21 May 2009 12:46:04 +0800
> > "Figo.zhang" <figo1802@gmail.com> escreveu:
> > 
> > > hi,all,
> > >  I am puzzle that how to mmap ( V4L2_MEMORY_MMAP) in videobuf-dma-sg.c?
> > > 
> > > In this file, it alloc the momery using vmalloc_32() , and put this
> > > momery into sglist table,and then use dma_map_sg() to create sg dma at
> > > __videobuf_iolock() function. but in __videobuf_mmap_mapper(), i canot
> > > understand how it do the mmap? 
> > > why it not use the remap_vmalloc_range() to do the mmap?
> > 
> > The answer is simple: remap_vmalloc_range() is newer than videobuf code. This
> > part of the code was written back to kernel 2.4, and nobody cared to update it
> > to use those newer functions, and simplify its code.
> > 
> > If you want, feel free to propose some cleanups on it
> > 
> > 
> > 
> > Cheers,
> > Mauro
> 
> hi mauro,
> Thank you! 
> But i canot found the similar function code of remap_vmalloc_range() in
> the videobuf-dma-contig.c file. So i want to know the how is work in
> __videobuf_mmap_mapper() function?
> 
> 

hi mauro:
Thank you. But i still have a puzzle question about mmap() in
videobuf-dma-sg.c. I canot find how to remap the dma buffer
(which alloc by vmalloc_32()) to the vma area in
__videobuf_mmap_mapper()? 

there is my test driver code about dma-sg,it work well. i use
remap_pfn_range() to remap the dma buffer to vma area in mmap method.

so would you like to give me some detail about it?

Best Regards,

Figo.zhang


static int mydev_alloc_dma_sg(struct mydev_device *dev, struct mydev_buf
*buf)
{
	int nr_pages;
	
	int i;
	struct page *pg;
	unsigned char * virt;

	nr_pages = mydev_buffer_pages(buf->size);

	buf->nr_pages = nr_pages;

	dprintk("%s:: buf->nr_pages =%d\n", __func__, buf->nr_pages);
	
	buf->sglist = kcalloc(buf->nr_pages, sizeof(struct scatterlist),
GFP_KERNEL);
	if (NULL == buf->sglist)
		return NULL;
	
	sg_init_table(buf->sglist, buf->nr_pages);

	buf->vmalloc = vmalloc_32(buf->nr_pages << PAGE_SHIFT);

	memset(buf->vmalloc,0,buf->nr_pages << PAGE_SHIFT);

	virt = buf->vmalloc;
	
	for(i = 0; i< buf->nr_pages; i++,virt += PAGE_SIZE){
		pg = vmalloc_to_page(virt);
		if (NULL == pg)
			goto nopage;
		BUG_ON(PageHighMem(pg));
		sg_set_page(&buf->sglist[i], pg, PAGE_SIZE, 0);
		
		}

	buf->sglen = dma_map_sg(&dev->pci->dev, buf->sglist,
					buf->nr_pages, DMA_FROM_DEVICE);

	return 0;
	
 nopage:
	dprintk("sgl: oops - no page\n");
	kfree(buf->sglist);
	return 0;
}

in mmap();

static int do_mmap_sg(struct mydev_device  *dev, struct vm_area_struct *
vma)
{
	struct videobuf_mapping *map;
	unsigned long pos,page;
	unsigned long start = vma->vm_start;
	unsigned long size = vma->vm_end - vma->vm_start;
	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
	unsigned int first, last, end;

	int retval = -EINVAL;
	int i;

	/* look for first buffer to map */
	for (first = 0; first < VIDEO_MAX_FRAME; first++) {
	
		if (dev->ktbuf[first].boff == (vma->vm_pgoff << PAGE_SHIFT))
			break;
	}
	if (VIDEO_MAX_FRAME == first) {
		dprintk("mmap app bug: offset invalid [offset=0x%lx]\n",
			(vma->vm_pgoff << PAGE_SHIFT));
		goto done;
	}
	/* create mapping + update buffer list */
	retval = -ENOMEM;
	map = kmalloc(sizeof(struct videobuf_mapping),GFP_KERNEL);
	if (NULL == map)
		goto done;

		pos = (unsigned long)dev->ktbuf[first].vmalloc;

	while (size > 0) {
		page = vmalloc_to_pfn((void *)pos);
		if (remap_pfn_range(vma, start, page, PAGE_SIZE, PAGE_SHARED)) {
			return -EAGAIN;
		}
		start += PAGE_SIZE;
		pos += PAGE_SIZE;
		if (size > PAGE_SIZE)
			size -= PAGE_SIZE;
		else
			size = 0;
	}

	map->count    = 1;
	map->start    = vma->vm_start;
	map->end      = vma->vm_end;
	vma->vm_ops   = &mydev_vm_ops;
	vma->vm_flags |=/* VM_DONTEXPAND |*/ VM_RESERVED;
vma->vm_flags &= ~VM_IO; /* using shared anonymous pages */
	vma->vm_private_data = map;

	mydev_vm_open(vma);
	retval = 0;

 done:
	return retval;
}





