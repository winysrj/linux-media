Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33505 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763320AbdEWAOu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 May 2017 20:14:50 -0400
Date: Mon, 22 May 2017 19:14:48 -0500
From: Rob Herring <robh@kernel.org>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: yannick.fertre@st.com, alexandre.torgue@st.com, hverkuil@xs4all.nl,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        hans.verkuil@cisco.com
Subject: Re: [PATCH v2 1/2] binding for stm32 cec driver
Message-ID: <20170523001448.iryswhvw2irtdyuz@rob-hp-laptop>
References: <1494939383-18937-1-git-send-email-benjamin.gaignard@linaro.org>
 <1494939383-18937-2-git-send-email-benjamin.gaignard@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1494939383-18937-2-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 16, 2017 at 02:56:22PM +0200, Benjamin Gaignard wrote:

Commit message?

Preferred subject prefix is "dt-bindings: media: ..."

> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
> ---
>  .../devicetree/bindings/media/st,stm32-cec.txt        | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/st,stm32-cec.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/st,stm32-cec.txt b/Documentation/devicetree/bindings/media/st,stm32-cec.txt
> new file mode 100644
> index 0000000..6be2381
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/st,stm32-cec.txt
> @@ -0,0 +1,19 @@
> +STMicroelectronics STM32 CEC driver
> +
> +Required properties:
> + - compatible : value should be "st,stm32-cec"

All stm32 chips have same CEC block?

> + - reg : Physical base address of the IP registers and length of memory
> +	 mapped region.
> + - clocks : from common clock binding: handle to CEC clocks
> + - clock-names : from common clock binding: must be "cec" and "hdmi-cec".
> + - interrupts : CEC interrupt number to the CPU.
> +
> +Example for stm32f746:
> +
> +cec: cec@40006c00 {
> +	compatible = "st,stm32-cec";
> +	reg = <0x40006C00 0x400>;
> +	interrupts = <94>;
> +	clocks = <&rcc 0 STM32F7_APB1_CLOCK(CEC)>, <&rcc 1 CLK_HDMI_CEC>;
> +	clock-names = "cec", "hdmi-cec";
> +};
> -- 
> 1.9.1
> 
