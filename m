Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40737 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301Ab2HVQS5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 12:18:57 -0400
Received: from eusync1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M96004EF00BM1C0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Aug 2012 17:19:23 +0100 (BST)
Received: from AMDN157 ([106.116.147.102])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0M95000APZZH1920@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Aug 2012 17:18:56 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Arun Kumar K' <arun.kk@samsung.com>, linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, janghyuck.kim@samsung.com,
	jaeryul.oh@samsung.com, ch.naveen@samsung.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kmpark@infradead.org, joshi@samsung.com
References: <1344508110-16945-1-git-send-email-arun.kk@samsung.com>
 <1344508110-16945-3-git-send-email-arun.kk@samsung.com>
In-reply-to: <1344508110-16945-3-git-send-email-arun.kk@samsung.com>
Subject: RE: [PATCH v4 2/4] [media] s5p-mfc: Add MFC variant data to device
 context
Date: Wed, 22 Aug 2012 18:18:56 +0200
Message-id: <007201cd8081$d4596fa0$7d0c4ee0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

Please find the comments in the patch contents.

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


> From: Arun Kumar K [mailto:arun.kk@samsung.com]
> Sent: 09 August 2012 12:28
> 
> From: Jeongtae Park <jtp.park@samsung.com>
> 
> MFC variant data replaces various macros used in the driver
> which will change in a different version of MFC hardware.
> Also does a cleanup of MFC context structure and common files.
> 
> Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
> Signed-off-by: Janghyuck Kim <janghyuck.kim@samsung.com>
> Signed-off-by: Jaeryul Oh <jaeryul.oh@samsung.com>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> ---
>  drivers/media/video/s5p-mfc/regs-mfc.h       |    2 +-
>  drivers/media/video/s5p-mfc/s5p_mfc.c        |   78 +++++-----
>  drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.c |    4 +-
>  drivers/media/video/s5p-mfc/s5p_mfc_common.h |   66 ++++++---
>  drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c   |    7 +-
>  drivers/media/video/s5p-mfc/s5p_mfc_enc.c    |   44 +-----
>  drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.c |  213
+++++++++++++++++---------
>  7 files changed, 243 insertions(+), 171 deletions(-)
> 

[snip]

> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c
b/drivers/media/video/s5p-
> mfc/s5p_mfc.c
> index ab66680..be8d689 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc.c

[snip]

> @@ -1207,9 +1177,43 @@ static const struct dev_pm_ops s5p_mfc_pm_ops = {
>  			   NULL)
>  };
> 
> +struct s5p_mfc_buf_size_v5 mfc_buf_size_v5 = {
> +	.h264_ctx	= 0x96000,
> +	.non_h264_ctx	= 0x2800,
> +	.dsc		= 0x20000,
> +	.shm		= 0x1000,
> +};
> +
> +struct s5p_mfc_buf_size buf_size_v5 = {
> +	.fw	= 0x60000,
> +	.cpb	= 0x400000,	/*   4MB */
> +	.priv	= &mfc_buf_size_v5,
> +};

In s5p_mfc_common.h you have the macros that define (most of) the used above
values. Please use the defines.


> +
> +struct s5p_mfc_buf_align mfc_buf_align_v5 = {
> +	.base = 17,
> +};
> +

MFC_BASE_ALIGN_ORDER?

> +static struct s5p_mfc_variant mfc_drvdata_v5 = {
> +	.version	= 0x51,
> +	.port_num	= 2,
> +	.buf_size	= &buf_size_v5,
> +	.buf_align	= &mfc_buf_align_v5,
> +};
> +

[snip]

> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_common.h
> b/drivers/media/video/s5p-mfc/s5p_mfc_common.h
> index e705938..512e84e 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_common.h
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_common.h
> @@ -34,10 +34,6 @@
>  #define MFC_OFFSET_SHIFT	11
> 
>  #define FIRMWARE_ALIGN		0x20000		/* 128KB */
> -#define MFC_H264_CTX_BUF_SIZE	0x96000		/* 600KB per H264
instance
> */
> -#define MFC_CTX_BUF_SIZE	0x2800		/* 10KB per instance */
> -#define DESC_BUF_SIZE		0x20000		/* 128KB for DESC
buffer */
> -#define SHARED_BUF_SIZE		0x2000		/* 8KB for shared
buffer */
> 
>  #define DEF_CPB_SIZE		0x40000		/* 512KB */

Here are the defines.
I have noticed that you remove them in future patches, but I think it is a
better
idea to keep them here.

