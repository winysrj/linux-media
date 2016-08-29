Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:35303 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751314AbcH2S0S (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Aug 2016 14:26:18 -0400
Received: by mail-qk0-f194.google.com with SMTP id o1so10862270qkd.2
        for <linux-media@vger.kernel.org>; Mon, 29 Aug 2016 11:26:18 -0700 (PDT)
Date: Mon, 29 Aug 2016 14:26:16 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: dri-devel@lists.freedesktop.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH] dma-buf/sync-file: Avoid enable fence signaling if
 poll(.timeout=0)
Message-ID: <20160829182616.GG23577@joana>
References: <20160829070834.22296-11-chris@chris-wilson.co.uk>
 <20160829181613.30722-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160829181613.30722-1-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chris,

2016-08-29 Chris Wilson <chris@chris-wilson.co.uk>:

> If we being polled with a timeout of zero, a nonblocking busy query,
> we don't need to install any fence callbacks as we will not be waiting.
> As we only install the callback once, the overhead comes from the atomic
> bit test that also causes serialisation between threads.
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: Gustavo Padovan <gustavo@padovan.org>
> Cc: linux-media@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: linaro-mm-sig@lists.linaro.org
> ---
>  drivers/dma-buf/sync_file.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Indeed, we can shortcut this.

Reviewed-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>

Gustavo
