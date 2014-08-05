Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60574 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932795AbaHEJL2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 05:11:28 -0400
From: Kamil Debski <k.debski@samsung.com>
To: 'Zhaowei Yuan' <zhaowei.yuan@samsung.com>,
	linux-media@vger.kernel.org, m.chehab@samsung.com,
	kyungmin.park@samsung.com, jtp.park@samsung.com
Cc: linux-samsung-soc@vger.kernel.org
References: <1407222797-14350-1-git-send-email-zhaowei.yuan@samsung.com>
In-reply-to: <1407222797-14350-1-git-send-email-zhaowei.yuan@samsung.com>
Subject: RE: [PATCH] media: s5p_mfc: Release ctx->ctx if failed to allocate
 ctx->shm
Date: Tue, 05 Aug 2014 11:11:28 +0200
Message-id: <0bd801cfb08d$3e5cf330$bb16d990$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Zhaowei,

Please provide a short and informative commit description.

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


> -----Original Message-----
> From: Zhaowei Yuan [mailto:zhaowei.yuan@samsung.com]
> Sent: Tuesday, August 05, 2014 9:13 AM
> To: linux-media@vger.kernel.org; k.debski@samsung.com;
> m.chehab@samsung.com; kyungmin.park@samsung.com; jtp.park@samsung.com
> Cc: linux-samsung-soc@vger.kernel.org
> Subject: [PATCH] media: s5p_mfc: Release ctx->ctx if failed to allocate
> ctx->shm
> 
> Signed-off-by: Zhaowei Yuan <zhaowei.yuan@samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |    1 +
>  1 file changed, 1 insertion(+)
>  mode change 100644 => 100755 drivers/media/platform/s5p-
> mfc/s5p_mfc_opr_v5.c
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
> old mode 100644
> new mode 100755
> index 58ec7bb..dc00aea
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
> @@ -228,6 +228,7 @@ static int s5p_mfc_alloc_instance_buffer_v5(struct
> s5p_mfc_ctx *ctx)
>  	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, &ctx->shm);
>  	if (ret) {
>  		mfc_err("Failed to allocate shared memory buffer\n");
> +		s5p_mfc_release_priv_buf(dev->mem_dev_l, &ctx->ctx);
>  		return ret;
>  	}
> 
> --
> 1.7.9.5

