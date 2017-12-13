Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:42256 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752998AbdLMNDc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 08:03:32 -0500
Received: by mail-wm0-f68.google.com with SMTP id b199so4923570wme.1
        for <linux-media@vger.kernel.org>; Wed, 13 Dec 2017 05:03:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1510743363-25798-8-git-send-email-jacopo+renesas@jmondi.org>
References: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org> <1510743363-25798-8-git-send-email-jacopo+renesas@jmondi.org>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Wed, 13 Dec 2017 14:02:50 +0100
Message-ID: <CAOFm3uHvU6W8FDsO8zH7+akJfALedQvbXwtfLsUQ-RRt7iWv5g@mail.gmail.com>
Subject: Re: [PATCH v1 07/10] v4l: i2c: Copy ov772x soc_camera sensor driver
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        magnus.damm@gmail.com, geert@glider.be,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-renesas-soc@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-sh@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jacopo,

On Wed, Nov 15, 2017 at 11:56 AM, Jacopo Mondi
<jacopo+renesas@jmondi.org> wrote:
> Copy the soc_camera based driver in v4l2 sensor driver directory.
> This commit just copies the original file without modifying it.
>
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

<snip>

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

You may want to use the new SPDX ids as documented in Thomas doc
patches instead of the loner legalese?
-- 
Cordially
Philippe Ombredanne
