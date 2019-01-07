Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 951FEC43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 14:13:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6367E2070B
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 14:13:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dix7yY1r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbfAGONr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 09:13:47 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41174 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbfAGONr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2019 09:13:47 -0500
Received: by mail-pg1-f195.google.com with SMTP id m1so191435pgq.8;
        Mon, 07 Jan 2019 06:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FeD9gjkkN7zLLh+2KIWM79cDaqhoDkmms4YVh/JDZmc=;
        b=dix7yY1r3B2vGFl6Xamp7KHpIDsL7v4vD9tJOLUesx0GtPMKtGEjuJATDeux2XptfX
         GNGNo2/cPyyeyYjaHrAoEfHTcQF6nRTIIEOabhEUzNjSazsLbNV4A3AwFIIxOJXxe9CQ
         eGsWBTprze1aXDyySJQCvflRbwMOL2kUxeAHcy6P8m6hD8ydb2mm672iWnIqT8/XIJjk
         pzibzTswFvnj5JLNYt/mUjnaiuW3e+Li6BJYkcatSN73O6e41KoLlj7gidiZOcGSrKYv
         iZWcgUiXjgAZfivYsYzuRY9VtSkzzXMaj8r30VKkwVoycYWYnaQlOMmRO1JKutXmOmG1
         Vqnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FeD9gjkkN7zLLh+2KIWM79cDaqhoDkmms4YVh/JDZmc=;
        b=X6zvNTNGMreUhyQK43Un3gWlCIZyQIVxbjKzmjIPxfH3vwFZ7a0+CHrHapf+FvpH+I
         WVVEfNsfn+Ug0xxXVZXBDQMy1zBnBk2gAmvFAz4g0et7djMCKBNMDDeb3Ad6inwf/5Dn
         ExiGmdPkzPDH59LtvYRC14roPeicRiAafWeo+8loYlIQb2gcER6Xle7oq8tQ+MrKtBof
         /icVb/5mXe7D/ZKg4efRF29zFVpEgC1Uu8OpHCEsWpGCXQklY/Wev1i4ffVcAY4KxaGL
         3IyXOgoIIoF+s1mE3W7A2w9j+yHtfgvYbYgwu/XPiBeE2N4FcxvMjs3HbijoeyzBq7UB
         RKdw==
X-Gm-Message-State: AJcUukekNgFQxZZfqgVIqMj3Iv7c6fww3V7uzSSTYEJb28YFIC5Y7KP0
        4g+4YNI1GEkUKctkEgOGFbZSgSDpvF1IoPljwFE=
X-Google-Smtp-Source: ALg8bN6zff6Z0pcNWoApP4hBs/bG3JCyucixfcxBEISOkTHtZyV9zXKQFqiq/zWjqGSFAjSYzix9efK9r34pkeC6R+c=
X-Received: by 2002:a63:31cc:: with SMTP id x195mr30327494pgx.52.1546870426455;
 Mon, 07 Jan 2019 06:13:46 -0800 (PST)
MIME-Version: 1.0
References: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
 <1545498774-11754-8-git-send-email-akinobu.mita@gmail.com> <20190107112910.waj5sbjje7vobrof@kekkonen.localdomain>
In-Reply-To: <20190107112910.waj5sbjje7vobrof@kekkonen.localdomain>
From:   Akinobu Mita <akinobu.mita@gmail.com>
Date:   Mon, 7 Jan 2019 23:13:35 +0900
Message-ID: <CAC5umyhHe-56oOOPHDD=-e8bUvJ=HkyKM7HEbJjgkOKTwM=4TA@mail.gmail.com>
Subject: Re: [PATCH 07/12] media: mt9m001: remove remaining soc_camera
 specific code
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

2019=E5=B9=B41=E6=9C=887=E6=97=A5(=E6=9C=88) 20:29 Sakari Ailus <sakari.ail=
us@linux.intel.com>:
>
> Hi Mita-san,
>
> On Sun, Dec 23, 2018 at 02:12:49AM +0900, Akinobu Mita wrote:
> > Remove remaining soc_camera specific code and drop soc_camera dependenc=
y
> > from this driver.
> >
> > Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > ---
> >  drivers/media/i2c/Kconfig   |  2 +-
> >  drivers/media/i2c/mt9m001.c | 84 ++++++++-----------------------------=
--------
> >  2 files changed, 15 insertions(+), 71 deletions(-)
> >
> > diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> > index 0efc038..4bdf043 100644
> > --- a/drivers/media/i2c/Kconfig
> > +++ b/drivers/media/i2c/Kconfig
> > @@ -845,7 +845,7 @@ config VIDEO_VS6624
> >
> >  config VIDEO_MT9M001
> >       tristate "mt9m001 support"
> > -     depends on SOC_CAMERA && I2C
> > +     depends on I2C && VIDEO_V4L2
> >       help
> >         This driver supports MT9M001 cameras from Micron, monochrome
> >         and colour models.
> > diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
> > index f20188a..eb5c4ed 100644
> > --- a/drivers/media/i2c/mt9m001.c
> > +++ b/drivers/media/i2c/mt9m001.c
> > @@ -15,15 +15,12 @@
> >  #include <linux/log2.h>
> >  #include <linux/module.h>
> >
> > -#include <media/soc_camera.h>
> > -#include <media/drv-intf/soc_mediabus.h>
> >  #include <media/v4l2-subdev.h>
> >  #include <media/v4l2-ctrls.h>
>
> While at it, could you order the list alphabetically? The same applies to
> further patches changing included files.

OK.  I'll prepare another separate patch.
