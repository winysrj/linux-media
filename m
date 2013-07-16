Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor1.renesas.com ([210.160.252.171]:49514 "EHLO
	relmlor1.renesas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280Ab3GPNyw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jul 2013 09:54:52 -0400
Received: from relmlir4.idc.renesas.com ([10.200.68.154])
 by relmlor1.idc.renesas.com ( SJSMS)
 with ESMTP id <0MQ100EVK7ZFXS40@relmlor1.idc.renesas.com> for
 linux-media@vger.kernel.org; Tue, 16 Jul 2013 22:54:51 +0900 (JST)
Received: from relmlac1.idc.renesas.com ([10.200.69.21])
 by relmlir4.idc.renesas.com ( SJSMS)
 with ESMTP id <0MQ100IWF7ZFEDC0@relmlir4.idc.renesas.com> for
 linux-media@vger.kernel.org; Tue, 16 Jul 2013 22:54:51 +0900 (JST)
In-reply-to: <2789438.CYsMhV4y8P@avalon>
References: <CAGGh5h1btafaMoaB89RBND2L8+Zg767HW3+hKG7Xcq2fsEN6Ew@mail.gmail.com>
 <1370423495-16784-1-git-send-email-phil.edworthy@renesas.com>
 <2789438.CYsMhV4y8P@avalon>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Jean-Philippe Francois <jp.francois@cynove.com>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-version: 1.0
From: phil.edworthy@renesas.com
Message-id: <OFFCCBF395.6ECC99A5-ON80257BAA.004C2329-80257BAA.004C6AA9@eu.necel.com>
Date: Tue, 16 Jul 2013 14:54:41 +0100
Subject: Re: [PATCH v3] ov10635: Add OmniVision ov10635 SoC camera driver
Content-type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

> From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> To: Phil Edworthy <phil.edworthy@renesas.com>, 
> Cc: linux-media@vger.kernel.org, Jean-Philippe Francois 
> <jp.francois@cynove.com>, Hans Verkuil <hverkuil@xs4all.nl>, Guennadi 
> Liakhovetski <g.liakhovetski@gmx.de>, Mauro Carvalho Chehab 
<mchehab@redhat.com>
> Date: 16/07/2013 13:05
> Subject: Re: [PATCH v3] ov10635: Add OmniVision ov10635 SoC camera 
driver
> 
> Hi Phil,
> 
> Thank you for the patch.
> 
> On Wednesday 05 June 2013 10:11:35 Phil Edworthy wrote:
> > Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
> > ---
> > v3:
> >  - Removed dupplicated writes to reg 0x3042
> >  - Program all the standard registers after checking the ID
> > 
> > v2:
> >  - Simplified flow in ov10635_s_ctrl.
> >  - Removed chip ident code - build tested only
> > 
> >  drivers/media/i2c/soc_camera/Kconfig   |    6 +
> >  drivers/media/i2c/soc_camera/Makefile  |    1 +
> >  drivers/media/i2c/soc_camera/ov10635.c | 1134 
+++++++++++++++++++++++++++++
> >  3 files changed, 1141 insertions(+)
> >  create mode 100644 drivers/media/i2c/soc_camera/ov10635.c
> > 
> > diff --git a/drivers/media/i2c/soc_camera/Kconfig
> > b/drivers/media/i2c/soc_camera/Kconfig index 23d352f..db97ee6 100644
> > --- a/drivers/media/i2c/soc_camera/Kconfig
> > +++ b/drivers/media/i2c/soc_camera/Kconfig
> > @@ -74,6 +74,12 @@ config SOC_CAMERA_OV9740
> >     help
> >       This is a ov9740 camera driver
> > 
> > +config SOC_CAMERA_OV10635
> > +   tristate "ov10635 camera support"
> > +   depends on SOC_CAMERA && I2C
> > +   help
> > +     This is an OmniVision ov10635 camera driver
> > +
> >  config SOC_CAMERA_RJ54N1
> >     tristate "rj54n1cb0c support"
> >     depends on SOC_CAMERA && I2C
> > diff --git a/drivers/media/i2c/soc_camera/Makefile
> > b/drivers/media/i2c/soc_camera/Makefile index d0421fe..f3d3403 100644
> > --- a/drivers/media/i2c/soc_camera/Makefile
> > +++ b/drivers/media/i2c/soc_camera/Makefile
> > @@ -10,5 +10,6 @@ obj-$(CONFIG_SOC_CAMERA_OV6650)      += ov6650.o
> >  obj-$(CONFIG_SOC_CAMERA_OV772X)      += ov772x.o
> >  obj-$(CONFIG_SOC_CAMERA_OV9640)      += ov9640.o
> >  obj-$(CONFIG_SOC_CAMERA_OV9740)      += ov9740.o
> > +obj-$(CONFIG_SOC_CAMERA_OV10635)   += ov10635.o
> >  obj-$(CONFIG_SOC_CAMERA_RJ54N1)      += rj54n1cb0c.o
> >  obj-$(CONFIG_SOC_CAMERA_TW9910)      += tw9910.o
> > diff --git a/drivers/media/i2c/soc_camera/ov10635.c
> > b/drivers/media/i2c/soc_camera/ov10635.c new file mode 100644
> > index 0000000..064cc7b
> > --- /dev/null
> > +++ b/drivers/media/i2c/soc_camera/ov10635.c
> > @@ -0,0 +1,1134 @@
> > +/*
> > + * OmniVision OV10635 Camera Driver
> > + *
> > + * Copyright (C) 2013 Phil Edworthy
> > + * Copyright (C) 2013 Renesas Electronics
> > + *
> > + * This driver has been tested at QVGA, VGA and 720p, and 1280x800 at 
up to
> > + * 30fps and it should work at any resolution in between and any 
frame
> > rate + * up to 30fps.
> > + *
> > + * FIXME:
> > + *  Horizontal flip (mirroring) does not work correctly. The image is
> > flipped, + *  but the colors are wrong.
> > + *
> > + * This program is free software; you can redistribute it and/or 
modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + */
> > +
> > +#include <linux/delay.h>
> > +#include <linux/i2c.h>
> > +#include <linux/init.h>
> > +#include <linux/module.h>
> > +#include <linux/slab.h>
> > +#include <linux/v4l2-mediabus.h>
> > +#include <linux/videodev2.h>
> > +
> > +#include <media/soc_camera.h>
> > +#include <media/v4l2-common.h>
> > +#include <media/v4l2-ctrls.h>
> > +
> > +/* Register definitions */
> > +#define   OV10635_VFLIP         0x381c
> > +#define    OV10635_VFLIP_ON      (0x3 << 6)
> > +#define    OV10635_VFLIP_SUBSAMPLE   0x1
> > +#define   OV10635_HMIRROR         0x381d
> > +#define    OV10635_HMIRROR_ON      0x3
> > +#define OV10635_PID         0x300a
> > +#define OV10635_VER         0x300b
> > +
> > +/* IDs */
> > +#define OV10635_VERSION_REG      0xa635
> > +#define OV10635_VERSION(pid, ver)   (((pid) << 8) | ((ver) & 0xff))
> > +
> > +#define OV10635_SENSOR_WIDTH      1312
> > +#define OV10635_SENSOR_HEIGHT      814
> > +
> > +#define OV10635_MAX_WIDTH      1280
> > +#define OV10635_MAX_HEIGHT      800
> > +
> > +struct ov10635_color_format {
> > +   enum v4l2_mbus_pixelcode code;
> > +   enum v4l2_colorspace colorspace;
> > +};
> > +
> > +struct ov10635_reg {
> > +   u16   reg;
> > +   u8   val;
> > +};
> > +
> > +struct ov10635_priv {
> > +   struct v4l2_subdev   subdev;
> > +   struct v4l2_ctrl_handler   hdl;
> > +   int         xvclk;
> > +   int         fps_numerator;
> > +   int         fps_denominator;
> > +   const struct ov10635_color_format   *cfmt;
> > +   int         width;
> > +   int         height;
> > +};
> > +
> > +/* default register setup */
> > +static const struct ov10635_reg ov10635_regs_default[] = {
> > +   { 0x0103, 0x01 }, { 0x301b, 0xff }, { 0x301c, 0xff }, { 0x301a, 
0xff },
<snip>

> > +   { 0xc35c, 0x00 }, { 0xc4bc, 0x01 }, { 0xc4bd, 0x60 }, { 0x5608, 
0x0d },
> > +};
> > +
> > +static const struct ov10635_reg ov10635_regs_change_mode[] = {
> > +   { 0x301b, 0xff }, { 0x301c, 0xff }, { 0x301a, 0xff }, { 0x5005, 
0x08 },
> > +   { 0x3007, 0x01 }, { 0x381c, 0x00 }, { 0x381f, 0x0C }, { 0x4001, 
0x04 },
> > +   { 0x4004, 0x08 }, { 0x4050, 0x20 }, { 0x4051, 0x22 }, { 0x6e47, 
0x0C },
> > +   { 0x4610, 0x05 }, { 0x4613, 0x10 },
> > +};
> > +
> > +static const struct ov10635_reg ov10635_regs_bt656[] = {
> > +   { 0x4700, 0x02 }, { 0x4302, 0x03 }, { 0x4303, 0xf8 }, { 0x4304, 
0x00 },
> > +   { 0x4305, 0x08 }, { 0x4306, 0x03 }, { 0x4307, 0xf8 }, { 0x4308, 
0x00 },
> > +   { 0x4309, 0x08 },
> > +};
> > +
> > +static const struct ov10635_reg ov10635_regs_bt656_10bit[] = {
> > +   { 0x4700, 0x02 }, { 0x4302, 0x03 }, { 0x4303, 0xfe }, { 0x4304, 
0x00 },
> > +   { 0x4305, 0x02 }, { 0x4306, 0x03 }, { 0x4307, 0xfe }, { 0x4308, 
0x00 },
> > +   { 0x4309, 0x02 },
> > +};
> > +
> > +static const struct ov10635_reg ov10635_regs_vert_sub_sample[] = {
> > +   { 0x381f, 0x06 }, { 0x4001, 0x02 }, { 0x4004, 0x02 }, { 0x4050, 
0x10 },
> > +   { 0x4051, 0x11 }, { 0x6e47, 0x06 }, { 0x4610, 0x03 }, { 0x4613, 
0x0a },
> > +};
> > +
> > +static const struct ov10635_reg ov10635_regs_enable[] = {
> > +   { 0x3042, 0xf0 }, { 0x301b, 0xf0 }, { 0x301c, 0xf0 }, { 0x301a, 
0xf0 },
> > +};
> 
> Could you please define macros for register addresses and values ? I 
know it's 
> quite a bit of boring work, but without that maintening the driver would 
be 
> pretty difficult.
I will ask OmniVision if I can provide the register names. However, I 
assume you don't mean I should define macros for all of the registers in 
the ov10635_regs_default array?

Thanks
Phil
