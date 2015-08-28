Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33908 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbbH1G5o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2015 02:57:44 -0400
Received: by wibcx1 with SMTP id cx1so3812542wib.1
        for <linux-media@vger.kernel.org>; Thu, 27 Aug 2015 23:57:43 -0700 (PDT)
Date: Fri, 28 Aug 2015 07:57:40 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	maxime.coquelin@st.com, srinivas.kandagatla@gmail.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 4/5] [media] c8sectpfe: Update binding to reset-gpios
Message-ID: <20150828065740.GD4796@x1>
References: <1440678575-21646-1-git-send-email-peter.griffin@linaro.org>
 <1440678575-21646-5-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1440678575-21646-5-git-send-email-peter.griffin@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 27 Aug 2015, Peter Griffin wrote:

> gpio.txt documents that GPIO properties should be named
> "[<name>-]gpios", with <name> being the purpose of this
> GPIO for the device.
> 
> This change has been done as one atomic commit.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt | 6 +++---
>  arch/arm/boot/dts/stihxxx-b2120.dtsi                          | 4 ++--
>  drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c         | 2 +-
>  3 files changed, 6 insertions(+), 6 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt b/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
> index d4def76..e70d840 100644
> --- a/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
> +++ b/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
> @@ -35,7 +35,7 @@ Required properties (tsin (child) node):
>  
>  - tsin-num	: tsin id of the InputBlock (must be between 0 to 6)
>  - i2c-bus	: phandle to the I2C bus DT node which the demodulators & tuners on this tsin channel are connected.
> -- rst-gpio	: reset gpio for this tsin channel.
> +- reset-gpios	: reset gpio for this tsin channel.
>  
>  Optional properties (tsin (child) node):
>  
> @@ -75,7 +75,7 @@ Example:
>  			tsin-num		= <0>;
>  			serial-not-parallel;
>  			i2c-bus			= <&ssc2>;
> -			rst-gpio		= <&pio15 4 0>;
> +			reset-gpios		= <&pio15 4 GPIO_ACTIVE_HIGH>;
>  			dvb-card		= <STV0367_TDA18212_NIMA_1>;
>  		};
>  
> @@ -83,7 +83,7 @@ Example:
>  			tsin-num		= <3>;
>  			serial-not-parallel;
>  			i2c-bus			= <&ssc3>;
> -			rst-gpio		= <&pio15 7 0>;
> +			reset-gpios		= <&pio15 7 GPIO_ACTIVE_HIGH>;
>  			dvb-card		= <STV0367_TDA18212_NIMB_1>;
>  		};
>  	};
> diff --git a/arch/arm/boot/dts/stihxxx-b2120.dtsi b/arch/arm/boot/dts/stihxxx-b2120.dtsi
> index c014173..f932bfd 100644
> --- a/arch/arm/boot/dts/stihxxx-b2120.dtsi
> +++ b/arch/arm/boot/dts/stihxxx-b2120.dtsi
> @@ -6,8 +6,8 @@
>   * it under the terms of the GNU General Public License version 2 as
>   * published by the Free Software Foundation.
>   */
> -
>  #include <dt-bindings/clock/stih407-clks.h>
> +#include <dt-bindings/gpio/gpio.h>
>  #include <dt-bindings/media/c8sectpfe.h>
>  / {
>  	soc {
> @@ -115,7 +115,7 @@
>  				tsin-num	= <0>;
>  				serial-not-parallel;
>  				i2c-bus		= <&ssc2>;
> -				rst-gpio	= <&pio15 4 0>;
> +				reset-gpios	= <&pio15 4 GPIO_ACTIVE_HIGH>;
>  				dvb-card	= <STV0367_TDA18212_NIMA_1>;
>  			};
>  		};
> diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
> index 3a91093..c691e13 100644
> --- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
> +++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
> @@ -822,7 +822,7 @@ static int c8sectpfe_probe(struct platform_device *pdev)
>  		}
>  		of_node_put(i2c_bus);
>  
> -		tsin->rst_gpio = of_get_named_gpio(child, "rst-gpio", 0);
> +		tsin->rst_gpio = of_get_named_gpio(child, "reset-gpios", 0);
>  
>  		ret = gpio_is_valid(tsin->rst_gpio);
>  		if (!ret) {

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
