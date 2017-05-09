Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f182.google.com ([209.85.213.182]:36820 "EHLO
        mail-yb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752676AbdEIP2M (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 May 2017 11:28:12 -0400
Received: by mail-yb0-f182.google.com with SMTP id s22so1094131ybe.3
        for <linux-media@vger.kernel.org>; Tue, 09 May 2017 08:28:12 -0700 (PDT)
Received: from mail-yw0-f180.google.com (mail-yw0-f180.google.com. [209.85.161.180])
        by smtp.gmail.com with ESMTPSA id i72sm137569ywc.43.2017.05.09.08.28.09
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 May 2017 08:28:10 -0700 (PDT)
Received: by mail-yw0-f180.google.com with SMTP id b68so2189381ywe.3
        for <linux-media@vger.kernel.org>; Tue, 09 May 2017 08:28:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170502130020.GL7456@valkosipuli.retiisi.org.uk>
References: <cover.1493479141.git.yong.zhi@intel.com> <9cf19d01f6f85ac0e5969a2b2fcd5ad5ef8c1e22.1493479141.git.yong.zhi@intel.com>
 <20170502130020.GL7456@valkosipuli.retiisi.org.uk>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 9 May 2017 23:27:48 +0800
Message-ID: <CAAFQd5Df=wyZcXxU7qOPouCDOQ7HT1XFo5Oh9Tj3uPcT3eDuSg@mail.gmail.com>
Subject: Re: [PATCH 3/3] [media] intel-ipu3: cio2: Add new MIPI-CSI2 driver
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>, hyungwoo.yang@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 2, 2017 at 9:00 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Yong,
>
> Thanks for the patches! Some comments below.
>
> On Sat, Apr 29, 2017 at 06:34:36PM -0500, Yong Zhi wrote:
>> +
>> +/**************** FBPT operations ****************/
>> +
>> +static void cio2_fbpt_exit_dummy(struct cio2_device *cio2)
>> +{
>> +     if (cio2->dummy_lop) {
>> +             dma_free_noncoherent(&cio2->pci_dev->dev, PAGE_SIZE,
>> +                             cio2->dummy_lop, cio2->dummy_lop_bus_addr);
>> +             cio2->dummy_lop = NULL;
>> +     }
>> +     if (cio2->dummy_page) {
>> +             dma_free_noncoherent(&cio2->pci_dev->dev, PAGE_SIZE,
>> +                             cio2->dummy_page, cio2->dummy_page_bus_addr);
>> +             cio2->dummy_page = NULL;
>> +     }
>> +}
>> +
>> +static int cio2_fbpt_init_dummy(struct cio2_device *cio2)
>> +{
>> +     unsigned int i;
>> +
>> +     cio2->dummy_page = dma_alloc_noncoherent(&cio2->pci_dev->dev, PAGE_SIZE,
>> +                                     &cio2->dummy_page_bus_addr, GFP_KERNEL);
>> +     cio2->dummy_lop = dma_alloc_noncoherent(&cio2->pci_dev->dev, PAGE_SIZE,
>> +                                     &cio2->dummy_lop_bus_addr, GFP_KERNEL);
>> +     if (!cio2->dummy_page || !cio2->dummy_lop) {
>> +             cio2_fbpt_exit_dummy(cio2);
>> +             return -ENOMEM;
>> +     }
>> +     /*
>> +      * List of Pointers(LOP) contains 1024x32b pointers to 4KB page each
>> +      * Initialize each entry to dummy_page bus base address.
>> +      */
>> +     for (i = 0; i < PAGE_SIZE / sizeof(*cio2->dummy_lop); i++)
>> +             cio2->dummy_lop[i] = cio2->dummy_page_bus_addr >> PAGE_SHIFT;
>> +
>> +     dma_sync_single_for_device(&cio2->pci_dev->dev, /* DMA phy addr */
>> +                     cio2->dummy_lop_bus_addr, PAGE_SIZE, DMA_TO_DEVICE);
>> +
>> +     return 0;
>> +}
>> +
>> +static void cio2_fbpt_entry_enable(struct cio2_device *cio2,
>> +                                struct cio2_fbpt_entry entry[CIO2_MAX_LOPS])
>> +{
>> +     dma_wmb();
>
> Is there a particular reason to have this?
>
> The documentation states that (Documentation/memory-barriers.txt):
>
>      These are for use with consistent memory to guarantee the ordering
>      of writes or reads of shared memory accessible to both the CPU and a
>      DMA capable device.
>
> This is while the device does not do cache coherent DMA.

I think the first question we should ask is why the driver allocates
non-consistent memory for this kind of structures. Looks like a waste
of cachelines, given that it seems to be a primarily write-only memory
(from CPU point of view), with rare read backs of entry[0] to check
the flags, which can be modified by the device. Moreover, the fact
that the memory is being cached actually defeats the barrier, as you
first write entry[1..N], call the barrier, write entry[0] and then
flush the cache starting from entry[0], which means that the hardware
sees entry[0] (+/- the size of the cacheline) before further entries.

Other than that, I think the barrier makes sense, as the compiler (or
even the CPU or buses) could reorder the writes without it, regardless
of whether the memory is consistent or not. (Of course the cache
flushing problem above remains if the memory is non-consistent.)

Best regards,
Tomasz
