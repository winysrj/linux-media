Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54265 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755223AbbCLX5F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2015 19:57:05 -0400
Date: Fri, 13 Mar 2015 01:56:32 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] media: omap3isp: hist: Move histogram DMA to DMA engine
Message-ID: <20150312235632.GQ11954@valkosipuli.retiisi.org.uk>
References: <1425850675-32266-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1425850675-32266-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Sun, Mar 08, 2015 at 11:37:55PM +0200, Laurent Pinchart wrote:
...
> @@ -198,24 +177,58 @@ static void hist_dma_cb(int lch, u16 ch_status, void *data)
>  static int hist_buf_dma(struct ispstat *hist)
>  {
>  	dma_addr_t dma_addr = hist->active_buf->dma_addr;
> +	struct dma_async_tx_descriptor *tx;
> +	struct dma_slave_config cfg;
> +	dma_cookie_t cookie;
> +	int ret;
>  
>  	if (unlikely(!dma_addr)) {
>  		dev_dbg(hist->isp->dev, "hist: invalid DMA buffer address\n");
> -		hist_reset_mem(hist);
> -		return STAT_NO_BUF;
> +		goto error;
>  	}
>  
>  	isp_reg_writel(hist->isp, 0, OMAP3_ISP_IOMEM_HIST, ISPHIST_ADDR);
>  	isp_reg_set(hist->isp, OMAP3_ISP_IOMEM_HIST, ISPHIST_CNT,
>  		    ISPHIST_CNT_CLEAR);
>  	omap3isp_flush(hist->isp);
> -	hist->dma_config.dst_start = dma_addr;
> -	hist->dma_config.elem_count = hist->buf_size / sizeof(u32);
> -	omap_set_dma_params(hist->dma_ch, &hist->dma_config);
>  
> -	omap_start_dma(hist->dma_ch);
> +	memset(&cfg, 0, sizeof(cfg));
> +	cfg.src_addr = hist->isp->mmio_base_phys[OMAP3_ISP_IOMEM_HIST]
> +		     + ISPHIST_DATA;
> +	cfg.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
> +	cfg.src_maxburst = hist->buf_size / 4;

How about initialising the struct when you declare it instead? That might be
a matter of opinion though, but I think I prefer that. Up to you.

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

> +	ret = dmaengine_slave_config(hist->dma_ch, &cfg);
> +	if (ret < 0) {
> +		dev_dbg(hist->isp->dev,
> +			"hist: DMA slave configuration failed\n");
> +		goto error;
> +	}
> +
> +	tx = dmaengine_prep_slave_single(hist->dma_ch, dma_addr,
> +					 hist->buf_size, DMA_DEV_TO_MEM,
> +					 DMA_CTRL_ACK);
> +	if (tx == NULL) {
> +		dev_dbg(hist->isp->dev,
> +			"hist: DMA slave preparation failed\n");
> +		goto error;
> +	}
> +
> +	tx->callback = hist_dma_cb;
> +	tx->callback_param = hist;
> +	cookie = tx->tx_submit(tx);
> +	if (dma_submit_error(cookie)) {
> +		dev_dbg(hist->isp->dev, "hist: DMA submission failed\n");
> +		goto error;
> +	}
> +
> +	dma_async_issue_pending(hist->dma_ch);
>  
>  	return STAT_BUF_WAITING_DMA;
> +
> +error:
> +	hist_reset_mem(hist);
> +	return STAT_NO_BUF;
>  }
>  
>  static int hist_buf_pio(struct ispstat *hist)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
