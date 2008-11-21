Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mALCBrNi008864
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 07:11:53 -0500
Received: from devils.ext.ti.com (devils.ext.ti.com [198.47.26.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mALCBBbK011381
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 07:11:37 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Arun KS <getarunks@gmail.com>, "Shah, Hardik" <hardik.shah@ti.com>
Date: Fri, 21 Nov 2008 17:40:56 +0530
Message-ID: <19F8576C6E063C45BE387C64729E739403E8E67DF3@dbde02.ent.ti.com>
In-Reply-To: <dfeb90390811210405l53ec0327le684c540d0b70e2f@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-fbdev-devel@lists.sourceforge.net"
	<linux-fbdev-devel@lists.sourceforge.net>
Subject: RE: [Review Patch] V4L2 driver on Tomis DSS patches
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



Thanks,
Vaibhav Hiremath

> -----Original Message-----
> From: video4linux-list-bounces@redhat.com [mailto:video4linux-list-
> bounces@redhat.com] On Behalf Of Arun KS
> Sent: Friday, November 21, 2008 5:35 PM
> To: Shah, Hardik
> Cc: video4linux-list@redhat.com; linux-omap@vger.kernel.org; linux-
> fbdev-devel@lists.sourceforge.net
> Subject: Re: [Review Patch] V4L2 driver on Tomis DSS patches
>
> Hi Hardik,
>
> Have a look at my review suggestions inline
>
> On Wed, Nov 19, 2008 at 12:18 PM, Hardik Shah <hardik.shah@ti.com>
> wrote:
> > This is the initial version of the V4L2 display driver
> > controlling the video pipelines of DSS.
> >
> > Features Supported/Tested
> > 1.  V4L2 controlling only one video pipeline (video1).
> >    Framework is for both. Only one is enabled right now.
> > 2.  Buffer size = VGA (which is same as LCD screen).
> > 3.  S_FMT, G_FMT, STREAMON, STREAMOFF, DQBUF, QBUF ioctls
> >    tested on OMAP3 EVM board.
> > 4.  Interrupt mechanism is working as expected.
> >
> > Features Not Supported/Tested
> > 1.  Mirroring, Rotation, Linking, windowing, cropping not
> supported.
> > 2.  Not tested with DVI and TV outputs.
> >
> > Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> >                Hari Nagalla <hnagalla@ti.com>
> >                Hardik Shah <hardik.shah@ti.com>
> >                Manjunath Hadli <mrh@ti.com>
> >                R Sivaraj <sivaraj@ti.com>
> >                Vaibhav Hiremath <hvaibhav@ti.com>
> >
> > ---
> >  arch/arm/mach-omap2/board-omap3evm.c       |   23 +-
> >  arch/arm/plat-omap/include/mach/omap34xx.h |   13 +
> >  drivers/media/video/Kconfig                |    9 +
> >  drivers/media/video/Makefile               |    2 +
> >  drivers/media/video/omap/Kconfig           |   12 +
> >  drivers/media/video/omap/Makefile          |    3 +
> >  drivers/media/video/omap/omap_vout.c       | 1589
> ++++++++++++++++++++++++++++
> >  drivers/media/video/omap/omap_voutdef.h    |  138 +++
> >  drivers/media/video/omap/omap_voutlib.c    |  281 +++++
> >  drivers/media/video/omap/omap_voutlib.h    |   34 +
> >  10 files changed, 2102 insertions(+), 2 deletions(-)
> >  create mode 100644 drivers/media/video/omap/Kconfig
> >  create mode 100644 drivers/media/video/omap/Makefile
> >  create mode 100644 drivers/media/video/omap/omap_vout.c
> >  create mode 100644 drivers/media/video/omap/omap_voutdef.h
> >  create mode 100644 drivers/media/video/omap/omap_voutlib.c
> >  create mode 100644 drivers/media/video/omap/omap_voutlib.h
> >
> > +#define NUM_OUTPUT_FORMATS
> (sizeof(omap_formats)/sizeof(omap_formats[0]))
> > +
> > +struct omap_vout_std_id_name {
> > +       v4l2_std_id id;
> > +       char name[25];
> > +};
> > +
> > +static unsigned long
> > +omap_vout_alloc_buffer(u32 buf_size, u32 *phys_addr)
>
> virtual addresses are pointer like and physical addresses are
> integer like.
> So the phys_addr should be stored in a u32 variable not in a
> pointer.
>
[Hiremath, Vaibhav] Thank you for pointing to this, point taken.

> > +{
> > +       unsigned long virt_addr, addr;
>
> here virt_addr should be a pointer like.
> There are many instances of this type throughout the code.
>
> > +       u32 order, size;
> > +       size = PAGE_ALIGN(buf_size);
> > +       order = get_order(size);
> > +       virt_addr = __get_free_pages(GFP_KERNEL | GFP_DMA, order);
> > +       addr = virt_addr;
> > +       if (virt_addr) {
> > +               while (size > 0) {
> > +                       SetPageReserved(virt_to_page(addr));
> > +                       addr += PAGE_SIZE;
> > +                       size -= PAGE_SIZE;
> > +               }
> > +       }
> > +       *phys_addr = (u32) virt_to_phys((void *) virt_addr);
> > +       return virt_addr;
> > +}
> > +
> > +static void
> > +omap_vout_free_buffer(unsigned long virtaddr, u32 phys_addr,
> > +                        u32 buf_size)
> > +{
> > +       unsigned long addr = virtaddr;
> > +       u32 order, size;
> > +       size = PAGE_ALIGN(buf_size);
> > +       order = get_order(size);
> > +       while (size > 0) {
> > +               ClearPageReserved(virt_to_page(addr));
> > +               addr += PAGE_SIZE;
> > +               size -= PAGE_SIZE;
> > +       }
> > +       free_pages((unsigned long) virtaddr, order);
> > +}
> > +
> > +static int omap_vout_try_format(struct v4l2_pix_format *pix,
> > +                               struct v4l2_pix_format *def_pix)
> > +{
> > +       int ifmt, bpp = 0;
> > +
> > +       if (pix->width > VID_MAX_WIDTH)
> > +               pix->width = VID_MAX_WIDTH;
> > +       if (pix->height > VID_MAX_HEIGHT)
> > +               pix->height = VID_MAX_HEIGHT;
> > +
> > +       if (pix->width <= VID_MIN_WIDTH)
> > +               pix->width = def_pix->width;
> > +       if (pix->height <= VID_MIN_HEIGHT)
> > +               pix->height = def_pix->height;
> > +
> > +       for (ifmt = 0; ifmt < NUM_OUTPUT_FORMATS; ifmt++) {
> > +               if (pix->pixelformat ==
> omap_formats[ifmt].pixelformat)
> > +                       break;
> > +       }
> > +
> > +       if (ifmt == NUM_OUTPUT_FORMATS)
> > +               ifmt = 0;
> > +
> > +       pix->pixelformat = omap_formats[ifmt].pixelformat;
> > +       pix->field = V4L2_FIELD_ANY;
> > +       pix->priv = 0;
> > +
> > +       switch (pix->pixelformat) {
> > +       case V4L2_PIX_FMT_YUYV:
> > +       case V4L2_PIX_FMT_UYVY:
> > +       default:
> > +               pix->colorspace = V4L2_COLORSPACE_JPEG;
> > +               bpp = YUYV_BPP;
> > +               break;
> > +       case V4L2_PIX_FMT_RGB565:
> > +       case V4L2_PIX_FMT_RGB565X:
> > +               pix->colorspace = V4L2_COLORSPACE_SRGB;
> > +               bpp = RGB565_BPP;
> > +               break;
> > +       case V4L2_PIX_FMT_RGB24:
> > +               pix->colorspace = V4L2_COLORSPACE_SRGB;
> > +               bpp = RGB24_BPP;
> > +               break;
> > +       case V4L2_PIX_FMT_RGB32:
> > +       case V4L2_PIX_FMT_BGR32:
> > +               pix->colorspace = V4L2_COLORSPACE_SRGB;
> > +               bpp = RGB32_BPP;
> > +               break;
> > +       }
> > +       pix->bytesperline = pix->width * bpp;
> > +       pix->sizeimage = pix->bytesperline * pix->height;
> > +       return bpp;
> > +}
> > +
> > +/*
> > + * omap_vout_uservirt_to_phys: This inline function is used to
> convert user
> > + * space virtual address to physical address.
> > + */
> > +       static inline u32 omap_vout_uservirt_to_phys(u32 virtp)
> > +{
> > +       unsigned long physp = 0;
> > +       struct mm_struct *mm = current->mm;
> > +       struct vm_area_struct *vma;
> > +
> > +       vma = find_vma(mm, virtp);
> > +       /* For kernel direct-mapped memory, take the easy way */
> > +       if (virtp >= PAGE_OFFSET) {
> > +               physp = virt_to_phys((void *) virtp);
> > +       } else if ((vma) && (vma->vm_flags & VM_IO)
> > +                  && (vma->vm_pgoff)) {
> > +               /* this will catch, kernel-allocated,
> > +                  mmaped-to-usermode addresses */
> > +               physp = (vma->vm_pgoff << PAGE_SHIFT) + (virtp -
> vma->vm_start);
> > +       } else {
> > +               /* otherwise, use get_user_pages() for general
> userland pages */
> > +               int res, nr_pages = 1;
> > +               struct page *pages;
> > +               down_read(&current->mm->mmap_sem);
> > +
> > +               res = get_user_pages(current, current->mm, virtp,
> nr_pages,
> > +                               1, 0, &pages, NULL);
> > +               up_read(&current->mm->mmap_sem);
> > +
> > +               if (res == nr_pages) {
> > +                       physp =  __pa(page_address(&pages[0]) +
> > +                                       (virtp & ~PAGE_MASK));
> > +               } else {
> > +                       printk(KERN_WARNING
> "omap_vout_uservirt_to_phys:\
> > +                                       get_user_pages failed\n");
> > +                       return 0;
> > +               }
> > +       }
> > +
> > +       return physp;
> > +}
> > +
> > +/* Buffer setup function is called by videobuf layer when REQBUF
> ioctl is
> > + * called. This is used to setup buffers and return size and
> count of
> > + * buffers allocated. After the call to this buffer, videobuf
> layer will
> > + * setup buffer queue depending on the size and count of buffers
> > + */
> > +static int
> > +omap_vout_buffer_setup(struct videobuf_queue *q, unsigned int
> *count,
> > +                         unsigned int *size)
> > +{
> > +       struct omap_vout_fh *fh = (struct omap_vout_fh *) q-
> >priv_data;
> > +       struct omap_vout_device *vout = fh->vout;
> > +       int startindex = 0, i;
> > +       u32 phy_addr = 0, virt_addr = 0;
> > +
> > +       if (!vout)
> > +               return -EINVAL;
> > +
> > +       if (V4L2_BUF_TYPE_VIDEO_OUTPUT != q->type)
> > +               return -EINVAL;
> > +
> > +       startindex = (vout->vid == OMAP_VIDEO1) ?
> > +               video1_numbuffers : video2_numbuffers;
> > +       if (V4L2_MEMORY_MMAP == vout->memory && *count <
> startindex)
> > +               *count = startindex;
> > +
> > +       *count = 4;
> > +
> > +       if (V4L2_MEMORY_MMAP != vout->memory)
> > +               return 0;
> > +
> > +       *size = vout->buffer_size;
> > +       startindex = (vout->vid == OMAP_VIDEO1) ?
> > +               video1_numbuffers : video2_numbuffers;
> > +       for (i = startindex; i < *count; i++) {
> > +               vout->buffer_size = *size;
> > +
> > +               virt_addr = omap_vout_alloc_buffer(vout-
> >buffer_size,
> > +                               &phy_addr);
> > +               if (!virt_addr)
> > +                       break;
> > +
> > +               vout->buf_virt_addr[i] = virt_addr;
> > +               vout->buf_phy_addr[i] = phy_addr;
> > +       }
> > +
> > +       *count = vout->buffer_allocated = i;
> > +       return 0;
> > +}
> > +
> > +/* This function will be called when VIDIOC_QBUF ioctl is called.
> > + * It prepare buffers before give out for the display. This
> function
> > + * user space virtual address into physical address if userptr
> memory
> > + * exchange mechanism is used. If rotation is enabled, it copies
> entire
> > + * buffer into VRFB memory space before giving it to the DSS.
> > + */
> > +static int
> > +omap_vout_buffer_prepare(struct videobuf_queue *q,
> > +                           struct videobuf_buffer *vb,
> > +                           enum v4l2_field field)
> > +{
> > +       struct omap_vout_fh *fh = (struct omap_vout_fh *) q-
> >priv_data;
> > +       struct omap_vout_device *vout = fh->vout;
> > +       struct videobuf_dmabuf *dmabuf = NULL;
> > +
> > +       if (VIDEOBUF_NEEDS_INIT == vb->state) {
> > +               vb->width = vout->pix.width;
> > +               vb->height = vout->pix.height;
> > +               vb->size = vb->width * vb->height * vout->bpp;
> > +               vb->field = field;
> > +       }
> > +       vb->state = VIDEOBUF_PREPARED;
> > +       /* if user pointer memory mechanism is used, get the
> physical
> > +        * address of the buffer
> > +        */
> > +       if (V4L2_MEMORY_USERPTR == vb->memory) {
> > +               if (0 == vb->baddr)
> > +                       return -EINVAL;
> > +               /* Virtual address */
> > +               /* priv points to struct videobuf_pci_sg_memory.
> But we went
> > +                * pointer to videobuf_dmabuf, which is member of
> > +                * videobuf_pci_sg_memory */
> > +               dmabuf = videobuf_to_dma(q->bufs[vb->i]);
> > +               dmabuf->vmalloc = (void *) vb->baddr;
> > +
> > +               /* Physical address */
> > +               dmabuf->bus_addr = (dma_addr_t)
> > +                       omap_vout_uservirt_to_phys(vb->baddr);
> > +       }
> > +
> > +       {
> > +               dmabuf = videobuf_to_dma(q->bufs[vb->i]);
> > +
> > +               vout->queued_buf_addr[vb->i] = (u8 *) dmabuf-
> >bus_addr;
> > +       }
> > +       return 0;
> > +}
> > +
> > +/* Buffer queue funtion will be called from the videobuf layer
> when _QBUF
> > + * ioctl is called. It is used to enqueue buffer, which is ready
> to be
> > + * displayed. */
> > +static void
> > +omap_vout_buffer_queue(struct videobuf_queue *q,
> > +                         struct videobuf_buffer *vb)
> > +{
> > +       struct omap_vout_fh *fh =
> > +           (struct omap_vout_fh *) q->priv_data;
> > +       struct omap_vout_device *vout = fh->vout;
> > +
> > +       /* Driver is also maintainig a queue. So enqueue buffer in
> the driver
> > +        * queue */
> > +       list_add_tail(&vb->queue, &vout->dma_queue);
> > +
> > +       vb->state = VIDEOBUF_PREPARED;
> > +}
> > +
> > +/* Buffer release function is called from videobuf layer to
> release buffer
> > + * which are already allocated */
> > +static void
> > +omap_vout_buffer_release(struct videobuf_queue *q,
> > +                           struct videobuf_buffer *vb)
> > +{
> > +       struct omap_vout_fh *fh = (struct omap_vout_fh *) q-
> >priv_data;
> > +       struct omap_vout_device *vout = fh->vout;
> > +
> > +       vb->state = VIDEOBUF_NEEDS_INIT;
> > +
> > +       if (V4L2_MEMORY_MMAP != vout->memory)
> > +               return;
> > +}
> > +
> > +/*
> > + *  file operations
> > + */
> > +static void omap_vout_vm_open(struct vm_area_struct *vma)
> > +{
> > +       struct omap_vout_device *vout = vma->vm_private_data;
> > +       DPRINTK("vm_open [vma=%08lx-%08lx]\n", vma->vm_start, vma-
> >vm_end);
> > +       vout->mmap_count++;
> > +}
> > +
> > +static void omap_vout_vm_close(struct vm_area_struct *vma)
> > +{
> > +       struct omap_vout_device *vout = vma->vm_private_data;
> > +       DPRINTK("vm_close [vma=%08lx-%08lx]\n", vma->vm_start,
> vma->vm_end);
> > +       vout->mmap_count--;
> > +}
> > +
> > +static struct vm_operations_struct omap_vout_vm_ops = {
> > +       .open = omap_vout_vm_open,
> > +       .close = omap_vout_vm_close,
> > +};
> > +
> > +static int omap_vout_mmap(struct file *file, struct
> vm_area_struct *vma)
> > +{
> > +       struct omap_vout_fh *fh = file->private_data;
> > +       struct omap_vout_device *vout = fh->vout;
> > +       struct videobuf_queue *q = &fh->vbq;
> > +       unsigned long size = (vma->vm_end - vma->vm_start);
> > +       unsigned long start = vma->vm_start;
> > +       int i;
> > +       void *pos;
> > +       struct videobuf_dmabuf *dmabuf = NULL;
> > +
> > +       DPRINTK("pgoff=0x%lx, start=0x%lx, end=0x%lx\n", vma-
> >vm_pgoff,
> > +               vma->vm_start, vma->vm_end);
> > +
> > +       /* look for the buffer to map */
> > +       for (i = 0; i < VIDEO_MAX_FRAME; i++) {
> > +               if (NULL == q->bufs[i])
> > +                       continue;
> > +               if (V4L2_MEMORY_MMAP != q->bufs[i]->memory)
> > +                       continue;
> > +               if (q->bufs[i]->boff == (vma->vm_pgoff <<
> PAGE_SHIFT))
> > +                       break;
> > +       }
> > +
> > +       if (VIDEO_MAX_FRAME == i) {
> > +               DPRINTK("offset invalid [offset=0x%lx]\n",
> > +                       (vma->vm_pgoff << PAGE_SHIFT));
> > +               return -EINVAL;
> > +       }
> > +       q->bufs[i]->baddr = vma->vm_start;
> > +
> > +       vma->vm_flags |= VM_RESERVED;
> > +       vma->vm_page_prot = pgprot_writecombine(vma-
> >vm_page_prot);
> > +       vma->vm_ops = &omap_vout_vm_ops;
> > +       vma->vm_private_data = (void *) vout;
> > +       dmabuf = videobuf_to_dma(q->bufs[i]);
> > +       pos = dmabuf->vmalloc;
> > +       while (size > 0) {
> > +               unsigned long pfn;
> > +               pfn = virt_to_phys((void *) pos) >> PAGE_SHIFT;
> > +               if (remap_pfn_range(vma, start, pfn, PAGE_SIZE,
> PAGE_SHARED))
> > +                       return -EAGAIN;
> > +               start += PAGE_SIZE;
> > +               pos += PAGE_SIZE;
> > +               size -= PAGE_SIZE;
> > +       }
> > +
> > +       vout->mmap_count++;
> > +       return 0;
> > +}
> > +
> > +static void omap_vout_free_allbuffers(struct omap_vout_device
> *vout)
> > +{
> > +       int num_buffers = 0, i;
> > +       num_buffers = (vout->vid == OMAP_VIDEO1) ?
> > +           video1_numbuffers : video2_numbuffers;
> > +       for (i = num_buffers; i < vout->buffer_allocated; i++) {
> > +               if (vout->buf_virt_addr[i]) {
> > +                       omap_vout_free_buffer(vout-
> >buf_virt_addr[i],
> > +                                vout->buf_phy_addr[i], vout-
> >buffer_size);
> > +               }
> > +               vout->buf_virt_addr[i] = 0;
> > +               vout->buf_phy_addr[i] = 0;
> > +       }
> > +       for (i = 0; i < 4; i++) {
> > +               if (vout->smsshado_virt_addr[i]) {
> > +                       omap_vout_free_buffer(vout-
> >smsshado_virt_addr[i],
> > +                                       vout-
> >smsshado_phy_addr[i],
> > +                                       vout->smsshado_size);
> > +                       vout->smsshado_virt_addr[i] = 0;
> > +                       vout->smsshado_phy_addr[i] = 0;
> > +               }
> > +       }
> > +       vout->buffer_allocated = num_buffers;
> > +}
> > +
> > +static int omap_vout_release(struct inode *inode, struct file
> *file)
> > +{
> > +
> > +       struct omap_vout_fh *fh = file->private_data;
> > +       struct omap_vout_device *vout;
> > +       struct videobuf_queue *q;
> > +       unsigned int t;
> > +       struct omapvideo_info *ovid;
> > +       unsigned int r;
> > +
> > +       vout = fh->vout;
> > +
> > +       ovid = &(vout->vid_info);
> > +       if (fh == 0)
> > +               return 0;
> > +       if (!vout)
> > +               return 0;
> > +       q = &fh->vbq;
> > +
> > +       /* Disable all the overlay managers connected with this
> interface */
> > +       for (t = 0; t < ovid->num_overlays; t++) {
> > +                       struct omap_overlay *ovl = ovid-
> >overlays[t];
> > +                       if (ovl->manager && ovl->manager->display)
> > +                               ovl->enable(ovl, 0);
> > +               }
> > +
> > +       r = omapvid_apply_changes(vout, 0, 0);
> > +               if (r)
> > +                       printk(KERN_ERR VOUT_NAME "failed to
> change mode\n");
> > +
> > +       /* Even if apply changes fails we should continue
> > +          freeing allocated memeory */
> > +       if (fh->io_allowed) {
> > +               videobuf_streamoff(q);
> > +               videobuf_queue_cancel(q);
> > +               /* Free all buffers */
> > +               omap_vout_free_allbuffers(vout);
> > +               videobuf_mmap_free(q);
> > +       }
> > +
> > +       if (vout->streaming == fh) {
> > +               omap_dispc_unregister_isr(omap_vout_isr);
> > +               vout->streaming = NULL;
> > +       }
> > +
> > +       if (vout->mmap_count != 0)
> > +               vout->mmap_count = 0;
> > +
> > +       vout->opened -= 1;
> > +       file->private_data = NULL;
> > +
> > +       if (vout->buffer_allocated)
> > +               videobuf_mmap_free(q);
> > +
> > +       kfree(fh);
> > +
> > +       /* need to remove the link when the either slave or master
> is gone */
> > +       spin_lock(&vout_link_lock);
> > +       if (vout_linked != -1)
> > +               vout_linked = -1;
> > +       spin_unlock(&vout_link_lock);
> > +
> > +       return r;
> > +}
> > +
> > +static int omap_vout_open(struct inode *inode, struct file *file)
> > +{
> > +       int minor = MINOR(file->f_dentry->d_inode->i_rdev);
> > +       struct omap_vout_device *vout = NULL;
> > +       struct omap_vout_fh *fh;
> > +       struct videobuf_queue *q;
> > +
> > +       DPRINTK("entering\n");
> > +
> > +       if (saved_v1out && saved_v1out->vfd
> > +           && (saved_v1out->vfd->minor == minor)) {
> > +               vout = saved_v1out;
> > +       }
> > +
> > +       if (vout == NULL) {
> > +               if (saved_v2out && saved_v2out->vfd
> > +                   && (saved_v2out->vfd->minor == minor)) {
> > +                       vout = saved_v2out;
> > +               }
> > +       }
> > +
> > +       if (vout == NULL)
> > +               return -ENODEV;
> > +
> > +       /* for now, we only support single open */
> > +       if (vout->opened)
> > +               return -EBUSY;
> > +
> > +       vout->opened += 1;
> > +
> > +       fh = kmalloc(sizeof(*fh), GFP_KERNEL);
> > +       if (NULL == fh)
> > +               return -ENOMEM;
> > +       memset(fh, 0, sizeof(*fh));
> > +
> > +       file->private_data = fh;
> > +       fh->vout = vout;
> > +       fh->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> > +
> > +       q = &fh->vbq;
> > +       video_vbq_ops.buf_setup = omap_vout_buffer_setup;
> > +       video_vbq_ops.buf_prepare = omap_vout_buffer_prepare;
> > +       video_vbq_ops.buf_release = omap_vout_buffer_release;
> > +       video_vbq_ops.buf_queue = omap_vout_buffer_queue;
> > +       spin_lock_init(&vout->vbq_lock);
> > +
> > +       videobuf_queue_sg_init(q, &video_vbq_ops, NULL, &vout-
> >vbq_lock,
> > +                              fh->type, V4L2_FIELD_NONE, sizeof
> > +                              (struct videobuf_buffer), fh);
> > +
> > +       return 0;
> > +}
> > +
> > +static int vidioc_querycap(struct file *file, void *fh,
> > +               struct v4l2_capability *cap)
> > +{
> > +       struct omap_vout_device *vout = ((struct omap_vout_fh *)
> fh)->vout;
> > +
> > +       memset(cap, 0, sizeof(*cap));
> > +       strncpy(cap->driver, VOUT_NAME,
> > +               sizeof(cap->driver));
> > +       strncpy(cap->card, vout->vfd->name, sizeof(cap->card));
> > +       cap->bus_info[0] = '\0';
> > +       cap->capabilities = V4L2_CAP_STREAMING |
> V4L2_CAP_VIDEO_OUTPUT;
> > +       return 0;
> > +}
> > +static int vidioc_enum_fmt_vid_out(struct file *file, void *fh,
> > +                       struct v4l2_fmtdesc *fmt)
> > +{
> > +       int index = fmt->index;
> > +       enum v4l2_buf_type type = fmt->type;
> > +
> > +       memset(fmt, 0, sizeof(*fmt));
> > +       fmt->index = index;
> > +       fmt->type = type;
> > +       if (index >= NUM_OUTPUT_FORMATS)
> > +               return -EINVAL;
> > +
> > +       fmt->flags = omap_formats[index].flags;
> > +       strncpy(fmt->description, omap_formats[index].description,
> > +                       sizeof(fmt->description));
> > +       fmt->pixelformat = omap_formats[index].pixelformat;
> > +       return 0;
> > +}
> > +static int vidioc_g_fmt_vid_out(struct file *file, void *fh,
> > +                       struct v4l2_format *f)
> > +{
> > +       struct omap_vout_device *vout = ((struct omap_vout_fh *)
> fh)->vout;
> > +
> > +       struct v4l2_pix_format *pix = &f->fmt.pix;
> > +       memset(pix, 0, sizeof(*pix));
> > +       *pix = vout->pix;
> > +       return 0;
> > +
> > +}
> > +
> > +static int vidioc_try_fmt_vid_out(struct file *file, void *fh,
> > +                       struct v4l2_format *f)
> > +{
> > +       struct omap_vout_device *vout = ((struct omap_vout_fh *)
> fh)->vout;
> > +
> > +       if (vout->streaming)
> > +               return -EBUSY;
> > +
> > +       vout->fbuf.fmt.height = def_display->y_res;
> > +       vout->fbuf.fmt.width = def_display->x_res;
> > +
> > +       omap_vout_try_format(&f->fmt.pix, &vout->fbuf.fmt);
> > +       return 0;
> > +}
> > +
> > +static int vidioc_s_fmt_vid_out(struct file *file, void *fh,
> > +                       struct v4l2_format *f)
> > +{
> > +       struct omap_vout_fh *ofh = (struct omap_vout_fh *)fh;
> > +       struct omap_vout_device *vout = ofh->vout;
> > +       int bpp;
> > +       int r;
> > +
> > +       if (vout->streaming)
> > +               return -EBUSY;
> > +
> > +       if (down_interruptible(&vout->lock))
> > +               return -EINVAL;
> > +
> > +       /* get the framebuffer parameters */
> > +       vout->fbuf.fmt.height = def_display->y_res;
> > +       vout->fbuf.fmt.width = def_display->x_res;
> > +
> > +       /* change to samller size is OK */
> > +       bpp = omap_vout_try_format(&f->fmt.pix, &vout->fbuf.fmt);
> > +       f->fmt.pix.sizeimage = f->fmt.pix.width * f-
> >fmt.pix.height * bpp;
> > +
> > +       /* try & set the new output format */
> > +       vout->bpp = bpp;
> > +       vout->pix = f->fmt.pix;
> > +
> > +       /* set default crop and win */
> > +       omap_vout_new_format(&vout->pix, &vout->fbuf, &vout->crop,
> &vout->win);
> > +
> > +       /* Save the changes in the overlay strcuture */
> > +       r = omapvid_apply_changes(vout, 0, 0);
> > +               if (r)
> > +                       printk(KERN_ERR VOUT_NAME "failed to
> change mode\n");
> > +
> > +       up(&vout->lock);
> > +       return 0;
> > +}
> > +
> > +static int vidioc_reqbufs(struct file *file, void *fh,
> > +                       struct v4l2_requestbuffers *req)
> > +{
> > +       struct omap_vout_device *vout = ((struct omap_vout_fh *)
> fh)->vout;
> > +       struct videobuf_queue *q = &(((struct omap_vout_fh *) fh)-
> >vbq);
> > +       unsigned int i, num_buffers = 0;
> > +       int ret = 0;
> > +       struct videobuf_dmabuf *dmabuf = NULL;
> > +
> > +       if (down_interruptible(&vout->lock))
> > +               return -EINVAL;
> > +       /* don't allow to buffer request for the linked layer */
> > +       if (vout->vid == vout_linked) {
> > +               up(&vout->lock);
> > +               return -EINVAL;
> > +       }
> > +
> > +       if ((req->type != V4L2_BUF_TYPE_VIDEO_OUTPUT) || (req-
> >count < 0)) {
> > +               up(&vout->lock);
> > +               return -EINVAL;
> > +       }
> > +       /* if memory is not mmp or userptr
> > +          return error */
> > +       if ((V4L2_MEMORY_MMAP != req->memory) &&
> > +               (V4L2_MEMORY_USERPTR != req->memory)) {
> > +               up(&vout->lock);
> > +               return -EINVAL;
> > +       }
> > +
> > +       /* Cannot be requested when streaming is on */
> > +       if (vout->streaming) {
> > +               up(&vout->lock);
> > +               return -EBUSY;
> > +       }
> > +
> > +       /* If buffers are already allocated free them */
> > +       if (q->bufs[0] && (V4L2_MEMORY_MMAP == q->bufs[0]-
> >memory)) {
> > +               if (vout->mmap_count) {
> > +                       up(&vout->lock);
> > +                       return -EBUSY;
> > +               }
> > +               num_buffers = (vout->vid == OMAP_VIDEO1) ?
> > +                       video1_numbuffers : video2_numbuffers;
> > +               for (i = num_buffers; i < vout->buffer_allocated;
> i++) {
> > +                       dmabuf = videobuf_to_dma(q->bufs[i]);
> > +                       omap_vout_free_buffer((u32)dmabuf-
> >vmalloc,
> > +                               dmabuf->bus_addr, vout-
> >buffer_size);
> > +                       vout->buf_virt_addr[i] = 0;
> > +                       vout->buf_phy_addr[i] = 0;
> > +               }
> > +               vout->buffer_allocated = num_buffers;
> > +               videobuf_mmap_free(q);
> > +       } else if (q->bufs[0] && (V4L2_MEMORY_USERPTR == q-
> >bufs[0]->memory)) {
> > +               if (vout->buffer_allocated) {
> > +                       videobuf_mmap_free(q);
> > +                       for (i = 0; i < vout->buffer_allocated;
> i++) {
> > +                               kfree(q->bufs[i]);
> > +                               q->bufs[i] = NULL;
> > +                       }
> > +                       vout->buffer_allocated = 0;
> > +               }
> > +       }
> > +       ((struct omap_vout_fh *) fh)->io_allowed = 1;
> > +
> > +       /*store the memory type in data structure */
> > +       vout->memory = req->memory;
> > +
> > +       INIT_LIST_HEAD(&vout->dma_queue);
> > +
> > +       /* call videobuf_reqbufs api */
> > +       ret = videobuf_reqbufs(q, req);
> > +       if (ret < 0) {
> > +               up(&vout->lock);
> > +               return ret;
> > +       }
> > +
> > +       vout->buffer_allocated = req->count;
> > +       for (i = 0; i < req->count; i++) {
> > +               dmabuf = videobuf_to_dma(q->bufs[i]);
> > +               dmabuf->vmalloc = (void *) vout->buf_virt_addr[i];
> > +               dmabuf->bus_addr = (dma_addr_t) vout-
> >buf_phy_addr[i];
> > +               dmabuf->sglen = 1;
> > +       }
> > +       up(&vout->lock);
> > +       return 0;
> > +}
> > +static int vidioc_querybuf(struct file *file, void *fh,
> > +                       struct v4l2_buffer *b)
> > +{
> > +       return videobuf_querybuf(&(((struct omap_vout_fh *) fh)-
> >vbq), b);
> > +}
> > +static int vidioc_qbuf(struct file *file, void *fh,
> > +                       struct v4l2_buffer *buffer)
> > +{
> > +       struct omap_vout_fh *ofh = (struct omap_vout_fh *)fh;
> > +       struct omap_vout_device *vout = ofh->vout;
> > +       struct videobuf_queue *q = &ofh->vbq;
> > +       int ret = 0;
> > +
> > +       if (!ofh->io_allowed)
> > +               return -EINVAL;
> > +
> > +       timeout = HZ / 5;
> > +       timeout += jiffies;
> > +
> > +       if ((V4L2_BUF_TYPE_VIDEO_OUTPUT != buffer->type) ||
> > +                       (buffer->index >= vout->buffer_allocated)
> ||
> > +                       (q->bufs[buffer->index]->memory != buffer-
> >memory)) {
> > +               return -EINVAL;
> > +       }
> > +       if (V4L2_MEMORY_USERPTR == buffer->memory) {
> > +               if ((buffer->length < vout->pix.sizeimage) ||
> > +                       (0 == buffer->m.userptr)) {
> > +                       return -EINVAL;
> > +               }
> > +       }
> > +
> > +       ret = videobuf_qbuf(q, buffer);
> > +       return ret;
> > +}
> > +static int vidioc_dqbuf(struct file *file, void *fh,
> > +                       struct v4l2_buffer *b)
> > +{
> > +       struct omap_vout_fh *ofh = (struct omap_vout_fh *)fh;
> > +       struct omap_vout_device *vout = ofh->vout;
> > +       struct videobuf_queue *q = &ofh->vbq;
> > +       int ret = 0;
> > +       /* don't allow to dequeue buffer for the linked layer */
> > +       if (vout->vid == vout_linked)
> > +               return -EINVAL;
> > +
> > +       if (!vout->streaming || !ofh->io_allowed)
> > +               return -EINVAL;
> > +
> > +       if (file->f_flags & O_NONBLOCK)
> > +               /* Call videobuf_dqbuf for non blocking mode */
> > +               ret = videobuf_dqbuf(q, (struct v4l2_buffer *)b,
> 1);
> > +       else
> > +               /* Call videobuf_dqbuf for  blocking mode */
> > +               ret = videobuf_dqbuf(q, (struct v4l2_buffer *)b,
> 0);
> > +       return ret;
> > +}
> > +#define DISPC_IRQSTATUS_VSYNC                           (1 <<  1)
> > +static int vidioc_streamon(struct file *file, void *fh,
> > +                       enum v4l2_buf_type i)
> > +{
> > +       struct omap_vout_fh *ofh = (struct omap_vout_fh *)fh;
> > +       struct omap_vout_device *vout = ofh->vout;
> > +       struct videobuf_queue *q = &ofh->vbq;
> > +       u32 addr = 0;
> > +       int r = 0;
> > +       int t;
> > +       struct omapvideo_info *ovid = &(vout->vid_info);
> > +       u32 mask = 0;
> > +
> > +       if (down_interruptible(&vout->lock))
> > +               return -EINVAL;
> > +       if (!ofh->io_allowed) {
> > +               up(&vout->lock);
> > +               return -EINVAL;
> > +       }
> > +
> > +       if (vout->streaming) {
> > +               up(&vout->lock);
> > +               return -EBUSY;
> > +       }
> > +
> > +       r = videobuf_streamon(q);
> > +       if (r < 0) {
> > +               up(&vout->lock);
> > +               return r;
> > +       }
> > +
> > +       if (list_empty(&vout->dma_queue)) {
> > +               up(&vout->lock);
> > +               return -EIO;
> > +       }
> > +       /* Get the next frame from the buffer queue */
> > +       vout->nextFrm = vout->curFrm = list_entry(vout-
> >dma_queue.next,
> > +                               struct videobuf_buffer, queue);
> > +       /* Remove buffer from the buffer queue */
> > +       list_del(&vout->curFrm->queue);
> > +       /* Mark state of the current frame to active */
> > +       vout->curFrm->state = VIDEOBUF_ACTIVE;
> > +       /* Initialize field_id and started member */
> > +       vout->field_id = 0;
> > +
> > +       /* set flag here. Next QBUF will start DMA */
> > +       vout->streaming = ofh;
> > +
> > +       vout->first_int = 1;
> > +
> > +       addr = (unsigned long) vout->queued_buf_addr[vout->curFrm-
> >i] +
> > +               vout->cropped_offset;
> > +
> > +       mask = DISPC_IRQSTATUS_VSYNC;
> > +               r = omap_dispc_register_isr(omap_vout_isr, vout,
> mask);
> > +
> > +       for (t = 0; t < ovid->num_overlays; t++) {
> > +               struct omap_overlay *ovl = ovid->overlays[t];
> > +               if (ovl->manager && ovl->manager->display)
> > +                       ovl->enable(ovl, 1);
> > +       }
> > +
> > +       r = omapvid_apply_changes(vout, addr, 0);
> > +       if (r)
> > +               printk(KERN_ERR VOUT_NAME "failed to change
> mode\n");
> > +
> > +       up(&vout->lock);
> > +       return 0;
> > +}
> > +static int vidioc_streamoff(struct file *file, void *fh,
> > +                       enum v4l2_buf_type i)
> > +{
> > +
> > +       struct omap_vout_fh *ofh = (struct omap_vout_fh *)fh;
> > +       struct omap_vout_device *vout = ofh->vout;
> > +       int t, r = 0;
> > +       struct omapvideo_info *ovid = &(vout->vid_info);
> > +
> > +       if (!ofh->io_allowed)
> > +               return -EINVAL;
> > +       if (!vout->streaming)
> > +               return -EINVAL;
> > +       if (vout->streaming == fh) {
> > +               vout->streaming = NULL;
> > +
> > +               omap_dispc_unregister_isr(omap_vout_isr);
> > +
> > +               for (t = 0; t < ovid->num_overlays; t++) {
> > +                       struct omap_overlay *ovl = ovid-
> >overlays[t];
> > +                       if (ovl->manager && ovl->manager->display)
> > +                               ovl->enable(ovl, 0);
> > +               }
> > +
> > +               r = omapvid_apply_changes(vout, 0, 0);
> > +               if (r) {
> > +                       printk(KERN_ERR VOUT_NAME "failed to
> change mode\n");
> > +                       return r;
> > +               }
> > +       }
> > +       return 0;
> > +}
> > +
> > +static const struct v4l2_ioctl_ops vout_ioctl_ops = {
> > +       .vidioc_querycap                        = vidioc_querycap,
> > +       .vidioc_querycap                                =
> vidioc_querycap,
> > +       .vidioc_enum_fmt_vid_out                =
> vidioc_enum_fmt_vid_out,
> > +       .vidioc_g_fmt_vid_out                   =
> vidioc_g_fmt_vid_out,
> > +       .vidioc_try_fmt_vid_out                 =
> vidioc_try_fmt_vid_out,
> > +       .vidioc_s_fmt_vid_out                   =
> vidioc_s_fmt_vid_out,
> > +       .vidioc_reqbufs                                 =
> vidioc_reqbufs,
> > +       .vidioc_querybuf                                =
> vidioc_querybuf,
> > +       .vidioc_qbuf                                    =
> vidioc_qbuf,
> > +       .vidioc_dqbuf                                   =
> vidioc_dqbuf,
> > +       .vidioc_streamon                                =
> vidioc_streamon,
> > +       .vidioc_streamoff                               =
> vidioc_streamoff,
> > +};
> > +
> > +static struct file_operations omap_vout_fops = {
> > +       .owner = THIS_MODULE,
> > +       .llseek = no_llseek,
> > +       .ioctl = video_ioctl2,
> > +       .mmap = omap_vout_mmap,
> > +       .open = omap_vout_open,
> > +       .release = omap_vout_release,
> > +};
> > +
> > +static int omap_vout_remove(struct platform_device *pdev)
> > +{
> > +
> > +       struct omap2video_device *vid_dev =
> platform_get_drvdata(pdev);
> > +       int k;
> > +
> > +       for (k = 0; k < pdev->num_resources; k++)
> > +               omap_vout_cleanup_device(vid_dev->vouts[k]);
> > +
> > +       for (k = 0; k < vid_dev->num_displays; k++) {
> > +               if (vid_dev->displays[k]->state !=
> OMAP_DSS_DISPLAY_DISABLED)
> > +                       vid_dev->displays[k]->disable(vid_dev-
> >displays[k]);
> > +
> > +               omap_dss_put_display(vid_dev->displays[k]);
> > +       }
> > +       kfree(vid_dev);
> > +       return 0;
> > +}
> > +
> > +static int omap_vout_probe(struct platform_device *pdev)
> > +{
> > +       int r = 0, i, t;
> > +       struct omap2video_device *vid_dev = NULL;
> > +       struct omap_overlay *ovl;
> > +
> > +       if (pdev->num_resources == 0) {
> > +               dev_err(&pdev->dev, "probed for an unknown
> device\n");
> > +               r = -ENODEV;
> > +               return r;
> > +       }
> > +
> > +       vid_dev = kzalloc(sizeof(struct omap2video_device),
> GFP_KERNEL);
> > +       if (vid_dev == NULL) {
> > +               r = -ENOMEM;
> > +               return r;
> > +       }
> > +
> > +       platform_set_drvdata(pdev, vid_dev);
> > +
> > +       vid_dev->num_displays = 0;
> > +       t = omap_dss_get_num_displays();
> > +       for (i = 0; i < t; i++) {
> > +               struct omap_display *display;
> > +               display = omap_dss_get_display(i);
> > +               if (!display) {
> > +                       dev_err(&pdev->dev, "probed for an unknown
> device\n");
> > +                       r = -EINVAL;
> > +                       goto error0;
> > +               }
> > +               vid_dev->displays[vid_dev->num_displays++] =
> display;
> > +       }
> > +
> > +       if (vid_dev->num_displays == 0) {
> > +               dev_err(&pdev->dev, "probed for an unknown
> device\n");
> > +               r = -EINVAL;
> > +               goto error0;
> > +       }
> > +
> > +       vid_dev->num_overlays = omap_dss_get_num_overlays();
> > +       for (i = 0; i < vid_dev->num_overlays; i++)
> > +               vid_dev->overlays[i] = omap_dss_get_overlay(i);
> > +
> > +       vid_dev->num_managers =
> omap_dss_get_num_overlay_managers();
> > +       for (i = 0; i < vid_dev->num_managers; i++)
> > +               vid_dev->managers[i] =
> omap_dss_get_overlay_manager(i);
> > +
> > +       /* video1 overlay should be the default one. find a
> display
> > +        * connected to that, and use it as default display */
> > +       ovl = omap_dss_get_overlay(1);
> > +       if (ovl->manager && ovl->manager->display) {
> > +               def_display = ovl->manager->display;
> > +       } else {
> > +               dev_err(&pdev->dev, "probed for an unknown
> device\n");
> > +               r = -EINVAL;
> > +               goto error0;
> > +       }
> > +
> > +       r = omapvout_create_vout_devices(pdev);
> > +       if (r)
> > +               goto error0;
> > +
> > +       r = def_display->enable(def_display);
> > +       if (r) {
> > +               /* Here we are not considering a error as display
> may be
> > +                  enabled by frame buffer driver */
> > +               printk(KERN_WARNING "Display already enabled\n");
> > +       }
> > +
> > +       /* set the update mode */
> > +       if (def_display->caps &
> OMAP_DSS_DISPLAY_CAP_MANUAL_UPDATE) {
> > +#ifdef CONFIG_FB_OMAP2_FORCE_AUTO_UPDATE
> > +               if (def_display->set_update_mode)
> > +                       def_display->set_update_mode(def_display,
> > +                                       OMAP_DSS_UPDATE_AUTO);
> > +               if (def_display->enable_te)
> > +                       def_display->enable_te(def_display, 1);
> > +#else
> > +               if (def_display->set_update_mode)
> > +                       def_display->set_update_mode(def_display,
> > +                                       OMAP_DSS_UPDATE_MANUAL);
> > +               if (def_display->enable_te)
> > +                       def_display->enable_te(def_display, 0);
> > +#endif
> > +       } else {
> > +               if (def_display->set_update_mode)
> > +                       def_display->set_update_mode(def_display,
> > +                                       OMAP_DSS_UPDATE_AUTO);
> > +       }
> > +
> > +       for (i = 0; i < vid_dev->num_displays; i++) {
> > +               struct omap_display *display = vid_dev-
> >displays[i];
> > +
> > +               if (display->update)
> > +                       display->update(display,
> > +                                       0, 0,
> > +                                       display->x_res, display-
> >y_res);
> > +       }
> > +       printk(KERN_INFO "display->updated\n");
> > +       return 0;
> > +
> > +error0:
> > +       kfree(vid_dev);
> > +       return r;
> > +}
> > +
> > +static int omapvout_create_vout_devices(struct platform_device
> *pdev)
> > +{
> > +       int r = 0, i, k;
> > +       struct omap_vout_device *vout;
> > +       struct video_device *vfd;
> > +       struct v4l2_pix_format *pix;
> > +       u32 numbuffers;
> > +       int index_i, index_j;
> > +       struct omap2video_device *vid_dev =
> platform_get_drvdata(pdev);
> > +
> > +       for (k = 0; k < pdev->num_resources; k++) {
> > +               vout = kmalloc(sizeof(struct omap_vout_device),
> GFP_KERNEL);
> > +               if (!vout) {
> > +                       printk(KERN_ERR VOUT_NAME ": could not
> allocate \
> > +                                       memory\n");
> > +                       return -ENOMEM;
> > +               }
> > +
> > +               memset(vout, 0, sizeof(struct omap_vout_device));
> > +               vout->vid = k + 1;
> > +
> > +               /* set the default pix */
> > +               pix = &vout->pix;
> > +
> > +               /* Set the default picture of QVGA  */
> > +               pix->width = QQVGA_WIDTH;
> > +               pix->height = QQVGA_HEIGHT;
> > +
> > +               /* Default pixel format is RGB 5-6-5 */
> > +               pix->pixelformat = V4L2_PIX_FMT_RGB565;
> > +               pix->field = V4L2_FIELD_ANY;
> > +               pix->bytesperline = pix->width * 2;
> > +               pix->sizeimage = pix->bytesperline * pix->height;
> > +               pix->priv = 0;
> > +               pix->colorspace = V4L2_COLORSPACE_JPEG;
> > +
> > +               vout->bpp = RGB565_BPP;
> > +
> > +               vout->fbuf.fmt.width = def_display->x_res;
> > +               vout->fbuf.fmt.height = def_display->y_res;
> > +
> > +               omap_vout_new_format(pix, &vout->fbuf, &vout-
> >crop, &vout->win);
> > +
> > +               /* initialize the video_device struct */
> > +               vfd = vout->vfd = video_device_alloc();
> > +
> > +               if (!vfd) {
> > +                       printk(KERN_ERR VOUT_NAME ": could not
> allocate video \
> > +                                       device struct\n");
> > +                       kfree(vout);
> > +                       return -ENOMEM;
> > +               }
> > +               vfd->release = video_device_release;
> > +               vfd->ioctl_ops = &vout_ioctl_ops;
> > +
> > +               strncpy(vfd->name, VOUT_NAME, sizeof(vfd->name));
> > +               vfd->vfl_type = VID_TYPE_OVERLAY |
> VID_TYPE_CHROMAKEY;
> > +               /* need to register for a VID_HARDWARE_* ID in
> videodev.h */
> > +               vfd->fops = &omap_vout_fops;
> > +               video_set_drvdata(vfd, vout);
> > +               vfd->minor = -1;
> > +
> > +               index_i = 4;
> > +               index_j = 0;
> > +
> > +               numbuffers = (k == 0) ?
> > +                       video1_numbuffers : video2_numbuffers;
> > +               vout->buffer_size = (k == 0) ?
> > +                       video1_bufsize : video2_bufsize;
> > +               printk(KERN_INFO "Buffer Size = %d\n", vout-
> >buffer_size);
> > +               for (i = 0; i < numbuffers; i++) {
> > +                       vout->buf_virt_addr[i] =
> > +                               omap_vout_alloc_buffer(vout-
> >buffer_size,
> > +                                               (u32 *) &vout-
> >buf_phy_addr[i]);
> > +                       if (!vout->buf_virt_addr[i]) {
> > +                               numbuffers = i;
> > +                               goto error;
> > +                       }
> > +               }
> > +
> > +               vout->suspended = 0;
> > +               init_waitqueue_head(&vout->suspend_wq);
> > +               init_MUTEX(&vout->lock);
> > +
> > +               if (video_register_device(vfd, VFL_TYPE_GRABBER,
> k) < 0) {
> > +                       printk(KERN_ERR VOUT_NAME ": could not
> register \
> > +                                       Video for Linux
> device\n");
> > +                       vfd->minor = -1;
> > +                       goto error;
> > +               }
> > +
> > +               printk(KERN_INFO VOUT_NAME ": registered device
> video%d \
> > +                               [v4l2]\n",
> > +                               vfd->minor);
> > +
> > +               if (k == 0)
> > +                       saved_v1out = vout;
> > +               else
> > +                       saved_v2out = vout;
> > +
> > +               vid_dev->vouts[k] = vout;
> > +               vout->vid_info.vid_dev = vid_dev;
> > +               vout->vid_info.overlays[0] = vid_dev->overlays[k +
> 1];
> > +               vout->vid_info.num_overlays = 1;
> > +               vout->vid_info.id = k + 1;
> > +               vid_dev->num_videos++;
> > +
> > +               r = omapvid_apply_changes(vid_dev->vouts[k], 0,
> 1);
> > +
> > +               if (!r)
> > +                       return 0;
> > +
> > +               printk(KERN_ERR VOUT_NAME ": could not register
> Video for \
> > +                                       Linux device\n");
> > +error:
> > +               for (i = 0; i < numbuffers; i++) {
> > +                       omap_vout_free_buffer(vout-
> >buf_virt_addr[i],
> > +                                       vout->buf_phy_addr[i],
> > +                                       vout->buffer_size);
> > +                       vout->buf_virt_addr[i] = 0;
> > +                       vout->buf_phy_addr[i] = 0;
> > +               }
> > +               video_device_release(vfd);
> > +               kfree(vout);
> > +               return r;
> > +       }
> > +       return -ENODEV;
> > +}
> > +
> > +int omapvid_apply_changes(struct omap_vout_device *vout, u32
> addr, int init)
> > +{
> > +       int r = 0;
> > +       struct omapvideo_info *ovid = &(vout->vid_info);
> > +       struct omap_overlay *ovl;
> > +       int posx, posy;
> > +       int outw, outh;
> > +       int i;
> > +
> > +       for (i = 0; i < ovid->num_overlays; i++) {
> > +               ovl = ovid->overlays[i];
> > +
> > +               if (init || (ovl->caps & OMAP_DSS_OVL_CAP_SCALE)
> == 0) {
> > +                       outw = vout->win.w.width;
> > +                       outh = vout->win.w.height;
> > +
> > +               } else {
> > +                       outw = vout->win.w.width;
> > +                       outh = vout->win.w.height;
> > +               }
> > +               if (init) {
> > +                       posx = 0;
> > +                       posy = 0;
> > +               } else {
> > +                       posx = vout->win.w.left;
> > +                       posy = vout->win.w.top;
> > +               }
> > +
> > +               r = omapvid_setup_overlay(vout, ovl, posx, posy,
> outw,
> > +                               outh, addr);
> > +               if (r)
> > +                       goto err;
> > +
> > +               /* disabled for now. if the display has changed,
> var
> > +                * still contains the old timings. */
> > +#if 0
> > +               if (display && display->set_timings) {
> > +                       struct omap_video_timings timings;
> > +                       timings.pixel_clock = PICOS2KHZ(var-
> >pixclock);
> > +                       timings.hfp = var->left_margin;
> > +                       timings.hbp = var->right_margin;
> > +                       timings.vfp = var->upper_margin;
> > +                       timings.vbp = var->lower_margin;
> > +                       timings.hsw = var->hsync_len;
> > +                       timings.vsw = var->vsync_len;
> > +
> > +                       display->set_timings(display, &timings);
> > +               }
> > +#endif
> > +       if (!init && ovl->manager)
> > +                       ovl->manager->apply(ovl->manager);
> > +
> > +       }
> > +       return 0;
> > +err:
> > +       printk("apply_changes failed\n");
> > +       return r;
> > +}
> > +
> > +int omapvid_setup_overlay(struct omap_vout_device *vout,
> > +               struct omap_overlay *ovl, int posx, int posy, int
> outw,
> > +               int outh, u32 addr)
> > +{
> > +       int r = 0;
> > +       enum omap_color_mode mode = 0;
> > +
> > +       if ((ovl->caps & OMAP_DSS_OVL_CAP_SCALE) == 0 &&
> > +                       (outw != vout->pix.width || outh != vout-
> >pix.height)) {
> > +               r = -EINVAL;
> > +               goto err;
> > +       }
> > +
> > +       mode = video_mode_to_dss_mode(&(vout->pix));
> > +
> > +       if (mode == -EINVAL) {
> > +               r = -EINVAL;
> > +               goto err;
> > +       }
> > +
> > +       r = ovl->setup_input(ovl, (u32)addr, (void *)addr, vout-
> >pix.width,
> > +                       vout->crop.width, vout->crop.height,
> mode);
> > +
> > +       if (r)
> > +               goto err;
> > +
> > +       r = ovl->setup_output(ovl, posx, posy, outw, outh);
> > +
> > +       if (r)
> > +               goto err;
> > +
> > +       return 0;
> > +
> > +err:
> > +       printk(KERN_WARNING "setup_overlay failed\n");
> > +       return r;
> > +}
> > +
> > +static enum omap_color_mode video_mode_to_dss_mode(struct
> v4l2_pix_format *pix)
> > +{
> > +       switch (pix->pixelformat) {
> > +
> > +       case 0:
> > +               break;
> > +       case V4L2_PIX_FMT_YUYV:
> > +               return OMAP_DSS_COLOR_YUV2;
> > +
> > +       case V4L2_PIX_FMT_UYVY:
> > +               return OMAP_DSS_COLOR_UYVY;
> > +
> > +       case V4L2_PIX_FMT_RGB565:
> > +               return OMAP_DSS_COLOR_RGB16;
> > +
> > +       case V4L2_PIX_FMT_RGB24:
> > +               return OMAP_DSS_COLOR_RGB24P;
> > +
> > +       default:
> > +               return -EINVAL;
> > +       }
> > +
> > +       return -EINVAL;
> > +}
> > +
> > +static struct platform_driver omap_vout_driver = {
> > +       .driver = {
> > +                  .name = VOUT_NAME,
> > +                  },
> > +       .probe = omap_vout_probe,
> > +       .remove = omap_vout_remove,
> > +};
> > +
> > +void
> > +omap_vout_isr(void *arg, unsigned int irqstatus)
> > +{
> > +       int r;
> > +
> > +       struct timeval timevalue;
> > +       struct omap_vout_device *vout =
> > +           (struct omap_vout_device *) arg;
> > +       u32 addr;
> > +
> > +       if (!vout->streaming)
> > +               return;
> > +
> > +       spin_lock(&vout->vbq_lock);
> > +       do_gettimeofday(&timevalue);
> > +
> > +       if (!(irqstatus & DISPC_IRQSTATUS_VSYNC))
> > +               return;
> > +
> > +       if (!vout->first_int && (vout->curFrm != vout->nextFrm)) {
> > +               vout->curFrm->ts = timevalue;
> > +               vout->curFrm->state = VIDEOBUF_DONE;
> > +               wake_up_interruptible(&vout->curFrm->done);
> > +               vout->curFrm = vout->nextFrm;
> > +       }
> > +       vout->first_int = 0;
> > +       if (list_empty(&vout->dma_queue)) {
> > +               spin_unlock(&vout->vbq_lock);
> > +               return;
> > +       }
> > +
> > +       vout->nextFrm = list_entry(vout->dma_queue.next,
> > +                                  struct videobuf_buffer, queue);
> > +       list_del(&vout->nextFrm->queue);
> > +
> > +       vout->nextFrm->state = VIDEOBUF_ACTIVE;
> > +
> > +       addr = (unsigned long) vout->queued_buf_addr[vout-
> >nextFrm->i] +
> > +                   vout->cropped_offset;
> > +
> > +       r = omapvid_apply_changes(vout, addr, 0);
> > +       if (r)
> > +               printk(KERN_ERR VOUT_NAME "failed to change
> mode\n");
> > +       spin_unlock(&vout->vbq_lock);
> > +}
> > +
> > +static void omap_vout_cleanup_device(struct omap_vout_device
> *vout)
> > +{
> > +
> > +       struct video_device *vfd;
> > +       int i, numbuffers;
> > +
> > +       if (!vout)
> > +               return;
> > +       vfd = vout->vfd;
> > +
> > +       if (vfd) {
> > +               if (vfd->minor == -1) {
> > +                       /*
> > +                        * The device was never registered, so
> release the
> > +                        * video_device struct directly.
> > +                        */
> > +                       video_device_release(vfd);
> > +               } else {
> > +                       /*
> > +                        * The unregister function will release
> the video_device
> > +                        * struct as well as unregistering it.
> > +                        */
> > +                       video_unregister_device(vfd);
> > +               }
> > +       }
> > +
> > +       /* Allocate memory for the buffes */
> > +       numbuffers = (vout->vid) ?  video2_numbuffers :
> video1_numbuffers;
> > +       vout->buffer_size = (vout->vid) ? video2_bufsize :
> video1_bufsize;
> > +
> > +       for (i = 0; i < numbuffers; i++) {
> > +               omap_vout_free_buffer(vout->buf_virt_addr[i],
> > +                        vout->buf_phy_addr[i], vout-
> >buffer_size);
> > +               vout->buf_phy_addr[i] = 0;
> > +               vout->buf_virt_addr[i] = 0;
> > +       }
> > +
> > +       kfree(vout);
> > +
> > +       if (!(vout->vid))
> > +               saved_v1out = NULL;
> > +       else
> > +               saved_v2out = NULL;
> > +}
> > +
> > +static int __init omap_vout_init(void)
> > +{
> > +
> > +       if (platform_driver_register(&omap_vout_driver) != 0) {
> > +               printk(KERN_ERR VOUT_NAME ": could not register \
> > +                               Video driver\n");
> > +               return -EINVAL;
> > +       }
> > +       return 0;
> > +}
> > +
> > +static void omap_vout_cleanup(void)
> > +{
> > +       platform_driver_unregister(&omap_vout_driver);
> > +}
> > +
> > +MODULE_AUTHOR("Texas Instruments.");
> > +MODULE_DESCRIPTION("OMAP Video for Linux Video out driver");
> > +MODULE_LICENSE("GPL");
> > +
> > +late_initcall(omap_vout_init);
> > +module_exit(omap_vout_cleanup);
> > diff --git a/drivers/media/video/omap/omap_voutdef.h
> b/drivers/media/video/omap/omap_voutdef.h
> > new file mode 100644
> > index 0000000..9e96540
> > --- /dev/null
> > +++ b/drivers/media/video/omap/omap_voutdef.h
> > @@ -0,0 +1,138 @@
> > +/*
> > + * drivers/media/video/omap/omap_voutdef.h
> > + *
> > + * Copyright (C) 2005 Texas Instruments.
> > + *
> > + * This file is licensed under the terms of the GNU General
> Public License
> > + * version 2. This program is licensed "as is" without any
> warranty of any
> > + * kind, whether express or implied.
> > + */
> > +
> > +#ifndef OMAP_VOUTDEF_H
> > +#define OMAP_VOUTDEF_H
> > +
> > +#include <mach/display.h>
> > +
> > +#define YUYV_BPP        2
> > +#define RGB565_BPP      2
> > +#define RGB24_BPP       3
> > +#define RGB32_BPP       4
> > +#define TILE_SIZE       32
> > +#define YUYV_VRFB_BPP   2
> > +#define RGB_VRFB_BPP    1
> > +
> > +/*
> > + * This structure is used to store the DMA transfer parameters
> > + * for VRFB hidden buffer
> > + */
> > +struct vid_vrfb_dma {
> > +       int dev_id;
> > +       int dma_ch;
> > +       int req_status;
> > +       int tx_status;
> > +       wait_queue_head_t wait;
> > +};
> > +
> > +struct omapvideo_info {
> > +       int id;
> > +       int num_overlays;
> > +       struct omap_overlay *overlays[3];
> > +       struct omap2video_device *vid_dev;
> > +};
> > +
> > +struct omap2video_device {
> > +       struct device *dev;
> > +       struct mutex  mtx;
> > +
> > +       int state;
> > +
> > +       int num_videos;
> > +       struct omap_vout_device *vouts[10];
> > +
> > +       int num_displays;
> > +       struct omap_display *displays[10];
> > +       int num_overlays;
> > +       struct omap_overlay *overlays[10];
> > +       int num_managers;
> > +       struct omap_overlay_manager *managers[10];
> > +};
> > +
> > +/* per-device data structure */
> > +struct omap_vout_device {
> > +
> > +       struct omapvideo_info vid_info;
> > +       struct device dev;
> > +       struct video_device *vfd;
> > +       int vid;
> > +       int opened;
> > +
> > +       /* Power management suspend lockout stuff */
> > +       int suspended;
> > +       wait_queue_head_t suspend_wq;
> > +
> > +       /* we don't allow to change image fmt/size once buffer has
> > +        * been allocated
> > +        */
> > +       int buffer_allocated;
> > +       /* allow to reuse previosuly allocated buffer which is big
> enough */
> > +       int buffer_size;
> > +       /* keep buffer info accross opens */
> > +       unsigned long buf_virt_addr[VIDEO_MAX_FRAME];
> > +       unsigned long buf_phy_addr[VIDEO_MAX_FRAME];
> > +       unsigned int buf_memory_type;
> > +
> > +       /* we don't allow to request new buffer when old buffers
> are
> > +        * still mmaped
> > +        */
> > +       int mmap_count;
> > +
> > +       spinlock_t vbq_lock;            /* spinlock for videobuf
> queues */
> > +       unsigned long field_count;      /* field counter for
> videobuf_buffer */
> > +
> > +       /* non-NULL means streaming is in progress. */
> > +       struct omap_vout_fh *streaming;
> > +
> > +       struct v4l2_pix_format pix;
> > +       struct v4l2_rect crop;
> > +       struct v4l2_window win;
> > +       struct v4l2_framebuffer fbuf;
> > +
> > +       /* Lock to protect the shared data structures in ioctl */
> > +       struct semaphore lock;
> > +
> > +       /* rotation variablse goes here */
> > +       unsigned long sms_rot_virt[4]; /* virtual addresss for
> four angles */
> > +                                       /* four angles */
> > +       dma_addr_t sms_rot_phy[4][4];
> > +
> > +       /* V4L2 control structure for different control id */
> > +
> > +       int bpp; /* bytes per pixel */
> > +       int vrfb_bpp; /* bytes per pixel with respect to VRFB */
> > +
> > +       struct vid_vrfb_dma vrfb_dma_tx;
> > +       unsigned int smsshado_phy_addr[4];
> > +       unsigned int smsshado_virt_addr[4];
> > +       unsigned int vrfb_context[4];
> > +       unsigned int smsshado_size;
> > +       unsigned char pos;
> > +
> > +       int ps, vr_ps, line_length, first_int, field_id;
> > +       enum v4l2_memory memory;
> > +       struct videobuf_buffer *curFrm, *nextFrm;
> > +       struct list_head dma_queue;
> > +       u8 *queued_buf_addr[32];
> > +       u32 cropped_offset;
> > +       s32 tv_field1_offset;
> > +
> > +};
> > +
> > +/* per-filehandle data structure */
> > +struct omap_vout_fh {
> > +       struct omap_vout_device *vout;
> > +       enum v4l2_buf_type type;
> > +       struct videobuf_queue vbq;
> > +       int io_allowed;
> > +};
> > +
> > +#endif /* ifndef OMAP_VOUTDEF_H */
> > diff --git a/drivers/media/video/omap/omap_voutlib.c
> b/drivers/media/video/omap/omap_voutlib.c
> > new file mode 100644
> > index 0000000..c51a413
> > --- /dev/null
> > +++ b/drivers/media/video/omap/omap_voutlib.c
> > @@ -0,0 +1,281 @@
> > +/*
> > + * drivers/media/video/omap/omap_voutlib.c
> > + *
> > + * Copyright (C) 2008 Texas Instruments.
> > + *
> > + * This file is licensed under the terms of the GNU General
> Public License
> > + * version 2. This program is licensed "as is" without any
> warranty of any
> > + * kind, whether express or implied.
> > + *
> > + * Based on the OMAP2 camera driver
> > + * Video-for-Linux (Version 2) camera capture driver for
> > + * the OMAP24xx camera controller.
> > + *
> > + * Author: Andy Lowe (source@mvista.com)
> > + *
> > + * Copyright (C) 2004 MontaVista Software, Inc.
> > + * Copyright (C) 2004 Texas Instruments.
> > + *
> > + */
> > +
> > +#include <linux/init.h>
> > +#include <linux/module.h>
> > +#include <linux/delay.h>
> > +#include <linux/errno.h>
> > +#include <linux/kernel.h>
> > +#include <linux/vmalloc.h>
> > +#include <linux/slab.h>
> > +#include <linux/sched.h>
> > +#include <linux/smp_lock.h>
> > +#include <linux/kdev_t.h>
> > +#include <linux/types.h>
> > +#include <linux/wait.h>
> > +#include <linux/videodev2.h>
> > +#include <linux/semaphore.h>
> > +
> > +/* Return the default overlay cropping rectangle in crop given
> the image
> > + * size in pix and the video display size in fbuf.  The default
> > + * cropping rectangle is the largest rectangle no larger than the
> capture size
> > + * that will fit on the display.  The default cropping rectangle
> is centered in
> > + * the image.  All dimensions and offsets are rounded down to
> even numbers.
> > + */
> > +void omap_vout_default_crop(struct v4l2_pix_format *pix,
> > +                 struct v4l2_framebuffer *fbuf, struct v4l2_rect
> *crop)
> > +{
> > +       crop->width = (pix->width < fbuf->fmt.width) ?
> > +               pix->width : fbuf->fmt.width;
> > +       crop->height = (pix->height < fbuf->fmt.height) ?
> > +               pix->height : fbuf->fmt.height;
> > +       crop->width &= ~1;
> > +       crop->height &= ~1;
> > +       crop->left = ((pix->width - crop->width) >> 1) & ~1;
> > +       crop->top = ((pix->height - crop->height) >> 1) & ~1;
> > +}
> > +EXPORT_SYMBOL_GPL(omap_vout_default_crop);
> > +/* Given a new render window in new_win, adjust the window to the
> > + * nearest supported configuration.  The adjusted window
> parameters are
> > + * returned in new_win.
> > + * Returns zero if succesful, or -EINVAL if the requested window
> is
> > + * impossible and cannot reasonably be adjusted.
> > + */
> > +int omap_vout_try_window(struct v4l2_framebuffer *fbuf,
> > +                       struct v4l2_window *new_win)
> > +{
> > +       struct v4l2_rect try_win;
> > +
> > +       /* make a working copy of the new_win rectangle */
> > +       try_win = new_win->w;
> > +
> > +       /* adjust the preview window so it fits on the display by
> clipping any
> > +        * offscreen areas
> > +        */
> > +       if (try_win.left < 0) {
> > +               try_win.width += try_win.left;
> > +               try_win.left = 0;
> > +       }
> > +       if (try_win.top < 0) {
> > +               try_win.height += try_win.top;
> > +               try_win.top = 0;
> > +       }
> > +       try_win.width = (try_win.width < fbuf->fmt.width) ?
> > +               try_win.width : fbuf->fmt.width;
> > +       try_win.height = (try_win.height < fbuf->fmt.height) ?
> > +               try_win.height : fbuf->fmt.height;
> > +       if (try_win.left + try_win.width > fbuf->fmt.width)
> > +               try_win.width = fbuf->fmt.width - try_win.left;
> > +       if (try_win.top + try_win.height > fbuf->fmt.height)
> > +               try_win.height = fbuf->fmt.height - try_win.top;
> > +       try_win.width &= ~1;
> > +       try_win.height &= ~1;
> > +
> > +       if (try_win.width <= 0 || try_win.height <= 0)
> > +               return -EINVAL;
> > +
> > +       /* We now have a valid preview window, so go with it */
> > +       new_win->w = try_win;
> > +       new_win->field = /*V4L2_FIELD_NONE*/V4L2_FIELD_ANY;
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(omap_vout_try_window);
> > +
> > +/* Given a new render window in new_win, adjust the window to the
> > + * nearest supported configuration.  The image cropping window in
> crop
> > + * will also be adjusted if necessary.  Preference is given to
> keeping the
> > + * the window as close to the requested configuration as
> possible.  If
> > + * successful, new_win, vout->win, and crop are updated.
> > + * Returns zero if succesful, or -EINVAL if the requested preview
> window is
> > + * impossible and cannot reasonably be adjusted.
> > + */
> > +int omap_vout_new_window(struct v4l2_rect *crop,
> > +               struct v4l2_window *win, struct v4l2_framebuffer
> *fbuf,
> > +               struct v4l2_window *new_win)
> > +{
> > +       int err;
> > +
> > +       err = omap_vout_try_window(fbuf, new_win);
> > +       if (err)
> > +               return err;
> > +
> > +       /* update our preview window */
> > +       win->w = new_win->w;
> > +       win->field = new_win->field;
> > +       win->chromakey = new_win->chromakey;
> > +
> > +       /* adjust the cropping window to allow for resizing
> limitations */
> > +       if ((crop->height/win->w.height) >= 2) {
> > +               /* The maximum vertical downsizing ratio is 2:1 */
> > +               crop->height = win->w.height * 2;
> > +       }
> > +       if ((crop->width/win->w.width) >= 2) {
> > +               /* The maximum horizontal downsizing ratio is 2:1
> */
> > +               crop->width = win->w.width * 2;
> > +       }
> > +       if (crop->width > 768) {
> > +               /* The OMAP2420 vertical resizing line buffer is
> 768 pixels
> > +                * wide.  If the cropped image is wider than 768
> pixels then it
> > +                * cannot be vertically resized.
> > +                */
> > +               if (crop->height != win->w.height)
> > +                       crop->width = 768;
> > +       }
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(omap_vout_new_window);
> > +
> > +/* Given a new cropping rectangle in new_crop, adjust the
> cropping rectangle to
> > + * the nearest supported configuration.  The image render window
> in win will
> > + * also be adjusted if necessary.  The preview window is adjusted
> such that the
> > + * horizontal and vertical rescaling ratios stay constant.  If
> the render
> > + * window would fall outside the display boundaries, the cropping
> rectangle
> > + * will also be adjusted to maintain the rescaling ratios.  If
> successful, crop
> > + * and win are updated.
> > + * Returns zero if succesful, or -EINVAL if the requested
> cropping rectangle is
> > + * impossible and cannot reasonably be adjusted.
> > + */
> > +int omap_vout_new_crop(struct v4l2_pix_format *pix,
> > +             struct v4l2_rect *crop, struct v4l2_window *win,
> > +             struct v4l2_framebuffer *fbuf, const struct
> v4l2_rect *new_crop)
> > +{
> > +       struct v4l2_rect try_crop;
> > +       unsigned long vresize, hresize;
> > +
> > +       /* make a working copy of the new_crop rectangle */
> > +       try_crop = *new_crop;
> > +
> > +       /* adjust the cropping rectangle so it fits in the image
> */
> > +       if (try_crop.left < 0) {
> > +               try_crop.width += try_crop.left;
> > +               try_crop.left = 0;
> > +       }
> > +       if (try_crop.top < 0) {
> > +               try_crop.height += try_crop.top;
> > +               try_crop.top = 0;
> > +       }
> > +       try_crop.width = (try_crop.width < pix->width) ?
> > +               try_crop.width : pix->width;
> > +       try_crop.height = (try_crop.height < pix->height) ?
> > +               try_crop.height : pix->height;
> > +       if (try_crop.left + try_crop.width > pix->width)
> > +               try_crop.width = pix->width - try_crop.left;
> > +       if (try_crop.top + try_crop.height > pix->height)
> > +               try_crop.height = pix->height - try_crop.top;
> > +       try_crop.width &= ~1;
> > +       try_crop.height &= ~1;
> > +       if (try_crop.width <= 0 || try_crop.height <= 0)
> > +               return -EINVAL;
> > +
> > +       if (crop->height != win->w.height) {
> > +               /* If we're resizing vertically, we can't support
> a crop width
> > +                * wider than 768 pixels.
> > +                */
> > +               if (try_crop.width > 768)
> > +                       try_crop.width = 768;
> > +       }
> > +       /* vertical resizing */
> > +       vresize = (1024 * crop->height) / win->w.height;
> > +       if (vresize > 2048)
> > +               vresize = 2048;
> > +       else if (vresize == 0)
> > +               vresize = 1;
> > +       win->w.height = ((1024 * try_crop.height) / vresize) & ~1;
> > +       if (win->w.height == 0)
> > +               win->w.height = 2;
> > +       if (win->w.height + win->w.top > fbuf->fmt.height) {
> > +               /* We made the preview window extend below the
> bottom of the
> > +                * display, so clip it to the display boundary and
> resize the
> > +                * cropping height to maintain the vertical
> resizing ratio.
> > +                */
> > +               win->w.height = (fbuf->fmt.height - win->w.top) &
> ~1;
> > +               if (try_crop.height == 0)
> > +                       try_crop.height = 2;
> > +       }
> > +       /* horizontal resizing */
> > +       hresize = (1024 * crop->width) / win->w.width;
> > +       if (hresize > 2048)
> > +               hresize = 2048;
> > +       else if (hresize == 0)
> > +               hresize = 1;
> > +       win->w.width = ((1024 * try_crop.width) / hresize) & ~1;
> > +       if (win->w.width == 0)
> > +               win->w.width = 2;
> > +       if (win->w.width + win->w.left > fbuf->fmt.width) {
> > +               /* We made the preview window extend past the
> right side of the
> > +                * display, so clip it to the display boundary and
> resize the
> > +                * cropping width to maintain the horizontal
> resizing ratio.
> > +                */
> > +               win->w.width = (fbuf->fmt.width - win->w.left) &
> ~1;
> > +               if (try_crop.width == 0)
> > +                       try_crop.width = 2;
> > +       }
> > +
> > +       /* Check for resizing constraints */
> > +       if ((try_crop.height/win->w.height) >= 2) {
> > +               /* The maximum vertical downsizing ratio is 2:1 */
> > +               try_crop.height = win->w.height * 2;
> > +       }
> > +       if ((try_crop.width/win->w.width) >= 2) {
> > +               /* The maximum horizontal downsizing ratio is 2:1
> */
> > +               try_crop.width = win->w.width * 2;
> > +       }
> > +       if (try_crop.width > 768) {
> > +               /* The OMAP2420 vertical resizing line buffer is
> 768 pixels
> > +                * wide.  If the cropped image is wider than 768
> pixels then it
> > +                * cannot be vertically resized.
> > +                */
> > +               if (try_crop.height != win->w.height)
> > +                       try_crop.width = 768;
> > +       }
> > +
> > +       /* update our cropping rectangle and we're done */
> > +       *crop = try_crop;
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(omap_vout_new_crop);
> > +
> > +/* Given a new format in pix and fbuf,  crop and win
> > + * structures are initialized to default values. crop
> > + * is initialized to the largest window size that will fit on the
> display.  The
> > + * crop window is centered in the image. win is initialized to
> > + * the same size as crop and is centered on the display.
> > + * All sizes and offsets are constrained to be even numbers.
> > + */
> > +void omap_vout_new_format(struct v4l2_pix_format *pix,
> > +               struct v4l2_framebuffer *fbuf, struct v4l2_rect
> *crop,
> > +               struct v4l2_window *win)
> > +{
> > +       /* crop defines the preview source window in the image
> capture
> > +        * buffer
> > +        */
> > +       omap_vout_default_crop(pix, fbuf, crop);
> > +
> > +       /* win defines the preview target window on the display */
> > +       win->w.width = crop->width;
> > +       win->w.height = crop->height;
> > +       win->w.left = ((fbuf->fmt.width - win->w.width) >> 1) &
> ~1;
> > +       win->w.top = ((fbuf->fmt.height - win->w.height) >> 1) &
> ~1;
> > +}
> > +EXPORT_SYMBOL_GPL(omap_vout_new_format);
> > +
> > +MODULE_AUTHOR("Texas Instruments.");
> > +MODULE_DESCRIPTION("OMAP Video library");
> > +MODULE_LICENSE("GPL");
> > diff --git a/drivers/media/video/omap/omap_voutlib.h
> b/drivers/media/video/omap/omap_voutlib.h
> > new file mode 100644
> > index 0000000..d98f659
> > --- /dev/null
> > +++ b/drivers/media/video/omap/omap_voutlib.h
> > @@ -0,0 +1,34 @@
> > +/*
> > + * drivers/media/video/omap/omap_voutlib.h
> > + *
> > + * Copyright (C) 2008 Texas Instruments.
> > + *
> > + * This file is licensed under the terms of the GNU General
> Public License
> > + * version 2. This program is licensed "as is" without any
> warranty of any
> > + * kind, whether express or implied.
> > + *
> > + */
> > +
> > +#ifndef OMAP_VOUTLIB_H
> > +#define OMAP_VOUTLIB_H
> > +
> > +extern void omap_vout_default_crop(struct v4l2_pix_format *pix,
> > +               struct v4l2_framebuffer *fbuf, struct v4l2_rect
> *crop);
> > +
> > +extern int omap_vout_new_crop(struct v4l2_pix_format *pix,
> > +               struct v4l2_rect *crop, struct v4l2_window *win,
> > +               struct v4l2_framebuffer *fbuf,
> > +               const struct v4l2_rect *new_crop);
> > +
> > +extern int omap_vout_try_window(struct v4l2_framebuffer *fbuf,
> > +               struct v4l2_window *new_win);
> > +
> > +extern int omap_vout_new_window(struct v4l2_rect *crop,
> > +               struct v4l2_window *win, struct v4l2_framebuffer
> *fbuf,
> > +               struct v4l2_window *new_win);
> > +
> > +extern void omap_vout_new_format(struct v4l2_pix_format *pix,
> > +               struct v4l2_framebuffer *fbuf, struct v4l2_rect
> *crop,
> > +               struct v4l2_window *win);
> > +#endif /* #ifndef OMAP_LIB_H */
> > +
> > --
> > 1.5.6
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> omap" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> Regards,
> Arun KS
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-
> request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
