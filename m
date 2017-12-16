Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:32956 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756913AbdLPSdQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Dec 2017 13:33:16 -0500
Received: by mail-wm0-f67.google.com with SMTP id g130so2242784wme.0
        for <linux-media@vger.kernel.org>; Sat, 16 Dec 2017 10:33:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1513447230-30948-4-git-send-email-tharvey@gateworks.com>
References: <1513447230-30948-1-git-send-email-tharvey@gateworks.com> <1513447230-30948-4-git-send-email-tharvey@gateworks.com>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Sat, 16 Dec 2017 19:32:34 +0100
Message-ID: <CAOFm3uEmV+oeQhh48X7+bpn8HPP85ho5=sN2oVVKAOdnftskng@mail.gmail.com>
Subject: Re: [PATCH v5 3/6] media: dt-bindings: Add bindings for TDA1997X
To: Tim Harvey <tharvey@gateworks.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        ALSA <alsa-devel@alsa-project.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tim,

On Sat, Dec 16, 2017 at 7:00 PM, Tim Harvey <tharvey@gateworks.com> wrote:
> Cc: Rob Herring <robh@kernel.org>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Tim Harvey <tharvey@gateworks.com>

<snip>

> --- /dev/null
> +++ b/include/dt-bindings/media/tda1997x.h
> @@ -0,0 +1,78 @@
> +/*
> + * Copyright (C) 2017 Gateworks Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */

Please consider using the new SPDX tags per Thomas doc patches [1]
Thanks!
[1] https://lkml.org/lkml/2017/12/4/934
-- 
Cordially
Philippe Ombredanne, your friendly kernel licensing scruffy
