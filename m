Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3532 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437Ab3CYI4N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 04:56:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [REVIEW PATCH 12/42] tw9903: add new tw9903 video decoder.
Date: Mon, 25 Mar 2013 09:55:58 +0100
Cc: linux-media@vger.kernel.org,
	Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl> <70b46354264bfe964430d87cbe6619749c71e96d.1363000605.git.hans.verkuil@cisco.com> <20130324122932.67985498@redhat.com>
In-Reply-To: <20130324122932.67985498@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303250955.58896.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun March 24 2013 16:29:32 Mauro Carvalho Chehab wrote:
> Em Mon, 11 Mar 2013 12:45:50 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > This based on the wis-tw9903.c driver that's part of the go7007 driver.
> > It has been converted to a v4l subdev driver by Pete Eberlein, and I made
> > additional cleanups.
> > 
> > Based on work by: Pete Eberlein <pete@sensoray.com>
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > Cc: Pete Eberlein <pete@sensoray.com>
> > ---
> >  drivers/media/i2c/Kconfig  |   10 ++
> >  drivers/media/i2c/Makefile |    1 +
> >  drivers/media/i2c/tw9903.c |  274 ++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 285 insertions(+)
> >  create mode 100644 drivers/media/i2c/tw9903.c
> > 
> > diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> > index 8000642..eb9ef55 100644
> > --- a/drivers/media/i2c/Kconfig
> > +++ b/drivers/media/i2c/Kconfig
> > @@ -301,6 +301,16 @@ config VIDEO_TVP7002
> >  	  To compile this driver as a module, choose M here: the
> >  	  module will be called tvp7002.
> >  
> > +config VIDEO_TW9903
> > +	tristate "Techwell TW9903 video decoder"
> > +	depends on VIDEO_V4L2 && I2C
> > +	---help---
> > +	  Support for the Techwell 9903 multi-standard video decoder
> > +	  with high quality down scaler.
> > +
> > +	  To compile this driver as a module, choose M here: the
> > +	  module will be called tw9903.
> > +
> >  config VIDEO_VPX3220
> >  	tristate "vpx3220a, vpx3216b & vpx3214c video decoders"
> >  	depends on VIDEO_V4L2 && I2C
> > diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> > index b1775b3..af8fb29 100644
> > --- a/drivers/media/i2c/Makefile
> > +++ b/drivers/media/i2c/Makefile
> > @@ -37,6 +37,7 @@ obj-$(CONFIG_VIDEO_THS7303) += ths7303.o
> >  obj-$(CONFIG_VIDEO_TVP5150) += tvp5150.o
> >  obj-$(CONFIG_VIDEO_TVP514X) += tvp514x.o
> >  obj-$(CONFIG_VIDEO_TVP7002) += tvp7002.o
> > +obj-$(CONFIG_VIDEO_TW9903) += tw9903.o
> >  obj-$(CONFIG_VIDEO_CS5345) += cs5345.o
> >  obj-$(CONFIG_VIDEO_CS53L32A) += cs53l32a.o
> >  obj-$(CONFIG_VIDEO_M52790) += m52790.o
> > diff --git a/drivers/media/i2c/tw9903.c b/drivers/media/i2c/tw9903.c
> > new file mode 100644
> > index 0000000..82626ea
> > --- /dev/null
> > +++ b/drivers/media/i2c/tw9903.c
> > @@ -0,0 +1,274 @@
> > +/*
> > + * Copyright (C) 2005-2006 Micronas USA Inc.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License (Version 2) as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software Foundation,
> > + * Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/init.h>
> > +#include <linux/i2c.h>
> > +#include <linux/videodev2.h>
> > +#include <linux/ioctl.h>
> > +#include <media/v4l2-device.h>
> > +#include <media/v4l2-ctrls.h>
> > +#include <linux/slab.h>
> > +
> > +MODULE_DESCRIPTION("TW9903 I2C subdev driver");
> > +MODULE_LICENSE("GPL v2");
> > +
> > +/*
> > + * This driver is based on the wis-tw9903.c source that was in
> > + * drivers/staging/media/go7007. That source had commented out code for
> > + * saturation and scaling (neither seemed to work). If anyone ever gets
> > + * hardware to test this driver, then that code might be useful to look at.
> > + * You need to get the kernel sources of, say, kernel 3.8 where that
> > + * wis-tw9903 driver is still present.
> > + */
> > +
> > +struct tw9903 {
> > +	struct v4l2_subdev sd;
> > +	struct v4l2_ctrl_handler hdl;
> > +	v4l2_std_id norm;
> > +};
> > +
> > +static inline struct tw9903 *to_state(struct v4l2_subdev *sd)
> > +{
> > +	return container_of(sd, struct tw9903, sd);
> > +}
> > +
> > +static const u8 initial_registers[] = {
> > +	0x02, 0x44, /* input 1, composite */
> > +	0x03, 0x92, /* correct digital format */
> > +	0x04, 0x00,
> > +	0x05, 0x80, /* or 0x00 for PAL */
> > +	0x06, 0x40, /* second internal current reference */
> > +	0x07, 0x02, /* window */
> > +	0x08, 0x14, /* window */
> > +	0x09, 0xf0, /* window */
> > +	0x0a, 0x81, /* window */
> > +	0x0b, 0xd0, /* window */
> > +	0x0c, 0x8c,
> > +	0x0d, 0x00, /* scaling */
> > +	0x0e, 0x11, /* scaling */
> > +	0x0f, 0x00, /* scaling */
> > +	0x10, 0x00, /* brightness */
> > +	0x11, 0x60, /* contrast */
> > +	0x12, 0x01, /* sharpness */
> > +	0x13, 0x7f, /* U gain */
> > +	0x14, 0x5a, /* V gain */
> > +	0x15, 0x00, /* hue */
> > +	0x16, 0xc3, /* sharpness */
> > +	0x18, 0x00,
> > +	0x19, 0x58, /* vbi */
> > +	0x1a, 0x80,
> > +	0x1c, 0x0f, /* video norm */
> > +	0x1d, 0x7f, /* video norm */
> > +	0x20, 0xa0, /* clamping gain (working 0x50) */
> > +	0x21, 0x22,
> > +	0x22, 0xf0,
> > +	0x23, 0xfe,
> > +	0x24, 0x3c,
> > +	0x25, 0x38,
> > +	0x26, 0x44,
> > +	0x27, 0x20,
> > +	0x28, 0x00,
> > +	0x29, 0x15,
> > +	0x2a, 0xa0,
> > +	0x2b, 0x44,
> > +	0x2c, 0x37,
> > +	0x2d, 0x00,
> > +	0x2e, 0xa5, /* burst PLL control (working: a9) */
> > +	0x2f, 0xe0, /* 0xea is blue test frame -- 0xe0 for normal */
> > +	0x31, 0x00,
> > +	0x33, 0x22,
> > +	0x34, 0x11,
> > +	0x35, 0x35,
> > +	0x3b, 0x05,
> > +	0x06, 0xc0, /* reset device */
> > +	0x00, 0x00, /* Terminator (reg 0x00 is read-only) */
> > +};
> > +
> > +static int write_reg(struct v4l2_subdev *sd, u8 reg, u8 value)
> > +{
> > +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> > +
> > +	return i2c_smbus_write_byte_data(client, reg, value);
> > +}
> > +
> > +static int write_regs(struct v4l2_subdev *sd, const u8 *regs)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; regs[i] != 0x00; i += 2)
> > +		if (write_reg(sd, regs[i], regs[i + 1]) < 0)
> > +			return -1;
> > +	return 0;
> > +}
> > +
> > +static int tw9903_s_video_routing(struct v4l2_subdev *sd, u32 input,
> > +				      u32 output, u32 config)
> > +{
> > +	write_reg(sd, 0x02, 0x40 | (input << 1));
> > +	return 0;
> > +}
> > +
> > +static int tw9903_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
> > +{
> > +	struct tw9903 *dec = to_state(sd);
> > +	bool is_60hz = norm & V4L2_STD_525_60;
> > +	u8 regs[] = {
> > +		0x05, is_60hz ? 0x80 : 0x00,
> > +		0x07, is_60hz ? 0x02 : 0x12,
> > +		0x08, is_60hz ? 0x14 : 0x18,
> > +		0x09, is_60hz ? 0xf0 : 0x20,
> > +		0,    0,
> > +	};
> 
> The above is ugly, and probably is wasting space at the code
> segment.
> 
> I'll apply it for now, but the better would be to change it to
> 2 const tables.

There are a few go7007 related patches that were posted in the last few days.
I'm going to combine them and also fix simple things like the above and
make a new pull request for you.

Regards,

	Hans
