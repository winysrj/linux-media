Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39732 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727756AbeIRTrm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 15:47:42 -0400
Received: by mail-pg1-f193.google.com with SMTP id i190-v6so1112738pgc.6
        for <linux-media@vger.kernel.org>; Tue, 18 Sep 2018 07:14:54 -0700 (PDT)
MIME-Version: 1.0
References: <1537200191-17956-1-git-send-email-akinobu.mita@gmail.com>
 <1537200191-17956-3-git-send-email-akinobu.mita@gmail.com> <CAJCx=gnoQz5Ks9oKKs3mgB58iHp0aTLpS1yM92o1nTKhwmoctg@mail.gmail.com>
In-Reply-To: <CAJCx=gnoQz5Ks9oKKs3mgB58iHp0aTLpS1yM92o1nTKhwmoctg@mail.gmail.com>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Tue, 18 Sep 2018 23:14:42 +0900
Message-ID: <CAC5umyhR2Xmd7e-OxCJbJjqDR7Z7Y+-ukDDZpV8kpjvdCy0H3w@mail.gmail.com>
Subject: Re: [PATCH 2/5] media: video-i2c: use i2c regmap
To: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018=E5=B9=B49=E6=9C=8818=E6=97=A5(=E7=81=AB) 12:19 Matt Ranostay <matt.ran=
ostay@konsulko.com>:
>
> On Mon, Sep 17, 2018 at 9:03 AM Akinobu Mita <akinobu.mita@gmail.com> wro=
te:
> >
> > Use regmap for i2c register access.  This simplifies register accesses =
and
> > chooses suitable access commands based on the functionality that the
> > adapter supports.
> >
> > Cc: Matt Ranostay <matt.ranostay@konsulko.com>
> > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Cc: Hans Verkuil <hansverk@cisco.com>
> > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > ---
> >  drivers/media/i2c/video-i2c.c | 54 ++++++++++++++++++++++-------------=
--------
> >  1 file changed, 28 insertions(+), 26 deletions(-)
> >
> > diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2=
c.c
> > index b7a2af9..90d389b 100644
> > --- a/drivers/media/i2c/video-i2c.c
> > +++ b/drivers/media/i2c/video-i2c.c
> > @@ -17,6 +17,7 @@
> >  #include <linux/module.h>
> >  #include <linux/mutex.h>
> >  #include <linux/of_device.h>
> > +#include <linux/regmap.h>
> >  #include <linux/sched.h>
> >  #include <linux/slab.h>
> >  #include <linux/videodev2.h>
> > @@ -38,7 +39,7 @@ struct video_i2c_buffer {
> >  };
> >
> >  struct video_i2c_data {
> > -       struct i2c_client *client;
> > +       struct regmap *regmap;
> >         const struct video_i2c_chip *chip;
> >         struct mutex lock;
> >         spinlock_t slock;
> > @@ -62,6 +63,12 @@ static const struct v4l2_frmsize_discrete amg88xx_si=
ze =3D {
> >         .height =3D 8,
> >  };
> >
> > +static const struct regmap_config amg88xx_regmap_config =3D {
> > +       .reg_bits =3D 8,
> > +       .val_bits =3D 8,
> > +       .max_register =3D 0xff
> > +};
> > +
> >  struct video_i2c_chip {
> >         /* video dimensions */
> >         const struct v4l2_fmtdesc *format;
> > @@ -76,6 +83,8 @@ struct video_i2c_chip {
> >         /* pixel size in bits */
> >         unsigned int bpp;
> >
> > +       const struct regmap_config *regmap_config;
> > +
> >         /* xfer function */
> >         int (*xfer)(struct video_i2c_data *data, char *buf);
> >
> > @@ -85,24 +94,8 @@ struct video_i2c_chip {
> >
> >  static int amg88xx_xfer(struct video_i2c_data *data, char *buf)
> >  {
> > -       struct i2c_client *client =3D data->client;
> > -       struct i2c_msg msg[2];
> > -       u8 reg =3D 0x80;
> > -       int ret;
> > -
> > -       msg[0].addr =3D client->addr;
> > -       msg[0].flags =3D 0;
> > -       msg[0].len =3D 1;
> > -       msg[0].buf  =3D (char *)&reg;
> > -
> > -       msg[1].addr =3D client->addr;
> > -       msg[1].flags =3D I2C_M_RD;
> > -       msg[1].len =3D data->chip->buffer_size;
> > -       msg[1].buf =3D (char *)buf;
> > -
> > -       ret =3D i2c_transfer(client->adapter, msg, 2);
> > -
> > -       return (ret =3D=3D 2) ? 0 : -EIO;
> > +       return regmap_bulk_read(data->regmap, 0x80, buf,
> > +                               data->chip->buffer_size);
>
> May as well make 0x80 into a AMG88XX_REG_* define as in the later
> patch in this series

Sounds good. I'll do in v2.

> >  }
> >
> >  #if IS_ENABLED(CONFIG_HWMON)
> > @@ -133,12 +126,15 @@ static int amg88xx_read(struct device *dev, enum =
hwmon_sensor_types type,
> >                         u32 attr, int channel, long *val)
> >  {
> >         struct video_i2c_data *data =3D dev_get_drvdata(dev);
> > -       struct i2c_client *client =3D data->client;
> > -       int tmp =3D i2c_smbus_read_word_data(client, 0x0e);
> > +       __le16 buf;
> > +       int tmp;
> >
> > -       if (tmp < 0)
> > +       tmp =3D regmap_bulk_read(data->regmap, 0x0e, &buf, 2);
>
> Same with 0x0e

OK.
