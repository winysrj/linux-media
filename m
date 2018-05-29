Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:59818 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933716AbeE2Mb7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 08:31:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] media: vsp1: Document vsp1_dl_body refcnt
Date: Tue, 29 May 2018 15:32:01 +0300
Message-ID: <2592409.Y0HWR0tUhb@avalon>
In-Reply-To: <20180528102420.19150-1-kieran.bingham@ideasonboard.com>
References: <20180528102420.19150-1-kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Monday, 28 May 2018 13:24:20 EEST Kieran Bingham wrote:
> In commit 2d9445db0ee9 ("media: vsp1: Use reference counting for
> bodies"), a new field was introduced to the vsp1_dl_body structure to
> account for usage tracking of the body.
> 
> Document the newly added field in the kerneldoc.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and taken in my tree for v4.19.

> ---
>  drivers/media/platform/vsp1/vsp1_dl.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c
> b/drivers/media/platform/vsp1/vsp1_dl.c index d9b9cdd8fbe2..10a24bde2299
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.c
> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
> @@ -43,6 +43,7 @@ struct vsp1_dl_entry {
>   * struct vsp1_dl_body - Display list body
>   * @list: entry in the display list list of bodies
>   * @free: entry in the pool free body list
> + * @refcnt: reference tracking for the body
>   * @pool: pool to which this body belongs
>   * @vsp1: the VSP1 device
>   * @entries: array of entries


-- 
Regards,

Laurent Pinchart
