Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46164 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab2DQA5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 20:57:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com
Subject: Re: [PATCH v4 06/14] v4l: vb2-dma-contig: Remove unneeded allocation context structure
Date: Tue, 17 Apr 2012 02:57:15 +0200
Message-ID: <1753926.X9Egm1Irbe@avalon>
In-Reply-To: <1334332076-28489-7-git-send-email-t.stanislaws@samsung.com>
References: <1334332076-28489-1-git-send-email-t.stanislaws@samsung.com> <1334332076-28489-7-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the patch.

On Friday 13 April 2012 17:47:48 Tomasz Stanislawski wrote:
> vb2-dma-contig returns a vb2_dc_conf structure instance as the vb2
> allocation context. That structure only stores a pointer to the physical
> device. Remove it and use the device pointer directly as the allocation
> context.
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

