Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:62436 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab2AMGeV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jan 2012 01:34:21 -0500
Received: by qadb10 with SMTP id b10so288821qad.19
        for <linux-media@vger.kernel.org>; Thu, 12 Jan 2012 22:34:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1326188817-12549-1-git-send-email-sachin.kamat@linaro.org>
References: <1326188817-12549-1-git-send-email-sachin.kamat@linaro.org>
Date: Fri, 13 Jan 2012 15:34:19 +0900
Message-ID: <CAH9JG2XmZqnJpNw2Zx4tqeePoKh4LXVrrQFSytXGWHM4BRneUw@mail.gmail.com>
Subject: Re: [PATCH] [media] s5p-fimc: Fix incorrect control ID assignment
From: Kyungmin Park <kyungmin.park@samsung.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	s.nawrocki@samsung.com,
	"patches@linaro.org. \"Marek Szyprowski\"" <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

On 1/10/12, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> This patch fixes the mismatch between control IDs (CID) and controls
> for hflip, vflip and rotate.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/media/video/s5p-fimc/fimc-core.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/video/s5p-fimc/fimc-core.c
> b/drivers/media/video/s5p-fimc/fimc-core.c
> index 07c6254..170f791 100644
> --- a/drivers/media/video/s5p-fimc/fimc-core.c
> +++ b/drivers/media/video/s5p-fimc/fimc-core.c
> @@ -811,11 +811,11 @@ int fimc_ctrls_create(struct fimc_ctx *ctx)
>  	v4l2_ctrl_handler_init(&ctx->ctrl_handler, 3);
>
>  	ctx->ctrl_rotate = v4l2_ctrl_new_std(&ctx->ctrl_handler, &fimc_ctrl_ops,
> -				     V4L2_CID_HFLIP, 0, 1, 1, 0);
> +					V4L2_CID_ROTATE, 0, 270, 90, 0);
>  	ctx->ctrl_hflip = v4l2_ctrl_new_std(&ctx->ctrl_handler, &fimc_ctrl_ops,
> -				    V4L2_CID_VFLIP, 0, 1, 1, 0);
> +					V4L2_CID_HFLIP, 0, 1, 1, 0);
>  	ctx->ctrl_vflip = v4l2_ctrl_new_std(&ctx->ctrl_handler, &fimc_ctrl_ops,
> -				    V4L2_CID_ROTATE, 0, 270, 90, 0);
> +					V4L2_CID_VFLIP, 0, 1, 1, 0);
>  	ctx->ctrls_rdy = ctx->ctrl_handler.error == 0;
>
>  	return ctx->ctrl_handler.error;
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
