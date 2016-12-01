Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40708 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754174AbcLAK3I (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2016 05:29:08 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Shailendra Verma <shailendra.v@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Shailendra Verma <shailendra.capricorn@gmail.com>,
        vidushi.koul@samsung.com
Subject: Re: [PATCH] V4l: omap4iss: Clean up file handle in open() and release().
Date: Thu, 01 Dec 2016 12:29:23 +0200
Message-ID: <2371533.nuiRhppDdV@avalon>
In-Reply-To: <1480567972-13510-1-git-send-email-shailendra.v@samsung.com>
References: <1480567972-13510-1-git-send-email-shailendra.v@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shailendra,

Thank you for the patch.

On Thursday 01 Dec 2016 10:22:52 Shailendra Verma wrote:
> Both functions initialize the file handle with v4l2_fh_init()
> and thus need to call clean up with v4l2_fh_exit() as appropriate.
> 
> Signed-off-by: Shailendra Verma <shailendra.v@samsung.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree for v4.11.

> ---
>  drivers/staging/media/omap4iss/iss_video.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/staging/media/omap4iss/iss_video.c
> b/drivers/staging/media/omap4iss/iss_video.c index c16927a..077c9f8 100644
> --- a/drivers/staging/media/omap4iss/iss_video.c
> +++ b/drivers/staging/media/omap4iss/iss_video.c
> @@ -1141,6 +1141,7 @@ static int iss_video_open(struct file *file)
>  done:
>  	if (ret < 0) {
>  		v4l2_fh_del(&handle->vfh);
> +		v4l2_fh_exit(&handle->vfh);
>  		kfree(handle);
>  	}
> 
> @@ -1162,6 +1163,7 @@ static int iss_video_release(struct file *file)
>  	vb2_queue_release(&handle->queue);
> 
>  	v4l2_fh_del(vfh);
> +	v4l2_fh_exit(vfh);
>  	kfree(handle);
>  	file->private_data = NULL;

-- 
Regards,

Laurent Pinchart

