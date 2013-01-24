Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52218 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750Ab3AXSaP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jan 2013 13:30:15 -0500
Message-id: <51017DB2.5050905@samsung.com>
Date: Thu, 24 Jan 2013 19:30:10 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	g.liakhovetski@gmx.de, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, grant.likely@secretlab.ca,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, myungjoo.ham@samsung.com,
	sw0312.kim@samsung.com, prabhakar.lad@ti.com,
	devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH RFC v4 01/14] [media] Add common video interfaces OF
 bindings documentation
References: <1358969489-20420-1-git-send-email-s.nawrocki@samsung.com>
 <1358969489-20420-2-git-send-email-s.nawrocki@samsung.com>
 <1525960.fMnIjkZnjX@avalon>
In-reply-to: <1525960.fMnIjkZnjX@avalon>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the review.

On 01/24/2013 11:16 AM, Laurent Pinchart wrote:
[...]
>> +Data interfaces on all video devices are described by their child 'port'
>> +nodes. Configuration of a port depends on other devices participating in
>> +the data transfer and is described by 'endpoint' subnodes.
>> +
>> +dev {
>> +	#address-cells = <1>;
>> +	#size-cells = <0>;
>> +	port@0 {
>> +		endpoint@0 { ... };
>> +		endpoint@1 { ... };
>> +	};
>> +	port@1 { ... };
>> +};
>> +
>> +If a port can be configured to work with more than one other device on the
>> +same bus, an 'endpoint' child node must be provided for each of them.  If
>> +more than one port is present in a device node or there is more than one
>> +endpoint at a port, a common scheme, using '#address-cells', '#size-cells'
>> +and 'reg' properties is used.
> 
> Wouldn't this cause problems if the device has both video ports and a child 
> bus ? Using #address-cells and #size-cells for the video ports would prevent 
> the child bus from being handled in the usual way.

Indeed, it looks like a serious issue in these bindings.

> A possible solution would be to number ports with a dash instead of a @, as 
> done in pinctrl for instance. We would then get
> 
> 	port-0 {
> 		endpoint-0 { ... };
> 		endpoint-1 { ... };
> 	};
> 	port-1 { ... };

Sounds like a good alternative, I can't think of any better solution at the
moment.

>> +Two 'endpoint' nodes are linked with each other through their
>> +'remote-endpoint' phandles.  An endpoint subnode of a device contains all
>> +properties needed for configuration of this device for data exchange with
>> +the other device.  In most cases properties at the peer 'endpoint' nodes
>> +will be identical, however they might need to be different when there is
>> +any signal modifications on the bus between two devices, e.g. there are
>> +logic signal inverters on the lines.
>> +
>> +Required properties
>> +-------------------
>> +
>> +If there is more than one 'port' or more than one 'endpoint' node following
>> +properties are required in relevant parent node:
>> +
>> +- #address-cells : number of cells required to define port number, should
>> be 1.
>> +- #size-cells    : should be zero.
> 
> I wonder if we should specify whether a port is a data sink or data source. A 
> source can be connected to multiple sinks at the same time, but a sink can 
> only be connected to a single source. If we want to perform automatic sanity 
> checks in the core knowing the direction might help.

Multiple sources can be linked to a single sink, but only one link can be 
active at any time.

So I'm not sure if knowing if a DT port is a data source or data sink would
let us to validate device tree structure statically in general.

Such source/sink property could be useful later at runtime, when data pipeline
is set up for streaming.

How do you think this could be represented ? By just having boolean 
properties like: 'source' and 'sink' in the port nodes ? Or perhaps in the 
endpoint nodes, since some devices might be bidirectional ? I don't recall 
any at the moment though.

>> +Optional endpoint properties
>> +----------------------------
>> +
>> +- remote-endpoint: phandle to an 'endpoint' subnode of the other device
>> +  node.
>> +- slave-mode: a boolean property, run the link in slave mode.
>> +  Default is master mode.
> 
> What are master and slave modes ? It might be worth it describing them.

This was originally proposed by Guennadi, I think he knows exactly what's
the meaning of this property. I'll dig into relevant documentation to 
find out and provide more detailed description.

