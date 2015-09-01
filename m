Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:38814 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbbIAH7X (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Sep 2015 03:59:23 -0400
Received: by wiclp12 with SMTP id lp12so21161027wic.1
        for <linux-media@vger.kernel.org>; Tue, 01 Sep 2015 00:59:22 -0700 (PDT)
Date: Tue, 1 Sep 2015 08:59:19 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	valentinrothberg@gmail.com, hugues.fruchet@st.com
Subject: Re: [PATCH v3 2/6] ARM: DT: STi: STiH407: Add c8sectpfe LinuxDVB DT
 node.
Message-ID: <20150901075919.GL4796@x1>
References: <1440784362-31217-1-git-send-email-peter.griffin@linaro.org>
 <1440784362-31217-3-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1440784362-31217-3-git-send-email-peter.griffin@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 28 Aug 2015, Peter Griffin wrote:

> This patch adds in the required DT node for the c8sectpfe
> Linux DVB demux driver which allows the tsin channels
> to be used on an upstream kernel.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  arch/arm/boot/dts/stihxxx-b2120.dtsi | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/arch/arm/boot/dts/stihxxx-b2120.dtsi b/arch/arm/boot/dts/stihxxx-b2120.dtsi
> index 62994ae..f9fca10 100644
> --- a/arch/arm/boot/dts/stihxxx-b2120.dtsi
> +++ b/arch/arm/boot/dts/stihxxx-b2120.dtsi
> @@ -6,6 +6,9 @@
>   * it under the terms of the GNU General Public License version 2 as
>   * published by the Free Software Foundation.
>   */
> +
> +#include <dt-bindings/clock/stih407-clks.h>
> +#include <dt-bindings/media/c8sectpfe.h>
>  / {
>  	soc {
>  		sbc_serial0: serial@9530000 {
> @@ -85,5 +88,37 @@
>  			status = "okay";
>  		};
>  
> +		demux@08a20000 {
> +			compatible	= "st,stih407-c8sectpfe";
> +			status		= "okay";
> +			reg		= <0x08a20000 0x10000>,
> +					  <0x08a00000 0x4000>;
> +			reg-names	= "c8sectpfe", "c8sectpfe-ram";
> +			interrupts	= <GIC_SPI 34 IRQ_TYPE_NONE>,
> +					  <GIC_SPI 35 IRQ_TYPE_NONE>;
> +			interrupt-names	= "c8sectpfe-error-irq",
> +					  "c8sectpfe-idle-irq";
> +			pinctrl-0	= <&pinctrl_tsin0_serial>;
> +			pinctrl-1	= <&pinctrl_tsin0_parallel>;
> +			pinctrl-2	= <&pinctrl_tsin3_serial>;
> +			pinctrl-3	= <&pinctrl_tsin4_serial_alt3>;
> +			pinctrl-4	= <&pinctrl_tsin5_serial_alt1>;
> +			pinctrl-names	= "tsin0-serial",
> +					  "tsin0-parallel",
> +					  "tsin3-serial",
> +					  "tsin4-serial",
> +					  "tsin5-serial";
> +			clocks		= <&clk_s_c0_flexgen CLK_PROC_STFE>;
> +			clock-names	= "c8sectpfe";
> +
> +			/* tsin0 is TSA on NIMA */
> +			tsin0: port@0 {
> +				tsin-num	= <0>;
> +				serial-not-parallel;
> +				i2c-bus		= <&ssc2>;
> +				rst-gpio	= <&pio15 4 GPIO_ACTIVE_HIGH>;
> +				dvb-card	= <STV0367_TDA18212_NIMA_1>;
> +			};
> +		};
>  	};
>  };

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
