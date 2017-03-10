Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f180.google.com ([74.125.82.180]:32824 "EHLO
        mail-ot0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933742AbdCJS7O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 13:59:14 -0500
Received: by mail-ot0-f180.google.com with SMTP id 19so82605085oti.0
        for <linux-media@vger.kernel.org>; Fri, 10 Mar 2017 10:59:13 -0800 (PST)
Subject: Re: [PATCH v5 07/39] ARM: dts: imx6qdl-sabrelite: remove erratum
 ERR006687 workaround
To: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <1489121599-23206-8-git-send-email-steve_longerbeam@mentor.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Troy Kisky <troy.kisky@boundarydevices.com>
Message-ID: <9f5d0ac4-0602-c729-5c00-1d9ef49247c1@boundarydevices.com>
Date: Fri, 10 Mar 2017 10:59:11 -0800
MIME-Version: 1.0
In-Reply-To: <1489121599-23206-8-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3/9/2017 8:52 PM, Steve Longerbeam wrote:
> There is a pin conflict with GPIO_6. This pin functions as a power
> input pin to the OV5642 camera sensor, but ENET uses it as the h/w
> workaround for erratum ERR006687, to wake-up the ARM cores on normal
> RX and TX packet done events. So we need to remove the h/w workaround
> to support the OV5642. The result is that the CPUidle driver will no
> longer allow entering the deep idle states on the sabrelite.
> 
> This is a partial revert of
> 
> commit 6261c4c8f13e ("ARM: dts: imx6qdl-sabrelite: use GPIO_6 for FEC
> 			interrupt.")
> commit a28eeb43ee57 ("ARM: dts: imx6: tag boards that have the HW workaround
> 			for ERR006687")
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  arch/arm/boot/dts/imx6qdl-sabrelite.dtsi | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi b/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
> index 8413179..89dce27 100644
> --- a/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
> @@ -270,9 +270,6 @@
>  	txd1-skew-ps = <0>;
>  	txd2-skew-ps = <0>;
>  	txd3-skew-ps = <0>;

How about

+#if !IS_ENABLED(CONFIG_VIDEO_OV5642)

> -	interrupts-extended = <&gpio1 6 IRQ_TYPE_LEVEL_HIGH>,
> -			      <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
> -	fsl,err006687-workaround-present;

+#endif

Is that allowed ?


>  	status = "okay";
>  };
>  
> @@ -373,7 +370,6 @@
>  				MX6QDL_PAD_RGMII_RX_CTL__RGMII_RX_CTL	0x1b030
>  				/* Phy reset */
>  				MX6QDL_PAD_EIM_D23__GPIO3_IO23		0x000b0
> -				MX6QDL_PAD_GPIO_6__ENET_IRQ		0x000b1
>  			>;
>  		};
>  
> 
