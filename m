Return-path: <mchehab@pedra>
Received: from mail.meprolight.com ([194.90.149.17]:39717 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754496Ab1F2QTS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 12:19:18 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>
CC: "'Sakari Ailus'" <sakari.ailus@iki.fi>,
	"'Michael Jones'" <michael.jones@matrix-vision.de>,
	"'linux-media@vger.kernel.org'" <linux-media@vger.kernel.org>,
	"'agersh@rambler.ru'" <agersh@rambler.ru>
Date: Wed, 29 Jun 2011 19:16:43 +0300
Subject: RE: FW: OMAP 3 ISP
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2A5D211E44@MEP-EXCH.meprolight.com>
In-Reply-To: <201106291755.07304.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



-----Original Message-----
From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
Sent: Wednesday, June 29, 2011 6:55 PM
To: Alex Gershgorin
Cc: 'Sakari Ailus'; 'Michael Jones'; 'linux-media@vger.kernel.org'; 'agersh@rambler.ru'
Subject: Re: FW: OMAP 3 ISP

Hi Alex,

On Wednesday 29 June 2011 15:50:54 Alex Gershgorin wrote:
> On Wednesday, June 29, 2011 2:33 PM Laurent Pinchart wrote:
> > On Wednesday 29 June 2011 13:18:10 Alex Gershgorin wrote:
> > >
> > > From previous correspondence:
> > >
> > > My video source is not the video camera and performs many other
> > > functions.
> > >
> > > For this purpose I have RS232 port.
> > >
> > > As for the video, it runs continuously and is not subject to control
> > > except for the power supply.
> > >
> > > > As a quick hack, you can create an I2C driver for your video source
> > > > that doesn't access the device and just returns fixed format and frame
> > > > size.
> > > >
> > > > The correct fix is to implement support for platform subdevs in the
> > > > V4L2 core.
> > >
> > > Yes, I wrote a simple driver, now it looks like this:
> > >
> > > [    2.029754] Linux media interface: v0.10
> > > [    2.034851] Linux video capture interface: v2.00
> > > [    2.041015] My_probe I2C subdev probed

[snip]

> > > [    2.047058] omap3isp omap3isp: Revision 2.0 found
> > > [    2.052307] omap-iommu omap-iommu.0: isp: version 1.1
> > > [    2.069854] i2c i2c-3: Failed to register i2c client my-te at 0x21
> > > -16)
> >
> > Make sure you don't already have an I2C device at address 0x21 on the same
> > bus.

[snip]

> Here is my platform device registration
>
> #define SENSOR_I2C_BUS_NUM    3
>
> static struct i2c_board_info __initdata camera_i2c_devices[] = {
>       {
>              I2C_BOARD_INFO("my-te", 0x21),
>       },
> };
>
> static struct isp_subdev_i2c_board_info camera_i2c_subdevs[] = {
>       {
>             .board_info = &camera_i2c_devices[0],
>             .i2c_adapter_id = SENSOR_I2C_BUS_NUM,
>       },
>       { NULL, 0, },
> };
>
> static struct isp_v4l2_subdevs_group camera_subdevs[] = {
>       {
>             .subdevs = camera_i2c_subdevs,
>             .interface = ISP_INTERFACE_PARALLEL,
>             .bus = {
>                   .parallel = {
>                         .data_lane_shift = 1,
>                         .clk_pol = 0,
>                         .hs_pol  = 0,
>                         .vs_pol  = 0,
>                         .bridge = ISPCTRL_PAR_BRIDGE_DISABLE,
>                   }
>             },
>       },
>       {},
> };
>
> static struct isp_platform_data isp_platform_data = {
>       .subdevs = camera_subdevs,
> };
>
> int __init camera_init(void)
> {
> omap_register_i2c_bus(3,camera_i2c_devices,ARRAY_SIZE(camera_i2c_devices))
> ;

Doesn't omap_register_i2c_bus() take 4 arguments ?

Anyway, you must not register the I2C devices here, they will be registered by
the OMAP3 ISP driver. You still need to register the bus though, with the last
two arguments sets to NULL, 0.

> return omap3_init_camera(&isp_platform_data);
> }

--
Regards,

Laurent Pinchart


__________ Information from ESET NOD32 Antivirus, version of virus signature database 6250 (20110629) __________

The message was checked by ESET NOD32 Antivirus.

http://www.eset.com



__________ Information from ESET NOD32 Antivirus, version of virus signature database 6250 (20110629) __________

The message was checked by ESET NOD32 Antivirus.

http://www.eset.com

