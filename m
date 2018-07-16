Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:44863 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727531AbeGPOh6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jul 2018 10:37:58 -0400
Message-ID: <1531750220.18173.20.camel@pengutronix.de>
Subject: Re: [PATCH 16/16] media: imx: add mem2mem device
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-media@vger.kernel.org, kernel@pengutronix.de,
        Steve Longerbeam <slongerbeam@gmail.com>
Date: Mon, 16 Jul 2018 16:10:20 +0200
In-Reply-To: <20180710120737.GC6884@amd>
References: <20180622155217.29302-1-p.zabel@pengutronix.de>
         <20180622155217.29302-17-p.zabel@pengutronix.de>
         <20180710120737.GC6884@amd>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Tue, 2018-07-10 at 14:07 +0200, Pavel Machek wrote:
[...]
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * i.MX IPUv3 mem2mem Scaler/CSC driver
> > + *
> > + * Copyright (C) 2011 Pengutronix, Sascha Hauer
> > + * Copyright (C) 2018 Pengutronix, Philipp Zabel
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + */
> 
> Point of SPDX is that the last 4 lines can be removed...and if you
> want GPL-2.0+ as you state (and I like that), you should also say so
> in SPDX.

Thank you, I'll fix this in v2.

regards
Philipp
