Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:34072 "EHLO
	mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbbHaPZn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 11:25:43 -0400
MIME-Version: 1.0
In-Reply-To: <1440784362-31217-5-git-send-email-peter.griffin@linaro.org>
References: <1440784362-31217-1-git-send-email-peter.griffin@linaro.org> <1440784362-31217-5-git-send-email-peter.griffin@linaro.org>
From: Rob Herring <robherring2@gmail.com>
Date: Mon, 31 Aug 2015 10:25:22 -0500
Message-ID: <CAL_JsqLYes5L2Bg0R45ui24yYWgHzFSLgBPajieSLgLz09=1aw@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] [media] c8sectpfe: Update binding to reset-gpios
To: Peter Griffin <peter.griffin@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
	Maxime Coquelin <maxime.coquelin@st.com>,
	Patrice Chotard <patrice.chotard@st.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	hugues.fruchet@st.com,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Lee Jones <lee.jones@linaro.org>, valentinrothberg@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 28, 2015 at 12:52 PM, Peter Griffin
<peter.griffin@linaro.org> wrote:
> gpio.txt documents that GPIO properties should be named
> "[<name>-]gpios", with <name> being the purpose of this
> GPIO for the device.
>
> This change has been done as one atomic commit.

dtb and kernel updates are not necessarily atomic, so you are breaking
compatibility with older dtbs. You should certainly highlight that in
the commit message. I only point this out. I'll leave it to platform
maintainers whether or not this breakage is acceptable.

Rob

>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> ---
>  Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt | 6 +++---
>  arch/arm/boot/dts/stihxxx-b2120.dtsi                          | 4 ++--
>  drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c         | 2 +-
>  3 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt b/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
> index d4def76..e70d840 100644
> --- a/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
> +++ b/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
> @@ -35,7 +35,7 @@ Required properties (tsin (child) node):
>
>  - tsin-num     : tsin id of the InputBlock (must be between 0 to 6)
>  - i2c-bus      : phandle to the I2C bus DT node which the demodulators & tuners on this tsin channel are connected.
> -- rst-gpio     : reset gpio for this tsin channel.
> +- reset-gpios  : reset gpio for this tsin channel.
>
>  Optional properties (tsin (child) node):
>
> @@ -75,7 +75,7 @@ Example:
>                         tsin-num                = <0>;
>                         serial-not-parallel;
>                         i2c-bus                 = <&ssc2>;
> -                       rst-gpio                = <&pio15 4 0>;
> +                       reset-gpios             = <&pio15 4 GPIO_ACTIVE_HIGH>;
>                         dvb-card                = <STV0367_TDA18212_NIMA_1>;
>                 };
>
> @@ -83,7 +83,7 @@ Example:
>                         tsin-num                = <3>;
>                         serial-not-parallel;
>                         i2c-bus                 = <&ssc3>;
> -                       rst-gpio                = <&pio15 7 0>;
> +                       reset-gpios             = <&pio15 7 GPIO_ACTIVE_HIGH>;
>                         dvb-card                = <STV0367_TDA18212_NIMB_1>;
>                 };
>         };
> diff --git a/arch/arm/boot/dts/stihxxx-b2120.dtsi b/arch/arm/boot/dts/stihxxx-b2120.dtsi
> index f9fca10..0b7592e 100644
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
>         soc {
> @@ -116,7 +116,7 @@
>                                 tsin-num        = <0>;
>                                 serial-not-parallel;
>                                 i2c-bus         = <&ssc2>;
> -                               rst-gpio        = <&pio15 4 GPIO_ACTIVE_HIGH>;
> +                               reset-gpios     = <&pio15 4 GPIO_ACTIVE_HIGH>;
>                                 dvb-card        = <STV0367_TDA18212_NIMA_1>;
>                         };
>                 };
> diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
> index 3a91093..c691e13 100644
> --- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
> +++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
> @@ -822,7 +822,7 @@ static int c8sectpfe_probe(struct platform_device *pdev)
>                 }
>                 of_node_put(i2c_bus);
>
> -               tsin->rst_gpio = of_get_named_gpio(child, "rst-gpio", 0);
> +               tsin->rst_gpio = of_get_named_gpio(child, "reset-gpios", 0);
>
>                 ret = gpio_is_valid(tsin->rst_gpio);
>                 if (!ret) {
> --
> 1.9.1
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
