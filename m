Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:46622 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752655AbeAZN4T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Jan 2018 08:56:19 -0500
MIME-Version: 1.0
In-Reply-To: <20180126135421.GJ17416@w540>
References: <1516974528-11120-1-git-send-email-jacopo+renesas@jmondi.org> <20180126135421.GJ17416@w540>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 26 Jan 2018 14:56:17 +0100
Message-ID: <CAMuHMdXOr52+VBD=0_xjtzPWggi2yRR-SQq3zpry=x2pZzwwJA@mail.gmail.com>
Subject: Re: [PATCH v7 00/11] Renesas Capture Engine Unit (CEU) V4L2 driver
To: jacopo mondi <jacopo@jmondi.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Fri, Jan 26, 2018 at 2:54 PM, jacopo mondi <jacopo@jmondi.org> wrote:
> UUUPS
>
> please ignore this submission as it contains patches from a previous
> version (you may have noticed some patches in the series reports
> [xx/09] in the subject).
>
> I will resend.

Good. So there's still time to fix e.g. "RZ/A1-H" to "RZ/A1H" (same
for M and L).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
