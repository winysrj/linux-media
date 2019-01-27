Return-Path: <SRS0=npIJ=QD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C8C2C282CA
	for <linux-media@archiver.kernel.org>; Sun, 27 Jan 2019 12:29:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D16E62147A
	for <linux-media@archiver.kernel.org>; Sun, 27 Jan 2019 12:29:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G3wdWByM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfA0M3n (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 27 Jan 2019 07:29:43 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39026 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbfA0M3n (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Jan 2019 07:29:43 -0500
Received: by mail-pf1-f194.google.com with SMTP id r136so6766491pfc.6
        for <linux-media@vger.kernel.org>; Sun, 27 Jan 2019 04:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xl6xaYLQZ6c0X+2+ceymDfE8prhVdXVTNAL9HT6HrMY=;
        b=G3wdWByM0SVkRdIuyCzGcDmVL0TtCDo3uhaTucyFplSunVe20NNdML1dleguYb3b+O
         5d3Arb1dSWUZZFbDIgE8wpBnpHMcyMa51X7YaFGsNShDv58KDMQ7mCukoIKA9RJidtUl
         nCrDScb7gdlrzu3aLTk2vN2PmYvYkemG0Cy/Drqxu52931P1aSlFdRSsGZwtv/PAgstF
         G3iwOfc08LSL7o0gVZH9q6ehXU690F9YSSJu5PsTCNSmaxWDMB1KLXfaTZ3oU+qoL+Y3
         eSUQ+4iDvPJsVkgW8Sq/fEsDPUJJC6QpJjY3x9hihm5R4L7f445LCpwtV8Qfr4F3qHxy
         nBRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xl6xaYLQZ6c0X+2+ceymDfE8prhVdXVTNAL9HT6HrMY=;
        b=qh2JrCqXKFIGRjt078dVWkUgdwAqWzjOfx10xJwFIWb4HJIbjyTZzh1BJ1eYUNx537
         VzIhb9DlD54tv1vKH9uc0FL5g2C7im0z2/xFSFJpA422j5mL366RQvRkBLMkc2R0FW0Z
         AZ4xUZqPfnfW0KQeCcXZvSio1kMBbNHBfwMsjMf+kYAwsUfRJB4jMXT8oihyPJQBy1c/
         1ymgVeZfE1Zf63RHT6QPKedI3uvaYGrXpXNXPvhdMXKqusqvEHxN6xE9yYKmIaxhXZKD
         8havnalkn4t2toTulk9CTKhi3cPsBSsdZArr1B7BgP65N6qrhz3WCYcG7IyA2zkF8cKa
         fKwQ==
X-Gm-Message-State: AJcUukdUaX/2AfugFZ/1kVLVMo4tB9wmKonlwp6Toz2e7qm8zVEB0a8g
        i+hkH05LWDTT3jiFhiYCC6ctEhljxM26JIeM+VM=
X-Google-Smtp-Source: ALg8bN437NLxI245PW/9NNoNKU1edX0FnhwW+G9saOVGkmVCa0xadxoo09cRsY3Md/W7XrpN9h6rswuVs4huvs4Gqig=
X-Received: by 2002:a62:6408:: with SMTP id y8mr17983549pfb.202.1548592181862;
 Sun, 27 Jan 2019 04:29:41 -0800 (PST)
MIME-Version: 1.0
References: <1547561141-13504-1-git-send-email-akinobu.mita@gmail.com>
 <1547561141-13504-2-git-send-email-akinobu.mita@gmail.com> <20190123151750.5s5efpear43pq2uj@pengutronix.de>
In-Reply-To: <20190123151750.5s5efpear43pq2uj@pengutronix.de>
From:   Akinobu Mita <akinobu.mita@gmail.com>
Date:   Sun, 27 Jan 2019 21:29:30 +0900
Message-ID: <CAC5umyiU02KjY45RbuvO21xsUetpDe-HoVYyjSMWNGN5j3XDTg@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] media: mt9m111: make VIDIOC_SUBDEV_G_FMT ioctl
 work with V4L2_SUBDEV_FORMAT_TRY
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     linux-media@vger.kernel.org,
        Enrico Scholz <enrico.scholz@sigma-chemnitz.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

2019=E5=B9=B41=E6=9C=8824=E6=97=A5(=E6=9C=A8) 0:17 Marco Felsch <m.felsch@p=
engutronix.de>:
>
> Hi Akinobu,
>
> sorry for the delayed response.
>
> On 19-01-15 23:05, Akinobu Mita wrote:
> > The VIDIOC_SUBDEV_G_FMT ioctl for this driver doesn't recognize
> > V4L2_SUBDEV_FORMAT_TRY and always works as if V4L2_SUBDEV_FORMAT_ACTIVE
> > is specified.
> >
> > Cc: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
> > Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
> > Cc: Marco Felsch <m.felsch@pengutronix.de>
> > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > ---
> > * v3
> > - Set initial try format with default configuration instead of
> >   current one.
> >
> >  drivers/media/i2c/mt9m111.c | 30 ++++++++++++++++++++++++++++++
> >  1 file changed, 30 insertions(+)
> >
> > diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
> > index d639b9b..63a5253 100644
> > --- a/drivers/media/i2c/mt9m111.c
> > +++ b/drivers/media/i2c/mt9m111.c
> > @@ -528,6 +528,16 @@ static int mt9m111_get_fmt(struct v4l2_subdev *sd,
> >       if (format->pad)
> >               return -EINVAL;
> >
> > +     if (format->which =3D=3D V4L2_SUBDEV_FORMAT_TRY) {
> > +#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
> > +             mf =3D v4l2_subdev_get_try_format(sd, cfg, format->pad);
> > +             format->format =3D *mf;
> > +             return 0;
> > +#else
> > +             return -ENOTTY;
> > +#endif
>
> If've checked this again and found the ov* devices do this too. IMO it's
> not good for other developers to check the upper layer if the '#else'
> path is reachable. There are also some code analyzer tools which will
> report this as issue/warning.
>
> As I said, I checked the v4l2_subdev_get_try_format() usage again and
> found the solution made by the mt9v111.c better. Why do you don't add a
> dependency in the Kconfig, so we can drop this ifdef?

I'm ok with adding CONFIG_VIDEO_V4L2_SUBDEV_API dependency to this
driver, because I always enable it.

But it may cause an issue on some environments that don't require
CONFIG_VIDEO_V4L2_SUBDEV_API.

Sakari, do you have any opinion?
