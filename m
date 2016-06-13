Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47225 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964804AbcFMMRh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2016 08:17:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran@ksquared.org.uk>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, linux-media@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] dt-bindings: Update Renesas R-Car FCP DT binding
Date: Mon, 13 Jun 2016 15:17:41 +0300
Message-ID: <2159488.zJIIWenpjG@avalon>
In-Reply-To: <1465479695-18644-2-git-send-email-kieran@bingham.xyz>
References: <1465479695-18644-1-git-send-email-kieran@bingham.xyz> <1465479695-18644-2-git-send-email-kieran@bingham.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Thursday 09 Jun 2016 14:41:32 Kieran Bingham wrote:
> The FCP driver, can also support the FCPF variant for FDP1 compatible
> processing.

With the comma dropped,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
> ---
>  Documentation/devicetree/bindings/media/renesas,fcp.txt | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/renesas,fcp.txt
> b/Documentation/devicetree/bindings/media/renesas,fcp.txt index
> 6a12960609d8..271dcfdb5a76 100644
> --- a/Documentation/devicetree/bindings/media/renesas,fcp.txt
> +++ b/Documentation/devicetree/bindings/media/renesas,fcp.txt
> @@ -7,12 +7,14 @@ conversion of AXI transactions in order to reduce the
> memory bandwidth.
> 
>  There are three types of FCP: FCP for Codec (FCPC), FCP for VSP (FCPV) and
> FCP for FDP (FCPF). Their configuration and behaviour depend on the module
> they -are paired with. These DT bindings currently support the FCPV only.
> +are paired with. These DT bindings currently support the FCPV and FCPF.
> 
>   - compatible: Must be one or more of the following
> 
>     - "renesas,r8a7795-fcpv" for R8A7795 (R-Car H3) compatible 'FCP for VSP'
> +   - "renesas,r8a7795-fcpf" for R8A7795 (R-Car H3) compatible 'FCP for
> FDP' - "renesas,fcpv" for generic compatible 'FCP for VSP'
> +   - "renesas,fcpf" for generic compatible 'FCP for FDP'
> 
>     When compatible with the generic version, nodes must list the
>     SoC-specific version corresponding to the platform first, followed by
> the

-- 
Regards,

Laurent Pinchart

