Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39180 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728979AbeJATqh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2018 15:46:37 -0400
MIME-Version: 1.0
References: <1537903629-14003-1-git-send-email-eajames@linux.ibm.com> <1537903629-14003-2-git-send-email-eajames@linux.ibm.com>
In-Reply-To: <1537903629-14003-2-git-send-email-eajames@linux.ibm.com>
From: Joel Stanley <joel@jms.id.au>
Date: Mon, 1 Oct 2018 15:08:38 +0200
Message-ID: <CACPK8Xd0MhrFQqiM=u-Rv5u7RJRo5R-pAejH4dmeTrYSWE0AZA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] dt-bindings: media: Add Aspeed Video Engine
 binding documentation
To: eajames@linux.ibm.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-aspeed@lists.ozlabs.org, Andrew Jeffery <andrew@aj.id.au>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
        mchehab@kernel.org, hverkuil@xs4all.nl
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 25 Sep 2018 at 21:27, Eddie James <eajames@linux.ibm.com> wrote:
>
> Document the bindings.
>
> Signed-off-by: Eddie James <eajames@linux.ibm.com>
> ---
>  .../devicetree/bindings/media/aspeed-video.txt     | 26 ++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/aspeed-video.txt
>
> diff --git a/Documentation/devicetree/bindings/media/aspeed-video.txt b/Documentation/devicetree/bindings/media/aspeed-video.txt
> new file mode 100644
> index 0000000..f1af528
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/aspeed-video.txt
> @@ -0,0 +1,26 @@
> +* Device tree bindings for Aspeed Video Engine
> +
> +The Video Engine (VE) embedded in the Aspeed AST2400 and AST2500 SOCs can
> +capture and compress video data from digital or analog sources.
> +
> +Required properties:
> + - compatible:         "aspeed,ast2400-video-engine" or
> +                       "aspeed,ast2500-video-engine"
> + - reg:                        contains the offset and length of the VE memory region
> + - clocks:             clock specifiers for the syscon clocks associated with
> +                       the VE (ordering must match the clock-names property)
> + - clock-names:                "vclk" and "eclk"
> + - resets:             reset specifier for the syscon reset associaated with

associated

> +                       the VE
> + - interrupts:         the interrupt associated with the VE on this platform
> +
> +Example:
> +
> +video-engine@1e700000 {
> +    compatible = "aspeed,ast2500-video-engine";
> +    reg = <0x1e700000 0x20000>;
> +    clocks = <&syscon ASPEED_CLK_GATE_VCLK>, <&syscon ASPEED_CLK_GATE_ECLK>;
> +    clock-names = "vclk", "eclk";

Did you end up sending the clock patches out?

Cheers,

Joel

> +    resets = <&syscon ASPEED_RESET_VIDEO>;
> +    interrupts = <7>;
> +};
> --
> 1.8.3.1
>
