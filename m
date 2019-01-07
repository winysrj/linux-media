Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37912C43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 14:20:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03CA42087F
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 14:20:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S2qiDDyy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbfAGOUl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 09:20:41 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44643 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbfAGOUl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2019 09:20:41 -0500
Received: by mail-pl1-f193.google.com with SMTP id e11so205421plt.11;
        Mon, 07 Jan 2019 06:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+2RzgdBoJDPF9OEcROb6SWwLnkxEKxtApUxtPtS0uTk=;
        b=S2qiDDyyAsDrECzvYw6XYRr6sQVQ3LNQihOVBn8J24a6BfYHRJcFqco4bWA+yw5H18
         4Ja6+1bcJEpWbwkIqdFqFKwNOfRYS/WU6OkUcdSnku53mrenPO6b3RHl29/ynUowffLm
         sp4vY1UShn68iIq67Jc+WVS2S8jRxA/pWuMMNTbccUKBACTDcGVoYh1hWE9RxBcqL74k
         HAWiKreF1ssasMDayafJeHUPpPOjM1B89Ie+TzcmUjTGO5GfAQeV8myTbMOKefwcGWFx
         QsXiG7/SAHt2cdXuROKDzODTiM70jdAN353DKOOROAJ3KHaLqKnGxyz2YeV/ZLHqXBpa
         /K1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+2RzgdBoJDPF9OEcROb6SWwLnkxEKxtApUxtPtS0uTk=;
        b=RLC1ZhpBnQNDyyN5IJEuttyOleBn6Y+QxcdU/yMp7WoG/x57rm6uKAP0Sa/clXU10E
         XjZ+wxihcVtrXaq6gUatrwZxq9zG+J0enfptbIpaKfaGdhxe1XnSrPP1ae8AX0dFy/pg
         WNsVZmoZ9aOO5Bl/7sXobNIEVeBi4Bmvvdm6BICjxxBCmO2Th4D+yC9AtZg1+jGRy58Z
         lkPHVJdZL+8pjMYileMmhiSAGHqhPFhoNwrRYtfg2OVL3xseoQBbY9uIm2duV59qJxen
         H6kYELIaHcZSNzWZhT6xsaoUiNXB/5445c4SLF6+sNmfHZOkYTCMIxxyBV7o+IQAPJ8b
         ai5Q==
X-Gm-Message-State: AJcUukfvKBvOQe8XS0Mb1ggL8IcZng2J+l6Hnwf4WNMArCWdcAa7wRWh
        Yd3R3Cd9ytjMcn6Ex1iTft5YnGSuzCNvbV+l6Vc=
X-Google-Smtp-Source: ALg8bN6027/M5OGfIQ4fudQH10Wy7HKjbB++lW+Wg3/jBiwtjBzSrI2TecGImRyg0DNEeE/ow6e1ZBf/cEg7dZSTTj0=
X-Received: by 2002:a17:902:4081:: with SMTP id c1mr62528045pld.87.1546870840057;
 Mon, 07 Jan 2019 06:20:40 -0800 (PST)
MIME-Version: 1.0
References: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
 <1545498774-11754-4-git-send-email-akinobu.mita@gmail.com> <20190107113708.oex222eb6ndd3hou@kekkonen.localdomain>
In-Reply-To: <20190107113708.oex222eb6ndd3hou@kekkonen.localdomain>
From:   Akinobu Mita <akinobu.mita@gmail.com>
Date:   Mon, 7 Jan 2019 23:20:29 +0900
Message-ID: <CAC5umyjG7i+1OJSZLoUSAmgqrfVR8QZ-aREEpM3ssMDEbgbGJw@mail.gmail.com>
Subject: Re: [PATCH 03/12] media: mt9m001: convert to SPDX license identifer
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

2019=E5=B9=B41=E6=9C=887=E6=97=A5(=E6=9C=88) 20:37 Sakari Ailus <sakari.ail=
us@linux.intel.com>:
>
> Hi Mita-san,
>
> On Sun, Dec 23, 2018 at 02:12:45AM +0900, Akinobu Mita wrote:
> > Replace GPL license statements with SPDX license identifiers (GPL-2.0).
> >
> > Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > ---
> >  drivers/media/i2c/mt9m001.c | 5 +----
> >  1 file changed, 1 insertion(+), 4 deletions(-)
> >
> > diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
> > index a1a85ff..65ff59d 100644
> > --- a/drivers/media/i2c/mt9m001.c
> > +++ b/drivers/media/i2c/mt9m001.c
> > @@ -1,11 +1,8 @@
> > +// SPDX-License-Identifier: GPL-2.0
> >  /*
> >   * Driver for MT9M001 CMOS Image Sensor from Micron
> >   *
> >   * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
> > - *
> > - * This program is free software; you can redistribute it and/or modif=
y
> > - * it under the terms of the GNU General Public License version 2 as
> > - * published by the Free Software Foundation.
> >   */
> >
> >  #include <linux/videodev2.h>
>
> The MODULE_LICENSE macro at the end of the file lists "GPL" as the licens=
e,
> i.e. including later versions. I'm not sure what was the intention
> originally. I guess it's safer to stick to 2.0, at least unless the
> original author is able to shed some light into this.

I've come across the same thought, and I found the following conversation.

https://lkml.org/lkml/2018/6/24/457

So I think MODULE_LICENSE() mismatch can be resolved in the future.
