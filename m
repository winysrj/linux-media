Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7421C43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 14:07:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86390206C0
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 14:07:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mmG8SQhN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbfAGOHb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 09:07:31 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42992 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbfAGOHb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2019 09:07:31 -0500
Received: by mail-pg1-f194.google.com with SMTP id d72so181273pga.9;
        Mon, 07 Jan 2019 06:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GcggwUpqkCSjt44KfbTsqsILoTNqZnB7fVtqlWd/TW0=;
        b=mmG8SQhNnirnUvYO97BMRLifiy4BRey+o7tRKQE0AUd3XegxMUApgjGajbk1WvZSI+
         CpHdOyFrZD1bubcBa+tLnOoSQCm2xDt9D8COJi1BmjSkOap+/AGLqmgGKSlvcY8mSoaX
         1uhV/8/hf6RoV/5hCFOJIu3/KbZMnYVnXd5BYgsyZuoqlJrrTDSDQjgPs6VTf7nVnwxn
         wC+Q59mm9cwYfw5gEOWIdSBJGnKoTp2kGXsAVftCGZy+NVctLfOnutxIqM0xlOuUUXL0
         ybASFG512dpQZ1nJVJBIWWPGnXUNSdb+4sl6+jYcZvTvRIydtqWC+Kd2BS7WWToqfzIW
         0sYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GcggwUpqkCSjt44KfbTsqsILoTNqZnB7fVtqlWd/TW0=;
        b=LRF+mU+ANaCM4n45ie/FWgm95H5XEVrFTQGSpcilVUAPksTwcxnIUbfZCnpJ8ZoLz6
         889tdvGbLvSeON3xHFZGdJ5jfORKE2/sUCpeHO3Y90qNRAeCJdf6bghXT1ysMoKOQRyb
         525Arzf6sd40cjR40gXF0Os2hLpzbGKpQMKux1FXxV7lEZcaa96WSvyhk0p/dw6EXhfb
         8ZSja4mHMwr5VurRdOVyolO88XRq7LPGLNV6d1BhRGOPr+1JyFwtadynqtFjVtDTkmOJ
         SSyHFNro5VVh/Wunqugken9nvlD8ahY1lkw4dPG3jZxK2O6AMELNTBgIWCDKM33N7nec
         h7hg==
X-Gm-Message-State: AA+aEWalgxbJo4QjSg055q1srGx6N0m0hcMcn5BcQMXVoZUzoStKSLRY
        PFjLZqac/YRr4kCYf9JqxXz+CgIR5p4cvBgzgJY=
X-Google-Smtp-Source: AFSGD/XpruzzOUOJIFmmG98V0n7Twj06I9SLwI1IOsAC4z1BSQ42W0uOzLM0qbiidhcc7pqapqSv4B/vBi1jFNVzY/s=
X-Received: by 2002:a62:d701:: with SMTP id b1mr61920572pfh.34.1546870049675;
 Mon, 07 Jan 2019 06:07:29 -0800 (PST)
MIME-Version: 1.0
References: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
 <1545498774-11754-7-git-send-email-akinobu.mita@gmail.com> <20190107100034.po3jsnc3rdj37l4x@kekkonen.localdomain>
In-Reply-To: <20190107100034.po3jsnc3rdj37l4x@kekkonen.localdomain>
From:   Akinobu Mita <akinobu.mita@gmail.com>
Date:   Mon, 7 Jan 2019 23:07:18 +0900
Message-ID: <CAC5umyg0=JO2d_TbmGWp4OaiZWCiQEdx6RBwpOTNEd6Ug8MqLg@mail.gmail.com>
Subject: Re: [PATCH 06/12] media: mt9m001: switch s_power callback to runtime PM
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     linux-media@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

