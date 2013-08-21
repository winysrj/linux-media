Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:23785 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab3HUIZE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 04:25:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH v7 13/13] V4L: Add driver for s5k4e5 image sensor
Date: Wed, 21 Aug 2013 10:24:58 +0200
Cc: Arun Kumar K <arun.kk@samsung.com>, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
	s.nawrocki@samsung.com, swarren@wwwdotorg.org,
	mark.rutland@arm.com, Pawel.Moll@arm.com, galak@codeaurora.org,
	a.hajda@samsung.com, sachin.kamat@linaro.org,
	shaik.ameer@samsung.com, kilyeon.im@samsung.com,
	arunkk.samsung@gmail.com
References: <1377066881-5423-1-git-send-email-arun.kk@samsung.com> <52146403.9050702@xs4all.nl> <4486068.1NMnLxuSKb@flatron>
In-Reply-To: <4486068.1NMnLxuSKb@flatron>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308211024.58303.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 21 August 2013 09:58:28 Tomasz Figa wrote:
> Hi Hans,
> 
> On Wednesday 21 of August 2013 08:53:55 Hans Verkuil wrote:
> > On 08/21/2013 08:34 AM, Arun Kumar K wrote:
> > > This patch adds subdev driver for Samsung S5K4E5 raw image sensor.
> > > Like s5k6a3, it is also another fimc-is firmware controlled
> > > sensor. This minimal sensor driver doesn't do any I2C communications
> > > as its done by ISP firmware. It can be updated if needed to a
> > > regular sensor driver by adding the I2C communication.
> > > 
> > > Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> > > Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > > ---
> > > 
> > >  .../devicetree/bindings/media/i2c/s5k4e5.txt       |   43 +++
> > >  drivers/media/i2c/Kconfig                          |    8 +
> > >  drivers/media/i2c/Makefile                         |    1 +
> > >  drivers/media/i2c/s5k4e5.c                         |  361
> > >  ++++++++++++++++++++ 4 files changed, 413 insertions(+)
> > >  create mode 100644
> > >  Documentation/devicetree/bindings/media/i2c/s5k4e5.txt create mode
> > >  100644 drivers/media/i2c/s5k4e5.c
> > 
> > ...
> > 
> > > diff --git a/drivers/media/i2c/s5k4e5.c b/drivers/media/i2c/s5k4e5.c
> > > new file mode 100644
> > > index 0000000..0a6ece6
> > > --- /dev/null
> > > +++ b/drivers/media/i2c/s5k4e5.c
> > > @@ -0,0 +1,361 @@
> > > +/*
> > > + * Samsung S5K4E5 image sensor driver
> > > + *
> > > + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> > > + * Author: Arun Kumar K <arun.kk@samsung.com>
> > > + *
> > > + * This program is free software; you can redistribute it and/or
> > > modify + * it under the terms of the GNU General Public License
> > > version 2 as + * published by the Free Software Foundation.
> > > + */
> > > +
> > > +#include <linux/clk.h>
> > > +#include <linux/delay.h>
> > > +#include <linux/device.h>
> > > +#include <linux/errno.h>
> > > +#include <linux/gpio.h>
> > > +#include <linux/i2c.h>
> > > +#include <linux/kernel.h>
> > > +#include <linux/module.h>
> > > +#include <linux/of_gpio.h>
> > > +#include <linux/pm_runtime.h>
> > > +#include <linux/regulator/consumer.h>
> > > +#include <linux/slab.h>
> > > +#include <linux/videodev2.h>
> > > +#include <media/v4l2-async.h>
> > > +#include <media/v4l2-subdev.h>
> > > +
> > > +#define S5K4E5_SENSOR_MAX_WIDTH		2576
> > > +#define S5K4E5_SENSOR_MAX_HEIGHT	1930
> > > +
> > > +#define S5K4E5_SENSOR_ACTIVE_WIDTH	2560
> > > +#define S5K4E5_SENSOR_ACTIVE_HEIGHT	1920
> > > +
> > > +#define S5K4E5_SENSOR_MIN_WIDTH		(32 + 16)
> > > +#define S5K4E5_SENSOR_MIN_HEIGHT	(32 + 10)
> > > +
> > > +#define S5K4E5_DEF_WIDTH		1296
> > > +#define S5K4E5_DEF_HEIGHT		732
> > > +
> > > +#define S5K4E5_DRV_NAME			"S5K4E5"
> > > +#define S5K4E5_CLK_NAME			"mclk"
> > > +
> > > +#define S5K4E5_NUM_SUPPLIES		2
> > > +
> > > +#define S5K4E5_DEF_CLK_FREQ		24000000
> > > +
> > > +/**
> > > + * struct s5k4e5 - s5k4e5 sensor data structure
> > > + * @dev: pointer to this I2C client device structure
> > > + * @subdev: the image sensor's v4l2 subdev
> > > + * @pad: subdev media source pad
> > > + * @supplies: image sensor's voltage regulator supplies
> > > + * @gpio_reset: GPIO connected to the sensor's reset pin
> > > + * @lock: mutex protecting the structure's members below
> > > + * @format: media bus format at the sensor's source pad
> > > + */
> > > +struct s5k4e5 {
> > > +	struct device *dev;
> > > +	struct v4l2_subdev subdev;
> > > +	struct media_pad pad;
> > > +	struct regulator_bulk_data supplies[S5K4E5_NUM_SUPPLIES];
> > > +	int gpio_reset;
> > > +	struct mutex lock;
> > > +	struct v4l2_mbus_framefmt format;
> > > +	struct clk *clock;
> > > +	u32 clock_frequency;
> > > +};
> > > +
> > > +static const char * const s5k4e5_supply_names[] = {
> > > +	"svdda",
> > > +	"svddio"
> > > +};
> > 
> > I'm no regulator expert, but shouldn't this list come from the DT or
> > platform_data? Or are these names specific to this sensor?
> 
> This is a list of regulator input (aka supply) names. In other words those 
> are usually names of pins of the consumer device (s5k4e5 chip in this 
> case) to which the regulators are connected. They are used as lookup keys 
> when looking up regulators, either from device tree or lookup tables.

How does that work if you have two of these sensors? E.g. in a stereo-camera?
Can the regulator subsystem map those pins to the correct regulators?

Again, sorry for my ignorance in this area as I've never used it. I just
want to make sure this information is stored in the right place.

Regards,

	Hans
