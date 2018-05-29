Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:54456 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933732AbeE2Ma5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 08:30:57 -0400
Received: by mail-it0-f65.google.com with SMTP id 76-v6so2943463itx.4
        for <linux-media@vger.kernel.org>; Tue, 29 May 2018 05:30:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180529084845.2al2dmpvjpz6eexp@sirius.home.kraxel.org>
References: <20180525140808.12714-1-kraxel@redhat.com> <20180529082327.GF3438@phenom.ffwll.local>
 <20180529084845.2al2dmpvjpz6eexp@sirius.home.kraxel.org>
From: Daniel Vetter <daniel@ffwll.ch>
Date: Tue, 29 May 2018 14:30:55 +0200
Message-ID: <CAKMK7uGnxNwOUoY=kqG4hW4AZd8Fouh9GRq8Na-fRQUUvF9fZw@mail.gmail.com>
Subject: Re: [PATCH v3] Add udmabuf misc device
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        David Airlie <airlied@linux.ie>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Shuah Khan <shuah@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        "open list:KERNEL SELFTEST FRAMEWORK"
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 29, 2018 at 10:48 AM, Gerd Hoffmann <kraxel@redhat.com> wrote:
>   Hi,
>
>> > +static void *kmap_atomic_udmabuf(struct dma_buf *buf, unsigned long page_num)
>> > +{
>> > +   struct udmabuf *ubuf = buf->priv;
>> > +   struct page *page = ubuf->pages[page_num];
>> > +
>> > +   return kmap_atomic(page);
>> > +}
>> > +
>> > +static void *kmap_udmabuf(struct dma_buf *buf, unsigned long page_num)
>> > +{
>> > +   struct udmabuf *ubuf = buf->priv;
>> > +   struct page *page = ubuf->pages[page_num];
>> > +
>> > +   return kmap(page);
>> > +}
>>
>> The above leaks like mad since no kunamp?
>
> /me checks code.  Oops.  Yes.
>
> The docs say map() is required and unmap() is not (for both atomic and
> non-atomic cases), so I assumed there is a default implementation just
> doing kunmap(page).  Which is not the case.  /me looks a bit surprised.
>
> I'll fix it for v4.
>
>> Also I think we have 0 users of the kmap atomic interfaces ... so not sure
>> whether it's worth it to implement those.
>
> Well, the docs are correct.  kmap_atomic() is required, dma-buf.c calls
> the function pointer without checking it exists beforehand ...

Frankly with the pletoria of dummy kmap functions that just return
NULL; it might be better to move that into core dma-buf code and make
it optional for real. Since it's indeed very surprising.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
