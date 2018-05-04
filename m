Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fireflyinternet.com ([109.228.58.192]:59445 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751269AbeEDIJS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 04:09:18 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        "DRI Development" <dri-devel@lists.freedesktop.org>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20180503142603.28513-5-daniel.vetter@ffwll.ch>
Cc: "Intel Graphics Development" <intel-gfx@lists.freedesktop.org>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>,
        "Sumit Semwal" <sumit.semwal@linaro.org>,
        "Gustavo Padovan" <gustavo@padovan.org>,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
References: <20180503142603.28513-1-daniel.vetter@ffwll.ch>
 <20180503142603.28513-5-daniel.vetter@ffwll.ch>
Message-ID: <152542135089.4767.3315686184618150713@mail.alporthouse.com>
Subject: Re: [PATCH 04/15] dma-fence: Make ->wait callback optional
Date: Fri, 04 May 2018 09:09:10 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quoting Daniel Vetter (2018-05-03 15:25:52)
> Almost everyone uses dma_fence_default_wait.
> 
> v2: Also remove the BUG_ON(!ops->wait) (Chris).

I just don't get the rationale for implicit over explicit.
-Chris
