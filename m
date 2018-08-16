Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33046 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725828AbeHQAPc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Aug 2018 20:15:32 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w7GL9Mbk002242
        for <linux-media@vger.kernel.org>; Thu, 16 Aug 2018 17:14:49 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2kwdeu08r7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-media@vger.kernel.org>; Thu, 16 Aug 2018 17:14:49 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-media@vger.kernel.org> from <eajames@linux.vnet.ibm.com>;
        Thu, 16 Aug 2018 15:14:48 -0600
Subject: Re: [RFC 1/2] dt-bindings: media: Add Aspeed Video Engine binding
 documentation
To: linux-kernel@vger.kernel.org
Cc: linux-aspeed@lists.ozlabs.org, andrew@aj.id.au,
        openbmc@lists.ozlabs.org, mchehab@kernel.org,
        linux-media@vger.kernel.org, robh@kernel.org
References: <1534448601-74120-1-git-send-email-eajames@linux.vnet.ibm.com>
 <1534448601-74120-2-git-send-email-eajames@linux.vnet.ibm.com>
From: Eddie James <eajames@linux.vnet.ibm.com>
Date: Thu, 16 Aug 2018 16:14:37 -0500
MIME-Version: 1.0
In-Reply-To: <1534448601-74120-2-git-send-email-eajames@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Message-Id: <0072215a-9249-2ad3-3d66-2f1b605ad915@linux.vnet.ibm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 08/16/2018 02:43 PM, Eddie James wrote:
> Document the bindings.
>
> Signed-off-by: Eddie James <eajames@linux.vnet.ibm.com>
> ---
>   .../devicetree/bindings/media/aspeed-video.txt     | 25 ++++++++++++++++++++++
>   1 file changed, 25 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/media/aspeed-video.txt
>
> diff --git a/Documentation/devicetree/bindings/media/aspeed-video.txt b/Documentation/devicetree/bindings/media/aspeed-video.txt
> new file mode 100644
> index 0000000..91a494e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/aspeed-video.txt
> @@ -0,0 +1,25 @@
> +* Device tree bindings for Aspeed Video Engine
> +
> +The Video Engine (VE) embedded in the Aspeed AST2400 and AST2500 SOCs can
> +capture and compress video data from digital or analog sources.
> +
> +Required properties:
> + - compatible:		"aspeed,ast2400-video" or "aspeed,ast2500-video"
> + - reg:			contains the offset and length of the VE memory region
> + - clocks:		pointers to the the "vclk" and "eclk" of the syscon
> + - clock-names:		"vclk-gate", "eclk-gate"
> + - resets:		pointer to the VE reset of the syscon
> + - interrupts:		the interrupt associated with the VE on this platform
> + - reg-scu:		pointer to the syscon itself

Forgot to remove syscon reference in latest, it's not needed.

Thanks,
Eddie

> +
> +Example:
> +
> +video: video@1e700000 {
> +        compatible = "aspeed,ast2500-video";
> +        reg = <0x1e700000 0x20000>;
> +        clocks = <&syscon ASPEED_CLK_GATE_VCLK>, <&syscon ASPEED_CLK_GATE_ECLK>;
> +        clock-names = "vclk-gate", "eclk-gate";
> +        resets = <&syscon ASPEED_RESET_VIDEO>;
> +        interrupts = <7>;
> +        reg-scu = <&syscon>;
> +};
