Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48021 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab1KXL0b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 06:26:31 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] media: vb2: fix queueing of userptr buffers with null buffer pointer
Date: Thu, 24 Nov 2011 12:26:31 +0100
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
References: <1321471348-11567-1-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1321471348-11567-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111241226.31762.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marek,

On Wednesday 16 November 2011 20:22:28 Marek Szyprowski wrote:
> Heuristic that checks if the memory pointer has been changed lacked a check
> if the pointer was actually provided by the userspace, what allowed one to
> queue a NULL pointer which was accepted without further checking.

Is that an issue ? If the pointer is NULL get_user_pages() will fail, won't it 
?

> This patch fixes this issue.
>
> Reported-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> CC: Pawel Osciak <pawel@osciak.com>
> ---
>  drivers/media/video/videobuf2-core.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-core.c
> b/drivers/media/video/videobuf2-core.c index ec49fed..24f11ae 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -765,7 +765,8 @@ static int __qbuf_userptr(struct vb2_buffer *vb, struct
> v4l2_buffer *b)
> 
>  	for (plane = 0; plane < vb->num_planes; ++plane) {
>  		/* Skip the plane if already verified */
> -		if (vb->v4l2_planes[plane].m.userptr == planes[plane].m.userptr
> +		if (vb->v4l2_planes[plane].m.userptr &&
> +		    vb->v4l2_planes[plane].m.userptr == planes[plane].m.userptr
>  		    && vb->v4l2_planes[plane].length == planes[plane].length)
>  			continue;

-- 
Regards,

Laurent Pinchart
