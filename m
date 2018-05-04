Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:55014 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750946AbeEDIR1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 04:17:27 -0400
Received: by mail-wm0-f65.google.com with SMTP id f6so2678023wmc.4
        for <linux-media@vger.kernel.org>; Fri, 04 May 2018 01:17:26 -0700 (PDT)
Date: Fri, 4 May 2018 10:17:22 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH 04/15] dma-fence: Make ->wait callback optional
Message-ID: <20180504081722.GQ12521@phenom.ffwll.local>
References: <20180503142603.28513-1-daniel.vetter@ffwll.ch>
 <20180503142603.28513-5-daniel.vetter@ffwll.ch>
 <152542135089.4767.3315686184618150713@mail.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152542135089.4767.3315686184618150713@mail.alporthouse.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 04, 2018 at 09:09:10AM +0100, Chris Wilson wrote:
> Quoting Daniel Vetter (2018-05-03 15:25:52)
> > Almost everyone uses dma_fence_default_wait.
> > 
> > v2: Also remove the BUG_ON(!ops->wait) (Chris).
> 
> I just don't get the rationale for implicit over explicit.

Closer approximation of dwim semantics. There's been tons of patch series
all over drm and related places to get there, once we have a big pile of
implementations and know what the dwim semantics should be. Individually
they're all not much, in aggregate they substantially simplify simple
drivers.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
