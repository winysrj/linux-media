Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcdn-iport-8.cisco.com ([173.37.86.79]:35110 "EHLO
	rcdn-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab1HJIpx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2011 04:45:53 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] media: vb2: add a check if queued userptr buffer is large enough
Date: Wed, 10 Aug 2011 10:45:36 +0200
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1312964488-2924-1-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1312964488-2924-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108101045.36681.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just one comment:

On Wednesday, August 10, 2011 10:21:28 Marek Szyprowski wrote:
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
> ---
>  drivers/media/video/videobuf2-core.c |   41 
+++++++++++++++++++--------------
>  include/media/videobuf2-core.h       |    1 +
>  2 files changed, 25 insertions(+), 17 deletions(-)
> 

<snip>

> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index f87472a..496d6e5 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -276,6 +276,7 @@ struct vb2_queue {
>  	wait_queue_head_t		done_wq;
>  
>  	void				*alloc_ctx[VIDEO_MAX_PLANES];
> +	unsigned long			plane_sizes[VIDEO_MAX_PLANES];

Why unsigned long when it is a u32 in struct v4l2_plane_pix_format?

unsigned long is 64 bit on a 64-bit OS, so that seems wasteful to me.

Regards,

	Hans

>  
>  	unsigned int			streaming:1;
>  
> -- 
> 1.7.1.569.g6f426
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
