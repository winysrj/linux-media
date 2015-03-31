Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44094 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576AbbCaPI6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2015 11:08:58 -0400
Message-ID: <1427814533.2969.61.camel@pengutronix.de>
Subject: Re: [PATCH v4] v4l: mt9v032: Add OF support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@iki.fi,
	Carlos =?ISO-8859-1?Q?Sanmart=EDn?= Bustos <carsanbu@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Date: Tue, 31 Mar 2015 17:08:53 +0200
In-Reply-To: <1426685926-22946-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1426685926-22946-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Am Mittwoch, den 18.03.2015, 15:38 +0200 schrieb Laurent Pinchart:
> Parse DT properties into a platform data structure when a DT node is
> available.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> ---
> 
> Changes since v3:
> 
> - Use /bits/ 64 in the DT bindings example
> - Remove the parent I2C master node from the DT bindings example
> - Use devm_kcalloc() to allocate array
> 
> Changes since v2:
> 
> - Use of_graph_get_next_endpoint()
> 
> Changes since v1:
> 
> - Add MT9V02[24] compatible strings
> - Prefix all compatible strings with "aptina,"
> - Use "link-frequencies" instead of "link-freqs"
> ---
>  .../devicetree/bindings/media/i2c/mt9v032.txt      | 39 ++++++++++++
>  MAINTAINERS                                        |  1 +
>  drivers/media/i2c/mt9v032.c                        | 69 +++++++++++++++++++++-
>  3 files changed, 108 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/mt9v032.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/mt9v032.txt b/Documentation/devicetree/bindings/media/i2c/mt9v032.txt
> new file mode 100644
> index 0000000..2025653
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/mt9v032.txt
> @@ -0,0 +1,39 @@
> +* Aptina 1/3-Inch WVGA CMOS Digital Image Sensor
> +
> +The Aptina MT9V032 is a 1/3-inch CMOS active pixel digital image sensor with
> +an active array size of 752H x 480V. It is programmable through a simple
> +two-wire serial interface.
> +
> +Required Properties:
> +
> +- compatible: value should be either one among the following
> +	(a) "aptina,mt9v022" for MT9V022 color sensor
> +	(b) "aptina,mt9v022m" for MT9V022 monochrome sensor
> +	(c) "aptina,mt9v024" for MT9V024 color sensor
> +	(d) "aptina,mt9v024m" for MT9V024 monochrome sensor
> +	(e) "aptina,mt9v032" for MT9V032 color sensor
> +	(f) "aptina,mt9v032m" for MT9V032 monochrome sensor
> +	(g) "aptina,mt9v034" for MT9V034 color sensor
> +	(h) "aptina,mt9v034m" for MT9V034 monochrome sensor
> +
> +Optional Properties:
> +
> +- link-frequencies: List of allowed link frequencies in Hz. Each frequency is
> +	expressed as a 64-bit big-endian integer.
> +
> +For further reading on port node refer to
> +Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +Example:
> +
> +	mt9v032@5c {
> +		compatible = "aptina,mt9v032";
> +		reg = <0x5c>;
> +
> +		port {
> +			mt9v032_out: endpoint {
> +				link-frequencies = /bits/ 64
> +					<13000000 26600000 27000000>;
> +			};
> +		};
> +	};
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ddc5a8c..180f6fb 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6535,6 +6535,7 @@ M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>  L:	linux-media@vger.kernel.org
>  T:	git git://linuxtv.org/media_tree.git
>  S:	Maintained
> +F:	Documentation/devicetree/bindings/media/i2c/mt9v032.txt
>  F:	drivers/media/i2c/mt9v032.c
>  F:	include/media/mt9v032.h
>  
> diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> index 255ea91..697be25 100644
> --- a/drivers/media/i2c/mt9v032.c
> +++ b/drivers/media/i2c/mt9v032.c
> @@ -17,6 +17,8 @@
>  #include <linux/i2c.h>
>  #include <linux/log2.h>
>  #include <linux/mutex.h>
> +#include <linux/of.h>
> +#include <linux/of_gpio.h>

I think of_gpio is not needed in mt9v032.c. Otherwise,
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

