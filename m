Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:45361 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750802AbdLWOJd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Dec 2017 09:09:33 -0500
Received: by mail-wm0-f66.google.com with SMTP id 9so26171068wme.4
        for <linux-media@vger.kernel.org>; Sat, 23 Dec 2017 06:09:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <07ce3ca4-b1db-331d-9218-83a2e7cc2017@maciej.szmigiero.name>
References: <cover.1513982691.git.mail@maciej.szmigiero.name> <07ce3ca4-b1db-331d-9218-83a2e7cc2017@maciej.szmigiero.name>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Sat, 23 Dec 2017 15:08:51 +0100
Message-ID: <CAOFm3uE9F2nBTUyz6U0Xac7fo1QtcZdzg-i7T=eQt09RB540RA@mail.gmail.com>
Subject: Re: [PATCH v5 3/6] cx25840: add pin to pad mapping and output format configuration
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andy Walls <awalls@md.metrocast.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Dec 23, 2017 at 12:18 AM, Maciej S. Szmigiero
<mail@maciej.szmigiero.name> wrote:
> This commit adds pin to pad mapping and output format configuration support
> in CX2584x-series chips to cx25840 driver.
>
> This functionality is then used to allow disabling ivtv-specific hacks
> (called a "generic mode"), so cx25840 driver can be used for other devices
> not needing them without risking compatibility problems.
>
> Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
> ---
>  drivers/media/i2c/cx25840/cx25840-core.c | 396 ++++++++++++++++++++++++++++++-
>  drivers/media/i2c/cx25840/cx25840-core.h |  13 +
>  drivers/media/i2c/cx25840/cx25840-vbi.c  |   3 +
>  include/media/drv-intf/cx25840.h         |  74 +++++-
>  4 files changed, 484 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
> index 2189980a0f29..e2fd33a64550 100644
> --- a/drivers/media/i2c/cx25840/cx25840-core.c
> +++ b/drivers/media/i2c/cx25840/cx25840-core.c
> @@ -21,6 +21,9 @@
>   * CX23888 DIF support for the HVR1850
>   * Copyright (C) 2011 Steven Toth <stoth@kernellabs.com>
>   *
> + * CX2584x pin to pad mapping and output format configuration support are
> + * Copyright (C) 2011 Maciej S. Szmigiero <mail@maciej.szmigiero.name>
> + *
>   * This program is free software; you can redistribute it and/or
>   * modify it under the terms of the GNU General Public License
>   * as published by the Free Software Foundation; either version 2

Since you are touching the copyright here, I wonder if you could reach
out to other copyright holders and switch to using an SPDX tag
instead?

-- 
Cordially
Philippe Ombredanne
