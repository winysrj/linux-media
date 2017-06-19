Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.47.9]:51735 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750757AbdFSJEc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 05:04:32 -0400
Subject: Re: [PATCH v3 4/4] dt-bindings: media: Document Synopsys Designware
 HDMI RX
To: Sylwester Nawrocki <sylwester.nawrocki@gmail.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>
References: <cover.1497630695.git.joabreu@synopsys.com>
 <51851d7b2335cc8a10fba17056314d7fa8ce88d1.1497630695.git.joabreu@synopsys.com>
 <f58aaeaa-3e49-3cbc-0ed8-8c3a6ebd3907@gmail.com>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <28d2ca0e-d9bc-816a-313c-e367aaed166e@synopsys.com>
Date: Mon, 19 Jun 2017 10:01:09 +0100
MIME-Version: 1.0
In-Reply-To: <f58aaeaa-3e49-3cbc-0ed8-8c3a6ebd3907@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,


Thanks for the feedback!


On 18-06-2017 18:34, Sylwester Nawrocki wrote:
> Hi Jose,
>
> On 06/16/2017 06:38 PM, Jose Abreu wrote:
>> Document the bindings for the Synopsys Designware HDMI RX.
>>
>> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
>> new file mode 100644
>> index 0000000..d30cc1e
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/snps,dw-hdmi-rx.txt
>> @@ -0,0 +1,45 @@
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
>> +- reg: Memory mapped base address and length of the DWC HDMI RX registers.
>> +
>> +- interrupts: Reference to the DWC HDMI RX interrupt and 5v sense interrupt.
>> +
>> +- snps,hdmi-phy-jtag-addr: JTAG address of the phy to be used.
>> +
>> +- snps,hdmi-phy-version: Version of the phy to be used.
>> +
>> +- snps,hdmi-phy-cfg-clk: Value of the cfg clk that is delivered to phy.
>> +
>> +- snps,hdmi-phy-driver: *Exact* name of the phy driver to be used.
> I don't think we can put Linux driver name in DT like this, devicetree 
> is supposed to be describing hardware in OS agnostic way.

Yeah, I was aware about that, its just that I have a few
limitations that I need to address. I will highlight them bellow
but I think that with your proposed DT bindings and using
of_platform_populate I can address them :)

>
>> +- snps,hdmi-ctl-cfg-clk: Value of the cfg clk that is delivered to the
>> +controller.
> How about creating a separate node for the PHY? The binding could then 
> be something like:
>
>
> /* Fixed clock needed only if respective clock is not already defined    
>    in the system */
>
> refclk: clock {
> 	compatible = "fixed-clock";
> 	#clock-cells = <0>;
> 	clock-frequency = <25000000>;
> };
>
> hdmi_phy: phy@f3 {
> 	/* PHY version can be derived from the compatible string */
> 	compatible = "snps,dw-hdmi-phy-e405"; 	
> 	/* JTAG address of the PHY */
> 	reg = <0xf3>
>
> 	clocks = <&refclk>
> 	clock-names = "cfg-clk";
> }
>
> hdmi-controller@0 {
> 	compatible = "snps,dw-hdmi-rx-controller-vX.X";
> 	reg = <0x0 0x10000>;
> 	interrupts = <1 3>; 	
> 	phys = <&hdmi_phy>;
>
> 	clocks = <&refclk>
> 	clock-names = "cfg-clk";
> };
>
> Or it might be better to make the PHY node child node of the RX controller 
> node, since the RX controller could be considered a controller of the JTAG 
> bus IIUC:
>
> refclk: clock {
> 	compatible = "fixed-clock";
> 	#clock-cells = <0>;
> 	clock-frequency = <25000000>;
> };
>
> hdmi-controller@0 {
> 	compatible = "snps,dw-hdmi-rx-controller-xxx";
> 	reg = <0x0 0x10000>;
> 	interrupts = <1 3>; 	
> 	clocks = <&refclk>
> 	clock-names = "cfg-clk";
> 	#address-cells = <1>;
> 	#size-cells = <0>;
>
> 	phy@f3 {
> 		/* PHY version can be derived from the compatible string */
> 		compatible = "snps,dw-hdmi-phy-e405";
>  		/* address of the PHY on the JTAG bus */
> 		reg = <0xf3>
>
> 		clocks = <&refclk>
> 		clock-names = "cfg-clk";
> 	}
> };
>
> Then rather than creating platform device in the RX controller driver 
> for the PHY just of_platform_populate() could be used.

