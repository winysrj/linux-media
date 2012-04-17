Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47049 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab2DQBD0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 21:03:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com
Subject: Re: [PATCH v4 12/14] v4l: vb2-dma-contig: change map/unmap behaviour for importers
Date: Tue, 17 Apr 2012 03:03:37 +0200
Message-ID: <1587515.L9hht06z7c@avalon>
In-Reply-To: <1334332076-28489-13-git-send-email-t.stanislaws@samsung.com>
References: <1334332076-28489-1-git-send-email-t.stanislaws@samsung.com> <1334332076-28489-13-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the patch.

On Friday 13 April 2012 17:47:54 Tomasz Stanislawski wrote:
> The DMABUF documentation says that the map_dma_buf callback should return
> scatterlist that is mapped into a caller's address space. In practice,
> almost none of existing implementations of DMABUF exporter does it.  This
> patch breaks the DMABUF specification in order to allow exchange DMABUF
> buffers between other APIs like DRM.

Once again, this means that it's time to either fix the documentation or fix 
the non-compliant drivers.

Could you please read the mail I've sent on 27/03/2012 in the "Minutes from 
V4L2 update call" thread and reply there to avoid scattering the discussion ?

-- 
Regards,

Laurent Pinchart

