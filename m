Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34310 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751176AbdGMMsn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 08:48:43 -0400
Subject: Re: [PATCH v2 01/14] v4l: vsp1: Fill display list headers without
 holding dlm spinlock
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com>
 <20170626181226.29575-2-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieranbingham@gmail.com>
Message-ID: <a45e660b-b931-ba16-d861-901c307afb1c@gmail.com>
Date: Thu, 13 Jul 2017 13:48:40 +0100
MIME-Version: 1.0
In-Reply-To: <20170626181226.29575-2-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Starts easy ... (I haven't gone through these in numerical order of course :D)

On 26/06/17 19:12, Laurent Pinchart wrote:
> The display list headers are filled using information from the display
> list only. Lower the display list manager spinlock contention by filling
> the headers without holding the lock.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/vsp1/vsp1_dl.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
> index aaf17b13fd78..dc47e236c780 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.c
> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
> @@ -483,8 +483,6 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
>  	unsigned long flags;
>  	bool update;
>  
> -	spin_lock_irqsave(&dlm->lock, flags);
> -
>  	if (dl->dlm->mode == VSP1_DL_MODE_HEADER) {
>  		struct vsp1_dl_list *dl_child;
>  
> @@ -501,7 +499,11 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
>  
>  			vsp1_dl_list_fill_header(dl_child, last);
>  		}
> +	}
>  
> +	spin_lock_irqsave(&dlm->lock, flags);
> +
> +	if (dl->dlm->mode == VSP1_DL_MODE_HEADER) {
>  		/*
>  		 * Commit the head display list to hardware. Chained headers
>  		 * will auto-start.
> 
