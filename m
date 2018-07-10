Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43969 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933406AbeGJPCO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 11:02:14 -0400
MIME-Version: 1.0
In-Reply-To: <20180710080114.31469-10-paul.kocialkowski@bootlin.com>
References: <20180710080114.31469-1-paul.kocialkowski@bootlin.com> <20180710080114.31469-10-paul.kocialkowski@bootlin.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Tue, 10 Jul 2018 22:53:44 +0800
Message-ID: <CAGb2v64HbpvJhy5KQOepc61nU7NECaWMPvhZ16dk5hJXiPBHxA@mail.gmail.com>
Subject: Re: [linux-sunxi] [PATCH v5 09/22] ARM: dts: sun5i: Use
 most-qualified system control compatibles
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Marco Franchi <marco.franchi@nxp.com>,
        Icenowy Zheng <icenowy@aosc.io>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Tom Saeger <tom.saeger@oracle.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Benoit Parrot <bparrot@ti.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Pawel Osciak <posciak@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 10, 2018 at 4:01 PM, Paul Kocialkowski
<paul.kocialkowski@bootlin.com> wrote:
> This switches the sun5i dtsi to use the most qualified compatibles for
> the system-control block (previously named SRAM controller) as well as
> the SRAM blocks. The sun4i-a10 compatibles are kept since these hardware
> blocks are backward-compatible.

Not quite sure why they are backward-compatible. The A13 has less SRAM
mapping controls than the A10.

ChenYu

> The phandle for system control is also updated to reflect the fact that
> the controller described is really about system control rather than SRAM
> control.
>
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> ---
>  arch/arm/boot/dts/sun5i.dtsi | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/boot/dts/sun5i.dtsi b/arch/arm/boot/dts/sun5i.dtsi
> index 07f2248ed5f8..68711954c293 100644
> --- a/arch/arm/boot/dts/sun5i.dtsi
> +++ b/arch/arm/boot/dts/sun5i.dtsi
> @@ -114,8 +114,9 @@
>                 #size-cells = <1>;
>                 ranges;
>
> -               sram-controller@1c00000 {
> -                       compatible = "allwinner,sun4i-a10-sram-controller";
> +               system-control@1c00000 {
> +                       compatible = "allwinner,sun5i-a13-system-control",
> +                                    "allwinner,sun4i-a10-system-control";
>                         reg = <0x01c00000 0x30>;
>                         #address-cells = <1>;
>                         #size-cells = <1>;
> @@ -130,7 +131,8 @@
>                         };
>
>                         emac_sram: sram-section@8000 {
> -                               compatible = "allwinner,sun4i-a10-sram-a3-a4";
> +                               compatible = "allwinner,sun5i-a13-sram-a3-a4",
> +                                            "allwinner,sun4i-a10-sram-a3-a4";
>                                 reg = <0x8000 0x4000>;
>                                 status = "disabled";
>                         };
> @@ -143,7 +145,8 @@
>                                 ranges = <0 0x00010000 0x1000>;
>
>                                 otg_sram: sram-section@0 {
> -                                       compatible = "allwinner,sun4i-a10-sram-d";
> +                                       compatible = "allwinner,sun5i-a13-sram-d",
> +                                                    "allwinner,sun4i-a10-sram-d";
>                                         reg = <0x0000 0x1000>;
>                                         status = "disabled";
>                                 };
> --
> 2.17.1
>
> --
> You received this message because you are subscribed to the Google Groups "linux-sunxi" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to linux-sunxi+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/d/optout.
