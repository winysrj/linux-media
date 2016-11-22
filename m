Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49062 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755665AbcKVVfj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 16:35:39 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Manuel Rodriguez <manuel2982@gmail.com>
Cc: mchehab@osg.samsung.com, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: media: davinci_vpfe: Fix spelling error on a comment
Date: Tue, 22 Nov 2016 23:35:23 +0200
Message-ID: <1625650.Ctaqjj1OdI@avalon>
In-Reply-To: <1457421366-4146-1-git-send-email-manuel2982@gmail.com>
References: <1457421366-4146-1-git-send-email-manuel2982@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manuel,

Thank you for the patch and sorry for the late reply.

On Tuesday 08 Mar 2016 01:16:06 Manuel Rodriguez wrote:
> Fix spelling error on a comment, change 'wether' to 'whether'
> 
> Signed-off-by: Manuel Rodriguez <manuel2982@gmail.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree. I will send a pull request for v4.11.

> ---
>  drivers/staging/media/davinci_vpfe/vpfe_video.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> b/drivers/staging/media/davinci_vpfe/vpfe_video.c index 0a65405..e4b953a
> 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> @@ -195,7 +195,7 @@ static int vpfe_update_pipe_state(struct
> vpfe_video_device *video) return 0;
>  }
> 
> -/* checks wether pipeline is ready for enabling */
> +/* checks whether pipeline is ready for enabling */
>  int vpfe_video_is_pipe_ready(struct vpfe_pipeline *pipe)
>  {
>  	int i;

-- 
Regards,

Laurent Pinchart

