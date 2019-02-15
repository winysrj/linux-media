Return-Path: <SRS0=2oy6=QW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2B34C43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 08:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BDA621916
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 08:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404275AbfBOIhk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 03:37:40 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:34603 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726396AbfBOIhk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 03:37:40 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id uZ02gHhOp4HFnuZ05gs7DA; Fri, 15 Feb 2019 09:37:38 +0100
Subject: Re: [PATCH 3/3] media: mx2-emmaprp: Add DT bindings documentation
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Alexander Shiyan <shc_work@mail.ru>, linux-media@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        devicetree@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
References: <20181216034907.15787-1-shc_work@mail.ru>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <799b49d0-0bea-7029-0259-baeacd06e105@xs4all.nl>
Date:   Fri, 15 Feb 2019 09:37:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20181216034907.15787-1-shc_work@mail.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfMMUNq5bPScK3f1Is7LTI+mZQ3vPdPFueOjgnv80ZpYgGEytqGx+BuiIgDYJEVcbL8OcFrr7DiOLxGvDtmN8t2HkZn4dHMKz8Ks0zgofTL4tnJouYeH9
 OnyuX7hbjrOAhKzJfR3Eyxj39/K3Jn0fSiGOPMOS0DlkAkINZUlJbV0nyAFaYbcFStNSgx8hz3JtUtOsccVdgxpt7gfHJ5ct89frVpT24MnQj0c7KDS1Zb7D
 XmoJyp2gNW6QDkeHHoINFIbfsrv13ROzApenxXxfbciLBFnEHWUY4feiTDsZv1hEMs1UO5G+HWWFK0vHyxVhkkDs8GsFimnn2dR5PWpNGPg=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Rob,

Can you take a look at this?

Thanks!

	Hans

On 12/16/18 4:49 AM, Alexander Shiyan wrote:
> This patch adds DT binding documentation for the Freescale enhanced
> Multimedia Accelerator (eMMA) video Pre-processor (PrP).
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
>  .../devicetree/bindings/media/fsl-emmaprp.txt        | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/fsl-emmaprp.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/fsl-emmaprp.txt b/Documentation/devicetree/bindings/media/fsl-emmaprp.txt
> new file mode 100644
> index 0000000..9dd7cc6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/fsl-emmaprp.txt
> @@ -0,0 +1,20 @@
> +* Freescale enhanced Multimedia Accelerator (eMMA) video Pre-processor (PrP)
> +  for i.MX21 & i.MX27 SoCs.
> +
> +Required properties:
> +- compatible : Shall contain "fsl,imx21-emmaprp" for compatible with
> +               the one integrated on i.MX21 SoC.
> +- reg        : Offset and length of the register set for the device.
> +- interrupts : Should contain eMMA PrP interrupt number.
> +- clocks     : Should contain the ahb and ipg clocks, in the order
> +               determined by the clock-names property.
> +- clock-names: Should be "ahb", "ipg".
> +
> +Example:
> +	emmaprp: emmaprp@10026400 {
> +		compatible = "fsl,imx21-emmaprp";
> +		reg = <0x10026400 0x100>;
> +		interrupts = <51>;
> +		clocks = <&clks 49>, <&clks 68>;
> +		clock-names = "ipg", "ahb";
> +	};
> 

