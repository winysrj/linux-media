Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:51528 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755458AbeE2Iss (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 04:48:48 -0400
Date: Tue, 29 May 2018 10:48:45 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
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
Subject: Re: [PATCH v3] Add udmabuf misc device
Message-ID: <20180529084845.2al2dmpvjpz6eexp@sirius.home.kraxel.org>
References: <20180525140808.12714-1-kraxel@redhat.com>
 <20180529082327.GF3438@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180529082327.GF3438@phenom.ffwll.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  Hi,

> > +static void *kmap_atomic_udmabuf(struct dma_buf *buf, unsigned long page_num)
> > +{
> > +	struct udmabuf *ubuf = buf->priv;
> > +	struct page *page = ubuf->pages[page_num];
> > +
> > +	return kmap_atomic(page);
> > +}
> > +
> > +static void *kmap_udmabuf(struct dma_buf *buf, unsigned long page_num)
> > +{
> > +	struct udmabuf *ubuf = buf->priv;
> > +	struct page *page = ubuf->pages[page_num];
> > +
> > +	return kmap(page);
> > +}
> 
> The above leaks like mad since no kunamp?

/me checks code.  Oops.  Yes.

The docs say map() is required and unmap() is not (for both atomic and
non-atomic cases), so I assumed there is a default implementation just
doing kunmap(page).  Which is not the case.  /me looks a bit surprised.

I'll fix it for v4.

> Also I think we have 0 users of the kmap atomic interfaces ... so not sure
> whether it's worth it to implement those.

Well, the docs are correct.  kmap_atomic() is required, dma-buf.c calls
the function pointer without checking it exists beforehand ...

cheers,
  Gerd
