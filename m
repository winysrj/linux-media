Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:55584 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751320AbeERVyV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 17:54:21 -0400
Received: by mail-wm0-f65.google.com with SMTP id a8-v6so16282303wmg.5
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 14:54:20 -0700 (PDT)
References: <20180518092806.3829-1-rui.silva@linaro.org> <20180518092806.3829-8-rui.silva@linaro.org> <20180518165022.GB21131@rob-hp-laptop>
From: Rui Miguel Silva <rui.silva@linaro.org>
To: Rob Herring <robh@kernel.org>
Cc: Rui Miguel Silva <rui.silva@linaro.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>, linux-clk@vger.kernel.org
Subject: Re: [PATCH v5 07/12] ARM: dts: imx7s: add mipi phy power domain
In-reply-to: <20180518165022.GB21131@rob-hp-laptop>
Date: Fri, 18 May 2018 22:54:17 +0100
Message-ID: <m3y3ggd3zq.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,
On Fri 18 May 2018 at 16:50, Rob Herring wrote:
> On Fri, May 18, 2018 at 10:28:01AM +0100, Rui Miguel Silva 
> wrote:
>> Add power domain index 0 related with mipi-phy to imx7s.
>> 
>> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
>> ---
>>  arch/arm/boot/dts/imx7s.dtsi | 6 ++++++
>>  1 file changed, 6 insertions(+)
>> 
>> diff --git a/arch/arm/boot/dts/imx7s.dtsi 
>> b/arch/arm/boot/dts/imx7s.dtsi
>> index 4d42335c0dee..67450ad89940 100644
>> --- a/arch/arm/boot/dts/imx7s.dtsi
>> +++ b/arch/arm/boot/dts/imx7s.dtsi
>> @@ -636,6 +636,12 @@
>>  					#address-cells = <1>;
>>  					#size-cells = <0>;
>>  
>> +					pgc_mipi_phy: 
>> pgc-power-domain@0 {
>
> power-domain@0

I can change it, but...
>
>> + 
>> #power-domain-cells = <0>;
>> +						reg = <0>;
>> +						power-supply = 
>> <&reg_1p0d>;
>> +					};
>> +
>>  					pgc_pcie_phy: 
>>  pgc-power-domain@1 {
>
> ditto.

This was not introduced by my patch, it is already there and I was
trying to be coherent with the existing naming.
but let me know if you like me to change it also.

---
Cheers,
	Rui
