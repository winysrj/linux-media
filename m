Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34266 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750766AbeBHHiP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Feb 2018 02:38:15 -0500
Date: Thu, 8 Feb 2018 09:38:11 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        tfiga@chromium.org, tian.shu.qiu@intel.com,
        jian.xu.zheng@intel.com, rajmohan.mani@intel.com
Subject: Re: [PATCH] media: intel-ipu3: cio2: Synchronize irqs at
 stop_streaming
Message-ID: <20180208073811.ie5c2x6o3vbxvxqi@valkosipuli.retiisi.org.uk>
References: <1518043670-4602-1-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1518043670-4602-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Wed, Feb 07, 2018 at 02:47:50PM -0800, Yong Zhi wrote:
> This is to avoid pending interrupts to be handled during
> stream off, in which case, the ready buffer will be removed
> from buffer list, thus not all buffers can be returned to VB2
> as expected. Disable CIO2 irq at cio2_hw_exit() so no new
> interrupts are generated.
> 
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
> ---
>  drivers/media/pci/intel/ipu3/ipu3-cio2.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> index 725973f..8d75146 100644
> --- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> +++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> @@ -518,6 +518,8 @@ static void cio2_hw_exit(struct cio2_device *cio2, struct cio2_queue *q)
>  	unsigned int i, maxloops = 1000;
>  
>  	/* Disable CSI receiver and MIPI backend devices */
> +	writel(0, q->csi_rx_base + CIO2_REG_IRQCTRL_MASK);
> +	writel(0, q->csi_rx_base + CIO2_REG_IRQCTRL_ENABLE);
>  	writel(0, q->csi_rx_base + CIO2_REG_CSIRX_ENABLE);
>  	writel(0, q->csi_rx_base + CIO2_REG_MIPIBE_ENABLE);
>  
> @@ -1027,6 +1029,7 @@ static void cio2_vb2_stop_streaming(struct vb2_queue *vq)
>  			"failed to stop sensor streaming\n");
>  
>  	cio2_hw_exit(cio2, q);
> +	synchronize_irq(cio2->pci_dev->irq);

Shouldn't this be put in cio2_hw_exit(), which is called from multiple
locations? Presumably the same issue exists there, too.

>  	cio2_vb2_return_all_buffers(q, VB2_BUF_STATE_ERROR);
>  	media_pipeline_stop(&q->vdev.entity);
>  	pm_runtime_put(&cio2->pci_dev->dev);

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
