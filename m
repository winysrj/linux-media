Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:44770 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933226AbeFLUDm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 16:03:42 -0400
Date: Tue, 12 Jun 2018 14:03:38 -0600
From: Rob Herring <robh@kernel.org>
To: Vishal Sagar <vishal.sagar@xilinx.com>
Cc: hyun.kwon@xilinx.com, laurent.pinchart@ideasonboard.com,
        michal.simek@xilinx.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, mark.rutland@arm.com,
        mchehab@kernel.org, linux-kernel@vger.kernel.org,
        hans.verkuil@cisco.com, sakari.ailus@linux.intel.com,
        dineshk@xilinx.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] media: dt-bindings: media: xilinx: Add Xilinx MIPI
 CSI-2 Rx Subsystem
Message-ID: <20180612200338.GA31620@rob-hp-laptop>
References: <1527620084-94864-1-git-send-email-vishal.sagar@xilinx.com>
 <1527620084-94864-2-git-send-email-vishal.sagar@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1527620084-94864-2-git-send-email-vishal.sagar@xilinx.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 30, 2018 at 12:24:43AM +0530, Vishal Sagar wrote:
> Add bindings documentation for Xilinx MIPI CSI-2 Rx Subsystem.
> 
> The Xilinx MIPI CSI-2 Rx Subsystem consists of a DPHY, CSI-2 Rx, an
> optional I2C controller and an optional Video Format Bridge (VFB). The
> active lanes can be configured at run time if enabled in the IP. The
> DPHY register interface may also be enabled.
>
> Signed-off-by: Vishal Sagar <vishal.sagar@xilinx.com>
> ---
>  .../bindings/media/xilinx/xlnx,csi2rxss.txt        | 117 +++++++++++++++++++++
>  1 file changed, 117 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt b/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
> new file mode 100644
> index 0000000..31ed721
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
> @@ -0,0 +1,117 @@
> +
> +Xilinx MIPI CSI2 Receiver Subsystem Device Tree Bindings
> +--------------------------------------------------------
> +
> +The Xilinx MIPI CSI2 Receiver Subsystem is used to capture MIPI CSI2 traffic
> +from compliant camera sensors and send the output as AXI4 Stream video data
> +for image processing.
> +
> +The subsystem consists of a MIPI DPHY in slave mode which captures the
> +data packets. This is passed along the MIPI CSI2 Rx IP which extracts the
> +packet data. This data is taken in by the Video Format Bridge (VFB),
> +if selected, and converted into AXI4 Stream video data at selected
> +pixels per clock as per AXI4-Stream Video IP and System Design UG934.
> +
> +For more details, please refer to PG232 MIPI CSI-2 Receiver Subsystem.
> +https://www.xilinx.com/support/documentation/ip_documentation/mipi_csi2_rx_subsystem/v3_0/pg232-mipi-csi2-rx.pdf
> +
> +Required properties:
> +
> +- compatible: Must contain "xlnx,mipi-csi2-rx-subsystem-2.0" or
> +  "xlnx,mipi-csi2-rx-subsystem-3.0"
> +
> +- reg: Physical base address and length of the registers set for the device.
> +
> +- interrupt-parent: specifies the phandle to the parent interrupt controller
> +
> +- interrupts: Property with a value describing the interrupt number.
> +
> +- xlnx,max-lanes: Maximum active lanes in the design.

There's already a property defined in video-interfaces.txt to limit 
lanes.

> +
> +- xlnx,vc: Virtual Channel, specifies virtual channel number to be filtered.
> +  If this is 4 then all virtual channels are allowed.
> +
> +- xlnx,csi-pxl-format: This denotes the CSI Data type selected in hw design.
> +  Packets other than this data type (except for RAW8 and User defined data
> +  types) will be filtered out. Possible values are RAW6, RAW7, RAW8, RAW10,
> +  RAW12, RAW14, RGB444, RGB555, RGB565, RGB666, RGB888 and YUV4228bit.

