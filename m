Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2586DC07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 12:39:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E028820989
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 12:39:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E028820989
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbeLGMjP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 07:39:15 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:46914 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725994AbeLGMjO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Dec 2018 07:39:14 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id VFPQg6XyrgJOKVFPTgYqxz; Fri, 07 Dec 2018 13:39:12 +0100
Subject: Re: [PATCH v9 05/13] media: dt-bindings: add bindings for i.MX7 media
 driver
To:     Rui Miguel Silva <rui.silva@linaro.org>,
        sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20181122151834.6194-1-rui.silva@linaro.org>
 <20181122151834.6194-6-rui.silva@linaro.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5bc1ad92-4d84-62af-396c-9ba8b3be424b@xs4all.nl>
Date:   Fri, 7 Dec 2018 13:39:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20181122151834.6194-6-rui.silva@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfB6c20PupPVY7prlUF/zf6dJzPtmjpfm2HYmAABJO712c7gxKrb8DedIJPxzHul2uQsufGLM26v8zLIV9SDn1K3qW+CHWSpXqwsaYYGcsLi3fmZCxLzk
 dtNC5+RskVe1dzzHdr5visUYdkUdXDPgUudMe+39elF887O6NQhcAQ66dKCl2t4f65HtW02CEhdkouNOTJ5awHz+cbdoyox82th0Iq6bIyqZMMd2mpLNNm/3
 U7dtq2xwnayvVFfRY75ngDujOrrtAeBkA5PJk44M5u5GDZ83ochE8gPNmwuB7htvhaUP+jSHpQxuUoA8dDOY1kRwpRXtT33YJEXC7htvNj0LOHwv5Q8IG1Ao
 SAJHImgtIvG7XYrLPQdSDbKrf+WTNvrttyYO11JS5RcOKPoAvQMdC4E8240A7tCoPl60ZvPHftz7J9oMt9v76h0tOYLvWg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 11/22/2018 04:18 PM, Rui Miguel Silva wrote:
> Add bindings documentation for i.MX7 media drivers.
> The imx7 MIPI CSI2 and imx7 CMOS Sensor Interface.
> 
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> Reviewed-by: Rob Herring <robh@kernel.org>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Please move this patch to the beginning of the series to avoid
checkpatch warnings:

WARNING: DT compatible string "fsl,imx7-csi" appears un-documented -- check ./Documentation/devicetree/bindings/
#1378: FILE: drivers/staging/media/imx/imx7-media-csi.c:1336:
+       { .compatible = "fsl,imx7-csi" },

Thanks!

	Hans


