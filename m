Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:36022 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752019AbdFMJTI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 05:19:08 -0400
Received: by mail-yw0-f169.google.com with SMTP id l75so46221670ywc.3
        for <linux-media@vger.kernel.org>; Tue, 13 Jun 2017 02:19:08 -0700 (PDT)
Received: from mail-yw0-f178.google.com (mail-yw0-f178.google.com. [209.85.161.178])
        by smtp.gmail.com with ESMTPSA id e62sm4818996ywh.61.2017.06.13.02.19.07
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Jun 2017 02:19:07 -0700 (PDT)
Received: by mail-yw0-f178.google.com with SMTP id v7so29440728ywc.2
        for <linux-media@vger.kernel.org>; Tue, 13 Jun 2017 02:19:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <374342140.IzTenANyU8@ttoivone-desk1>
References: <1496799279-8774-1-git-send-email-yong.zhi@intel.com>
 <1496799279-8774-4-git-send-email-yong.zhi@intel.com> <CAAFQd5Byemom138duZRpsKOzsb5204NfbFnjEdnDTu6wfLgnrQ@mail.gmail.com>
 <374342140.IzTenANyU8@ttoivone-desk1>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 13 Jun 2017 18:18:46 +0900
Message-ID: <CAAFQd5D20dz4LRhvUaUqZxeGBeXqHvi=mdGRmDbM9ofAscwwsA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] [media] intel-ipu3: cio2: Add new MIPI-CSI2 driver
To: Tuukka Toivonen <tuukka.toivonen@intel.com>
Cc: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tuukka,

Thanks for your replies. Please see mine inline.

On Tue, Jun 13, 2017 at 5:58 PM, Tuukka Toivonen
<tuukka.toivonen@intel.com> wrote:
> Hi Tomasz,
>
> On Monday, June 12, 2017 18:59:18 Tomasz Figa wrote:
>> By any chance, doesn't the hardware provide some simple mode for
>> contiguous buffers? Since we have an MMU anyway, we could use
>> vb2_dma_contig and simplify the code significantly.
>
> In IPU3 the CIO2 (CSI-2 receiver) and the IMGU (image processing system)
> are entirely separate PCI devices. The MMU is only in the IMGU device;
> the CIO2 doesn't have MMU but has the FBPT (frame buffer pointer tables)
> to handle discontinuous buffers.
>
> [...]
>
>>
>> > +               pixelformat = V4L2_PIX_FMT_IPU3_SRGGB10;
>> > +
>> > +       alloc_devs[0] = &cio2->pci_dev->dev;
>>
>> Hmm, so it doesn't go through the IPU MMU in the end?
>
> No, it doesn't.

Aha. I was confused by the fact that the driver calls
dma_alloc_(non)coherent() with sizes likely greater than PAGE_SIZE.

So, given the above, I believe we need to fix the LOP allocation to
allocate one page at a time and stop relying on bus address
contiguity.

