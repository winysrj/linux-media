Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:38416 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752444AbdCCQKZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Mar 2017 11:10:25 -0500
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OM801A9DMDOHX80@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 03 Mar 2017 20:53:48 +0900 (KST)
Subject: Re: [v2,01/15] media: s5p-mfc: Remove unused structures and dead code
From: Smitha T Murthy <smitha.t@samsung.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
In-reply-to: <1487597944-2000-2-git-send-email-m.szyprowski@samsung.com>
Date: Fri, 03 Mar 2017 17:26:51 +0530
Message-id: <1488542211.3182.14.camel@smitha-fedora>
MIME-version: 1.0
Content-transfer-encoding: 7bit
Content-type: text/plain; charset=utf-8
References: <1487597944-2000-2-git-send-email-m.szyprowski@samsung.com>
 <CGME20170303115347epcas5p1a4d81408a974580cd1c1f2c6d216f10a@epcas5p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-02-20 at 14:38 +0100, Marek Szyprowski wrote:
> Remove unused structures, definitions and functions that are no longer
> called from the driver code.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
> Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>
> Acked-by: Andrzej Hajda <a.hajda@samsung.com>

Reviewed-by: Smitha T Murthy <smitha.t@samsung.com>

Regards,
Smitha T Murthy
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c        | 21 ---------------------
>  drivers/media/platform/s5p-mfc/s5p_mfc_common.h | 13 -------------
>  drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h   |  1 -
>  3 files changed, 35 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index 05fe82be6584..3e1f22eb4339 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -1422,16 +1422,11 @@ static int s5p_mfc_resume(struct device *dev)
>  	.priv	= &mfc_buf_size_v5,
>  };
>  
> -static struct s5p_mfc_buf_align mfc_buf_align_v5 = {
> -	.base = MFC_BASE_ALIGN_ORDER,
> -};
> -
>  static struct s5p_mfc_variant mfc_drvdata_v5 = {
>  	.version	= MFC_VERSION,
>  	.version_bit	= MFC_V5_BIT,
>  	.port_num	= MFC_NUM_PORTS,
>  	.buf_size	= &buf_size_v5,
> -	.buf_align	= &mfc_buf_align_v5,
>  	.fw_name[0]	= "s5p-mfc.fw",
>  	.clk_names	= {"mfc", "sclk_mfc"},
>  	.num_clocks	= 2,
> @@ -1452,16 +1447,11 @@ static int s5p_mfc_resume(struct device *dev)
>  	.priv	= &mfc_buf_size_v6,
>  };
>  
> -static struct s5p_mfc_buf_align mfc_buf_align_v6 = {
> -	.base = 0,
> -};
> -
>  static struct s5p_mfc_variant mfc_drvdata_v6 = {
>  	.version	= MFC_VERSION_V6,
>  	.version_bit	= MFC_V6_BIT,
>  	.port_num	= MFC_NUM_PORTS_V6,
>  	.buf_size	= &buf_size_v6,
> -	.buf_align	= &mfc_buf_align_v6,
>  	.fw_name[0]     = "s5p-mfc-v6.fw",
>  	/*
>  	 * v6-v2 firmware contains bug fixes and interface change
> @@ -1486,16 +1476,11 @@ static int s5p_mfc_resume(struct device *dev)
>  	.priv	= &mfc_buf_size_v7,
>  };
>  
> -static struct s5p_mfc_buf_align mfc_buf_align_v7 = {
> -	.base = 0,
> -};
> -
>  static struct s5p_mfc_variant mfc_drvdata_v7 = {
>  	.version	= MFC_VERSION_V7,
>  	.version_bit	= MFC_V7_BIT,
>  	.port_num	= MFC_NUM_PORTS_V7,
>  	.buf_size	= &buf_size_v7,
> -	.buf_align	= &mfc_buf_align_v7,
>  	.fw_name[0]     = "s5p-mfc-v7.fw",
>  	.clk_names	= {"mfc", "sclk_mfc"},
>  	.num_clocks	= 2,
> @@ -1515,16 +1500,11 @@ static int s5p_mfc_resume(struct device *dev)
>  	.priv	= &mfc_buf_size_v8,
>  };
>  
> -static struct s5p_mfc_buf_align mfc_buf_align_v8 = {
> -	.base = 0,
> -};
> -
>  static struct s5p_mfc_variant mfc_drvdata_v8 = {
>  	.version	= MFC_VERSION_V8,
>  	.version_bit	= MFC_V8_BIT,
>  	.port_num	= MFC_NUM_PORTS_V8,
>  	.buf_size	= &buf_size_v8,
> -	.buf_align	= &mfc_buf_align_v8,
>  	.fw_name[0]     = "s5p-mfc-v8.fw",
>  	.clk_names	= {"mfc"},
>  	.num_clocks	= 1,
> @@ -1535,7 +1515,6 @@ static int s5p_mfc_resume(struct device *dev)
>  	.version_bit	= MFC_V8_BIT,
>  	.port_num	= MFC_NUM_PORTS_V8,
>  	.buf_size	= &buf_size_v8,
> -	.buf_align	= &mfc_buf_align_v8,
>  	.fw_name[0]     = "s5p-mfc-v8.fw",
>  	.clk_names	= {"pclk", "aclk", "aclk_xiu"},
>  	.num_clocks	= 3,
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> index ab23236aa942..3e0e8eaf8bfe 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> @@ -44,14 +44,6 @@
>  
>  #include <media/videobuf2-dma-contig.h>
>  
> -static inline dma_addr_t s5p_mfc_mem_cookie(void *a, void *b)
> -{
> -	/* Same functionality as the vb2_dma_contig_plane_paddr */
> -	dma_addr_t *paddr = vb2_dma_contig_memops.cookie(b);
> -
> -	return *paddr;
> -}
> -
>  /* MFC definitions */
>  #define MFC_MAX_EXTRA_DPB       5
>  #define MFC_MAX_BUFFERS		32
> @@ -229,16 +221,11 @@ struct s5p_mfc_buf_size {
>  	void *priv;
>  };
>  
> -struct s5p_mfc_buf_align {
> -	unsigned int base;
> -};
> -
>  struct s5p_mfc_variant {
>  	unsigned int version;
>  	unsigned int port_num;
>  	u32 version_bit;
>  	struct s5p_mfc_buf_size *buf_size;
> -	struct s5p_mfc_buf_align *buf_align;
>  	char	*fw_name[MFC_FW_MAX_VERSIONS];
>  	const char	*clk_names[MFC_MAX_CLOCKS];
>  	int		num_clocks;
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h
> index 8e5df041edf7..45c807bf19cc 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h
> @@ -18,7 +18,6 @@
>  int s5p_mfc_release_firmware(struct s5p_mfc_dev *dev);
>  int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev);
>  int s5p_mfc_load_firmware(struct s5p_mfc_dev *dev);
> -int s5p_mfc_reload_firmware(struct s5p_mfc_dev *dev);
>  
>  int s5p_mfc_init_hw(struct s5p_mfc_dev *dev);
>  void s5p_mfc_deinit_hw(struct s5p_mfc_dev *dev);
