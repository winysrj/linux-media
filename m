Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44975 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727870AbeI1U4Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Sep 2018 16:56:25 -0400
Received: by mail-wr1-f68.google.com with SMTP id v16-v6so6613439wro.11
        for <linux-media@vger.kernel.org>; Fri, 28 Sep 2018 07:32:21 -0700 (PDT)
MIME-Version: 1.0
References: <20180928142816.4311-1-mjourdan@baylibre.com> <20180928142816.4311-2-mjourdan@baylibre.com>
In-Reply-To: <20180928142816.4311-2-mjourdan@baylibre.com>
From: Maxime Jourdan <mjourdan@baylibre.com>
Date: Fri, 28 Sep 2018 16:32:09 +0200
Message-ID: <CAMO6naws6gRXogL8MyGdz8rBivg7ZxLG1ZoPy0zff=rnHfKPQQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] dt-bindings: media: add Amlogic Video Decoder Bindings
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Rob Herring <robh+dt@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Errata: I forgot the following tag:

Reviewed-by: Rob Herring <robh@kernel.org>

(The patch is unchanged from v2)
Le ven. 28 sept. 2018 =C3=A0 16:29, Maxime Jourdan <mjourdan@baylibre.com> =
a =C3=A9crit :
>
> Add documentation for the meson vdec dts node.
>
> Signed-off-by: Maxime Jourdan <mjourdan@baylibre.com>
> ---
>  .../bindings/media/amlogic,vdec.txt           | 71 +++++++++++++++++++
>  1 file changed, 71 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/amlogic,vdec.=
txt
>
> diff --git a/Documentation/devicetree/bindings/media/amlogic,vdec.txt b/D=
ocumentation/devicetree/bindings/media/amlogic,vdec.txt
> new file mode 100644
> index 000000000000..aabdd01bcf32
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/amlogic,vdec.txt
> @@ -0,0 +1,71 @@
> +Amlogic Video Decoder
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The video decoding IP lies within the DOS memory region,
> +except for the hardware bitstream parser that makes use of an undocument=
ed
> +region.
> +
> +It makes use of the following blocks:
> +
> +- ESPARSER is a bitstream parser that outputs to a VIFIFO. Further VDEC =
blocks
> +then feed from this VIFIFO.
> +- VDEC_1 can decode MPEG-1, MPEG-2, MPEG-4 part 2, MJPEG, H.263, H.264, =
VC-1.
> +- VDEC_HEVC can decode HEVC and VP9.
> +
> +Both VDEC_1 and VDEC_HEVC share the "vdec" IRQ and as such cannot run
> +concurrently.
> +
> +Device Tree Bindings:
> +---------------------
> +
> +VDEC: Video Decoder
> +--------------------------
> +
> +Required properties:
> +- compatible: value should be different for each SoC family as :
> +       - GXBB (S905) : "amlogic,gxbb-vdec"
> +       - GXL (S905X, S905D) : "amlogic,gxl-vdec"
> +       - GXM (S912) : "amlogic,gxm-vdec"
> +- reg: base address and size of he following memory-mapped regions :
> +       - dos
> +       - esparser
> +- reg-names: should contain the names of the previous memory regions
> +- interrupts: should contain the following IRQs:
> +       - vdec
> +       - esparser
> +- interrupt-names: should contain the names of the previous interrupts
> +- amlogic,ao-sysctrl: should point to the AOBUS sysctrl node
> +- amlogic,canvas: should point to a canvas provider node
> +- clocks: should contain the following clocks :
> +       - dos_parser
> +       - dos
> +       - vdec_1
> +       - vdec_hevc
> +- clock-names: should contain the names of the previous clocks
> +- resets: should contain the parser reset
> +- reset-names: should be "esparser"
> +
> +Example:
> +
> +vdec: video-decoder@c8820000 {
> +       compatible =3D "amlogic,gxbb-vdec";
> +       reg =3D <0x0 0xc8820000 0x0 0x10000>,
> +             <0x0 0xc110a580 0x0 0xe4>;
> +       reg-names =3D "dos", "esparser";
> +
> +       interrupts =3D <GIC_SPI 44 IRQ_TYPE_EDGE_RISING>,
> +                    <GIC_SPI 32 IRQ_TYPE_EDGE_RISING>;
> +       interrupt-names =3D "vdec", "esparser";
> +
> +       amlogic,ao-sysctrl =3D <&sysctrl_AO>;
> +       amlogic,canvas =3D <&canvas>;
> +
> +       clocks =3D <&clkc CLKID_DOS_PARSER>,
> +                <&clkc CLKID_DOS>,
> +                <&clkc CLKID_VDEC_1>,
> +                <&clkc CLKID_VDEC_HEVC>;
> +       clock-names =3D "dos_parser", "dos", "vdec_1", "vdec_hevc";
> +
> +       resets =3D <&reset RESET_PARSER>;
> +       reset-names =3D "esparser";
> +};
> --
> 2.19.0
>
