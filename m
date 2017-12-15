Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43988 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753218AbdLOKL3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 05:11:29 -0500
Subject: Re: [PATCH 1/9] v4l: vsp1: Fix display stalls when requesting too
 many inputs
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org
References: <20171203105735.10529-1-laurent.pinchart+renesas@ideasonboard.com>
 <20171203105735.10529-2-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reply-To: kieran.bingham@ideasonboard.com
Message-ID: <d8d9d2d7-eee7-3951-3e75-2c3e7b175f63@ideasonboard.com>
Date: Fri, 15 Dec 2017 10:11:25 +0000
MIME-Version: 1.0
In-Reply-To: <20171203105735.10529-2-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

As this is a prevents hardware hangs, and is a distinct patch on it's own - I
feel it should be on an accelerated path to integration, and should be merged
separately from the rest of the CRC feature series.

On 03/12/17 10:57, Laurent Pinchart wrote:
> Make sure we don't accept more inputs than the hardware can handle. This
> is a temporary fix to avoid display stall, we need to instead allocate
> the BRU or BRS to display pipelines dynamically based on the number of
> planes they each use.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/vsp1/vsp1_drm.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> index 7ce69f23f50a..ac85942162c1 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -530,6 +530,15 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index)
>  		struct vsp1_rwpf *rpf = vsp1->rpf[i];
>  		unsigned int j;
>  
> +		/*
> +		 * Make sure we don't accept more inputs than the hardware can
> +		 * handle. This is a temporary fix to avoid display stall, we
> +		 * need to instead allocate the BRU or BRS to display pipelines
> +		 * dynamically based on the number of planes they each use.
> +		 */
> +		if (pipe->num_inputs >= pipe->bru->source_pad)
> +			pipe->inputs[i] = NULL;
> +
>  		if (!pipe->inputs[i])
>  			continue;
>  
> 
