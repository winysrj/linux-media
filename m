Return-Path: <SRS0=yUb4=PN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92A3BC43387
	for <linux-media@archiver.kernel.org>; Sat,  5 Jan 2019 14:52:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DAE2206B6
	for <linux-media@archiver.kernel.org>; Sat,  5 Jan 2019 14:52:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tUv9lzXE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbfAEOw1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 5 Jan 2019 09:52:27 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35250 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfAEOw1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 5 Jan 2019 09:52:27 -0500
Received: by mail-pg1-f195.google.com with SMTP id s198so18743188pgs.2
        for <linux-media@vger.kernel.org>; Sat, 05 Jan 2019 06:52:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=itm+XOUl+uXpUydA7dTG57hj9HbxtNhhGcbZNSqeHNg=;
        b=tUv9lzXEpIMDpeNUtMaUOC/Dp90CdFX73JRO2KIl4sEIz9c3QyGrHd3SNj6bdgeF6g
         B9IxL5AcLKd4DRmfCFirdW/i1VIPZAxKfCECA+/htCBHVclyk44bAhWNDDkOmUoelx8Q
         kKGR5yQFur91HVQb5zgtZl8vodEsF6MHvKe7wSx/BY4kIrXWWyS7aWn14AnGxXtcbyc7
         It95kWmsK67PCbsAuHuP8b5xM9N2JjHww4SWu00J2CLHsNdflBe9BCirJL/wcexnb106
         Rw+69zrlTNAZLb8PtYT3rEISMwkmXkyP13tt1CJuR7gaRjGPbpwuRXiurM/qtiMx/YmZ
         7vpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=itm+XOUl+uXpUydA7dTG57hj9HbxtNhhGcbZNSqeHNg=;
        b=fX4xOdjfdlhl0bsyZNcLimpQEYKgW1SijxzCm0yk217+kvZSP9+y7X0W8F3WSs7023
         zwhRhJ8362uPdbLRVjJuYZy8ikmO1orBtela8SOgMFYfoiNO7lClzA0ZQKuM9h3cprHM
         gDayUx4xF0MLrK0HzYRQrfsbvq3AVD1OVvrKG9n5gFk4lNre59XyU5sbYM7woqG6Cn3/
         24Pa65ZkAzBDFXke8aT8yKpiQN7Id7KSA7tjuqpLqrDXpmD5hMWaDrsvcogCjlttww/K
         UuY2BSSYFG0V4sIt6/czRIan6Y8fsxM1YNSlgOCT5wS5YswWs38MZ8OiOFbxKiXnxEJz
         B1AQ==
X-Gm-Message-State: AA+aEWa43wy5uASuYFQus28OaBRHG5tZYM+weUyiNtYOaJAMdCtWl7oQ
        /WwZNx2bYVIOTzPMaArQxJbGrkW0afXUbvFAKeI=
X-Google-Smtp-Source: AFSGD/UZxyvzzeT7SwCPCEbJ6L/bjnfViNCJI5hTm3S5NZn8wmMnAFvg+0Vy94TbvfRWqExR8Yrzgj1k3ug88b+Ao04=
X-Received: by 2002:a62:3305:: with SMTP id z5mr57292240pfz.112.1546699946143;
 Sat, 05 Jan 2019 06:52:26 -0800 (PST)
MIME-Version: 1.0
References: <1546103258-29025-1-git-send-email-akinobu.mita@gmail.com>
 <1546103258-29025-3-git-send-email-akinobu.mita@gmail.com>
 <20181231105418.nt4b6abe2tnvsge7@pengutronix.de> <CAC5umyiSoo46A7d-V1fRMny0HhV9=gbch4_vBhy-GN1O54CJjw@mail.gmail.com>
 <20190103134704.3rabugqd3pqzrazb@pengutronix.de>
In-Reply-To: <20190103134704.3rabugqd3pqzrazb@pengutronix.de>
From:   Akinobu Mita <akinobu.mita@gmail.com>
Date:   Sat, 5 Jan 2019 23:52:14 +0900
Message-ID: <CAC5umyjpCj6AaWyY=w-2NnO0v6MHz8JFA9R+oJrxxxHyXz=_8g@mail.gmail.com>
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

