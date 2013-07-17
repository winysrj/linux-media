Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60650 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab3GQKjk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jul 2013 06:39:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: phil.edworthy@renesas.com
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Jean-Philippe Francois <jp.francois@cynove.com>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v3] ov10635: Add OmniVision ov10635 SoC camera driver
Date: Wed, 17 Jul 2013 12:40:23 +0200
Message-ID: <2551685.bvvVTulDIc@avalon>
In-Reply-To: <OFFCCBF395.6ECC99A5-ON80257BAA.004C2329-80257BAA.004C6AA9@eu.necel.com>
References: <CAGGh5h1btafaMoaB89RBND2L8+Zg767HW3+hKG7Xcq2fsEN6Ew@mail.gmail.com> <2789438.CYsMhV4y8P@avalon> <OFFCCBF395.6ECC99A5-ON80257BAA.004C2329-80257BAA.004C6AA9@eu.necel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Phil,

On Tuesday 16 July 2013 14:54:41 phil.edworthy@renesas.com wrote:
> On 16/07/2013 13:05 Laurent Pinchart wrote:
> > On Wednesday 05 June 2013 10:11:35 Phil Edworthy wrote:
> > > Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
> > > ---
> > > 
> > > v3:
> > >  - Removed dupplicated writes to reg 0x3042
> > >  - Program all the standard registers after checking the ID
> > > 
> > > v2:
> > >  - Simplified flow in ov10635_s_ctrl.
> > >  - Removed chip ident code - build tested only
> > >  
> > >  drivers/media/i2c/soc_camera/Kconfig   |    6 +
> > >  drivers/media/i2c/soc_camera/Makefile  |    1 +
> > >  drivers/media/i2c/soc_camera/ov10635.c | 1134 +++++++++++++++++++++++++ 
> > >  3 files changed, 1141 insertions(+)
> > >  create mode 100644 drivers/media/i2c/soc_camera/ov10635.c

[snip]

> > > diff --git a/drivers/media/i2c/soc_camera/ov10635.c
> > > b/drivers/media/i2c/soc_camera/ov10635.c new file mode 100644
> > > index 0000000..064cc7b
> > > --- /dev/null
> > > +++ b/drivers/media/i2c/soc_camera/ov10635.c
> > > @@ -0,0 +1,1134 @@
> > > +/*
> > > + * OmniVision OV10635 Camera Driver
> > > + *
> > > + * Copyright (C) 2013 Phil Edworthy
> > > + * Copyright (C) 2013 Renesas Electronics
> > > + *
> > > + * This driver has been tested at QVGA, VGA and 720p, and 1280x800 at
> > > + * up to 30fps and it should work at any resolution in between and any
> > > + * frame rate up to 30fps.
> > > + *
> > > + * FIXME:
> > > + *  Horizontal flip (mirroring) does not work correctly. The image is
> > > + *  flipped, but the colors are wrong.

Have you checked whether this could be fixed by shifting the crop rectangle by 
one pixel ? Color issues with flipping are usually due to the fact that 
flipping modifies the Bayer pattern.

> > > + *
> > > + * This program is free software; you can redistribute it and/or
> > > + * modify it under the terms of the GNU General Public License version
> > > + * 2 as published by the Free Software Foundation.
> > > + *
> > > + */
> > > +
> > > +#include <linux/delay.h>
> > > +#include <linux/i2c.h>
> > > +#include <linux/init.h>
> > > +#include <linux/module.h>
> > > +#include <linux/slab.h>
> > > +#include <linux/v4l2-mediabus.h>
> > > +#include <linux/videodev2.h>
> > > +
> > > +#include <media/soc_camera.h>
> > > +#include <media/v4l2-common.h>
> > > +#include <media/v4l2-ctrls.h>
> > > +
> > > +/* Register definitions */
> > > +#define   OV10635_VFLIP         0x381c
> > > +#define    OV10635_VFLIP_ON      (0x3 << 6)
> > > +#define    OV10635_VFLIP_SUBSAMPLE   0x1
> > > +#define   OV10635_HMIRROR         0x381d
> > > +#define    OV10635_HMIRROR_ON      0x3
> > > +#define OV10635_PID         0x300a
> > > +#define OV10635_VER         0x300b
> > > +
> > > +/* IDs */
> > > +#define OV10635_VERSION_REG      0xa635
> > > +#define OV10635_VERSION(pid, ver)   (((pid) << 8) | ((ver) & 0xff))
> > > +
> > > +#define OV10635_SENSOR_WIDTH      1312
> > > +#define OV10635_SENSOR_HEIGHT      814
> > > +
> > > +#define OV10635_MAX_WIDTH      1280
> > > +#define OV10635_MAX_HEIGHT      800

[snip]

> > > +static const struct ov10635_reg ov10635_regs_enable[] = {
> > > +   { 0x3042, 0xf0 }, { 0x301b, 0xf0 }, { 0x301c, 0xf0 },
> > > +   { 0x301a, 0xf0 },
> > > +};
> > 
> > Could you please define macros for register addresses and values ? I
> > know it's quite a bit of boring work, but without that maintening the
> > driver would be pretty difficult.
> 
> I will ask OmniVision if I can provide the register names.

A quick search unfortunately revealed no leak datasheets, so permission will 
indeed be required.

> However, I
> assume you don't mean I should define macros for all of the registers in
> the ov10635_regs_default array?

Ideally that would be great, but I won't nak the patch because of that.

http://git.linuxtv.org/pinchartl/media.git/blob/refs/heads/sensors/ov3640:/drivers/media/i2c/ov3640_regs.h

:-)

-- 
Regards,

Laurent Pinchart

