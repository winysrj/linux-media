Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:35000 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbdEBQQw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 May 2017 12:16:52 -0400
MIME-Version: 1.0
In-Reply-To: <20170502132615.42134-3-ramesh.shanmugasundaram@bp.renesas.com>
References: <20170502132615.42134-1-ramesh.shanmugasundaram@bp.renesas.com> <20170502132615.42134-3-ramesh.shanmugasundaram@bp.renesas.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 2 May 2017 18:16:50 +0200
Message-ID: <CAMuHMdX7Hff=t=oQf4oygJMqhgxhwrh5cOjuEJCx=7vy28mMfg@mail.gmail.com>
Subject: Re: [PATCH v4 2/7] dt-bindings: media: Add MAX2175 binding description
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ramesh,

On Tue, May 2, 2017 at 3:26 PM, Ramesh Shanmugasundaram
<ramesh.shanmugasundaram@bp.renesas.com> wrote:
> --- a/Documentation/devicetree/bindings/property-units.txt
> +++ b/Documentation/devicetree/bindings/property-units.txt
> @@ -28,6 +28,7 @@ Electricity
>  -ohms          : Ohms
>  -micro-ohms    : micro Ohms
>  -microvolt     : micro volts
> +-pF            : pico farads

All electrical units seem to use long(er) names.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
