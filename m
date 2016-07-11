Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:11007 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757595AbcGKDGT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 23:06:19 -0400
Message-ID: <1468206372.3725.16.camel@mtksdaap41>
Subject: Re: [PATCH 2/2] mtk-vcodec: fix compiler warning
From: tiffany lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Date: Mon, 11 Jul 2016 11:06:12 +0800
In-Reply-To: <1468049578-10039-2-git-send-email-hverkuil@xs4all.nl>
References: <1468049578-10039-1-git-send-email-hverkuil@xs4all.nl>
	 <1468049578-10039-2-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2016-07-09 at 09:32 +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> mtk-vcodec/venc_vpu_if.c:40:30: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>   struct venc_vpu_inst *vpu = (struct venc_vpu_inst *)msg->venc_inst;
>                               ^
> 
> Note: venc_inst is u64.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/mtk-vcodec/venc_vpu_if.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/mtk-vcodec/venc_vpu_if.c b/drivers/media/platform/mtk-vcodec/venc_vpu_if.c
> index b92c6d2..a01c759 100644
> --- a/drivers/media/platform/mtk-vcodec/venc_vpu_if.c
> +++ b/drivers/media/platform/mtk-vcodec/venc_vpu_if.c
> @@ -37,7 +37,8 @@ static void handle_enc_encode_msg(struct venc_vpu_inst *vpu, void *data)
>  static void vpu_enc_ipi_handler(void *data, unsigned int len, void *priv)
>  {
>  	struct venc_vpu_ipi_msg_common *msg = data;
> -	struct venc_vpu_inst *vpu = (struct venc_vpu_inst *)msg->venc_inst;
> +	struct venc_vpu_inst *vpu =
> +		(struct venc_vpu_inst *)(unsigned long)msg->venc_inst;
>  
reviewed-by: Tiffany Lin <tiffany.lin@mediatek.com>

>  	mtk_vcodec_debug(vpu, "msg_id %x inst %p status %d",
>  			 msg->msg_id, vpu, msg->status);


