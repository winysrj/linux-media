Return-path: <mchehab@pedra>
Received: from nm22-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.222]:46298 "HELO
	nm22-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933153Ab1FADVy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 23:21:54 -0400
Message-ID: <115690.73510.qm@web112018.mail.gq1.yahoo.com>
Date: Tue, 31 May 2011 20:21:53 -0700 (PDT)
From: Chris Rodley <carlighting@yahoo.co.nz>
Subject: Re: [beagleboard] [PATCH v5 2/2] Add support for mt9p031 (LI-5M03 module) in Beagleboard xM.
To: javier.martin@vista-silicon.com
Cc: beagleboard@googlegroups.com, linux-media@vger.kernel.org,
	g.liakhovetski@gmx.de, laurent.pinchart@ideasonboard.com,
	mch_kot@yahoo.com.cn, koen@beagleboard.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Javier,

On 01/06/11 01:34, Koen Kooi wrote:
> root@beagleboardxMC:~# yavta -f SGRBG8 -s 320x240 -n 4 --capture=10 --skip 3 -F `media-ctl -e "OMAP3 ISP CCDC output"`
> Device /dev/video2 opened.
> Device `OMAP3 ISP CCDC output' on `media' is a video capture device.
> Video format set: SGRBG8 (47425247) 320x240 buffer size 76800
> Video format: SGRBG8 (47425247) 320x240 buffer size 76800
> 4 buffers requested.
> length: 76800 offset: 0
> Buffer 0 mapped at address 0x402cf000.
> length: 76800 offset: 77824
> Buffer 1 mapped at address 0x402fe000.
> length: 76800 offset: 155648
> Buffer 2 mapped at address 0x40362000.
> length: 76800 offset: 233472
> Buffer 3 mapped at address 0x40416000.
> 0 (0) [-] 4294967295 76800 bytes 167.403289 1306829219.931121 0.002 fps
> 1 (1) [-] 4294967295 76800 bytes 167.633148 1306829220.160980 4.350 fps
> 2 (2) [-] 4294967295 76800 bytes 167.744506 1306829220.272308 8.980 fps
> 3 (3) [-] 4294967295 76800 bytes 167.855865 1306829220.383667 8.980 fps
> 4 (0) [-] 4294967295 76800 bytes 167.967193 1306829220.495025 8.982 fps
> 5 (1) [-] 4294967295 76800 bytes 168.078552 1306829220.606384 8.980 fps
> 6 (2) [-] 4294967295 76800 bytes 168.189910 1306829220.717742 8.980 fps
> 7 (3) [-] 4294967295 76800 bytes 168.301269 1306829220.829071 8.980 fps
> 8 (0) [-] 4294967295 76800 bytes 168.412597 1306829220.940429 8.982 fps
> 9 (1) [-] 4294967295 76800 bytes 168.523956 1306829221.051788 8.980 fps
> Captured 10 frames in 1.254212 seconds (7.973134 fps, 612336.670356 B/s).
> 4 buffers released.
>
> So that seems to be working! I haven't checked the frames yet, but is isn't throwing ISP errors anymore.

Unfortunately still not working for me.
My board is not the BeagleBoard XM but is similar. It is an omap3530 board and power to the camera (VDD and VDD_IO) is controlled by GPIO 57 and 58.

Here is my code for the board-omap3beagle-camera.c file.
Instead of triggering the regulators I set them up in the board file and then turn them on - This approach worked fine in v1 of your patch, but has not worked on any version since - Is there anything you can see as an issue?:

#include <linux/gpio.h>
//#include <linux/regulator/machine.h>

#include <plat/i2c.h>

#include <media/mt9p031.h>

#include "devices.h"
#include "../../../drivers/media/video/omap3isp/isp.h"

#define MT9P031_RESET_GPIO	98
#define MT9P031_XCLK		ISP_XCLK_A

//static struct regulator *reg_1v8, *reg_2v8;

static int beagle_cam_set_xclk(struct v4l2_subdev *subdev, int hz)
{
	struct isp_device *isp = v4l2_dev_to_isp_device(subdev->v4l2_dev);
	int ret;

	ret = isp->platform_cb.set_xclk(isp, hz, MT9P031_XCLK);
	return 0;
}

static int beagle_cam_reset(struct v4l2_subdev *subdev, int active)
{
	/* Set RESET_BAR to !active */
	gpio_set_value(MT9P031_RESET_GPIO, !active);

	return 0;
}

static struct mt9p031_platform_data beagle_mt9p031_platform_data = {
	.set_xclk               = beagle_cam_set_xclk,
	.reset                  = beagle_cam_reset,
};

static struct i2c_board_info mt9p031_camera_i2c_device = {
	I2C_BOARD_INFO("mt9p031", 0x48),
	.platform_data = &beagle_mt9p031_platform_data,
};

static struct isp_subdev_i2c_board_info mt9p031_camera_subdevs[] = {
	{
		.board_info = &mt9p031_camera_i2c_device,
		.i2c_adapter_id = 2,
	},
	{ NULL, 0, },
};

static struct isp_v4l2_subdevs_group beagle_camera_subdevs[] = {
	{
		.subdevs = mt9p031_camera_subdevs,
		.interface = ISP_INTERFACE_PARALLEL,
		.bus = {
				.parallel = {
					.data_lane_shift = 0,
					.clk_pol = 1,
					.bridge = ISPCTRL_PAR_BRIDGE_DISABLE,
				}
		},
	},
	{ },
};

static struct isp_platform_data beagle_isp_platform_data = {
	.subdevs = beagle_camera_subdevs,
};

static int __init beagle_camera_init(void)
{
/* New code START */
	gpio_set_value(58, 0);
 	printk(KERN_INFO "Power on 58 1v8 init..\n");	

	gpio_set_value(57, 0);
	printk(KERN_INFO "Power on 57 2v8 init..\n");
/* New code END */ 

/* ORIG CODE
{
	reg_1v8 = regulator_get(NULL, "cam_1v8");
	if (IS_ERR(reg_1v8))
		pr_err("%s: cannot get cam_1v8 regulator\n", __func__);
	else
		regulator_enable(reg_1v8);

	reg_2v8 = regulator_get(NULL, "cam_2v8");
	if (IS_ERR(reg_2v8))
		pr_err("%s: cannot get cam_2v8 regulator\n", __func__);
	else
		regulator_enable(reg_2v8);*/

	omap_register_i2c_bus(2, 100, NULL, 0);
	gpio_request(MT9P031_RESET_GPIO, "cam_rst");
	gpio_direction_output(MT9P031_RESET_GPIO, 0);
	omap3_init_camera(&beagle_isp_platform_data);
	return 0;
}
late_initcall(beagle_camera_init);


Regards,
Chris
