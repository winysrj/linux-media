Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:43636 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750756AbdKJIJl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Nov 2017 03:09:41 -0500
MIME-Version: 1.0
In-Reply-To: <20171109234320.13016-2-niklas.soderlund+renesas@ragnatech.se>
References: <20171109234320.13016-1-niklas.soderlund+renesas@ragnatech.se> <20171109234320.13016-2-niklas.soderlund+renesas@ragnatech.se>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 10 Nov 2017 09:09:39 +0100
Message-ID: <CAMuHMdWDfxFQO8bwxHim=BXHtC37cWFgU-keDDNiLDtEhh7=Dw@mail.gmail.com>
Subject: Re: [PATCH v9 1/2] media: rcar-csi2: add Renesas R-Car MIPI CSI-2
 receiver documentation
To: =?UTF-8?Q?Niklas_S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Fukawa <tomoharu.fukawa.eb@renesas.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Fri, Nov 10, 2017 at 12:43 AM, Niklas S=C3=B6derlund
<niklas.soderlund+renesas@ragnatech.se> wrote:
> Documentation for Renesas R-Car MIPI CSI-2 receiver. The CSI-2 receivers
> are located between the video sources (CSI-2 transmitters) and the video
> grabbers (VIN) on Gen3 of Renesas R-Car SoC.
>
> Each CSI-2 device is connected to more then one VIN device which
> simultaneously can receive video from the same CSI-2 device. Each VIN
> device can also be connected to more then one CSI-2 device. The routing
> of which link are used are controlled by the VIN devices. There are only
> a few possible routes which are set by hardware limitations, which are
> different for each SoC in the Gen3 family.
>
> To work with the limitations of routing possibilities it is necessary
> for the DT bindings to describe which VIN device is connected to which
> CSI-2 device. This is why port 1 needs to to assign reg numbers for each
> VIN device that be connected to it. To setup and to know which links are
> valid for each SoC is the responsibility of the VIN driver since the
> register to configure it belongs to the VIN hardware.
>
> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>
> ---
>  .../devicetree/bindings/media/rcar-csi2.txt        | 103 +++++++++++++++=
++++++
>  MAINTAINERS                                        |   1 +
>  2 files changed, 104 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/rcar-csi2.txt
>
> diff --git a/Documentation/devicetree/bindings/media/rcar-csi2.txt b/Docu=
mentation/devicetree/bindings/media/rcar-csi2.txt
> new file mode 100644
> index 0000000000000000..39d41d82b71b60eb
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/rcar-csi2.txt

> +Example:
> +
> +       csi20: csi2@fea80000 {
> +               compatible =3D "renesas,r8a7796-csi2", "renesas,rcar-gen3=
-csi2";
> +               reg =3D <0 0xfea80000 0 0x10000>;
> +               interrupts =3D <0 184 IRQ_TYPE_LEVEL_HIGH>;
> +               clocks =3D <&cpg CPG_MOD 714>;
> +               power-domains =3D <&sysc R8A7796_PD_ALWAYS_ON>;

resets?

I know this is just an example, but your prototype patches to add the
csi nodes to r8a7795.dtsi also don't have reset properties.

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
