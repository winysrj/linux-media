Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D40EC43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 13:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD7FD2087E
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 13:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbfAHNFD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 08:05:03 -0500
Received: from mga07.intel.com ([134.134.136.100]:31757 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727473AbfAHNFC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Jan 2019 08:05:02 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2019 05:05:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,454,1539673200"; 
   d="scan'208";a="132646411"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga002.fm.intel.com with ESMTP; 08 Jan 2019 05:04:58 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id C377F20948; Tue,  8 Jan 2019 15:04:57 +0200 (EET)
Date:   Tue, 8 Jan 2019 15:04:57 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Vishal Sagar <vishal.sagar@xilinx.com>
Cc:     hyun.kwon@xilinx.com, laurent.pinchart@ideasonboard.com,
        michal.simek@xilinx.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, hans.verkuil@cisco.com,
        mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        dineshk@xilinx.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] media: dt-bindings: media: xilinx: Add Xilinx MIPI
 CSI-2 Rx Subsystem
Message-ID: <20190108130457.syjuq7u7vep3km3h@paasikivi.fi.intel.com>
References: <1527620084-94864-1-git-send-email-vishal.sagar@xilinx.com>
 <1527620084-94864-2-git-send-email-vishal.sagar@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1527620084-94864-2-git-send-email-vishal.sagar@xilinx.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Vishal,

The patchset hard escaped me somehow earlier and your reply to Rob made me
notice it again. Thanks. :-)

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

Extra newline.

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
> +
> +- xlnx,vc: Virtual Channel, specifies virtual channel number to be filtered.
> +  If this is 4 then all virtual channels are allowed.

This seems like something a driver should configure, based on the
configuration of the connected device.

> +
> +- xlnx,csi-pxl-format: This denotes the CSI Data type selected in hw design.
> +  Packets other than this data type (except for RAW8 and User defined data
> +  types) will be filtered out. Possible values are RAW6, RAW7, RAW8, RAW10,
> +  RAW12, RAW14, RGB444, RGB555, RGB565, RGB666, RGB888 and YUV4228bit.

This should be configured at runtime instead through V4L2 sub-device
interface; it's not a property of the hardware.

> +
> +- xlnx,axis-tdata-width: AXI Stream width, This denotes the AXI Stream width.
> +  It depends on Data type chosen, Video Format Bridge enabled/disabled and
> +  pixels per clock. If VFB is disabled then its value is either 0x20 (32 bit)
> +  or 0x40(64 bit) width.
> +
> +- xlnx,video-format, xlnx,video-width: Video format and width, as defined in
> +  video.txt.

Ditto.

> +
> +- port: Video port, using the DT bindings defined in ../video-interfaces.txt.
> +  The CSI 2 Rx Subsystem has a two ports, one input port for connecting to
> +  camera sensor and other is output port.
> +
> +- data-lanes: The number of data lanes through which CSI2 Rx Subsystem is
> +  connected to the camera sensor as per video-interfaces.txt

This is somewhat different from the documentation in video-interfaces.txt.
Could you align the two? I don't think there's a need to document standard
properties in device binding files elaborately; rather just the hardware
specific bits.

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

Could you drop this from v2?

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
