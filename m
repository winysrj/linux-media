Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34403 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbcFJRjQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2016 13:39:16 -0400
Date: Fri, 10 Jun 2016 12:39:14 -0500
From: Rob Herring <robh@kernel.org>
To: Kieran Bingham <kieran@ksquared.org.uk>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	"open list:MEDIA DRIVERS FOR RENESAS - FCP"
	<linux-media@vger.kernel.org>,
	"open list:MEDIA DRIVERS FOR RENESAS - FCP"
	<linux-renesas-soc@vger.kernel.org>,
	"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
	<devicetree@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] dt-bindings: Document Renesas R-Car FCP
 power-domains usage
Message-ID: <20160610173914.GA20505@rob-hp-laptop>
References: <1465479695-18644-1-git-send-email-kieran@bingham.xyz>
 <1465479695-18644-3-git-send-email-kieran@bingham.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1465479695-18644-3-git-send-email-kieran@bingham.xyz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 09, 2016 at 02:41:33PM +0100, Kieran Bingham wrote:
> The power domain must be specified to bring the device out of module
> standby. Document this in the example provided, so that new additions
> are not missed.
> 
> Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
> ---
>  Documentation/devicetree/bindings/media/renesas,fcp.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/renesas,fcp.txt b/Documentation/devicetree/bindings/media/renesas,fcp.txt
> index 271dcfdb5a76..6a55f5215221 100644
> --- a/Documentation/devicetree/bindings/media/renesas,fcp.txt
> +++ b/Documentation/devicetree/bindings/media/renesas,fcp.txt
> @@ -31,4 +31,5 @@ Device node example
>  		compatible = "renesas,r8a7795-fcpv", "renesas,fcpv";
>  		reg = <0 0xfea2f000 0 0x200>;
>  		clocks = <&cpg CPG_MOD 602>;
> +		power-domains = <&sysc R8A7795_PD_A3VP>;

This needs to be documented above too, not just the example.

>  	};
> -- 
> 2.7.4
> 
