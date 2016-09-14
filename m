Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37350 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753197AbcINJvH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Sep 2016 05:51:07 -0400
Received: by mail-wm0-f51.google.com with SMTP id c131so19664757wmh.0
        for <linux-media@vger.kernel.org>; Wed, 14 Sep 2016 02:51:06 -0700 (PDT)
Date: Wed, 14 Sep 2016 10:51:02 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: hans.verkuil@cisco.com, linux-media@vger.kernel.org,
        robh@kernel.org, kernel@stlinux.com, arnd@arndb.de
Subject: Re: [STLinux Kernel] [PATCH 3/4] add stih-cec driver into DT
Message-ID: <20160914095102.GA9482@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1473844924-13895-1-git-send-email-benjamin.gaignard@linaro.org>
 <1473844924-13895-4-git-send-email-benjamin.gaignard@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1473844924-13895-4-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Benjamin,

On Wed, 14 Sep 2016, Benjamin Gaignard wrote:

> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
> ---
>  arch/arm/boot/dts/stih410.dtsi | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/stih410.dtsi b/arch/arm/boot/dts/stih410.dtsi
> index 18ed1ad..440c4bd 100644
> --- a/arch/arm/boot/dts/stih410.dtsi
> +++ b/arch/arm/boot/dts/stih410.dtsi
> @@ -227,5 +227,17 @@
>  			clock-names = "bdisp";
>  			clocks = <&clk_s_c0_flexgen CLK_IC_BDISP_0>;
>  		};
> +
> +		sti-cec@094a087c {
> +			compatible = "st,stih-cec";
> +			reg = <0x94a087c 0x64>;
> +			clocks = <&clk_sysin>;
> +			clock-names = "cec-clk";
> +			interrupts = <GIC_SPI 140 IRQ_TYPE_NONE>;
> +			interrupt-names = "cec-irq";
> +			pinctrl-names = "default";
> +			pinctrl-0 = <&pinctrl_cec0_default>;
> +			resets = <&softreset STIH407_LPM_SOFTRESET>;
> +		};

I think this should be put in stih407-family.dtsi.

regards,

Peter.
