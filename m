Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33303 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752742AbcKGMuw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2016 07:50:52 -0500
MIME-Version: 1.0
In-Reply-To: <20161102132235.32738-1-niklas.soderlund+renesas@ragnatech.se>
References: <20161102132235.32738-1-niklas.soderlund+renesas@ragnatech.se>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 7 Nov 2016 13:49:55 +0100
Message-ID: <CAMuHMdW6pBQHMnpmnpoJ6rYBXLfEWuXpdaZMJNBUVAyXrz7_Mw@mail.gmail.com>
Subject: Re: [PATCHv3] media: rcar-csi2: add Renesas R-Car MIPI CSI-2 driver
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

Hi Niklas,

On Wed, Nov 2, 2016 at 2:22 PM, Niklas S=C3=B6derlund
<niklas.soderlund+renesas@ragnatech.se> wrote:
> A V4L2 driver for Renesas R-Car MIPI CSI-2 interface. The driver
> supports the rcar-vin driver on R-Car Gen3 SoCs where a separate driver
> is needed to receive CSI-2.
>
> Driver is based on a prototype by Koji Matsuoka in the Renesas BSP.
>
> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>

Looking at the binding doc only...

> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/rcar-csi2.txt
> @@ -0,0 +1,116 @@
> +Renesas R-Car MIPI CSI-2 driver (rcar-csi2)

Bindings are meant to describe hardware, not drivers.

> +-------------------------------------------
> +
> +The rcar-csi2 device provides MIPI CSI-2 capabilities for the Renesas R-=
Car
> +family of devices. It is to be used in conjunction with the rcar-vin dri=
ver

R-Car VIN module?

> +which provides the video input capabilities.

> +
> + - compatible: Must be one or more of the following
> +   - "renesas,r8a7795-csi2" for the R8A7795 device.
> +   - "renesas,r8a7796-csi2" for the R8A7796 device.
> +   - "renesas,rcar-gen3-csi2" for a generic R-Car Gen3 compatible device=
.
> +
> +   When compatible with a generic version nodes must list the
> +   SoC-specific version corresponding to the platform first
> +   followed by the generic version.
> +
> + - reg: the register base and size for the device registers
> + - interrupts: the interrupt for the device
> + - clocks: Reference to the parent clock
> +
> +The device node should contain two 'port' child nodes according to the
> +bindings defined in Documentation/devicetree/bindings/media/
> +video-interfaces.txt. Port 0 should connect the device that is the vidoe

video

> +source for to the CSI-2 . Port 1 should connect the R-Car VIN devices
> +(rcar-vin) devices which can use the CSI-2 device.

Please drop "(rcar-vin)"

> +
> +- Port 0 - Vidoe source

Video

> +       - Reg 0 - sub-node describing the endpoint which are the vidoe so=
urce

is the video?

> +
> +- Port 1 - VIN instacnes
> +       - Reg 0 - sub-node describing the endpoint which are VIN0
> +       - Reg 1 - sub-node describing the endpoint which are VIN1
> +       - Reg 2 - sub-node describing the endpoint which are VIN2
> +       - Reg 3 - sub-node describing the endpoint which are VIN3
> +       - Reg 4 - sub-node describing the endpoint which are VIN4
> +       - Reg 5 - sub-node describing the endpoint which are VIN5
> +       - Reg 6 - sub-node describing the endpoint which are VIN6
> +       - Reg 7 - sub-node describing the endpoint which are VIN7

s/are/in/?

> +
> +Example:
> +
> +/* SoC properties */
> +
> +        csi20: csi2@fea80000 {
> +                compatible =3D "renesas,r8a7795-csi2";
> +                reg =3D <0 0xfea80000 0 0x10000>;
> +                interrupts =3D <0 184 IRQ_TYPE_LEVEL_HIGH>;
> +                clocks =3D <&cpg CPG_MOD 714>;
> +                power-domains =3D <&cpg>;

Please update the power-domains property to match reality.

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
