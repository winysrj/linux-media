Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:33276 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750777AbdBAShZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Feb 2017 13:37:25 -0500
Received: by mail-wm0-f51.google.com with SMTP id t18so31490284wmt.0
        for <linux-media@vger.kernel.org>; Wed, 01 Feb 2017 10:37:24 -0800 (PST)
Date: Wed, 1 Feb 2017 18:37:16 +0000
From: Peter Griffin <peter.griffin@linaro.org>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        kernel@stlinux.com,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [STLinux Kernel] [PATCH v6 02/10] ARM: dts: STiH410: add DELTA
 dt node
Message-ID: <20170201183716.GJ31988@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1485965011-17388-1-git-send-email-hugues.fruchet@st.com>
 <1485965011-17388-3-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1485965011-17388-3-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 01 Feb 2017, Hugues Fruchet wrote:

> This patch adds DT node for STMicroelectronics
> DELTA V4L2 video decoder
> 
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>  arch/arm/boot/dts/stih410.dtsi | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/stih410.dtsi b/arch/arm/boot/dts/stih410.dtsi
> index 281a124..42e070c 100644
> --- a/arch/arm/boot/dts/stih410.dtsi
> +++ b/arch/arm/boot/dts/stih410.dtsi
> @@ -259,5 +259,15 @@
>  			clocks = <&clk_sysin>;
>  			interrupts = <GIC_SPI 205 IRQ_TYPE_EDGE_RISING>;
>  		};
> +		delta0 {
> +			compatible = "st,st-delta";
> +			clock-names = "delta",
> +				      "delta-st231",
> +				      "delta-flash-promip";
> +			clocks = <&clk_s_c0_flexgen CLK_VID_DMU>,
> +				 <&clk_s_c0_flexgen CLK_ST231_DMU>,
> +				 <&clk_s_c0_flexgen CLK_FLASH_PROMIP>;
> +		};
> +

I think this node should be in stih407-family.dtsi file?

regards,

Peter.
