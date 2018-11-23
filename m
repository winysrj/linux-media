Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:52369 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390041AbeKWS1s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 13:27:48 -0500
Date: Fri, 23 Nov 2018 08:44:28 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Cameron <quozl@laptop.org>, Pavel Machek <pavel@ucw.cz>,
        Libin Yang <lbyang@marvell.com>,
        Albert Wang <twang13@marvell.com>
Subject: Re: [PATCH v3 14/14] [media] marvell-ccic: provide a clock for the
 sensor
Message-ID: <20181122200747.GA6788@w540>
References: <20181120100318.367987-1-lkundrak@v3.sk>
 <20181120100318.367987-15-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jousvV0MzM2p6OtC"
Content-Disposition: inline
In-Reply-To: <20181120100318.367987-15-lkundrak@v3.sk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--jousvV0MzM2p6OtC
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

HI Lubomir,

On Tue, Nov 20, 2018 at 11:03:19AM +0100, Lubomir Rintel wrote:
> The sensor needs the MCLK clock running when it's being probed. On
> platforms where the sensor is instantiated from a DT (MMP2) it is going
> to happen asynchronously.
>
> Therefore, the current modus operandi, where the bridge driver fiddles
> with the sensor power and clock itself is not going to fly. As the comments
> wisely note, this doesn't even belong there.
>
> Luckily, the ov7670 driver is already able to control its power and
> reset lines, we can just drop the MMP platform glue altogether.
>
> It also requests the clock via the standard clock subsystem. Good -- let's
> set up a clock instance so that the sensor can ask us to enable the clock.
> Note that this is pretty dumb at the moment: the clock is hardwired to a
> particular frequency and parent. It was always the case.
>
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
>
> ---
> Changes since v1:
> - [kbuild/ia64] depend on COMMON_CLK.
> - [smatch] fix bad return in mcam_v4l_open() leading to lock not getting
>   released on error.
>
>  drivers/media/platform/marvell-ccic/Kconfig   |   2 +
>  .../media/platform/marvell-ccic/cafe-driver.c |   9 +-
>  .../media/platform/marvell-ccic/mcam-core.c   | 156 +++++++++++++++---
>  .../media/platform/marvell-ccic/mcam-core.h   |   3 +
>  .../media/platform/marvell-ccic/mmp-driver.c  | 152 ++---------------
>  .../linux/platform_data/media/mmp-camera.h    |   2 -
>  6 files changed, 161 insertions(+), 163 deletions(-)
>
> diff --git a/drivers/media/platform/marvell-ccic/Kconfig b/drivers/media/platform/marvell-ccic/Kconfig
> index cf12e077203a..3e12eb25740a 100644
> --- a/drivers/media/platform/marvell-ccic/Kconfig
> +++ b/drivers/media/platform/marvell-ccic/Kconfig
> @@ -1,6 +1,7 @@
>  config VIDEO_CAFE_CCIC
>  	tristate "Marvell 88ALP01 (Cafe) CMOS Camera Controller support"
>  	depends on PCI && I2C && VIDEO_V4L2
> +	depends on COMMON_CLK
>  	select VIDEO_OV7670
>  	select VIDEOBUF2_VMALLOC
>  	select VIDEOBUF2_DMA_CONTIG
> @@ -14,6 +15,7 @@ config VIDEO_MMP_CAMERA
>  	tristate "Marvell Armada 610 integrated camera controller support"
>  	depends on I2C && VIDEO_V4L2
>  	depends on ARCH_MMP || COMPILE_TEST
> +	depends on COMMON_CLK
>  	select VIDEO_OV7670
>  	select I2C_GPIO
>  	select VIDEOBUF2_VMALLOC
> diff --git a/drivers/media/platform/marvell-ccic/cafe-driver.c b/drivers/media/platform/marvell-ccic/cafe-driver.c
> index 658294d319c0..0e712bb941ba 100644
> --- a/drivers/media/platform/marvell-ccic/cafe-driver.c
> +++ b/drivers/media/platform/marvell-ccic/cafe-driver.c
> @@ -33,6 +33,7 @@
>  #include <linux/wait.h>
>  #include <linux/delay.h>
>  #include <linux/io.h>
> +#include <linux/clkdev.h>
>
>  #include "mcam-core.h"
>
> @@ -533,11 +534,10 @@ static int cafe_pci_probe(struct pci_dev *pdev,
>  		goto out_iounmap;
>
>  	/*
> -	 * Initialize the controller and leave it powered up.  It will
> -	 * stay that way until the sensor driver shows up.
> +	 * Initialize the controller.
>  	 */
>  	cafe_ctlr_init(mcam);
> -	cafe_ctlr_power_up(mcam);
> +
>  	/*
>  	 * Set up I2C/SMBUS communications.  We have to drop the mutex here
>  	 * because the sensor could attach in this call chain, leading to
> @@ -555,6 +555,9 @@ static int cafe_pci_probe(struct pci_dev *pdev,
>  	if (ret)
>  		goto out_smbus_shutdown;
>
> +	clkdev_create(mcam->mclk, "xclk", "%d-%04x",
> +		i2c_adapter_id(cam->i2c_adapter), ov7670_info.addr);
> +
>  	if (i2c_new_device(cam->i2c_adapter, &ov7670_info)) {
>  		cam->registered = 1;
>  		return 0;
> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
> index 87812b7287f0..982fbac6472d 100644
> --- a/drivers/media/platform/marvell-ccic/mcam-core.c
> +++ b/drivers/media/platform/marvell-ccic/mcam-core.c
> @@ -22,6 +22,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/io.h>
>  #include <linux/clk.h>
> +#include <linux/clk-provider.h>
>  #include <linux/videodev2.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ioctl.h>
> @@ -303,9 +304,6 @@ static void mcam_enable_mipi(struct mcam_camera *mcam)
>  		 */
>  		mcam_reg_write(mcam, REG_CSI2_CTRL0,
>  			CSI2_C0_MIPI_EN | CSI2_C0_ACT_LANE(mcam->lane));
> -		mcam_reg_write(mcam, REG_CLKCTRL,
> -			(mcam->mclk_src << 29) | mcam->mclk_div);
> -
>  		mcam->mipi_enabled = true;
>  	}
>  }
> @@ -846,11 +844,6 @@ static void mcam_ctlr_init(struct mcam_camera *cam)
>  	 * but it's good to be sure.
>  	 */
>  	mcam_reg_clear_bit(cam, REG_CTRL0, C0_ENABLE);
> -	/*
> -	 * Clock the sensor appropriately.  Controller clock should
> -	 * be 48MHz, sensor "typical" value is half that.
> -	 */
> -	mcam_reg_write_mask(cam, REG_CLKCTRL, 2, CLK_DIV_MASK);
>  	spin_unlock_irqrestore(&cam->dev_lock, flags);
>  }
>
> @@ -898,14 +891,15 @@ static int mcam_ctlr_power_up(struct mcam_camera *cam)
>  	int ret;
>
>  	spin_lock_irqsave(&cam->dev_lock, flags);
> -	ret = cam->plat_power_up(cam);
> -	if (ret) {
> -		spin_unlock_irqrestore(&cam->dev_lock, flags);
> -		return ret;
> +	if (cam->plat_power_up) {
> +		ret = cam->plat_power_up(cam);
> +		if (ret) {
> +			spin_unlock_irqrestore(&cam->dev_lock, flags);
> +			return ret;
> +		}
>  	}
>  	mcam_reg_clear_bit(cam, REG_CTRL1, C1_PWRDWN);
>  	spin_unlock_irqrestore(&cam->dev_lock, flags);
> -	msleep(5); /* Just to be sure */
>  	return 0;
>  }
>
> @@ -920,10 +914,101 @@ static void mcam_ctlr_power_down(struct mcam_camera *cam)
>  	 * power down routine.
>  	 */
>  	mcam_reg_set_bit(cam, REG_CTRL1, C1_PWRDWN);
> -	cam->plat_power_down(cam);
> +	if (cam->plat_power_down)
> +		cam->plat_power_down(cam);
>  	spin_unlock_irqrestore(&cam->dev_lock, flags);
>  }
>
> +/* ---------------------------------------------------------------------- */
> +/*
> + * Controller clocks.
> + */
> +static void mcam_clk_enable(struct mcam_camera *mcam)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < NR_MCAM_CLK; i++) {
> +		if (!IS_ERR(mcam->clk[i]))
> +			clk_prepare_enable(mcam->clk[i]);
> +	}
> +}
> +
> +static void mcam_clk_disable(struct mcam_camera *mcam)
> +{
> +	int i;
> +
> +	for (i = NR_MCAM_CLK - 1; i >= 0; i--) {
> +		if (!IS_ERR(mcam->clk[i]))
> +			clk_disable_unprepare(mcam->clk[i]);
> +	}
> +}
> +
> +/* ---------------------------------------------------------------------- */
> +/*
> + * Master sensor clock.
> + */
> +static int mclk_prepare(struct clk_hw *hw)
> +{
> +	struct mcam_camera *cam = container_of(hw, struct mcam_camera, mclk_hw);
> +
> +	clk_prepare(cam->clk[0]);
> +	return 0;
> +}
> +
> +static void mclk_unprepare(struct clk_hw *hw)
> +{
> +	struct mcam_camera *cam = container_of(hw, struct mcam_camera, mclk_hw);
> +
> +	clk_unprepare(cam->clk[0]);
> +}
> +
> +static int mclk_enable(struct clk_hw *hw)
> +{
> +	struct mcam_camera *cam = container_of(hw, struct mcam_camera, mclk_hw);
> +	int mclk_src;
> +	int mclk_div;
> +
> +	/*
> +	 * Clock the sensor appropriately.  Controller clock should
> +	 * be 48MHz, sensor "typical" value is half that.
> +	 */
> +	if (cam->bus_type == V4L2_MBUS_CSI2_DPHY) {
> +		mclk_src = cam->mclk_src;
> +		mclk_div = cam->mclk_div;
> +	} else {
> +		mclk_src = 3;
> +		mclk_div = 2;
> +	}
> +
> +	clk_enable(cam->clk[0]);
> +	mcam_reg_write(cam, REG_CLKCTRL, (mclk_src << 29) | mclk_div);
> +	mcam_ctlr_power_up(cam);
> +
> +	return 0;
> +}
> +
> +static void mclk_disable(struct clk_hw *hw)
> +{
> +	struct mcam_camera *cam = container_of(hw, struct mcam_camera, mclk_hw);
> +
> +	mcam_ctlr_power_down(cam);
> +	clk_disable(cam->clk[0]);
> +}
> +
> +static unsigned long mclk_recalc_rate(struct clk_hw *hw,
> +				unsigned long parent_rate)
> +{
> +	return 48000000;
> +}
> +
> +static const struct clk_ops mclk_ops = {
> +	.prepare = mclk_prepare,
> +	.unprepare = mclk_unprepare,
> +	.enable = mclk_enable,
> +	.disable = mclk_disable,
> +	.recalc_rate = mclk_recalc_rate,
> +};
> +
>  /* -------------------------------------------------------------------- */
>  /*
>   * Communications with the sensor.
> @@ -948,7 +1033,6 @@ static int mcam_cam_init(struct mcam_camera *cam)
>  	ret = __mcam_cam_reset(cam);
>  	/* Get/set parameters? */
>  	cam->state = S_IDLE;
> -	mcam_ctlr_power_down(cam);
>  	return ret;
>  }
>
> @@ -1584,9 +1668,10 @@ static int mcam_v4l_open(struct file *filp)
>  	if (ret)
>  		goto out;
>  	if (v4l2_fh_is_singular_file(filp)) {
> -		ret = mcam_ctlr_power_up(cam);
> +		ret = sensor_call(cam, core, s_power, 1);
>  		if (ret)
>  			goto out;
> +		mcam_clk_enable(cam);
>  		__mcam_cam_reset(cam);
>  		mcam_set_config_needed(cam, 1);
>  	}
> @@ -1608,7 +1693,8 @@ static int mcam_v4l_release(struct file *filp)
>  	_vb2_fop_release(filp, NULL);
>  	if (last_open) {
>  		mcam_disable_mipi(cam);
> -		mcam_ctlr_power_down(cam);
> +		sensor_call(cam, core, s_power, 0);
> +		mcam_clk_disable(cam);
>  		if (cam->buffer_mode == B_vmalloc && alloc_bufs_at_read)
>  			mcam_free_dma_bufs(cam);
>  	}
> @@ -1806,6 +1892,7 @@ static const struct v4l2_async_notifier_operations mccic_notify_ops = {
>
>  int mccic_register(struct mcam_camera *cam)
>  {
> +	struct clk_init_data mclk_init = { };
>  	int ret;
>
>  	/*
> @@ -1838,7 +1925,10 @@ int mccic_register(struct mcam_camera *cam)
>  	mcam_set_config_needed(cam, 1);
>  	cam->pix_format = mcam_def_pix_format;
>  	cam->mbus_code = mcam_def_mbus_code;
> -	mcam_ctlr_init(cam);
> +
> +	mcam_clk_enable(cam);

Am I mis-interpreting the clock bindings, or here you expose a clock
source, and sensors are supposed to reference it if they need to. It
is then the sensor driver that by calling clk_prepare_enable() on the
referenced clock triggers the call of the 'enable' function. It seems
to me that here you have exposed a clock provider, but the provider
itself enables its clocks... Am I confused?

Thanks
   j

> +	mcam_ctlr_init(cam); // XXX?
> +	mcam_clk_disable(cam);
>
>  	/*
>  	 * Register sensor notifier.
> @@ -1857,6 +1947,26 @@ int mccic_register(struct mcam_camera *cam)
>  		goto out;
>  	}
>
> +	/*
> +	 * Register sensor master clock.
> +	 */
> +	mclk_init.parent_names = NULL;
> +	mclk_init.num_parents = 0;
> +	mclk_init.ops = &mclk_ops;
> +	mclk_init.name = "mclk";
> +
> +	of_property_read_string(cam->dev->of_node, "clock-output-names",
> +							&mclk_init.name);
> +
> +	cam->mclk_hw.init = &mclk_init;
> +
> +	cam->mclk = devm_clk_register(cam->dev, &cam->mclk_hw);
> +	if (IS_ERR(cam->mclk)) {
> +		ret = PTR_ERR(cam->mclk);
> +		dev_err(cam->dev, "can't register clock\n");
> +		goto out;
> +	}
> +
>  	/*
>  	 * If so requested, try to get our DMA buffers now.
>  	 */
> @@ -1884,7 +1994,7 @@ void mccic_shutdown(struct mcam_camera *cam)
>  	 */
>  	if (!list_empty(&cam->vdev.fh_list)) {
>  		cam_warn(cam, "Removing a device with users!\n");
> -		mcam_ctlr_power_down(cam);
> +		sensor_call(cam, core, s_power, 0);
>  	}
>  	if (cam->buffer_mode == B_vmalloc)
>  		mcam_free_dma_bufs(cam);
> @@ -1906,7 +2016,8 @@ void mccic_suspend(struct mcam_camera *cam)
>  		enum mcam_state cstate = cam->state;
>
>  		mcam_ctlr_stop_dma(cam);
> -		mcam_ctlr_power_down(cam);
> +		sensor_call(cam, core, s_power, 0);
> +		mcam_clk_disable(cam);
>  		cam->state = cstate;
>  	}
>  	mutex_unlock(&cam->s_mutex);
> @@ -1919,14 +2030,15 @@ int mccic_resume(struct mcam_camera *cam)
>
>  	mutex_lock(&cam->s_mutex);
>  	if (!list_empty(&cam->vdev.fh_list)) {
> -		ret = mcam_ctlr_power_up(cam);
> +		mcam_clk_enable(cam);
> +		ret = sensor_call(cam, core, s_power, 1);
>  		if (ret) {
>  			mutex_unlock(&cam->s_mutex);
>  			return ret;
>  		}
>  		__mcam_cam_reset(cam);
>  	} else {
> -		mcam_ctlr_power_down(cam);
> +		sensor_call(cam, core, s_power, 0);
>  	}
>  	mutex_unlock(&cam->s_mutex);
>
> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
> index 4a72213aca1a..2e3a7567a76a 100644
> --- a/drivers/media/platform/marvell-ccic/mcam-core.h
> +++ b/drivers/media/platform/marvell-ccic/mcam-core.h
> @@ -8,6 +8,7 @@
>  #define _MCAM_CORE_H
>
>  #include <linux/list.h>
> +#include <linux/clk-provider.h>
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-dev.h>
> @@ -125,6 +126,8 @@ struct mcam_camera {
>
>  	/* clock tree support */
>  	struct clk *clk[NR_MCAM_CLK];
> +	struct clk_hw mclk_hw;
> +	struct clk *mclk;
>
>  	/*
>  	 * Callbacks from the core to the platform code.
> diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
> index efbffb06e25c..7e0783dc9152 100644
> --- a/drivers/media/platform/marvell-ccic/mmp-driver.c
> +++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
> @@ -22,9 +22,7 @@
>  #include <linux/of.h>
>  #include <linux/of_platform.h>
>  #include <linux/platform_device.h>
> -#include <linux/gpio.h>
>  #include <linux/io.h>
> -#include <linux/delay.h>
>  #include <linux/list.h>
>  #include <linux/pm.h>
>  #include <linux/clk.h>
> @@ -38,7 +36,6 @@ MODULE_LICENSE("GPL");
>  static char *mcam_clks[] = {"axi", "func", "phy"};
>
>  struct mmp_camera {
> -	void __iomem *power_regs;
>  	struct platform_device *pdev;
>  	struct mcam_camera mcam;
>  	struct list_head devlist;
> @@ -94,94 +91,6 @@ static struct mmp_camera *mmpcam_find_device(struct platform_device *pdev)
>  	return NULL;
>  }
>
> -
> -
> -
> -/*
> - * Power-related registers; this almost certainly belongs
> - * somewhere else.
> - *
> - * ARMADA 610 register manual, sec 7.2.1, p1842.
> - */
> -#define CPU_SUBSYS_PMU_BASE	0xd4282800
> -#define REG_CCIC_DCGCR		0x28	/* CCIC dyn clock gate ctrl reg */
> -#define REG_CCIC_CRCR		0x50	/* CCIC clk reset ctrl reg	*/
> -
> -static void mcam_clk_enable(struct mcam_camera *mcam)
> -{
> -	unsigned int i;
> -
> -	for (i = 0; i < NR_MCAM_CLK; i++) {
> -		if (!IS_ERR(mcam->clk[i]))
> -			clk_prepare_enable(mcam->clk[i]);
> -	}
> -}
> -
> -static void mcam_clk_disable(struct mcam_camera *mcam)
> -{
> -	int i;
> -
> -	for (i = NR_MCAM_CLK - 1; i >= 0; i--) {
> -		if (!IS_ERR(mcam->clk[i]))
> -			clk_disable_unprepare(mcam->clk[i]);
> -	}
> -}
> -
> -/*
> - * Power control.
> - */
> -static void mmpcam_power_up_ctlr(struct mmp_camera *cam)
> -{
> -	iowrite32(0x3f, cam->power_regs + REG_CCIC_DCGCR);
> -	iowrite32(0x3805b, cam->power_regs + REG_CCIC_CRCR);
> -	mdelay(1);
> -}
> -
> -static int mmpcam_power_up(struct mcam_camera *mcam)
> -{
> -	struct mmp_camera *cam = mcam_to_cam(mcam);
> -	struct mmp_camera_platform_data *pdata;
> -
> -/*
> - * Turn on power and clocks to the controller.
> - */
> -	mmpcam_power_up_ctlr(cam);
> -	mcam_clk_enable(mcam);
> -/*
> - * Provide power to the sensor.
> - */
> -	mcam_reg_write(mcam, REG_CLKCTRL, 0x60000002);
> -	pdata = cam->pdev->dev.platform_data;
> -	gpio_set_value(pdata->sensor_power_gpio, 1);
> -	mdelay(5);
> -	mcam_reg_clear_bit(mcam, REG_CTRL1, 0x10000000);
> -	gpio_set_value(pdata->sensor_reset_gpio, 0); /* reset is active low */
> -	mdelay(5);
> -	gpio_set_value(pdata->sensor_reset_gpio, 1); /* reset is active low */
> -	mdelay(5);
> -
> -	return 0;
> -}
> -
> -static void mmpcam_power_down(struct mcam_camera *mcam)
> -{
> -	struct mmp_camera *cam = mcam_to_cam(mcam);
> -	struct mmp_camera_platform_data *pdata;
> -/*
> - * Turn off clocks and set reset lines
> - */
> -	iowrite32(0, cam->power_regs + REG_CCIC_DCGCR);
> -	iowrite32(0, cam->power_regs + REG_CCIC_CRCR);
> -/*
> - * Shut down the sensor.
> - */
> -	pdata = cam->pdev->dev.platform_data;
> -	gpio_set_value(pdata->sensor_power_gpio, 0);
> -	gpio_set_value(pdata->sensor_reset_gpio, 0);
> -
> -	mcam_clk_disable(mcam);
> -}
> -
>  /*
>   * calc the dphy register values
>   * There are three dphy registers being used.
> @@ -327,8 +236,6 @@ static int mmpcam_probe(struct platform_device *pdev)
>  	INIT_LIST_HEAD(&cam->devlist);
>
>  	mcam = &cam->mcam;
> -	mcam->plat_power_up = mmpcam_power_up;
> -	mcam->plat_power_down = mmpcam_power_down;
>  	mcam->calc_dphy = mmpcam_calc_dphy;
>  	mcam->dev = &pdev->dev;
>  	pdata = pdev->dev.platform_data;
> @@ -366,33 +273,6 @@ static int mmpcam_probe(struct platform_device *pdev)
>  	if (IS_ERR(mcam->regs))
>  		return PTR_ERR(mcam->regs);
>  	mcam->regs_size = resource_size(res);
> -	/*
> -	 * Power/clock memory is elsewhere; get it too.  Perhaps this
> -	 * should really be managed outside of this driver?
> -	 */
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> -	cam->power_regs = devm_ioremap_resource(&pdev->dev, res);
> -	if (IS_ERR(cam->power_regs))
> -		return PTR_ERR(cam->power_regs);
> -	/*
> -	 * Sensor GPIO pins.
> -	 */
> -	ret = devm_gpio_request(&pdev->dev, pdata->sensor_power_gpio,
> -							"cam-power");
> -	if (ret) {
> -		dev_err(&pdev->dev, "Can't get sensor power gpio %d",
> -				pdata->sensor_power_gpio);
> -		return ret;
> -	}
> -	gpio_direction_output(pdata->sensor_power_gpio, 0);
> -	ret = devm_gpio_request(&pdev->dev, pdata->sensor_reset_gpio,
> -							"cam-reset");
> -	if (ret) {
> -		dev_err(&pdev->dev, "Can't get sensor reset gpio %d",
> -				pdata->sensor_reset_gpio);
> -		return ret;
> -	}
> -	gpio_direction_output(pdata->sensor_reset_gpio, 0);
>
>  	mcam_init_clk(mcam);
>
> @@ -410,14 +290,21 @@ static int mmpcam_probe(struct platform_device *pdev)
>  	fwnode_handle_put(ep);
>
>  	/*
> -	 * Power the device up and hand it off to the core.
> +	 * Register the device with the core.
>  	 */
> -	ret = mmpcam_power_up(mcam);
> -	if (ret)
> -		return ret;
>  	ret = mccic_register(mcam);
>  	if (ret)
> -		goto out_power_down;
> +		return ret;
> +
> +	/*
> +	 * Add OF clock provider.
> +	 */
> +	ret = of_clk_add_provider(pdev->dev.of_node, of_clk_src_simple_get,
> +								mcam->mclk);
> +	if (ret) {
> +		dev_err(&pdev->dev, "can't add DT clock provider\n");
> +		goto out;
> +	}
>
>  	/*
>  	 * Finally, set up our IRQ now that the core is ready to
> @@ -426,7 +313,7 @@ static int mmpcam_probe(struct platform_device *pdev)
>  	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>  	if (res == NULL) {
>  		ret = -ENODEV;
> -		goto out_unregister;
> +		goto out;
>  	}
>  	cam->irq = res->start;
>  	ret = devm_request_irq(&pdev->dev, cam->irq, mmpcam_irq, IRQF_SHARED,
> @@ -436,10 +323,10 @@ static int mmpcam_probe(struct platform_device *pdev)
>  		return 0;
>  	}
>
> -out_unregister:
> +out:
> +	fwnode_handle_put(mcam->asd.match.fwnode);
>  	mccic_shutdown(mcam);
> -out_power_down:
> -	mmpcam_power_down(mcam);
> +
>  	return ret;
>  }
>
> @@ -450,7 +337,6 @@ static int mmpcam_remove(struct mmp_camera *cam)
>
>  	mmpcam_remove_device(cam);
>  	mccic_shutdown(mcam);
> -	mmpcam_power_down(mcam);
>  	return 0;
>  }
>
> @@ -482,12 +368,6 @@ static int mmpcam_resume(struct platform_device *pdev)
>  {
>  	struct mmp_camera *cam = mmpcam_find_device(pdev);
>
> -	/*
> -	 * Power up unconditionally just in case the core tries to
> -	 * touch a register even if nothing was active before; trust
> -	 * me, it's better this way.
> -	 */
> -	mmpcam_power_up_ctlr(cam);
>  	return mccic_resume(&cam->mcam);
>  }
>
> diff --git a/include/linux/platform_data/media/mmp-camera.h b/include/linux/platform_data/media/mmp-camera.h
> index c573ebc40035..53adaab64f28 100644
> --- a/include/linux/platform_data/media/mmp-camera.h
> +++ b/include/linux/platform_data/media/mmp-camera.h
> @@ -12,8 +12,6 @@ enum dphy3_algo {
>  };
>
>  struct mmp_camera_platform_data {
> -	int sensor_power_gpio;
> -	int sensor_reset_gpio;
>  	enum v4l2_mbus_type bus_type;
>  	int mclk_src;	/* which clock source the MCLK derives from */
>  	int mclk_div;	/* Clock Divider Value for MCLK */
> --
> 2.19.1
>

--jousvV0MzM2p6OtC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJb96/cAAoJEHI0Bo8WoVY8tvsP/0d5w7womrIfj7J7a9Khx77D
fYhyfwGwwqnggUpme01CTGuNGXghB9QUZdOKHBbY3R9JOamzP5FL7SdLCSyZGxTQ
usfKa0ceFe2dnzg15xNhL/LffXvHmTL6nUei5aPnxeR9EOcor3Mwn3MiDIFkNyK+
SfOjZySQ1n+TJEn3xvOWKmrqVUcf5tel6Ld+U3R1l6py6ZrG+IVfKQK4wYWnnOKq
x4uGIiqMXT9B0BIyIGvr55Ue0x5AhhEivnIyjyB4ivejTjaDns/x4TmwyiV35wSw
E36HvJkLTFzqf9vxTrTA3ykvgeIlx60GE676g+QFHBxGI3dflJ2j7PC0A/8uGtUI
iNjTmkDAfGvcLHuuvFLTAW52So/3BFtDUNMxKdqCJvsWb3Bv3P0xFoU4wCQbSn9A
xk9QwhbDFLrQYVAjP6zY/14gv6SfmANPWT3rUjzamf9z2uEF+jSa6kkVwlixb/OG
lgVuRkmMiDOnXAo+VHudQomyd/evvqUthcTNLCWCGYoAPm7dcAdilnQPiSULq2rp
xGgwDu29J2IW3bTl8e3Shd8G3puGhNxpbvg4UZO0/lBqPNdtr8Kc9tYI++8BCe1x
38bbrnjL6N9RGND28/nu2ZTQ5GbPitoADVN3Srh54KJKkIkX24IPpGIMLoyEwQMp
fHaM4PrG0YGXyo4NAyEY
=D7FC
-----END PGP SIGNATURE-----

--jousvV0MzM2p6OtC--
