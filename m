Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34584 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751283AbdAWQ2N (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jan 2017 11:28:13 -0500
Date: Mon, 23 Jan 2017 18:27:18 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        Inki Dae <inki.dae@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv3 4/5] exynos4.dtsi: add HDMI controller phandle
Message-ID: <20170123162718.4tqhjgs56eewx4tc@kozik-lap>
References: <20170123102337.20947-1-hverkuil@xs4all.nl>
 <20170123102337.20947-5-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20170123102337.20947-5-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 23, 2017 at 11:23:36AM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Update the bindings documenting the new hdmi phandle and
> update exynos4.dtsi accordingly. This phandle is needed by the
> s5p-cec driver to initialize the HPD notifier framework.
> 
> Tested with my Odroid U3.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> CC: linux-samsung-soc@vger.kernel.org
> ---
>  Documentation/devicetree/bindings/media/s5p-cec.txt | 2 ++
>  arch/arm/boot/dts/exynos4.dtsi                      | 1 +
>  2 files changed, 3 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/s5p-cec.txt b/Documentation/devicetree/bindings/media/s5p-cec.txt
> index 925ab4d72eaa..710fc005150c 100644
> --- a/Documentation/devicetree/bindings/media/s5p-cec.txt
> +++ b/Documentation/devicetree/bindings/media/s5p-cec.txt
> @@ -15,6 +15,7 @@ Required properties:
>    - clock-names : from common clock binding: must contain "hdmicec",
>  		  corresponding to entry in the clocks property.
>    - samsung,syscon-phandle - phandle to the PMU system controller
> +  - samsung,hdmi-phandle - phandle to the HDMI controller
>  
>  Example:
>  
> @@ -25,6 +26,7 @@ hdmicec: cec@100B0000 {
>  	clocks = <&clock CLK_HDMI_CEC>;
>  	clock-names = "hdmicec";
>  	samsung,syscon-phandle = <&pmu_system_controller>;
> +	samsung,hdmi-phandle = <&hdmi>;
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&hdmi_cec>;
>  	status = "okay";

The bindings description can be a separate patch (often welcomed) but
does not have to. It may be squashed with driver changes. But not with
DTS changes because DTS should go through samsung-soc tree (alone). The
bindings description usually go through subsystem maintainer.

When sending the bindings description, please Cc at least
devicetree@vger.kernel.org as mentioned by get_maintainers. It is
welcomed to Cc also DT maintainers (Rob & Mark) although with simple
bindings extension I think it is not a necessity.

Anyway please split this and name the subject (git log --oneline
arch/arm/boot/dts/exynos*: "ARM: dts: exynos: Foo Bar").

Best regards,
Krzysztof

> diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
> index c64737baa45e..51dfcbb51b6b 100644
> --- a/arch/arm/boot/dts/exynos4.dtsi
> +++ b/arch/arm/boot/dts/exynos4.dtsi
> @@ -762,6 +762,7 @@
>  		clocks = <&clock CLK_HDMI_CEC>;
>  		clock-names = "hdmicec";
>  		samsung,syscon-phandle = <&pmu_system_controller>;
> +		samsung,hdmi-phandle = <&hdmi>;
>  		pinctrl-names = "default";
>  		pinctrl-0 = <&hdmi_cec>;
>  		status = "disabled";
> -- 
> 2.11.0
> 
