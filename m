Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37227 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754260AbeGJOxC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 10:53:02 -0400
MIME-Version: 1.0
In-Reply-To: <20180710080114.31469-9-paul.kocialkowski@bootlin.com>
References: <20180710080114.31469-1-paul.kocialkowski@bootlin.com> <20180710080114.31469-9-paul.kocialkowski@bootlin.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Tue, 10 Jul 2018 22:52:39 +0800
Message-ID: <CAGb2v65JP8fBvD6Sbexjg2cv5AXVufWxjMVuOPa7J1A9qQjZ2g@mail.gmail.com>
Subject: Re: [PATCH v5 08/22] ARM: dts: sun4i-a10: Use system-control compatible
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

Subject prefix should be "ARM: dts: sun4i:"

We don't need the "a10" part since the A10 owns into this category
all by itself.

Also, it doesn't say what the system control compatible is for.
"Switch to new system control compatible string" would be slightly
better.

> This switches the sun4i-a10 dtsi to use the new compatible for the
> system-control block (previously named SRAM controller) instead of
> the deprecated one.
>
> The phandle is also updated to reflect the fact that the controller

The label actually.

ChenYu

> described is really about system control rather than SRAM control.
>
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> ---
>  arch/arm/boot/dts/sun4i-a10.dtsi | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
> index 3a1c6b45c9a1..82f81f06f201 100644
> --- a/arch/arm/boot/dts/sun4i-a10.dtsi
> +++ b/arch/arm/boot/dts/sun4i-a10.dtsi
> @@ -190,8 +190,8 @@
>                 #size-cells = <1>;
>                 ranges;
>
> -               sram-controller@1c00000 {
> -                       compatible = "allwinner,sun4i-a10-sram-controller";
> +               system-control@1c00000 {
> +                       compatible = "allwinner,sun4i-a10-system-control";
>                         reg = <0x01c00000 0x30>;
>                         #address-cells = <1>;
>                         #size-cells = <1>;
> --
> 2.17.1
>
