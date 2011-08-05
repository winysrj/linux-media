Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36259 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab1HEI7m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Aug 2011 04:59:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: [PATCH] [media] omap3isp: queue: fail QBUF if buffer is too small
Date: Fri, 5 Aug 2011 10:59:46 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <1312472437-26231-1-git-send-email-michael.jones@matrix-vision.de>
In-Reply-To: <1312472437-26231-1-git-send-email-michael.jones@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108051059.46485.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

Thanks for the patch.

On Thursday 04 August 2011 17:40:37 Michael Jones wrote:
> Add buffer length to sanity checks for QBUF.
> 
> Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
> ---
>  drivers/media/video/omap3isp/ispqueue.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/ispqueue.c
> b/drivers/media/video/omap3isp/ispqueue.c index 9c31714..4f6876f 100644
> --- a/drivers/media/video/omap3isp/ispqueue.c
> +++ b/drivers/media/video/omap3isp/ispqueue.c
> @@ -867,6 +867,9 @@ int omap3isp_video_queue_qbuf(struct isp_video_queue
> *queue, if (buf->state != ISP_BUF_STATE_IDLE)
>  		goto done;
> 
> +	if (vbuf->length < buf->vbuf.length)
> +		goto done;
> +

The vbuf->length value passed from userspace isn't used by the driver, so I'm 
not sure if verifying it is really useful. We verify the memory itself 
instead, to make sure that enough pages can be accessed. The application can 
always lie about the length, so we can't relying on it anyway.

>  	if (vbuf->memory == V4L2_MEMORY_USERPTR &&
>  	    vbuf->m.userptr != buf->vbuf.m.userptr) {
>  		isp_video_buffer_cleanup(buf);

-- 
Regards,

Laurent Pinchart
