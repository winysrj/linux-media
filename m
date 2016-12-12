Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58725 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752986AbcLLJhi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 04:37:38 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Santosh Kumar Singh <kumar.san1093@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        PJunghak Sung <jh1009.sung@samsung.com>,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vim2m: Clean up file handle in open() error path.
Date: Mon, 12 Dec 2016 11:38:08 +0200
Message-ID: <4539600.dorPRmcVo7@avalon>
In-Reply-To: <1481131419-2921-1-git-send-email-kumar.san1093@gmail.com>
References: <1481131419-2921-1-git-send-email-kumar.san1093@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Santosh,

Thank you for the patch.

On Wednesday 07 Dec 2016 22:53:39 Santosh Kumar Singh wrote:
> Fix to avoid possible memory leak and exit file handle
> in error paths.
> 
> Signed-off-by: Santosh Kumar Singh <kumar.san1093@gmail.com>
> ---
>  drivers/media/platform/vim2m.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
> index a98f679..9fd24b8 100644
> --- a/drivers/media/platform/vim2m.c
> +++ b/drivers/media/platform/vim2m.c
> @@ -907,6 +907,7 @@ static int vim2m_open(struct file *file)
>  	if (hdl->error) {
>  		rc = hdl->error;
>  		v4l2_ctrl_handler_free(hdl);
> +		kfree(ctx);
>  		goto open_unlock;
>  	}
>  	ctx->fh.ctrl_handler = hdl;
> @@ -929,6 +930,7 @@ static int vim2m_open(struct file *file)
> 
>  		v4l2_ctrl_handler_free(hdl);
>  		kfree(ctx);
> +		v4l2_fh_exit(&ctx->fh);

Don't you notice something wrong in those last two lines ?

>  		goto open_unlock;
>  	}

-- 
Regards,

Laurent Pinchart

