Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:60959 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933408AbcGKDHy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 23:07:54 -0400
Message-ID: <1468206468.3725.17.camel@mtksdaap41>
Subject: Re: [PATCH 1/2] mtk-vcodec: fix two compiler warnings
From: tiffany lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Date: Mon, 11 Jul 2016 11:07:48 +0800
In-Reply-To: <1468049578-10039-1-git-send-email-hverkuil@xs4all.nl>
References: <1468049578-10039-1-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2016-07-09 at 09:32 +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> mtk-vcodec/mtk_vcodec_enc.c: In function 'mtk_venc_worker':
> mtk-vcodec/mtk_vcodec_enc.c:1030:43: warning: format '%lx' expects argument of type 'long unsigned int', but argument 7 has type 'size_t {aka unsigned int}' [-Wformat=]
> mtk-vcodec/mtk_vcodec_enc.c:1030:43: warning: format '%lx' expects argument of type 'long unsigned int', but argument 10 has type 'size_t {aka unsigned int}' [-Wformat=]
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> index 6dcae0a..907a6d1 100644
> --- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> @@ -1028,7 +1028,7 @@ static void mtk_venc_worker(struct work_struct *work)
>  	bs_buf.size = (size_t)dst_buf->planes[0].length;
>  
>  	mtk_v4l2_debug(2,
> -			"Framebuf VA=%p PA=%llx Size=0x%lx;VA=%p PA=0x%llx Size=0x%lx;VA=%p PA=0x%llx Size=%zu",
> +			"Framebuf VA=%p PA=%llx Size=0x%zx;VA=%p PA=0x%llx Size=0x%zx;VA=%p PA=0x%llx Size=%zu",
>  			frm_buf.fb_addr[0].va,
>  			(u64)frm_buf.fb_addr[0].dma_addr,
>  			frm_buf.fb_addr[0].size,

reviewed-by: Tiffany Lin <tiffany.lin@mediatek.com>

