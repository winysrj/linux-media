Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:34817 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752795AbcLGUDP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2016 15:03:15 -0500
Received: by mail-io0-f175.google.com with SMTP id a124so731309370ioe.2
        for <linux-media@vger.kernel.org>; Wed, 07 Dec 2016 12:03:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161207183025.20684-1-khilman@baylibre.com>
References: <20161207183025.20684-1-khilman@baylibre.com>
From: Javier Martinez Canillas <javier@dowhile0.org>
Date: Wed, 7 Dec 2016 17:03:13 -0300
Message-ID: <CABxcv=nrDACjfjStNPky5_y5zXBpzLZyO3g9WuOz95C6b_bgOg@mail.gmail.com>
Subject: Re: [PATCH v6 0/5] davinci: VPIF: add DT support
To: Kevin Hilman <khilman@baylibre.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>,
        Axel Haslam <ahaslam@baylibre.com>,
        =?UTF-8?Q?Bartosz_Go=C5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Kevin,

On Wed, Dec 7, 2016 at 3:30 PM, Kevin Hilman <khilman@baylibre.com> wrote:
> Prepare the groundwork for adding DT support for davinci VPIF drivers.
> This series does some fixups/cleanups and then adds the DT binding and
> DT compatible string matching for DT probing.
>
> The controversial part from previous versions around async subdev
> parsing, and specifically hard-coding the input/output routing of
> subdevs, has been left out of this series.  That part can be done as a
> follow-on step after agreement has been reached on the path forward.

I had a similar need for another board (OMAP3 IGEPv2), that has a
TVP5151 video decoder (that also supports 2 composite or 1 s-video
signal) attached to the OMAP3 ISP.

I posted some RFC patches [0] to define the input signals in the DT,
and AFAICT Laurent and Hans were not against the approach but just had
some comments on the DT binding.

Basically they wanted the ports to be directly in the tvp5150 node
instead of under a connectors sub-node [1] and to just be called just
a (input / output) port instead of a connector [2].

Unfortunately I was busy with other tasks so I couldn't res-pin the
patches, but I think you could have something similar in the DT
binding for your case and it shouldn't be hard to parse the ports /
endpoints in the driver to get that information from DT and setup the
input and output pins.

> With this version, platforms can still use the VPIF capture/display
> drivers, but must provide platform_data for the subdevs and subdev
> routing.
>

I guess DT backward compatibility isn't a big issue on this platform,
since support for the platform is quite recently and after all someone
who wants to use the vpif with current DT will need platform data and
pdata-quirks anyways. So I agree with you that the input / output
signals lookup from DT could be done as a follow-up.

[0]: https://lkml.org/lkml/2016/4/12/983
[1]: https://lkml.org/lkml/2016/4/27/678
[2]: https://lkml.org/lkml/2016/11/11/346

Best regards,
Javier
