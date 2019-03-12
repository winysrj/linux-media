Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB81FC43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 14:05:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C6612087C
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 14:05:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bics063t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbfCLOF3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 10:05:29 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36395 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbfCLOF3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 10:05:29 -0400
Received: by mail-wr1-f68.google.com with SMTP id g18so2871899wru.3
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2019 07:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=Ae3WRq4jyg8RQTHC2kXqGMDRMH7DYMb+QRqEF+aWxzg=;
        b=bics063tViopRzk+isSWJImb7HDgLQTBgaZ1S747PthYGodGRGLiYl3/ED13D3iGOD
         IMId7yE2BYUab9QWDX3j16HzPqIhyB1X/NYHUDHQf+mpmeRRSKs/+g2m/mb+mEm3FCk7
         ZwFaH5fqW/IhjYbC5+p7oWPwPktT0xoFOXemo3wKFg7P51wJafqBI4p4hyUD7rcottuS
         T0QCj9sa3uP71nIBYY5LVBezbzy2u8+xL9e4W/9AhuMe+NJebDAeOkMRDZApLITnMdX7
         sUjMX5L/q9K2jQnlk8bGOE7qJayM+fuVtPPO6VSdzgYggY3sMjMeMOPvdszPTittshb3
         jDqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=Ae3WRq4jyg8RQTHC2kXqGMDRMH7DYMb+QRqEF+aWxzg=;
        b=rFv2iACxP6/cjaLo5VMitsdJT5QO133GWocYW4sot5yGADF4o/J9MkTl4JJmlqVoqk
         Pd8BjNgyGifjQTFLGI+QSgPj5mJuM8KVBIaQSikk0tesvhVSx0as7Ia+RI+ybPNsbtiX
         jGjg95uvjXDtVfAVe+JUpUb5w44wIZi1o/i3fQkGNQWBS8uyQjpIWsT3sry6OhmsrkLv
         XLW45272VOVt535BBEugKlmbX/QOpItZWXN6jbBZKCuOvfwDkrvUEQtRdXTstXPkRFNY
         oZFhBGStusJJLRTJiZF+WL/GhRc41ifkewO32nY1NWJRv5vvu+nA7ae9a5dgW94xsSSV
         WhJA==
X-Gm-Message-State: APjAAAXEO7T6HPdEny5dd6UBRqeeTIuifgRvCArUwp/0ys/HJ557Pxw/
        vcDUrZ3lPAAdLKqewWiBnRV8vw==
X-Google-Smtp-Source: APXvYqy1Fezem0EnCPRW4ytCycQ2rIHMtGfwG6DBcFp5XYCTUjMBgbLJifXV09389L0Vvy4OZnSDRw==
X-Received: by 2002:a5d:5042:: with SMTP id h2mr5321099wrt.12.1552399527029;
        Tue, 12 Mar 2019 07:05:27 -0700 (PDT)
Received: from arch-late (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id a64sm2165826wma.11.2019.03.12.07.05.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Mar 2019 07:05:26 -0700 (PDT)
References: <20190206151328.21629-1-rui.silva@linaro.org> <20190206151328.21629-9-rui.silva@linaro.org> <20190310214102.GA7578@pendragon.ideasonboard.com>
User-agent: mu4e 1.0; emacs 27.0.50
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v14 08/13] ARM: dts: imx7: Add video mux, csi and mipi_csi and connections
In-reply-to: <20190310214102.GA7578@pendragon.ideasonboard.com>
Date:   Tue, 12 Mar 2019 14:05:24 +0000
Message-ID: <m3y35kdw7v.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,
On Sun 10 Mar 2019 at 21:41, Laurent Pinchart wrote:
> Hi Rui,
>
> Thank you for the patch.

Where have you been for the latest 14 versions? :)

This is already merged, but... follow up patches can address your
issues bellow.

