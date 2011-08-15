Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49914 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab1HOM4T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2011 08:56:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] media: vb2: add a check if queued userptr buffer is large enough
Date: Mon, 15 Aug 2011 14:56:28 +0200
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
References: <1312964488-2924-1-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1312964488-2924-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108151456.29339.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HI Marek,

Thanks for the patch.

On Wednesday 10 August 2011 10:21:28 Marek Szyprowski wrote:
> Videobuf2 accepted any userptr buffer without verifying if its size is
> large enough to store the video data from the driver. The driver reports
> the minimal size of video data once in queue_setup and expects that
> videobuf2 provides buffers that match these requirements. This patch
> adds the required check.
> 
> Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> CC: Pawel Osciak <pawel@osciak.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Just one small comment below though.

> ---
>  drivers/media/video/videobuf2-core.c |   41
> +++++++++++++++++++-------------- include/media/videobuf2-core.h       |  
>  1 +
>  2 files changed, 25 insertions(+), 17 deletions(-)

[snip]

> diff --git a/include/media/videobuf2-core.h
> b/include/media/videobuf2-core.h index f87472a..496d6e5 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -276,6 +276,7 @@ struct vb2_queue {
>  	wait_queue_head_t		done_wq;
> 
>  	void				*alloc_ctx[VIDEO_MAX_PLANES];
> +	unsigned long			plane_sizes[VIDEO_MAX_PLANES];

What about unsigned int ? That 4GB should be more than enough :-)

>  	unsigned int			streaming:1;

-- 
Regards,

Laurent Pinchart
