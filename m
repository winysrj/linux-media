Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38865 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933256AbeGJOra (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 10:47:30 -0400
MIME-Version: 1.0
In-Reply-To: <20180710080114.31469-6-paul.kocialkowski@bootlin.com>
References: <20180710080114.31469-1-paul.kocialkowski@bootlin.com> <20180710080114.31469-6-paul.kocialkowski@bootlin.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Tue, 10 Jul 2018 22:47:07 +0800
Message-ID: <CAGb2v64Na1Mq0=-z5Haq=sgggRPHNHVZ-6fFczxb3EESAzZ=XA@mail.gmail.com>
Subject: Re: [PATCH v5 05/22] dt-bindings: sram: sunxi: Populate valid
 sections compatibles
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

On Tue, Jul 10, 2018 at 4:00 PM, Paul Kocialkowski
<paul.kocialkowski@bootlin.com> wrote:
> This adds a list of valid SRAM sections compatibles for the A13, A20,
> A23 and H3 platforms. Per-platform compatibles are introduced for the
> SRAM sections of these platforms, with the A10 compatibles also listed
> as valid when applicable.
>
> In particular, compatibles for the C1 SRAM section are introduced.

You should probably mention that this is not an exhaustive list. In
particular, the C2 and C3 (sun5i) mappings are still missing.

>
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> ---
>  .../devicetree/bindings/sram/sunxi-sram.txt   | 25 +++++++++++++++++++
>  1 file changed, 25 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/sram/sunxi-sram.txt b/Documentation/devicetree/bindings/sram/sunxi-sram.txt
> index 156a02ab6b54..07c53c5214a0 100644
> --- a/Documentation/devicetree/bindings/sram/sunxi-sram.txt
> +++ b/Documentation/devicetree/bindings/sram/sunxi-sram.txt
> @@ -32,8 +32,33 @@ once again the representation described in the mmio-sram binding.
>
>  The valid sections compatible for A10 are:
>      - allwinner,sun4i-a10-sram-a3-a4
> +    - allwinner,sun4i-a10-sram-c1
>      - allwinner,sun4i-a10-sram-d
>
> +The valid sections compatible for A13 are:
> +    - allwinner,sun5i-a13-sram-a3-a4
> +    - allwinner,sun4i-a10-sram-a3-a4
> +    - allwinner,sun5i-a13-sram-c1
> +    - allwinner,sun4i-a10-sram-c1
> +    - allwinner,sun5i-a13-sram-d
> +    - allwinner,sun4i-a10-sram-d
> +
> +The valid sections compatible for A20 are:
> +    - allwinner,sun7i-a20-sram-a3-a4
> +    - allwinner,sun4i-a10-sram-a3-a4
> +    - allwinner,sun7i-a20-sram-c1
> +    - allwinner,sun4i-a10-sram-c1
> +    - allwinner,sun7i-a20-sram-d
> +    - allwinner,sun4i-a10-sram-d
> +
> +The valid sections compatible for A23/A33 are:
> +    - allwinner,sun8i-a23-sram-c1
> +    - allwinner,sun4i-a10-sram-c1
> +
> +The valid sections compatible for H3 are:
> +    - allwinner,sun8i-h3-sram-c1
> +    - allwinner,sun4i-a10-sram-c1

I'm not quite sure why we want to list these... I think it makes more sense
to just have the SoC specific compatible. They are tied to the controls
after all. Maybe Rob has a different opinion?

ChenYu

> +
>  The valid sections compatible for A64 are:
>      - allwinner,sun50i-a64-sram-c
>
> --
> 2.17.1
>
