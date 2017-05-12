Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:34577 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756373AbdELG53 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 May 2017 02:57:29 -0400
MIME-Version: 1.0
In-Reply-To: <f6f888b797402e75ad542742ddc63d4829622489.1494523203.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.5d2526b759f71c06d51df279c3d5885aca476fb6.1494523203.git-series.kieran.bingham+renesas@ideasonboard.com>
 <f6f888b797402e75ad542742ddc63d4829622489.1494523203.git-series.kieran.bingham+renesas@ideasonboard.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 12 May 2017 08:57:27 +0200
Message-ID: <CAMuHMdXVGPjgujkSXdVR5YVvZu-Bm+-u6rVNGrbeOZpCHE1cBQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/4] arm64: dts: r8a7796: salvator-x: enable VIN,
 CSI and ADV7482
To: Kieran Bingham <kbingham@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Thu, May 11, 2017 at 7:21 PM, Kieran Bingham <kbingham@kernel.org> wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>
> Provide bindings between the VIN, CSI and the ADV7482 on the r8a7796.
>
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  arch/arm64/boot/dts/renesas/r8a7796-salvator-x.dts | 147 ++++++++++++++-

You have to do this only once, in salvator-x.dtsi ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