> 
> @@ -207,6 +203,47 @@ struct s5p_mfc_pm {
>  	struct device	*device;
>  };
> 
> +struct s5p_mfc_buf_size_v5 {
> +	unsigned int h264_ctx;
> +	unsigned int non_h264_ctx;
> +	unsigned int dsc;
> +	unsigned int shm;
> +};
> +
> +struct s5p_mfc_buf_size {
> +	unsigned int fw;
> +	unsigned int cpb;
> +	void *priv;
> +};
> +
> +struct s5p_mfc_buf_align {
> +	unsigned int base;
> +};
> +
> +struct s5p_mfc_variant {
> +	unsigned int version;
> +	unsigned int port_num;
> +	struct s5p_mfc_buf_size *buf_size;
> +	struct s5p_mfc_buf_align *buf_align;
> +};
> +
> +/**
> + * struct s5p_mfc_priv_buf - represents internal used buffer
> + * @alloc:		allocation-specific context for each buffer
> + *			(videobuf2 allocator)
> + * @ofs:		offset of each buffer, will be used for MFC
> + * @virt:		kernel virtual address, only valid when the
> + *			buffer accessed by driver
> + * @dma:		DMA address, only valid when kernel DMA API used
> + */
> +struct s5p_mfc_priv_buf {
> +	void		*alloc;
> +	unsigned long	ofs;
> +	void		*virt;
> +	dma_addr_t	dma;
> +	size_t		size;
> +};
> +
>  /**
>   * struct s5p_mfc_dev - The struct containing driver internal parameters.
>   *
> @@ -257,6 +294,7 @@ struct s5p_mfc_dev {
>  	struct v4l2_ctrl_handler dec_ctrl_handler;
>  	struct v4l2_ctrl_handler enc_ctrl_handler;
>  	struct s5p_mfc_pm	pm;
> +	struct s5p_mfc_variant	*variant;
>  	int num_inst;
>  	spinlock_t irqlock;	/* lock when operating on videobuf2 queues */
>  	spinlock_t condlock;	/* lock when changing/checking if a context is
> @@ -295,7 +333,6 @@ struct s5p_mfc_h264_enc_params {
>  	u8 max_ref_pic;
>  	u8 num_ref_pic_4p;
>  	int _8x8_transform;
> -	int rc_mb;
>  	int rc_mb_dark;
>  	int rc_mb_smooth;
>  	int rc_mb_static;
> @@ -314,6 +351,7 @@ struct s5p_mfc_h264_enc_params {
>  	enum v4l2_mpeg_video_h264_level level_v4l2;
>  	int level;
>  	u16 cpb_size;
> +	int interlace;
>  };
> 
>  /**
> @@ -352,6 +390,7 @@ struct s5p_mfc_enc_params {
>  	u8 pad_cb;
>  	u8 pad_cr;
>  	int rc_frame;
> +	int rc_mb;
>  	u32 rc_bitrate;
>  	u16 rc_reaction_coeff;
>  	u16 vbv_size;
> @@ -363,7 +402,6 @@ struct s5p_mfc_enc_params {
>  	u8 num_b_frame;
>  	u32 rc_framerate_num;
>  	u32 rc_framerate_denom;
> -	int interlace;
> 
>  	union {
>  		struct s5p_mfc_h264_enc_params h264;
> @@ -506,6 +544,7 @@ struct s5p_mfc_ctx {
>  	unsigned long consumed_stream;
> 
>  	unsigned int dpb_flush_flag;
> +	unsigned int remained;

I really don't like this name, as it does not describe the meaning.
I would call it maybe "head_processed" and reverse the values. Also
I recommend setting it to both values 0 and 1 appropriately in
s5p_mfc_handle_seq_done.

Also there is no description of the newly added variable (above the
structure).

> 
>  	/* Buffers */
>  	void *bank1_buf;
> @@ -540,18 +579,9 @@ struct s5p_mfc_ctx {
>  	int total_dpb_count;
> 
>  	/* Buffers */
> -	void *ctx_buf;
> -	size_t ctx_phys;
> -	size_t ctx_ofs;
> -	size_t ctx_size;
> -
> -	void *desc_buf;
> -	size_t desc_phys;
> -
> -
> -	void *shm_alloc;
> -	void *shm;
> -	size_t shm_ofs;
> +	struct s5p_mfc_priv_buf ctx;
> +	struct s5p_mfc_priv_buf dsc;
> +	struct s5p_mfc_priv_buf shm;
> 
>  	struct s5p_mfc_enc_params enc_params;
> 

[snip]

