Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fireflyinternet.com ([109.228.58.192]:62519 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752735AbeCPNwC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Mar 2018 09:52:02 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Chris Wilson <chris@chris-wilson.co.uk>
To: =?utf-8?q?Christian_K=C3=B6nig?= <ckoenig.leichtzumerken@gmail.com>,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
References: <20180316132049.1748-1-christian.koenig@amd.com>
 <20180316132049.1748-2-christian.koenig@amd.com>
In-Reply-To: <20180316132049.1748-2-christian.koenig@amd.com>
Message-ID: <152120831102.25315.4326885184264378830@mail.alporthouse.com>
Subject: Re: [PATCH 1/5] dma-buf: add optional invalidate_mappings callback v2
Date: Fri, 16 Mar 2018 13:51:51 +0000
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quoting Christian König (2018-03-16 13:20:45)
> @@ -326,6 +338,29 @@ struct dma_buf_attachment {
>         struct device *dev;
>         struct list_head node;
>         void *priv;
> +
> +       /**
> +        * @invalidate_mappings:
> +        *
> +        * Optional callback provided by the importer of the attachment which
> +        * must be set before mappings are created.
> +        *
> +        * If provided the exporter can avoid pinning the backing store while
> +        * mappings exists.

Hmm, no I don't think it avoids the pinning issue entirely. As it stands,
the importer doesn't have a page refcount and so they all rely on the
exporter keeping the dmabuf pages pinned while attached. What can happen
is that given the invalidate cb, the importers can revoke their
attachments, letting the exporter recover the pages/sg, and then start
again from scratch.

That also neatly answers what happens if not all importers provide an
invalidate cb, or fail, the dmabuf remains pinned and the exporter must
retreat.

> +        *
> +        * The function is called with the lock of the reservation object
> +        * associated with the dma_buf held and the mapping function must be
> +        * called with this lock held as well. This makes sure that no mapping
> +        * is created concurrently with an ongoing invalidation.
> +        *
> +        * After the callback all existing mappings are still valid until all
> +        * fences in the dma_bufs reservation object are signaled, but should be
> +        * destroyed by the importer as soon as possible.
> +        *
> +        * New mappings can be created immediately, but can't be used before the
> +        * exclusive fence in the dma_bufs reservation object is signaled.
> +        */
> +       void (*invalidate_mappings)(struct dma_buf_attachment *attach);

The intent is that the invalidate is synchronous and immediate, while
locked? We are looking at recursing back into the dma_buf functions to
remove each attachment from the invalidate cb (as well as waiting for
dma), won't that cause some nasty issues?
-Chris
