Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33212 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751786AbcIIH32 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2016 03:29:28 -0400
Received: by mail-wm0-f66.google.com with SMTP id b187so1432289wme.0
        for <linux-media@vger.kernel.org>; Fri, 09 Sep 2016 00:29:27 -0700 (PDT)
Subject: Re: [PATCH v3 07/10] v4l: fdp1: Remove unused struct fdp1_v4l2_buffer
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org
References: <1473287110-780-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1473287110-780-8-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org
From: Kieran Bingham <kieran@ksquared.org.uk>
Message-ID: <7643da9a-31cc-364e-36bc-59e903d4438b@bingham.xyz>
Date: Fri, 9 Sep 2016 08:29:25 +0100
MIME-Version: 1.0
In-Reply-To: <1473287110-780-8-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/09/16 23:25, Laurent Pinchart wrote:
> The structure is not used, remove it.

Ahh yes, looks like a left over from my first attempt at serialising
input fields.

Reviewed-by: Kieran Bingham <kieran@bingham.xyz>

> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/rcar_fdp1.c | 13 -------------
>  1 file changed, 13 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
> index bbeacf1527b5..fdab41165f5a 100644
> --- a/drivers/media/platform/rcar_fdp1.c
> +++ b/drivers/media/platform/rcar_fdp1.c
> @@ -514,19 +514,6 @@ enum fdp1_deint_mode {
>  	 mode == FDP1_PREVFIELD)
>  
>  /*
> - * fdp1_v4l2_buffer: Track v4l2_buffers with a reference count
> - *
> - * As buffers come in, they may be used for more than one field.
> - * It then becomes necessary to track the usage of these buffers,
> - * and only release when the last job has completed using this
> - * vb buffer.
> - */
> -struct fdp1_v4l2_buffer {
> -	struct vb2_v4l2_buffer	vb;
> -	struct list_head	list;
> -};
> -
> -/*
>   * FDP1 operates on potentially 3 fields, which are tracked
>   * from the VB buffers using this context structure.
>   * Will always be a field or a full frame, never two fields.
> 

-- 
Regards

Kieran Bingham
