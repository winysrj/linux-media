Return-Path: <SRS0=IHcP=PI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1C21C43387
	for <linux-media@archiver.kernel.org>; Mon, 31 Dec 2018 17:07:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B23D20685
	for <linux-media@archiver.kernel.org>; Mon, 31 Dec 2018 17:07:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O+lmNKPt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbeLaRHM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 31 Dec 2018 12:07:12 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34387 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbeLaRHM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Dec 2018 12:07:12 -0500
Received: by mail-pg1-f195.google.com with SMTP id j10so12883123pga.1
        for <linux-media@vger.kernel.org>; Mon, 31 Dec 2018 09:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=keFMhUshSY8y60CQxv22sSQ5oGZTkDAmFBY299Uc6LQ=;
        b=O+lmNKPt1qcMWBRowgmXU1HlaHTL5mS31P6PqT/gFys8g3+rM0oBFqifstyxXWIpZS
         aGL1NQ/Fw5iN2/IfuasFFRdUCISEUs57DmJBGDkNk1aZizI5wZUU9NjxAJV0ddvKDUKZ
         PTvX2K3JCnnMgqbXszSDknYIOPiHlTzWpz9IbUrRbqIL0PJRltKNUvGDYNL+NHiKzM+v
         CpBjw5yB1eNnEZ36nds8JjBup/1d9Lc5Sn09Sq6vgFYY3EUGbXF22hS8GAJvFAFUbEAQ
         1cqz5m/hnJp/VwKmmhBCmqtCkIpOyDhqUxHUBh5dtt0+gQ/RP44eYSq89DgdiNFXKU/u
         eoqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=keFMhUshSY8y60CQxv22sSQ5oGZTkDAmFBY299Uc6LQ=;
        b=fohxOc9J4rD8+d/cCBElJxYTpyR2ajPfQKY9CH5CTQIKDJK2LhWNqBrRtEXJT1ufK3
         i68XF/cqP7DigACGrbL+bmb2uxIzUgq8QwKX0d2bxCKMKm9/5BPD6UFLPpVSG5/zG9Rj
         A36QU5HrOV1Qow3LJZUTFsC51HEf6+F7w5fR8RNMrpCIKfHAjWnysdoYUaA8N3vwDgU3
         bV3UbcY0q1TgklAbGe9ByqLlkr5VvGm1Z9Zloe56h00VmPI15iFO0CyvAHwce0qw52Tw
         NEVuXXZuwtDNcj2bqACZYa1/TdiEMVk9sI5vzT4Lq0nAMMdjkBzaosNVsHdR3M8y4jaY
         4O0w==
X-Gm-Message-State: AA+aEWZySPSbinDCWoEutMYWYJgohb+bl6BUZ46Hm9rpwA45zXOjlfZn
        OJtrMatLBPUIQDkwSoEZjgo628xEf4RfqYKaGeM=
X-Google-Smtp-Source: AFSGD/XNxEb90OZC8bcnhikO1WEZM19PGEWmh8To0Xl0t6UAdzGtHuVc8aGhHgLIJICR6ZJWszE++2tj2llX9+IpuX0=
X-Received: by 2002:a62:d701:: with SMTP id b1mr37848530pfh.34.1546276031257;
 Mon, 31 Dec 2018 09:07:11 -0800 (PST)
MIME-Version: 1.0
References: <1546103258-29025-1-git-send-email-akinobu.mita@gmail.com>
 <1546103258-29025-3-git-send-email-akinobu.mita@gmail.com> <20181231105418.nt4b6abe2tnvsge7@pengutronix.de>
In-Reply-To: <20181231105418.nt4b6abe2tnvsge7@pengutronix.de>
From:   Akinobu Mita <akinobu.mita@gmail.com>
Date:   Tue, 1 Jan 2019 02:07:00 +0900
Message-ID: <CAC5umyiSoo46A7d-V1fRMny0HhV9=gbch4_vBhy-GN1O54CJjw@mail.gmail.com>
Subject: Re: [PATCH 2/4] media: mt9m111: make VIDIOC_SUBDEV_G_FMT ioctl work
 with V4L2_SUBDEV_FORMAT_TRY
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

