Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33004 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751151AbeBIN1H (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Feb 2018 08:27:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kbingham@kernel.org>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        "Stable v4.14+" <stable@vger.kernel.org>
Subject: Re: [PATCH] v4l: vsp1: Fix continuous mode for dual pipelines
Date: Fri, 09 Feb 2018 15:27:36 +0200
Message-ID: <2830648.6d5UhGC3vQ@avalon>
In-Reply-To: <1518182305-17988-1-git-send-email-kbingham@kernel.org>
References: <1518182305-17988-1-git-send-email-kbingham@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Friday, 9 February 2018 15:18:25 EET Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> To allow dual pipelines utilising two WPF entities when available, the
> VSP was updated to support header-mode display list in continuous
> pipelines.
> 
> A small bug in the status check of the command register causes the
> second pipeline to be directly afflicted by the running of the first;
> appearing as a perceived performance issue with stuttering display.
> 
> Fix the vsp1_dl_list_hw_update_pending() call to ensure that the read
> comparison corresponds to the correct pipeline.
> 
> Fixes: eaf4bfad6ad8 ("v4l: vsp1: Add support for header display
> lists in continuous mode")
> Cc: "Stable v4.14+" <stable@vger.kernel.org>
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Good catch !

The patch looks good to me, but I wonder if we shouldn't write the subject 
line as "v4l: vsp1: Fix header display list status check in continuous mode". 
Sure, we're fixing continuous mode for dual pipelines, but that's more of a 
side effect, it's header display lists that are broken as a whole in 
continuous mode, even if we only use that for dual pipelines right now.

Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Please let me know if you'd like to rewrite the commit message.

> ---
>  drivers/media/platform/vsp1/vsp1_dl.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c
> b/drivers/media/platform/vsp1/vsp1_dl.c index 8cd03ee45f79..34b5ed2592f8
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.c
> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
> @@ -509,7 +509,8 @@ static bool vsp1_dl_list_hw_update_pending(struct
> vsp1_dl_manager *dlm) return !!(vsp1_read(vsp1, VI6_DL_BODY_SIZE)
>  			  & VI6_DL_BODY_SIZE_UPD);
>  	else
> -		return !!(vsp1_read(vsp1, VI6_CMD(dlm->index) & VI6_CMD_UPDHDR));
> +		return !!(vsp1_read(vsp1, VI6_CMD(dlm->index))
> +			  & VI6_CMD_UPDHDR);

/me feels so ashamed.

>  }
> 
>  static bool vsp1_dl_hw_active(struct vsp1_dl_manager *dlm)

-- 
Regards,

Laurent Pinchart
