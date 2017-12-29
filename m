Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36616 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750744AbdL2MsM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Dec 2017 07:48:12 -0500
Received: by mail-wm0-f68.google.com with SMTP id b76so48194925wmg.1
        for <linux-media@vger.kernel.org>; Fri, 29 Dec 2017 04:48:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1514469681-15602-7-git-send-email-jacopo+renesas@jmondi.org>
References: <1514469681-15602-1-git-send-email-jacopo+renesas@jmondi.org> <1514469681-15602-7-git-send-email-jacopo+renesas@jmondi.org>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Fri, 29 Dec 2017 13:47:30 +0100
Message-ID: <CAOFm3uEU1ZegJgjUYXVJCTLRROtJ_KJDgf1-KiHdoJSw-5zd3Q@mail.gmail.com>
Subject: Re: [PATCH v2 6/9] v4l: i2c: Copy ov772x soc_camera sensor driver
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Magnus Damm <magnus.damm@gmail.com>, geert@glider.be,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-renesas-soc@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-sh@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jacopo,

On Thu, Dec 28, 2017 at 3:01 PM, Jacopo Mondi <jacopo+renesas@jmondi.org> wrote:
> Copy the soc_camera based driver in v4l2 sensor driver directory.
> This commit just copies the original file without modifying it.
> No modification to KConfig and Makefile as soc_camera framework
> dependencies need to be removed first in next commit.
>
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/i2c/ov772x.c | 1124 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 1124 insertions(+)
>  create mode 100644 drivers/media/i2c/ov772x.c
>
> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
> new file mode 100644
> index 0000000..8063835
> --- /dev/null
> +++ b/drivers/media/i2c/ov772x.c
> @@ -0,0 +1,1124 @@
> +/*
> + * ov772x Camera Driver
> + *
> + * Copyright (C) 2008 Renesas Solutions Corp.
> + * Kuninori Morimoto <morimoto.kuninori@renesas.com>
> + *
> + * Based on ov7670 and soc_camera_platform driver,
> + *
> + * Copyright 2006-7 Jonathan Corbet <corbet@lwn.net>
> + * Copyright (C) 2008 Magnus Damm
> + * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */

Do you mind using a simpler SPDX identifier instead of this long
legalese boilerplate?
This is documented in Thomas doc patches. This applies to your entire
patch set of course.
Thanks!
-- 
Cordially
Philippe Ombredanne
