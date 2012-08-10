Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:61784 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab2HJTbv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 15:31:51 -0400
Received: by wgbfm10 with SMTP id fm10so1421194wgb.1
        for <linux-media@vger.kernel.org>; Fri, 10 Aug 2012 12:31:49 -0700 (PDT)
Date: Fri, 10 Aug 2012 21:32:10 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: sumit.semwal@linaro.org, rob.clark@linaro.org,
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH 1/4] dma-buf: remove fallback for
 !CONFIG_DMA_SHARED_BUFFER
Message-ID: <20120810193210.GG5738@phenom.ffwll.local>
References: <20120810145728.5490.44707.stgit@patser.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120810145728.5490.44707.stgit@patser.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 10, 2012 at 04:57:43PM +0200, Maarten Lankhorst wrote:
> Documentation says that code requiring dma-buf should add it to
> select, so inline fallbacks are not going to be used. A link error
> will make it obvious what went wrong, instead of silently doing
> nothing at runtime.
> 
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

I've botched it more than once to update these when creating new dma-buf
code. Hence

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
