Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13926C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 12:57:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1FAF20449
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 12:57:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbfC0M5Q (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 08:57:16 -0400
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:52386 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725797AbfC0M5Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 08:57:16 -0400
Received: from [IPv6:2001:420:44c1:2579:f45d:db5a:3412:ff5f] ([IPv6:2001:420:44c1:2579:f45d:db5a:3412:ff5f])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 987ChBLfsUjKf987FhoyBK; Wed, 27 Mar 2019 13:57:14 +0100
Subject: Re: [PATCH v4 1/3] media: dt-bindings: media: document allegro-dvt
 bindings
To:     Michael Tretter <m.tretter@pengutronix.de>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     kernel@pengutronix.de, robh+dt@kernel.org, mchehab@kernel.org,
        tfiga@chromium.org, dshah@xilinx.com, Rob Herring <robh@kernel.org>
References: <20190301152718.23134-1-m.tretter@pengutronix.de>
 <20190301152718.23134-2-m.tretter@pengutronix.de>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e61aebce-8be4-7f6a-6d9b-69c5e4db14d2@xs4all.nl>
Date:   Wed, 27 Mar 2019 13:57:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190301152718.23134-2-m.tretter@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfCymeItseZN7BRDUM7iu44Y6whZe5b92EZf2OSUb+4S0T+joZTyCXQeCKVO7iU5tWH7KWFY1L//AbVrZ8hy+A6TsRYvUonXMoLKWf3Z03Dpuo1dPfTYC
 mKSfEXirH15e0RAfAA9NBmE3xaxKG/jQr/4VhH/u6CNOfQ8EMibu0OaSf1pUjmCjVcfltwBHoxr5CZ65+0c2TEuoLpR4ybJuj6rp+MshmMwtsKnQbGDOIDd5
 c5ss5FGWmEn1CL3264WROT0hZMXeMNCWoF6FTOhXg5FoyN8bbr/S6H/0L7uiEWyT+vnmfeVBDgeZsQNVmQNw89cLw6nkgUgKmPVT4hHtE5kTBEjk5B8WZBYo
 fRxaMssTgadXLN0dKaA0bJDXAaka7DoQaEw7kB6VO38J695kcrxvQLxKeyv2rAfTA0+v5K1Hl9OiEjpo/BD83Nro7KaO4+6g7hBS0pY/EBw+C6dunPSiJDr5
 SSAwTlPjo5BYDN6UNGs5f26UdjuAu9TJ+8ZE9mQouH5UAoK1SfJRABomLqot0bisUtY+nPK1L6MXPgej
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 3/1/19 4:27 PM, Michael Tretter wrote:
> Add device-tree bindings for the Allegro DVT video IP core found on the
> Xilinx ZynqMP EV family.
> 
> Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
> Reviewed-by: Rob Herring <robh@kernel.org>
> ---
> v3 -> v4:
> none
> 
> v2 -> v3:
> - rename node to video-codec
> - drop interrupt-names
> - fix compatible in example
> - add clocks to required properties
> 
> v1 -> v2:
> none
> ---
>  .../devicetree/bindings/media/allegro.txt     | 43 +++++++++++++++++++
>  1 file changed, 43 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/allegro.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/allegro.txt b/Documentation/devicetree/bindings/media/allegro.txt
> new file mode 100644
> index 000000000000..a92e2fbf26c9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/allegro.txt
> @@ -0,0 +1,43 @@
> +Device-tree bindings for the Allegro DVT video IP codecs present in the Xilinx
> +ZynqMP SoC. The IP core may either be a H.264/H.265 encoder or H.264/H.265
> +decoder ip core.
> +
> +Each actual codec engines is controlled by a microcontroller (MCU). Host
> +software uses a provided mailbox interface to communicate with the MCU. The
> +MCU share an interrupt.
> +
> +Required properties:
> +  - compatible: value should be one of the following
> +    "allegro,al5e-1.1", "allegro,al5e": encoder IP core
> +    "allegro,al5d-1.1", "allegro,al5d": decoder IP core

checkpatch give me:

WARNING: DT compatible string vendor "allegro" appears un-documented -- check ./Documentation/devicetree/bindings/vendor-prefixes.txt
#2714: FILE: drivers/staging/media/allegro-dvt/allegro-core.c:2636:
+       { .compatible = "allegro,al5e-1.1" },

I think you should probably replace allegro by xlnx.

Regards,

	Hans

> +  - reg: base and length of the memory mapped register region and base and
> +    length of the memory mapped sram
> +  - reg-names: must include "regs" and "sram"
> +  - interrupts: shared interrupt from the MCUs to the processing system
> +  - clocks: must contain an entry for each entry in clock-names
> +  - clock-names: must include "core_clk", "mcu_clk", "m_axi_core_aclk",
> +    "m_axi_mcu_aclk", "s_axi_lite_aclk"
> +
> +Example:
> +	al5e: video-codec@a0009000 {
> +		compatible = "allegro,al5e-1.1", "allegro,al5e";
> +		reg = <0 0xa0009000 0 0x1000>,
> +		      <0 0xa0000000 0 0x8000>;
> +		reg-names = "regs", "sram";
> +		interrupts = <0 96 4>;
> +		clocks = <&xlnx_vcu 0>, <&xlnx_vcu 1>,
> +			 <&clkc 71>, <&clkc 71>, <&clkc 71>;
> +		clock-names = "core_clk", "mcu_clk", "m_axi_core_aclk",
> +			      "m_axi_mcu_aclk", "s_axi_lite_aclk"
> +	};
> +	al5d: video-codec@a0029000 {
> +		compatible = "allegro,al5d-1.1", "allegro,al5d";
> +		reg = <0 0xa0029000 0 0x1000>,
> +		      <0 0xa0020000 0 0x8000>;
> +		reg-names = "regs", "sram";
> +		interrupts = <0 96 4>;
> +		clocks = <&xlnx_vcu 2>, <&xlnx_vcu 3>,
> +			 <&clkc 71>, <&clkc 71>, <&clkc 71>;
> +		clock-names = "core_clk", "mcu_clk", "m_axi_core_aclk",
> +			      "m_axi_mcu_aclk", "s_axi_lite_aclk"
> +	};
> 

