Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:34722 "EHLO
        smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757825AbdLRDVd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Dec 2017 22:21:33 -0500
MIME-Version: 1.0
In-Reply-To: <20171217224547.21481-4-embed3d@gmail.com>
References: <20171217224547.21481-1-embed3d@gmail.com> <20171217224547.21481-4-embed3d@gmail.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Mon, 18 Dec 2017 11:21:04 +0800
Message-ID: <CAGb2v65Dcd=g+_Vv9b7q+eoEBhem7tzkrG8h1AeS7mF9bESNZQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] arm: dts: sun8i: a83t: Add the ir pin for the A83T
To: Philipp Rossak <embed3d@gmail.com>
Cc: mchehab@kernel.org, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Russell King <linux@armlinux.org.uk>, sean@mess.org,
        Philipp Zabel <p.zabel@pengutronix.de>, andi.shyti@samsung.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 18, 2017 at 6:45 AM, Philipp Rossak <embed3d@gmail.com> wrote:
> The CIR Pin of the A83T is located at PL12.
>
> Signed-off-by: Philipp Rossak <embed3d@gmail.com>
> ---
>  arch/arm/boot/dts/sun8i-a83t.dtsi | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/arch/arm/boot/dts/sun8i-a83t.dtsi b/arch/arm/boot/dts/sun8i-a83t.dtsi
> index a384b766f3dc..954c2393325f 100644
> --- a/arch/arm/boot/dts/sun8i-a83t.dtsi
> +++ b/arch/arm/boot/dts/sun8i-a83t.dtsi
> @@ -521,6 +521,11 @@
>                                 drive-strength = <20>;
>                                 bias-pull-up;
>                         };
> +
> +                       ir_pins_a: ir@0 {

ir_pins: ir-pins

And it really should be cir, to distinguish it from IrDA.

ChenYu

> +                               pins = "PL12";
> +                               function = "s_cir_rx";
> +                       };
>                 };
>
>                 r_rsb: rsb@1f03400 {
> --
> 2.11.0
>