>> > +/* Called after each buffer is allocated */
>> > +static int cio2_vb2_buf_init(struct vb2_buffer *vb)
>> > +{
>> > +       struct cio2_device *cio2 = vb2_get_drv_priv(vb->vb2_queue);
>> > +       struct device *dev = &cio2->pci_dev->dev;
>> > +       struct cio2_buffer *b =
>> > +               container_of(vb, struct cio2_buffer, vbb.vb2_buf);
>> > +       unsigned int length = vb->planes[0].length;
>> > +       int lops  = DIV_ROUND_UP(DIV_ROUND_UP(length, PAGE_SIZE) +
> 1,
>> > +                                PAGE_SIZE / sizeof(u32));
>> > +       u32 *lop;
>> > +       struct sg_table *sg;
>> > +       struct sg_page_iter sg_iter;
>> > +
>> > +       if (lops <= 0 || lops > CIO2_MAX_LOPS) {
>> > +               dev_err(dev, "%s: bad buffer size (%i)\n", __func__,
> length);
>> > +               return -ENOSPC;         /* Should never happen */
>> > +       }
>> > +
>> > +       /* Allocate LOP table */
>> > +       b->lop = lop = dma_alloc_noncoherent(dev, lops * PAGE_SIZE,
>> > +                                       &b->lop_bus_addr,
> GFP_KERNEL);

^^ Here is the offending allocation.

>>
>> > +               u32 fbpt_rp =
>> > +                       (readl(cio2->base +
> CIO2_REG_CDMARI(CIO2_DMA_CHAN))
>> > +                        >> CIO2_CDMARI_FBPT_RP_SHIFT)
>> > +                       & CIO2_CDMARI_FBPT_RP_MASK;
>> > +
>> > +               /*
>> > +                * fbpt_rp is the fbpt entry that the dma is
> currently working
>> > +                * on, but since it could jump to next entry at any
> time,
>> > +                * assume that we might already be there.
>> > +                */
>> > +               fbpt_rp = (fbpt_rp + 1) % CIO2_MAX_BUFFERS;
>>
>> Hmm, this is really racy. This code can be pre-empted and not execute
>> for quite long time, depending on system load, resuming after the
>> hardware goes even further. Technically you could prevent this using
>> *_irq_save()/_irq_restore(), but I'd try to find a way that doesn't
>> rely on the timing, if possible.
>
> That is true, if the driver doesn't get executed in more than one frame
> time. I don't think that's very common, but should be handled.
>
> Hmm. Actually the buffer has VALID bit which is set by driver to indicate
> that the HW can fill the buffer and cleared by HW to indicate that the
> buffer is filled. Probably the HW can not actually jump to the next
> buffer as suggested by the comment, because I think the VALID bit
> would be clear in that case. That should be checked.

I think the problem here is that we keep all the entries valid and
only point to dummy buffers if there are no buffers queued by
userspace.

>
>>
>> > +
>> > +               if (bufs_queued <= 1)
>> > +                       next = fbpt_rp + 1;     /* Buffers were
> drained */
>> > +               else if (fbpt_rp == next)
>> > +                       next++;
>> > +               next %= CIO2_MAX_BUFFERS;
>> > +       }
>> > +
>> > +       while (q->bufs[next]) {
>> > +               /* If the entry is used, get the next one,
>> > +                * We can not break here if all are filled,
>> > +                * Will wait for one free, otherwise it will crash
>> > +                */
>
> That comment should be fixed. "otherwise it will crash" doesn't
> tell much useful. Why would it crash?
>
>> > +               dev_dbg(&cio2->pci_dev->dev,
>> > +                       "entry %i was already full!\n", next);
>> > +               next = (next + 1) % CIO2_MAX_BUFFERS;
>>
>> A busy waiting, possibly infinite, loop. Hmm.
>
> It's not really busy waiting. We have allocated CIO2_MAX_BUFFERS
> buffers (or actually just buffer entries in HW table) circularly for the
> hardware, and then the user has requested N buffer queue. The driver
> ensures N <= CIO2_MAX_BUFFERS and this guarantees that whenever user
> queues a buffer, there necessarily is a free buffer in the hardware
> circular buffer list. The loop above finds the first free buffer from the
> circular list, which necessarily exists. In practice it should be always
> the very first since that is the oldest one given to hardware.
>
>>
>> I think we could do something smarter here, such as sleeping on a
>> wait_queue, which is woken up from the interrupt handler.
>
> I think that's a bit complicated for situation which should be never
> possible to happen.
>
>> Also, why do you think it will crash? I think you can just do return
>> the buffer to vb2 with _ERROR status and bail out, if you can't queue
>> due to some failure.
>
> Agree.

Given your explanation, wouldn't it make sense to actually make the
loop finite, limited by the number of buffers and if (due to some
unforeseen condition, like a driver bug) there is no buffer available
until then, error out?

Best regards,
Tomasz