>
> On Wed, Feb 06, 2019 at 03:13:23PM +0000, Rui Miguel Silva 
> wrote:
>> This patch adds the device tree nodes for csi, video 
>> multiplexer and
>> mipi-csi besides the graph connecting the necessary endpoints 
>> to make
>> the media capture entities to work in imx7 Warp board.
>> 
>> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
>> ---
>>  arch/arm/boot/dts/imx7s-warp.dts | 51 
>>  ++++++++++++++++++++++++++++++++
>>  arch/arm/boot/dts/imx7s.dtsi     | 27 +++++++++++++++++
>
> I would have split this in two patches to make backporting 
> easier, but
> it's not a big deal.
>
> Please see below for a few additional comments.
>
>>  2 files changed, 78 insertions(+)
>> 
>> diff --git a/arch/arm/boot/dts/imx7s-warp.dts 
>> b/arch/arm/boot/dts/imx7s-warp.dts
>> index 23431faecaf4..358bcae7ebaf 100644
>> --- a/arch/arm/boot/dts/imx7s-warp.dts
>> +++ b/arch/arm/boot/dts/imx7s-warp.dts
>> @@ -277,6 +277,57 @@
>>  	status = "okay";
>>  };
>>  
>> +&gpr {
>> +	csi_mux {
>> +		compatible = "video-mux";
>> +		mux-controls = <&mux 0>;
>> +		#address-cells = <1>;
>> +		#size-cells = <0>;
>> +
>> +		port@1 {
>> +			reg = <1>;
>> +
>> +			csi_mux_from_mipi_vc0: endpoint {
>> +				remote-endpoint = 
>> <&mipi_vc0_to_csi_mux>;
>> +			};
>> +		};
>> +
>> +		port@2 {
>> +			reg = <2>;
>> +
>> +			csi_mux_to_csi: endpoint {
>> +				remote-endpoint = 
>> <&csi_from_csi_mux>;
>> +			};
>> +		};
>> +	};
>> +};
>> +
>> +&csi {
>> +	status = "okay";
>> +
>> +	port {
>> +		csi_from_csi_mux: endpoint {
>> +			remote-endpoint = <&csi_mux_to_csi>;
>> +		};
>> +	};
>> +};
>
> Shouldn't these two nodes, as well as port@1 of the mipi_csi 
> node, be
> moved to imx7d.dtsi ?

Yeah, I guess you are right here.

>
>> +
>> +&mipi_csi {
>> +	clock-frequency = <166000000>;
>> +	status = "okay";
>> +	#address-cells = <1>;
>> +	#size-cells = <0>;
>> +	fsl,csis-hs-settle = <3>;
>
> Shouldn't this be an endpoint property ? Different sensors 
> connected
> through different endpoints could have different timing 
> requirements.

Hum... I see you point, even tho the phy hs-settle is a common
control. 

>
>> +
>> +	port@1 {
>> +		reg = <1>;
>> +
>> +		mipi_vc0_to_csi_mux: endpoint {
>> +			remote-endpoint = 
>> <&csi_mux_from_mipi_vc0>;
>> +		};
>> +	};
>> +};
>> +
>>  &wdog1 {
>>  	pinctrl-names = "default";
>>  	pinctrl-0 = <&pinctrl_wdog>;
>> diff --git a/arch/arm/boot/dts/imx7s.dtsi 
>> b/arch/arm/boot/dts/imx7s.dtsi
>> index 792efcd2caa1..01962f85cab6 100644
>> --- a/arch/arm/boot/dts/imx7s.dtsi
>> +++ b/arch/arm/boot/dts/imx7s.dtsi
>> @@ -8,6 +8,7 @@
>>  #include <dt-bindings/gpio/gpio.h>
>>  #include <dt-bindings/input/input.h>
>>  #include <dt-bindings/interrupt-controller/arm-gic.h>
>> +#include <dt-bindings/reset/imx7-reset.h>
>>  #include "imx7d-pinfunc.h"
>>  
>>  / {
>> @@ -709,6 +710,17 @@
>>  				status = "disabled";
>>  			};
>>  
>> +			csi: csi@30710000 {
>> +				compatible = "fsl,imx7-csi";
>> +				reg = <0x30710000 0x10000>;
>> +				interrupts = <GIC_SPI 7 
>> IRQ_TYPE_LEVEL_HIGH>;
>> +				clocks = <&clks IMX7D_CLK_DUMMY>,
>> +						<&clks 
>> IMX7D_CSI_MCLK_ROOT_CLK>,
>> +						<&clks 
>> IMX7D_CLK_DUMMY>;
>> +				clock-names = "axi", "mclk", 
>> "dcic";
>> +				status = "disabled";
>> +			};
>> +
>>  			lcdif: lcdif@30730000 {
>>  				compatible = "fsl,imx7d-lcdif", 
>>  "fsl,imx28-lcdif";
>>  				reg = <0x30730000 0x10000>;
>> @@ -718,6 +730,21 @@
>>  				clock-names = "pix", "axi";
>>  				status = "disabled";
>>  			};
>> +
>> +			mipi_csi: mipi-csi@30750000 {
>> +				compatible = "fsl,imx7-mipi-csi2";
>> +				reg = <0x30750000 0x10000>;
>> +				interrupts = <GIC_SPI 25 
>> IRQ_TYPE_LEVEL_HIGH>;
>> +				clocks = <&clks 
>> IMX7D_IPG_ROOT_CLK>,
>> +					<&clks 
>> IMX7D_MIPI_CSI_ROOT_CLK>,
>> +					<&clks 
>> IMX7D_MIPI_DPHY_ROOT_CLK>;
>> +				clock-names = "pclk", "wrap", 
>> "phy";
>> +				power-domains = <&pgc_mipi_phy>;
>> +				phy-supply = <&reg_1p0d>;
>> +				resets = <&src 
>> IMX7_RESET_MIPI_PHY_MRST>;
>> +				reset-names = "mrst";
>> +				status = "disabled";
>
> How about already declaring port@0 here too (but obviously 
> without any
> endoint) ?

empty port, do not know if they make much sense.

---
Cheers,
	Rui

