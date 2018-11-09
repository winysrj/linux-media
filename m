Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55953 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727596AbeKISgx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2018 13:36:53 -0500
Received: by mail-wm1-f66.google.com with SMTP id s10-v6so1228676wmc.5
        for <linux-media@vger.kernel.org>; Fri, 09 Nov 2018 00:57:16 -0800 (PST)
Subject: Re: [PATCH] dt-bindings: media: i2c: Fix i2c address for OV5645
 camera sensor
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        mchehab@kernel.org, robh+dt@kernel.org, hansverk@cisco.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20181109075643.17575-1-manivannan.sadhasivam@linaro.org>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <a777f934-9adb-83d7-b0b6-0777563410c0@linaro.org>
Date: Fri, 9 Nov 2018 10:57:14 +0200
MIME-Version: 1.0
In-Reply-To: <20181109075643.17575-1-manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mani,

On  9.11.2018 09:56, Manivannan Sadhasivam wrote:
> The i2c address for the Omnivision OV5645 camera sensor is 0x3c. It is
> incorrectly mentioned as 0x78 in binding. Hence fix that.

The seven bit i2c address of ov5645 is really 0x3c.
Thank you for finding this and sending the fix!

Best regards,
Todor

> 
> Fixes: 09c716af36e6 [media] media: i2c/ov5645: add the device tree binding document
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  Documentation/devicetree/bindings/media/i2c/ov5645.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov5645.txt b/Documentation/devicetree/bindings/media/i2c/ov5645.txt
> index fd7aec9f8e24..1a68ca5eb9a3 100644
> --- a/Documentation/devicetree/bindings/media/i2c/ov5645.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/ov5645.txt
> @@ -26,9 +26,9 @@ Example:
>  	&i2c1 {
>  		...
>  
> -		ov5645: ov5645@78 {
> +		ov5645: ov5645@3c {
>  			compatible = "ovti,ov5645";
> -			reg = <0x78>;
> +			reg = <0x3c>;
>  
>  			enable-gpios = <&gpio1 6 GPIO_ACTIVE_HIGH>;
>  			reset-gpios = <&gpio5 20 GPIO_ACTIVE_LOW>;
> 
