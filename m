Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:64630 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752641AbdCGH7t (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 02:59:49 -0500
Message-ID: <1488873582.20293.4.camel@mtksdaap41>
Subject: Re: [PATCH 1/1] mtk-vcodec: check the vp9 decoder buffer index from
 VPU.
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Wu-Cheng Li <wuchengli@chromium.org>
CC: <pawel@osciak.com>, <andrew-ct.chen@mediatek.com>,
        <mchehab@kernel.org>, <matthias.bgg@gmail.com>,
        <hans.verkuil@cisco.com>, <wuchengli@google.com>,
        <djkurtz@chromium.org>, <linux-media@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Date: Tue, 7 Mar 2017 15:59:42 +0800
In-Reply-To: <20170307060328.114348-2-wuchengli@chromium.org>
References: <20170307060328.114348-1-wuchengli@chromium.org>
         <20170307060328.114348-2-wuchengli@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-03-07 at 14:03 +0800, Wu-Cheng Li wrote:
> From: Wu-Cheng Li <wuchengli@google.com>
> 
> VPU firmware has a bug and may return invalid buffer index for
> some vp9 videos. Check the buffer indexes before accessing the
> buffer.
> 
> Signed-off-by: Wu-Cheng Li <wuchengli@chromium.org>
> ---
>  drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c |  6 +++++
>  .../media/platform/mtk-vcodec/vdec/vdec_vp9_if.c   | 26 ++++++++++++++++++++++
>  drivers/media/platform/mtk-vcodec/vdec_drv_if.h    |  2 ++
>  3 files changed, 34 insertions(+)
> 
> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
> index 502877a4b1df..7ebcf9e57ac7 100644
> --- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
> @@ -1176,6 +1176,12 @@ static void vb2ops_vdec_buf_queue(struct vb2_buffer *vb)
>  			       "[%d] vdec_if_decode() src_buf=%d, size=%zu, fail=%d, res_chg=%d",
>  			       ctx->id, src_buf->index,
>  			       src_mem.size, ret, res_chg);
> +
> +		if (ret == -EIO) {
> +			mtk_v4l2_err("[%d] Unrecoverable error in vdec_if_decode.",
> +					ctx->id);
> +			ctx->state = MTK_STATE_ABORT;
> +		}
Could we use v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf),
VB2_BUF_STATE_ERROR); instead ctx->state = MTK_STATE_ABORT;
In this case, the behavior will be same as vdec_if_decode called in
mtk_vdec_worker.
And we could also get information about what output buffer make vpu
crash.

best regards,
Tiffany
>  		return;
>  	}
>  
> diff --git a/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c b/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c
> index e91a3b425b0c..5539b1853f16 100644
> --- a/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c
> +++ b/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c
> @@ -718,6 +718,26 @@ static void get_free_fb(struct vdec_vp9_inst *inst, struct vdec_fb **out_fb)
>  	*out_fb = fb;
>  }
>  
> +static int validate_vsi_array_indexes(struct vdec_vp9_inst *inst,
> +		struct vdec_vp9_vsi *vsi) {
> +	if (vsi->sf_frm_idx >= VP9_MAX_FRM_BUF_NUM - 1) {
> +		mtk_vcodec_err(inst, "Invalid vsi->sf_frm_idx=%u.",
> +				vsi->sf_frm_idx);
> +		return -EIO;
> +	}
> +	if (vsi->frm_to_show_idx >= VP9_MAX_FRM_BUF_NUM) {
> +		mtk_vcodec_err(inst, "Invalid vsi->frm_to_show_idx=%u.",
> +				vsi->frm_to_show_idx);
> +		return -EIO;
> +	}
> +	if (vsi->new_fb_idx >= VP9_MAX_FRM_BUF_NUM) {
> +		mtk_vcodec_err(inst, "Invalid vsi->new_fb_idx=%u.",
> +				vsi->new_fb_idx);
> +		return -EIO;
> +	}
> +	return 0;
> +}
> +
>  static void vdec_vp9_deinit(unsigned long h_vdec)
>  {
>  	struct vdec_vp9_inst *inst = (struct vdec_vp9_inst *)h_vdec;
> @@ -834,6 +854,12 @@ static int vdec_vp9_decode(unsigned long h_vdec, struct mtk_vcodec_mem *bs,
>  			goto DECODE_ERROR;
>  		}
>  
> +		ret = validate_vsi_array_indexes(inst, vsi);
> +		if (ret) {
> +			mtk_vcodec_err(inst, "Invalid values from VPU.");
> +			goto DECODE_ERROR;
> +		}
> +
>  		if (vsi->resolution_changed) {
>  			if (!vp9_alloc_work_buf(inst)) {
>  				ret = -EINVAL;
> diff --git a/drivers/media/platform/mtk-vcodec/vdec_drv_if.h b/drivers/media/platform/mtk-vcodec/vdec_drv_if.h
> index db6b5205ffb1..ded1154481cd 100644
> --- a/drivers/media/platform/mtk-vcodec/vdec_drv_if.h
> +++ b/drivers/media/platform/mtk-vcodec/vdec_drv_if.h
> @@ -85,6 +85,8 @@ void vdec_if_deinit(struct mtk_vcodec_ctx *ctx);
>   * @res_chg	: [out] resolution change happens if current bs have different
>   *	picture width/height
>   * Note: To flush the decoder when reaching EOF, set input bitstream as NULL.
> + *
> + * Return: 0 on success. -EIO on unrecoverable error.
>   */
>  int vdec_if_decode(struct mtk_vcodec_ctx *ctx, struct mtk_vcodec_mem *bs,
>  		   struct vdec_fb *fb, bool *res_chg);
