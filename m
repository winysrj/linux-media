Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52688 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbdBTKsl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 05:48:41 -0500
Subject: Re: [PATCH] v4l: vsp1: Fix WPF U/V order in 3-planar formats on Gen3
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org
References: <20170212231753.30397-1-laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <fa11d1ad-be4c-9e55-0681-cd377f7fb99c@ideasonboard.com>
Date: Mon, 20 Feb 2017 10:48:32 +0000
MIME-Version: 1.0
In-Reply-To: <20170212231753.30397-1-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 12/02/17 23:17, Laurent Pinchart wrote:
> The WPF U/V order bit has no effect for 3-planar formats on Gen3
> hardware. Swap the U and V planes manually instead in that case.

Nice effective solution.

> Fixes: b915bd24a034 ("[media] v4l: vsp1: Add tri-planar memory formats support")
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>

> ---
>  drivers/media/platform/vsp1/vsp1_wpf.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> This makes the vsp-unit-test-0002.sh test pass on both H2 and H3.
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
> index 7c48f81cd5c1..052a83e2d489 100644
> --- a/drivers/media/platform/vsp1/vsp1_wpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_wpf.c
> @@ -216,6 +216,7 @@ static void wpf_configure(struct vsp1_entity *entity,
>  
>  	if (params == VSP1_ENTITY_PARAMS_PARTITION) {
>  		const struct v4l2_pix_format_mplane *format = &wpf->format;
> +		const struct vsp1_format_info *fmtinfo = wpf->fmtinfo;
>  		struct vsp1_rwpf_memory mem = wpf->mem;
>  		unsigned int flip = wpf->flip.active;
>  		unsigned int width = source_format->width;
> @@ -281,6 +282,14 @@ static void wpf_configure(struct vsp1_entity *entity,
>  			}
>  		}
>  
> +		/*
> +		 * On Gen3 hardware the SPUVS bit has no effect on 3-planar
> +		 * formats. Swap the U and V planes manually in that case.
> +		 */
> +		if (vsp1->info->gen == 3 && format->num_planes == 3 &&
> +		    fmtinfo->swap_uv)
> +			swap(mem.addr[1], mem.addr[2]);
> +
>  		vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_Y, mem.addr[0]);
>  		vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_C0, mem.addr[1]);
>  		vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_C1, mem.addr[2]);
> 
