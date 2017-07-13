Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37717 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751176AbdGMMuY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 08:50:24 -0400
Subject: Re: [PATCH v2 03/14] v4l: vsp1: Don't set WPF sink pointer
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com>
 <20170626181226.29575-4-laurent.pinchart+renesas@ideasonboard.com>
Reply-To: kieran.bingham@ideasonboard.com
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <61e7fb65-9f7a-7f36-12dd-02fd709cec52@ideasonboard.com>
Date: Thu, 13 Jul 2017 13:50:20 +0100
MIME-Version: 1.0
In-Reply-To: <20170626181226.29575-4-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26/06/17 19:12, Laurent Pinchart wrote:
> The sink pointer is used to configure routing inside the VSP, and as
> such must point to the next VSP entity in the pipeline. The WPF being a
> pipeline terminal sink, its output route can't be configured. The
> routing configuration code already handles this correctly without
> referring to the sink pointer, which thus doesn't need to be set.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/vsp1/vsp1_drv.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
> index 6b35e043b554..35087d5573ce 100644
> --- a/drivers/media/platform/vsp1/vsp1_drv.c
> +++ b/drivers/media/platform/vsp1/vsp1_drv.c
> @@ -412,7 +412,6 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
>  			}
>  
>  			list_add_tail(&video->list, &vsp1->videos);
> -			wpf->entity.sink = &video->video.entity;
>  		}
>  	}
>  
> 
