Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.47.9]:33014 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752399AbcKNPbf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 10:31:35 -0500
Subject: Re: [PATCH 1/2] Add Documentation for Media Device, Video Device, and
 Synopsys DW MIPI CSI-2 Host
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
References: <cover.1479132355.git.roliveir@synopsys.com>
 <160acd0770e0685330ba8e7445423c1d6f34658e.1479132355.git.roliveir@synopsys.com>
 <9132828.vOiOHSy7z0@avalon>
CC: <robh+dt@kernel.org>, <mark.rutland@arm.com>, <mchehab@kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <davem@davemloft.net>,
        <gregkh@linuxfoundation.org>, <geert+renesas@glider.be>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <hverkuil@xs4all.nl>, <laurent.pinchart+renesas@ideasonboard.com>,
        <arnd@arndb.de>, <sudipm.mukherjee@gmail.com>,
        <tiffany.lin@mediatek.com>, <minghsiu.tsai@mediatek.com>,
        <jean-christophe.trotin@st.com>, <andrew-ct.chen@mediatek.com>,
        <simon.horman@netronome.com>, <songjun.wu@microchip.com>,
        <bparrot@ti.com>, <CARLOS.PALMINHA@synopsys.com>
From: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Message-ID: <8f28e551-eb97-0e1f-6902-cdae13a8ed96@synopsys.com>
Date: Mon, 14 Nov 2016 15:31:21 +0000
MIME-Version: 1.0
In-Reply-To: <9132828.vOiOHSy7z0@avalon>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the feedback.

On 11/14/2016 2:49 PM, Laurent Pinchart wrote:
> Hi Ramiro,
> 
> Thank you for the patch.
> 
> On Monday 14 Nov 2016 14:20:22 Ramiro Oliveira wrote:
>> Add documentation for Media and Video Device, as well as the DW MIPI CSI-2
>> Host.
>>
>> Signed-off-by: Ramiro Oliveira <roliveir@synopsys.com>
>> ---
>>  .../devicetree/bindings/media/snps,dw-mipi-csi.txt | 27 +++++++++++++++++++
>>  .../devicetree/bindings/media/snps,plat-ipk.txt    |  9 ++++++++
>>  .../bindings/media/snps,video-device.txt           | 12 ++++++++++
>>  3 files changed, 48 insertions(+)
>>  create mode 100644
>> Documentation/devicetree/bindings/media/snps,dw-mipi-csi.txt create mode
>> 100644 Documentation/devicetree/bindings/media/snps,plat-ipk.txt create
>> mode 100644 Documentation/devicetree/bindings/media/snps,video-device.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/snps,dw-mipi-csi.txt
>> b/Documentation/devicetree/bindings/media/snps,dw-mipi-csi.txt new file
>> mode 100644
>> index 0000000..bec7441
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/snps,dw-mipi-csi.txt
>> @@ -0,0 +1,27 @@
>> +Synopsys DesignWare CSI-2 Host controller
>> +
>> +Description
>> +-----------
>> +
>> +This HW block is used to receive image coming from an MIPI CSI-2 compatible
>> +camera.
> 
> And what does it do after receiving the stream ? A more detailed description 
> would be useful. Is there any public documentation for this IP core ?
> 

I can add a more detailed description. Also, here is a link to the
documentation, but I'm afraid you might have to register yourself to access it.

CSI-2 Host
https://www.synopsys.com/dw/doc.php/ds/c/dwc_csi2_controller.pdf

CSI-2 Host IPK
https://www.synopsys.com/dw/doc.php/ds/o/ip_prototyping_kit_mipi_csi2_host_arc.pdf

>> +Required properties:
>> +- compatible: shall be "snps,dw-mipi-csi"
>> +- reg		: physical base address and size of the device memory 
> mapped
>> +		  registers;
>> +- interrupts	: CSI-2 Host interrupt
>> +- data-lanes    : Number of lanes to be used
> 
> Is that fixed at synthesis time or configurable at runtime ?
> 

The max number is fixed at synthesis time, but you can configure it for lower
values. I added this option here because, although configurable, it's usually a
fixed value.

>> +- output-type   : Core output to be used (IPI-> 0 or IDI->1 or BOTH->2)
> 
> What are IPI and IDI ?
> 

IPI is Image Pixel Interface and IDI Image Data Interface, these are the two
types of data output support by our CSI-2 Host controller

>> +- phys, phy-names: List of one PHY specifier and identifier string (as
>> defined
>> +  in Documentation/devicetree/bindings/phy/phy-bindings.txt).
> 
> A PHY for what ?
> 

Our controller needs a PHY, in this case a MIPI DPHY, to interact with a CSI-2
receiver (usually a sensor).

>> +Optional properties(if in IPI mode):
>> +- ipi-mode 	: Mode to be used when in IPI(Camera -> 0 or Automatic -> 1)
>> +- ipi-color-mode: Color depth to be used in IPI (48 bits -> 0 or 16 bits ->
>> 1)
>> +- ipi-auto-flush: Data auto-flush (1 -> Yes or 0 -> No)
>> +- virtual-channel: Virtual channel where data is present when in IPI
> 
> We need more details than that, this is impossible to review, sorry.
> 

Sure, I'll add more details to the descripton

>> +The per-board settings:
>> + - port sub-node describing a single endpoint connected to the dw-mipi-csi
>> +   as described in video-interfaces.txt[1].
> 
> An example would be nice.
> 

I'll add an example of how we're using it.

>> diff --git a/Documentation/devicetree/bindings/media/snps,plat-ipk.txt
>> b/Documentation/devicetree/bindings/media/snps,plat-ipk.txt new file mode
>> 100644
>> index 0000000..2d51541
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/snps,plat-ipk.txt
>> @@ -0,0 +1,9 @@
>> +Synopsys DesignWare CSI-2 Host IPK Media Device
>> +
>> +This Media Device at the moment is not totally functional, however it is a
>> base
>> +for the future.
> 
> Then let's add it later :-) We don't want to design incomplete transient DT 
> bindings.
> 

I'm afraid I wasn't completely clear. This setup is fully functional. Actually
this sentence made sense in the past, but no longer does now.

>> +Required properties:
>> +
>> +- compatible: Must be "snps,plat-ipk".
>> +
>> diff --git a/Documentation/devicetree/bindings/media/snps,video-device.txt
>> b/Documentation/devicetree/bindings/media/snps,video-device.txt new file
>> mode 100644
>> index 0000000..d467092
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/snps,video-device.txt
>> @@ -0,0 +1,12 @@
>> +Synopsys DesignWare CSI-2 Host video device
>> +
>> +This driver handles all the video handling part of this platform.
> 
> This is a DT binding documentation, drivers are irrelevant. You should 
> describe the hardware only.
> 
> More information is needed, based on this document I can't tell what the 
> "CSI-2 host video device" is.
> 

You're right, I'll add a more detailed description.

>> +Required properties:
>> +
>> +- compatible: Must be "snps,video-device".
>> +
>> +- dmas, dma-names: List of one DMA specifier and identifier string (as
>> defined
>> +  in Documentation/devicetree/bindings/dma/dma.txt) per port. Each port
>> +  requires a DMA channel with the identifier string set to "port" followed
>> by
>> +  the port index.
> 

Thanks once again,
Ramiro Oliveira