> ---
>  .../devicetree/bindings/media/imx7-csi.txt    | 45 ++++++++++
>  .../bindings/media/imx7-mipi-csi2.txt         | 90 +++++++++++++++++++
>  2 files changed, 135 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/imx7-csi.txt
>  create mode 100644 Documentation/devicetree/bindings/media/imx7-mipi-csi2.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/imx7-csi.txt b/Documentation/devicetree/bindings/media/imx7-csi.txt
> new file mode 100644
> index 000000000000..3c07bc676bc3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/imx7-csi.txt
> @@ -0,0 +1,45 @@
> +Freescale i.MX7 CMOS Sensor Interface
> +=====================================
> +
> +csi node
> +--------
> +
> +This is device node for the CMOS Sensor Interface (CSI) which enables the chip
> +to connect directly to external CMOS image sensors.
> +
> +Required properties:
> +
> +- compatible    : "fsl,imx7-csi";
> +- reg           : base address and length of the register set for the device;
> +- interrupts    : should contain CSI interrupt;
> +- clocks        : list of clock specifiers, see
> +        Documentation/devicetree/bindings/clock/clock-bindings.txt for details;
> +- clock-names   : must contain "axi", "mclk" and "dcic" entries, matching
> +                 entries in the clock property;
> +
> +The device node shall contain one 'port' child node with one child 'endpoint'
> +node, according to the bindings defined in:
> +Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +In the following example a remote endpoint is a video multiplexer.
> +
> +example:
> +
> +                csi: csi@30710000 {
> +                        #address-cells = <1>;
> +                        #size-cells = <0>;
> +
> +                        compatible = "fsl,imx7-csi";
> +                        reg = <0x30710000 0x10000>;
> +                        interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
> +                        clocks = <&clks IMX7D_CLK_DUMMY>,
> +                                        <&clks IMX7D_CSI_MCLK_ROOT_CLK>,
> +                                        <&clks IMX7D_CLK_DUMMY>;
> +                        clock-names = "axi", "mclk", "dcic";
> +
> +                        port {
> +                                csi_from_csi_mux: endpoint {
> +                                        remote-endpoint = <&csi_mux_to_csi>;
> +                                };
> +                        };
> +                };
> diff --git a/Documentation/devicetree/bindings/media/imx7-mipi-csi2.txt b/Documentation/devicetree/bindings/media/imx7-mipi-csi2.txt
> new file mode 100644
> index 000000000000..71fd74ed3ec8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/imx7-mipi-csi2.txt
> @@ -0,0 +1,90 @@
> +Freescale i.MX7 Mipi CSI2
> +=========================
> +
> +mipi_csi2 node
> +--------------
> +
> +This is the device node for the MIPI CSI-2 receiver core in i.MX7 SoC. It is
> +compatible with previous version of Samsung D-phy.
> +
> +Required properties:
> +
> +- compatible    : "fsl,imx7-mipi-csi2";
> +- reg           : base address and length of the register set for the device;
> +- interrupts    : should contain MIPI CSIS interrupt;
> +- clocks        : list of clock specifiers, see
> +        Documentation/devicetree/bindings/clock/clock-bindings.txt for details;
> +- clock-names   : must contain "pclk", "wrap" and "phy" entries, matching
> +                  entries in the clock property;
> +- power-domains : a phandle to the power domain, see
> +          Documentation/devicetree/bindings/power/power_domain.txt for details.
> +- reset-names   : should include following entry "mrst";
> +- resets        : a list of phandle, should contain reset entry of
> +                  reset-names;
> +- phy-supply    : from the generic phy bindings, a phandle to a regulator that
> +	          provides power to MIPI CSIS core;
> +
> +Optional properties:
> +
> +- clock-frequency : The IP's main (system bus) clock frequency in Hz, default
> +		    value when this property is not specified is 166 MHz;
> +- fsl,csis-hs-settle : differential receiver (HS-RX) settle time;
> +
> +The device node should contain two 'port' child nodes with one child 'endpoint'
> +node, according to the bindings defined in:
> + Documentation/devicetree/bindings/ media/video-interfaces.txt.
> + The following are properties specific to those nodes.
> +
> +port node
> +---------
> +
> +- reg		  : (required) can take the values 0 or 1, where 0 shall be
> +                     related to the sink port and port 1 shall be the source
> +                     one;
> +
> +endpoint node
> +-------------
> +
> +- data-lanes    : (required) an array specifying active physical MIPI-CSI2
> +		    data input lanes and their mapping to logical lanes; this
> +                    shall only be applied to port 0 (sink port), the array's
> +                    content is unused only its length is meaningful,
> +                    in this case the maximum length supported is 2;
> +
> +example:
> +
> +        mipi_csi: mipi-csi@30750000 {
> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +
> +                compatible = "fsl,imx7-mipi-csi2";
> +                reg = <0x30750000 0x10000>;
> +                interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
> +                clocks = <&clks IMX7D_IPG_ROOT_CLK>,
> +                                <&clks IMX7D_MIPI_CSI_ROOT_CLK>,
> +                                <&clks IMX7D_MIPI_DPHY_ROOT_CLK>;
> +                clock-names = "pclk", "wrap", "phy";
> +                clock-frequency = <166000000>;
> +                power-domains = <&pgc_mipi_phy>;
> +                phy-supply = <&reg_1p0d>;
> +                resets = <&src IMX7_RESET_MIPI_PHY_MRST>;
> +                reset-names = "mrst";
> +                fsl,csis-hs-settle = <3>;
> +
> +                port@0 {
> +                        reg = <0>;
> +
> +                        mipi_from_sensor: endpoint {
> +                                remote-endpoint = <&ov2680_to_mipi>;
> +                                data-lanes = <1>;
> +                        };
> +                };
> +
> +                port@1 {
> +                        reg = <1>;
> +
> +                        mipi_vc0_to_csi_mux: endpoint {
> +                                remote-endpoint = <&csi_mux_from_mipi_vc0>;
> +                        };
> +                };
> +        };
> 

