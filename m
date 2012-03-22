Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:61599 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab2CVGDW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Mar 2012 02:03:22 -0400
Received: by qcqw6 with SMTP id w6so1111806qcq.19
        for <linux-media@vger.kernel.org>; Wed, 21 Mar 2012 23:03:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1332113668-4364-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1332113668-4364-1-git-send-email-daniel.vetter@ffwll.ch>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Thu, 22 Mar 2012 11:33:01 +0530
Message-ID: <CAO_48GF_x+B0pZeFZ+URU6arX9Fw3=VAvFFrkyHpm6Lp-3n6Tg@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH 1/4] dma-buf: don't hold the mutex around
 map/unmap calls
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: linaro-mm-sig@lists.linaro.org,
	LKML <linux-kernel@vger.kernel.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19 March 2012 05:04, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> The mutex protects the attachment list and hence needs to be held
> around the callbakc to the exporters (optional) attach/detach
> functions.
>
> Holding the mutex around the map/unmap calls doesn't protect any
> dma_buf state. Exporters need to properly protect any of their own
> state anyway (to protect against calls from their own interfaces).
> So this only makes the locking messier (and lockdep easier to anger).
>
> Therefore let's just drop this.
>
> v2: Rebased on top of latest dma-buf-next git.
>
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Reviewed-by: Rob Clark <rob.clark@linaro.org>
Thanks; Applied to for-next.
> ---
<snip>
BR,
~Sumit.
