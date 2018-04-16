Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:52452 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753105AbeDPNi6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 09:38:58 -0400
Received: by mail-it0-f67.google.com with SMTP id f6-v6so11386630ita.2
        for <linux-media@vger.kernel.org>; Mon, 16 Apr 2018 06:38:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180416123937.GA9073@infradead.org>
References: <20180325110000.2238-1-christian.koenig@amd.com>
 <20180325110000.2238-4-christian.koenig@amd.com> <20180329065753.GD3881@phenom.ffwll.local>
 <8b823458-8bdc-3217-572b-509a28aae742@gmail.com> <20180403090909.GN3881@phenom.ffwll.local>
 <20180403170645.GB5935@redhat.com> <20180403180832.GZ3881@phenom.ffwll.local> <20180416123937.GA9073@infradead.org>
From: Daniel Vetter <daniel@ffwll.ch>
Date: Mon, 16 Apr 2018 15:38:56 +0200
Message-ID: <CAKMK7uEFVOh-R2_4vs1M22_wDau0oNTgmCcTWDE+ScxL=92+2g@mail.gmail.com>
Subject: Re: [PATCH 4/8] dma-buf: add peer2peer flag
To: Christoph Hellwig <hch@infradead.org>
Cc: Jerome Glisse <jglisse@redhat.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 16, 2018 at 2:39 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Apr 03, 2018 at 08:08:32PM +0200, Daniel Vetter wrote:
>> I did not mean you should dma_map_sg/page. I just meant that using
>> dma_map_resource to fill only the dma address part of the sg table seems
>> perfectly sufficient.
>
> But that is not how the interface work, especially facing sg_dma_len.
>
>> Assuming you get an sg table that's been mapping by calling dma_map_sg was
>> always a bit a case of bending the abstraction to avoid typing code. The
>> only thing an importer ever should have done is look at the dma addresses
>> in that sg table, nothing else.
>
> The scatterlist is not a very good abstraction unfortunately, but it
> it is spread all over the kernel.  And we do expect that anyone who
> gets passed a scatterlist can use sg_page() or sg_virt() (which calls
> sg_page()) on it.  Your changes would break that, and will cause major
> trouble because of that.
>
> If you want to expose p2p memory returned from dma_map_resource in
> dmabuf do not use scatterlists for this please, but with a new interface
> that explicitly passes a virtual address, a dma address and a length
> and make it very clear that virt_to_page will not work on the virtual
> address.

We've broken that assumption in i915 years ago. Not struct page backed
gpu memory is very real.

Of course we'll never feed such a strange sg table to a driver which
doesn't understand it, but allowing sg_page == NULL works perfectly
fine. At least for gpu drivers.

If that's not acceptable then I guess we could go over the entire tree
and frob all the gpu related code to switch over to a new struct
sg_table_might_not_be_struct_page_backed, including all the other
functions we added over the past few years to iterate over sg tables.
But seems slightly silly, given that sg tables seem to do exactly what
we need.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
