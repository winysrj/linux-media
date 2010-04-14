Return-path: <linux-media-owner@vger.kernel.org>
Received: from therealtimegroup.com ([72.22.91.212]:39387 "EHLO
	therealtimegroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab0DNCBE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Apr 2010 22:01:04 -0400
Message-ID: <7554DA9455F6445CB94B84859EEDCE57@RSI45>
Reply-To: "Charles D. Krebs" <ckrebs@therealtimegroup.com>
From: "Charles D. Krebs" <ckrebs@therealtimegroup.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: <linux-media@vger.kernel.org>
References: <C5F5A45C8EB6446BA837800AC37D53A2@RSI45> <h2laec7e5c31004071719m4a6551c7w8afdca6bdcf49eae@mail.gmail.com> <Pine.LNX.4.64.1004080814370.4621@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1004080814370.4621@axis700.grange>
Subject: Re: CEU / Camera Driver Question
Date: Tue, 13 Apr 2010 20:54:09 -0500
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_003E_01CADB4B.76B6EBD0"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

------=_NextPart_000_003E_01CADB4B.76B6EBD0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit

Guennadi,

Thank you for the response and explanation.  It falls perfectly in line with 
what we had been suspecting on our end.

We ended up basing the driver off "mt9t112.c", which is an I2C camera.  The 
major issues have been figuring out how to remove the I2C components.

The driver (attached for reference) currently registers a device under 
"/sys/bus/platform/drivers/testcam".  However, udev does not populate a 
"video0" entry under "/dev", so it seems the V4L2 registration wasn't done 
correctly.

I'm fairly sure the problem falls under "testcam_probe" or 
"testcam_module_init".

Since we are not I2C, should we call "platform_driver_register" from 
"testcam_module_init"?

Do we need to fill out a link structure from the SOC Camera driver 
(soc_camera_link)?  I noticed that this is used in all the I2C cameras.

Unfortunately, I still need to figure out how to best integrate with the 
sh_mobile_ceu_camera driver since I am mid migration from 2.6.31-rc7 to 
2.6.33.  It appears that quite a lot has changed...  The Kernel change has 
spawned a plethora of issues, which has unfortunately delayed development on 
this driver until now.

Thanks for your input!

Charles Krebs, Embedded Solutions Developer
The Realtime Group

--------------------------------------------------
From: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Sent: Thursday, April 08, 2010 1:39 AM
To: "Magnus Damm" <magnus.damm@gmail.com>
Cc: "Charles D. Krebs" <ckrebs@therealtimegroup.com>
Subject: Re: CEU / Camera Driver Question

> Hi Charles
>
> On Thu, 8 Apr 2010, Magnus Damm wrote:
>
>> Hi Charles,
>>
>> Thanks for your email. I am afraid I know too little about the current
>> status of the CEU driver and camera sensor integration. I do however know
>> one guy that can help you.
>>
>> Guennadi, can you please give us some recommendations? Charles is using
>> 2.6.33 on sh7724, see below.
>>
>> Thanks!
>>
>> / magnus
>>
>> On Apr 6, 2010 10:35 AM, "Charles D. Krebs" <ckrebs@therealtimegroup.com>
>> wrote:
>>
>>  Magnus,
>>
>> We have been working on integrating our camera into the 7724 platform.  I
>> think we are pretty close to having the camera up and working at this 
>> point,
>> but there are a few outstanding concerns.
>
> In the open-source community it is customary to discuss related topics and
> ask questions on respective mailing lists. So, I'll just give a very brief
> answer to this your mail, if you get more questions, please CC
>
> Linux Media Mailing List <linux-media@vger.kernel.org>
>
> in your naxt mail.
>
>> The basic objective is to interface a very dumb video camera that 
>> connects
>> directly to CEU driver in the SH7724 processor.  This camera needs no
>> control interface (the interface is actually RS232, which I plan to drive
>> completely from user space), but has 8 bit parallel video (Grayscale). 
>> The
>> camera driver was patterned after the the soc_camera driver, using the
>> platform interface.
>> Our camera driver is mostly dummy code because of the simplicity.
>
> The current Linux kernel mainline implementation of the video capture
> function on several embedded SoCs, including CEU-based SuperH platforms,
> is a V4L2 driver stack, consisting of
>
> 1. a host driver (in this case sh_mobile_ceu_camera.c), using the
>   soc-camera API to integrate itself into the V4L framework
> 2. the soc-camera core
> 3. client drivers, using the v4l2-subdev API for most V4L2 communication,
>   the mediabus API for pixel-format negotiation and a couple of
>   soc-camera API extensions.
>
> So, all you need is use the existing sh_mobile_ceu_camera.c driver, the
> soc-camera framework and add a new driver for your camera-sensor, which in
> your case would be very simple, as you say. Just use any platform,
> currently in the mainline (e.g., ecovec) as an example for your platform
> bindings, and any soc-camera client driver (e.g., mt9m001, or ov772x) as a
> template for your camera driver.
>
> There is one point, where you will have to be careful: your camera is not
> using I2C. soc-camera should support this too, but it hasn't been tested
> or used for a while, so, something might have bitrotted there.
>
> So, I would suggest - write a driver, test it and post to the mailing list
> (you can CC me too, if you like). If you have any questions in the
> meantime - don't hesitate to ask, but please cc the list. Regarding your
> intension to control the sensor from the user-space, however simple that
> controlling might be, I would seriously consider writing a line discipline
> for it, which would allow you then use any standard V4L(2) application
> with your system. The only addition you would have is a tiny app, that
> would open the serial port, set the required line discipline for it and
> keep it open for the whole time your video driver is going to be used.
>
> Thanks
> Guennadi
>
>>
>> Questions:
>>
>> 1. Is soc_camera a reasonable driver to use as a starting point, or is
>> there a better choice?
>>
>> 2. How is the CEU driver associated with the camera driver?
>>
>> 3. Is there a special bus type ID that needs to be claimed by the camera
>> driver?  Standard or custom?
>>
>> 4.  In /arch/sh/boards/mach-ecovec24/setup.c -
>>
>> I made quite a few modifications.  Pertaining to the new "testcam" 
>> device, I
>> have:
>>
>> static struct platform_device camera_devices[] = {
>>  {
>>   //.name = "soc-camera-pdrv",
>>   .name = "testcam",
>>   .id = 0,
>>   .dev = {
>>    .platform_data = &testcam_info2,
>>   },
>>  },
>> static struct testcam_camera_info testcam_info2 = {
>>  .flags = 0,
>>  .bus_param = 1,
>>  };
>> The connection from here to our camera driver appears to depend on the
>> "name" field of the platform_device structure:
>>
>> static struct platform_driver testcam_driver =
>> {
>>  .driver       = {
>>   .name = "testcam",
>>  },
>>  .probe        = testcam_probe,
>>  .remove       = testcam_remove,
>> };
>> In the "mt9t112" driver, it uses the "soc-camera-pdrv".  Should I have
>> emulated other functions from the SOC Camera driver such as the link 
>> field
>> to get the device to connect?  soc_camera_device_register in still called 
>> in
>> our driver's probe function, and in that way, the driver ends up being 
>> more
>> like "mx3_camera.c"
>>
>> Using the platform driver, the device registers
>> in "/sys/bus/platform/drivers/testcam".  However, udev does not populate 
>> a
>> "video0" entry under "/dev".  What is special about the "mt9t112" driver
>> that allows such a registration to take place?
>>
>> Any other insight regarding how the existing demo drivers were 
>> architected
>> would be extremely helpful.
>>
>> Thank you,
>>
>> Charles Krebs, Embedded Solutions Developer
>> The Realtime Group
>>
>
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 
------=_NextPart_000_003E_01CADB4B.76B6EBD0
Content-Type: text/plain;
	format=flowed;
	name="testcam.c";
	reply-type=original
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="testcam.c"

/*
 * testcam Camera Driver
 *
 * Copyright (C) 2010
 * Based on the Generic Platform Camera Driver
 * Copyright (C) 2010
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <linux/init.h>
#include <linux/module.h>
#include <linux/slab.h>
#include <linux/delay.h>
#include <linux/platform_device.h>
#include <linux/videodev2.h>
#include <media/v4l2-common.h>
#include <media/v4l2-chip-ident.h>
#include <media/soc_camera.h>
#include <media/testcam.h>

/*
 * max frame size
 */
#define MAX_WIDTH   320
#define MAX_HEIGHT  240

/* flags for testcam_priv :: flags */
#define INIT_DONE  (1<<0)


struct testcam_priv
{
	struct testcam_camera_info       *info;
	struct soc_camera_device               icd;
	int                                    model;
};


/* =
------------------------------------------------------------------------
*/
/*
 * supported format list (only one supported entry, for 8 bit greyscale)
 */
/* =
------------------------------------------------------------------------
*/
#define COL_FMT(_name, _depth, _fourcc, _colorspace)		\
	{ .name =3D _name, .depth =3D _depth, .fourcc =3D _fourcc,	\
			.colorspace =3D _colorspace }

#define RGB_FMT(_name, _depth, _fourcc)				\
	COL_FMT(_name, _depth, V4L2_PIX_FMT_ ## _fourcc, V4L2_COLORSPACE_SRGB)

static const struct soc_camera_data_format testcam_fmt_lists [] =3D
{
	RGB_FMT("Monochrome 8 bit", 8, NV12)
//	RGB_FMT("Monochrome 8 bit", 8, GREY)	// Changed to repurpose NV12
};

/* =
------------------------------------------------------------------------
*/
/*
 * general functions
 */
/* =
------------------------------------------------------------------------
*/
static inline struct testcam_camera_info *
soc_camera_platform_get_info(struct soc_camera_device *icd)
{
	struct testcam_priv *priv;
	priv =3D container_of(icd, struct testcam_priv, icd);
	return priv->info;
}

/* =
------------------------------------------------------------------------
*/
static int testcam_check_frame(u16 width, u16 height)
{
	return ((height !=3D MAX_HEIGHT)  ||  (width !=3D MAX_WIDTH));
}

/* =
------------------------------------------------------------------------
*/
static int testcam_get_chipID(struct soc_camera_device *icd)
{
	return 0x1234;
}

/* =
------------------------------------------------------------------------
*/
static int testcam_reset(struct soc_camera_device *icd)
{
	return (0);
}

/* =
------------------------------------------------------------------------
*/
/*
 * soc_camera_ops functions
 */
/* =
------------------------------------------------------------------------
*/
static int testcam_init(struct soc_camera_device *icd)
{
	struct testcam_camera_info *info =3D soc_camera_platform_get_info(icd);
	int ret =3D 0;

//	if (info->power)
//		ret =3D info->power(1);

	return ret;
}

/* =
------------------------------------------------------------------------
*/
static int testcam_release(struct soc_camera_device *icd)
{
	struct testcam_camera_info *info =3D soc_camera_platform_get_info(icd);

//	if (info->power)
//		info->power(0);

	return 0;
}

/* =
------------------------------------------------------------------------
*/
static int testcam_start_capture(struct soc_camera_device *icd)
{
	struct testcam_camera_info *info =3D soc_camera_platform_get_info(icd);

	if (!(info->flags & INIT_DONE)) {
		dev_err(&icd->dev, "device init isn't done\n");
		return -EINVAL;
	}

	dev_info(&icd->dev, "size   : QVGA (%d x %d)\n", MAX_WIDTH, =
MAX_HEIGHT);

	return 0;
}

/* =
------------------------------------------------------------------------
*/
static int testcam_stop_capture(struct soc_camera_device *icd)
{
//	struct testcam_camera_info *info =3D =
soc_camera_platform_get_info(icd);
// not supported; only single frame capture is supported
	return 0;
}

/* =
------------------------------------------------------------------------
*/
static int testcam_set_bus_param(struct soc_camera_device *icd,
				      unsigned long		flags)
{
//	struct testcam_camera_info *info =3D =
soc_camera_platform_get_info(icd);
// nothing to do here
	return 0;
}

/* =
------------------------------------------------------------------------
*/
static unsigned long testcam_query_bus_param(struct soc_camera_device =
*icd)
{
	struct testcam_camera_info *info =3D soc_camera_platform_get_info(icd);
	unsigned long flags =3D SOCAM_MASTER | SOCAM_VSYNC_ACTIVE_HIGH |
			      SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_DATA_ACTIVE_HIGH |
			      SOCAM_DATAWIDTH_8;

	info->flags =3D (info->flags & INIT_DONE) | flags;

	return info->bus_param;
}

/* =
------------------------------------------------------------------------
*/
static int testcam_get_control(struct soc_camera_device *icd,
			      struct v4l2_control *ctrl)
{
//	struct testcam_camera_info *info =3D =
soc_camera_platform_get_info(icd);
// not supported
	return 0;
}

/* =
------------------------------------------------------------------------
*/
static int testcam_set_control(struct soc_camera_device *icd,
			      struct v4l2_control *ctrl)
{
//	struct testcam_camera_info *info =3D =
soc_camera_platform_get_info(icd);
// not supported
	return 0;
}

/* =
------------------------------------------------------------------------
*/
static int testcam_get_chip_id(struct soc_camera_device *icd,
			      struct v4l2_dbg_chip_ident   *id)
{
	struct testcam_priv *priv =3D container_of(icd, struct testcam_priv, =
icd);

	id->ident    =3D priv->model;
	id->revision =3D 0;

	return 0;
}

/* =
------------------------------------------------------------------------
*/
#ifdef CONFIG_VIDEO_ADV_DEBUG
static int testcam_get_register(struct soc_camera_device *icd,
			       struct v4l2_dbg_register *reg)
{
// not supported
	return 0;
}

/* =
------------------------------------------------------------------------
*/
static int testcam_set_register(struct soc_camera_device *icd,
			       struct v4l2_dbg_register *reg)
{
// not supported
	return testcam_reg_write(icd, reg->reg, reg->val);
}
#endif
/* =
------------------------------------------------------------------------
*/
static int testcam_init_camera(struct soc_camera_device *icd)
{
	int ret =3D testcam_reset(icd);

	return ret;
}

/* =
------------------------------------------------------------------------
*/
static int testcam_set_params(struct soc_camera_device *icd,
			      u32 width, u32 height, u32 pixfmt)
{
	struct testcam_priv *priv =3D container_of(icd, struct testcam_priv, =
icd);
	int ret;

	/*
	 * check frame size
	 */
	if (testcam_check_frame(width, height))
		return -EINVAL;

	/*
	 * testcam should init in 1st time.
	 */
	if (!(priv->info->flags & INIT_DONE)) {
		if (!(ret =3D testcam_init_camera(icd)))
			return ret;
		priv->info->flags |=3D INIT_DONE;
	}

	return 0;
}

/* =
------------------------------------------------------------------------
*/
static int testcam_set_crop(struct soc_camera_device *icd,
				 struct v4l2_rect *rect)
{
// not supported
	return 0;
}

/* =
------------------------------------------------------------------------
*/
static int testcam_set_fmt(struct soc_camera_device *icd,
			  struct v4l2_format *f)
{
	struct v4l2_pix_format *pix =3D &f->fmt.pix;

	return testcam_set_params(icd, pix->width, pix->height,
				 pix->pixelformat);
}

/* =
------------------------------------------------------------------------
*/
static int testcam_try_fmt(struct soc_camera_device  *icd,
				struct v4l2_format        *f)
{
	struct v4l2_pix_format  *pix =3D &f->fmt.pix;

	/*
	 * check frame size
	 */
	if (testcam_check_frame(pix->width, pix->height))
		return -EINVAL;

	pix->field =3D V4L2_FIELD_NONE;

	return 0;
}

/* =
------------------------------------------------------------------------
*/
static int testcam_camera_probe(struct soc_camera_device *icd)
{
	struct testcam_priv *priv =3D container_of(icd, struct testcam_priv, =
icd);
	const char               *devname;
	int                       chipid;

	/*
	 * check and show chip ID
	 */

	chipid		 =3D testcam_get_chipID(icd);
	devname		 =3D "testcam";
	priv->model	 =3D V4L2_IDENT_UNKNOWN;
	icd->formats     =3D testcam_fmt_lists;
	icd->num_formats =3D ARRAY_SIZE(testcam_fmt_lists);

	dev_info(&icd->dev,
		 "%s chip ID %04x\n", devname, chipid);

	return soc_camera_video_start(icd);
}

/* =
------------------------------------------------------------------------
*/
static void testcam_camera_remove(struct soc_camera_device *icd)
{
	soc_camera_video_stop(icd);
}

/* =
------------------------------------------------------------------------
*/
static struct soc_camera_ops testcam_ops =3D
{
	.owner			=3D THIS_MODULE,
	.probe			=3D testcam_camera_probe,
	.remove			=3D testcam_camera_remove,
	.init			=3D testcam_init,
	.release		=3D testcam_release,
	.start_capture		=3D testcam_start_capture,
	.stop_capture		=3D testcam_stop_capture,
	.set_crop		=3D testcam_set_crop,
	.set_fmt		=3D testcam_set_fmt,
	.try_fmt		=3D testcam_try_fmt,
	.set_bus_param		=3D testcam_set_bus_param,
	.query_bus_param	=3D testcam_query_bus_param,
	.get_control		=3D testcam_get_control,
	.set_control		=3D testcam_set_control,
	.get_chip_id		=3D testcam_get_chip_id,
#ifdef CONFIG_VIDEO_ADV_DEBUG
	.get_register		=3D testcam_get_register,
	.set_register		=3D testcam_set_register,
#endif
};

/* =
------------------------------------------------------------------------
*/
/*
 * platform functions
 */
/* =
------------------------------------------------------------------------
*/
static int testcam_probe(struct platform_device *pdev)
{
	struct testcam_priv        *priv;
	struct testcam_camera_info *info;
	struct soc_camera_device        *icd;
	int                              ret;

	info =3D pdev->dev.platform_data;
	if (!info)
		return -EINVAL;

	priv =3D kzalloc(sizeof(*priv), GFP_KERNEL);
	if (!priv)
		return -ENOMEM;

	priv->info =3D info;
	platform_set_drvdata(pdev, priv);

	icd             =3D &priv->icd;
	icd->ops	=3D &testcam_ops;
	icd->control	=3D &pdev->dev;
	icd->width_min	=3D MAX_WIDTH;
	icd->width_max	=3D MAX_WIDTH;
	icd->height_min	=3D MAX_HEIGHT;
	icd->height_max	=3D MAX_HEIGHT;
	icd->y_skip_top	=3D 0;
	icd->iface	=3D priv->info->iface;

	ret =3D soc_camera_device_register(icd);
	if (ret)
		kfree(priv);

	return ret;
}

/* =
------------------------------------------------------------------------
*/
static int testcam_remove(struct platform_device *pdev)
{
	struct testcam_priv *priv =3D platform_get_drvdata(pdev);

	soc_camera_device_unregister(&priv->icd);
	kfree(priv);
	return 0;
}

/* =
------------------------------------------------------------------------
*/
static struct platform_driver testcam_driver =3D
{
	.driver       =3D {
		.name =3D "testcam",
	},
	.probe        =3D testcam_probe,
	.remove       =3D testcam_remove,
};
/* =
------------------------------------------------------------------------
*/
/*
 * module functions
 */
/* =
------------------------------------------------------------------------
*/
static int __init testcam_module_init(void)
{
	return platform_driver_register(&testcam_driver);
}

/* =
------------------------------------------------------------------------
*/
static void __exit testcam_module_exit(void)
{
	platform_driver_unregister(&testcam_driver);
}

/* =
------------------------------------------------------------------------
*/
module_init(testcam_module_init);
module_exit(testcam_module_exit);

MODULE_DESCRIPTION("SoC Camera driver for testcam");
MODULE_AUTHOR("CK");
MODULE_LICENSE("GPL v2");

------=_NextPart_000_003E_01CADB4B.76B6EBD0
Content-Type: text/plain;
	format=flowed;
	name="testcam.h";
	reply-type=original
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="testcam.h"

/*
 * TestCam Camera Driver Header
 *
 * Copyright (C) 2010
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#ifndef __TESTCAM_H__
#define __TESTCAM_H__

#include <linux/videodev2.h>

/*
 * lanternshark camera info
 */
struct lanternshark_camera_info {
	u32                     flags;
	int                     iface;
	unsigned long           bus_param;
	struct soc_camera_link link;

#endif /* __TESTCAM_H__ */

------=_NextPart_000_003E_01CADB4B.76B6EBD0--


