Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:40787 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932248AbeFFJIn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 05:08:43 -0400
Received: by mail-lf0-f67.google.com with SMTP id q11-v6so7933514lfc.7
        for <linux-media@vger.kernel.org>; Wed, 06 Jun 2018 02:08:42 -0700 (PDT)
Subject: Re: [RFC PATCH v1 3/4] media: dt-bindings: rdacm20: add device tree
 binding
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        niklas.soderlund@ragnatech.se, jacopo@jmondi.org
References: <20180605233435.18102-1-kieran.bingham+renesas@ideasonboard.com>
 <20180605233435.18102-4-kieran.bingham+renesas@ideasonboard.com>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <3d7d9cef-2882-a67b-895d-ce3eb62a5fae@cogentembedded.com>
Date: Wed, 6 Jun 2018 12:08:40 +0300
MIME-Version: 1.0
In-Reply-To: <20180605233435.18102-4-kieran.bingham+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

On 6/6/2018 2:34 AM, Kieran Bingham wrote:

> Provide device tree binding documentation for the RDACM GMSL Camera.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>   .../devicetree/bindings/media/i2c/rdacm20.txt | 31 +++++++++++++++++++
>   .../devicetree/bindings/vendor-prefixes.txt   |  1 +
>   2 files changed, 32 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/media/i2c/rdacm20.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/rdacm20.txt b/Documentation/devicetree/bindings/media/i2c/rdacm20.txt
> new file mode 100644
> index 000000000000..22898e835580
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/rdacm20.txt
> @@ -0,0 +1,31 @@
> +* Global IMI RDACM20 GMSL Camera
> +
> +Required Properties:
> + - compatible: shall be "imi,rdacm20"
> + - reg: MAX9271 and OV10635 I2C addresses
> +
> +The camera node shall be connected to an I2C bus interface of
> +the GMSL deserialiser device of which will receive image data.
> +
> +The device node shall contain one 'port' child node with an
> +'endpoint' subnode for its digital output video port,
> +in accordance with the video interface bindings defined in
> +Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +Example:
> +
> +i2c@0 {
> +	#address-cells = <1>;
> +	#size-cells = <0>;
> +	reg = <0>;
> +		camera@51 {
> +		compatible = MAXIM_CAMERA0;

    What?

> +		reg = <0x51 0x61>;
> +
> +		port {
> +			rdacm20_out0: endpoint {
> +				remote-endpoint = <&max9286_in0>;
> +			};
> +		};
> +	};
> +};
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index b5f978a4cac6..1e438341ea6b 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -160,6 +160,7 @@ idt	Integrated Device Technologies, Inc.
>   ifi	Ingenieurburo Fur Ic-Technologie (I/F/I)
>   ilitek	ILI Technology Corporation (ILITEK)
>   img	Imagination Technologies Ltd.
> +imi	Integrated Micro-Electronics Inc.
>   infineon Infineon Technologies
>   inforce	Inforce Computing
>   ingenic	Ingenic Semiconductor

    I think this update needs to be in a separate patch.

MBR, Sergei
