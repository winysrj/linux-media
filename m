Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46868 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731305AbeGTSbG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Jul 2018 14:31:06 -0400
MIME-Version: 1.0
References: <1531756070-8560-1-git-send-email-akinobu.mita@gmail.com>
 <1531756070-8560-2-git-send-email-akinobu.mita@gmail.com> <20180718152832.ylu6rlcsaom2q4xm@ninjato>
In-Reply-To: <20180718152832.ylu6rlcsaom2q4xm@ninjato>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Sat, 21 Jul 2018 02:41:37 +0900
Message-ID: <CAC5umyig9ZTddEu7HLwnspcPqEEmRS7ac=Oszd=6dPdN1vSkfA@mail.gmail.com>
Subject: Re: [PATCH -next v4 1/3] regmap: add SCCB support
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-media@vger.kernel.org, linux-i2c@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Peter Rosin <peda@axentia.se>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018=E5=B9=B47=E6=9C=8819=E6=97=A5(=E6=9C=A8) 0:28 Wolfram Sang <wsa@the-dr=
eams.de>:
>
> On Tue, Jul 17, 2018 at 12:47:48AM +0900, Akinobu Mita wrote:
> > This adds Serial Camera Control Bus (SCCB) support for regmap API that
> > is intended to be used by some of Omnivision sensor drivers.
> >
> > The ov772x and ov9650 drivers are going to use this SCCB regmap API.
> >
> > The ov772x driver was previously only worked with the i2c controller
> > drivers that support I2C_FUNC_PROTOCOL_MANGLING, because the ov772x
> > device doesn't support repeated starts.  After commit 0b964d183cbf
> > ("media: ov772x: allow i2c controllers without
> > I2C_FUNC_PROTOCOL_MANGLING"), reading ov772x register is replaced with
> > issuing two separated i2c messages in order to avoid repeated start.
> > Using this SCCB regmap hides the implementation detail.
> >
> > The ov9650 driver also issues two separated i2c messages to read the
> > registers as the device doesn't support repeated start.  So it can
> > make use of this SCCB regmap.
>
> Cool, this series really gets better and better each time. Thank you for
> keeping at it! And thanks to everyone for their suggestions. I really
> like how we do not introduce a couple of i2c_sccb_* functions with a
> need to export them. And given the nature of regmap, I'd think it should
> be fairly easy to add support for ov2659 somewhen which has 16 bit
> registers? Only minor nits:

I have an ov2659 sensor.  The ov2659 driver works with i2c adapter that
doesn't know I2C_FUNC_PROTOCOL_MANGLING, so it actually supports repeated
start.

But ov5645, ov5647, ov7251 drivers may want to use SCCB regmap API for
16-bit register.  Because they use i2c_master_send + i2c_master_recv
for reading register value.

> > +#include <linux/regmap.h>
> > +#include <linux/i2c.h>
> > +#include <linux/module.h>
>
> Sort these?
>
> > +/**
> > + * regmap_sccb_read - Read data from SCCB slave device
> > + * @context: Device that will be interacted wit
>
> "with"
>
> > +     ret =3D __i2c_smbus_xfer(i2c->adapter, i2c->addr, i2c->flags,
> > +                            I2C_SMBUS_WRITE, reg, I2C_SMBUS_BYTE, NULL=
);
>
> Mark: __i2c_smbus_xfer is a dependency on i2c/for-next. Do you want an
> immutable branch for that?
>
> > +/**
> > + * regmap_sccb_write - Write data to SCCB slave device
> > + * @context: Device that will be interacted wit
>
> "with"
>
> But in general (especially for the I2C parts):
>
> Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Thank you for your reviewing.
