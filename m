Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44321 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbcGQQbL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 12:31:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran@ksquared.org.uk>
Cc: robh+dt@kernel.org, mark.rutland@arm.com,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] dt-bindings: Document Renesas R-Car FCP power-domains usage
Date: Sun, 17 Jul 2016 19:31:12 +0300
Message-ID: <5049690.gmjd5cAaeQ@avalon>
In-Reply-To: <1467305430-25660-3-git-send-email-kieran@bingham.xyz>
References: <1467305430-25660-1-git-send-email-kieran@bingham.xyz> <1467305430-25660-3-git-send-email-kieran@bingham.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Thursday 30 Jun 2016 17:50:29 Kieran Bingham wrote:
> The power domain must be specified to bring the device out of module
> standby. Document this in the bindings provided, so that new additions
> are not missed.
> 
> Signed-off-by: Kieran Bingham <kieran@bingham.xyz>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  Documentation/devicetree/bindings/media/renesas,fcp.txt | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/renesas,fcp.txt
> b/Documentation/devicetree/bindings/media/renesas,fcp.txt index
> 271dcfdb5a76..5be21b6411ba 100644
> --- a/Documentation/devicetree/bindings/media/renesas,fcp.txt
> +++ b/Documentation/devicetree/bindings/media/renesas,fcp.txt
> @@ -23,6 +23,10 @@ are paired with. These DT bindings currently support the
> FCPV and FCPF. - reg: the register base and size for the device registers
>   - clocks: Reference to the functional clock
> 
> +Optional properties:
> + - power-domains : power-domain property defined with a power domain
> specifier
> +                            to respective power domain.
> +
> 
>  Device node example
>  -------------------
> @@ -31,4 +35,5 @@ Device node example
>  		compatible = "renesas,r8a7795-fcpv", "renesas,fcpv";
>  		reg = <0 0xfea2f000 0 0x200>;
>  		clocks = <&cpg CPG_MOD 602>;
> +		power-domains = <&sysc R8A7795_PD_A3VP>;
>  	};

-- 
Regards,

Laurent Pinchart

