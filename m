Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49227 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbcKVVwb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 16:52:31 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Shailendra Verma <shailendra.v@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Shailendra Verma <shailendra.capricorn@gmail.com>,
        vidushi.koul@samsung.com
Subject: Re: [PATCH] Staging: media: davinci_vpfe: - Fix for memory leak if
Date: Tue, 22 Nov 2016 23:52:48 +0200
Message-ID: <2953330.nJgbQtyEbq@avalon>
In-Reply-To: <1478854301-25466-1-git-send-email-shailendra.v@samsung.com>
References: <1478854301-25466-1-git-send-email-shailendra.v@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shailendra,

Thank you for the patch.

I think the subject line is incomplete.

On Friday 11 Nov 2016 14:21:41 Shailendra Verma wrote:
> From: "Shailendra Verma" <shailendra.v@samsung.com>
> 
> Fix to avoid possible memory leak if the decoder initialization
> got failed.Free the allocated memory for file handle object
> before return in case decoder initialization fails.
> 
> Signed-off-by: Shailendra Verma <shailendra.capricorn@gmail.com>
> ---
>  drivers/staging/media/davinci_vpfe/vpfe_video.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> b/drivers/staging/media/davinci_vpfe/vpfe_video.c index 8be9f85..80c2e25
> 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> @@ -423,6 +423,7 @@ static int vpfe_open(struct file *file)

(Adding a bit of context here for review purpose)

        v4l2_fh_init(&handle->vfh, &video->video_dev);
        v4l2_fh_add(&handle->vfh);

        mutex_lock(&video->lock)

>  	/* If decoder is not initialized. initialize it */
>  	if (!video->initialized && vpfe_update_pipe_state(video)) {
>  		mutex_unlock(&video->lock);
> +		kfree(handle);

This isn't enough. The v4l2_fh_init() and v4l2_fh_add() calls have side 
effects. The major one is adding vfh to the file handles' list in video_dev. 
If you just free the memory here you will get a crash pretty soon afterwards.

>  		return -ENODEV;
>  	}
>  	/* Increment device users counter */

-- 
Regards,

Laurent Pinchart

