Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53129 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751606AbcJXKbq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Oct 2016 06:31:46 -0400
Subject: Re: [PATCH v4 4/4] arm64: dts: renesas: r8a7796: Add FDP1 instance
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org
References: <1477299818-31935-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1477299818-31935-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <cadb2e0f-91c4-8004-0c7d-61839ef8bb3e@ideasonboard.com>
Date: Mon, 24 Oct 2016 11:31:40 +0100
MIME-Version: 1.0
In-Reply-To: <1477299818-31935-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 24/10/16 10:03, Laurent Pinchart wrote:
> The r8a7796 has a single FDP1 instance.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  arch/arm64/boot/dts/renesas/r8a7796.dtsi | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/renesas/r8a7796.dtsi b/arch/arm64/boot/dts/renesas/r8a7796.dtsi
> index 9217da983525..fbec7a29121a 100644
> --- a/arch/arm64/boot/dts/renesas/r8a7796.dtsi
> +++ b/arch/arm64/boot/dts/renesas/r8a7796.dtsi
> @@ -251,5 +251,14 @@
>  			power-domains = <&sysc R8A7796_PD_ALWAYS_ON>;
>  			status = "disabled";
>  		};
> +
> +		fdp1@fe940000 {
> +			compatible = "renesas,fdp1";
> +			reg = <0 0xfe940000 0 0x2400>;
> +			interrupts = <GIC_SPI 262 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks = <&cpg CPG_MOD 119>;
> +			power-domains = <&sysc R8A7796_PD_A3VC>;
> +			renesas,fcp = <&fcpf0>;
> +		};
>  	};
>  };
> 

Looks good to me:

Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
--
Kieran
