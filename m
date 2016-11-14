Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36580 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751662AbcKNOtk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 09:49:40 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, geert+renesas@glider.be,
        akpm@linux-foundation.org, linux@roeck-us.net, hverkuil@xs4all.nl,
        laurent.pinchart+renesas@ideasonboard.com, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, tiffany.lin@mediatek.com,
        minghsiu.tsai@mediatek.com, jean-christophe.trotin@st.com,
        andrew-ct.chen@mediatek.com, simon.horman@netronome.com,
        songjun.wu@microchip.com, bparrot@ti.com,
        CARLOS.PALMINHA@synopsys.com
Subject: Re: [PATCH 1/2] Add Documentation for Media Device, Video Device, and Synopsys DW MIPI CSI-2 Host
Date: Mon, 14 Nov 2016 16:49:45 +0200
Message-ID: <9132828.vOiOHSy7z0@avalon>
In-Reply-To: <160acd0770e0685330ba8e7445423c1d6f34658e.1479132355.git.roliveir@synopsys.com>
References: <cover.1479132355.git.roliveir@synopsys.com> <160acd0770e0685330ba8e7445423c1d6f34658e.1479132355.git.roliveir@synopsys.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ramiro,

Thank you for the patch.

On Monday 14 Nov 2016 14:20:22 Ramiro Oliveira wrote:
> Add documentation for Media and Video Device, as well as the DW MIPI CSI-2
> Host.
> 
> Signed-off-by: Ramiro Oliveira <roliveir@synopsys.com>
> ---
>  .../devicetree/bindings/media/snps,dw-mipi-csi.txt | 27 +++++++++++++++++++
>  .../devicetree/bindings/media/snps,plat-ipk.txt    |  9 ++++++++
>  .../bindings/media/snps,video-device.txt           | 12 ++++++++++
>  3 files changed, 48 insertions(+)
>  create mode 100644
> Documentation/devicetree/bindings/media/snps,dw-mipi-csi.txt create mode
> 100644 Documentation/devicetree/bindings/media/snps,plat-ipk.txt create
> mode 100644 Documentation/devicetree/bindings/media/snps,video-device.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/snps,dw-mipi-csi.txt
> b/Documentation/devicetree/bindings/media/snps,dw-mipi-csi.txt new file
> mode 100644
> index 0000000..bec7441
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/snps,dw-mipi-csi.txt
> @@ -0,0 +1,27 @@
> +Synopsys DesignWare CSI-2 Host controller
> +
> +Description
> +-----------
> +
> +This HW block is used to receive image coming from an MIPI CSI-2 compatible
> +camera.

And what does it do after receiving the stream ? A more detailed description 
would be useful. Is there any public documentation for this IP core ?

> +Required properties:
> +- compatible: shall be "snps,dw-mipi-csi"
> +- reg		: physical base address and size of the device memory 
mapped
> +		  registers;
> +- interrupts	: CSI-2 Host interrupt
> +- data-lanes    : Number of lanes to be used

Is that fixed at synthesis time or configurable at runtime ?

> +- output-type   : Core output to be used (IPI-> 0 or IDI->1 or BOTH->2)

What are IPI and IDI ?

> +- phys, phy-names: List of one PHY specifier and identifier string (as
> defined
> +  in Documentation/devicetree/bindings/phy/phy-bindings.txt).

A PHY for what ?

> +Optional properties(if in IPI mode):
> +- ipi-mode 	: Mode to be used when in IPI(Camera -> 0 or Automatic -> 1)
> +- ipi-color-mode: Color depth to be used in IPI (48 bits -> 0 or 16 bits ->
> 1)
> +- ipi-auto-flush: Data auto-flush (1 -> Yes or 0 -> No)
> +- virtual-channel: Virtual channel where data is present when in IPI

We need more details than that, this is impossible to review, sorry.

> +The per-board settings:
> + - port sub-node describing a single endpoint connected to the dw-mipi-csi
> +   as described in video-interfaces.txt[1].

An example would be nice.

> diff --git a/Documentation/devicetree/bindings/media/snps,plat-ipk.txt
> b/Documentation/devicetree/bindings/media/snps,plat-ipk.txt new file mode
> 100644
> index 0000000..2d51541
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/snps,plat-ipk.txt
> @@ -0,0 +1,9 @@
> +Synopsys DesignWare CSI-2 Host IPK Media Device
> +
> +This Media Device at the moment is not totally functional, however it is a
> base
> +for the future.

Then let's add it later :-) We don't want to design incomplete transient DT 
bindings.

> +Required properties:
> +
> +- compatible: Must be "snps,plat-ipk".
> +
> diff --git a/Documentation/devicetree/bindings/media/snps,video-device.txt
> b/Documentation/devicetree/bindings/media/snps,video-device.txt new file
> mode 100644
> index 0000000..d467092
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/snps,video-device.txt
> @@ -0,0 +1,12 @@
> +Synopsys DesignWare CSI-2 Host video device
> +
> +This driver handles all the video handling part of this platform.

This is a DT binding documentation, drivers are irrelevant. You should 
describe the hardware only.

More information is needed, based on this document I can't tell what the 
"CSI-2 host video device" is.

> +Required properties:
> +
> +- compatible: Must be "snps,video-device".
> +
> +- dmas, dma-names: List of one DMA specifier and identifier string (as
> defined
> +  in Documentation/devicetree/bindings/dma/dma.txt) per port. Each port
> +  requires a DMA channel with the identifier string set to "port" followed
> by
> +  the port index.

-- 
Regards,

Laurent Pinchart

