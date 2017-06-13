Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:48451 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751753AbdFMI6p (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 04:58:45 -0400
From: Tuukka Toivonen <tuukka.toivonen@intel.com>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>
Subject: Re: [PATCH v2 3/3] [media] intel-ipu3: cio2: Add new MIPI-CSI2 driver
Date: Tue, 13 Jun 2017 11:58:40 +0300
Message-ID: <374342140.IzTenANyU8@ttoivone-desk1>
In-Reply-To: <CAAFQd5Byemom138duZRpsKOzsb5204NfbFnjEdnDTu6wfLgnrQ@mail.gmail.com>
References: <1496799279-8774-1-git-send-email-yong.zhi@intel.com> <1496799279-8774-4-git-send-email-yong.zhi@intel.com> <CAAFQd5Byemom138duZRpsKOzsb5204NfbFnjEdnDTu6wfLgnrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Monday, June 12, 2017 18:59:18 Tomasz Figa wrote:
> By any chance, doesn't the hardware provide some simple mode for
> contiguous buffers? Since we have an MMU anyway, we could use
> vb2_dma_contig and simplify the code significantly.

In IPU3 the CIO2 (CSI-2 receiver) and the IMGU (image processing system) 
are entirely separate PCI devices. The MMU is only in the IMGU device; 
the CIO2 doesn't have MMU but has the FBPT (frame buffer pointer tables) 
to handle discontinuous buffers.

[...]

> 
> > +               pixelformat = V4L2_PIX_FMT_IPU3_SRGGB10;
> > +
> > +       alloc_devs[0] = &cio2->pci_dev->dev;
> 
> Hmm, so it doesn't go through the IPU MMU in the end?

No, it doesn't.

> 
> > +       szimage = cio2_bytesperline(width) * height;
> > +
> > +       if (*num_planes) {
> > +               /*
> > +                * Only single plane is supported
> > +                */
> > +               if (*num_planes != 1 || sizes[0] < szimage)
> > +                       return -EINVAL;
> 
> S_FMT should validate this and then queue_setup should never get an
> invalid value.
> 
> > +       }
> > +
> > +       *num_planes = 1;
> > +       sizes[0] = szimage;
> > +
> > +       *num_buffers = clamp_val(*num_buffers, 1, CIO2_MAX_BUFFERS);
> > +
> > +       /* Initialize buffer queue */
> > +       for (i = 0; i < CIO2_MAX_BUFFERS; i++) {
> > +               q->bufs[i] = NULL;
> > +               cio2_fbpt_entry_init_dummy(cio2, &q->fbpt[i * 
CIO2_MAX_LOPS]);
> > +       }
> > +       atomic_set(&q->bufs_queued, 0);
> > +       q->bufs_first = 0;
> > +       q->bufs_next = 0;
> > +
> > +       return r;
> > +}
> > +
> > +/* Called after each buffer is allocated */
> > +static int cio2_vb2_buf_init(struct vb2_buffer *vb)
> > +{
> > +       struct cio2_device *cio2 = vb2_get_drv_priv(vb->vb2_queue);
> > +       struct device *dev = &cio2->pci_dev->dev;
> > +       struct cio2_buffer *b =
> > +               container_of(vb, struct cio2_buffer, vbb.vb2_buf);
> > +       unsigned int length = vb->planes[0].length;
> > +       int lops  = DIV_ROUND_UP(DIV_ROUND_UP(length, PAGE_SIZE) + 
1,
> > +                                PAGE_SIZE / sizeof(u32));
> > +       u32 *lop;
> > +       struct sg_table *sg;
> > +       struct sg_page_iter sg_iter;
> > +
> > +       if (lops <= 0 || lops > CIO2_MAX_LOPS) {
> > +               dev_err(dev, "%s: bad buffer size (%i)\n", __func__, 
length);
> > +               return -ENOSPC;         /* Should never happen */
> > +       }
> > +
> > +       /* Allocate LOP table */
> > +       b->lop = lop = dma_alloc_noncoherent(dev, lops * PAGE_SIZE,
> > +                                       &b->lop_bus_addr, 
GFP_KERNEL);
> 
> _coherent?
> 
> > +       if (!lop)
> > +               return -ENOMEM;
> > +
> > +       /* Fill LOP */
> > +       sg = vb2_dma_sg_plane_desc(vb, 0);
> > +       if (!sg)
> > +               return -EFAULT;
> 
> I'd say -ENOMEM is better here. (But actually it should be impossible,
> if allocation succeeded previously.)
> 
> > +
> > +       for_each_sg_page(sg->sgl, &sg_iter, sg->nents, 0)
> > +               *lop++ = sg_page_iter_dma_address(&sg_iter) >> 
PAGE_SHIFT;
> > +       *lop++ = cio2->dummy_page_bus_addr >> PAGE_SHIFT;
> > +
> > +       return 0;
> > +}
> > +
> > +/* Transfer buffer ownership to cio2 */
> > +static void cio2_vb2_buf_queue(struct vb2_buffer *vb)
> > +{
> > +       struct cio2_device *cio2 = vb2_get_drv_priv(vb->vb2_queue);
> > +       struct cio2_queue *q =
> > +               container_of(vb->vb2_queue, struct cio2_queue, vbq);
> > +       struct cio2_buffer *b =
> > +               container_of(vb, struct cio2_buffer, vbb.vb2_buf);
> > +       struct cio2_fbpt_entry *entry;
> > +       unsigned int next = q->bufs_next;
> > +       int bufs_queued = atomic_inc_return(&q->bufs_queued);
> > +
> > +       if (vb2_start_streaming_called(&q->vbq)) {
> 
> Shouldn't it be vb2_is_streaming()? (There is not much difference,
> though, except that vb2_start_streaming_called() returns true, even
> before .start_streaming finished, while vb2_is_streaming() does so
> only after it returns successfully.)
> 
> > +               u32 fbpt_rp =
> > +                       (readl(cio2->base + 
CIO2_REG_CDMARI(CIO2_DMA_CHAN))
> > +                        >> CIO2_CDMARI_FBPT_RP_SHIFT)
> > +                       & CIO2_CDMARI_FBPT_RP_MASK;
> > +
> > +               /*
> > +                * fbpt_rp is the fbpt entry that the dma is 
currently working
> > +                * on, but since it could jump to next entry at any 
time,
> > +                * assume that we might already be there.
> > +                */
> > +               fbpt_rp = (fbpt_rp + 1) % CIO2_MAX_BUFFERS;
> 
> Hmm, this is really racy. This code can be pre-empted and not execute
> for quite long time, depending on system load, resuming after the
> hardware goes even further. Technically you could prevent this using
> *_irq_save()/_irq_restore(), but I'd try to find a way that doesn't
> rely on the timing, if possible.

That is true, if the driver doesn't get executed in more than one frame 
time. I don't think that's very common, but should be handled.

Hmm. Actually the buffer has VALID bit which is set by driver to indicate
that the HW can fill the buffer and cleared by HW to indicate that the
buffer is filled. Probably the HW can not actually jump to the next
buffer as suggested by the comment, because I think the VALID bit
would be clear in that case. That should be checked.

> 
> > +
> > +               if (bufs_queued <= 1)
> > +                       next = fbpt_rp + 1;     /* Buffers were 
drained */
> > +               else if (fbpt_rp == next)
> > +                       next++;
> > +               next %= CIO2_MAX_BUFFERS;
> > +       }
> > +
> > +       while (q->bufs[next]) {
> > +               /* If the entry is used, get the next one,
> > +                * We can not break here if all are filled,
> > +                * Will wait for one free, otherwise it will crash
> > +                */

That comment should be fixed. "otherwise it will crash" doesn't
tell much useful. Why would it crash?

> > +               dev_dbg(&cio2->pci_dev->dev,
> > +                       "entry %i was already full!\n", next);
> > +               next = (next + 1) % CIO2_MAX_BUFFERS;
> 
> A busy waiting, possibly infinite, loop. Hmm.

It's not really busy waiting. We have allocated CIO2_MAX_BUFFERS
buffers (or actually just buffer entries in HW table) circularly for the
hardware, and then the user has requested N buffer queue. The driver
ensures N <= CIO2_MAX_BUFFERS and this guarantees that whenever user
queues a buffer, there necessarily is a free buffer in the hardware
circular buffer list. The loop above finds the first free buffer from the
circular list, which necessarily exists. In practice it should be always
the very first since that is the oldest one given to hardware.

> 
> I think we could do something smarter here, such as sleeping on a
> wait_queue, which is woken up from the interrupt handler.

I think that's a bit complicated for situation which should be never
possible to happen.

> Also, why do you think it will crash? I think you can just do return
> the buffer to vb2 with _ERROR status and bail out, if you can't queue
> due to some failure.

Agree.

- Tuukka
