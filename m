Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49C05C43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 14:09:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A716217D4
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 14:09:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EvfkU4cd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbfAGOJn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 09:09:43 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37577 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728076AbfAGOJm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2019 09:09:42 -0500
Received: by mail-pf1-f193.google.com with SMTP id y126so223728pfb.4;
        Mon, 07 Jan 2019 06:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OYzw+MaHktdblA7V3UuEKc+6dk3yurU0nsmjzxJmuck=;
        b=EvfkU4cd6aFYwaL7leZJiEc3KSMzBJPG4xw+laffeS82FtyqsKj7xitOjqV1K+C3lR
         weZsxZ1z/0j7qYJJZGv2DHCnR42K85wSG4Goh8S8OWX+Sq6PEstC1BoWiOUOth1kFbom
         94BHq+MIDqVBtXCPDGuE1NwR0uK86teuC5dRgZudWOvH9VfRvFTxKYjUbvLGXiFJ4MnG
         CB3I6hxF5Gm+ofvH5yS2sLFo5OriKKHiXH5oNTMfZ+SwaxkLGhg81SMpIV8rQITc/bkq
         mvg8APXL6NYva397FC/32SttocEal45Xl58Ijd+E5Mo9HBmY0LaGF86zKIOfmrVWURtf
         mRAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OYzw+MaHktdblA7V3UuEKc+6dk3yurU0nsmjzxJmuck=;
        b=tPF+h2hto5GGOAkNTIiFrwFelY5jJjMb9g0RwEFdS4Oakzfa/+QngAEcA7rSfoVaWm
         au2z1LDES0Q5ppRhtQRqMYvWRzJ2DE9oMY1VRCDvZKLYheaDKRUJ1k0e+u5ZRHq1XH0h
         Q7T4SAUQHqc45N/drGOcZ+1Z6QrINRnRJREhDfVKQMDqo5vIMWtL4drbJdmza7B1FKvT
         SAmU4zunA5NjvV67zaoaAyY0tT3XGmtrz/xcpOptC5l7V56tomEx7FQrZiylyUAh72lm
         Wsu+dP0hiXM62LJShLbJEV8l9Q/DyMj2cNYEF6G7wSCtV1tuQENwEaZXDjUYzr4hKOPd
         ZOLw==
X-Gm-Message-State: AJcUukcQM7E63cF8UITMRHN6DmYYnMMWMdXxrfARruNaVsN4zZUOj373
        d6Rw4JW92iLMZbFTs5owL9D/vz+no05wq12QL9h2bA==
X-Google-Smtp-Source: ALg8bN448OrMpeHPDgAQK5F2/EjgY2D76oX/n9jSqeNyaKCaKdSg/MbjpsiEL3pfgS7FGqNXiYcBWHqDBEUy7wll2LQ=
X-Received: by 2002:a63:5207:: with SMTP id g7mr11154875pgb.253.1546870181271;
 Mon, 07 Jan 2019 06:09:41 -0800 (PST)
MIME-Version: 1.0
References: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
 <1545498774-11754-10-git-send-email-akinobu.mita@gmail.com> <20190107112742.grz2nvaqmcufoblk@kekkonen.localdomain>
In-Reply-To: <20190107112742.grz2nvaqmcufoblk@kekkonen.localdomain>
From:   Akinobu Mita <akinobu.mita@gmail.com>
Date:   Mon, 7 Jan 2019 23:09:30 +0900
Message-ID: <CAC5umyjoKLOMK_kYovzgkmrzVCwzCj2Yv28p65TTZjBmiE+TGw@mail.gmail.com>
Subject: Re: [PATCH 09/12] media: mt9m001: register to V4L2 asynchronous
 subdevice framework
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     linux-media@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

2019=E5=B9=B41=E6=9C=887=E6=97=A5(=E6=9C=88) 20:27 Sakari Ailus <sakari.ail=
us@linux.intel.com>:
>
> Hi Mita-san,
>
> On Sun, Dec 23, 2018 at 02:12:51AM +0900, Akinobu Mita wrote:
> > Register a sub-device to the asynchronous subdevice framework, and also
> > create subdevice device node.
> >
> > Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > ---
> >  drivers/media/i2c/Kconfig   | 2 +-
> >  drivers/media/i2c/mt9m001.c | 9 ++++++++-
> >  2 files changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> > index 5e30ad3..a6d8416 100644
> > --- a/drivers/media/i2c/Kconfig
> > +++ b/drivers/media/i2c/Kconfig
> > @@ -845,7 +845,7 @@ config VIDEO_VS6624
> >
> >  config VIDEO_MT9M001
> >       tristate "mt9m001 support"
> > -     depends on I2C && VIDEO_V4L2
> > +     depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
>
> VIDEO_V4L2_SUBDEV_API depends on MEDIA_CONTROLLER, so MEDIA_CONTROLLER
> below can be removed.

OK.

> >       depends on MEDIA_CAMERA_SUPPORT
> >       depends on MEDIA_CONTROLLER
> >       help
> > diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
> > index e31fb7d..b4deec3 100644
> > --- a/drivers/media/i2c/mt9m001.c
> > +++ b/drivers/media/i2c/mt9m001.c
> > @@ -716,6 +716,7 @@ static int mt9m001_probe(struct i2c_client *client,
> >               return PTR_ERR(mt9m001->reset_gpio);
> >
> >       v4l2_i2c_subdev_init(&mt9m001->subdev, client, &mt9m001_subdev_op=
s);
> > +     mt9m001->subdev.flags =3D V4L2_SUBDEV_FL_HAS_DEVNODE;
>
> |=3D
>
> Otherwise you lose flags set by v4l2_i2c_subdev_init().

Oops.  Thanks for spotting.
