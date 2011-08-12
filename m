Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41998 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab1HLJ2o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2011 05:28:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: omap3isp buffer alignment
Date: Fri, 12 Aug 2011 11:28:21 +0200
Cc: Michael Jones <michael.jones@matrix-vision.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4E43A770.7080308@matrix-vision.de> <20110811212145.GK5926@valkosipuli.localdomain>
In-Reply-To: <20110811212145.GK5926@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108121128.22850.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 11 August 2011 23:21:45 Sakari Ailus wrote:
> On Thu, Aug 11, 2011 at 11:57:04AM +0200, Michael Jones wrote:
> > Hi Laurent,
> > 
> > If I understood your discussion with Russell [1] correctly, user pointer
> > buffers are required to be page-aligned because of the IOMMU API, and
> > it's desirable to keep the IOMMU driver that way for other subsystems
> > which may use it. So we're stuck with user buffers needing to be
> > page-aligned.
> 
> My understanding is that this is actually a hardware requirement. You only
> can map pages of 4 kiB (at least).

The IOMMU works on a 4kiB page granularity, but that doesn't require buffers 
to be page-aligned. If the buffer start address isn't aligned on a page 
boundary the IOMMU can map the whole page, and the driver can then just add an 
offset to the virtual address.

> > There's a check in ispvideo.c:isp_video_buffer_prepare() that the buffer
> > address is 32-byte aligned. Isn't this superfluous considering the
> > page-aligned restriction?
> 
> I guess the ISP driver isn't assuming that ispmmu_vmap always give page
> aligned mappings --- or that the page size couls theoretically be smaller.
> The assumptions might not hold in another implementation of the IOMMU API,
> which however will be replaced (hopefully at some point) by the improved
> DMA mapping API.

-- 
Regards,

Laurent Pinchart
