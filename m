Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:38604 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbbH1G5H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2015 02:57:07 -0400
Received: by wibgu7 with SMTP id gu7so98004wib.1
        for <linux-media@vger.kernel.org>; Thu, 27 Aug 2015 23:57:05 -0700 (PDT)
Date: Fri, 28 Aug 2015 07:57:02 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	maxime.coquelin@st.com, srinivas.kandagatla@gmail.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 5/5] [media] c8sectpfe: Update DT binding doc with
 some minor fixes
Message-ID: <20150828065702.GC4796@x1>
References: <1440678575-21646-1-git-send-email-peter.griffin@linaro.org>
 <1440678575-21646-6-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1440678575-21646-6-git-send-email-peter.griffin@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 27 Aug 2015, Peter Griffin wrote:

> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  .../devicetree/bindings/media/stih407-c8sectpfe.txt      | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt b/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
> index e70d840..5d6438c 100644
> --- a/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
> +++ b/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
> @@ -55,21 +55,20 @@ Example:
>  		status = "okay";
>  		reg = <0x08a20000 0x10000>, <0x08a00000 0x4000>;
>  		reg-names = "stfe", "stfe-ram";
> -		interrupts = <0 34 0>, <0 35 0>;
> +		interrupts = <GIC_SPI 34 IRQ_TYPE_NONE>, <GIC_SPI 35 IRQ_TYPE_NONE>;
>  		interrupt-names = "stfe-error-irq", "stfe-idle-irq";
> -
> -		pinctrl-names	= "tsin0-serial", "tsin0-parallel", "tsin3-serial",
> -				"tsin4-serial", "tsin5-serial";
> -
> +		pinctrl-names	= "tsin0-serial",
> +				  "tsin0-parallel",
> +				  "tsin3-serial",
> +				  "tsin4-serial",
> +				  "tsin5-serial";
>  		pinctrl-0	= <&pinctrl_tsin0_serial>;
>  		pinctrl-1	= <&pinctrl_tsin0_parallel>;
>  		pinctrl-2	= <&pinctrl_tsin3_serial>;
>  		pinctrl-3	= <&pinctrl_tsin4_serial_alt3>;
>  		pinctrl-4	= <&pinctrl_tsin5_serial_alt1>;
> -
>  		clocks = <&clk_s_c0_flexgen CLK_PROC_STFE>;
> -		clock-names = "stfe";
> -
> +		clock-names = "c8sectpfe";

Are you sure you even need this property?  I'm thinking that *-names
properties are *usually* only required if there are more than one in a
single property.

>  		/* tsin0 is TSA on NIMA */
>  		tsin0: port@0 {
>  			tsin-num		= <0>;
> @@ -78,7 +77,6 @@ Example:
>  			reset-gpios		= <&pio15 4 GPIO_ACTIVE_HIGH>;
>  			dvb-card		= <STV0367_TDA18212_NIMA_1>;
>  		};
> -

My personal preference is to have a '\n' between nodes.

>  		tsin3: port@3 {
>  			tsin-num		= <3>;
>  			serial-not-parallel;

But these comments are pretty trivial, so agree or not, or fix-up or
not, it's that big of a deal.

Either way,
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