>> +- bus-width: number of data lines, valid for parallel busses.
>> +- data-shift: on parallel data busses, if bus-width is used to specify the
>> +  number of data lines, data-shift can be used to specify which data lines
>> +  are used, e.g. "bus-width=<10>; data-shift=<2>;" means, that lines 9:2
>> +  are used.
>> +- hsync-active: active state of HSYNC signal, 0/1 for LOW/HIGH
>> +  respectively.
>> +- vsync-active: active state of VSYNC signal, 0/1 for LOW/HIGH
>> +  respectively. Note, that if HSYNC and VSYNC polarities are not
>> +  specified, embedded synchronization may be required, where supported.
>> +- data-active: similar to HSYNC and VSYNC, specifies data line polarity.
>> +- field-even-active: field signal level during the even field data
>> +  transmission.
>> +- pclk-sample: sample data on rising (1) or falling (0) edge of the pixel
>> +  clock signal.
>> +- data-lanes: an array of physical data lane indexes. Position of an entry
>> +  determines the logical lane number, while the value of an entry indicates
>> +  physical lane, e.g. for 2-lane MIPI CSI-2 bus we could have
>> +  "data-lanes = <1>, <2>;", assuming the clock lane is on hardware lane 0.
>> +  This property is valid for serial busses only (e.g. MIPI CSI-2).
>> +- clock-lanes: an array of physical clock lane indexes. Position of an
>> +  entry determines the logical lane number, while the value of an entry
>> +  indicates physical lane, e.g. for a MIPI CSI-2 bus we could have
>> +  "clock-lanes = <0>;", which places the clock lane on hardware lane 0.
>> +  This property is valid for serial busses only (e.g. MIPI CSI-2). Note
>> +  that for the MIPI CSI-2 bus this array contains only one entry.
>> +- clock-noncontinuous: a boolean property to allow MIPI CSI-2
>> +  non-continuous clock mode.
>> +
>> +Example
>> +-------
>> +
>> +The example snippet below describes two data pipelines.  ov772x and imx074
>> +are camera sensors with a parallel and serial (MIPI CSI-2) video bus
>> +respectively. Both sensors are on the I2C control bus corresponding to the
>> +i2c0 controller node.  ov772x sensor is linked directly to the ceu0 video
>> +host interface. imx074 is linked to ceu0 through the MIPI CSI-2 receiver
>> +(csi2). ceu0 has a (single) DMA engine writing captured data to memory. 
>> +ceu0 node has a single 'port' node which indicates that at any time only
>> +one of the following data pipelines can be active: ov772x -> ceu0 or
>> +imx074 -> csi2 -> ceu0.
>> +
>> +	ceu0: ceu@0xfe910000 {
>> +		compatible = "renesas,sh-mobile-ceu";
>> +		reg = <0xfe910000 0xa0>;
>> +		interrupts = <0x880>;
>> +
>> +		mclk: master_clock {
>> +			compatible = "renesas,ceu-clock";
>> +			#clock-cells = <1>;
>> +			clock-frequency = <50000000>;	/* Max clock frequency */
>> +			clock-output-names = "mclk";
>> +		};
>> +
>> +		port {
>> +			#address-cells = <1>;
>> +			#size-cells = <0>;
>> +
>> +			ceu0_1: endpoint@1 {
>> +				reg = <1>;		/* Local endpoint # */
>> +				remote = <&ov772x_1_1>;	/* Remote phandle */
>> +				bus-width = <8>;	/* Used data lines */
>> +				data-shift = <0>;	/* Lines 7:0 are used */
> 
> As data-shift is optional, shouldn't it be left out when equal to 0 ? It 
> would, however, be nice to have a non-zero data-shift somewhere in the 
> example.

Yes, good point. data-shift could be ommited. I'm going to increase the 
bus-width and make data-shit non-zero.

>> +
>> +				/* If hsync-active/vsync-active are missing,
>> +				   embedded bt.605 sync is used */
>> +				hsync-active = <1>;	/* Active high */
>> +				vsync-active = <1>;	/* Active high */
>> +				data-active = <1>;	/* Active high */
>> +				pclk-sample = <1>;	/* Rising */
>> +			};
>> +
>> +			ceu0_0: endpoint@0 {
>> +				reg = <0>;
>> +				remote = <&csi2_2>;
>> +				immutable;
> 
> What is the immutable property for her e?

I was staring at this yesterday and finally I forgot to remove it. It is
undocumented and I think it's not supposed to be here. Guennadi, would
you have any comments on that ?

>> +			};
>> +		};
>> +	};
>> +
>> +	i2c0: i2c@0xfff20000 {
>> +		...
>> +		ov772x_1: camera@0x21 {
>> +			compatible = "omnivision,ov772x";
>> +			reg = <0x21>;
>> +			vddio-supply = <&regulator1>;
>> +			vddcore-supply = <&regulator2>;
>> +
>> +			clock-frequency = <20000000>;
>> +			clocks = <&mclk 0>;
>> +			clock-names = "xclk";
>> +
>> +			port {
>> +				/* With 1 endpoint per port no need in addresses. */
> 
> s/in/for/ ?

I proposed same change to Guennadi, but he argued that "in" is also
commonly used. I agreed even though 'for' seemed more natural to me.
I would change it, unless there is a strong opposition. :)

--

Regards,
Sylwester

