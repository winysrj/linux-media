Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:13929 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428Ab2EJIzd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 04:55:33 -0400
Received: from epcpsbgm2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M3S00BJ0U4GU3O0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 17:55:31 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M3S00HW4U4EI040@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 17:55:31 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sachin Kamat' <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org
Cc: mchehab@infradead.org, kyungmin.park@samsung.com,
	patches@linaro.org
References: <1336631521-24820-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1336631521-24820-1-git-send-email-sachin.kamat@linaro.org>
Subject: RE: [PATCH 1/2] [media] s5p-mfc: Fix NULL pointer warnings
Date: Thu, 10 May 2012 10:55:25 +0200
Message-id: <017101cd2e8a$a708aaa0$f519ffe0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

Thanks for the patch.

Best regards,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

> From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
> Sent: 10 May 2012 08:32
> 
> Fixes the following type of warnings detected by sparse:
> warning: Using plain integer as NULL pointer.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
>  drivers/media/video/s5p-mfc/s5p_mfc.c      |   10 +++++-----
>  drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c |   16 ++++++++--------
>  drivers/media/video/s5p-mfc/s5p_mfc_opr.c  |   26 +++++++++++++---------
> ----
>  3 files changed, 26 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c
> b/drivers/media/video/s5p-mfc/s5p_mfc.c
> index 83fe461..ac2dac9 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
> @@ -373,7 +373,7 @@ static void s5p_mfc_handle_error(struct s5p_mfc_ctx
> *ctx,
> 
>  	/* If no context is available then all necessary
>  	 * processing has been done. */
> -	if (ctx == 0)
> +	if (ctx == NULL)
>  		return;
> 
>  	dev = ctx->dev;
> @@ -429,7 +429,7 @@ static void s5p_mfc_handle_seq_done(struct
> s5p_mfc_ctx *ctx,
>  	struct s5p_mfc_dev *dev;
>  	unsigned int guard_width, guard_height;
> 
> -	if (ctx == 0)
> +	if (ctx == NULL)
>  		return;
>  	dev = ctx->dev;
>  	if (ctx->c_ops->post_seq_start) {
> @@ -496,7 +496,7 @@ static void s5p_mfc_handle_init_buffers(struct
> s5p_mfc_ctx *ctx,
>  	struct s5p_mfc_dev *dev;
>  	unsigned long flags;
> 
> -	if (ctx == 0)
> +	if (ctx == NULL)
>  		return;
>  	dev = ctx->dev;
>  	s5p_mfc_clear_int_flags(dev);
> @@ -772,7 +772,7 @@ err_queue_init:
>  err_init_hw:
>  	s5p_mfc_release_firmware(dev);
>  err_alloc_fw:
> -	dev->ctx[ctx->num] = 0;
> +	dev->ctx[ctx->num] = NULL;
>  	del_timer_sync(&dev->watchdog_timer);
>  	s5p_mfc_clock_off();
>  err_pwr_enable:
> @@ -849,7 +849,7 @@ static int s5p_mfc_release(struct file *file)
>  	}
>  	mfc_debug(2, "Shutting down clock\n");
>  	s5p_mfc_clock_off();
> -	dev->ctx[ctx->num] = 0;
> +	dev->ctx[ctx->num] = NULL;
>  	s5p_mfc_dec_ctrls_delete(ctx);
>  	v4l2_fh_del(&ctx->fh);
>  	v4l2_fh_exit(&ctx->fh);
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
> b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
> index f2481a8..08a5cfe 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
> @@ -52,7 +52,7 @@ int s5p_mfc_alloc_and_load_firmware(struct s5p_mfc_dev
> *dev)
>  	s5p_mfc_bitproc_buf = vb2_dma_contig_memops.alloc(
>  		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], dev->fw_size);
>  	if (IS_ERR(s5p_mfc_bitproc_buf)) {
> -		s5p_mfc_bitproc_buf = 0;
> +		s5p_mfc_bitproc_buf = NULL;
>  		mfc_err("Allocating bitprocessor buffer failed\n");
>  		release_firmware(fw_blob);
>  		return -ENOMEM;
> @@ -63,7 +63,7 @@ int s5p_mfc_alloc_and_load_firmware(struct s5p_mfc_dev
> *dev)
>  		mfc_err("The base memory for bank 1 is not aligned to
> 128KB\n");
>  		vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
>  		s5p_mfc_bitproc_phys = 0;
> -		s5p_mfc_bitproc_buf = 0;
> +		s5p_mfc_bitproc_buf = NULL;
>  		release_firmware(fw_blob);
>  		return -EIO;
>  	}
> @@ -72,7 +72,7 @@ int s5p_mfc_alloc_and_load_firmware(struct s5p_mfc_dev
> *dev)
>  		mfc_err("Bitprocessor memory remap failed\n");
>  		vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
>  		s5p_mfc_bitproc_phys = 0;
> -		s5p_mfc_bitproc_buf = 0;
> +		s5p_mfc_bitproc_buf = NULL;
>  		release_firmware(fw_blob);
>  		return -EIO;
>  	}
> @@ -82,7 +82,7 @@ int s5p_mfc_alloc_and_load_firmware(struct s5p_mfc_dev
> *dev)
>  	if (IS_ERR(b_base)) {
>  		vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
>  		s5p_mfc_bitproc_phys = 0;
> -		s5p_mfc_bitproc_buf = 0;
> +		s5p_mfc_bitproc_buf = NULL;
>  		mfc_err("Allocating bank2 base failed\n");
>  	release_firmware(fw_blob);
>  		return -ENOMEM;
> @@ -94,7 +94,7 @@ int s5p_mfc_alloc_and_load_firmware(struct s5p_mfc_dev
> *dev)
>  		mfc_err("The base memory for bank 2 is not aligned to
> 128KB\n");
>  		vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
>  		s5p_mfc_bitproc_phys = 0;
> -		s5p_mfc_bitproc_buf = 0;
> +		s5p_mfc_bitproc_buf = NULL;
>  		release_firmware(fw_blob);
>  		return -EIO;
>  	}
> @@ -126,7 +126,7 @@ int s5p_mfc_reload_firmware(struct s5p_mfc_dev *dev)
>  		release_firmware(fw_blob);
>  		return -ENOMEM;
>  	}
> -	if (s5p_mfc_bitproc_buf == 0 || s5p_mfc_bitproc_phys == 0) {
> +	if (s5p_mfc_bitproc_buf == NULL || s5p_mfc_bitproc_phys == 0) {
>  		mfc_err("MFC firmware is not allocated or was not mapped
> correctly\n");
>  		release_firmware(fw_blob);
>  		return -EINVAL;
> @@ -146,9 +146,9 @@ int s5p_mfc_release_firmware(struct s5p_mfc_dev *dev)
>  	if (!s5p_mfc_bitproc_buf)
>  		return -EINVAL;
>  	vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
> -	s5p_mfc_bitproc_virt =  0;
> +	s5p_mfc_bitproc_virt = NULL;
>  	s5p_mfc_bitproc_phys = 0;
> -	s5p_mfc_bitproc_buf = 0;
> +	s5p_mfc_bitproc_buf = NULL;
>  	return 0;
>  }
> 
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
> b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
> index e08b21c..a802829 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
> @@ -43,7 +43,7 @@ int s5p_mfc_alloc_dec_temp_buffers(struct s5p_mfc_ctx
> *ctx)
>  	ctx->desc_buf = vb2_dma_contig_memops.alloc(
>  			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], DESC_BUF_SIZE);
>  	if (IS_ERR_VALUE((int)ctx->desc_buf)) {
> -		ctx->desc_buf = 0;
> +		ctx->desc_buf = NULL;
>  		mfc_err("Allocating DESC buffer failed\n");
>  		return -ENOMEM;
>  	}
> @@ -54,7 +54,7 @@ int s5p_mfc_alloc_dec_temp_buffers(struct s5p_mfc_ctx
> *ctx)
>  	if (desc_virt == NULL) {
>  		vb2_dma_contig_memops.put(ctx->desc_buf);
>  		ctx->desc_phys = 0;
> -		ctx->desc_buf = 0;
> +		ctx->desc_buf = NULL;
>  		mfc_err("Remapping DESC buffer failed\n");
>  		return -ENOMEM;
>  	}
> @@ -69,7 +69,7 @@ void s5p_mfc_release_dec_desc_buffer(struct s5p_mfc_ctx
> *ctx)
>  	if (ctx->desc_phys) {
>  		vb2_dma_contig_memops.put(ctx->desc_buf);
>  		ctx->desc_phys = 0;
> -		ctx->desc_buf = 0;
> +		ctx->desc_buf = NULL;
>  	}
>  }
> 
> @@ -186,7 +186,7 @@ int s5p_mfc_alloc_codec_buffers(struct s5p_mfc_ctx
> *ctx)
>  		ctx->bank1_buf = vb2_dma_contig_memops.alloc(
>  		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->bank1_size);
>  		if (IS_ERR(ctx->bank1_buf)) {
> -			ctx->bank1_buf = 0;
> +			ctx->bank1_buf = NULL;
>  			printk(KERN_ERR
>  			       "Buf alloc for decoding failed (port A)\n");
>  			return -ENOMEM;
> @@ -200,7 +200,7 @@ int s5p_mfc_alloc_codec_buffers(struct s5p_mfc_ctx
> *ctx)
>  		ctx->bank2_buf = vb2_dma_contig_memops.alloc(
>  		dev->alloc_ctx[MFC_BANK2_ALLOC_CTX], ctx->bank2_size);
>  		if (IS_ERR(ctx->bank2_buf)) {
> -			ctx->bank2_buf = 0;
> +			ctx->bank2_buf = NULL;
>  			mfc_err("Buf alloc for decoding failed (port B)\n");
>  			return -ENOMEM;
>  		}
> @@ -216,13 +216,13 @@ void s5p_mfc_release_codec_buffers(struct
> s5p_mfc_ctx *ctx)
>  {
>  	if (ctx->bank1_buf) {
>  		vb2_dma_contig_memops.put(ctx->bank1_buf);
> -		ctx->bank1_buf = 0;
> +		ctx->bank1_buf = NULL;
>  		ctx->bank1_phys = 0;
>  		ctx->bank1_size = 0;
>  	}
>  	if (ctx->bank2_buf) {
>  		vb2_dma_contig_memops.put(ctx->bank2_buf);
> -		ctx->bank2_buf = 0;
> +		ctx->bank2_buf = NULL;
>  		ctx->bank2_phys = 0;
>  		ctx->bank2_size = 0;
>  	}
> @@ -244,7 +244,7 @@ int s5p_mfc_alloc_instance_buffer(struct s5p_mfc_ctx
> *ctx)
>  	if (IS_ERR(ctx->ctx_buf)) {
>  		mfc_err("Allocating context buffer failed\n");
>  		ctx->ctx_phys = 0;
> -		ctx->ctx_buf = 0;
> +		ctx->ctx_buf = NULL;
>  		return -ENOMEM;
>  	}
>  	ctx->ctx_phys = s5p_mfc_mem_cookie(
> @@ -256,7 +256,7 @@ int s5p_mfc_alloc_instance_buffer(struct s5p_mfc_ctx
> *ctx)
>  		mfc_err("Remapping instance buffer failed\n");
>  		vb2_dma_contig_memops.put(ctx->ctx_buf);
>  		ctx->ctx_phys = 0;
> -		ctx->ctx_buf = 0;
> +		ctx->ctx_buf = NULL;
>  		return -ENOMEM;
>  	}
>  	/* Zero content of the allocated memory */
> @@ -265,7 +265,7 @@ int s5p_mfc_alloc_instance_buffer(struct s5p_mfc_ctx
> *ctx)
>  	if (s5p_mfc_init_shm(ctx) < 0) {
>  		vb2_dma_contig_memops.put(ctx->ctx_buf);
>  		ctx->ctx_phys = 0;
> -		ctx->ctx_buf = 0;
> +		ctx->ctx_buf = NULL;
>  		return -ENOMEM;
>  	}
>  	return 0;
> @@ -277,12 +277,12 @@ void s5p_mfc_release_instance_buffer(struct
> s5p_mfc_ctx *ctx)
>  	if (ctx->ctx_buf) {
>  		vb2_dma_contig_memops.put(ctx->ctx_buf);
>  		ctx->ctx_phys = 0;
> -		ctx->ctx_buf = 0;
> +		ctx->ctx_buf = NULL;
>  	}
>  	if (ctx->shm_alloc) {
>  		vb2_dma_contig_memops.put(ctx->shm_alloc);
> -		ctx->shm_alloc = 0;
> -		ctx->shm = 0;
> +		ctx->shm_alloc = NULL;
> +		ctx->shm = NULL;
>  	}
>  }
> 
> --
> 1.7.4.1

