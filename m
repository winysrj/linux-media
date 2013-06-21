Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:60310 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423203Ab3FUQ7s (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 12:59:48 -0400
Date: Fri, 21 Jun 2013 10:59:41 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: <lbyang@marvell.com>
Cc: <g.liakhovetski@gmx.de>, <mchehab@redhat.com>,
	<linux-media@vger.kernel.org>, <albert.v.wang@gmail.com>
Subject: Re: [PATCH 1/7] marvell-ccic: add MIPI support for marvell-ccic
 driver
Message-ID: <20130621105941.44086d1b@lwn.net>
In-Reply-To: <1370324380.26072.19.camel@younglee-desktop>
References: <1370324380.26072.19.camel@younglee-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Better late than never, I hope...in response to Hans's poke, I'm going
to try to do a quick review.  I am allegedly in vacation, so this may
not be as thorough as we might like...

On Tue, 4 Jun 2013 13:39:40 +0800
lbyang <lbyang@marvell.com> wrote:

> From: Libin Yang <lbyang@marvell.com>
> 
> This patch adds the MIPI support for marvell-ccic.
> Board driver should determine whether using MIPI or not.
> 
> Signed-off-by: Albert Wang <twang13@marvell.com>
> Signed-off-by: Libin Yang <lbyang@marvell.com>
> ---
>  drivers/media/platform/marvell-ccic/cafe-driver.c |    4 +-
>  drivers/media/platform/marvell-ccic/mcam-core.c   |   75 +++++++++++-
>  drivers/media/platform/marvell-ccic/mcam-core.h   |   32 +++++-
>  drivers/media/platform/marvell-ccic/mmp-driver.c  |  126 ++++++++++++++++++++-
>  include/media/mmp-camera.h                        |   19 ++++
>  5 files changed, 245 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/platform/marvell-ccic/cafe-driver.c b/drivers/media/platform/marvell-ccic/cafe-driver.c
> index d030f9b..68e82fb 100644
> --- a/drivers/media/platform/marvell-ccic/cafe-driver.c
> +++ b/drivers/media/platform/marvell-ccic/cafe-driver.c
> @@ -400,7 +400,7 @@ static void cafe_ctlr_init(struct mcam_camera *mcam)
>  }
>  
>  
> -static void cafe_ctlr_power_up(struct mcam_camera *mcam)
> +static int cafe_ctlr_power_up(struct mcam_camera *mcam)
>  {
>  	/*
>  	 * Part one of the sensor dance: turn the global
> @@ -415,6 +415,8 @@ static void cafe_ctlr_power_up(struct mcam_camera *mcam)
>  	 */
>  	mcam_reg_write(mcam, REG_GPR, GPR_C1EN|GPR_C0EN); /* pwr up, reset */
>  	mcam_reg_write(mcam, REG_GPR, GPR_C1EN|GPR_C0EN|GPR_C0);
> +
> +	return 0;
>  }

Curious: why add the return value when it never changes?  Do I assume that
some future patch adds some complexity here?  Not opposed to this, but it
seems like the wrong time.

>  static void cafe_ctlr_power_down(struct mcam_camera *mcam)
> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
> index 64ab91e..bb3de1f 100644
> --- a/drivers/media/platform/marvell-ccic/mcam-core.c
> +++ b/drivers/media/platform/marvell-ccic/mcam-core.c
> @@ -19,6 +19,7 @@
>  #include <linux/delay.h>
>  #include <linux/vmalloc.h>
>  #include <linux/io.h>
> +#include <linux/clk.h>
>  #include <linux/videodev2.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ioctl.h>
> @@ -254,6 +255,45 @@ static void mcam_ctlr_stop(struct mcam_camera *cam)
>  	mcam_reg_clear_bit(cam, REG_CTRL0, C0_ENABLE);
>  }
>  
> +static int mcam_config_mipi(struct mcam_camera *mcam, bool enable)
> +{
> +	if (enable) {
> +		/* Using MIPI mode and enable MIPI */
> +		cam_dbg(mcam, "camera: DPHY3=0x%x, DPHY5=0x%x, DPHY6=0x%x\n",
> +			mcam->dphy[0], mcam->dphy[1], mcam->dphy[2]);
> +		mcam_reg_write(mcam, REG_CSI2_DPHY3, mcam->dphy[0]);
> +		mcam_reg_write(mcam, REG_CSI2_DPHY5, mcam->dphy[1]);
> +		mcam_reg_write(mcam, REG_CSI2_DPHY6, mcam->dphy[2]);
> +
> +		if (!mcam->mipi_enabled) {
> +			if (mcam->lane > 4 || mcam->lane <= 0) {
> +				cam_warn(mcam, "lane number error\n");
> +				mcam->lane = 1;	/* set the default value */
> +			}
> +			/*
> +			 * 0x41 actives 1 lane
> +			 * 0x43 actives 2 lanes
> +			 * 0x45 actives 3 lanes (never happen)
> +			 * 0x47 actives 4 lanes
> +			 */
> +			mcam_reg_write(mcam, REG_CSI2_CTRL0,
> +				CSI2_C0_MIPI_EN | CSI2_C0_ACT_LANE(mcam->lane));
> +			mcam_reg_write(mcam, REG_CLKCTRL,
> +				(mcam->mclk_src << 29) | mcam->mclk_div);
> +
> +			mcam->mipi_enabled = true;
> +		}
> +	} else {
> +		/* Using Parallel mode or disable MIPI */
> +		mcam_reg_write(mcam, REG_CSI2_CTRL0, 0x0);
> +		mcam_reg_write(mcam, REG_CSI2_DPHY3, 0x0);
> +		mcam_reg_write(mcam, REG_CSI2_DPHY5, 0x0);
> +		mcam_reg_write(mcam, REG_CSI2_DPHY6, 0x0);
> +		mcam->mipi_enabled = false;
> +	}
> +	return 0;
> +}

