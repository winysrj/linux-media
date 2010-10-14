Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49679 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab0JNNKr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Oct 2010 09:10:47 -0400
Received: by iwn41 with SMTP id 41so812789iwn.19
        for <linux-media@vger.kernel.org>; Thu, 14 Oct 2010 06:10:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201010121458.57150.laurent.pinchart@ideasonboard.com>
References: <AANLkTimyR117ZiHq8GFz4YW5tBtW3k82NzGVZqKoVTbY@mail.gmail.com>
	<201010111707.21537.laurent.pinchart@ideasonboard.com>
	<AANLkTiks9qzC6W4iyu2_QWkWeK-cN-pTOS=trGxeRF=6@mail.gmail.com>
	<201010121458.57150.laurent.pinchart@ideasonboard.com>
Date: Thu, 14 Oct 2010 15:10:46 +0200
Message-ID: <AANLkTim9vaLM20m0=dT5GJSttLBn4KWh1-bv44QnRw92@mail.gmail.com>
Subject: Re: OMAP 3530 camera ISP forks and new media framework
From: Bastian Hecht <hechtb@googlemail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

2010/10/12 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Bastian,
>
> On Tuesday 12 October 2010 14:10:00 Bastian Hecht wrote:
>> 2010/10/11 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>> > On Monday 11 October 2010 16:58:35 Bastian Hecht wrote:
>> >> 2010/10/11 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>> >> > On Monday 11 October 2010 14:59:15 Bastian Hecht wrote:
>> >> >> So... let's see if i got some things right, please let me now if you
>> >> >> disagree:
>> >> >>
>> >> >> - I do want to use the omap34xxcam.c driver as it is for the newest
>> >> >> framework and I get most support for it
>> >> >
>> >> > That's a bad start. With the latest driver, omap34xxcam.c doesn't
>> >> > exist anymore :-)
>> >>
>> >> Nice :S
>> >>
>> >> I think I take the mt9t001 approach (Sorry Guennadi, I think modifying
>> >> your framework is too much for me to start with). So in this driver I
>> >> tell the framework that I can do i2c probing, some subdev_core_ops and
>> >> some subdev_video_ops. I define these functions that mostly do some
>> >> basic i2c communication to the sensor chip. I guess I can handle that
>> >> as there are so many examples out there.
>> >
>> > The best solution would be to add mt9p031 support to the mt9t001 driver.
>> > If that's too difficult to start with, you can copy mt9t001 to mt9p031
>> > and modify the driver as needed and merge the two drivers when you will
>> > be satisfied with the result.
>>
>> OK, now I built the nokia kernel for the omap3-isp and made your
>> mt9t001.c work for it.
>> In mt9t001.c you call i2c_add_driver(&mt9t001_driver);
>> As far I as I figured out the driver core system looks for matches
>> between registered devices in arch/arm/omap/devices.c and appropriate
>> drivers.
>
> The driver core looks for matches between registered drivers and registered
> devices. Devices are registered in lots of places, arch/arm/omap/devices.c is
> only one of them. Board-specific devices are registered (or at least declared)
> in a board file located (for this architecture) in arch/arm/mach-omap2/.
>
>> Is the next step to include a static struct platform_device into
>> devices.c? Or is there a special i2c_device struct that I have to use?
>
> The OMAP3 ISP driver requires platform data that contain, among other
> information, the list of I2C subdevices. Have a look at arch/arm/mach-
> omap2/board-rx51-camera.c.
>

OK, I am closing in :)

I registered the OMAP_ISP device in my board-module. The driver kicks in
[  205.686248] omap3isp omap3isp: Revision 2.0 found

and I can see the device in /sys/devices/platform/omap3isp.
I loaded your slightly modified mt9t001 module under the name mt9p031
and I can find it under
/sys/bus/i2c/drivers/mt9p031
/sys/module/laurentcam/drivers/i2c:mt9p031

But this subdevice-driver doesn't get active (I added alot printk in
the sensor module code, but no probing, nothing happens except the
registration). I have not connected anything to the camera isp
physically, but I think it should find out when probing?
I also see no /dev/videox device from the isp. Can you guide me to
next step? Your help makes it so much easier and I really appreciate
it :)

Thanks,

 Bastian


Here my board code:

static struct mt9t001_platform_data bastix_mt9p031_platform_data = {
        .clk_pol        = 0,
};


static struct i2c_board_info bastix_camera_i2c_devices[] = {
        {
                I2C_BOARD_INFO(MT9P031_NAME, MT9P031_I2C_ADDR), /*
name is "mt9p031" and i2caddr is fantasy number */
                .platform_data = &bastix_mt9p031_platform_data,
        },
};

static struct v4l2_subdev_i2c_board_info bastix_camera_mt9p031[] = {
        {
                .board_info = &bastix_camera_i2c_devices[0],
                .i2c_adapter_id = BASTIX_CAM_I2C_BUS_NUM, /* busnum is 2 */
                .module_name = "mt9p031",
        },
        { NULL, 0, NULL, },
};

static struct isp_v4l2_subdevs_group bastix_camera_subdevs[] = {
        {
                .subdevs = bastix_camera_mt9p031,
                .interface = ISP_INTERFACE_CCP2B_PHY1,
                .bus = { .ccp2 = {
                        .strobe_clk_pol         = 0,
                        .crc                    = 1,
                        .ccp2_mode              = 1,
                        .phy_layer              = 1,
                        .vpclk_div              = 1,
                } },
        },
        { NULL, 0, },
};

static struct isp_platform_data bastix_isp_platform_data = {
        .subdevs = bastix_camera_subdevs,
};

module_init() {
...
omap3isp_device.dev.platform_data = &bastix_isp_platform_data;
return platform_device_register(&omap3isp_device);
}

> --
> Regards,
>
> Laurent Pinchart
>
