Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54073 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab1HIHmE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Aug 2011 03:42:04 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: [PATCH v2] [media] omap3isp: queue: fail QBUF if user buffer is too small
Date: Tue, 9 Aug 2011 09:42:03 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <1312472437-26231-1-git-send-email-michael.jones@matrix-vision.de> <1312872140-7517-1-git-send-email-michael.jones@matrix-vision.de>
In-Reply-To: <1312872140-7517-1-git-send-email-michael.jones@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108090942.03596.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

On Tuesday 09 August 2011 08:42:20 Michael Jones wrote:
> Add buffer length check to sanity checks for USERPTR QBUF
> 
> Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I'll push the patch to v3.2.

> ---
> Changes for v2:
>  - only check when V4L2_MEMORY_USERPTR
> 
>  drivers/media/video/omap3isp/ispqueue.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/ispqueue.c
> b/drivers/media/video/omap3isp/ispqueue.c index 9c31714..9bebb1e 100644
> --- a/drivers/media/video/omap3isp/ispqueue.c
> +++ b/drivers/media/video/omap3isp/ispqueue.c
> @@ -868,6 +868,10 @@ int omap3isp_video_queue_qbuf(struct isp_video_queue
> *queue, goto done;
> 
>  	if (vbuf->memory == V4L2_MEMORY_USERPTR &&
> +	    vbuf->length < buf->vbuf.length)
> +		goto done;
> +
> +	if (vbuf->memory == V4L2_MEMORY_USERPTR &&
>  	    vbuf->m.userptr != buf->vbuf.m.userptr) {
>  		isp_video_buffer_cleanup(buf);
>  		buf->vbuf.m.userptr = vbuf->m.userptr;

-- 
Regards,

Laurent Pinchart
