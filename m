Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAD50C169C4
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 10:42:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9A1721479
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 10:42:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=lucaceresoli.net header.i=@lucaceresoli.net header.b="Zn2n4NQN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfBKKmM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 05:42:12 -0500
Received: from hostingweb31-40.netsons.net ([89.40.174.40]:50339 "EHLO
        hostingweb31-40.netsons.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726866AbfBKKmM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 05:42:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=lucaceresoli.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:References:To:Subject:From:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ljwG33noKakhS1ZfZKdZs6BmGxQjhcvZfkTjn3MmOQA=; b=Zn2n4NQNSSFyWlBpUy7CHlywcc
        hAsV6r23b8h8EPdSYxOPBejIgzViZsObqgoLlv9NuXJkQr+YurSXuexURbUTW3zAUDtWsZhZmLvDL
        JKXmDGjhFNHuIpw/tPqNtjqH2niRFtGf99Gr4vABj21A/MbdDVMVbKfevGFYoR0jTHlM=;
Received: from [109.168.11.45] (port=59806 helo=[192.168.101.224])
        by hostingweb31.netsons.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@lucaceresoli.net>)
        id 1gt92M-00GzCd-Bm; Mon, 11 Feb 2019 11:42:06 +0100
From:   Luca Ceresoli <luca@lucaceresoli.net>
Subject: Re: [PATCH v3 1/2] media: dt-bindings: media: xilinx: Add Xilinx MIPI
 CSI-2 Rx Subsystem
To:     Vishal Sagar <vishal.sagar@xilinx.com>, hyun.kwon@xilinx.com,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, michals@xilinx.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dineshk@xilinx.com, sandipk@xilinx.com
References: <1549025766-135037-1-git-send-email-vishal.sagar@xilinx.com>
 <1549025766-135037-2-git-send-email-vishal.sagar@xilinx.com>
Message-ID: <fe975327-2746-28d4-1340-5ad1e71858f1@lucaceresoli.net>
Date:   Mon, 11 Feb 2019 11:42:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1549025766-135037-2-git-send-email-vishal.sagar@xilinx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - hostingweb31.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lucaceresoli.net
X-Get-Message-Sender-Via: hostingweb31.netsons.net: authenticated_id: luca+lucaceresoli.net/only user confirmed/virtual account not confirmed
X-Authenticated-Sender: hostingweb31.netsons.net: luca@lucaceresoli.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Vishal,

sorry for joining late in reviewing your patches. I have a few small
comments.

On 01/02/19 13:56, Vishal Sagar wrote:
> Add bindings documentation for Xilinx MIPI CSI-2 Rx Subsystem.
> 
> The Xilinx MIPI CSI-2 Rx Subsystem consists of a CSI-2 Rx controller, a
> DPHY in Rx mode, an optional I2C controller and a Video Format Bridge.
> 
> Signed-off-by: Vishal Sagar <vishal.sagar@xilinx.com>
> ---
> v3
> - removed interrupt parent as suggested by Rob
> - removed dphy clock
> - moved vfb to optional properties
> - Added required and optional port properties section
> - Added endpoint property section
> 
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
>  .../bindings/media/xilinx/xlnx,csi2rxss.txt        | 123 +++++++++++++++++++++
>  1 file changed, 123 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt b/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
> new file mode 100644
> index 0000000..399f7fa
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
> @@ -0,0 +1,123 @@
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

I'd clarify the vfb is optional:
"The Video Format Bridge" -> "The optional Video Format Bridge",
otherwise it has to be inferred from the property description below.

> +For more details, please refer to PG232 Xilinx MIPI CSI-2 Receiver Subsystem.
> +
> +Required properties:
> +--------------------
> +- compatible: Must contain "xlnx,mipi-csi2-rx-subsystem-4.0".
> +- reg: Physical base address and length of the registers set for the device.
> +- interrupts: Property with a value describing the interrupt number.
> +- clocks: List of phandles to AXI Lite, Video and 200 MHz DPHY clocks.
> +- clock-names: Must contain "lite_aclk" and "video_aclk" in the same order
> +  as clocks listed in clocks property.

Two clock names and 3 clocks?

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
> +
> +
> +Optional properties:
> +--------------------
> +- xlnx,vfb: This is present when Video Format Bridge is enabled.
> +  Without this property the driver won't be loaded as IP won't be able to generate
> +  media bus format compliant stream output.
> +- xlnx,en-csi-v2-0: Present if CSI v2 is enabled in IP configuration.
> +- xlnx,en-vcx: When present, there are maximum 16 virtual channels, else
> +  only 4. This is present only if xlnx,en-csi-v2-0 is present.
> +- xlnx,en-active-lanes: Enable Active lanes configuration in Protocol
> +  Configuration Register.

This doesn't seem very clear to me. According to my understanding of the
IP and driver, I'd rather rephrase as:

- xlnx,en-active-lanes: present if the number of active lanes can be
  reconfigured at runtime in the Protocol Configuration Register.
  If present, the V4L2_CID_XILINX_MIPICSISS_ACT_LANES is added.
  Otherwise all lanes are always active.

> +Ports
> +-----
> +The device node shall contain two 'port' child nodes as defined in
> +Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +The port@0 is sink port and shall connect to CSI2 source like camera.

"is a sink port"

> +It must have the data-lanes property. It may have the xlnx,cfa-pattern
> +property to indicate bayer pattern of source.
> +
> +The port@1 is source port could be connected to any video processing IP

"is a source port and can be"

> +which can work with AXI4 Stream data.
> +
> +Required port properties:
> +--------------------
> +- reg: 0 - for sink port.
> +       1 - for source port.
> +
> +Optional port properties:
> +--------------------
> +- xlnx,cfa-pattern: This goes in the sink port to indicate bayer pattern.
> +  Valid values are "bggr", "rggb", "gbrg" and "grbg".

Please excuse my ignorance, but does the csi2 rx module really [need to]
know the cfa pattern? I used to think  the sensor and debayer module
need to agree on it and CSI2 just moves bytes around. Also, other CSI2
RX drivers I've looked at don't have this property.

> +Optional endpoint property:
> +---------------------------
> +- data-lanes: specifies MIPI CSI-2 data lanes as covered in video-interfaces.txt.
> +  This should be in the sink port endpoint which connects to MIPI CSI2 source
> +  like sensor. The possible values are:
> +  1       - For 1 lane enabled in IP.
> +  1 2     - For 2 lanes enabled in IP.
> +  1 2 3   - For 3 lanes enabled in IP.
> +  1 2 3 4 - For 4 lanes enabled in IP.
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
> +		clock-names = "lite_aclk", "video_aclk";
> +		clocks = <&misc_clk_0>, <&misc_clk_1>, <&misc_clk_2>;

As above: two clock names and 3 clocks?

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

-- 
Luca
