Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40718 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751301AbcLAK3w (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2016 05:29:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Shailendra Verma <shailendra.v@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Shailendra Verma <shailendra.capricorn@gmail.com>,
        vidushi.koul@samsung.com
Subject: Re: [PATCH] Platform: vsp1: Clean up file handle in open() error path.
Date: Thu, 01 Dec 2016 12:30:07 +0200
Message-ID: <2714292.XDaUmZ9RCx@avalon>
In-Reply-To: <1480567818-13363-1-git-send-email-shailendra.v@samsung.com>
References: <1480567818-13363-1-git-send-email-shailendra.v@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shailendra,

Thank you for the patch.

On Thursday 01 Dec 2016 10:20:18 Shailendra Verma wrote:
> v4l2_fh_init is already done.So call the v4l2_fh_exit in error condition
> before returing from the function.
> 
> Signed-off-by: Shailendra Verma <shailendra.v@samsung.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree for v4.11.

> ---
>  drivers/media/platform/vsp1/vsp1_video.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c
> b/drivers/media/platform/vsp1/vsp1_video.c index d351b9c..cc58163 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -1044,6 +1044,7 @@ static int vsp1_video_open(struct file *file)
>  	ret = vsp1_device_get(video->vsp1);
>  	if (ret < 0) {
>  		v4l2_fh_del(vfh);
> +		v4l2_fh_exit(vfh);
>  		kfree(vfh);
>  	}

-- 
Regards,

Laurent Pinchart

