Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:45758 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732441AbeITV24 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 17:28:56 -0400
Subject: Re: [V2, 4/5] Documentation: dt-bindings: Document bindings for DW
 MIPI CSI-2 Host
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Luis Oliveira <Luis.Oliveira@synopsys.com>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Joao.Pinto@synopsys.com>, <festevam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Todor Tomov <todor.tomov@linaro.org>,
        <devicetree@vger.kernel.org>
References: <20180920111648.27000-1-lolivei@synopsys.com>
 <20180920111648.27000-5-lolivei@synopsys.com> <1932462.yjy0pN2BsW@avalon>
From: Luis Oliveira <Luis.Oliveira@synopsys.com>
Message-ID: <c9dc5a21-ca7c-63f0-4833-308a78e243d0@synopsys.com>
Date: Thu, 20 Sep 2018 16:44:45 +0100
MIME-Version: 1.0
In-Reply-To: <1932462.yjy0pN2BsW@avalon>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20-Sep-18 14:24, Laurent Pinchart wrote:
> Hi Luis,
> 
> Thank you for the patch.
> 

Hi Laurent, thank you for your review.
My answers inline.

> On Thursday, 20 September 2018 14:16:42 EEST Luis Oliveira wrote:
>> Add bindings for Synopsys DesignWare MIPI CSI-2 host.
>>
>> Signed-off-by: Luis Oliveira <lolivei@synopsys.com>
>> ---
>> Changelog
>> v2:
>> - no changes
>>
>>  .../devicetree/bindings/media/snps,dw-csi-plat.txt | 74 +++++++++++++++++++
>>  1 file changed, 74 insertions(+)
>>  create mode 100644
>> Documentation/devicetree/bindings/media/snps,dw-csi-plat.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/snps,dw-csi-plat.txt
>> b/Documentation/devicetree/bindings/media/snps,dw-csi-plat.txt new file
>> mode 100644
>> index 0000000..028f5eb
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/snps,dw-csi-plat.txt
>> @@ -0,0 +1,74 @@
>> +Synopsys DesignWare CSI-2 Host controller
>> +
>> +Description
>> +-----------
>> +
>> +This HW block is used to receive image coming from an MIPI CSI-2 compatible
>> +camera.
>> +
>> +Required properties:
>> +- compatible: shall be "snps,dw-csi-plat"
>> +- reg			: physical base address and size of the device memory mapped
>> +  registers;
>> +- interrupts		: CSI-2 Host interrupt
>> +- snps,output-type	: Core output to be used (IPI-> 0 or IDI->1 or BOTH-
>> 2)
>> These
>> +			  values choose which of the Core outputs will be used, it
>> +			  can be Image Data Interface or Image Pixel Interface.
>> +- phys			: List of one PHY specifier (as defined in
>> +			  Documentation/devicetree/bindings/phy/phy-bindings.txt).
>> +			  This PHY is a MIPI DPHY working in RX mode.
>> +- resets		: Reference to a reset controller (optional)
>> +
>> +Optional properties(if in IPI mode):
>> +- snps,ipi-mode 	: Mode to be used when in IPI(Camera -> 0 or Controller -
>>
>> 1)
>> +			  This property defines if the controller will use the video
>> +			  timings available
>> +			  in the video stream or if it will use pre-defined ones.
> 
> How does one select this ?
> 

This is a hardware setting for timings in IPI (Image Pixel Interface - Synopsys
specific interface), default is Controller mode - 1.

This can be selected in the DT or after by the driver.

>> +- snps,ipi-color-mode	: Bus depth to be used in IPI (48 bits -> 0 or 16
>> bits -> 1)
>> +			  This property defines the width of the IPI bus.
> 
> How about using the standard bus-width property in the endpoint of the output 
> port ?
> 

Here I think It makes sense, I will use your suggestion.

>> +- snps,ipi-auto-flush	: Data auto-flush (1 -> Yes or 0 -> No). This
>> property defines
>> +			  if the data is automatically flushed in each vsync
>> or if
>> +			  this process is done manually
> 
> This seems like a configuration option, not a hardware property. I don't think 
> it belongs to DT.
> 
I see your point,

>> +- snps,virtual-channel	: Virtual channel where data is present when in IPI
>> mode. This
>> +			  property chooses the virtual channel which IPI will use to
>> +			  retrieve the video stream.
> 
> The virtual channel doesn't belong to DT, it should be queried from the sensor 
> at runtime (and when a sensor can send multiple data streams, that should even 
> be configurable).
> 

I will do that.

I made this properties for my tests with cameras, thinking of SoCs that have
fixed HW configurations. But I can remove all this fields from the DT because
all of them can be made after in the driver.

>> +The per-board settings:
>> + - port sub-node describing a single endpoint connected to the camera as
>> +   described in video-interfaces.txt[1].
> 
> You need to explicitly list all the ports for this device, with their number 
> and function.
> 

Ok.

>> +Example:
>> +
>> +	csi2_1: csi2@3000 {
>> +		compatible = "snps,dw-csi-plat";
>> +		#address-cells = <1>;
>> +		#size-cells = <0>;
>> +		reg = < 0x03000 0x7FF>;
>> +		interrupts = <2>;
>> +		output-type = <2>;
>> +		resets = <&dw_rst 1>;
>> +		phys = <&mipi_dphy_rx1 0>;
>> +		phy-names = "csi2-dphy";
>> +
>> +		/* IPI optional Configurations */
>> +		snps,ipi-mode = <0>;
>> +		snps,ipi-color-mode = <0>;
>> +		snps,ipi-auto-flush = <1>;
>> +		snps,virtual-channel = <0>;
>> +
>> +		/* CSI-2 per-board settings */
>> +		port@1 {
>> +			reg = <1>;
>> +			csi1_ep1: endpoint {
>> +				remote-endpoint = <&camera_1>;
>> +				data-lanes = <1 2>;
>> +			};
>> +		};
>> +		port@2 {
>> +			csi1_ep2: endpoint {
>> +				remote-endpoint = <&vif1_ep>;
>> +			};
>> +		};
>> +	};
>> +
>> +
> 
> Extra blank lines.

Thanks.
> 
