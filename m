Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45289 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072Ab2HHOGU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2012 10:06:20 -0400
Received: by wibhm11 with SMTP id hm11so3890131wib.1
        for <linux-media@vger.kernel.org>; Wed, 08 Aug 2012 07:06:18 -0700 (PDT)
Date: Wed, 8 Aug 2012 16:06:38 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	devel@driverdev.osuosl.org, Pawel Osciak <pawel@osciak.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerome Glisse <jglisse@redhat.com>,
	Vinod Koul <vinod.koul@intel.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Rob Landley <rob@landley.net>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Alex Deucher <alexander.deucher@amd.com>,
	Rob Clark <rob@ti.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] dma-buf: add reference counting for exporter module
Message-ID: <20120808140638.GK5490@phenom.ffwll.local>
References: <50223CC5.9060007@samsung.com>
 <1404275.atroogfRqe@avalon>
 <50226F46.3080800@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50226F46.3080800@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 08, 2012 at 03:53:10PM +0200, Tomasz Stanislawski wrote:
> Hi Laurent,
> 
> On 08/08/2012 03:35 PM, Laurent Pinchart wrote:
> > Hi Tomasz,
> > 
> > Thanks for the patch.
> > 
> > On Wednesday 08 August 2012 12:17:41 Tomasz Stanislawski wrote:
> >> This patch adds reference counting on a module that exports dma-buf and
> >> implements its operations. This prevents the module from being unloaded
> >> while DMABUF file is in use.
> >>
> >> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> >> ---
> >>  Documentation/dma-buf-sharing.txt          |    3 ++-
> >>  drivers/base/dma-buf.c                     |   10 +++++++++-
> >>  drivers/gpu/drm/exynos/exynos_drm_dmabuf.c |    1 +
> >>  drivers/gpu/drm/i915/i915_gem_dmabuf.c     |    1 +
> >>  drivers/gpu/drm/nouveau/nouveau_prime.c    |    1 +
> >>  drivers/gpu/drm/radeon/radeon_prime.c      |    1 +
> >>  drivers/staging/omapdrm/omap_gem_dmabuf.c  |    1 +
> >>  include/linux/dma-buf.h                    |    2 ++
> >>  8 files changed, 18 insertions(+), 2 deletions(-)
> >>
> [snip]
> 
> >> @@ -96,6 +98,7 @@ struct dma_buf *dma_buf_export(void *priv, const struct
> >> dma_buf_ops *ops, struct file *file;
> >>
> >>  	if (WARN_ON(!priv || !ops
> >> +			  || !ops->owner
> 
> Thank you for spotting this.
> I didn'y know that try_get_module returned true is module was NULL.
> 
> BTW. Is it worth to add ".owner = THIS_MODULE," to all dma_buf
> exporters in this patch?

Yeah, I think that makes sense. Otherwise it might get lost somewhere,
i.e. you can smash my Ack on this.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
