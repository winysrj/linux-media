Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:35283 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751646AbdF2Jhq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 05:37:46 -0400
MIME-Version: 1.0
In-Reply-To: <17f2a43c3500f610f8df2548f51555eb5ae03293.1498575029.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.13d48bb2ba66a5e11c962c62b1a7b5832b0a2344.1498575029.git-series.kieran.bingham+renesas@ideasonboard.com>
 <17f2a43c3500f610f8df2548f51555eb5ae03293.1498575029.git-series.kieran.bingham+renesas@ideasonboard.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 29 Jun 2017 11:37:43 +0200
Message-ID: <CAMuHMdUcxU8avfS6s67E9jnorZYC7ouN7erph=3kVoyH_5C39Q@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] media: adv748x: Add adv7181, adv7182 bindings
To: Kieran Bingham <kbingham@kernel.org>
Cc: Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 27, 2017 at 5:03 PM, Kieran Bingham <kbingham@kernel.org> wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>
> Create device tree bindings documentation for the ADV748x.
> The ADV748x supports both the ADV7481 and ADV7482 chips which
> provide analogue decoding and HDMI receiving capabilities

The subject says adv7*1*81, adv7*1*82.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
