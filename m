Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fireflyinternet.com ([109.228.58.192]:65037 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751075AbeECPvH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 11:51:07 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        "DRI Development" <dri-devel@lists.freedesktop.org>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20180503142603.28513-3-daniel.vetter@ffwll.ch>
Cc: "Intel Graphics Development" <intel-gfx@lists.freedesktop.org>,
        linaro-mm-sig@lists.linaro.org,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>,
        "Daniel Vetter" <daniel.vetter@intel.com>,
        linux-media@vger.kernel.org
References: <20180503142603.28513-1-daniel.vetter@ffwll.ch>
 <20180503142603.28513-3-daniel.vetter@ffwll.ch>
Message-ID: <152536266352.16610.7750025488848662288@mail.alporthouse.com>
Subject: Re: [PATCH 02/15] dma-fence: Make ->enable_signaling optional
Date: Thu, 03 May 2018 16:51:03 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quoting Daniel Vetter (2018-05-03 15:25:50)
> @@ -560,7 +567,7 @@ dma_fence_init(struct dma_fence *fence, const struct dma_fence_ops *ops,
>                spinlock_t *lock, u64 context, unsigned seqno)
>  {
>         BUG_ON(!lock);
> -       BUG_ON(!ops || !ops->wait || !ops->enable_signaling ||
> +       BUG_ON(!ops || !ops->wait ||
>                !ops->get_driver_name || !ops->get_timeline_name);

One thing I was wondering about (following the discussion of rhashtable
on lwn) was inlining this function and passing dma_fence_ops by value.
And seeing if that eliminates the branch and makes smaller code
(probably not, mostly idling wondering about that technique) and kills
off the BUGs (can then be BUILD_BUG_ON).
-Chris
