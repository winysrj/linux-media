Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:33788 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286Ab0JNN2S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Oct 2010 09:28:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bastian Hecht <hechtb@googlemail.com>
Subject: Re: OMAP 3530 camera ISP forks and new media framework
Date: Thu, 14 Oct 2010 15:28:20 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <AANLkTimyR117ZiHq8GFz4YW5tBtW3k82NzGVZqKoVTbY@mail.gmail.com> <201010121458.57150.laurent.pinchart@ideasonboard.com> <AANLkTim9vaLM20m0=dT5GJSttLBn4KWh1-bv44QnRw92@mail.gmail.com>
In-Reply-To: <AANLkTim9vaLM20m0=dT5GJSttLBn4KWh1-bv44QnRw92@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010141528.21794.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bastian,

On Thursday 14 October 2010 15:10:46 Bastian Hecht wrote:
> 2010/10/12 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:

[snip]

> > The OMAP3 ISP driver requires platform data that contain, among other
> > information, the list of I2C subdevices. Have a look at arch/arm/mach-
> > omap2/board-rx51-camera.c.
> 
> OK, I am closing in :)
> 
> I registered the OMAP_ISP device in my board-module. The driver kicks in
> [  205.686248] omap3isp omap3isp: Revision 2.0 found
> 
> and I can see the device in /sys/devices/platform/omap3isp.
> I loaded your slightly modified mt9t001 module under the name mt9p031
> and I can find it under
> /sys/bus/i2c/drivers/mt9p031
> /sys/module/laurentcam/drivers/i2c:mt9p031

The module should be loaded automatically. Make sure you modify the 
mt9t001_id[] array to replace "mt9t001" with "mt9p031".

> But this subdevice-driver doesn't get active (I added alot printk in
> the sensor module code, but no probing, nothing happens except the
> registration). I have not connected anything to the camera isp
> physically, but I think it should find out when probing?

Yes. The sensor driver probe function will try to access the sensor and will 
fail. This will in turn make the OMAP3 ISP driver fail, but you should at 
least get error messages.

> I also see no /dev/videox device from the isp. Can you guide me to
> next step? Your help makes it so much easier and I really appreciate
> it :)
> 
> Here my board code:
> 
> static struct mt9t001_platform_data bastix_mt9p031_platform_data = {
>         .clk_pol        = 0,
> };
> 
> 
> static struct i2c_board_info bastix_camera_i2c_devices[] = {
>         {
>                 I2C_BOARD_INFO(MT9P031_NAME, MT9P031_I2C_ADDR), /*
> name is "mt9p031" and i2caddr is fantasy number */

You need to provide a correct I2C address.

>                 .platform_data = &bastix_mt9p031_platform_data,
>         },
> };
> 
> static struct v4l2_subdev_i2c_board_info bastix_camera_mt9p031[] = {
>         {
>                 .board_info = &bastix_camera_i2c_devices[0],
>                 .i2c_adapter_id = BASTIX_CAM_I2C_BUS_NUM, /* busnum is 2 */
>                 .module_name = "mt9p031",

This field has disappeared recently. Please upgrade to the latest OMAP3 ISP 
driver version.

>         },
>         { NULL, 0, NULL, },
> };
> 
> static struct isp_v4l2_subdevs_group bastix_camera_subdevs[] = {
>         {
>                 .subdevs = bastix_camera_mt9p031,
>                 .interface = ISP_INTERFACE_CCP2B_PHY1,
>                 .bus = { .ccp2 = {
>                         .strobe_clk_pol         = 0,
>                         .crc                    = 1,
>                         .ccp2_mode              = 1,
>                         .phy_layer              = 1,
>                         .vpclk_div              = 1,
>                 } },

The mt9p031 is a parallel sensor, not a serial sensor. Use the following code 
(and replace the data_lane_shift and clk_pol variable depending on your 
hardware).

                .interface = ISP_INTERFACE_PARALLEL,
                .bus = { .parallel = {
                        .data_lane_shift        = 1,
                        .clk_pol                = 1,
                        .bridge                 = ISPCTRL_PAR_BRIDGE_DISABLE,
                } },

>         },
>         { NULL, 0, },
> };
> 
> static struct isp_platform_data bastix_isp_platform_data = {
>         .subdevs = bastix_camera_subdevs,
> };
> 
> module_init() {
> ...
> omap3isp_device.dev.platform_data = &bastix_isp_platform_data;
> return platform_device_register(&omap3isp_device);
> }

-- 
Regards,

Laurent Pinchart
