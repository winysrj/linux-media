Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:35868 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751701AbcKONFf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 08:05:35 -0500
MIME-Version: 1.0
In-Reply-To: <20161112122911.19079-1-niklas.soderlund+renesas@ragnatech.se>
References: <20161112122911.19079-1-niklas.soderlund+renesas@ragnatech.se>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 15 Nov 2016 14:05:33 +0100
Message-ID: <CAMuHMdWTzdV_-FLo3=pb+bkKPVu-di8XfkLsMbbCRkunYjBZrA@mail.gmail.com>
Subject: Re: [PATCHv4] media: rcar-csi2: add Renesas R-Car MIPI CSI-2 driver
To: =?UTF-8?Q?Niklas_S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Fukawa <tomoharu.fukawa.eb@renesas.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 12, 2016 at 1:29 PM, Niklas S=C3=B6derlund
<niklas.soderlund+renesas@ragnatech.se> wrote:
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/rcar-csi2.txt

> +The device node should contain two 'port' child nodes according to the
> +bindings defined in Documentation/devicetree/bindings/media/
> +video-interfaces.txt. Port 0 should connect the node that is the video
> +source for to the CSI-2. Port 1 should connect all the R-Car VIN

Trailing space at the end of previous line.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
