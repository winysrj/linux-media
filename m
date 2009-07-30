Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45633 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752295AbZG3KeL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2009 06:34:11 -0400
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Alexey Klimov <klimov.linux@gmail.com>
Subject: Re: [PATCH v2 4/4] radio-si470x: add i2c driver for si470x
Date: Thu, 30 Jul 2009 12:30:43 +0200
Cc: Joonyoung Shim <jy0922.shim@samsung.com>,
	linux-media@vger.kernel.org, mchehab@infradead.org,
	kyungmin.park@samsung.com
References: <4A5C145D.30300@samsung.com> <208cbae30907190719v3fcffee0g1f15d05da5e182f2@mail.gmail.com>
In-Reply-To: <208cbae30907190719v3fcffee0g1f15d05da5e182f2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907301230.43497.tobias.lorenz@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

okay for the moment. We can later think about optimizations, like "return 0" functions.
I have no possibility of testing this functionality. But I guess it works with your device, so

Acked-by: Tobias Lorenz <tobias.lorenz@gmx.net>

Bye,
Toby

On Sunday 19 July 2009 16:19:24 Alexey Klimov wrote:
> Hello,
> 
> On Tue, Jul 14, 2009 at 9:15 AM, Joonyoung Shim<jy0922.shim@samsung.com> wrote:
> > This patch supports i2c interface of si470x. The i2c specific part
> > exists in radio-si470x-i2c.c file and the common part uses
> > radio-si470x-common.c file. The '#if defined' is inserted inevitably
> > because of parts used only si470x usb in the common file.
> >
> > The current driver version doesn't support the RDS.
> >
> > Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
> > ---
> >  linux/drivers/media/radio/si470x/Kconfig           |   13 +
> >  linux/drivers/media/radio/si470x/Makefile          |    2 +
> >  .../media/radio/si470x/radio-si470x-common.c       |    6 +
> >  .../drivers/media/radio/si470x/radio-si470x-i2c.c  |  254 ++++++++++++++++++++
> >  linux/drivers/media/radio/si470x/radio-si470x.h    |    6 +
> >  5 files changed, 281 insertions(+), 0 deletions(-)
> >  create mode 100644 linux/drivers/media/radio/si470x/radio-si470x-i2c.c
> >
> > diff --git a/linux/drivers/media/radio/si470x/Kconfig b/linux/drivers/media/radio/si470x/Kconfig
> > index 20d05c0..a466654 100644
> > --- a/linux/drivers/media/radio/si470x/Kconfig
> > +++ b/linux/drivers/media/radio/si470x/Kconfig
> > @@ -22,3 +22,16 @@ config USB_SI470X
> >
> >          To compile this driver as a module, choose M here: the
> >          module will be called radio-usb-si470x.
> > +
> > +config I2C_SI470X
> > +       tristate "Silicon Labs Si470x FM Radio Receiver support with I2C"
> > +       depends on I2C && RADIO_SI470X && !USB_SI470X
> > +       ---help---
> > +         This is a driver for I2C devices with the Silicon Labs SI470x
> > +         chip.
> > +
> > +         Say Y here if you want to connect this type of radio to your
> > +         computer's I2C port.
> > +
> > +         To compile this driver as a module, choose M here: the
> > +         module will be called radio-i2c-si470x.
> > diff --git a/linux/drivers/media/radio/si470x/Makefile b/linux/drivers/media/radio/si470x/Makefile
> > index 3cb777f..0696481 100644
> > --- a/linux/drivers/media/radio/si470x/Makefile
> > +++ b/linux/drivers/media/radio/si470x/Makefile
> > @@ -3,5 +3,7 @@
> >  #
> >
> >  radio-usb-si470x-objs  := radio-si470x-usb.o radio-si470x-common.o
> > +radio-i2c-si470x-objs  := radio-si470x-i2c.o radio-si470x-common.o
> >
> >  obj-$(CONFIG_USB_SI470X) += radio-usb-si470x.o
> > +obj-$(CONFIG_I2C_SI470X) += radio-i2c-si470x.o
> > diff --git a/linux/drivers/media/radio/si470x/radio-si470x-common.c b/linux/drivers/media/radio/si470x/radio-si470x-common.c
> > index 84cbea3..0a48159 100644
> > --- a/linux/drivers/media/radio/si470x/radio-si470x-common.c
> > +++ b/linux/drivers/media/radio/si470x/radio-si470x-common.c
> > @@ -581,8 +581,12 @@ static int si470x_vidioc_g_tuner(struct file *file, void *priv,
> >        /* driver constants */
> >        strcpy(tuner->name, "FM");
> >        tuner->type = V4L2_TUNER_RADIO;
> > +#if defined(CONFIG_USB_SI470X) || defined(CONFIG_USB_SI470X_MODULE)
> >        tuner->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO |
> >                            V4L2_TUNER_CAP_RDS;
> > +#else
> > +       tuner->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
> > +#endif
> >
> >        /* range limits */
> >        switch ((radio->registers[SYSCONFIG2] & SYSCONFIG2_BAND) >> 6) {
> > @@ -608,10 +612,12 @@ static int si470x_vidioc_g_tuner(struct file *file, void *priv,
> >                tuner->rxsubchans = V4L2_TUNER_SUB_MONO;
> >        else
> >                tuner->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
> > +#if defined(CONFIG_USB_SI470X) || defined(CONFIG_USB_SI470X_MODULE)
> >        /* If there is a reliable method of detecting an RDS channel,
> >           then this code should check for that before setting this
> >           RDS subchannel. */
> >        tuner->rxsubchans |= V4L2_TUNER_SUB_RDS;
> > +#endif
> >
> >        /* mono/stereo selector */
> >        if ((radio->registers[POWERCFG] & POWERCFG_MONO) == 0)
> > diff --git a/linux/drivers/media/radio/si470x/radio-si470x-i2c.c b/linux/drivers/media/radio/si470x/radio-si470x-i2c.c
> > new file mode 100644
> > index 0000000..2181021
> > --- /dev/null
> > +++ b/linux/drivers/media/radio/si470x/radio-si470x-i2c.c
> > @@ -0,0 +1,254 @@
> > +/*
> > + * drivers/media/radio/si470x/radio-si470x-i2c.c
> > + *
> > + * I2C driver for radios with Silicon Labs Si470x FM Radio Receivers
> > + *
> > + * Copyright (C) 2009 Samsung Electronics Co.Ltd
> > + * Author: Joonyoung Shim <jy0922.shim@samsung.com>
> > + *
> > + *  This program is free software; you can redistribute  it and/or modify it
> > + *  under  the terms of  the GNU General  Public License as published by the
> > + *  Free Software Foundation;  either version 2 of the  License, or (at your
> > + *  option) any later version.
> > + *
> > + *
> > + * TODO:
> > + * - RDS support
> > + *
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/init.h>
> > +#include <linux/i2c.h>
> > +#include <linux/delay.h>
> > +
> > +#include "radio-si470x.h"
> > +
> > +#define DRIVER_KERNEL_VERSION  KERNEL_VERSION(1, 0, 0)
> > +#define DRIVER_CARD            "Silicon Labs Si470x FM Radio Receiver"
> > +#define DRIVER_VERSION         "1.0.0"
> > +
> > +/* starting with the upper byte of register 0x0a */
> > +#define READ_REG_NUM           RADIO_REGISTER_NUM
> > +#define READ_INDEX(i)          ((i + RADIO_REGISTER_NUM - 0x0a) % READ_REG_NUM)
> > +
> > +static int si470x_get_all_registers(struct si470x_device *radio)
> > +{
> > +       int i;
> > +       u16 buf[READ_REG_NUM];
> > +       struct i2c_msg msgs[1] = {
> > +               { radio->client->addr, I2C_M_RD, sizeof(u16) * READ_REG_NUM,
> > +                       (void *)buf },
> > +       };
> > +
> > +       if (i2c_transfer(radio->client->adapter, msgs, 1) != 1)
> > +               return -EIO;
> > +
> > +       for (i = 0; i < READ_REG_NUM; i++)
> > +               radio->registers[i] = __be16_to_cpu(buf[READ_INDEX(i)]);
> > +
> > +       return 0;
> > +}
> > +
> > +int si470x_get_register(struct si470x_device *radio, int regnr)
> > +{
> > +       u16 buf[READ_REG_NUM];
> > +       struct i2c_msg msgs[1] = {
> > +               { radio->client->addr, I2C_M_RD, sizeof(u16) * READ_REG_NUM,
> > +                       (void *)buf },
> > +       };
> > +
> > +       if (i2c_transfer(radio->client->adapter, msgs, 1) != 1)
> > +               return -EIO;
> > +
> > +       radio->registers[regnr] = __be16_to_cpu(buf[READ_INDEX(regnr)]);
> > +
> > +       return 0;
> > +}
> > +
> > +/* starting with the upper byte of register 0x02h */
> > +#define WRITE_REG_NUM          8
> > +#define WRITE_INDEX(i)         (i + 0x02)
> > +
> > +int si470x_set_register(struct si470x_device *radio, int regnr)
> > +{
> > +       int i;
> > +       u16 buf[WRITE_REG_NUM];
> > +       struct i2c_msg msgs[1] = {
> > +               { radio->client->addr, 0, sizeof(u16) * WRITE_REG_NUM,
> > +                       (void *)buf },
> > +       };
> > +
> > +       for (i = 0; i < WRITE_REG_NUM; i++)
> > +               buf[i] = __cpu_to_be16(radio->registers[WRITE_INDEX(i)]);
> > +
> > +       if (i2c_transfer(radio->client->adapter, msgs, 1) != 1)
> > +               return -EIO;
> > +
> > +       return 0;
> > +}
> > +
> > +int si470x_disconnect_check(struct si470x_device *radio)
> > +{
> > +       return 0;
> > +}
> 
> Looks like this function is empty and it's called few times. Is it
> good to make it inline?
> 
