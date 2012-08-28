Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:49542 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab2H1V7Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Aug 2012 17:59:24 -0400
Received: from eusync1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M9H002RFJRNKI00@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 28 Aug 2012 22:59:47 +0100 (BST)
Received: from AMDN157 ([106.210.236.152])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0M9H00MPCJQUB230@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 28 Aug 2012 22:59:21 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Arun Kumar K' <arun.kk@samsung.com>, linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, janghyuck.kim@samsung.com,
	jaeryul.oh@samsung.com, ch.naveen@samsung.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kmpark@infradead.org, joshi@samsung.com
References: <1346068683-31610-1-git-send-email-arun.kk@samsung.com>
 <1346068683-31610-3-git-send-email-arun.kk@samsung.com>
In-reply-to: <1346068683-31610-3-git-send-email-arun.kk@samsung.com>
Subject: RE: [PATCH v5 2/4] [media] s5p-mfc: Add MFC variant data to device
 context
Date: Tue, 28 Aug 2012 14:59:17 -0700
Message-id: <001901cd8568$60c09820$2241c860$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

Please find my comments below.

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


> From: Arun Kumar K [mailto:arun.kk@samsung.com]
> Sent: 27 August 2012 04:58

[...]

> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_common.h
> b/drivers/media/video/s5p-mfc/s5p_mfc_common.h
> index 9834b4e..0c1618e 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_common.h
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_common.h
> @@ -30,17 +30,6 @@
>  *  while mmaping */
>  #define DST_QUEUE_OFF_BASE      (TASK_SIZE / 2)
> 
> -/* Offset used by the hardware to store addresses */
> -#define MFC_OFFSET_SHIFT	11
> -
> -#define FIRMWARE_ALIGN		0x20000		/* 128KB */
> -#define MFC_H264_CTX_BUF_SIZE	0x96000		/* 600KB per H264
instance
> */
> -#define MFC_CTX_BUF_SIZE	0x2800		/* 10KB per instance */
> -#define DESC_BUF_SIZE		0x20000		/* 128KB for DESC
buffer */
> -#define SHARED_BUF_SIZE		0x2000		/* 8KB for shared
buffer */
> -
> -#define DEF_CPB_SIZE		0x40000		/* 512KB */
> -
>  #define MFC_BANK1_ALLOC_CTX	0
>  #define MFC_BANK2_ALLOC_CTX	1
> 
> @@ -207,6 +196,47 @@ struct s5p_mfc_pm {
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
> @@ -257,6 +287,7 @@ struct s5p_mfc_dev {
>  	struct v4l2_ctrl_handler dec_ctrl_handler;
>  	struct v4l2_ctrl_handler enc_ctrl_handler;
>  	struct s5p_mfc_pm	pm;
> +	struct s5p_mfc_variant	*variant;

No description for this variable above.

>  	int num_inst;
>  	spinlock_t irqlock;	/* lock when operating on videobuf2 queues */
>  	spinlock_t condlock;	/* lock when changing/checking if a context is
> @@ -295,7 +326,6 @@ struct s5p_mfc_h264_enc_params {
>  	u8 max_ref_pic;
>  	u8 num_ref_pic_4p;
>  	int _8x8_transform;
> -	int rc_mb;
>  	int rc_mb_dark;
>  	int rc_mb_smooth;
>  	int rc_mb_static;
> @@ -314,6 +344,7 @@ struct s5p_mfc_h264_enc_params {
>  	enum v4l2_mpeg_video_h264_level level_v4l2;
>  	int level;
>  	u16 cpb_size;
> +	int interlace;
>  };
> 
>  /**
> @@ -352,6 +383,7 @@ struct s5p_mfc_enc_params {
>  	u8 pad_cb;
>  	u8 pad_cr;
>  	int rc_frame;
> +	int rc_mb;
>  	u32 rc_bitrate;
>  	u16 rc_reaction_coeff;
>  	u16 vbv_size;
> @@ -363,7 +395,6 @@ struct s5p_mfc_enc_params {
>  	u8 num_b_frame;
>  	u32 rc_framerate_num;
>  	u32 rc_framerate_denom;
> -	int interlace;
> 
>  	union {
>  		struct s5p_mfc_h264_enc_params h264;
> @@ -540,18 +571,9 @@ struct s5p_mfc_ctx {
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

Also no description for these variables.

>  	struct s5p_mfc_enc_params enc_params;
> 

[...]

