Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF36DC282D8
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 19:41:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A686218AE
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 19:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548877260;
	bh=C482ThCpoJRymZ0ui9yx/2Twc1fp7mxm5mKVSbzjIxA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=UQeQuTUZ0EcxIaZC1C8KcXIeH0g1nOWS2UMp0mog32v+dUYCXZXBDu1YFvOMzYLGI
	 xyDuMWYXk4U/VRmehtFnY8Zp30YGl+6n+FLEasUx/ubpF2I7a2mzKqjbqI4xjcJQpg
	 YUyg3O51Mh09MLGT5mBt8I14xAjTXph/eKicVgSM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387738AbfA3Tkz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 14:40:55 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:39975 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387587AbfA3Tky (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 14:40:54 -0500
Received: by mail-ot1-f68.google.com with SMTP id s5so669485oth.7;
        Wed, 30 Jan 2019 11:40:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Pzed3W/0Z0OCxQkoAsbcMNZwHTcCFLmcZxWxeac8a/I=;
        b=EK+/v+wZEu8Frqnd+OgwSjEeCeZa4rkE2is3zFEc96oMjliIb6yJZCVUxHS0ExwR7F
         TpspsV5TTL70Ogi2RPLg2DCVWo0Qke8C6nCU1NpcxAkVQ9ObJCh5pl9pmGJ+vcjAUn5M
         8jpIC2zH3n6OvrBLbJiOSMPeagtXrqRm94kGdifL9vjXwhXNJxoERgHvncV+zE620LIF
         k1Dap4as/qq2LKXdtJmdwa/lmi5q37qJoaJBS4Mz4Ll06/Mo4aUl8cqzowYnSq14OHWn
         hXYUYmnd8pX7XDX75325ydUk2pXhBn/dmdcO13YkOPGjmcNKg9CL2W+WBQiEY80o4vXc
         DFjg==
X-Gm-Message-State: AJcUukeMSuoz6IK6Xo5gkaLNAMDrZx9Ts0W/DBTivuUN3wCKUbnBZ5m4
        CkgTTt68JMli6sdkigis3A==
X-Google-Smtp-Source: ALg8bN6IkUHTJZug2xNP1ip8Z2xgvxBQnDeycRl0IzbdTdfJ7fpiSOukORCC1SijvRRIKCqcmma7ow==
X-Received: by 2002:a9d:2f64:: with SMTP id h91mr23653203otb.14.1548877253388;
        Wed, 30 Jan 2019 11:40:53 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id m131sm1055633oia.6.2019.01.30.11.40.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 30 Jan 2019 11:40:52 -0800 (PST)
Date:   Wed, 30 Jan 2019 13:40:52 -0600
From:   Rob Herring <robh@kernel.org>
To:     Vishal Sagar <vishal.sagar@xilinx.com>
Cc:     hyun.kwon@xilinx.com, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, mark.rutland@arm.com, michal.simek@xilinx.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dineshk@xilinx.com, sandipk@xilinx.com
Subject: Re: [PATCH v2 1/2] media: dt-bindings: media: xilinx: Add Xilinx
 MIPI CSI-2 Rx Subsystem
Message-ID: <20190130194052.GA9543@bogus>
References: <1548438777-11203-1-git-send-email-vishal.sagar@xilinx.com>
 <1548438777-11203-2-git-send-email-vishal.sagar@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548438777-11203-2-git-send-email-vishal.sagar@xilinx.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Jan 25, 2019 at 11:22:56PM +0530, Vishal Sagar wrote:
> Add bindings documentation for Xilinx MIPI CSI-2 Rx Subsystem.
> 
> The Xilinx MIPI CSI-2 Rx Subsystem consists of a CSI-2 Rx controller, a
> DPHY in Rx mode, an optional I2C controller and a Video Format Bridge.
> 
> Signed-off-by: Vishal Sagar <vishal.sagar@xilinx.com>
> ---
> v2
> - updated the compatible string to latest version supported
> - removed DPHY related parameters
> - added CSI v2.0 related property (including VCX for supporting upto 16
>   virtual channels).
> - modified csi-pxl-format from string to unsigned int type where the value
>   is as per the CSI specification
> - Defined port 0 and port 1 as sink and source ports.
> - Removed max-lanes property as suggested by Rob and Sakari
> 
>  .../bindings/media/xilinx/xlnx,csi2rxss.txt        | 105 +++++++++++++++++++++
>  1 file changed, 105 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt b/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
> new file mode 100644
> index 0000000..98781cf
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
> @@ -0,0 +1,105 @@
> +Xilinx MIPI CSI2 Receiver Subsystem Device Tree Bindings
> +--------------------------------------------------------
> +
> +The Xilinx MIPI CSI2 Receiver Subsystem is used to capture MIPI CSI2 traffic
> +from compliant camera sensors and send the output as AXI4 Stream video data
> +for image processing.
> +
> +The subsystem consists of a MIPI DPHY in slave mode which captures the
> +data packets. This is passed along the MIPI CSI2 Rx IP which extracts the
> +packet data. The Video Format Bridge (VFB) converts this data to AXI4 Stream
> +video data.
> +
> +For more details, please refer to PG232 Xilinx MIPI CSI-2 Receiver Subsystem.
> +
> +Required properties:
> +--------------------
> +- compatible: Must contain "xlnx,mipi-csi2-rx-subsystem-4.0".
> +- reg: Physical base address and length of the registers set for the device.
> +- interrupt-parent: specifies the phandle to the parent interrupt controller

Don't document this. It is implied.

> +- interrupts: Property with a value describing the interrupt number.
> +- clocks: List of phandles to AXI Lite, Video and 200 MHz DPHY clocks.
> +- clock-names: Must contain "lite_aclk", "video_aclk" and "dphy_clk_200M" in
> +  the same order as clocks listed in clocks property.
> +- xlnx,csi-pxl-format: This denotes the CSI Data type selected in hw design.
> +  Packets other than this data type (except for RAW8 and User defined data
> +  types) will be filtered out. Possible values are as below -
> +  0x1E - YUV4228B
> +  0x1F - YUV42210B
> +  0x20 - RGB444
> +  0x21 - RGB555
> +  0x22 - RGB565
> +  0x23 - RGB666
> +  0x24 - RGB888
> +  0x28 - RAW6
> +  0x29 - RAW7
> +  0x2A - RAW8
> +  0x2B - RAW10
> +  0x2C - RAW12
> +  0x2D - RAW14
> +  0x2E - RAW16
> +  0x2F - RAW20
> +- xlnx,vfb: This is present when Video Format Bridge is enabled.

boolean?

> +
> +Optional properties:
> +--------------------
> +- xlnx,en-csi-v2-0: Present if CSI v2 is enabled in IP configuration.
> +- xlnx,en-vcx: When present, there are maximum 16 virtual channels, else
> +  only 4. This is present only if xlnx,en-csi-v2-0 is present.
> +- xlnx,en-active-lanes: Enable Active lanes configuration in Protocol
> +  Configuration Register.
> +- xlnx,cfa-pattern: This goes in the sink port to indicate bayer pattern.
> +  Valid values are "bggr", "rggb", "gbrg" and "grbg".

This should go in the endpoint with the other properties. I'd also move 
it down below 'Ports' to be clear it goes in a different node.

> +
> +Ports
> +-----
> +The device node shall contain two 'port' child nodes as defined in
> +Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +The port@0 is sink port and shall connect to CSI2 source like camera.
> +It must have the data-lanes property. It may have the xlnx,cfa-pattern
> +property to indicate bayer pattern of source.
> +
> +The port@1 is source port could be connected to any video processing IP
> +which can work with AXI4 Stream data.
> +
> +Both ports must have remote-endpoints.

No need to state that. That's implicit for the graph to work...
> +
> +Example:
> +
> +	csiss_1: csiss@a0020000 {
> +		compatible = "xlnx,mipi-csi2-rx-subsystem-4.0";
> +		reg = <0x0 0xa0020000 0x0 0x10000>;
> +		interrupt-parent = <&gic>;
> +		interrupts = <0 95 4>;
> +		xlnx,csi-pxl-format = <0x2a>;
> +		xlnx,vfb;
> +		xlnx,en-active-lanes;
> +		xlnx,en-csi-v2-0;
> +		xlnx,en-vcx;
> +		clock-names = "lite_aclk", "dphy_clk_200M", "video_aclk";
> +		clocks = <&misc_clk_0>, <&misc_clk_1>, <&misc_clk_2>;
> +
> +		ports {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +
> +			port@0 {
> +				/* Sink port */
> +				reg = <0>;
> +				xlnx,cfa-pattern = "bggr"
> +				csiss_in: endpoint {
> +					data-lanes = <1 2 3 4>;
> +					/* MIPI CSI2 Camera handle */
> +					remote-endpoint = <&camera_out>;
> +				};
> +			};
> +			port@1 {
> +				/* Source port */
> +				reg = <1>;
> +				csiss_out: endpoint {
> +					remote-endpoint = <&vproc_in>;
> +				};
> +			};
> +		};
> +	};
> -- 
> 2.7.4
> 
