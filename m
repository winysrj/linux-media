Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:41276 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279Ab0BXFhk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2010 00:37:40 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Muralidharan Karicheri <mkaricheri@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>
Date: Wed, 24 Feb 2010 11:07:35 +0530
Subject: RE: [PATCH-V1 09/10] VPFE Capture: Add support for USERPTR mode of
 	operation
Message-ID: <19F8576C6E063C45BE387C64729E7394044DA99712@dbde02.ent.ti.com>
References: <hvaibhav@ti.com>
	 <1266914073-30135-10-git-send-email-hvaibhav@ti.com>
 <55a3e0ce1002231522q6a3fb7cak530e8b970dcbdee5@mail.gmail.com>
In-Reply-To: <55a3e0ce1002231522q6a3fb7cak530e8b970dcbdee5@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Muralidharan Karicheri [mailto:mkaricheri@gmail.com]
> Sent: Wednesday, February 24, 2010 4:53 AM
> To: Hiremath, Vaibhav
> Cc: linux-media@vger.kernel.org; linux-omap@vger.kernel.org;
> hverkuil@xs4all.nl; Karicheri, Muralidharan
> Subject: Re: [PATCH-V1 09/10] VPFE Capture: Add support for USERPTR mode of
> operation
> 
> Vaibhav,
> 
> There are changes to vpfe capture on Arago tree on top of this. For
> example, vpfe_uservirt_to_phys() is removed and is replaced with
> videobuf_iolock(). So please get the latest changes to upstream.
> 
[Hiremath, Vaibhav] No, the Arago version doesn't support USERPTR mode at all,


1386		if (V4L2_MEMORY_USERPTR == req_buf->memory) {
1386                 /* we don't support user ptr IO */
1387                 v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_reqbufs:"
1388                          " USERPTR IO not supported\n");
1389                 return  -EINVAL;
1390         }

And also, I have received important comment from Mauro, which expects some code tobe moved to generic VideoBuf layer. I will be submitting patch for the same separately.

Thanks,
Vaibhav

