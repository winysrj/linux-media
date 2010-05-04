Return-path: <linux-media-owner@vger.kernel.org>
Received: from therealtimegroup.com ([72.22.91.212]:39959 "EHLO
	therealtimegroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954Ab0EDC0f (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 May 2010 22:26:35 -0400
Message-ID: <F528C77ECD244EC8ADEEE5DEF504EB88@RSI45>
Reply-To: "Charles D. Krebs" <ckrebs@therealtimegroup.com>
From: "Charles D. Krebs" <ckrebs@therealtimegroup.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: "Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Magnus Damm" <magnus.damm@gmail.com>
References: <C5F5A45C8EB6446BA837800AC37D53A2@RSI45> <h2laec7e5c31004071719m4a6551c7w8afdca6bdcf49eae@mail.gmail.com> <Pine.LNX.4.64.1004080814370.4621@axis700.grange> <7554DA9455F6445CB94B84859EEDCE57@RSI45> <Pine.LNX.4.64.1004140827550.6386@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1004140827550.6386@axis700.grange>
Subject: Re: CEU / Camera Driver Question
Date: Mon, 3 May 2010 21:26:29 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi,

As per your recommendation I reviewed the "soc_camera_platform" driver, and 
have chosen to implement the new camera by simply modifying it.

Sure enough, I can boot up and properly register a device under /dev/video0.

The camera provides 8-bit Grayscale data corresponding to pixel format 
V4L2_PIX_FMT_GREY.  I can't seem to find any example of a device driver that 
uses this format, so I've been taking my best guess as how to setup 
"soc_camera_platform_info".  So far I have:

static struct soc_camera_platform_info mycam_camera_info = {
	.format_name = "GREY",
	.format_depth = 8,
	.format = {
		.code = V4L2_MBUS_FMT_YUYV8_2X8_BE,
		.colorspace = V4L2_COLORSPACE_JPEG,
		.field = V4L2_FIELD_NONE,
		.width = 320,
		.height = 240,
	},
	.bus_param = SOCAM_PCLK_SAMPLE_RISING | SOCAM_HSYNC_ACTIVE_HIGH |
	SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_MASTER | SOCAM_DATAWIDTH_8 |
	SOCAM_DATA_ACTIVE_HIGH,
};

It looks like I'll need to modify "soc_camera_platform" it in a way to at 
least add a "fourcc" field that can be interpreted by the ceu driver for the 
"sh_mobile_ceu_set_bus_param" call to setup the hardware correctly.

But regardless of how I set this structure up, I don't see any direct 
support for a Grayscale mode data capture in the ceu driver.  For example, 
"sh_mobile_ceu_set_bus_param" does not contain V4L2_PIX_FMT_GREY in its list 
of fourcc formats.  Yet based on the 7724 hardware manual, and from the 
information I have received from Renesas, I'm not seeing any reason why this 
format should not be supported.

Is grayscale somehow supported under the current CEU driver?

Any suggestions on how I might go about implementing support?  I'm having 
trouble seeing the dataflow through the driver at the moment...

Thank you!

Charles Krebs, Embedded Solutions Developer
The Realtime Group

--------------------------------------------------
From: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Sent: Wednesday, April 14, 2010 1:38 AM
To: "Charles D. Krebs" <ckrebs@therealtimegroup.com>
Cc: "Linux Media Mailing List" <linux-media@vger.kernel.org>
Subject: Re: CEU / Camera Driver Question

> Hi Charles
>
> On Tue, 13 Apr 2010, Charles D. Krebs wrote:
>
>> Guennadi,
>>
>> Thank you for the response and explanation.  It falls perfectly in line 
>> with
>> what we had been suspecting on our end.
>>
>> We ended up basing the driver off "mt9t112.c", which is an I2C camera. 
>> The
>> major issues have been figuring out how to remove the I2C components.
>>
>> The driver (attached for reference) currently registers a device under
>> "/sys/bus/platform/drivers/testcam".  However, udev does not populate a
>> "video0" entry under "/dev", so it seems the V4L2 registration wasn't 
>> done
>> correctly.
>
> All my comments will base on the current kernel, so, if you prefer to stay
> with an older one, they will not be (entirely) applicable.
>
>> I'm fairly sure the problem falls under "testcam_probe" or
>> "testcam_module_init".
>>
>> Since we are not I2C, should we call "platform_driver_register" from
>> "testcam_module_init"?
>>
>> Do we need to fill out a link structure from the SOC Camera driver
>> (soc_camera_link)?  I noticed that this is used in all the I2C cameras.
>
> As I see, your driver is just a dummy, that only specifies camera's
> capabilities. That's also ok, you certainly can make a driver for a
> completely fixed-parameter camera, but then a few methods from your driver
> should either disappear, or return an "unsupported" error, or return the
> fixed configuration of the sensor (like s_fmt, try_fmt). Please, have a
> look at drivers/media/video/soc_camera_platform.c, that's an example of an
> soc-camera client driver, not using i2c. I'm not sure if it's working
> presently, it's use kind of discouraged, but you can certainly use it as
> an example. If you don't plan to mainline your driver, you can even
> actually use soc_camera_platform.c, then you'll just need to add some
> platform data for it (see arch/sh/boards/mach-ap325rxa/setup.c and struct
> soc_camera_link camera_link in it for an example). You might have to fix
> that driver slightly, but that shouldn't be too difficult.
>
> Thanks
> Guennadi
>
>>
>> Unfortunately, I still need to figure out how to best integrate with the
>> sh_mobile_ceu_camera driver since I am mid migration from 2.6.31-rc7 to
>> 2.6.33.  It appears that quite a lot has changed...  The Kernel change 
>> has
>> spawned a plethora of issues, which has unfortunately delayed development 
>> on
>> this driver until now.
>>
>> Thanks for your input!
>>
>> Charles Krebs, Embedded Solutions Developer
>> The Realtime Group
>>
>> --------------------------------------------------
>> From: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
>> Sent: Thursday, April 08, 2010 1:39 AM
>> To: "Magnus Damm" <magnus.damm@gmail.com>
>> Cc: "Charles D. Krebs" <ckrebs@therealtimegroup.com>
>> Subject: Re: CEU / Camera Driver Question
>>
>> > Hi Charles
>> >
>> > On Thu, 8 Apr 2010, Magnus Damm wrote:
>> >
>> > > Hi Charles,
>> > >
>> > > Thanks for your email. I am afraid I know too little about the 
>> > > current
>> > > status of the CEU driver and camera sensor integration. I do however 
>> > > know
>> > > one guy that can help you.
>> > >
>> > > Guennadi, can you please give us some recommendations? Charles is 
>> > > using
>> > > 2.6.33 on sh7724, see below.
>> > >
>> > > Thanks!
>> > >
>> > > / magnus
>> > >
>> > > On Apr 6, 2010 10:35 AM, "Charles D. Krebs" 
>> > > <ckrebs@therealtimegroup.com>
>> > > wrote:
>> > >
>> > >  Magnus,
>> > >
>> > > We have been working on integrating our camera into the 7724 
>> > > platform.  I
>> > > think we are pretty close to having the camera up and working at this
>> > > point,
>> > > but there are a few outstanding concerns.
>> >
>> > In the open-source community it is customary to discuss related topics 
>> > and
>> > ask questions on respective mailing lists. So, I'll just give a very 
>> > brief
>> > answer to this your mail, if you get more questions, please CC
>> >
>> > Linux Media Mailing List <linux-media@vger.kernel.org>
>> >
>> > in your naxt mail.
>> >
>> > > The basic objective is to interface a very dumb video camera that 
>> > > connects
>> > > directly to CEU driver in the SH7724 processor.  This camera needs no
>> > > control interface (the interface is actually RS232, which I plan to 
>> > > drive
>> > > completely from user space), but has 8 bit parallel video 
>> > > (Grayscale). The
>> > > camera driver was patterned after the the soc_camera driver, using 
>> > > the
>> > > platform interface.
>> > > Our camera driver is mostly dummy code because of the simplicity.
>> >
>> > The current Linux kernel mainline implementation of the video capture
>> > function on several embedded SoCs, including CEU-based SuperH 
>> > platforms,
>> > is a V4L2 driver stack, consisting of
>> >
>> > 1. a host driver (in this case sh_mobile_ceu_camera.c), using the
>> >   soc-camera API to integrate itself into the V4L framework
>> > 2. the soc-camera core
>> > 3. client drivers, using the v4l2-subdev API for most V4L2 
>> > communication,
>> >   the mediabus API for pixel-format negotiation and a couple of
>> >   soc-camera API extensions.
>> >
>> > So, all you need is use the existing sh_mobile_ceu_camera.c driver, the
>> > soc-camera framework and add a new driver for your camera-sensor, which 
>> > in
>> > your case would be very simple, as you say. Just use any platform,
>> > currently in the mainline (e.g., ecovec) as an example for your 
>> > platform
>> > bindings, and any soc-camera client driver (e.g., mt9m001, or ov772x) 
>> > as a
>> > template for your camera driver.
>> >
>> > There is one point, where you will have to be careful: your camera is 
>> > not
>> > using I2C. soc-camera should support this too, but it hasn't been 
>> > tested
>> > or used for a while, so, something might have bitrotted there.
>> >
>> > So, I would suggest - write a driver, test it and post to the mailing 
>> > list
>> > (you can CC me too, if you like). If you have any questions in the
>> > meantime - don't hesitate to ask, but please cc the list. Regarding 
>> > your
>> > intension to control the sensor from the user-space, however simple 
>> > that
>> > controlling might be, I would seriously consider writing a line 
>> > discipline
>> > for it, which would allow you then use any standard V4L(2) application
>> > with your system. The only addition you would have is a tiny app, that
>> > would open the serial port, set the required line discipline for it and
>> > keep it open for the whole time your video driver is going to be used.
>> >
>> > Thanks
>> > Guennadi
>> >
>> > >
>> > > Questions:
>> > >
>> > > 1. Is soc_camera a reasonable driver to use as a starting point, or 
>> > > is
>> > > there a better choice?
>> > >
>> > > 2. How is the CEU driver associated with the camera driver?
>> > >
>> > > 3. Is there a special bus type ID that needs to be claimed by the 
>> > > camera
>> > > driver?  Standard or custom?
>> > >
>> > > 4.  In /arch/sh/boards/mach-ecovec24/setup.c -
>> > >
>> > > I made quite a few modifications.  Pertaining to the new "testcam" 
>> > > device,
>> > > I
>> > > have:
>> > >
>> > > static struct platform_device camera_devices[] = {
>> > >  {
>> > >   //.name = "soc-camera-pdrv",
>> > >   .name = "testcam",
>> > >   .id = 0,
>> > >   .dev = {
>> > >    .platform_data = &testcam_info2,
>> > >   },
>> > >  },
>> > > static struct testcam_camera_info testcam_info2 = {
>> > >  .flags = 0,
>> > >  .bus_param = 1,
>> > >  };
>> > > The connection from here to our camera driver appears to depend on 
>> > > the
>> > > "name" field of the platform_device structure:
>> > >
>> > > static struct platform_driver testcam_driver =
>> > > {
>> > >  .driver       = {
>> > >   .name = "testcam",
>> > >  },
>> > >  .probe        = testcam_probe,
>> > >  .remove       = testcam_remove,
>> > > };
>> > > In the "mt9t112" driver, it uses the "soc-camera-pdrv".  Should I 
>> > > have
>> > > emulated other functions from the SOC Camera driver such as the link 
>> > > field
>> > > to get the device to connect?  soc_camera_device_register in still 
>> > > called
>> > > in
>> > > our driver's probe function, and in that way, the driver ends up 
>> > > being
>> > > more
>> > > like "mx3_camera.c"
>> > >
>> > > Using the platform driver, the device registers
>> > > in "/sys/bus/platform/drivers/testcam".  However, udev does not 
>> > > populate a
>> > > "video0" entry under "/dev".  What is special about the "mt9t112" 
>> > > driver
>> > > that allows such a registration to take place?
>> > >
>> > > Any other insight regarding how the existing demo drivers were 
>> > > architected
>> > > would be extremely helpful.
>> > >
>> > > Thank you,
>> > >
>> > > Charles Krebs, Embedded Solutions Developer
>> > > The Realtime Group
>> > >
>> >
>> > ---
>> > Guennadi Liakhovetski, Ph.D.
>> > Freelance Open-Source Software Developer
>> > http://www.open-technology.de/
>> >
>
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 