2019=E5=B9=B41=E6=9C=887=E6=97=A5(=E6=9C=88) 19:00 Sakari Ailus <sakari.ail=
us@linux.intel.com>:
>
> Hi Mita-san,
>
> Thanks for the patchset.
>
> On Sun, Dec 23, 2018 at 02:12:48AM +0900, Akinobu Mita wrote:
> > Switch s_power() callback to runtime PM framework.  This also removes
> > soc_camera specific power management code and introduces reset and stan=
dby
> > gpios instead.
> >
> > Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > ---
> >  drivers/media/i2c/mt9m001.c | 242 ++++++++++++++++++++++++++++++++----=
--------
> >  1 file changed, 178 insertions(+), 64 deletions(-)
> >
> > diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
> > index c0180fdc..f20188a 100644
> > --- a/drivers/media/i2c/mt9m001.c
> > +++ b/drivers/media/i2c/mt9m001.c
> > @@ -5,6 +5,10 @@
> >   * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
> >   */
> >
> > +#include <linux/clk.h>
> > +#include <linux/delay.h>
> > +#include <linux/gpio/consumer.h>
> > +#include <linux/pm_runtime.h>
> >  #include <linux/videodev2.h>
> >  #include <linux/slab.h>
> >  #include <linux/i2c.h>
> > @@ -13,7 +17,6 @@
> >
> >  #include <media/soc_camera.h>
> >  #include <media/drv-intf/soc_mediabus.h>
> > -#include <media/v4l2-clk.h>
> >  #include <media/v4l2-subdev.h>
> >  #include <media/v4l2-ctrls.h>
> >
> > @@ -92,8 +95,12 @@ struct mt9m001 {
> >               struct v4l2_ctrl *autoexposure;
> >               struct v4l2_ctrl *exposure;
> >       };
> > +     bool streaming;
> > +     struct mutex mutex;
> >       struct v4l2_rect rect;  /* Sensor window */
> > -     struct v4l2_clk *clk;
> > +     struct clk *clk;
> > +     struct gpio_desc *standby_gpio;
> > +     struct gpio_desc *reset_gpio;
> >       const struct mt9m001_datafmt *fmt;
> >       const struct mt9m001_datafmt *fmts;
> >       int num_fmts;
> > @@ -177,8 +184,7 @@ static int mt9m001_init(struct i2c_client *client)
> >       return multi_reg_write(client, init_regs, ARRAY_SIZE(init_regs));
> >  }
> >
> > -static int mt9m001_apply_selection(struct v4l2_subdev *sd,
> > -                                 struct v4l2_rect *rect)
> > +static int mt9m001_apply_selection(struct v4l2_subdev *sd)
> >  {
> >       struct i2c_client *client =3D v4l2_get_subdevdata(sd);
> >       struct mt9m001 *mt9m001 =3D to_mt9m001(client);
> > @@ -190,11 +196,11 @@ static int mt9m001_apply_selection(struct v4l2_su=
bdev *sd,
> >                * The caller provides a supported format, as verified pe=
r
> >                * call to .set_fmt(FORMAT_TRY).
> >                */
> > -             { MT9M001_COLUMN_START, rect->left },
> > -             { MT9M001_ROW_START, rect->top },
> > -             { MT9M001_WINDOW_WIDTH, rect->width - 1 },
> > +             { MT9M001_COLUMN_START, mt9m001->rect.left },
> > +             { MT9M001_ROW_START, mt9m001->rect.top },
> > +             { MT9M001_WINDOW_WIDTH, mt9m001->rect.width - 1 },
> >               { MT9M001_WINDOW_HEIGHT,
> > -                     rect->height + mt9m001->y_skip_top - 1 },
> > +                     mt9m001->rect.height + mt9m001->y_skip_top - 1 },
> >       };
> >
> >       return multi_reg_write(client, regs, ARRAY_SIZE(regs));
> > @@ -203,11 +209,50 @@ static int mt9m001_apply_selection(struct v4l2_su=
bdev *sd,
> >  static int mt9m001_s_stream(struct v4l2_subdev *sd, int enable)
> >  {
> >       struct i2c_client *client =3D v4l2_get_subdevdata(sd);
> > +     struct mt9m001 *mt9m001 =3D to_mt9m001(client);
> > +     int ret =3D 0;
> >
> > -     /* Switch to master "normal" mode or stop sensor readout */
> > -     if (reg_write(client, MT9M001_OUTPUT_CONTROL, enable ? 2 : 0) < 0=
)
> > -             return -EIO;
> > -     return 0;
> > +     mutex_lock(&mt9m001->mutex);
> > +
> > +     if (mt9m001->streaming =3D=3D enable)
> > +             goto done;
> > +
> > +     if (enable) {
> > +             ret =3D pm_runtime_get_sync(&client->dev);
> > +             if (ret < 0) {
> > +                     pm_runtime_put_noidle(&client->dev);
> > +                     goto done;
>
> How about adding another label for calling pm_runtime_put()? The error
> handling is the same in all cases. You can also use pm_runtime_put()
> instead of pm_runtime_put_noidle() here; there's no harm done.

There are two ways that I can think of.  Which one do you prefer?

(1)
done:
        mutex_unlock(&mt9m001->mutex);

        return 0;

enable_error:
        pm_runtime_put(&client->dev);
        mutex_unlock(&mt9m001->mutex);

        return ret;
}

(2)
done:
        if (ret && enable)
               pm_runtime_put(&client->dev);

        mutex_unlock(&mt9m001->mutex);

        return ret;
}

> > +             }
> > +
> > +             ret =3D mt9m001_apply_selection(sd);
> > +             if (ret) {
> > +                     pm_runtime_put(&client->dev);
> > +                     goto done;
> > +             }
> > +
> > +             ret =3D __v4l2_ctrl_handler_setup(&mt9m001->hdl);
> > +             if (ret) {
> > +                     pm_runtime_put(&client->dev);
> > +                     goto done;
> > +             }
> > +
> > +             /* Switch to master "normal" mode */
> > +             ret =3D reg_write(client, MT9M001_OUTPUT_CONTROL, 2);
> > +             if (ret < 0) {
> > +                     pm_runtime_put(&client->dev);
> > +                     goto done;
> > +             }
> > +     } else {
> > +             /* Switch to master stop sensor readout */
> > +             reg_write(client, MT9M001_OUTPUT_CONTROL, 0);
> > +             pm_runtime_put(&client->dev);
> > +     }
> > +
> > +     mt9m001->streaming =3D enable;
> > +done:
> > +     mutex_unlock(&mt9m001->mutex);
> > +
> > +     return ret;
> >  }
> >
> >  static int mt9m001_set_selection(struct v4l2_subdev *sd,
> > @@ -217,7 +262,6 @@ static int mt9m001_set_selection(struct v4l2_subdev=
 *sd,
> >       struct i2c_client *client =3D v4l2_get_subdevdata(sd);
> >       struct mt9m001 *mt9m001 =3D to_mt9m001(client);
> >       struct v4l2_rect rect =3D sel->r;
> > -     int ret;
> >
> >       if (sel->which !=3D V4L2_SUBDEV_FORMAT_ACTIVE ||
> >           sel->target !=3D V4L2_SEL_TGT_CROP)
> > @@ -243,15 +287,9 @@ static int mt9m001_set_selection(struct v4l2_subde=
v *sd,
> >       mt9m001->total_h =3D rect.height + mt9m001->y_skip_top +
> >                          MT9M001_DEFAULT_VBLANK;
> >
> > +     mt9m001->rect =3D rect;
> >
> > -     ret =3D mt9m001_apply_selection(sd, &rect);
> > -     if (!ret && v4l2_ctrl_g_ctrl(mt9m001->autoexposure) =3D=3D V4L2_E=
XPOSURE_AUTO)
> > -             ret =3D reg_write(client, MT9M001_SHUTTER_WIDTH, mt9m001-=
>total_h);
> > -
> > -     if (!ret)
> > -             mt9m001->rect =3D rect;
> > -
> > -     return ret;
> > +     return 0;
> >  }
> >
> >  static int mt9m001_get_selection(struct v4l2_subdev *sd,
> > @@ -395,13 +433,34 @@ static int mt9m001_s_register(struct v4l2_subdev =
*sd,
> >  }
> >  #endif
> >
> > -static int mt9m001_s_power(struct v4l2_subdev *sd, int on)
> > +static int mt9m001_power_on(struct mt9m001 *mt9m001)
> >  {
> > -     struct i2c_client *client =3D v4l2_get_subdevdata(sd);
> > -     struct soc_camera_subdev_desc *ssdd =3D soc_camera_i2c_to_desc(cl=
ient);
> > -     struct mt9m001 *mt9m001 =3D to_mt9m001(client);
> > +     int ret =3D clk_prepare_enable(mt9m001->clk);
> > +
> > +     if (ret)
> > +             return ret;
> > +
> > +     if (mt9m001->standby_gpio) {
> > +             gpiod_set_value_cansleep(mt9m001->standby_gpio, 0);
> > +             usleep_range(1000, 2000);
> > +     }
> > +
> > +     if (mt9m001->reset_gpio) {
> > +             gpiod_set_value_cansleep(mt9m001->reset_gpio, 1);
> > +             usleep_range(1000, 2000);
> > +             gpiod_set_value_cansleep(mt9m001->reset_gpio, 0);
> > +             usleep_range(1000, 2000);
> > +     }
> >
> > -     return soc_camera_set_power(&client->dev, ssdd, mt9m001->clk, on)=
;
> > +     return 0;
> > +}
> > +
> > +static int mt9m001_power_off(struct mt9m001 *mt9m001)
> > +{
> > +     gpiod_set_value_cansleep(mt9m001->standby_gpio, 1);
> > +     clk_disable_unprepare(mt9m001->clk);
> > +
> > +     return 0;
> >  }
> >
> >  static int mt9m001_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
> > @@ -429,16 +488,18 @@ static int mt9m001_s_ctrl(struct v4l2_ctrl *ctrl)
> >       struct i2c_client *client =3D v4l2_get_subdevdata(sd);
> >       struct v4l2_ctrl *exp =3D mt9m001->exposure;
> >       int data;
> > +     int ret;
> > +
> > +     if (!pm_runtime_get_if_in_use(&client->dev))
> > +             return 0;
> >
> >       switch (ctrl->id) {
> >       case V4L2_CID_VFLIP:
> >               if (ctrl->val)
> > -                     data =3D reg_set(client, MT9M001_READ_OPTIONS2, 0=
x8000);
> > +                     ret =3D reg_set(client, MT9M001_READ_OPTIONS2, 0x=
8000);
> >               else
> > -                     data =3D reg_clear(client, MT9M001_READ_OPTIONS2,=
 0x8000);
> > -             if (data < 0)
> > -                     return -EIO;
> > -             return 0;
> > +                     ret =3D reg_clear(client, MT9M001_READ_OPTIONS2, =
0x8000);
> > +             break;
> >
> >       case V4L2_CID_GAIN:
> >               /* See Datasheet Table 7, Gain settings. */
> > @@ -448,9 +509,7 @@ static int mt9m001_s_ctrl(struct v4l2_ctrl *ctrl)
> >                       data =3D ((ctrl->val - (s32)ctrl->minimum) * 8 + =
range / 2) / range;
> >
> >                       dev_dbg(&client->dev, "Setting gain %d\n", data);
> > -                     data =3D reg_write(client, MT9M001_GLOBAL_GAIN, d=
ata);
> > -                     if (data < 0)
> > -                             return -EIO;
> > +                     ret =3D reg_write(client, MT9M001_GLOBAL_GAIN, da=
ta);
> >               } else {
> >                       /* Pack it into 1.125..15 variable step, register=
 values 9..67 */
> >                       /* We assume qctrl->maximum - qctrl->default_valu=
e - 1 > 0 */
> > @@ -467,11 +526,9 @@ static int mt9m001_s_ctrl(struct v4l2_ctrl *ctrl)
> >
> >                       dev_dbg(&client->dev, "Setting gain from %d to %d=
\n",
> >                                reg_read(client, MT9M001_GLOBAL_GAIN), d=
ata);
> > -                     data =3D reg_write(client, MT9M001_GLOBAL_GAIN, d=
ata);
> > -                     if (data < 0)
> > -                             return -EIO;
> > +                     ret =3D reg_write(client, MT9M001_GLOBAL_GAIN, da=
ta);
> >               }
> > -             return 0;
> > +             break;
> >
> >       case V4L2_CID_EXPOSURE_AUTO:
> >               if (ctrl->val =3D=3D V4L2_EXPOSURE_MANUAL) {
> > @@ -482,19 +539,22 @@ static int mt9m001_s_ctrl(struct v4l2_ctrl *ctrl)
> >                       dev_dbg(&client->dev,
> >                               "Setting shutter width from %d to %lu\n",
> >                               reg_read(client, MT9M001_SHUTTER_WIDTH), =
shutter);
> > -                     if (reg_write(client, MT9M001_SHUTTER_WIDTH, shut=
ter) < 0)
> > -                             return -EIO;
> > +                     ret =3D reg_write(client, MT9M001_SHUTTER_WIDTH, =
shutter);
> >               } else {
> > -                     const u16 vblank =3D 25;
> > -
> >                       mt9m001->total_h =3D mt9m001->rect.height +
> > -                             mt9m001->y_skip_top + vblank;
> > -                     if (reg_write(client, MT9M001_SHUTTER_WIDTH, mt9m=
001->total_h) < 0)
> > -                             return -EIO;
> > +                             mt9m001->y_skip_top + MT9M001_DEFAULT_VBL=
ANK;
> > +                     ret =3D reg_write(client, MT9M001_SHUTTER_WIDTH,
> > +                                     mt9m001->total_h);
> >               }
> > -             return 0;
> > +             break;
> > +     default:
> > +             ret =3D -EINVAL;
> > +             break;
> >       }
> > -     return -EINVAL;
> > +
> > +     pm_runtime_put(&client->dev);
> > +
> > +     return ret;
> >  }
> >
> >  /*
> > @@ -509,10 +569,6 @@ static int mt9m001_video_probe(struct soc_camera_s=
ubdev_desc *ssdd,
> >       unsigned long flags;
> >       int ret;
> >
> > -     ret =3D mt9m001_s_power(&mt9m001->subdev, 1);
> > -     if (ret < 0)
> > -             return ret;
> > -
> >       /* Enable the chip */
> >       data =3D reg_write(client, MT9M001_CHIP_ENABLE, 1);
> >       dev_dbg(&client->dev, "write: %d\n", data);
> > @@ -571,7 +627,6 @@ static int mt9m001_video_probe(struct soc_camera_su=
bdev_desc *ssdd,
> >       ret =3D v4l2_ctrl_handler_setup(&mt9m001->hdl);
> >
> >  done:
> > -     mt9m001_s_power(&mt9m001->subdev, 0);
> >       return ret;
> >  }
> >
> > @@ -601,7 +656,6 @@ static const struct v4l2_subdev_core_ops mt9m001_su=
bdev_core_ops =3D {
> >       .g_register     =3D mt9m001_g_register,
> >       .s_register     =3D mt9m001_s_register,
> >  #endif
> > -     .s_power        =3D mt9m001_s_power,
> >  };
> >
> >  static int mt9m001_enum_mbus_code(struct v4l2_subdev *sd,
> > @@ -700,6 +754,20 @@ static int mt9m001_probe(struct i2c_client *client=
,
> >       if (!mt9m001)
> >               return -ENOMEM;
> >
> > +     mt9m001->clk =3D devm_clk_get(&client->dev, NULL);
> > +     if (IS_ERR(mt9m001->clk))
> > +             return PTR_ERR(mt9m001->clk);
> > +
> > +     mt9m001->standby_gpio =3D devm_gpiod_get_optional(&client->dev, "=
standby",
> > +                                                     GPIOD_OUT_LOW);
> > +     if (IS_ERR(mt9m001->standby_gpio))
> > +             return PTR_ERR(mt9m001->standby_gpio);
> > +
> > +     mt9m001->reset_gpio =3D devm_gpiod_get_optional(&client->dev, "re=
set",
> > +                                                   GPIOD_OUT_LOW);
> > +     if (IS_ERR(mt9m001->reset_gpio))
> > +             return PTR_ERR(mt9m001->reset_gpio);
> > +
> >       v4l2_i2c_subdev_init(&mt9m001->subdev, client, &mt9m001_subdev_op=
s);
> >       v4l2_ctrl_handler_init(&mt9m001->hdl, 4);
> >       v4l2_ctrl_new_std(&mt9m001->hdl, &mt9m001_ctrl_ops,
> > @@ -722,6 +790,9 @@ static int mt9m001_probe(struct i2c_client *client,
> >       v4l2_ctrl_auto_cluster(2, &mt9m001->autoexposure,
> >                                       V4L2_EXPOSURE_MANUAL, true);
> >
> > +     mutex_init(&mt9m001->mutex);
> > +     mt9m001->hdl.lock =3D &mt9m001->mutex;
> > +
> >       /* Second stage probe - when a capture adapter is there */
> >       mt9m001->y_skip_top     =3D 0;
> >       mt9m001->rect.left      =3D MT9M001_COLUMN_SKIP;
> > @@ -729,18 +800,30 @@ static int mt9m001_probe(struct i2c_client *clien=
t,
> >       mt9m001->rect.width     =3D MT9M001_MAX_WIDTH;
> >       mt9m001->rect.height    =3D MT9M001_MAX_HEIGHT;
> >
> > -     mt9m001->clk =3D v4l2_clk_get(&client->dev, "mclk");
> > -     if (IS_ERR(mt9m001->clk)) {
> > -             ret =3D PTR_ERR(mt9m001->clk);
> > -             goto eclkget;
> > -     }
> > +     ret =3D mt9m001_power_on(mt9m001);
> > +     if (ret)
> > +             goto error_hdl_free;
> > +
> > +     pm_runtime_get_noresume(&client->dev);
> > +     pm_runtime_set_active(&client->dev);
> > +     pm_runtime_enable(&client->dev);
>
> You could replace ...get_noresume() + ...put_sync() below with a single
> pm_runtime_idle() call.

OK.

> >
> >       ret =3D mt9m001_video_probe(ssdd, client);
> > -     if (ret) {
> > -             v4l2_clk_put(mt9m001->clk);
> > -eclkget:
> > -             v4l2_ctrl_handler_free(&mt9m001->hdl);
> > -     }
> > +     if (ret)
> > +             goto error_power_off;
> > +
> > +     pm_runtime_put_sync(&client->dev);
> > +
> > +     return 0;
> > +
> > +error_power_off:
> > +     pm_runtime_disable(&client->dev);
> > +     pm_runtime_set_suspended(&client->dev);
> > +     pm_runtime_put_noidle(&client->dev);
> > +     mt9m001_power_off(mt9m001);
>
> A newline would be nice here.

OK.

> > +error_hdl_free:
> > +     v4l2_ctrl_handler_free(&mt9m001->hdl);
> > +     mutex_destroy(&mt9m001->mutex);
> >
> >       return ret;
> >  }
> > @@ -750,10 +833,17 @@ static int mt9m001_remove(struct i2c_client *clie=
nt)
> >       struct mt9m001 *mt9m001 =3D to_mt9m001(client);
> >       struct soc_camera_subdev_desc *ssdd =3D soc_camera_i2c_to_desc(cl=
ient);
> >
> > -     v4l2_clk_put(mt9m001->clk);
> >       v4l2_device_unregister_subdev(&mt9m001->subdev);
> > +     pm_runtime_get_sync(&client->dev);
> > +
> > +     pm_runtime_disable(&client->dev);
> > +     pm_runtime_set_suspended(&client->dev);
> > +     pm_runtime_put_noidle(&client->dev);
> > +     mt9m001_power_off(mt9m001);
> > +
> >       v4l2_ctrl_handler_free(&mt9m001->hdl);
> >       mt9m001_video_remove(ssdd);
> > +     mutex_destroy(&mt9m001->mutex);
> >
> >       return 0;
> >  }
> > @@ -764,6 +854,29 @@ static const struct i2c_device_id mt9m001_id[] =3D=
 {
> >  };
> >  MODULE_DEVICE_TABLE(i2c, mt9m001_id);
> >
> > +static int __maybe_unused mt9m001_runtime_resume(struct device *dev)
> > +{
> > +     struct i2c_client *client =3D to_i2c_client(dev);
> > +     struct mt9m001 *mt9m001 =3D to_mt9m001(client);
> > +
> > +     return mt9m001_power_on(mt9m001);
>
> How about changing the argument of mt9m001_power_o{n,ff} to struct device
> so you could remove these two? I think the original names are fine.

Sounds good.