Using fixed-clock was already in my todo list. Regarding phy I
need to pass pdata so that the callbacks between controller and
phy are established. I also need to make sure that phy driver
will be loaded by the controller driver. Hmm, and also address of
the phy on th JTAG bus is fed to the controller driver not to the
phy driver. Maybe leave the property as is (the
"snps,hdmi-phy-jtag-addr") or parse it from the phy node?

I also need to pass pdata to the controller driver (the callbacks
for 5v handling) which are agnostic of the controller. These
reasons prevented me from adding compatible strings to both
drivers and just use a wrapper driver instead. This way i do
"modprobe wrapper_driver" and I get all the drivers loaded via
request_module(). Still, I like your approach much better. I saw
that I can pass pdata using of_platform_populate, could you
please confirm if I can still maintain this architecture (i.e.
prevent modules from loading until I get all the chain setup)?

Following your approach I could get something like this:

hdmi_system@YYYY {
    compatible = "snps,dw-hdmi-rx-wrapper";
    reg = <0xYYYY 0xZZZZ>;
    interrupts = <3>;
    #address-cells = <1>;
    #size-cells = <1>;

    hdmi_controller@0 {
        compatible = "snps,dw-hdmi-rx-controller";
        reg = <0x0 0x10000>;
        interrupts = <1>;
        edid-phandle = <&hdmi_system>;
        clocks = <&refclk>;
        clock-names = "ref-clk";
        #address-cells = <1>;
        #size-cells = <0>;

        hdmi_phy@f3 {
            compatible = "snps,dw-hdmi-phy-e405";
            reg = <0xf3>;
            clocks = <&cfgclk>;
            clock-names = "cfg-clk";
        }
    }
};

And then snps,dw-hdmi-rx-wrapper would call of_platform_populate
for controller which would instead call of_platform_populate for
phy. Is this possible, and maintainable? Isn't the controller
driver get auto loaded because of the compatible string match?
And one more thing: The reg address of the hdmi_controller: Isn't
this relative to the parent node? I mean isn't this going to be
0xYYYY + 0x0? Because I don't want that :/

Best regards,
Jose Miguel Abreu

>
>> +- edid-phandle: phandle to the EDID driver. It can be, for example, the main
>> +wrapper driver.
>> +
>> +A sample binding is now provided. The compatible string is for a wrapper driver
>> +which then instantiates the Synopsys Designware HDMI RX decoder driver.
> I would avoid talking about drivers in DT binding documentation, we should 
> rather refer to hardware blocks.
>
>> +Example:
>> +
>> +dw_hdmi_wrapper: dw-hdmi-wrapper@0 {
>> +	compatible = "snps,dw-hdmi-rx-wrapper";
>> +	reg = <0x0 0x10000>; /* controller regbank */
>> +	interrupts = <1 3>; /* controller interrupt + 5v sense interrupt */
>> +	snps,hdmi-phy-driver = "dw-hdmi-phy-e405";
>> +	snps,hdmi-phy-version = <405>;
>> +	snps,hdmi-phy-cfg-clk = <25>; /* MHz */
>> +	snps,hdmi-ctl-cfg-clk = <25>; /* MHz */
>> +	snps,hdmi-phy-jtag-addr = /bits/ 8 <0xfc>;
>> +	edid-phandle = <&dw_hdmi_wrapper>;
>> +};
> --
> Regards,
> Sylwester
>
