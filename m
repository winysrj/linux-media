Return-Path: <SRS0=OvUS=QF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 134C8C169C4
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 12:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4A402087E
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 12:50:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P5ziNpli"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbfA2MuM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 07:50:12 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41708 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfA2MuM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 07:50:12 -0500
Received: by mail-pg1-f193.google.com with SMTP id m1so8699580pgq.8
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2019 04:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IhpsC+FeQ2D5tQHqBAH57znZPDrjyQuRw1puTJL5Ouw=;
        b=P5ziNplidphnbw+hr4DXPrpXmza2Y2SevjnL6akKzH/xNlZtkwSAHuWVt6CFkn/9k7
         xUs35uTUkcN/hUUd/CDB4/yFROR0w3YgpvLulayULKyQz4/KjhpelXuxTGrvrTErGVlm
         S0c9s0+zBw091x0lAGR4+rDJwb0gYox3T6QkPmQ0D/m1zveDo9kP4/10jRqOzH78akk8
         1FoMrkC8Jr4ygni6GQFw/CvXIW85wk/2IzsA+Kt+IJ7GFDzC60W80F+1Sa71zfZ+9rUJ
         stPYfSXswVMZQI0n/xMR/HQmZucLNGaVgCuRcZVQ6+5w6vOUXkuPm73nYSkvbL2q1jl7
         qjCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IhpsC+FeQ2D5tQHqBAH57znZPDrjyQuRw1puTJL5Ouw=;
        b=Fgre4++11oLiEzfANuk+23cUEVBZp5YCHvsu+fuewGfkdIdkLIDo1UmAj3WbgA1CPw
         kO+whWSG6E78DFfB6W1ORYGYlpY/EOTPkjmevaTm0rdJGydjXG3cJBAQCd7sXLEomXWY
         26K3I+98qh8Y1XYqxeyKSQZrZGQPoTh6z8M7pAZhr0+JWH5kjCB6L8HrH+ecgkC0LUk1
         sMLPdn3TWXP2f8iRkvXvVfGEzDb7G4dmlCIxJvQhpjOGpyJLV8r5NxQ2pJebBupjKP71
         9lB7QuDee8NRtwUGGG5nmkansnV4D+MHnW80pQuD1VKSC51Vew0CcWytasUPrty/Ipvu
         eaDw==
X-Gm-Message-State: AJcUukdF4AbGiofNNDeWdP6P4dqQhS35we3ZidZU8pZN9JbB8WLk4sEF
        JhESHlESsMKGoE7k3yOCpQBMPe3jmdxpgdsqmGo=
X-Google-Smtp-Source: ALg8bN4TftUiN5wHgmXoAATezb+D5/RgwVaibPbRgC6w769s7WfcFtKGJSfNhpnytB6gEpc+jEsAVBdO0Eqbk2Mm7Ss=
X-Received: by 2002:a62:2606:: with SMTP id m6mr25409671pfm.133.1548766210820;
 Tue, 29 Jan 2019 04:50:10 -0800 (PST)
MIME-Version: 1.0
References: <1547561141-13504-1-git-send-email-akinobu.mita@gmail.com>
 <1547561141-13504-2-git-send-email-akinobu.mita@gmail.com>
 <20190123151750.5s5efpear43pq2uj@pengutronix.de> <CAC5umyiU02KjY45RbuvO21xsUetpDe-HoVYyjSMWNGN5j3XDTg@mail.gmail.com>
 <20190128083455.ilql2qtxtlv3doga@paasikivi.fi.intel.com>
In-Reply-To: <20190128083455.ilql2qtxtlv3doga@paasikivi.fi.intel.com>
From:   Akinobu Mita <akinobu.mita@gmail.com>
Date:   Tue, 29 Jan 2019 21:49:59 +0900
Message-ID: <CAC5umygo5JCuGDnw95f9S_iAKO1tEUvC0p-OEJyT4JkxWNZoog@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] media: mt9m111: make VIDIOC_SUBDEV_G_FMT ioctl
 work with V4L2_SUBDEV_FORMAT_TRY
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Marco Felsch <m.felsch@pengutronix.de>,
        linux-media@vger.kernel.org,
        Enrico Scholz <enrico.scholz@sigma-chemnitz.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

2019=E5=B9=B41=E6=9C=8828=E6=97=A5(=E6=9C=88) 17:34 Sakari Ailus <sakari.ai=
lus@linux.intel.com>:
>
> Hi Mita-san, Marco,
>
> On Sun, Jan 27, 2019 at 09:29:30PM +0900, Akinobu Mita wrote:
> > 2019=E5=B9=B41=E6=9C=8824=E6=97=A5(=E6=9C=A8) 0:17 Marco Felsch <m.fels=
ch@pengutronix.de>:
> > >
> > > Hi Akinobu,
> > >
> > > sorry for the delayed response.
> > >
> > > On 19-01-15 23:05, Akinobu Mita wrote:
> > > > The VIDIOC_SUBDEV_G_FMT ioctl for this driver doesn't recognize
> > > > V4L2_SUBDEV_FORMAT_TRY and always works as if V4L2_SUBDEV_FORMAT_AC=
TIVE
> > > > is specified.
> > > >
> > > > Cc: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
> > > > Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
> > > > Cc: Marco Felsch <m.felsch@pengutronix.de>
> > > > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> > > > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > > > ---
> > > > * v3
> > > > - Set initial try format with default configuration instead of
> > > >   current one.
> > > >
> > > >  drivers/media/i2c/mt9m111.c | 30 ++++++++++++++++++++++++++++++
> > > >  1 file changed, 30 insertions(+)
> > > >
> > > > diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m11=
1.c
> > > > index d639b9b..63a5253 100644
> > > > --- a/drivers/media/i2c/mt9m111.c
> > > > +++ b/drivers/media/i2c/mt9m111.c
> > > > @@ -528,6 +528,16 @@ static int mt9m111_get_fmt(struct v4l2_subdev =
*sd,
> > > >       if (format->pad)
> > > >               return -EINVAL;
> > > >
> > > > +     if (format->which =3D=3D V4L2_SUBDEV_FORMAT_TRY) {
> > > > +#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
> > > > +             mf =3D v4l2_subdev_get_try_format(sd, cfg, format->pa=
d);
> > > > +             format->format =3D *mf;
> > > > +             return 0;
> > > > +#else
> > > > +             return -ENOTTY;
> > > > +#endif
> > >
> > > If've checked this again and found the ov* devices do this too. IMO i=
t's
> > > not good for other developers to check the upper layer if the '#else'
> > > path is reachable. There are also some code analyzer tools which will
> > > report this as issue/warning.
> > >
> > > As I said, I checked the v4l2_subdev_get_try_format() usage again and
> > > found the solution made by the mt9v111.c better. Why do you don't add=
 a
> > > dependency in the Kconfig, so we can drop this ifdef?
> >
> > I'm ok with adding CONFIG_VIDEO_V4L2_SUBDEV_API dependency to this
> > driver, because I always enable it.
> >
> > But it may cause an issue on some environments that don't require
> > CONFIG_VIDEO_V4L2_SUBDEV_API.
> >
> > Sakari, do you have any opinion?
>
> I think the dependency is just fine. There are drivers that do not suppor=
t
> MC (and V4L2 sub-device uAPI) but if a driver does, I don't see why it
> couldn't depend on the related Kconfig option.

OK.  I'll prepare a patch that adds the dependency and removes the ifdef.
I made similar change for ov2640, so I'll do for mt9m111 and ov2640,
respectively.
