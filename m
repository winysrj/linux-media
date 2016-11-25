Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40527 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754867AbcKYOhm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Nov 2016 09:37:42 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Shailendra Verma <shailendra.v@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shailendra Verma <shailendra.capricorn@gmail.com>,
        vidushi.koul@samsung.com
Subject: Re: [PATCH] Media: Platform: Omap3isp: Do not forget to call
Date: Fri, 25 Nov 2016 16:27:49 +0200
Message-ID: <2236670.bOO96ZUSu8@avalon>
In-Reply-To: <1480049072-20019-1-git-send-email-shailendra.v@samsung.com>
References: <1480049072-20019-1-git-send-email-shailendra.v@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shailendra,

Thank you for the patch.

On Friday 25 Nov 2016 10:14:32 Shailendra Verma wrote:
> v4l2_fh_init is already done.So call the v4l2_fh_exit in error condition
> before returing from the function.
> 
> Signed-off-by: Shailendra Verma <shailendra.v@samsung.com>
> ---
>  drivers/media/platform/omap3isp/ispvideo.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/platform/omap3isp/ispvideo.c
> b/drivers/media/platform/omap3isp/ispvideo.c index 7354469..2822e2f 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.c
> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> @@ -1350,6 +1350,7 @@ static int isp_video_open(struct file *file)
>  done:
>  	if (ret < 0) {
>  		v4l2_fh_del(&handle->vfh);
> +		v4l2_fh_exit(&handle->vfh);

While at it you should call v4l2_fh_exit() in the isp_video_release() function 
as well. I propose updating the commit message to

    v4l: omap3isp: Clean up file handle in open() and release()
    
    Both functions initialize the file handle with v4l2_fh_init() and thus
    need to call clean up with v4l2_fh_exit() as appropriate. Fix it.

Same comment for the OMAP4 ISS patches you've submitted.

>  		kfree(handle);
>  	}

-- 
Regards,

Laurent Pinchart

