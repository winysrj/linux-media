Return-path: <linux-media-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61609 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932171Ab3J1Xyt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Oct 2013 19:54:49 -0400
Date: Mon, 28 Oct 2013 23:54:23 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Arun Kumar K <arun.kk@samsung.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"s.nawrocki@samsung.com" <s.nawrocki@samsung.com>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
	Pawel Moll <Pawel.Moll@arm.com>,
	"galak@codeaurora.org" <galak@codeaurora.org>,
	"a.hajda@samsung.com" <a.hajda@samsung.com>,
	"sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
	"shaik.ameer@samsung.com" <shaik.ameer@samsung.com>,
	"kilyeon.im@samsung.com" <kilyeon.im@samsung.com>,
	"arunkk.samsung@gmail.com" <arunkk.samsung@gmail.com>
Subject: Re: [PATCH v10 11/12] V4L: Add DT binding doc for s5k4e5 image sensor
Message-ID: <20131028235423.GD4763@kartoffel>
References: <1382074659-31130-1-git-send-email-arun.kk@samsung.com>
 <1382074659-31130-12-git-send-email-arun.kk@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1382074659-31130-12-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 18, 2013 at 06:37:38AM +0100, Arun Kumar K wrote:
> S5K4E5 is a Samsung raw image sensor controlled via I2C.
> This patch adds the DT binding documentation for the same.
> 
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> ---
>  .../devicetree/bindings/media/samsung-s5k4e5.txt   |   45 ++++++++++++++++++++
>  1 file changed, 45 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/samsung-s5k4e5.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/samsung-s5k4e5.txt b/Documentation/devicetree/bindings/media/samsung-s5k4e5.txt
> new file mode 100644
> index 0000000..0fca087
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/samsung-s5k4e5.txt
> @@ -0,0 +1,45 @@
> +* Samsung S5K4E5 Raw Image Sensor
> +
> +S5K4E5 is a raw image sensor with maximum resolution of 2560x1920
> +pixels. Data transfer is carried out via MIPI CSI-2 port and controls
> +via I2C bus.
> +
> +Required Properties:
> +- compatible	: must be "samsung,s5k4e5"

s/must be/should contain/

> +- reg		: I2C device address
> +- reset-gpios	: specifier of a GPIO connected to the RESET pin
> +- clocks	: should contain the sensor's EXTCLK clock specifier, from
> +		  the common clock bindings

I would reword this to reference clock-names so as to make the ordering
relationship explicit.

With that, as everything else looks sane:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Thanks
Mark.
