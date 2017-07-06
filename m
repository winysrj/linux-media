Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:38742 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752514AbdGFKYz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Jul 2017 06:24:55 -0400
Subject: Re: [PATCH v6 4/4] dt-bindings: media: Document Synopsys Designware
 HDMI RX
To: Sylwester Nawrocki <snawrocki@kernel.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>
References: <cover.1499176790.git.joabreu@synopsys.com>
 <d6da0a3ec47a46d30b74e9d41fb4bf9ef392d969.1499176790.git.joabreu@synopsys.com>
 <4dc8f06f-b9cf-6d3d-da88-51abb24c1724@kernel.org>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Carlos Palminha" <CARLOS.PALMINHA@synopsys.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        <devicetree@vger.kernel.org>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <e87124d0-d523-5dcd-5ace-6b5896ad585c@synopsys.com>
Date: Thu, 6 Jul 2017 11:24:36 +0100
MIME-Version: 1.0
In-Reply-To: <4dc8f06f-b9cf-6d3d-da88-51abb24c1724@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,


On 05-07-2017 21:52, Sylwester Nawrocki wrote:
> On 07/04/2017 04:11 PM, Jose Abreu wrote:
>> Document the bindings for the Synopsys Designware HDMI RX.
>>
>> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
>> ---
>>   .../devicetree/bindings/media/snps,dw-hdmi-rx.txt  | 70 ++++++++++++++++++++++
>>   1 file changed, 70 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/media/snps,dw-hdmi-rx.txt
> Could you make the DT binding documentation patch first patch in the series?
> Now checkpatch will complain about undocumented compatible string when 
> the driver patches are applied alone.

Sure.

>
>> diff --git a/Documentation/devicetree/bindings/media/snps,dw-hdmi-rx.txt 
>> b/Documentation/devicetree/bindings/media/snps,dw-hdmi-rx.txt
>> new file mode 100644
>> index 0000000..449b8a2
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/snps,dw-hdmi-rx.txt
>> @@ -0,0 +1,70 @@
>> +Synopsys DesignWare HDMI RX Decoder
>> +===================================
>> +
>> +This document defines device tree properties for the Synopsys DesignWare HDMI
>> +RX Decoder (DWC HDMI RX). It doesn't constitute a device tree binding
>> +specification by itself but is meant to be referenced by platform-specific
>> +device tree bindings.
>> +
>> +When referenced from platform device tree bindings the properties defined in
>> +this document are defined as follows.
> It would be good to make it clear which properties are required and which are
> optional. And also to mention the properties below belong to the HDMI RX node.

Ok.

>
>> +- compatible: Shall be "snps,dw-hdmi-rx".
>> +
>> +- reg: Memory mapped base address and length of the DWC HDMI RX registers.
>> +
>> +- interrupts: Reference to the DWC HDMI RX interrupt and 5v sense interrupt.
> s/5v/HDMI 5V ?

Ok.

>
>> +
>> +- clocks: Phandle to the config clock block.
>> +
>> +- clock-names: Shall be "cfg".
>> +
>> +- edid-phandle: phandle to the EDID handler block.
> Could you make this property optional and when it is missing assume that device
> corresponding to the parent node of this node handles EDID? This way we could
> avoid having property pointing to the parent node.

Hmm, this is for the CEC notifier. Do you mean I should grab the
parent device for the notifier? This property is already optional
if cec is not enabled though.

>
>> +- #address-cells: Shall be 1.
>> +
>> +- #size-cells: Shall be 0.
>> +
>> +You also have to create a subnode for phy driver. Phy properties are as follows.
> s/phy driver. Phy/the PHY device. PHY ?
>
> Might be also worth to make it explicit these are all required properties.

Ok.

>
>> +- compatible: Shall be "snps,dw-hdmi-phy-e405".
>> +
>> +- reg: Shall be JTAG address of phy.
> s/phy/the PHY ?

Ok.

>
>> +- clocks: Phandle for cfg clock.
>> +
>> +- clock-names:Shall be "cfg".
>> +
>> +A sample binding is now provided. The compatible string is for a SoC which has
>> +has a Synopsys DesignWare HDMI RX decoder inside.
>> +
>> +Example:
>> +
>> +dw_hdmi_soc: dw-hdmi-soc@0 {
>> +	compatible = "snps,dw-hdmi-soc";
> Perhaps just make it
>
> 	compatible = "...";
> ?

Yeah, probably its better.

>
>> +	reg = <0x11c00 0x1000>; /* EDIDs */
> This is not relevant and undocumented, will likely be part of documentation 
> of other binding thus I'd suggest dropping this reg property.

Ok.

>
>> +	#address-cells = <1>;
>> +	#size-cells = <1>;
>> +	ranges;
>> +
>> +	hdmi-rx@0 {
>> +		compatible = "snps,dw-hdmi-rx";
>> +		reg = <0x0 0x10000>;
>> +		interrupts = <1 2>;
>> +		edid-phandle = <&dw_hdmi_soc>;
>> +
>> +		clocks = <&dw_hdmi_refclk>;
>> +		clock-names = "cfg";
>> +
>> +		#address-cells = <1>;
>> +		#size-cells = <0>;
>> +
>> +		hdmi-phy@fc {
>> +			compatible = "snps,dw-hdmi-phy-e405";
>> +			reg = <0xfc>;
>> +
>> +			clocks = <&dw_hdmi_refclk>;
>> +			clock-names = "cfg";
>> +		};
>> +	};
>> +};
> Otherwise looks good. I'll likely not have comments to the other patches.

Thanks for the review!

Best regards,
Jose Miguel Abreu

>
> --
> Regards,
> Sylwester
>  
