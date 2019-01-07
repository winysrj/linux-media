Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D7C3C43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 14:15:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F18652183E
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 14:15:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q7vXUL6a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfAGOPo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 09:15:44 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38367 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726746AbfAGOPn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2019 09:15:43 -0500
Received: by mail-pf1-f195.google.com with SMTP id q1so228235pfi.5;
        Mon, 07 Jan 2019 06:15:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IF3fqkzhpsWGqT0fTv5H9LSvYjZis/25sWF7xQGZEvo=;
        b=q7vXUL6aJsBLrFD1tT3oOPdvsGZ6Z/0B1CzyD9RiyaRwAcxwiwIFDBbkw7+ff+Cc7g
         S6QjFwFS23oxc1l8i8DgMnoqp+pClkmU+PLPyrGuthF1VakfQmNjvcwbCulAGJxv2/Sj
         aaPcYTpLT+hYElHobw6Qo2IqfCPoAt7UAbDwlz+2Ftb3V4negsLcgaIVcekzpPuHoPS7
         V5bME7uJBIKO+hLmLxlYY9CgnMHZ4ZcUEiNa04q9yWCLi4DFHykgzRourfgyuAjtbaEP
         BgkFZiLRQCMbrOaunrI0+2GpUmxza+25Xd8y5bgnnSUwrv8BlvADwCIo0L+1FEzlF+Td
         QcKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IF3fqkzhpsWGqT0fTv5H9LSvYjZis/25sWF7xQGZEvo=;
        b=Ev9oes53A+4ef+zK68Hzv0Pwt3/Sc+1z3yffhffyEePulrI6Gbpsu/whPNoQ0q4E3K
         cMm9DTMSx8772vTMQXeI6JjcEtXc8cW6sJeunJoLoxEp20Py4xXaBVqFSC0VNBMxCfAl
         rgtTWoORq/U1YFASvpq75pEjIG9TjrCoT4//1m/T9GfijkhI1kRLgIKz+GHE5LIaA57z
         o4d5bC/2sklUxbG2fT1xsy7BYRZCdQdUqEb/2xxjqRewH8iclRYheD/H0L+AlvOZT1cC
         d9zT3a6aKSlNoDNAQz68pPGhb2F7sH0LDuPjV7aKPAxq6vTKH0hd2Y+cBSpuzxPlN+JB
         o1kw==
X-Gm-Message-State: AJcUukf9i/ehLqR3o3jma3pc0McUN/AoZ/ZXOOEpeORHvLah+8REyrpW
        +MhiNVCxqO5DREpM6FxDxCrIFofK7xsLfVCdr00=
X-Google-Smtp-Source: ALg8bN4dVTBU8tCpX1yqw+hNdwk9+v7VS1QUQbxSRAYjd56lEYYPAnjQjZ//5wiyDGo519+hSCfSlxFKzGmmpuR0Qa0=
X-Received: by 2002:a63:2b01:: with SMTP id r1mr10993002pgr.432.1546870542998;
 Mon, 07 Jan 2019 06:15:42 -0800 (PST)
MIME-Version: 1.0
References: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
 <1545498774-11754-12-git-send-email-akinobu.mita@gmail.com> <20190107113034.4zpxdqoc5xbkvkt7@kekkonen.localdomain>
In-Reply-To: <20190107113034.4zpxdqoc5xbkvkt7@kekkonen.localdomain>
From:   Akinobu Mita <akinobu.mita@gmail.com>
Date:   Mon, 7 Jan 2019 23:15:32 +0900
Message-ID: <CAC5umyg=PTpksfEXnGEmxsYZnM4Anw=71B7whc3LmaSD50Vu0A@mail.gmail.com>
Subject: Re: [PATCH 11/12] media: mt9m001: make VIDIOC_SUBDEV_G_FMT ioctl work
 with V4L2_SUBDEV_FORMAT_TRY
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

2019=E5=B9=B41=E6=9C=887=E6=97=A5(=E6=9C=88) 20:30 Sakari Ailus <sakari.ail=
us@linux.intel.com>:
>
> Hi Mita-san,
>
> On Sun, Dec 23, 2018 at 02:12:53AM +0900, Akinobu Mita wrote:
> > The VIDIOC_SUBDEV_G_FMT ioctl for this driver doesn't recognize
> > V4L2_SUBDEV_FORMAT_TRY and always works as if V4L2_SUBDEV_FORMAT_ACTIVE
> > is specified.
> >
> > Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > ---
> >  drivers/media/i2c/mt9m001.c | 27 +++++++++++++++++++++++++++
> >  1 file changed, 27 insertions(+)
> >
> > diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
> > index a5b94d7..f4afbc9 100644
> > --- a/drivers/media/i2c/mt9m001.c
> > +++ b/drivers/media/i2c/mt9m001.c
> > @@ -331,6 +331,12 @@ static int mt9m001_get_fmt(struct v4l2_subdev *sd,
> >       if (format->pad)
> >               return -EINVAL;
> >
> > +     if (format->which =3D=3D V4L2_SUBDEV_FORMAT_TRY) {
> > +             mf =3D v4l2_subdev_get_try_format(sd, cfg, 0);
> > +             format->format =3D *mf;
> > +             return 0;
> > +     }
> > +
> >       mf->width       =3D mt9m001->rect.width;
> >       mf->height      =3D mt9m001->rect.height;
> >       mf->code        =3D mt9m001->fmt->code;
> > @@ -638,6 +644,26 @@ static const struct v4l2_subdev_core_ops mt9m001_s=
ubdev_core_ops =3D {
> >  #endif
> >  };
> >
> > +static int mt9m001_init_cfg(struct v4l2_subdev *sd,
> > +                         struct v4l2_subdev_pad_config *cfg)
> > +{
> > +     struct i2c_client *client =3D v4l2_get_subdevdata(sd);
> > +     struct mt9m001 *mt9m001 =3D to_mt9m001(client);
> > +     struct v4l2_mbus_framefmt *try_fmt =3D
> > +             v4l2_subdev_get_try_format(sd, cfg, 0);
> > +
> > +     try_fmt->width          =3D mt9m001->rect.width;
> > +     try_fmt->height         =3D mt9m001->rect.height;
> > +     try_fmt->code           =3D mt9m001->fmt->code;
> > +     try_fmt->colorspace     =3D mt9m001->fmt->colorspace;
>
> The initial configuration set here should reflect the default, not curren=
t
> configuration. This appears to refer to the current one.

You are right.  I'll fix this.
