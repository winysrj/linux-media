Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C79BC43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 15:40:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A77F20883
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 15:40:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N0Da2FZI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbfAHPkq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 10:40:46 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35565 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728238AbfAHPkq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 10:40:46 -0500
Received: by mail-pg1-f193.google.com with SMTP id s198so1903875pgs.2;
        Tue, 08 Jan 2019 07:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WPzW3mRWfIWm21hgekZFtj1UDNWUPREGt23MRPnQSH8=;
        b=N0Da2FZIUDEk7Oxbhq4aQvovd3Hx/psXNOfjrhoQ9R5jbFR9Znh/04aGCTKj191IRL
         gUz2oA0WZ7+9Dt9G7dMG2FbVO5I/38gWm9qL237HsAIV/FcH1lmDwDk4CvlVkkCC29vG
         Y3vqL+SlYd6KsevFj79oBU4NEAAcoMRJDwR+Gt4+zYlGmsWRvVoe8+EOQ/M+gwLFGgQN
         5s7qgXkpueaqSAyfQmByM/935LwsrK+9ZmH2CHe8AENtDg6rPZSTCtNaLDrio/nL1HM9
         dP87TQpBw6Gj0/SpuKdS/G20G/l9w5s6KupVXpadp7yTIjx6g9rgtWoPPCSCq1B1Fw6Z
         Mprw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WPzW3mRWfIWm21hgekZFtj1UDNWUPREGt23MRPnQSH8=;
        b=Vo/xn+tyZsHahgu2GiU1GMHy1TJZYAXOKXQ8wmLWkqUR3uFw9gDJxU7YuJZttAQb1f
         usgCriuVSJrWgqothDmDrbrXhpD1mAYiwdl3kJkVqVme7yOr7cjV5O8W4X9gLmeN9Bvb
         pt0IsrAsEvZpkDwTKLn3tctOevQXunXidp0v+LHEkFh5rlYWMXSUmSBHcDv0RnLJJP+J
         AUReem/2wedfvqULKU/vS/iKd693DGeGs+boilWuk6pyh57DggbxRv+vTwtXaQh+RZVN
         /S9kN1237Xx8gWnsk9CdHsTELw4G8DBwAfmPVb9hWTcL/HxJtrOAqmkHDWpiyC53ViP2
         R9Iw==
X-Gm-Message-State: AJcUukdU38YNjbVpfdl37v7nwjIOCRfw9TCP17WKq4JoYzZaIVv6YHX0
        nuDRhQp/FOZVfyIJznajcoUZp6uxTVqnN8apaZl5RQ==
X-Google-Smtp-Source: ALg8bN7geg6OANAS5R+pI3MSWxEVoYIldmPxGhFIp2gM0jk5zzeJ4/X5c/UN/5NY6HKgtdBJRRXcWwr1tsdwaGiIFF0=
X-Received: by 2002:a62:de06:: with SMTP id h6mr2276102pfg.158.1546962044667;
 Tue, 08 Jan 2019 07:40:44 -0800 (PST)
MIME-Version: 1.0
References: <1546959110-19445-1-git-send-email-akinobu.mita@gmail.com> <1546959110-19445-9-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1546959110-19445-9-git-send-email-akinobu.mita@gmail.com>
From:   Akinobu Mita <akinobu.mita@gmail.com>
Date:   Wed, 9 Jan 2019 00:40:33 +0900
Message-ID: <CAC5umyhkAQdKY9PHiZR61UKUu8a8J2V4SrVZ0hu8LC3JeZQjeA@mail.gmail.com>
Subject: Re: [PATCH v2 08/13] media: mt9m001: remove remaining soc_camera
 specific code
To:     linux-media@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Cc:     Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

2019=E5=B9=B41=E6=9C=888=E6=97=A5(=E7=81=AB) 23:52 Akinobu Mita <akinobu.mi=
ta@gmail.com>:
>
> Remove remaining soc_camera specific code and drop soc_camera dependency
> from this driver.
>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
> * No changes from v1
>
>  drivers/media/i2c/Kconfig   |  2 +-
>  drivers/media/i2c/mt9m001.c | 84 ++++++++-------------------------------=
------
>  2 files changed, 15 insertions(+), 71 deletions(-)
>
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index ee3ef1b..bc248d9 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -859,7 +859,7 @@ config VIDEO_VS6624
>
>  config VIDEO_MT9M001
>         tristate "mt9m001 support"
> -       depends on SOC_CAMERA && I2C
> +       depends on I2C && VIDEO_V4L2
>         help
>           This driver supports MT9M001 cameras from Micron, monochrome
>           and colour models.
> diff --git a/drivers/media/i2c/mt9m001.c b/drivers/media/i2c/mt9m001.c
> index 1619c8c..0f5e3f9 100644
> --- a/drivers/media/i2c/mt9m001.c
> +++ b/drivers/media/i2c/mt9m001.c
> @@ -15,15 +15,12 @@
>  #include <linux/slab.h>
>  #include <linux/videodev2.h>
>
> -#include <media/drv-intf/soc_mediabus.h>
> -#include <media/soc_camera.h>
>  #include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
>  #include <media/v4l2-subdev.h>
>
>  /*
>   * mt9m001 i2c address 0x5d
> - * The platform has to define struct i2c_board_info objects and link to =
them
> - * from struct soc_camera_host_desc
>   */
>
>  /* mt9m001 selected register addresses */
> @@ -276,11 +273,15 @@ static int mt9m001_set_selection(struct v4l2_subdev=
 *sd,
>         rect.width =3D ALIGN(rect.width, 2);
>         rect.left =3D ALIGN(rect.left, 2);
>
> -       soc_camera_limit_side(&rect.left, &rect.width,
> -                    MT9M001_COLUMN_SKIP, MT9M001_MIN_WIDTH, MT9M001_MAX_=
WIDTH);
> +       rect.width =3D clamp_t(u32, rect.width, MT9M001_MIN_WIDTH,
> +                       MT9M001_MAX_WIDTH);
> +       rect.left =3D clamp_t(u32, rect.left, MT9M001_COLUMN_SKIP,
> +                       MT9M001_COLUMN_SKIP + MT9M001_MAX_WIDTH - rect.wi=
dth);
>
> -       soc_camera_limit_side(&rect.top, &rect.height,
> -                    MT9M001_ROW_SKIP, MT9M001_MIN_HEIGHT, MT9M001_MAX_HE=
IGHT);
> +       rect.height =3D clamp_t(u32, rect.height, MT9M001_MIN_HEIGHT,
> +                       MT9M001_MAX_HEIGHT);
> +       rect.top =3D clamp_t(u32, rect.top, MT9M001_ROW_SKIP,
> +                       MT9M001_ROW_SKIP + MT9M001_MAX_HEIGHT - rect.widt=
h);

Oops.  This line isn't correct. s/rect.width/rect.height/
