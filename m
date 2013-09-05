Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:46170 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab3IEUC0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Sep 2013 16:02:26 -0400
Message-ID: <5228E34B.307@gmail.com>
Date: Thu, 05 Sep 2013 22:02:19 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, swarren@wwwdotorg.org, mark.rutland@arm.com,
	Pawel.Moll@arm.com, galak@codeaurora.org, a.hajda@samsung.com,
	sachin.kamat@linaro.org, shaik.ameer@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com
Subject: Re: [PATCH v7 13/13] V4L: Add driver for s5k4e5 image sensor
References: <1377066881-5423-1-git-send-email-arun.kk@samsung.com> <1377066881-5423-14-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1377066881-5423-14-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/21/2013 08:34 AM, Arun Kumar K wrote:
> This patch adds subdev driver for Samsung S5K4E5 raw image sensor.
> Like s5k6a3, it is also another fimc-is firmware controlled
> sensor. This minimal sensor driver doesn't do any I2C communications
> as its done by ISP firmware. It can be updated if needed to a
> regular sensor driver by adding the I2C communication.
>
> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
> Reviewed-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
> ---
>   .../devicetree/bindings/media/i2c/s5k4e5.txt       |   43 +++
>   drivers/media/i2c/Kconfig                          |    8 +
>   drivers/media/i2c/Makefile                         |    1 +
>   drivers/media/i2c/s5k4e5.c                         |  361 ++++++++++++++++++++
>   4 files changed, 413 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/media/i2c/s5k4e5.txt
>   create mode 100644 drivers/media/i2c/s5k4e5.c
>
> diff --git a/Documentation/devicetree/bindings/media/i2c/s5k4e5.txt b/Documentation/devicetree/bindings/media/i2c/s5k4e5.txt
> new file mode 100644
> index 0000000..5af462c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/s5k4e5.txt
> @@ -0,0 +1,43 @@
> +* Samsung S5K4E5 Raw Image Sensor
> +
> +S5K4E5 is a raw image sensor with maximum resolution of 2560x1920
> +pixels. Data transfer is carried out via MIPI CSI-2 port and controls
> +via I2C bus.
> +
> +Required Properties:
> +- compatible	: must be "samsung,s5k4e5"
> +- reg		: I2C device address
> +- gpios		: reset gpio pin

I guess this should be "reset-gpios". How about changing description to:

- reset-gpios	: specifier of a GPIO connected to the RESET pin;

?
> +- clocks	: clock specifier for the clock-names property

Perhaps something along the lines of:

- clocks : "should contain the sensor's MCLK clock specifier, from
		  the common clock bindings"
?
> +- clock-names	: must contain "mclk" entry

Is name of the clock input pin really MCLK ?

> +- svdda-supply	: core voltage supply
> +- svddio-supply	: I/O voltage supply
> +
> +Optional Properties:
> +- clock-frequency : operating frequency for the sensor
> +                    default value will be taken if not provided.

How about clarifying it a bit, as Stephen suggested, e.g.:

- clock-frequency : the frequency at which the "mclk" clock should be
		    configured to operate, in Hz; if this property is not
		    specified default 24 MHz value will be used.

> +The device node should be added to respective control bus controller
> +(e.g. I2C0) nodes and linked to the csis port node, using the common
> +video interfaces bindings, defined in video-interfaces.txt.

This seems misplaced, S5K4E5 image sensor has nothingto do with csis nodes.
How about something like this instead:

"The common video interfaces bindings (see video-interfaces.txt) should be
used to specify link to the image data receiver. The S5K6A3(YX) device
node should contain one 'port' child node with an 'endpoint' subnode.

Following properties are valid for the endpoint node:
..."

> +Example:
> +
> +	i2c-isp@13130000 {
> +		s5k4e5@20 {
> +			compatible = "samsung,s5k4e5";
> +			reg =<0x20>;
> +			gpios =<&gpx1 2 1>;
> +			clock-frequency =<24000000>;
> +			clocks =<&clock 129>;
> +			clock-names = "mclk";
> +			svdda-supply =<...>;
> +			svddio-supply =<...>;
> +			port {
> +				is_s5k4e5_ep: endpoint {
> +					data-lanes =<1 2 3 4>;
> +					remote-endpoint =<&csis0_ep>;
> +				};
> +			};
> +		};
> +	};

--
Thanks,
Sylwester