2019=E5=B9=B41=E6=9C=883=E6=97=A5(=E6=9C=A8) 22:47 Marco Felsch <m.felsch@p=
engutronix.de>:
>
> On 19-01-01 02:07, Akinobu Mita wrote:
> > 2018=E5=B9=B412=E6=9C=8831=E6=97=A5(=E6=9C=88) 19:54 Marco Felsch <m.fe=
lsch@pengutronix.de>:
> > >
> > > On 18-12-30 02:07, Akinobu Mita wrote:
> > > > The VIDIOC_SUBDEV_G_FMT ioctl for this driver doesn't recognize
> > > > V4L2_SUBDEV_FORMAT_TRY and always works as if V4L2_SUBDEV_FORMAT_AC=
TIVE
> > > > is specified.
> > > >
> > > > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> > > > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > > > ---
> > > >  drivers/media/i2c/mt9m111.c | 31 +++++++++++++++++++++++++++++++
> > > >  1 file changed, 31 insertions(+)
> > > >
> > > > diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m11=
1.c
> > > > index f0e47fd..acb4dee 100644
> > > > --- a/drivers/media/i2c/mt9m111.c
> > > > +++ b/drivers/media/i2c/mt9m111.c
> > > > @@ -528,6 +528,16 @@ static int mt9m111_get_fmt(struct v4l2_subdev =
*sd,
> > > >       if (format->pad)
> > > >               return -EINVAL;
> > > >
> > > > +     if (format->which =3D=3D V4L2_SUBDEV_FORMAT_TRY) {
> > > > +#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
> > >
> > > This ifdef is made in the include/media/v4l2-subdev.h, so I would dro=
p
> > > it.
> >
> > I sent similar fix for ov2640 driver and kerel test robot reported
> > build test failure.  So I think this ifdef is necessary.
> >
> > v1: https://www.mail-archive.com/linux-media@vger.kernel.org/msg137098.=
html
> > v2: https://www.mail-archive.com/linux-media@vger.kernel.org/msg141735.=
html
>
> You are absolutely true, sorry my mistake.. Unfortunately my patch [1] wa=
sn't
> applied which fixes it commonly. This patch will avoid the 2nd ifdef in
> init_cfg() too.
>
> [1] https://www.spinics.net/lists/linux-media/msg138940.html
>
> >
> > > > +             mf =3D v4l2_subdev_get_try_format(sd, cfg, 0);
> > >
> > > I would use format->pad instead of the static 0.
> >
> > OK.
> >
> > > > +             format->format =3D *mf;
> > >
> > > Is this correct? I tought v4l2_subdev_get_try_format() will return th=
e
> > > try_pad which we need to fill.
> >
> > I think this is correct.  Other sensor drivers are doing the same thing=
 in
> > get_fmt() callback.
>
> Yes, you're right.
>
> > > > +             return 0;
> > > > +#else
> > > > +             return -ENOTTY;
> > >
> > > Return this error is not specified in the API-Doc.
> >
> > I think this 'return -ENOTTY' is not reachable even if
> > CONFIG_VIDEO_V4L2_SUBDEV_API is not set, and can be replaced with any
> > return value.
>
> Sorry I didn't catched this. When it's not reachable why is it there and
> why isn't it reachable? If the format->which =3D V4L2_SUBDEV_FORMAT_TRY
> and we don't configure CONFIG_VIDEO_V4L2_SUBDEV_API, then this path will
> be reached, or overlooked I something?

As far as I can see, when CONFIG_VIDEO_V4L2_SUBDEV_API is not defined,
the get_fmt() callback is always called with
'format->which =3D=3D V4L2_SUBDEV_FORMAT_ACTIVE'.

There is only one call site that the get_fmt() is called with
'format->which =3D=3D V4L2_SUBDEV_FORMAT_TRY' in
drivers/media/v4l2-core/v4l2-subdev.c: subdev_do_ioctl().
But the call site is enclosed by ifdef CONFIG_VIDEO_V4L2_SUBDEV_API.

So the hunk of the patch can be changed to:

        if (format->which =3D=3D V4L2_SUBDEV_FORMAT_TRY) {
#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
                mf =3D v4l2_subdev_get_try_format(sd, cfg, format->pad);
                format->format =3D *mf;
                return 0;
#endif
        }
