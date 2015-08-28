Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34616 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbbH1HB2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2015 03:01:28 -0400
Received: by wibcx1 with SMTP id cx1so3907050wib.1
        for <linux-media@vger.kernel.org>; Fri, 28 Aug 2015 00:01:27 -0700 (PDT)
Date: Fri, 28 Aug 2015 08:01:24 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	maxime.coquelin@st.com, srinivas.kandagatla@gmail.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/5] ARM: DT: STi: stihxxx-b2120: Add pulse-width
 properties to ssc2 & ssc3
Message-ID: <20150828070124.GG4796@x1>
References: <1440678575-21646-1-git-send-email-peter.griffin@linaro.org>
 <1440678575-21646-2-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1440678575-21646-2-git-send-email-peter.griffin@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 27 Aug 2015, Peter Griffin wrote:

> Adding these properties makes the I2C bus to the demodulators much
> more reliable, and we no longer suffer from I2C errors when tuning.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  arch/arm/boot/dts/stihxxx-b2120.dtsi | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/arch/arm/boot/dts/stihxxx-b2120.dtsi b/arch/arm/boot/dts/stihxxx-b2120.dtsi
> index f589fe4..62994ae 100644
> --- a/arch/arm/boot/dts/stihxxx-b2120.dtsi
> +++ b/arch/arm/boot/dts/stihxxx-b2120.dtsi
> @@ -27,12 +27,18 @@
>  			};
>  		};
>  
> -		i2c@9842000 {
> +		ssc2: i2c@9842000 {
>  			status = "okay";
> +			clock-frequency = <100000>;
> +			st,i2c-min-scl-pulse-width-us = <0>;
> +			st,i2c-min-sda-pulse-width-us = <5>;
>  		};
>  
> -		i2c@9843000 {
> +		ssc3: i2c@9843000 {
>  			status = "okay";
> +			clock-frequency = <100000>;
> +			st,i2c-min-scl-pulse-width-us = <0>;
> +			st,i2c-min-sda-pulse-width-us = <5>;
>  		};
>  
>  		i2c@9844000 {

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
