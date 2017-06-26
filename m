Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:47940 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751418AbdFZQm4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 12:42:56 -0400
Subject: Re: [PATCH v4 4/4] dt-bindings: media: Document Synopsys Designware
 HDMI RX
To: Rob Herring <robh@kernel.org>, Jose Abreu <Jose.Abreu@synopsys.com>
References: <cover.1497978962.git.joabreu@synopsys.com>
 <8ebe3dfcd61a1c8cfa99102c376ad26b2bfbd254.1497978963.git.joabreu@synopsys.com>
 <20170623215814.ase6g4lbukaeqak2@rob-hp-laptop>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Sylwester Nawrocki" <snawrocki@kernel.org>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <13f2516b-9e2b-4ad6-ecf1-76fc0d744a32@synopsys.com>
Date: Mon, 26 Jun 2017 17:42:49 +0100
MIME-Version: 1.0
In-Reply-To: <20170623215814.ase6g4lbukaeqak2@rob-hp-laptop>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,


On 23-06-2017 22:58, Rob Herring wrote:
> On Tue, Jun 20, 2017 at 06:26:12PM +0100, Jose Abreu wrote:
>> Document the bindings for the Synopsys Designware HDMI RX.
>>
>> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
>> Cc: Carlos Palminha <palminha@synopsys.com>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Sylwester Nawrocki <snawrocki@kernel.org>
>>
>> Changes from v3:
>> 	- Document the new DT bindings suggested by Sylwester
>> Changes from v2:
>> 	- Document edid-phandle property
>> ---
>>  .../devicetree/bindings/media/snps,dw-hdmi-rx.txt  | 70 ++++++++++++++++++++++
>>  1 file changed, 70 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/snps,dw-hdmi-rx.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/snps,dw-hdmi-rx.txt b/Documentation/devicetree/bindings/media/snps,dw-hdmi-rx.txt
>> new file mode 100644
>> index 0000000..efb0ac3
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
>> +
>> +- compatible: Shall be "snps,dw-hdmi-rx".
>> +
>> +- reg: Memory mapped base address and length of the DWC HDMI RX registers.
>> +
>> +- interrupts: Reference to the DWC HDMI RX interrupt and 5v sense interrupt.
>> +
>> +- clocks: Phandle to the config clock block.
>> +
>> +- clock-names: Shall be "cfg-clk".
> "-clk" is redundant.
>
> Seems strange that this is the only clock. The only other clock is the 
> HDMI clock from the HDMI transmitter.

Its a receiver so it gets driven by the transmitter. In my
implementation I only need to configure this clock in the
controller so that it knows the timebase. I will change to "cfg"
only then.

>
>> +
>> +- edid-phandle: phandle to the EDID handler block.
>> +
>> +- #address-cells: Shall be 1.
>> +
>> +- #size-cells: Shall be 0.
>> +
>> +You also have to create a subnode for phy driver. Phy properties are as follows.
>> +
>> +- compatible: Shall be "snps,dw-hdmi-phy-e405".
>> +
>> +- reg: Shall be JTAG address of phy.
>> +
>> +- clocks: Phandle for cfg clock.
>> +
>> +- clock-names:Shall be "cfg-clk".
>> +
>> +A sample binding is now provided. The compatible string is for a SoC which has
>> +has a Synopsys Designware HDMI RX decoder inside.
>> +
>> +Example:
>> +
>> +dw_hdmi_soc: dw-hdmi-soc@0 {
>> +	compatible = "snps,dw-hdmi-soc";
> Not documented.

Yes, its a sample binding which reflects a wrapper driver that
shall instantiate the controller driver (and this wrapper driver
is not in this patch series), should I remove this?

>
>> +	reg = <0x11c00 0x1000>; /* EDIDs */
>> +	#address-cells = <1>;
>> +	#size-cells = <1>;
>> +	ranges;
>> +
>> +	dw_hdmi_rx@0 {
> hdmi-rx@0

Ok.

>
>> +		compatible = "snps,dw-hdmi-rx";
>> +		reg = <0x0 0x10000>;
>> +		interrupts = <1 2>;
>> +		edid-phandle = <&dw_hdmi_soc>;
> Don't need this if it is the parent node.

Sometimes it will not be the parent node (if edid handling is
done in a separate driver, for example).

>
>> +
>> +		clocks = <&dw_hdmi_refclk>;
>> +		clock-names = "cfg-clk";
>> +
>> +		#address-cells = <1>;
>> +		#size-cells = <0>;
>> +
>> +		dw_hdmi_phy_e405@fc {
> hdmi-phy@fc

Ok.

>
>> +			compatible = "snps,dw-hdmi-phy-e405";
>> +			reg = <0xfc>;
>> +
>> +			clocks = <&dw_hdmi_refclk>;
>> +			clock-names = "cfg-clk";

I will also change this to "cfg" only.

Thanks for the review!

Best regards,
Jose Miguel Abreu

>> +		};
>> +	};
>> +};
>> -- 
>> 1.9.1
>>
>>
