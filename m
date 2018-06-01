Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:41942 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750729AbeFAHBH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Jun 2018 03:01:07 -0400
Date: Fri, 1 Jun 2018 09:01:05 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dma-buf: make map_atomic and map function pointers
 optional
Message-ID: <20180601070105.xj7wqn7px64krl7v@sirius.home.kraxel.org>
References: <20180529135918.19729-1-kraxel@redhat.com>
 <20180530103051.GK3438@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530103051.GK3438@phenom.ffwll.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 30, 2018 at 12:30:51PM +0200, Daniel Vetter wrote:
> On Tue, May 29, 2018 at 03:59:18PM +0200, Gerd Hoffmann wrote:
> > So drivers don't need dummy functions just returning NULL.
> > 
> > Cc: Daniel Vetter <daniel@ffwll.ch>
> > Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> 
> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> 
> Please push to drm-misc-next (maybe after a few more days of waiting for
> feedback).

Done.

cheers,
  Gerd
