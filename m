Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:35459 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab3HEFVB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 01:21:01 -0400
Received: by mail-ob0-f175.google.com with SMTP id xn12so4675425obc.20
        for <linux-media@vger.kernel.org>; Sun, 04 Aug 2013 22:21:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1375455762-22071-2-git-send-email-arun.kk@samsung.com>
References: <1375455762-22071-1-git-send-email-arun.kk@samsung.com>
	<1375455762-22071-2-git-send-email-arun.kk@samsung.com>
Date: Mon, 5 Aug 2013 10:51:00 +0530
Message-ID: <CAK9yfHzt3taTwsub_DyPQr6Ojz1BAXuF+dNJ3sVv2RymmDy72A@mail.gmail.com>
Subject: Re: [RFC v3 01/13] [media] exynos5-is: Adding media device driver for exynos5
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Arun Kumar K <arun.kk@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, a.hajda@samsung.com, shaik.ameer@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2 August 2013 20:32, Arun Kumar K <arun.kk@samsung.com> wrote:
> From: Shaik Ameer Basha <shaik.ameer@samsung.com>
>
> This patch adds support for media device for EXYNOS5 SoCs.
> The current media device supports the following ips to connect
> through the media controller framework.
>
> * MIPI-CSIS
>   Support interconnection(subdev interface) between devices
>
> * FIMC-LITE
>   Support capture interface from device(Sensor, MIPI-CSIS) to memory
>   Support interconnection(subdev interface) between devices
>
> * FIMC-IS
>   Camera post-processing IP having multiple sub-nodes.
>
> G-Scaler will be added later to the current media device.
>
> The media device creates two kinds of pipelines for connecting
> the above mentioned IPs.
> The pipeline0 is uses Sensor, MIPI-CSIS and FIMC-LITE which captures
> image data and dumps to memory.
> Pipeline1 uses FIMC-IS components for doing post-processing
> operations on the captured image and give scaled YUV output.
>
> Pipeline0
>   +--------+     +-----------+     +-----------+     +--------+
>   | Sensor | --> | MIPI-CSIS | --> | FIMC-LITE | --> | Memory |
>   +--------+     +-----------+     +-----------+     +--------+
>
> Pipeline1
>  +--------+      +--------+     +-----------+     +-----------+
>  | Memory | -->  |  ISP   | --> |    SCC    | --> |    SCP    |
>  +--------+      +--------+     +-----------+     +-----------+
>
> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>

[snip]

> +
> +Common 'camera' node
> +--------------------
> +
> +Required properties:
> +
> +- compatible   : must be "samsung,exynos5-fimc", "simple-bus"

I am not sure if this point was discusssed during the previous
versions. "samsung,exynos5-fimc" seems a bit generic.
The compatible string should generally point to a specific SoC (the
first one to have this IP), something like "samsung,exynos5250-fimc".

> +- clocks       : list of clock specifiers, corresponding to entries in
> +                 the clock-names property;
> +- clock-names  : must contain "sclk_cam0", "sclk_cam1" entries,
> +                 matching entries in the clocks property.
> +

[snip]

> +Example:
> +
> +       aliases {
> +               fimc-lite0 = &fimc_lite_0
> +       };
> +
> +       /* Parallel bus IF sensor */
> +       i2c_0: i2c@13860000 {
> +               s5k6aa: sensor@3c {
> +                       compatible = "samsung,s5k6aafx";
> +                       reg = <0x3c>;
> +                       vddio-supply = <...>;
> +
> +                       clock-frequency = <24000000>;
> +                       clocks = <...>;
> +                       clock-names = "mclk";
> +
> +                       port {
> +                               s5k6aa_ep: endpoint {
> +                                       remote-endpoint = <&fimc0_ep>;
> +                                       bus-width = <8>;
> +                                       hsync-active = <0>;
> +                                       vsync-active = <1>;
> +                                       pclk-sample = <1>;
> +                               };
> +                       };
> +               };
> +       };
> +
> +       /* MIPI CSI-2 bus IF sensor */
> +       s5c73m3: sensor@0x1a {

0x not needed.

-- 
With warm regards,
Sachin