This should be standard property. 

> +
> +- xlnx,axis-tdata-width: AXI Stream width, This denotes the AXI Stream width.
> +  It depends on Data type chosen, Video Format Bridge enabled/disabled and
> +  pixels per clock. If VFB is disabled then its value is either 0x20 (32 bit)
> +  or 0x40(64 bit) width.
> +
> +- xlnx,video-format, xlnx,video-width: Video format and width, as defined in
> +  video.txt.

This doc needs to define what are valid values.

Why do you need this on both ports? Can there be a conversion in this 
block? At least for the MIPI CSI interface part, this should be a common 
property. Not sure offhand if we have defined one. We have for parallel 
interfaces.

And 'width' doesn't seem like the right term for what this is defined to 
be.

> +
> +- port: Video port, using the DT bindings defined in ../video-interfaces.txt.

port is not a property. It goes in its own section. And port properties 
should be under it.

> +  The CSI 2 Rx Subsystem has a two ports, one input port for connecting to
> +  camera sensor and other is output port.

Need be specific port #0 is ?? and port #1 is ??.

> +
> +- data-lanes: The number of data lanes through which CSI2 Rx Subsystem is
> +  connected to the camera sensor as per video-interfaces.txt

Why do you need both this and max-lanes?

> +
> +Optional properties:
> +
> +- xlnx,en-active-lanes: Enable Active lanes configuration in Protocol
> +  Configuration Register.
> +
> +- xlnx,dphy-present: This is equivalent to whether DPHY register interface is
> +  enabled or not.
> +
> +- xlnx,iic-present: This shows whether subsystem's IIC is present or not. This
> +  affects the base address of the DPHY.

Perhaps you should break up reg into ranges for each submodule (or make 
the DPHY a separate node and use the phy binding.

> +
> +- xlnx,vfb: Video Format Bridge, Denotes if Video Format Bridge is selected
> +  so that output is as per AXI stream documented in UG934.
> +
> +- xlnx,ppc: Pixels per clock, Number of pixels to be transferred per pixel
> +  clock. This is valid only if xlnx,vfb property is present.
> +
> +Example:
> +
> +       csiss_1: csiss@a0020000 {
> +               compatible = "xlnx,mipi-csi2-rx-subsystem-3.0";
> +               reg = <0x0 0xa0020000 0x0 0x20000>;
> +               interrupt-parent = <&gic>;
> +               interrupts = <0 95 4>;
> +
> +               xlnx,max-lanes = <0x4>;
> +               xlnx,en-active-lanes;
> +               xlnx,dphy-present;
> +               xlnx,iic-present;
> +               xlnx,vc = <0x4>;
> +               xlnx,csi-pxl-format = "RAW8";
> +               xlnx,vfb;
> +               xlnx,ppc = <0x4>;
> +               xlnx,axis-tdata-width = <0x20>;
> +
> +               ports {
> +                       #address-cells = <1>;
> +                       #size-cells = <0>;
> +
> +                       port@0 {
> +                               reg = <0>;
> +
> +                               xlnx,video-format = <XVIP_VF_YUV_422>;
> +                               xlnx,video-width = <8>;
> +                               csiss_out: endpoint {
> +                                       remote-endpoint = <&vcap_csiss_in>;
> +                               };
> +                       };
> +                       port@1 {
> +                               reg = <1>;
> +
> +                               xlnx,video-format = <XVIP_VF_YUV_422>;
> +                               xlnx,video-width = <8>;
> +
> +                               csiss_in: endpoint {
> +                                       data-lanes = <1 2 3 4>;
> +                                       /* MIPI CSI2 Camera handle */
> +                                       remote-endpoint = <&vs2016_out>;
> +                               };
> +
> +                       };
> +
> +               };
> +       };
> --
> 2.7.4
> 
> This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