I think I said this before...having separate enable/disable functions seems
better to me than a multiplexed function with an overall flag.  Is there a
reason it's done this way?

[...]
>  /*
>   * Power up and down.
>   */
> -static void mcam_ctlr_power_up(struct mcam_camera *cam)
> +static int mcam_ctlr_power_up(struct mcam_camera *cam)
>  {
>  	unsigned long flags;
> +	int ret;
>  
>  	spin_lock_irqsave(&cam->dev_lock, flags);
> -	cam->plat_power_up(cam);
> +	ret = cam->plat_power_up(cam);
> +	if (ret)
> +		return ret;

You just returned with the lock held - that's a big mistake.

>  	mcam_reg_clear_bit(cam, REG_CTRL1, C1_PWRDWN);
>  	spin_unlock_irqrestore(&cam->dev_lock, flags);
>  	msleep(5); /* Just to be sure */
> +	return 0;
>  }
>  
>  static void mcam_ctlr_power_down(struct mcam_camera *cam)
> @@ -887,6 +938,16 @@ static int mcam_read_setup(struct mcam_camera *cam)
>  	spin_lock_irqsave(&cam->dev_lock, flags);
>  	clear_bit(CF_DMA_ACTIVE, &cam->flags);
>  	mcam_reset_buffers(cam);
> +	/*
> +	 * Update CSI2_DPHY value
> +	 */
> +	if (cam->calc_dphy)
> +		cam->calc_dphy(cam);
> +	cam_dbg(cam, "camera: DPHY sets: dphy3=0x%x, dphy5=0x%x, dphy6=0x%x\n",
> +			cam->dphy[0], cam->dphy[1], cam->dphy[2]);
> +	ret = mcam_config_mipi(cam, cam->bus_type == V4L2_MBUS_CSI2);
> +	if (ret < 0)
> +		return ret;

Once again - you're holding a spinlock here.

[...]

