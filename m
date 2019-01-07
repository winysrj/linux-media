Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC47C43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 14:19:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B87602183E
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 14:19:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WNXg4ZtO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfAGOS7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 09:18:59 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39669 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbfAGOS7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2019 09:18:59 -0500
Received: by mail-pg1-f193.google.com with SMTP id w6so201561pgl.6;
        Mon, 07 Jan 2019 06:18:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Zlm4mI9b5XqBGNC0MHyS0lLAo+zWfvjP2FYGaaQ30wA=;
        b=WNXg4ZtOMxGiOFMev/8OGUpB+/i9r96UAcFRudw9XnEIBUgrgqvpv/0rM/wIsrVY8X
         WTq4qIO/8d5B7KJ2CYYk4iMyGn/wJkwgu8zNk3dNG4uxSwNlIfv7Rm7GWpMhAj+wu2vN
         OLxTA52RWLbPYI7nniMbRyCBURox6PB19QFk8wjixkWiDw9AeWyPV3jeKmavk/25QgNW
         3FfKoIywPLfmEZhw9abT6ctE7KlhsGG//X+wtcpTG7xuclPAfxUhimpHSaD+DhxbgJNS
         KiutHhClNYsYFn2LHSEoyA4Su4YKcBbp+rpTG1Yy1WKYv9U2/SAtRy+vVw+3SxEu6FqN
         G6og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Zlm4mI9b5XqBGNC0MHyS0lLAo+zWfvjP2FYGaaQ30wA=;
        b=fGU1Ncn17EB9RKkuOfq3Xxl8MLkCpKvBAYuW7PxMlzi+9oprP5IM4dZbK/rtjEs2xf
         aQn6yT2tzmSRuD/I2eZfunpYpm+dQUIIrzZBxGVbbdyHOi4tBS++H12llPrB7Kjmi91T
         PMzuVeuIsrz13JQrQhaEr5/p9SaxuHOuQOi+yt8LnbEiEWQa6xryixKTmcwk5um3GSaK
         1UvoK8y/hYkf4UOFQyKnNRSoOcXzokod0hT3fNWW3+8r8HjVFVIophpHENZRbE/9xjft
         HlzZbswjMsUpuJUp56PAh2GZtQiaPjyTNK4Xb57hZ3sdau0Riber2KhfOIe9ZgQLyZfR
         Y6OA==
X-Gm-Message-State: AJcUukcr2v47/QRQo/CwLIuOxtdKAjA7wl+ElXsCCHjDz8mQsXGcN2q1
        aQ6rLuCWoIXqOr+03JIwsh91sakUpN47eQlJ7Ts=
X-Google-Smtp-Source: ALg8bN5AHNoMP38I9+yEPrz06rmM9zcz/D1KnqWQGe11SfcdMkmNssZJrpc89pJv2hsYzMfwDnl54cL1793J8RUebnI=
X-Received: by 2002:a63:451a:: with SMTP id s26mr11247207pga.150.1546870738210;
 Mon, 07 Jan 2019 06:18:58 -0800 (PST)
MIME-Version: 1.0
References: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
 <1545498774-11754-13-git-send-email-akinobu.mita@gmail.com> <20190107113243.dte4yqioqy33cwe5@kekkonen.localdomain>
In-Reply-To: <20190107113243.dte4yqioqy33cwe5@kekkonen.localdomain>
From:   Akinobu Mita <akinobu.mita@gmail.com>
Date:   Mon, 7 Jan 2019 23:18:47 +0900
Message-ID: <CAC5umyjrnxZ4FdGsmy9UZ5FSx16RQwDu2StRg67Kov=pxZrodw@mail.gmail.com>
Subject: Re: [PATCH 12/12] media: mt9m001: set all mbus format field when
 G_FMT and S_FMT ioctls
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

2019=E5=B9=B41=E6=9C=887=E6=97=A5(=E6=9C=88) 20:32 Sakari Ailus <sakari.ail=
us@linux.intel.com>:
>
> Hi Mita-san,
>
> On Sun, Dec 23, 2018 at 02:12:54AM +0900, Akinobu Mita wrote:
> > This driver doesn't set all members of mbus format field when the
> > VIDIOC_SUBDEV_{S,G}_FMT ioctls are called.
> >
> > This is detected by v4l2-compliance.
> >
> > Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > ---
> >  drivers/media/i2c/mt9m001.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
> > index f4afbc9..82b89d5 100644
> > --- a/drivers/media/i2c/mt9m001.c
> > +++ b/drivers/media/i2c/mt9m001.c
> > @@ -342,6 +342,9 @@ static int mt9m001_get_fmt(struct v4l2_subdev *sd,
> >       mf->code        =3D mt9m001->fmt->code;
> >       mf->colorspace  =3D mt9m001->fmt->colorspace;
> >       mf->field       =3D V4L2_FIELD_NONE;
> > +     mf->ycbcr_enc   =3D V4L2_YCBCR_ENC_DEFAULT;
> > +     mf->quantization =3D V4L2_QUANTIZATION_DEFAULT;
> > +     mf->xfer_func   =3D V4L2_XFER_FUNC_DEFAULT;
>
> Instead of setting the fields individually, would it be feasible to just
> assign mt9m001->fmt to mf?

The data type of mt9m001->fmt is struct mt9m001_datafmt, so it can't
simply assign to mf.
