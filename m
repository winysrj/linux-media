Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36002 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751606AbeERVyw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 17:54:52 -0400
Received: by mail-wr0-f195.google.com with SMTP id p4-v6so10558325wrh.3
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 14:54:52 -0700 (PDT)
References: <20180518092806.3829-1-rui.silva@linaro.org> <20180518092806.3829-9-rui.silva@linaro.org> <20180518165146.GC21131@rob-hp-laptop>
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
Subject: Re: [PATCH v5 08/12] ARM: dts: imx7s: add multiplexer controls
In-reply-to: <20180518165146.GC21131@rob-hp-laptop>
Date: Fri, 18 May 2018 22:54:49 +0100
Message-ID: <m3wow0d3yu.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,
On Fri 18 May 2018 at 16:51, Rob Herring wrote:
> On Fri, May 18, 2018 at 10:28:02AM +0100, Rui Miguel Silva 
> wrote:
>> The IOMUXC General Purpose Register has bitfield to control 
>> video bus
>> multiplexer to control the CSI input between the MIPI-CSI2 and 
>> parallel
>> interface. Add that register and mask.
>> 
>> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
>> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
>> ---
>>  arch/arm/boot/dts/imx7s.dtsi | 8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>> 
>> diff --git a/arch/arm/boot/dts/imx7s.dtsi 
>> b/arch/arm/boot/dts/imx7s.dtsi
>> index 67450ad89940..3590dab529f9 100644
>> --- a/arch/arm/boot/dts/imx7s.dtsi
>> +++ b/arch/arm/boot/dts/imx7s.dtsi
>> @@ -520,8 +520,14 @@
>>  
>>  			gpr: iomuxc-gpr@30340000 {
>>  				compatible = 
>>  "fsl,imx7d-iomuxc-gpr",
>> -					"fsl,imx6q-iomuxc-gpr", 
>> "syscon";
>> +					"fsl,imx6q-iomuxc-gpr", 
>> "syscon", "simple-mfd";
>>  				reg = <0x30340000 0x10000>;
>> +
>> +				mux: mux-controller {
>> +					compatible = "mmio-mux";
>> +					#mux-control-cells = <1>;
>> +					mux-reg-masks = <0x14 
>> 0x00000010>;
>
> If 1 bit control, then #mux-control-cells can be 0.

Ack.

>
>> +				};
>>  			};
>>  
>>  			ocotp: ocotp-ctrl@30350000 {
>> -- 
>> 2.17.0
>> 
