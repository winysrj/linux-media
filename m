Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57502 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751434AbeC1M1P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 08:27:15 -0400
Subject: Re: [PATCH 02/15] v4l: vsp1: Remove outdated comment
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
References: <20180226214516.11559-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180226214516.11559-3-laurent.pinchart+renesas@ideasonboard.com>
Reply-To: kieran.bingham@ideasonboard.com
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <0a055333-78b0-a64b-ef97-c1706b7b56b9@ideasonboard.com>
Date: Wed, 28 Mar 2018 13:27:10 +0100
MIME-Version: 1.0
In-Reply-To: <20180226214516.11559-3-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thank you for the patch.

On 26/02/18 21:45, Laurent Pinchart wrote:
> The entities in the pipeline are all started when the LIF is setup.
> Remove the outdated comment that state otherwise.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

I'll start with the easy ones :-)

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/vsp1/vsp1_drm.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> index e31fb371eaf9..a1f2ba044092 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -221,11 +221,7 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
>  		return -EPIPE;
>  	}
>  
> -	/*
> -	 * Enable the VSP1. We don't start the entities themselves right at this
> -	 * point as there's no plane configured yet, so we can't start
> -	 * processing buffers.
> -	 */
> +	/* Enable the VSP1. */
>  	ret = vsp1_device_get(vsp1);
>  	if (ret < 0)
>  		return ret;
> 
