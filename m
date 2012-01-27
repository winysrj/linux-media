Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:52103 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094Ab2A0Ptt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jan 2012 10:49:49 -0500
Received: by werb13 with SMTP id b13so1338319wer.19
        for <linux-media@vger.kernel.org>; Fri, 27 Jan 2012 07:49:48 -0800 (PST)
Date: Fri, 27 Jan 2012 16:49:49 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Sumit Semwal <sumit.semwal@ti.com>
Cc: dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org, t.stanislaws@samsung.com
Subject: Re: [PATCH] dma-buf: add dma_data_direction to unmap dma_buf_op
Message-ID: <20120127154949.GC3901@phenom.ffwll.local>
References: <1327657408-15234-1-git-send-email-sumit.semwal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327657408-15234-1-git-send-email-sumit.semwal@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 27, 2012 at 03:13:28PM +0530, Sumit Semwal wrote:
> Some exporters may use DMA map/unmap APIs in dma-buf ops, which require
> enum dma_data_direction for both map and unmap operations.
> 
> Thus, the unmap dma_buf_op also needs to have enum dma_data_direction as
> a parameter.
> 
> Reported-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Sumit Semwal <sumit.semwal@ti.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