> @@ -1816,7 +1881,9 @@ int mccic_resume(struct mcam_camera *cam)
>  
>  	mutex_lock(&cam->s_mutex);
>  	if (cam->users > 0) {
> -		mcam_ctlr_power_up(cam);
> +		ret = mcam_ctlr_power_up(cam);
> +		if (ret)
> +			return ret;

...and here you're holding a mutex.  There's a reason so much kernel code
uses the "goto out" pattern; you really have to be careful about returning
from the middle of a function.

>  		__mcam_cam_reset(cam);
>  	} else {
>  		mcam_ctlr_power_down(cam);
> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
> index 01dec9e..be271b3 100644
> --- a/drivers/media/platform/marvell-ccic/mcam-core.h
> +++ b/drivers/media/platform/marvell-ccic/mcam-core.h
> @@ -102,11 +102,23 @@ struct mcam_camera {
>  	short int clock_speed;	/* Sensor clock speed, default 30 */
>  	short int use_smbus;	/* SMBUS or straight I2c? */
>  	enum mcam_buffer_mode buffer_mode;
> +
> +	int mclk_min;
> +	int mclk_src;
> +	int mclk_div;
> +
> +	enum v4l2_mbus_type bus_type;
> +	/* MIPI support */
> +	int *dphy;
> +	bool mipi_enabled;
> +	int lane;			/* lane number */

Can we document these new fields a bit better?

>  	/*
>  	 * Callbacks from the core to the platform code.
>  	 */
> -	void (*plat_power_up) (struct mcam_camera *cam);
> +	int (*plat_power_up) (struct mcam_camera *cam);
>  	void (*plat_power_down) (struct mcam_camera *cam);
> +	void (*calc_dphy) (struct mcam_camera *cam);
>  
>  	/*
>  	 * Everything below here is private to the mcam core and
> @@ -220,6 +232,17 @@ int mccic_resume(struct mcam_camera *cam);
>  #define REG_Y0BAR	0x00
>  #define REG_Y1BAR	0x04
>  #define REG_Y2BAR	0x08
> +
> +/*
> + * register definitions for MIPI support
> + */
> +#define REG_CSI2_CTRL0	0x100
> +#define   CSI2_C0_MIPI_EN (0x1 << 0)
> +#define   CSI2_C0_ACT_LANE(n) ((n-1) << 1)
> +#define REG_CSI2_DPHY3	0x12c
> +#define REG_CSI2_DPHY5	0x134
> +#define REG_CSI2_DPHY6	0x138
> +
>  /* ... */
>  
>  #define REG_IMGPITCH	0x24	/* Image pitch register */
> @@ -288,13 +311,16 @@ int mccic_resume(struct mcam_camera *cam);
>  #define	  C0_YUVE_XUVY	  0x00020000	/* 420: .UVY		*/
>  #define	  C0_YUVE_XVUY	  0x00030000	/* 420: .VUY		*/
>  /* Bayer bits 18,19 if needed */
> +#define	  C0_EOF_VSYNC	  0x00400000	/* Generate EOF by VSYNC */
> +#define	  C0_VEDGE_CTRL   0x00800000	/* Detect falling edge of VSYNC */
>  #define	  C0_HPOL_LOW	  0x01000000	/* HSYNC polarity active low */
>  #define	  C0_VPOL_LOW	  0x02000000	/* VSYNC polarity active low */
>  #define	  C0_VCLK_LOW	  0x04000000	/* VCLK on falling edge */
>  #define	  C0_DOWNSCALE	  0x08000000	/* Enable downscaler */
> -#define	  C0_SIFM_MASK	  0xc0000000	/* SIF mode bits */
> +/* SIFMODE */

What's this change for?

> diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
> index c4c17fe..3dad182 100644
> --- a/drivers/media/platform/marvell-ccic/mmp-driver.c
> +++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
[...]
> +void mmpcam_calc_dphy(struct mcam_camera *mcam)
> +{
> +	struct mmp_camera *cam = mcam_to_cam(mcam);
> +	struct mmp_camera_platform_data *pdata = cam->pdev->dev.platform_data;
> +	struct device *dev = &cam->pdev->dev;
> +	unsigned long tx_clk_esc;
> +
> +	/*
> +	 * If CSI2_DPHY3 is calculated dynamically,
> +	 * pdata->lane_clk should be already set
> +	 * either in the board driver statically
> +	 * or in the sensor driver dynamically.
> +	 */
> +	/*
> +	 * dphy[0] - CSI2_DPHY3:
> +	 *  bit 0 ~ bit 7: HS Term Enable.
> +	 *   defines the time that the DPHY
> +	 *   wait before enabling the data
> +	 *   lane termination after detecting
> +	 *   that the sensor has driven the data
> +	 *   lanes to the LP00 bridge state.
> +	 *   The value is calculated by:
> +	 *   (Max T(D_TERM_EN)/Period(DDR)) - 1
> +	 *  bit 8 ~ bit 15: HS_SETTLE
> +	 *   Time interval during which the HS
> +	 *   receiver shall ignore any Data Lane
> +	 *   HS transistions.
> +	 *   The vaule has been calibrated on
> +	 *   different boards. It seems to work well.
> +	 *
> +	 *  More detail please refer
> +	 *  MIPI Alliance Spectification for D-PHY
> +	 *  document for explanation of HS-SETTLE
> +	 *  and D-TERM-EN.
> +	 */
> +	switch (pdata->dphy3_algo) {
> +	case DPHY3_ALGO_PXA910:
> +		/*
> +		 * Calculate CSI2_DPHY3 algo for PXA910
> +		 */
> +		pdata->dphy[0] = ((1 + pdata->lane_clk * 80 / 1000) & 0xff) << 8
> +			| (1 + pdata->lane_clk * 35 / 1000);

There's enough operators here that some parentheses would really help to
make the code more readable.  Lots of places in this file.

[...]
>  static irqreturn_t mmpcam_irq(int irq, void *data)
>  {
> @@ -174,17 +280,30 @@ static int mmpcam_probe(struct platform_device *pdev)
>  	struct mmp_camera_platform_data *pdata;
>  	int ret;
>  
> +	pdata = pdev->dev.platform_data;
> +	if (!pdata)
> +		return -ENODEV;
> +
>  	cam = kzalloc(sizeof(*cam), GFP_KERNEL);
>  	if (cam == NULL)
>  		return -ENOMEM;
>  	cam->pdev = pdev;
> +	cam->mipi_clk = ERR_PTR(-EINVAL);

The use of ERR_PTR here (and in related places) seems a bit weird; is there
a reason you can't just use NULL?

In summary, I'm not really familiar with the MIPI interface, and I don't
have any hardware with it, so I'll have to take your word that the code
works.  I've pointed out a bunch of nits that are worth fixing.  The
locking mistakes are fatal, though, and need attention.  They should be
quick to fix, though; this code should be ready to merge in short order.

Thanks,

jon
