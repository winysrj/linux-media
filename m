Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:56724 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab1EWIsr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 04:48:47 -0400
Date: Mon, 23 May 2011 10:48:36 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: javier Martin <javier.martin@vista-silicon.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	carlighting@yahoo.co.nz, beagleboard@googlegroups.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/2] MT9P031: Add support for Aptina mt9p031 sensor.
In-Reply-To: <BANLkTinjNUVH4pvxsKos=wTd0fCB-2zz2A@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1105231027150.30305@axis700.grange>
References: <1305899272-31839-1-git-send-email-javier.martin@vista-silicon.com>
 <Pine.LNX.4.64.1105211334260.25424@axis700.grange>
 <BANLkTinjNUVH4pvxsKos=wTd0fCB-2zz2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 23 May 2011, javier Martin wrote:

> On 21 May 2011 17:29, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > On Fri, 20 May 2011, Javier Martin wrote:
> >
> >> This driver adds basic support for Aptina mt9p031 sensor.
> >>
> >> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> >> ---
> >>  drivers/media/video/Kconfig   |    8 +
> >>  drivers/media/video/Makefile  |    1 +
> >>  drivers/media/video/mt9p031.c |  751 +++++++++++++++++++++++++++++++++++++++++
> >>  include/media/mt9p031.h       |   11 +
> >>  4 files changed, 771 insertions(+), 0 deletions(-)
> >>  create mode 100644 drivers/media/video/mt9p031.c
> >>  create mode 100644 include/media/mt9p031.h
> >>
> >> diff --git a/drivers/media/video/mt9p031.c b/drivers/media/video/mt9p031.c
> >> new file mode 100644
> >> index 0000000..e406b64
> >> --- /dev/null
> >> +++ b/drivers/media/video/mt9p031.c
> >> @@ -0,0 +1,751 @@
> >> +/*
> >> + * Driver for MT9P031 CMOS Image Sensor from Aptina
> >> + *
> >> + * Copyright (C) 2011, Javier Martin <javier.martin@vista-silicon.com>
> >> + *
> >> + * Copyright (C) 2011, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> >> + *
> >> + * Based on the MT9V032 driver and Bastian Hecht's code.
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License version 2 as
> >> + * published by the Free Software Foundation.
> >> + */
> >> +
> >> +#include <linux/delay.h>
> >> +#include <linux/device.h>
> >> +#include <linux/i2c.h>
> >> +#include <linux/log2.h>
> >> +#include <linux/pm.h>
> >> +#include <linux/regulator/consumer.h>
> >> +#include <linux/slab.h>
> >> +#include <media/v4l2-subdev.h>
> >> +#include <linux/videodev2.h>
> >> +
> >> +#include <media/mt9p031.h>
> >> +#include <media/v4l2-chip-ident.h>
> >> +#include <media/v4l2-subdev.h>
> >> +#include <media/v4l2-device.h>
> >> +
> >> +/* mt9p031 selected register addresses */
> >> +#define MT9P031_CHIP_VERSION                 0x00
> >> +#define              MT9P031_CHIP_VERSION_VALUE      0x1801
> >> +#define MT9P031_ROW_START                    0x01
> >
> > Don't mix spaces and TABs between "#define" and the macro - just use one
> > space everywhere.
> >
> 
> I've done this in order to follow Laurent's directions. He does the
> same in mt9v032 driver.
> So, unless Laurent and you agree I think I won't change it.

Ah, so, you use a space for registers and TABs for their values, ok then.

> >> +struct mt9p031 {
> >> +     struct v4l2_subdev subdev;
> >> +     struct media_pad pad;
> >> +     struct v4l2_rect rect;  /* Sensor window */
> >> +     struct v4l2_mbus_framefmt format;
> >> +     struct mt9p031_platform_data *pdata;
> >> +     struct mutex power_lock;
> >
> > Don't locks _always_ have to be documented? And this one: you only protect
> > set_power() with it, Laurent, is this correct?
> >
> 
> Just following the model Laurent applies in mt9v032. Let's see what he
> has to say about this.

Try running scripts/checkpatch.pl on your patch. I think, it will complain 
about this. And in general it's a good idea to run it before submission;)

> >> +static int mt9p031_reset(struct i2c_client *client)
> >> +{
> >> +     struct mt9p031 *mt9p031 = to_mt9p031(client);
> >> +     int ret;
> >> +
> >> +     /* Disable chip output, synchronous option update */
> >> +     ret = reg_write(client, MT9P031_RST, MT9P031_RST_ENABLE);
> >> +     if (ret < 0)
> >> +             return -EIO;
> >> +     ret = reg_write(client, MT9P031_RST, MT9P031_RST_DISABLE);
> >> +     if (ret < 0)
> >> +             return -EIO;
> >> +     ret = mt9p031_set_output_control(mt9p031, MT9P031_OUTPUT_CONTROL_CEN, 0);
> >> +     if (ret < 0)
> >> +             return -EIO;
> >> +     return 0;
> >
> >
> > I think, a sequence like
> >
> >        ret = fn();
> >        if (!ret)
> >                ret = fn();
> >        if (!ret)
> >                ret = fn();
> >        return ret;
> >
> > is a better way to achieve the same.
> >
> 
> Sorry, but I have to disagree. I understand what you want to achieve
> but this seems quite tricky to me.
> I explicitly changed parts of the code that were written using that
> style because I think It was better understandable.

Well, that was my opinion. Since Laurent will be taking this patch via his 
tree, his decision will be final, of course. But I think, he'll agree, 
that at least you have to be consistent across the driver. And at least 
you'd want to propagate your error code up to the caller instead of 
replacing it with "-EIO."

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
