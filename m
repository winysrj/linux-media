Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:43474 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725746AbeHJIaQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Aug 2018 04:30:16 -0400
Date: Fri, 10 Aug 2018 08:01:54 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, intel-gfx@lists.freedesktop.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH] dma-buf: Remove requirement for ops->map() from
 dma_buf_export
Message-ID: <20180810060154.bbyvujno4m4eoyzh@sirius.home.kraxel.org>
References: <20180807183647.22626-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180807183647.22626-1-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 07, 2018 at 07:36:47PM +0100, Chris Wilson wrote:
> Since commit 9ea0dfbf972 ("dma-buf: make map_atomic and map function
> pointers optional"), the core provides the no-op functions when map and
> map_atomic are not provided, so we no longer need assert that are
> supplied by a dma-buf exporter.

Pushed to drm-misc-next.

thanks,
  Gerd
