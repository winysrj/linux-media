Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:58596 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758158Ab3CDVe4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 16:34:56 -0500
Date: Mon, 4 Mar 2013 22:34:48 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Albert Wang <twang13@marvell.com>
cc: corbet@lwn.net,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [REVIEW PATCH V4 01/12] [media] marvell-ccic: add MIPI support
 for marvell-ccic driver
In-Reply-To: <1360238687-15768-2-git-send-email-twang13@marvell.com>
Message-ID: <Pine.LNX.4.64.1303042128390.20206@axis700.grange>
References: <1360238687-15768-1-git-send-email-twang13@marvell.com>
 <1360238687-15768-2-git-send-email-twang13@marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Albert

A general comment first: I have no idea about this hardware, so, feel free 
to ignore all my hardware-handling related comments. But just from looking 
your handling of the pll1 clock does seem a bit fishy to me. You acquire 
and release the clock in the generic mcam code, but only use it in the mmp 
driver. Is it really needed centrally? Wouldn't it suffice to only acquire 
it in mmp? Same goes for your mcam_config_mipi() function - is it really 
needed centrally? But as I said, maybe I'm just missing something.

On Thu, 7 Feb 2013, Albert Wang wrote:

> From: Libin Yang <lbyang@marvell.com>
> 
> This patch adds the MIPI support for marvell-ccic.
> Board driver should determine whether using MIPI or not.
> 
> Signed-off-by: Albert Wang <twang13@marvell.com>
> Signed-off-by: Libin Yang <lbyang@marvell.com>
> ---
>  drivers/media/platform/marvell-ccic/mcam-core.c  |   66 +++++++++++++
>  drivers/media/platform/marvell-ccic/mcam-core.h  |   28 +++++-
>  drivers/media/platform/marvell-ccic/mmp-driver.c |  113 +++++++++++++++++++++-
>  include/media/mmp-camera.h                       |   10 ++
>  4 files changed, 214 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
> index 7012913f..7e178d8 100755
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
> @@ -253,6 +254,39 @@ static void mcam_ctlr_stop(struct mcam_camera *cam)
>  	mcam_reg_clear_bit(cam, REG_CTRL0, C0_ENABLE);
>  }
>  
> +static int mcam_config_mipi(struct mcam_camera *mcam, int enable)
> +{
> +	if (mcam->bus_type == V4L2_MBUS_CSI2 && enable) {

This function is only called twice in the code: both times with a const 
"enable" - once 1 and once 0. But you also do a disable, if the parallel 
bus is used. Wouldn't it look prettier as

+static int mcam_config_mipi(struct mcam_camera *mcam, bool enable)
+{
+	if (enable) {

And then see the change below.

> +		/* Using MIPI mode and enable MIPI */
> +		cam_dbg(mcam, "camera: DPHY3=0x%x, DPHY5=0x%x, DPHY6=0x%x\n",
> +			mcam->dphy[0], mcam->dphy[1], mcam->dphy[2]);
> +		mcam_reg_write(mcam, REG_CSI2_DPHY3, mcam->dphy[0]);
> +		mcam_reg_write(mcam, REG_CSI2_DPHY5, mcam->dphy[1]);
> +		mcam_reg_write(mcam, REG_CSI2_DPHY6, mcam->dphy[2]);
> +
> +		if (mcam->mipi_enabled == 0) {
> +			BUG_ON(mcam->lane > 4 || mcam->lane <= 0);

A recent discussion about the use of BUG* macros in the kernel indicated, 
that you only should BUG() the kernel, when there's really no way to 
continue and the system would die soon anyway. Otherwise produce an error 
/ warning message and return an error code (if possible).

> +			/*
> +			 * 0x41 actives 1 lane
> +			 * 0x43 actives 2 lanes
> +			 * 0x45 actives 3 lanes (never happen)
> +			 * 0x47 actives 4 lanes
> +			 */
> +			mcam_reg_write(mcam, REG_CSI2_CTRL0,
> +				CSI2_C0_MIPI_EN | CSI2_C0_ACT_LANE(mcam->lane));
> +			mcam->mipi_enabled = 1;
> +		}
> +	} else {
> +		/* Using Parallel mode or disable MIPI */
> +		mcam_reg_write(mcam, REG_CSI2_CTRL0, 0x0);
> +		mcam_reg_write(mcam, REG_CSI2_DPHY3, 0x0);
> +		mcam_reg_write(mcam, REG_CSI2_DPHY5, 0x0);
> +		mcam_reg_write(mcam, REG_CSI2_DPHY6, 0x0);
> +		mcam->mipi_enabled = 0;
> +	}
> +	return 0;

If you convert the above BUG() to a failure, then you need this return 
value, in this version this function never fails.

> +}
> +
>  /* ------------------------------------------------------------------- */
>  
>  #ifdef MCAM_MODE_VMALLOC
> @@ -656,6 +690,13 @@ static void mcam_ctlr_image(struct mcam_camera *cam)
>  	 */
>  	mcam_reg_write_mask(cam, REG_CTRL0, C0_SIF_HVSYNC,
>  			C0_SIFM_MASK);
> +
> +	/*
> +	 * This field controls the generation of EOF(DVP only)
> +	 */
> +	if (cam->bus_type != V4L2_MBUS_CSI2)
> +		mcam_reg_set_bit(cam, REG_CTRL0,
> +				C0_EOF_VSYNC | C0_VEDGE_CTRL);
>  }
>  
>  
> @@ -886,6 +927,16 @@ static int mcam_read_setup(struct mcam_camera *cam)
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
> +	ret = mcam_config_mipi(cam, 1);

Then here you do

+	ret = mcam_config_mipi(cam, cam->bus_type == V4L2_MBUS_CSI2);

> +	if (ret < 0)
> +		return ret;
>  	mcam_ctlr_irq_enable(cam);
>  	cam->state = S_STREAMING;
>  	if (!test_bit(CF_SG_RESTART, &cam->flags))
> @@ -1551,6 +1602,16 @@ static int mcam_v4l_open(struct file *filp)
>  		mcam_set_config_needed(cam, 1);
>  	}
>  	(cam->users)++;
> +	if (cam->bus_type == V4L2_MBUS_CSI2) {
> +		cam->pll1 = devm_clk_get(cam->dev, "pll1");
> +		if (IS_ERR_OR_NULL(cam->pll1) && cam->dphy[2] == 0) {

So, is CSI2 mode only supported with enabled CONFIG_HAVE_CLK? It looks a 
bit susppicious, but, I think, this might be valid here - you really need 
a clock, from which you can read a valid rate to use CSI2, right? 
Otherwise you cannot configure dphy.

> +			cam_err(cam, "Could not get pll1 clock\n");
> +			if (IS_ERR(cam->pll1))
> +				ret = PTR_ERR(cam->pll1);
> +			else
> +				ret = -EINVAL;
> +		}
> +	}
>  out:
>  	mutex_unlock(&cam->s_mutex);
>  	return ret;
> @@ -1569,10 +1630,15 @@ static int mcam_v4l_release(struct file *filp)
>  	if (cam->users == 0) {
>  		mcam_ctlr_stop_dma(cam);
>  		mcam_cleanup_vb2(cam);
> +		mcam_config_mipi(cam, 0);

and use a boolean value here

+		mcam_config_mipi(cam, false);

>  		mcam_ctlr_power_down(cam);
>  		if (cam->buffer_mode == B_vmalloc && alloc_bufs_at_read)
>  			mcam_free_dma_bufs(cam);
>  	}
> +	if (cam->bus_type == V4L2_MBUS_CSI2) {
> +		devm_clk_put(cam->dev, cam->pll1);
> +		cam->pll1 = NULL;
> +	}
>  	mutex_unlock(&cam->s_mutex);
>  	return 0;
>  }
> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
> index 5e802c6..f73a801 100755
> --- a/drivers/media/platform/marvell-ccic/mcam-core.h
> +++ b/drivers/media/platform/marvell-ccic/mcam-core.h
> @@ -101,11 +101,21 @@ struct mcam_camera {
>  	short int clock_speed;	/* Sensor clock speed, default 30 */
>  	short int use_smbus;	/* SMBUS or straight I2c? */
>  	enum mcam_buffer_mode buffer_mode;
> +
> +	enum v4l2_mbus_type bus_type;
> +	/* MIPI support */
> +	int *dphy;
> +	int mipi_enabled;
> +	int lane;			/* lane number */
> +
> +	struct clk *pll1;
> +
>  	/*
>  	 * Callbacks from the core to the platform code.
>  	 */
>  	void (*plat_power_up) (struct mcam_camera *cam);
>  	void (*plat_power_down) (struct mcam_camera *cam);
> +	void (*calc_dphy) (struct mcam_camera *cam);
>  
>  	/*
>  	 * Everything below here is private to the mcam core and
> @@ -218,6 +228,17 @@ int mccic_resume(struct mcam_camera *cam);
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
> @@ -286,13 +307,16 @@ int mccic_resume(struct mcam_camera *cam);
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
>  #define	  C0_SIF_HVSYNC	  0x00000000	/* Use H/VSYNC */
> -#define	  CO_SOF_NOSYNC	  0x40000000	/* Use inband active signaling */
> +#define	  C0_SOF_NOSYNC	  0x40000000	/* Use inband active signaling */
> +#define	  C0_SIFM_MASK	  0xc0000000	/* SIF mode bits */
>  
>  /* Bits below C1_444ALPHA are not present in Cafe */
>  #define REG_CTRL1	0x40	/* Control 1 */
> diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
> index c4c17fe..7ab01e9 100755
> --- a/drivers/media/platform/marvell-ccic/mmp-driver.c
> +++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
> @@ -27,6 +27,7 @@
>  #include <linux/delay.h>
>  #include <linux/list.h>
>  #include <linux/pm.h>
> +#include <linux/clk.h>
>  
>  #include "mcam-core.h"
>  
> @@ -152,6 +153,103 @@ static void mmpcam_power_down(struct mcam_camera *mcam)
>  	gpio_set_value(pdata->sensor_reset_gpio, 0);
>  }
>  
> +/*
> + * calc the dphy register values
> + * There are three dphy registers being used.
> + * dphy[0] - CSI2_DPHY3
> + * dphy[1] - CSI2_DPHY5
> + * dphy[2] - CSI2_DPHY6
> + * CSI2_DPHY3 and CSI2_DPHY6 can be set with a default value
> + * or be calculated dynamically

Do you really support static dphy[*] valus? You'd recalculate them every 
time this function is called?

> + */
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
> +	case 1:

