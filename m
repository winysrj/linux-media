Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:54917 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751346AbcGMKxJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 06:53:09 -0400
Message-ID: <1468407163.3555.1.camel@mtksdaap41>
Subject: Re: [PATCH v2] [media] mtk-vcodec: fix more type mismatches
From: pochun lin <pochun.lin@mediatek.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	"Tiffany Lin" <tiffany.lin@mediatek.com>,
	<linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>
Date: Wed, 13 Jul 2016 18:52:43 +0800
In-Reply-To: <20160713084916.2765651-1-arnd@arndb.de>
References: <20160713084916.2765651-1-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On Wed, 2016-07-13 at 10:47 +0200, Arnd Bergmann wrote:
> The newly added mtk-vcodec driver produces a number of warnings in an ARM
> allmodconfig build, mainly since it assumes that dma_addr_t is 32-bit wide:
> 
> mtk-vcodec/venc/venc_vp8_if.c: In function 'vp8_enc_alloc_work_buf':
> mtk-vcodec/venc/venc_vp8_if.c:212:191: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
> mtk-vcodec/venc/venc_h264_if.c: In function 'h264_enc_alloc_work_buf':
> mtk-vcodec/venc/venc_h264_if.c:297:190: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
> 
> This rearranges the format strings and type casts to what they should have been
> in order to avoid the warnings. e0f80d8d62f5 ("[media] mtk-vcodec: fix two compiler
> warnings") fixed some of the problems that were introduced at the same time, but
> missed two others.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c | 4 ++--
>  drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c  | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c b/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c
> index f4e18bb44cb9..9a600525b3c1 100644
> --- a/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c
> +++ b/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c
> @@ -295,9 +295,9 @@ static int h264_enc_alloc_work_buf(struct venc_h264_inst *inst)
>  		wb[i].iova = inst->work_bufs[i].dma_addr;
>  
>  		mtk_vcodec_debug(inst,
> -				 "work_buf[%d] va=0x%p iova=0x%p size=%zu",
> +				 "work_buf[%d] va=0x%p iova=%pad size=%zu",
>  				 i, inst->work_bufs[i].va,
> -				 (void *)inst->work_bufs[i].dma_addr,
> +				 &inst->work_bufs[i].dma_addr,
>  				 inst->work_bufs[i].size);
>  	}
>  

This modified will dump dma_addr's address, not dma_addr value.
In actually, we need to dump dma_addr value.
Thanks.

> diff --git a/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c b/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
> index 5b4ef0f1740c..60bbcd2a0510 100644
> --- a/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
> +++ b/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
> @@ -210,9 +210,9 @@ static int vp8_enc_alloc_work_buf(struct venc_vp8_inst *inst)
>  		wb[i].iova = inst->work_bufs[i].dma_addr;
>  
>  		mtk_vcodec_debug(inst,
> -				 "work_bufs[%d] va=0x%p,iova=0x%p,size=%zu",
> +				 "work_bufs[%d] va=0x%p,iova=%pad,size=%zu",
>  				 i, inst->work_bufs[i].va,
> -				 (void *)inst->work_bufs[i].dma_addr,
> +				 &inst->work_bufs[i].dma_addr,
>  				 inst->work_bufs[i].size);
>  	}
>  

The same as above.

Best Regards
PoChun


