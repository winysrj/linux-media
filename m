Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:34786 "EHLO
        smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757738AbdLRDat (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Dec 2017 22:30:49 -0500
MIME-Version: 1.0
In-Reply-To: <20171217224547.21481-6-embed3d@gmail.com>
References: <20171217224547.21481-1-embed3d@gmail.com> <20171217224547.21481-6-embed3d@gmail.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Mon, 18 Dec 2017 11:30:23 +0800
Message-ID: <CAGb2v67js9XCLUYd+zJBTp-cPG0s3YsWR-=KDfdCR23NkUQheg@mail.gmail.com>
Subject: Re: [PATCH 5/5] arm: dts: sun8i: a83t: bananapi-m3: Enable IR controller
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
> The Bananapi M3 has an onboard IR receiver.
> This enables the onboard IR receiver subnode.
> Other than the other IR receivers this one needs a base clock frequency

Unlike the other...

> of 3000000 Hz (3 MHz), to be able to work.
>
> Signed-off-by: Philipp Rossak <embed3d@gmail.com>
> ---
>  arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts b/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts
> index 6550bf0e594b..2bf25ca64133 100644
> --- a/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts
> +++ b/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts
> @@ -100,6 +100,13 @@
>         status = "okay";
>  };
>
> +&ir {

See my other reply about the name.

Otherwise,

Acked-by: Chen-Yu Tsai <wens@csie.org>

> +       pinctrl-names = "default";
> +       pinctrl-0 = <&ir_pins_a>;
> +       clock-frequency = <3000000>;
> +       status = "okay";
> +};
> +
>  &mdio {
>         rgmii_phy: ethernet-phy@1 {
>                 compatible = "ethernet-phy-ieee802.3-c22";
> --
> 2.11.0
>
