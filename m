Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59391 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751975AbdAROiE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jan 2017 09:38:04 -0500
Subject: Re: [PATCH] [media] s5p-mfc: Align stream buffer and CPB buffer to 512
To: Smitha T Murthy <smitha.t@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <de7bbdbf-35cc-a575-79d1-2ec5764469a5@samsung.com>
Date: Wed, 18 Jan 2017 15:37:09 +0100
MIME-version: 1.0
In-reply-to: <1484732223-24670-1-git-send-email-smitha.t@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
References: <CGME20170118094212epcas5p22e588016d2b330dcd0b99b6e1012c744@epcas5p2.samsung.com>
 <1484732223-24670-1-git-send-email-smitha.t@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Smitha,

On 18.01.2017 10:37, Smitha T Murthy wrote:
> >From MFCv6 onwards encoder stream buffer and decoder CPB buffer

Unexpected char at the beginning.

> need to be aligned with 512.

Patch below adds checks only if buffer size is multiple of 512, am I right?
If yes, please precise the subject, for example "...CPB buffer size need
to be...".


>
> Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    9 +++++++++
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h |    3 +++
>  2 files changed, 12 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> index d6f207e..57da798 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> @@ -408,8 +408,15 @@ static int s5p_mfc_set_dec_stream_buffer_v6(struct s5p_mfc_ctx *ctx,
>  	struct s5p_mfc_dev *dev = ctx->dev;
>  	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
>  	struct s5p_mfc_buf_size *buf_size = dev->variant->buf_size;
> +	size_t cpb_buf_size;
>  
>  	mfc_debug_enter();
> +	cpb_buf_size = ALIGN(buf_size->cpb, CPB_ALIGN);

Since buf_size->cpb is constant of know size there is no need to align
it here.

> +	if (strm_size >= set_strm_size_max(cpb_buf_size)) {
> +		mfc_debug(2, "Decrease strm_size : %u -> %zu, gap : %d\n",
> +			strm_size, set_strm_size_max(cpb_buf_size), CPB_ALIGN);
> +		strm_size = set_strm_size_max(cpb_buf_size);
> +	}

As I understand strm_size here is a size of buffer to be decoded, why it
cannot be equal to buf_size->cpb? Commit message says nothing about it.

>  	mfc_debug(2, "inst_no: %d, buf_addr: 0x%08x,\n"
>  		"buf_size: 0x%08x (%d)\n",
>  		ctx->inst_no, buf_addr, strm_size, strm_size);
> @@ -519,6 +526,8 @@ static int s5p_mfc_set_enc_stream_buffer_v6(struct s5p_mfc_ctx *ctx,
>  	struct s5p_mfc_dev *dev = ctx->dev;
>  	const struct s5p_mfc_regs *mfc_regs = dev->mfc_regs;
>  
> +	size = ALIGN(size, 512);
> +

Shouldn't be CPB_ALIGN instead of 512? And more importantly size is a
length of buffer for encoded stream,
by up-aligning you tell MFC that it can write beyond the buffer, it
could potentially overwrite random memory? Am I right?


>  	writel(addr, mfc_regs->e_stream_buffer_addr); /* 16B align */
>  	writel(size, mfc_regs->e_stream_buffer_size);
>  
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
> index 8055848..16a7b1d 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
> @@ -40,6 +40,9 @@
>  #define FRAME_DELTA_H264_H263		1
>  #define TIGHT_CBR_MAX			10
>  
> +#define CPB_ALIGN			512
> +#define set_strm_size_max(cpb_max)	((cpb_max) - CPB_ALIGN)

Name of the macro is misleading.

Regards
Andrzej

> +
>  struct s5p_mfc_hw_ops *s5p_mfc_init_hw_ops_v6(void);
>  const struct s5p_mfc_regs *s5p_mfc_init_regs_v6_plus(struct s5p_mfc_dev *dev);
>  #endif /* S5P_MFC_OPR_V6_H_ */


