Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42643 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751735AbdGaN5O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Jul 2017 09:57:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Subject: Re: [PATCH 1/6 v5]  UVC: fix .queue_setup() to check the number of planes
Date: Mon, 31 Jul 2017 16:57:23 +0300
Message-ID: <1773002.W70q46i2MF@avalon>
In-Reply-To: <1501245205-15802-2-git-send-email-g.liakhovetski@gmx.de>
References: <1501245205-15802-1-git-send-email-g.liakhovetski@gmx.de> <1501245205-15802-2-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thank you for the patch.

On Friday 28 Jul 2017 14:33:20 Guennadi Liakhovetski wrote:
> According to documentation of struct vb2_ops the .queue_setup() callback
> should return an error if the number of planes parameter contains an
> invalid value on input. Fix this instead of ignoring the value.
> 
> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> ---
>  drivers/media/usb/uvc/uvc_queue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_queue.c
> b/drivers/media/usb/uvc/uvc_queue.c index aa21997..371a4ad 100644
> --- a/drivers/media/usb/uvc/uvc_queue.c
> +++ b/drivers/media/usb/uvc/uvc_queue.c
> @@ -84,7 +84,7 @@ static int uvc_queue_setup(struct vb2_queue *vq,
> 
>  	/* Make sure the image size is large enough. */

Nitpicking, I'd update the comment as well.

        /*
	 * When called with plane sizes, validate them. The driver supports
	 * single planar formats only, and requires buffers to be large enough
	 * to store a complete frame.
	 */

>  	if (*nplanes)
> -		return sizes[0] < size ? -EINVAL : 0;
> +		return sizes[0] < size || *nplanes != 1 ? -EINVAL : 0;

Nitpicking again, I'd test *nplanes first, as it conditions which entries of 
the sizes array are valid. If course the if (*nplanes) test ensures that entry 
0 is valid, so it won't make a difference at runtime, it's just about code 
readability.

The patch looks good otherwise,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  	*nplanes = 1;
>  	sizes[0] = size;
>  	return 0;

-- 
Regards,

Laurent Pinchart
