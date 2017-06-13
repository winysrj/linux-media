Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:34614 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751834AbdFMJgM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 05:36:12 -0400
MIME-Version: 1.0
In-Reply-To: <20170613091056.20796-1-ramesh.shanmugasundaram@bp.renesas.com>
References: <20170612132620.1024-4-ramesh.shanmugasundaram@bp.renesas.com> <20170613091056.20796-1-ramesh.shanmugasundaram@bp.renesas.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 13 Jun 2017 11:36:10 +0200
Message-ID: <CAMuHMdXbuzQqC4bgTfZ_HJ5wMduvrv4XPdTw_y-VjfrUDj38WA@mail.gmail.com>
Subject: Re: [PATCH v9] media: i2c: max2175: Add MAX2175 support
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Antti Palosaari <crope@iki.fi>,
        Chris Paterson <chris.paterson2@renesas.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ramesh,

On Tue, Jun 13, 2017 at 11:10 AM, Ramesh Shanmugasundaram
<ramesh.shanmugasundaram@bp.renesas.com> wrote:
> This patch adds driver support for the MAX2175 chip. This is Maxim
> Integrated's RF to Bits tuner front end chip designed for software-defined
> radio solutions. This driver exposes the tuner as a sub-device instance
> with standard and custom controls to configure the device.
>
> Signed-off-by: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
> ---
> Hi Hans,
>
>    As requested, here is the v9 of this patch alone implementing the work
>    around to avoid the sparse warning.
>
>    https://www.mail-archive.com/linux-renesas-soc@vger.kernel.org/msg15138.html
>
>    For some reason, I could not reproduce this warning in my setup :-(
>
> Thanks,
> Ramesh.
>
> v9:
>  - Work around to avoid a sparse warning generated because of
>    regmap_read_poll_timeout macro implementation.

> +/* Checks expected pattern every msec until timeout */
> +static int max2175_poll_timeout(struct max2175 *ctx, u8 idx, u8 msb, u8 lsb,
> +                               u8 exp_bitval, u32 timeout_ms)
> +{
> +       unsigned int val;
> +
> +       /*
> +        * The brackets around the last parameter is a work around to avoid
> +        * the sparse tool warning. The ideal fix is to use brackets for the
> +        * last parameter of regmap_read_poll_timeout macro.
> +        */
> +       return regmap_read_poll_timeout(ctx->regmap, idx, val,
> +                       (max2175_get_bitval(val, msb, lsb) == exp_bitval),
> +                       1000, (timeout_ms * 1000));

I don't think that issue should be fixed here, so I prefer v8.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
