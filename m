Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:56629 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab3AAQFw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jan 2013 11:05:52 -0500
Date: Tue, 1 Jan 2013 17:05:46 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Albert Wang <twang13@marvell.com>
cc: corbet@lwn.net, linux-media@vger.kernel.org,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [PATCH V3 03/15] [media] marvell-ccic: add clock tree support
 for marvell-ccic driver
In-Reply-To: <1355565484-15791-4-git-send-email-twang13@marvell.com>
Message-ID: <Pine.LNX.4.64.1301011633530.31619@axis700.grange>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
 <1355565484-15791-4-git-send-email-twang13@marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 15 Dec 2012, Albert Wang wrote:

> From: Libin Yang <lbyang@marvell.com>
> 
> This patch adds the clock tree support for marvell-ccic.
> 
> Each board may require different clk enabling sequence.
> Developer need add the clk_name in correct sequence in board driver
> to use this feature.
> 
> Signed-off-by: Libin Yang <lbyang@marvell.com>
> Signed-off-by: Albert Wang <twang13@marvell.com>
> ---
>  drivers/media/platform/marvell-ccic/mcam-core.h  |    4 ++
>  drivers/media/platform/marvell-ccic/mmp-driver.c |   57 +++++++++++++++++++++-
>  include/media/mmp-camera.h                       |    5 ++
>  3 files changed, 65 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
> index ca63010..86e634e 100755
> --- a/drivers/media/platform/marvell-ccic/mcam-core.h
> +++ b/drivers/media/platform/marvell-ccic/mcam-core.h
> @@ -88,6 +88,7 @@ struct mcam_frame_state {
>   *          the dev_lock spinlock; they are marked as such by comments.
>   *          dev_lock is also required for access to device registers.
>   */
> +#define NR_MCAM_CLK 4
>  struct mcam_camera {
>  	/*
>  	 * These fields should be set by the platform code prior to
> @@ -109,6 +110,9 @@ struct mcam_camera {
>  	int lane;			/* lane number */
>  
>  	struct clk *pll1;
> +	/* clock tree support */
> +	struct clk *clk[NR_MCAM_CLK];
> +	int clk_num;
>  
>  	/*
>  	 * Callbacks from the core to the platform code.
> diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
> index 603fa0a..2c4dce3 100755
> --- a/drivers/media/platform/marvell-ccic/mmp-driver.c
> +++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
> @@ -104,6 +104,23 @@ static struct mmp_camera *mmpcam_find_device(struct platform_device *pdev)
>  #define REG_CCIC_DCGCR		0x28	/* CCIC dyn clock gate ctrl reg */
>  #define REG_CCIC_CRCR		0x50	/* CCIC clk reset ctrl reg	*/
>  
> +static void mcam_clk_set(struct mcam_camera *mcam, int on)

Personally, I would also make two functions out of this - "on" and "off," 
but that's a matter of taste, perhaps.

> +{
> +	unsigned int i;
> +
> +	if (on) {
> +		for (i = 0; i < mcam->clk_num; i++) {
> +			if (mcam->clk[i])
> +				clk_enable(mcam->clk[i]);
> +		}
> +	} else {
> +		for (i = mcam->clk_num; i > 0; i--) {
> +			if (mcam->clk[i - 1])
> +				clk_disable(mcam->clk[i - 1]);
> +		}
> +	}
> +}
> +
>  /*
>   * Power control.
>   */
> @@ -134,6 +151,8 @@ static void mmpcam_power_up(struct mcam_camera *mcam)
>  	mdelay(5);
>  	gpio_set_value(pdata->sensor_reset_gpio, 1); /* reset is active low */
>  	mdelay(5);
> +
> +	mcam_clk_set(mcam, 1);
>  }
>  
>  static void mmpcam_power_down(struct mcam_camera *mcam)
> @@ -151,6 +170,8 @@ static void mmpcam_power_down(struct mcam_camera *mcam)
>  	pdata = cam->pdev->dev.platform_data;
>  	gpio_set_value(pdata->sensor_power_gpio, 0);
>  	gpio_set_value(pdata->sensor_reset_gpio, 0);
> +
> +	mcam_clk_set(mcam, 0);
>  }
>  
>  /*
> @@ -202,7 +223,7 @@ void mmpcam_calc_dphy(struct mcam_camera *mcam)
>  	 * pll1 will never be changed, it is a fixed value
>  	 */
>  
> -	if (IS_ERR(mcam->pll1))
> +	if (IS_ERR_OR_NULL(mcam->pll1))

Why are you changing this? If this really were needed, you should do this 
already in the previous patch, where you add these lines. But I don't 
think this is a good idea, don't think Russell would like this :-) NULL is 
a valid clock. Only a negative error is a failure. In fact, if you like, 
you could initialise .pll1 to ERR_PTR(-EINVAL) in your previous patch in 
mmpcam_probe().

>  		return;
>  
>  	tx_clk_esc = clk_get_rate(mcam->pll1) / 1000000 / 12;
> @@ -229,6 +250,35 @@ static irqreturn_t mmpcam_irq(int irq, void *data)
>  	return IRQ_RETVAL(handled);
>  }
>  
> +static void mcam_init_clk(struct mcam_camera *mcam,
> +			struct mmp_camera_platform_data *pdata, int init)

I don't think this "int init" makes sense. Please, remove the parameter 
and you actually don't need the de-initialisation, no reason to set 
num_clk = 0 before freeing memory.

> +{
> +	unsigned int i;
> +
> +	if (NR_MCAM_CLK < pdata->clk_num) {
> +		dev_err(mcam->dev, "Too many mcam clocks defined\n");
> +		mcam->clk_num = 0;
> +		return;
> +	}
> +
> +	if (init) {
> +		for (i = 0; i < pdata->clk_num; i++) {
> +			if (pdata->clk_name[i] != NULL) {
> +				mcam->clk[i] = devm_clk_get(mcam->dev,
> +						pdata->clk_name[i]);

Sorry, no. Passing clock names in platform data doesn't look right to me. 
Clock names are a property of the consumer device, not of clock supplier. 
Also, your platform tells you to get clk_num clocks, you fail to get one 
of them, you don't continue trying the rest and just return with no error. 
This seems strange, usually a failure to get clocks, that the platform 
tells you to get, is fatal.

> +				if (IS_ERR(mcam->clk[i])) {
> +					dev_err(mcam->dev,
> +						"Could not get clk: %s\n",
> +						pdata->clk_name[i]);
> +					mcam->clk_num = 0;
> +					return;
> +				}
> +			}
> +		}
> +		mcam->clk_num = pdata->clk_num;
> +	} else
> +		mcam->clk_num = 0;
> +}
>  
>  static int mmpcam_probe(struct platform_device *pdev)
>  {

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
