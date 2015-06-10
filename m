Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:36385 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965207AbbFJSSh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 14:18:37 -0400
MIME-Version: 1.0
In-Reply-To: <1433754145-12765-8-git-send-email-j.anaszewski@samsung.com>
References: <1433754145-12765-1-git-send-email-j.anaszewski@samsung.com> <1433754145-12765-8-git-send-email-j.anaszewski@samsung.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Wed, 10 Jun 2015 11:18:16 -0700
Message-ID: <CAK5ve-LZ0G0H2XpepJ1Bje=Sfv4HNHt1PCu2Mn9HnT4bgXZmuw@mail.gmail.com>
Subject: Re: [PATCH v10 7/8] DT: Add documentation for exynos4-is 'flashes' property
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
> This patch adds a description of 'samsung,camera-flashes'
> property to the samsung-fimc.txt.
>

Please go ahead with my Ack
Acked-by: Bryan Wu <cooloney@gmail.com>

Thanks,
-Bryan

> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: devicetree@vger.kernel.org
> ---
>  .../devicetree/bindings/media/samsung-fimc.txt     |   10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
> index 922d6f8..0554cad 100644
> --- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
> +++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
> @@ -40,6 +40,14 @@ should be inactive. For the "active-a" state the camera port A must be activated
>  and the port B deactivated and for the state "active-b" it should be the other
>  way around.
>
> +Optional properties:
> +
> +- samsung,camera-flashes - Array of pairs of phandles to the camera sensor
> +       devices and flash LEDs respectively. The pairs must reflect the board
> +       configuration, i.e. a sensor has to be able to strobe a flash LED by
> +       hardware. Flash LED is represented by a child node of a flash LED
> +       device (see Documentation/devicetree/bindings/leds/common.txt).
> +
>  The 'camera' node must include at least one 'fimc' child node.
>
>
> @@ -166,6 +174,8 @@ Example:
>                 clock-output-names = "cam_a_clkout", "cam_b_clkout";
>                 pinctrl-names = "default";
>                 pinctrl-0 = <&cam_port_a_clk_active>;
> +               samsung,camera-flashes = <&rear_camera &rear_flash>,
> +                                        <&front_camera &front_flash>;
>                 status = "okay";
>                 #address-cells = <1>;
>                 #size-cells = <1>;
> --
> 1.7.9.5
>
