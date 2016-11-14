Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:32787 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936175AbcKNIaA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 03:30:00 -0500
MIME-Version: 1.0
In-Reply-To: <20161112122911.19079-1-niklas.soderlund+renesas@ragnatech.se>
References: <20161112122911.19079-1-niklas.soderlund+renesas@ragnatech.se>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 14 Nov 2016 09:29:59 +0100
Message-ID: <CAMuHMdWs0DvLLkbg1MrrqK_ho_dQdVwXYsrcO=hgMF761jOePg@mail.gmail.com>
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
> +Example:
> +
> +/* SoC properties */
> +
> +        csi20: csi2@fea80000 {
> +                compatible =3D "renesas,r8a7795-csi2";

7795

> +                reg =3D <0 0xfea80000 0 0x10000>;
> +                interrupts =3D <0 184 IRQ_TYPE_LEVEL_HIGH>;
> +                clocks =3D <&cpg CPG_MOD 714>;
> +                power-domains =3D <&sysc R8A7796_PD_ALWAYS_ON>;

7796

You'd better match the SoC part numbers ;-)

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
