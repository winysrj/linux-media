Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:34553 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934030AbbFJSMm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 14:12:42 -0400
MIME-Version: 1.0
In-Reply-To: <1433754145-12765-5-git-send-email-j.anaszewski@samsung.com>
References: <1433754145-12765-1-git-send-email-j.anaszewski@samsung.com> <1433754145-12765-5-git-send-email-j.anaszewski@samsung.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Wed, 10 Jun 2015 11:12:20 -0700
Message-ID: <CAK5ve-JjLuYqOP2dzQCV0w-5eV0XnuVkiDOXD58FugXfrNYc0w@mail.gmail.com>
Subject: Re: [PATCH v10 4/8] DT: aat1290: Document handling external strobe sources
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pavel Machek <pavel@ucw.cz>,
	"rpurdie@rpsys.net" <rpurdie@rpsys.net>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 8, 2015 at 2:02 AM, Jacek Anaszewski
<j.anaszewski@samsung.com> wrote:
> This patch adds documentation for a pinctrl-names property.
> The property, when present, is used for switching the source
> of the strobe signal for the device.
>

Merged into my -devel branch and it won't be merged into 4.2.0 merge
window but wait for one more cycle, since now it's quite late in 4.1.0
cycle.

Thanks,
-Bryan

> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: devicetree@vger.kernel.org
> ---
>  .../devicetree/bindings/leds/leds-aat1290.txt      |   36 ++++++++++++++++++--
>  1 file changed, 34 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/leds/leds-aat1290.txt b/Documentation/devicetree/bindings/leds/leds-aat1290.txt
> index ef88b9c..c05ed91 100644
> --- a/Documentation/devicetree/bindings/leds/leds-aat1290.txt
> +++ b/Documentation/devicetree/bindings/leds/leds-aat1290.txt
> @@ -2,7 +2,9 @@
>
>  The device is controlled through two pins: FL_EN and EN_SET. The pins when,
>  asserted high, enable flash strobe and movie mode (max 1/2 of flash current)
> -respectively.
> +respectively. In order to add a capability of selecting the strobe signal source
> +(e.g. CPU or camera sensor) there is an additional switch required, independent
> +of the flash chip. The switch is controlled with pin control.
>
>  Required properties:
>
> @@ -10,6 +12,13 @@ Required properties:
>  - flen-gpios : Must be device tree identifier of the flash device FL_EN pin.
>  - enset-gpios : Must be device tree identifier of the flash device EN_SET pin.
>
> +Optional properties:
> +- pinctrl-names : Must contain entries: "default", "host", "isp". Entries
> +               "default" and "host" must refer to the same pin configuration
> +               node, which sets the host as a strobe signal provider. Entry
> +               "isp" must refer to the pin configuration node, which sets the
> +               ISP as a strobe signal provider.
> +
>  A discrete LED element connected to the device must be represented by a child
>  node - see Documentation/devicetree/bindings/leds/common.txt.
>
> @@ -25,13 +34,22 @@ Required properties of the LED child node:
>  Optional properties of the LED child node:
>  - label : see Documentation/devicetree/bindings/leds/common.txt
>
> -Example (by Ct = 220nF, Rset = 160kohm):
> +Example (by Ct = 220nF, Rset = 160kohm and exynos4412-trats2 board with
> +a switch that allows for routing strobe signal either from the host or from
> +the camera sensor):
> +
> +#include "exynos4412.dtsi"
>
>  aat1290 {
>         compatible = "skyworks,aat1290";
>         flen-gpios = <&gpj1 1 GPIO_ACTIVE_HIGH>;
>         enset-gpios = <&gpj1 2 GPIO_ACTIVE_HIGH>;
>
> +       pinctrl-names = "default", "host", "isp";
> +       pinctrl-0 = <&camera_flash_host>;
> +       pinctrl-1 = <&camera_flash_host>;
> +       pinctrl-2 = <&camera_flash_isp>;
> +
>         camera_flash: flash-led {
>                 label = "aat1290-flash";
>                 led-max-microamp = <520833>;
> @@ -39,3 +57,17 @@ aat1290 {
>                 flash-timeout-us = <1940000>;
>         };
>  };
> +
> +&pinctrl_0 {
> +       camera_flash_host: camera-flash-host {
> +               samsung,pins = "gpj1-0";
> +               samsung,pin-function = <1>;
> +               samsung,pin-val = <0>;
> +       };
> +
> +       camera_flash_isp: camera-flash-isp {
> +               samsung,pins = "gpj1-0";
> +               samsung,pin-function = <1>;
> +               samsung,pin-val = <1>;
> +       };
> +};
> --
> 1.7.9.5
>
