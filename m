Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f54.google.com ([209.85.160.54]:40502 "EHLO
        mail-pl0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933313AbeGJQgW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 12:36:22 -0400
MIME-Version: 1.0
References: <1531150874-4595-1-git-send-email-akinobu.mita@gmail.com>
 <1531150874-4595-3-git-send-email-akinobu.mita@gmail.com> <20180709161443.ubxu4el6bp6zgerj@ninjato>
 <20180709212306.47xsduu3b5qpq72h@earth.universe>
In-Reply-To: <20180709212306.47xsduu3b5qpq72h@earth.universe>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Wed, 11 Jul 2018 01:36:09 +0900
Message-ID: <CAC5umyhOsyYZqdgkZDuBwwWUwAHi2y_dizRr=hy8WRfpAr5UGA@mail.gmail.com>
Subject: Re: [PATCH -next v3 2/2] media: ov772x: use SCCB helpers
To: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-media@vger.kernel.org,
        linux-i2c@vger.kernel.org, Peter Rosin <peda@axentia.se>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018=E5=B9=B47=E6=9C=8810=E6=97=A5(=E7=81=AB) 6:23 Sebastian Reichel <sebas=
tian.reichel@collabora.co.uk>:
>
> Hi,
>
> On Mon, Jul 09, 2018 at 06:14:43PM +0200, Wolfram Sang wrote:
> > >  static int ov772x_read(struct i2c_client *client, u8 addr)
> > >  {
> > > -   int ret;
> > > -   u8 val;
> > > -
> > > -   ret =3D i2c_master_send(client, &addr, 1);
> > > -   if (ret < 0)
> > > -           return ret;
> > > -   ret =3D i2c_master_recv(client, &val, 1);
> > > -   if (ret < 0)
> > > -           return ret;
> > > -
> > > -   return val;
> > > +   return sccb_read_byte(client, addr);
> > >  }
> > >
> > >  static inline int ov772x_write(struct i2c_client *client, u8 addr, u=
8 value)
> > >  {
> > > -   return i2c_smbus_write_byte_data(client, addr, value);
> > > +   return sccb_write_byte(client, addr, value);
> > >  }
>
> Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
>
> > Minor nit: I'd rather drop these two functions and use the
> > sccb-accessors directly.
> >
> > However, I really like how this looks here: It is totally clear we are
> > doing SCCB and hide away all the details.
>
> I think it would be even better to introduce a SSCB regmap layer
> and use that.

I'm fine with introducing a SCCB regmap layer.

But do we need to provide both a SCCB regmap and these SCCB helpers?

If we have a regmap_init_sccb(), I feel these three SCCB helper functions
don't need to be exported anymore.
