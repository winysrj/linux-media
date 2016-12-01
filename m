Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40702 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755561AbcLAK2Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2016 05:28:25 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Shailendra Verma <shailendra.v@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shailendra Verma <shailendra.capricorn@gmail.com>,
        vidushi.koul@samsung.com
Subject: Re: [PATCH] V4l: omap3isp: Clean up file handle in open() and release().
Date: Thu, 01 Dec 2016 12:28:39 +0200
Message-ID: <1835003.usQhLsQOpN@avalon>
In-Reply-To: <1480567540-13119-1-git-send-email-shailendra.v@samsung.com>
References: <1480567540-13119-1-git-send-email-shailendra.v@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shailendra,

Thank you for the patch.

On Thursday 01 Dec 2016 10:15:40 Shailendra Verma wrote:
> Both functions initialize the file handle with v4l2_fh_init()
> and thus need to call clean up with v4l2_fh_exit() as appropriate.
> 
> Signed-off-by: Shailendra Verma <shailendra.v@samsung.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree for v4.11.

> ---
>  drivers/media/platform/omap3isp/ispvideo.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/platform/omap3isp/ispvideo.c
> b/drivers/media/platform/omap3isp/ispvideo.c index 7354469..9f966e8 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.c
> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> @@ -1350,6 +1350,7 @@ static int isp_video_open(struct file *file)
>  done:
>  	if (ret < 0) {
>  		v4l2_fh_del(&handle->vfh);
> +		v4l2_fh_exit(&handle->vfh);
>  		kfree(handle);
>  	}
> 
> @@ -1373,6 +1374,7 @@ static int isp_video_release(struct file *file)
> 
>  	/* Release the file handle. */
>  	v4l2_fh_del(vfh);
> +	v4l2_fh_exit(vfh);
>  	kfree(handle);
>  	file->private_data = NULL;

-- 
Regards,

Laurent Pinchart

