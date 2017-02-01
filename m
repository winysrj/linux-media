Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:35428 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752958AbdBARKr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Feb 2017 12:10:47 -0500
Received: by mail-wm0-f43.google.com with SMTP id b65so48471696wmf.0
        for <linux-media@vger.kernel.org>; Wed, 01 Feb 2017 09:10:46 -0800 (PST)
Date: Wed, 1 Feb 2017 17:10:40 +0000
From: Peter Griffin <peter.griffin@linaro.org>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        kernel@stlinux.com,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [STLinux Kernel] [PATCH v6 01/10] Documentation: DT: add
 bindings for ST DELTA
Message-ID: <20170201171040.GA31988@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1485965011-17388-1-git-send-email-hugues.fruchet@st.com>
 <1485965011-17388-2-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1485965011-17388-2-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 01 Feb 2017, Hugues Fruchet wrote:

> This patch adds DT binding documentation for STMicroelectronics
> DELTA V4L2 video decoder.
> 
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>

Acked-by: Peter Griffin <peter.griffin@linaro.org>

> ---
>  Documentation/devicetree/bindings/media/st,st-delta.txt | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/st,st-delta.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/st,st-delta.txt b/Documentation/devicetree/bindings/media/st,st-delta.txt
> new file mode 100644
> index 0000000..a538ab3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/st,st-delta.txt
> @@ -0,0 +1,17 @@
> +* STMicroelectronics DELTA multi-format video decoder
> +
> +Required properties:
> +- compatible: should be "st,st-delta".
> +- clocks: from common clock binding: handle hardware IP needed clocks, the
> +  number of clocks may depend on the SoC type.
> +  See ../clock/clock-bindings.txt for details.
> +- clock-names: names of the clocks listed in clocks property in the same order.
> +
> +Example:
> +	delta0 {
> +		compatible = "st,st-delta";
> +		clock-names = "delta", "delta-st231", "delta-flash-promip";
> +		clocks = <&clk_s_c0_flexgen CLK_VID_DMU>,
> +			 <&clk_s_c0_flexgen CLK_ST231_DMU>,
> +			 <&clk_s_c0_flexgen CLK_FLASH_PROMIP>;
> +	};
