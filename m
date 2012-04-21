Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58802 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab2DUT6I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Apr 2012 15:58:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	linux-doc@vger.kernel.org, g.liakhovetski@gmx.de,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCHv5 08/13] v4l: vb2-dma-contig: add support for scatterlist in userptr mode
Date: Sat, 21 Apr 2012 19:24:53 +0200
Message-ID: <1441118.citg6Ndf7i@avalon>
In-Reply-To: <1334933134-4688-9-git-send-email-t.stanislaws@samsung.com>
References: <1334933134-4688-1-git-send-email-t.stanislaws@samsung.com> <1334933134-4688-9-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the patch.

On Friday 20 April 2012 16:45:29 Tomasz Stanislawski wrote:
> From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> 
> This patch introduces usage of dma_map_sg to map memory behind
> a userspace pointer to a device as dma-contiguous mapping.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> 	[bugfixing]
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> 	[bugfixing]
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> 	[add sglist subroutines/code refactoring]
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