2018=E5=B9=B412=E6=9C=8831=E6=97=A5(=E6=9C=88) 19:54 Marco Felsch <m.felsch=
@pengutronix.de>:
>
> On 18-12-30 02:07, Akinobu Mita wrote:
> > The VIDIOC_SUBDEV_G_FMT ioctl for this driver doesn't recognize
> > V4L2_SUBDEV_FORMAT_TRY and always works as if V4L2_SUBDEV_FORMAT_ACTIVE
> > is specified.
> >
> > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > ---
> >  drivers/media/i2c/mt9m111.c | 31 +++++++++++++++++++++++++++++++
> >  1 file changed, 31 insertions(+)
> >
> > diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
> > index f0e47fd..acb4dee 100644
> > --- a/drivers/media/i2c/mt9m111.c
> > +++ b/drivers/media/i2c/mt9m111.c
> > @@ -528,6 +528,16 @@ static int mt9m111_get_fmt(struct v4l2_subdev *sd,
> >       if (format->pad)
> >               return -EINVAL;
> >
> > +     if (format->which =3D=3D V4L2_SUBDEV_FORMAT_TRY) {
> > +#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
>
> This ifdef is made in the include/media/v4l2-subdev.h, so I would drop
> it.

I sent similar fix for ov2640 driver and kerel test robot reported
build test failure.  So I think this ifdef is necessary.

v1: https://www.mail-archive.com/linux-media@vger.kernel.org/msg137098.html
v2: https://www.mail-archive.com/linux-media@vger.kernel.org/msg141735.html

> > +             mf =3D v4l2_subdev_get_try_format(sd, cfg, 0);
>
> I would use format->pad instead of the static 0.

OK.

> > +             format->format =3D *mf;
>
> Is this correct? I tought v4l2_subdev_get_try_format() will return the
> try_pad which we need to fill.

I think this is correct.  Other sensor drivers are doing the same thing in
get_fmt() callback.

> > +             return 0;
> > +#else
> > +             return -ENOTTY;
>
> Return this error is not specified in the API-Doc.

I think this 'return -ENOTTY' is not reachable even if
CONFIG_VIDEO_V4L2_SUBDEV_API is not set, and can be replaced with any
return value.

> > +#endif
> > +     }
> > +
>
> If I understood it right, your patch should look like:
>
> > +     if (format->which =3D=3D V4L2_SUBDEV_FORMAT_TRY)
> > +             mf =3D v4l2_subdev_get_try_format(sd, cfg, format->pad);
>
> Sakari please correct me if it's wrong.
>
> >       mf->width       =3D mt9m111->width;
> >       mf->height      =3D mt9m111->height;
> >       mf->code        =3D mt9m111->fmt->code;
> > @@ -1090,6 +1100,26 @@ static int mt9m111_s_stream(struct v4l2_subdev *=
sd, int enable)
> >       return 0;
> >  }
> >
> > +static int mt9m111_init_cfg(struct v4l2_subdev *sd,
> > +                         struct v4l2_subdev_pad_config *cfg)
>
> Is this related to the patch description? I would split this into a
> seperate patch.

The mt9m111_init_cfg() initializes the try format with default setting.
So this is required in case get_fmt() with V4L2_SUBDEV_FORMAT_TRY is
called before set_fmt() with V4L2_SUBDEV_FORMAT_TRY is called.

> > +{
> > +#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
> > +     struct mt9m111 *mt9m111 =3D container_of(sd, struct mt9m111, subd=
ev);
> > +     struct v4l2_mbus_framefmt *format =3D
> > +             v4l2_subdev_get_try_format(sd, cfg, 0);
> > +
> > +     format->width   =3D mt9m111->width;
> > +     format->height  =3D mt9m111->height;
> > +     format->code    =3D mt9m111->fmt->code;
> > +     format->colorspace      =3D mt9m111->fmt->colorspace;
> > +     format->field   =3D V4L2_FIELD_NONE;
> > +     format->ycbcr_enc       =3D V4L2_YCBCR_ENC_DEFAULT;
> > +     format->quantization    =3D V4L2_QUANTIZATION_DEFAULT;
> > +     format->xfer_func       =3D V4L2_XFER_FUNC_DEFAULT;
> > +#endif
> > +     return 0;
> > +}
> > +
> >  static int mt9m111_g_mbus_config(struct v4l2_subdev *sd,
> >                               struct v4l2_mbus_config *cfg)
> >  {
> > @@ -1115,6 +1145,7 @@ static const struct v4l2_subdev_video_ops mt9m111=
_subdev_video_ops =3D {
> >  };
> >
> >  static const struct v4l2_subdev_pad_ops mt9m111_subdev_pad_ops =3D {
> > +     .init_cfg       =3D mt9m111_init_cfg,
> >       .enum_mbus_code =3D mt9m111_enum_mbus_code,
> >       .get_selection  =3D mt9m111_get_selection,
> >       .set_selection  =3D mt9m111_set_selection,
> > --
> > 2.7.4
> >
> >