These values are purely software, thy have no direct analogs in hardware, 
right? I.e. you cannot read them from a register and you don't have to 
write them to one. Then, I think, you really want to use macros for them.

> +		/*
> +		 * dphy3_algo == 1
> +		 * Calculate CSI2_DPHY3 algo for PXA910
> +		 */
> +		pdata->dphy[0] = ((1 + pdata->lane_clk * 80 / 1000) & 0xff) << 8
> +			| (1 + pdata->lane_clk * 35 / 1000);
> +		break;
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
> +	if (IS_ERR_OR_NULL(mcam->pll1))
> +		return;

All this function does is calculate dphy[] array values, right? And these 
values are only used if CSI2 is activated. And CSI2 can only be activated 
if an open() has been successful. And you only succeed a CSI2-mode open() 
if a clock can be acquired. So, the above check is redundant?

> +
> +	/* get the escape clk, this is hard coded */
> +	tx_clk_esc = (clk_get_rate(mcam->pll1) / 1000000) / 12;
> +
> +	/*
> +	 * dphy[2] - CSI2_DPHY6:
> +	 * bit 0 ~ bit 7: CK Term Enable
> +	 *  Time for the Clock Lane receiver to enable the HS line
> +	 *  termination. The value is calculated similarly with
> +	 *  HS Term Enable
> +	 * bit 8 ~ bit 15: CK Settle
> +	 *  Time interval during which the HS receiver shall ignore
> +	 *  any Clock Lane HS transitions.
> +	 *  The value is calibrated on the boards.
> +	 */
> +	pdata->dphy[2] = ((534 * tx_clk_esc / 2000 - 1) & 0xff) << 8
> +			| ((38 * tx_clk_esc / 1000 - 1) & 0xff);
> +
> +	dev_dbg(dev, "camera: DPHY sets: dphy3=0x%x, dphy5=0x%x, dphy6=0x%x\n",
> +		pdata->dphy[0], pdata->dphy[1], pdata->dphy[2]);
> +}
>  
>  static irqreturn_t mmpcam_irq(int irq, void *data)
>  {
> @@ -174,6 +272,10 @@ static int mmpcam_probe(struct platform_device *pdev)
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
> @@ -183,8 +285,18 @@ static int mmpcam_probe(struct platform_device *pdev)
>  	mcam = &cam->mcam;
>  	mcam->plat_power_up = mmpcam_power_up;
>  	mcam->plat_power_down = mmpcam_power_down;
> +	mcam->calc_dphy = mmpcam_calc_dphy;
>  	mcam->dev = &pdev->dev;
>  	mcam->use_smbus = 0;
> +	mcam->bus_type = pdata->bus_type;
> +	mcam->dphy = pdata->dphy;
> +	/* mosetly it won't happen. dphy is an array in pdata, but in case .. */
> +	if (unlikely(mcam->dphy == NULL)) {
> +		ret = -EINVAL;
> +		goto out_free;
> +	}
> +	mcam->mipi_enabled = 0;
> +	mcam->lane = pdata->lane;
>  	mcam->chip_id = V4L2_IDENT_ARMADA610;
>  	mcam->buffer_mode = B_DMA_sg;
>  	spin_lock_init(&mcam->dev_lock);
> @@ -223,7 +335,6 @@ static int mmpcam_probe(struct platform_device *pdev)
>  	 * Find the i2c adapter.  This assumes, of course, that the
>  	 * i2c bus is already up and functioning.
>  	 */
> -	pdata = pdev->dev.platform_data;
>  	mcam->i2c_adapter = platform_get_drvdata(pdata->i2c_device);
>  	if (mcam->i2c_adapter == NULL) {
>  		ret = -ENODEV;
> diff --git a/include/media/mmp-camera.h b/include/media/mmp-camera.h
> index 7611963..813efe2 100755
> --- a/include/media/mmp-camera.h
> +++ b/include/media/mmp-camera.h
> @@ -1,3 +1,4 @@
> +#include <media/v4l2-mediabus.h>
>  /*
>   * Information for the Marvell Armada MMP camera
>   */
> @@ -6,4 +7,13 @@ struct mmp_camera_platform_data {
>  	struct platform_device *i2c_device;
>  	int sensor_power_gpio;
>  	int sensor_reset_gpio;
> +	enum v4l2_mbus_type bus_type;
> +	/*
> +	 * MIPI support
> +	 */
> +	int dphy[3];		/* DPHY: CSI2_DPHY3, CSI2_DPHY5, CSI2_DPHY6 */
> +	int dphy3_algo;		/* Exist 2 algos for calculate CSI2_DPHY3 */

I'd make the above an enum

> +	int mipi_enabled;	/* MIPI enabled flag */

And this one a bool

> +	int lane;		/* ccic used lane number; 0 means DVP mode */
> +	int lane_clk;
>  };
> -- 
> 1.7.9.5
> 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