> Murali
> 
> On Tue, Feb 23, 2010 at 3:34 AM,  <hvaibhav@ti.com> wrote:
> > From: Vaibhav Hiremath <hvaibhav@ti.com>
> >
> >
> > Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> > Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> > ---
> >  drivers/media/video/ti-media/vpfe_capture.c |   94
> ++++++++++++++++++++++----
> >  1 files changed, 79 insertions(+), 15 deletions(-)
> >
> > diff --git a/drivers/media/video/ti-media/vpfe_capture.c
> b/drivers/media/video/ti-media/vpfe_capture.c
> > index cece265..7d4ab44 100644
> > --- a/drivers/media/video/ti-media/vpfe_capture.c
> > +++ b/drivers/media/video/ti-media/vpfe_capture.c
> > @@ -538,7 +538,24 @@ static void vpfe_schedule_next_buffer(struct
> vpfe_device *vpfe_dev)
> >                                        struct videobuf_buffer, queue);
> >        list_del(&vpfe_dev->next_frm->queue);
> >        vpfe_dev->next_frm->state = VIDEOBUF_ACTIVE;
> > -       addr = videobuf_to_dma_contig(vpfe_dev->next_frm);
> > +       if (V4L2_MEMORY_USERPTR == vpfe_dev->memory)
> > +               addr = vpfe_dev->cur_frm->boff;
> > +       else
> > +               addr = videobuf_to_dma_contig(vpfe_dev->next_frm);
> > +
> > +       ccdc_dev->hw_ops.setfbaddr(addr);
> > +}
> > +
> > +static void vpfe_schedule_bottom_field(struct vpfe_device *vpfe_dev)
> > +{
> > +       unsigned long addr;
> > +
> > +       if (V4L2_MEMORY_USERPTR == vpfe_dev->memory)
> > +               addr = vpfe_dev->cur_frm->boff;
> > +       else
> > +               addr = videobuf_to_dma_contig(vpfe_dev->cur_frm);
> > +
> > +       addr += vpfe_dev->field_off;
> >        ccdc_dev->hw_ops.setfbaddr(addr);
> >  }
> >
> > @@ -559,7 +576,6 @@ static irqreturn_t vpfe_isr(int irq, void *dev_id)
> >  {
> >        struct vpfe_device *vpfe_dev = dev_id;
> >        enum v4l2_field field;
> > -       unsigned long addr;
> >        int fid;
> >
> >        v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "\nStarting
> vpfe_isr...\n");
> > @@ -604,10 +620,7 @@ static irqreturn_t vpfe_isr(int irq, void *dev_id)
> >                         * the CCDC memory address
> >                         */
> >                        if (field == V4L2_FIELD_SEQ_TB) {
> > -                               addr =
> > -                                 videobuf_to_dma_contig(vpfe_dev-
> >cur_frm);
> > -                               addr += vpfe_dev->field_off;
> > -                               ccdc_dev->hw_ops.setfbaddr(addr);
> > +                               vpfe_schedule_bottom_field(vpfe_dev);
> >                        }
> >                        goto clear_intr;
> >                }
> > @@ -1234,7 +1247,10 @@ static int vpfe_videobuf_setup(struct
> videobuf_queue *vq,
> >        struct vpfe_device *vpfe_dev = fh->vpfe_dev;
> >
> >        v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_buffer_setup\n");
> > -       *size = config_params.device_bufsize;
> > +       *size = vpfe_dev->fmt.fmt.pix.sizeimage;
> > +       if (vpfe_dev->memory == V4L2_MEMORY_MMAP &&
> > +               vpfe_dev->fmt.fmt.pix.sizeimage >
> config_params.device_bufsize)
> > +               *size = config_params.device_bufsize;
> >
> >        if (*count < config_params.min_numbuffers)
> >                *count = config_params.min_numbuffers;
> > @@ -1243,6 +1259,46 @@ static int vpfe_videobuf_setup(struct
> videobuf_queue *vq,
> >        return 0;
> >  }
> >
> > +/*
> > + * vpfe_uservirt_to_phys: This function is used to convert user
> > + * space virtual address to physical address.
> > + */
> > +static u32 vpfe_uservirt_to_phys(struct vpfe_device *vpfe_dev, u32 virtp)
> > +{
> > +       struct mm_struct *mm = current->mm;
> > +       unsigned long physp = 0;
> > +       struct vm_area_struct *vma;
> > +
> > +       vma = find_vma(mm, virtp);
> > +
> > +       /* For kernel direct-mapped memory, take the easy way */
> > +       if (virtp >= PAGE_OFFSET)
> > +               physp = virt_to_phys((void *)virtp);
> > +       else if (vma && (vma->vm_flags & VM_IO) && (vma->vm_pgoff))
> > +               /* this will catch, kernel-allocated, mmaped-to-usermode
> addr */
> > +               physp = (vma->vm_pgoff << PAGE_SHIFT) + (virtp - vma-
> >vm_start);
> > +       else {
> > +               /* otherwise, use get_user_pages() for general userland
> pages */
> > +               int res, nr_pages = 1;
> > +               struct page *pages;
> > +               down_read(&current->mm->mmap_sem);
> > +
> > +               res = get_user_pages(current, current->mm,
> > +                                    virtp, nr_pages, 1, 0, &pages, NULL);
> > +               up_read(&current->mm->mmap_sem);
> > +
> > +               if (res == nr_pages)
> > +                       physp = __pa(page_address(&pages[0]) +
> > +                                    (virtp & ~PAGE_MASK));
> > +               else {
> > +                       v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
> > +                               "get_user_pages failed\n");
> > +                       return 0;
> > +               }
> > +       }
> > +       return physp;
> > +}
> > +
> >  static int vpfe_videobuf_prepare(struct videobuf_queue *vq,
> >                                struct videobuf_buffer *vb,
> >                                enum v4l2_field field)
> > @@ -1259,6 +1315,18 @@ static int vpfe_videobuf_prepare(struct
> videobuf_queue *vq,
> >                vb->size = vpfe_dev->fmt.fmt.pix.sizeimage;
> >                vb->field = field;
> >        }
> > +
> > +       if (V4L2_MEMORY_USERPTR == vpfe_dev->memory) {
> > +               if (!vb->baddr) {
> > +                       v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
> > +                               "buffer address is 0\n");
> > +                       return -EINVAL;
> > +               }
> > +               vb->boff = vpfe_uservirt_to_phys(vpfe_dev, vb->baddr);
> > +               /* Make sure user addresses are aligned to 32 bytes */
> > +               if (!ALIGN(vb->boff, 32))
> > +                       return -EINVAL;
> > +       }
> >        vb->state = VIDEOBUF_PREPARED;
> >        return 0;
> >  }
> > @@ -1327,13 +1395,6 @@ static int vpfe_reqbufs(struct file *file, void
> *priv,
> >                return -EINVAL;
> >        }
> >
> > -       if (V4L2_MEMORY_USERPTR == req_buf->memory) {
> > -               /* we don't support user ptr IO */
> > -               v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_reqbufs:"
> > -                        " USERPTR IO not supported\n");
> > -               return  -EINVAL;
> > -       }
> > -
> >        ret = mutex_lock_interruptible(&vpfe_dev->lock);
> >        if (ret)
> >                return ret;
> > @@ -1541,7 +1602,10 @@ static int vpfe_streamon(struct file *file, void
> *priv,
> >        vpfe_dev->cur_frm->state = VIDEOBUF_ACTIVE;
> >        /* Initialize field_id and started member */
> >        vpfe_dev->field_id = 0;
> > -       addr = videobuf_to_dma_contig(vpfe_dev->cur_frm);
> > +       if (V4L2_MEMORY_USERPTR == vpfe_dev->memory)
> > +               addr = vpfe_dev->cur_frm->boff;
> > +       else
> > +               addr = videobuf_to_dma_contig(vpfe_dev->cur_frm);
> >
> >        /* Calculate field offset */
> >        vpfe_calculate_offsets(vpfe_dev);
> > --
> > 1.6.2.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> 
> --
> Murali Karicheri
> mkaricheri@gmail.com
