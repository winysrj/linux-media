Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:58723 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab1HKVVt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2011 17:21:49 -0400
Date: Fri, 12 Aug 2011 00:21:45 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Michael Jones <michael.jones@matrix-vision.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: omap3isp buffer alignment
Message-ID: <20110811212145.GK5926@valkosipuli.localdomain>
References: <4E43A770.7080308@matrix-vision.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E43A770.7080308@matrix-vision.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 11, 2011 at 11:57:04AM +0200, Michael Jones wrote:
> Hi Laurent,
> 
> If I understood your discussion with Russell [1] correctly, user pointer
> buffers are required to be page-aligned because of the IOMMU API, and
> it's desirable to keep the IOMMU driver that way for other subsystems
> which may use it. So we're stuck with user buffers needing to be
> page-aligned.

My understanding is that this is actually a hardware requirement. You only
can map pages of 4 kiB (at least).

> There's a check in ispvideo.c:isp_video_buffer_prepare() that the buffer
> address is 32-byte aligned. Isn't this superfluous considering the
> page-aligned restriction?

I guess the ISP driver isn't assuming that ispmmu_vmap always give page
aligned mappings --- or that the page size couls theoretically be smaller.
The assumptions might not hold in another implementation of the IOMMU API,
which however will be replaced (hopefully at some point) by the improved DMA
mapping API.

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
