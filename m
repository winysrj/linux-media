Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50498 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933501Ab3DIRMZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Apr 2013 13:12:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tom Cooksey <tom.cooksey@arm.com>
Cc: linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: Status of exporting an fbdev framebuffer with dma_buf?
Date: Tue, 09 Apr 2013 19:12:23 +0200
Message-ID: <1446369.MK0i6vhK4t@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tom,

On Tuesday 09 April 2013 12:21:08 Tom Cooksey wrote:
> Hi All,
> 
> Last year Laurent posted an RFC patch[i] to add support for exporting an
> fbdev framebuffer through dma_buf. Looking through the mailing list
> archives, it doesn't appear to have progressed beyond an RFC? What would be
> needed to get this merged? It would be useful for our Mali T6xx driver
> (which supports importing dma_buf buffers) to allow the GPU to draw
> directly into the framebuffer on platforms which lack a DRM/KMS driver.

The patch was pretty simple, I don't think it would take lots of efforts to 
get it to mainline. On the other hand, fbdev is a dying API, so I'm not sure 
how much energy we want to spend on upgrading it. I suppose all that would be 
needed is a developer with enough interest in the topic to fix the patch 
according to the comments.

> [i] Subject: "[RFC/PATCH] fb: Add dma-buf support", sent 20/06/2012.

-- 
Regards,

Laurent Pinchart

