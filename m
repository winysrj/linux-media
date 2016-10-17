Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56459 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757888AbcJQNsW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 09:48:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH 26/57] [media] omap3isp: don't break long lines
Date: Mon, 17 Oct 2016 16:48:19 +0300
Message-ID: <1647461.7xIPZGfc2x@avalon>
In-Reply-To: <126092c44821c1987bf798e777ef738616c2d19d.1476475771.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com> <126092c44821c1987bf798e777ef738616c2d19d.1476475771.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

As commented before, please add line breaks after function arguments to keep 
lines within the 80 columns limit where possible.

On Friday 14 Oct 2016 17:20:14 Mauro Carvalho Chehab wrote:
> Due to the 80-cols checkpatch warnings, several strings
> were broken into multiple lines. This is not considered
> a good practice anymore, as it makes harder to grep for
> strings at the source code. So, join those continuation
> lines.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/platform/omap3isp/isp.c         |  3 +--
>  drivers/media/platform/omap3isp/ispccdc.c     |  6 ++---
>  drivers/media/platform/omap3isp/ispcsi2.c     | 11 ++------
>  drivers/media/platform/omap3isp/ispcsiphy.c   |  3 +--
>  drivers/media/platform/omap3isp/isph3a_aewb.c |  6 ++---
>  drivers/media/platform/omap3isp/isph3a_af.c   |  6 ++---
>  drivers/media/platform/omap3isp/ispstat.c     | 36 ++++++++----------------
>  7 files changed, 22 insertions(+), 49 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c index 0321d84addc7..a9d4347bf100
> 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -480,8 +480,7 @@ void omap3isp_hist_dma_done(struct isp_device *isp)
>  	    omap3isp_stat_pcr_busy(&isp->isp_hist)) {
>  		/* Histogram cannot be enabled in this frame anymore */
>  		atomic_set(&isp->isp_hist.buf_err, 1);
> -		dev_dbg(isp->dev, "hist: Out of synchronization with "
> -				  "CCDC. Ignoring next buffer.\n");
> +		dev_dbg(isp->dev, "hist: Out of synchronization with CCDC. 
Ignoring next
> buffer.\n"); }
>  }
> 
> diff --git a/drivers/media/platform/omap3isp/ispccdc.c
> b/drivers/media/platform/omap3isp/ispccdc.c index
> 882310eb45cc..3f8e71c8ea48 100644
> --- a/drivers/media/platform/omap3isp/ispccdc.c
> +++ b/drivers/media/platform/omap3isp/ispccdc.c
> @@ -151,8 +151,7 @@ static int ccdc_lsc_validate_config(struct
> isp_ccdc_device *ccdc, }
> 
>  	if (lsc_cfg->offset & 3) {
> -		dev_dbg(isp->dev, "CCDC: LSC: Offset must be a multiple of "
> -			"4\n");
> +		dev_dbg(isp->dev, "CCDC: LSC: Offset must be a multiple of 
4\n");
>  		return -EINVAL;
>  	}
> 
> @@ -416,8 +415,7 @@ static int ccdc_lsc_config(struct isp_ccdc_device *ccdc,
> return 0;
> 
>  	if (update != (OMAP3ISP_CCDC_CONFIG_LSC | OMAP3ISP_CCDC_TBL_LSC)) {
> -		dev_dbg(to_device(ccdc), "%s: Both LSC configuration and table 
"
> -			"need to be supplied\n", __func__);
> +		dev_dbg(to_device(ccdc), "%s: Both LSC configuration and table 
need to be
> supplied\n", __func__); return -EINVAL;
>  	}
> 
> diff --git a/drivers/media/platform/omap3isp/ispcsi2.c
> b/drivers/media/platform/omap3isp/ispcsi2.c index
> f75a1be29d84..53a7573ed2a5 100644
> --- a/drivers/media/platform/omap3isp/ispcsi2.c
> +++ b/drivers/media/platform/omap3isp/ispcsi2.c
> @@ -753,8 +753,7 @@ void omap3isp_csi2_isr(struct isp_csi2_device *csi2)
>  						 ISPCSI2_PHY_IRQSTATUS);
>  		isp_reg_writel(isp, cpxio1_irqstatus,
>  			       csi2->regs1, ISPCSI2_PHY_IRQSTATUS);
> -		dev_dbg(isp->dev, "CSI2: ComplexIO Error IRQ "
> -			"%x\n", cpxio1_irqstatus);
> +		dev_dbg(isp->dev, "CSI2: ComplexIO Error IRQ %x\n", 
cpxio1_irqstatus);
>  		pipe->error = true;
>  	}
> 
> @@ -763,13 +762,7 @@ void omap3isp_csi2_isr(struct isp_csi2_device *csi2)
>  			      ISPCSI2_IRQSTATUS_ECC_NO_CORRECTION_IRQ |
>  			      ISPCSI2_IRQSTATUS_COMPLEXIO2_ERR_IRQ |
>  			      ISPCSI2_IRQSTATUS_FIFO_OVF_IRQ)) {
> -		dev_dbg(isp->dev, "CSI2 Err:"
> -			" OCP:%d,"
> -			" Short_pack:%d,"
> -			" ECC:%d,"
> -			" CPXIO2:%d,"
> -			" FIFO_OVF:%d,"
> -			"\n",
> +		dev_dbg(isp->dev, "CSI2 Err: OCP:%d, Short_pack:%d, ECC:%d, 
CPXIO2:%d,
> FIFO_OVF:%d,\n", (csi2_irqstatus &
>  			 ISPCSI2_IRQSTATUS_OCP_ERR_IRQ) ? 1 : 0,
>  			(csi2_irqstatus &
> diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c
> b/drivers/media/platform/omap3isp/ispcsiphy.c index
> 495447d66cfd..f67fd2f09f00 100644
> --- a/drivers/media/platform/omap3isp/ispcsiphy.c
> +++ b/drivers/media/platform/omap3isp/ispcsiphy.c
> @@ -267,8 +267,7 @@ int omap3isp_csiphy_acquire(struct isp_csiphy *phy)
>  	int rval;
> 
>  	if (phy->vdd == NULL) {
> -		dev_err(phy->isp->dev, "Power regulator for CSI PHY not "
> -			"available\n");
> +		dev_err(phy->isp->dev, "Power regulator for CSI PHY not 
available\n");
>  		return -ENODEV;
>  	}
> 
> diff --git a/drivers/media/platform/omap3isp/isph3a_aewb.c
> b/drivers/media/platform/omap3isp/isph3a_aewb.c index
> ccaf92f39236..de9bb3ea032e 100644
> --- a/drivers/media/platform/omap3isp/isph3a_aewb.c
> +++ b/drivers/media/platform/omap3isp/isph3a_aewb.c
> @@ -304,8 +304,7 @@ int omap3isp_h3a_aewb_init(struct isp_device *isp)
>  	aewb_recover_cfg = devm_kzalloc(isp->dev, sizeof(*aewb_recover_cfg),
>  					GFP_KERNEL);
>  	if (!aewb_recover_cfg) {
> -		dev_err(aewb->isp->dev, "AEWB: cannot allocate memory for "
> -					"recover configuration.\n");
> +		dev_err(aewb->isp->dev, "AEWB: cannot allocate memory for 
recover
> configuration.\n"); return -ENOMEM;
>  	}
> 
> @@ -321,8 +320,7 @@ int omap3isp_h3a_aewb_init(struct isp_device *isp)
>  	aewb_recover_cfg->subsample_hor_inc = OMAP3ISP_AEWB_MIN_SUB_INC;
> 
>  	if (h3a_aewb_validate_params(aewb, aewb_recover_cfg)) {
> -		dev_err(aewb->isp->dev, "AEWB: recover configuration is "
> -					"invalid.\n");
> +		dev_err(aewb->isp->dev, "AEWB: recover configuration is 
invalid.\n");
>  		return -EINVAL;
>  	}
> 
> diff --git a/drivers/media/platform/omap3isp/isph3a_af.c
> b/drivers/media/platform/omap3isp/isph3a_af.c index
> 92937f7eecef..42607bda8e86 100644
> --- a/drivers/media/platform/omap3isp/isph3a_af.c
> +++ b/drivers/media/platform/omap3isp/isph3a_af.c
> @@ -367,8 +367,7 @@ int omap3isp_h3a_af_init(struct isp_device *isp)
>  	af_recover_cfg = devm_kzalloc(isp->dev, sizeof(*af_recover_cfg),
>  				      GFP_KERNEL);
>  	if (!af_recover_cfg) {
> -		dev_err(af->isp->dev, "AF: cannot allocate memory for recover 
"
> -				      "configuration.\n");
> +		dev_err(af->isp->dev, "AF: cannot allocate memory for recover
> configuration.\n"); return -ENOMEM;
>  	}
> 
> @@ -379,8 +378,7 @@ int omap3isp_h3a_af_init(struct isp_device *isp)
>  	af_recover_cfg->paxel.v_cnt = OMAP3ISP_AF_PAXEL_VERTICAL_COUNT_MIN;
>  	af_recover_cfg->paxel.line_inc = OMAP3ISP_AF_PAXEL_INCREMENT_MIN;
>  	if (h3a_af_validate_params(af, af_recover_cfg)) {
> -		dev_err(af->isp->dev, "AF: recover configuration is "
> -				      "invalid.\n");
> +		dev_err(af->isp->dev, "AF: recover configuration is invalid.
\n");
>  		return -EINVAL;
>  	}
> 
> diff --git a/drivers/media/platform/omap3isp/ispstat.c
> b/drivers/media/platform/omap3isp/ispstat.c index
> 1b9217d3b1b6..220a9224271b 100644
> --- a/drivers/media/platform/omap3isp/ispstat.c
> +++ b/drivers/media/platform/omap3isp/ispstat.c
> @@ -113,8 +113,7 @@ static int isp_stat_buf_check_magic(struct ispstat
> *stat, ret = 0;
> 
>  	if (ret) {
> -		dev_dbg(stat->isp->dev, "%s: beginning magic check does not "
> -					"match.\n", stat->subdev.name);
> +		dev_dbg(stat->isp->dev, "%s: beginning magic check does not 
match.\n",
> stat->subdev.name); return ret;
>  	}
> 
> @@ -122,8 +121,7 @@ static int isp_stat_buf_check_magic(struct ispstat
> *stat, for (w = buf->virt_addr + buf_size, end = w + MAGIC_SIZE;
>  	     w < end; w++) {
>  		if (unlikely(*w != MAGIC_NUM)) {
> -			dev_dbg(stat->isp->dev, "%s: ending magic check does "
> -				"not match.\n", stat->subdev.name);
> +			dev_dbg(stat->isp->dev, "%s: ending magic check does 
not match.\n",
> stat->subdev.name); return -EINVAL;
>  		}
>  	}
> @@ -256,8 +254,7 @@ static void isp_stat_buf_next(struct ispstat *stat)
>  {
>  	if (unlikely(stat->active_buf))
>  		/* Overwriting unused active buffer */
> -		dev_dbg(stat->isp->dev, "%s: new buffer requested without "
> -					"queuing active one.\n",
> +		dev_dbg(stat->isp->dev, "%s: new buffer requested without 
queuing active
> one.\n", stat->subdev.name);
>  	else
>  		stat->active_buf = isp_stat_buf_find_oldest_or_empty(stat);
> @@ -292,8 +289,7 @@ static struct ispstat_buffer *isp_stat_buf_get(struct
> ispstat *stat, return ERR_PTR(-EBUSY);
>  		}
>  		if (isp_stat_buf_check_magic(stat, buf)) {
> -			dev_dbg(stat->isp->dev, "%s: current buffer has "
> -				"corrupted data\n.", stat->subdev.name);
> +			dev_dbg(stat->isp->dev, "%s: current buffer has 
corrupted data\n.",
> stat->subdev.name); /* Mark empty because it doesn't have valid data. */
>  			buf->empty = 1;
>  		} else {
> @@ -307,8 +303,7 @@ static struct ispstat_buffer *isp_stat_buf_get(struct
> ispstat *stat, spin_unlock_irqrestore(&stat->isp->stat_lock, flags);
> 
>  	if (buf->buf_size > data->buf_size) {
> -		dev_warn(stat->isp->dev, "%s: userspace's buffer size is "
> -					 "not enough.\n", stat->subdev.name);
> +		dev_warn(stat->isp->dev, "%s: userspace's buffer size is not 
enough.\n",
> stat->subdev.name); isp_stat_buf_release(stat);
>  		return ERR_PTR(-EINVAL);
>  	}
> @@ -531,20 +526,17 @@ int omap3isp_stat_config(struct ispstat *stat, void
> *new_conf)
> 
>  	mutex_lock(&stat->ioctl_lock);
> 
> -	dev_dbg(stat->isp->dev, "%s: configuring module with buffer "
> -		"size=0x%08lx\n", stat->subdev.name, (unsigned long)buf_size);
> +	dev_dbg(stat->isp->dev, "%s: configuring module with buffer
> size=0x%08lx\n", stat->subdev.name, (unsigned long)buf_size);
> 
>  	ret = stat->ops->validate_params(stat, new_conf);
>  	if (ret) {
>  		mutex_unlock(&stat->ioctl_lock);
> -		dev_dbg(stat->isp->dev, "%s: configuration values are "
> -					"invalid.\n", stat->subdev.name);
> +		dev_dbg(stat->isp->dev, "%s: configuration values are invalid.
\n",
> stat->subdev.name); return ret;
>  	}
> 
>  	if (buf_size != user_cfg->buf_size)
> -		dev_dbg(stat->isp->dev, "%s: driver has corrected buffer size 
"
> -			"request to 0x%08lx\n", stat->subdev.name,
> +		dev_dbg(stat->isp->dev, "%s: driver has corrected buffer size 
request to
> 0x%08lx\n", stat->subdev.name, (unsigned long)user_cfg->buf_size);
> 
>  	/*
> @@ -595,8 +587,7 @@ int omap3isp_stat_config(struct ispstat *stat, void
> *new_conf)
> 
>  	/* Module has a valid configuration. */
>  	stat->configured = 1;
> -	dev_dbg(stat->isp->dev, "%s: module has been successfully "
> -		"configured.\n", stat->subdev.name);
> +	dev_dbg(stat->isp->dev, "%s: module has been successfully configured.
\n",
> stat->subdev.name);
> 
>  	mutex_unlock(&stat->ioctl_lock);
> 
> @@ -762,8 +753,7 @@ int omap3isp_stat_enable(struct ispstat *stat, u8
> enable) if (!stat->configured && enable) {
>  		spin_unlock_irqrestore(&stat->isp->stat_lock, irqflags);
>  		mutex_unlock(&stat->ioctl_lock);
> -		dev_dbg(stat->isp->dev, "%s: cannot enable module as it's "
> -			"never been successfully configured so far.\n",
> +		dev_dbg(stat->isp->dev, "%s: cannot enable module as it's 
never been
> successfully configured so far.\n", stat->subdev.name);
>  		return -EINVAL;
>  	}
> @@ -859,8 +849,7 @@ static void __stat_isr(struct ispstat *stat, int
> from_dma) if (stat->state == ISPSTAT_ENABLED) {
>  			spin_unlock_irqrestore(&stat->isp->stat_lock, 
irqflags);
>  			dev_err(stat->isp->dev,
> -				"%s: interrupt occurred when module was still 
"
> -				"processing a buffer.\n", stat->subdev.name);
> +				"%s: interrupt occurred when module was still 
processing a buffer.\n",
> stat->subdev.name); ret = STAT_NO_BUF;
>  			goto out;
>  		} else {
> @@ -964,8 +953,7 @@ static void __stat_isr(struct ispstat *stat, int
> from_dma) atomic_set(&stat->buf_err, 1);
> 
>  		ret = STAT_NO_BUF;
> -		dev_dbg(stat->isp->dev, "%s: cannot process buffer, "
> -					"device is busy.\n", stat-
>subdev.name);
> +		dev_dbg(stat->isp->dev, "%s: cannot process buffer, device is 
busy.\n",
> stat->subdev.name); }
> 
>  out:

-- 
Regards,

Laurent Pinchart

