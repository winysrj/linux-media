Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:48118 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751553AbdIKJug (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 05:50:36 -0400
Subject: Re: [PATCH v10 24/24] arm: dts: omap3: N9/N950: Add flash references
 to the camera
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, linux-acpi@vger.kernel.org,
        mika.westerberg@intel.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
References: <20170911080008.21208-1-sakari.ailus@linux.intel.com>
 <20170911080008.21208-25-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3ea79dc9-9374-008f-7cd9-567a560a0fd5@xs4all.nl>
Date: Mon, 11 Sep 2017 11:50:29 +0200
MIME-Version: 1.0
In-Reply-To: <20170911080008.21208-25-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/2017 10:00 AM, Sakari Ailus wrote:
> Add flash and indicator LED phandles to the sensor node.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans


> ---
>  arch/arm/boot/dts/omap3-n9.dts       | 1 +
>  arch/arm/boot/dts/omap3-n950-n9.dtsi | 4 ++--
>  arch/arm/boot/dts/omap3-n950.dts     | 1 +
>  3 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/omap3-n9.dts b/arch/arm/boot/dts/omap3-n9.dts
> index b9e58c536afd..39e35f8b8206 100644
> --- a/arch/arm/boot/dts/omap3-n9.dts
> +++ b/arch/arm/boot/dts/omap3-n9.dts
> @@ -26,6 +26,7 @@
>  		clocks = <&isp 0>;
>  		clock-frequency = <9600000>;
>  		nokia,nvm-size = <(16 * 64)>;
> +		flash-leds = <&as3645a_flash &as3645a_indicator>;
>  		port {
>  			smia_1_1: endpoint {
>  				link-frequencies = /bits/ 64 <199200000 210000000 499200000>;
> diff --git a/arch/arm/boot/dts/omap3-n950-n9.dtsi b/arch/arm/boot/dts/omap3-n950-n9.dtsi
> index 1b0bd72945f2..12fbb3da5fce 100644
> --- a/arch/arm/boot/dts/omap3-n950-n9.dtsi
> +++ b/arch/arm/boot/dts/omap3-n950-n9.dtsi
> @@ -271,14 +271,14 @@
>  		#size-cells = <0>;
>  		reg = <0x30>;
>  		compatible = "ams,as3645a";
> -		flash@0 {
> +		as3645a_flash: flash@0 {
>  			reg = <0x0>;
>  			flash-timeout-us = <150000>;
>  			flash-max-microamp = <320000>;
>  			led-max-microamp = <60000>;
>  			ams,input-max-microamp = <1750000>;
>  		};
> -		indicator@1 {
> +		as3645a_indicator: indicator@1 {
>  			reg = <0x1>;
>  			led-max-microamp = <10000>;
>  		};
> diff --git a/arch/arm/boot/dts/omap3-n950.dts b/arch/arm/boot/dts/omap3-n950.dts
> index 646601a3ebd8..c354a1ed1e70 100644
> --- a/arch/arm/boot/dts/omap3-n950.dts
> +++ b/arch/arm/boot/dts/omap3-n950.dts
> @@ -60,6 +60,7 @@
>  		clocks = <&isp 0>;
>  		clock-frequency = <9600000>;
>  		nokia,nvm-size = <(16 * 64)>;
> +		flash-leds = <&as3645a_flash &as3645a_indicator>;
>  		port {
>  			smia_1_1: endpoint {
>  				link-frequencies = /bits/ 64 <210000000 333600000 398400000>;
> 
