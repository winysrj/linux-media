Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:59573 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbaLAOyT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 09:54:19 -0500
Message-ID: <547C8113.3050100@mentor.com>
Date: Mon, 1 Dec 2014 16:54:11 +0200
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
	Shawn Guo <shawn.guo@linaro.org>
CC: Wolfram Sang <wsa@the-dreams.de>, <devicetree@vger.kernel.org>,
	<linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH 1/3] staging: imx-drm: document internal HDMI I2C master
 controller DT binding
References: <1416073759-19939-1-git-send-email-vladimir_zapolskiy@mentor.com> <1416073759-19939-2-git-send-email-vladimir_zapolskiy@mentor.com>
In-Reply-To: <1416073759-19939-2-git-send-email-vladimir_zapolskiy@mentor.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp and Shawn,

On 15.11.2014 19:49, Vladimir Zapolskiy wrote:
> Provide information about how to bind internal iMX6Q/DL HDMI DDC I2C
> master controller. The property is set as optional one, because iMX6
> HDMI DDC bus may be represented by one of general purpose I2C busses
> found on SoC.
> 
> Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
> Cc: Wolfram Sang <wsa@the-dreams.de>
> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: devicetree@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-i2c@vger.kernel.org
> ---
>  Documentation/devicetree/bindings/staging/imx-drm/hdmi.txt |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/staging/imx-drm/hdmi.txt b/Documentation/devicetree/bindings/staging/imx-drm/hdmi.txt
> index 1b756cf..43c8924 100644
> --- a/Documentation/devicetree/bindings/staging/imx-drm/hdmi.txt
> +++ b/Documentation/devicetree/bindings/staging/imx-drm/hdmi.txt
> @@ -10,6 +10,8 @@ Required properties:
>   - #address-cells : should be <1>
>   - #size-cells : should be <0>
>   - compatible : should be "fsl,imx6q-hdmi" or "fsl,imx6dl-hdmi".
> +   If internal HDMI DDC I2C master controller is supposed to be used,
> +   then "simple-bus" should be added to compatible value.
>   - gpr : should be <&gpr>.
>     The phandle points to the iomuxc-gpr region containing the HDMI
>     multiplexer control register.
> @@ -22,6 +24,7 @@ Required properties:
>  
>  Optional properties:
>   - ddc-i2c-bus: phandle of an I2C controller used for DDC EDID probing
> + - ddc: internal HDMI DDC I2C master controller
>  
>  example:
>  
> @@ -32,7 +35,7 @@ example:
>          hdmi: hdmi@0120000 {
>                  #address-cells = <1>;
>                  #size-cells = <0>;
> -                compatible = "fsl,imx6q-hdmi";
> +                compatible = "fsl,imx6q-hdmi", "simple-bus";
>                  reg = <0x00120000 0x9000>;
>                  interrupts = <0 115 0x04>;
>                  gpr = <&gpr>;
> @@ -40,6 +43,11 @@ example:
>                  clock-names = "iahb", "isfr";
>                  ddc-i2c-bus = <&i2c2>;
>  
> +                hdmi_ddc: ddc {
> +                        compatible = "fsl,imx6q-hdmi-ddc";
> +                        status = "disabled";
> +                };
> +
>                  port@0 {
>                          reg = <0>;
>  
> 

knowing in advance that I2C framework lacks a graceful support of non
fully compliant I2C devices, do you have any objections to the proposed
iMX HDMI DTS change?

--
With best wishes,
Vladimir
