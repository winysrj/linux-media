Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:53378 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089Ab2LPPyy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 10:54:54 -0500
Date: Sun, 16 Dec 2012 08:54:49 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Albert Wang <twang13@marvell.com>
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [PATCH V3 02/15] [media] marvell-ccic: add MIPI support for
 marvell-ccic driver
Message-ID: <20121216085449.2a3807f6@hpe.lwn.net>
In-Reply-To: <1355565484-15791-3-git-send-email-twang13@marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
	<1355565484-15791-3-git-send-email-twang13@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 15 Dec 2012 17:57:51 +0800
Albert Wang <twang13@marvell.com> wrote:

> From: Libin Yang <lbyang@marvell.com>
> 
> This patch adds the MIPI support for marvell-ccic.
> Board driver should determine whether using MIPI or not.

There are limits to how deeply I can review this, since I know little about
the MIPI mode and don't have any hardware that uses it.  So I'm assuming
that it all works :)  My comments are on a different level.

> +static int mcam_config_mipi(struct mcam_camera *mcam, int enable)
> +{
> +	if (mcam->bus_type == V4L2_MBUS_CSI2 && enable) {
> +		/* Using MIPI mode and enable MIPI */
> +		cam_dbg(mcam, "camera: DPHY3=0x%x, DPHY5=0x%x, DPHY6=0x%x\n",
> +			mcam->dphy[0], mcam->dphy[1], mcam->dphy[2]);
> +		mcam_reg_write(mcam, REG_CSI2_DPHY3, mcam->dphy[0]);
> +		mcam_reg_write(mcam, REG_CSI2_DPHY6, mcam->dphy[2]);
> +		mcam_reg_write(mcam, REG_CSI2_DPHY5, mcam->dphy[1]);

Is there a reason you're writing them in something other than direct
increasing order?  If so, a comment saying why might help somebody in ghe future.

> +		if (mcam->mipi_enabled == 0) {
> +			/*
> +			 * 0x41 actives 1 lane
> +			 * 0x43 actives 2 lanes
> +			 * 0x47 actives 4 lanes
> +			 * There is no 3 lanes case
> +			 */
> +			switch (mcam->lane) {
> +			case 1:
> +				mcam_reg_write(mcam, REG_CSI2_CTRL0, 0x41);
> +				break;
> +			case 2:
> +				mcam_reg_write(mcam, REG_CSI2_CTRL0, 0x43);
> +				break;
> +			case 4:
> +				mcam_reg_write(mcam, REG_CSI2_CTRL0, 0x47);
> +				break;

Can we have defined symbols rather than magic constants here?

> @@ -656,6 +701,15 @@ static void mcam_ctlr_image(struct mcam_camera *cam)
>  	 */
>  	mcam_reg_write_mask(cam, REG_CTRL0, C0_SIF_HVSYNC,
>  			C0_SIFM_MASK);
> +
> +	/*
> +	 * This field controls the generation of EOF(DVP only)
> +	 */
> +	if (cam->bus_type != V4L2_MBUS_CSI2) {
> +		mcam_reg_set_bit(cam, REG_CTRL0,
> +				C0_EOF_VSYNC | C0_VEDGE_CTRL);
> +		mcam_reg_write(cam, REG_CTRL3, 0x4);

Again, how about a symbol, or at least an explanation of what 0x4 means?

> +	}
>  }
>  
[...]
> @@ -1551,6 +1615,11 @@ static int mcam_v4l_open(struct file *filp)
>  		mcam_set_config_needed(cam, 1);
>  	}
>  	(cam->users)++;
> +	cam->pll1 = devm_clk_get(cam->dev, "pll1");
> +	if (IS_ERR(cam->pll1)) {
> +		cam_err(cam, "Could not get pll1 clock\n");
> +		ret = PTR_ERR(cam->pll1);
> +	}

This looks like it gets the clock in all cases?  Is that right?

>  #define REG_IMGPITCH	0x24	/* Image pitch register */
> @@ -292,7 +311,9 @@ int mccic_resume(struct mcam_camera *cam);
>  #define	  C0_DOWNSCALE	  0x08000000	/* Enable downscaler */
>  #define	  C0_SIFM_MASK	  0xc0000000	/* SIF mode bits */
>  #define	  C0_SIF_HVSYNC	  0x00000000	/* Use H/VSYNC */
> -#define	  CO_SOF_NOSYNC	  0x40000000	/* Use inband active signaling */
> +#define	  C0_SOF_NOSYNC	  0x40000000	/* Use inband active signaling */
> +#define	  C0_EOF_VSYNC	  0x00400000	/* Generate EOF by VSYNC */
> +#define	  C0_VEDGE_CTRL   0x00800000	/* Detect falling edge of VSYNC */

Being the retentive sort of guy I am, I try to keep definitions like these
in numerical order.  Any chance you could humor me and maintain that?

>  /* Bits below C1_444ALPHA are not present in Cafe */
>  #define REG_CTRL1	0x40	/* Control 1 */
> @@ -308,6 +329,7 @@ int mccic_resume(struct mcam_camera *cam);
>  #define	  C1_TWOBUFS	  0x08000000	/* Use only two DMA buffers */
>  #define	  C1_PWRDWN	  0x10000000	/* Power down */
>  
> +#define REG_CTRL3	0x1ec	/* CCIC parallel mode */
>  #define REG_CLKCTRL	0x88	/* Clock control */
>  #define	  CLK_DIV_MASK	  0x0000ffff	/* Upper bits RW "reserved" */

Here, too, I'd rather keep them in order if possible.

> +/*
> + * calc the dphy register values
> + * There are three dphy registers being used.
> + * dphy[0] can be set with a default value
> + * or be calculated dynamically
> + */
> +void mmpcam_calc_dphy(struct mcam_camera *mcam)
> +{
> +	struct mmp_camera *cam = mcam_to_cam(mcam);
> +	struct mmp_camera_platform_data *pdata = cam->pdev->dev.platform_data;
> +	struct device *dev = &cam->pdev->dev;
> +	unsigned long tx_clk_esc;
> +
> +	/*
> +	 * If dphy[0] is calculated dynamically,
> +	 * pdata->lane_clk should be already set
> +	 * either in the board driver statically
> +	 * or in the sensor driver dynamically.
> +	 */
> +	switch (pdata->dphy3_algo) {
> +	case 1:
> +		/*
> +		 * dphy3_algo == 1
> +		 * Calculate CSI2_DPHY3 algo for PXA910
> +		 */
> +		pdata->dphy[0] = ((1 + pdata->lane_clk * 80 / 1000) & 0xff) << 8
> +			| (1 + pdata->lane_clk * 35 / 1000);
> +		break;

What are the chances of getting a comment or some other reference so that a
naive reader like me has a chance of understanding what this calculation
does?  Where do all those constants come from?

> +	case 2:
> +		/*
> +		 * dphy3_algo == 2
> +		 * Calculate CSI2_DPHY3 algo for PXA2128
> +		 */
> +		pdata->dphy[0] =
> +			((2 + pdata->lane_clk * 110 / 1000) & 0xff) << 8
> +			| (1 + pdata->lane_clk * 35 / 1000);
> +		break;
> +	default:
> +		/*
> +		 * dphy3_algo == 0
> +		 * Use default CSI2_DPHY3 value for PXA688/PXA988
> +		 */
> +		dev_dbg(dev, "camera: use the default CSI2_DPHY3 value\n");
> +	}
> +
> +	/*
> +	 * pll1 will never be changed, it is a fixed value
> +	 */
> +
> +	if (IS_ERR(mcam->pll1))
> +		return;
> +
> +	tx_clk_esc = clk_get_rate(mcam->pll1) / 1000000 / 12;

Being who I am (see "retentive" above) I'll always parenthesize an
expression like this to make the intended order of operations explicit.

Mostly low-level comments, it's looking pretty good.

jon
