Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46186 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab2DQA5F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 20:57:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH v4 01/14] v4l: Add DMABUF as a memory type
Date: Tue, 17 Apr 2012 02:57:17 +0200
Message-ID: <2569036.qHhPBMIXO6@avalon>
In-Reply-To: <1334332076-28489-2-git-send-email-t.stanislaws@samsung.com>
References: <1334332076-28489-1-git-send-email-t.stanislaws@samsung.com> <1334332076-28489-2-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the patch.

On Friday 13 April 2012 17:47:43 Tomasz Stanislawski wrote:
> From: Sumit Semwal <sumit.semwal@ti.com>
> 
> Adds DMABUF memory type to v4l framework. Also adds the related file
> descriptor in v4l2_plane and v4l2_buffer.
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>    [original work in the PoC for buffer sharing]
> Signed-off-by: Sumit Semwal <sumit.semwal@ti.com>
> Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

