Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB27C67839
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 21:27:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DDA620811
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 21:27:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="HVhvEjp5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1DDA620811
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbeLMV1m (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 16:27:42 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:44808 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbeLMV1l (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 16:27:41 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id D5D04549;
        Thu, 13 Dec 2018 22:27:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544736459;
        bh=NNLvVXb3vvj9BYXaiMjHXN7Nbt/wZGuQ4BEaWKiuiqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HVhvEjp5ts2UrqAB/vIGmyPoh9SKTgR2QiWW/2ls31CNP3OjxjIUoZfUgUJAzWp69
         fTquNkHaYRatusQGXAWD6JBVOHRCKHHVirtN+XzIreVTz98v8whTSFA9ppbsViaXE4
         O1ZOQmELrcWu1j5c27ch2Eai31ZcF91wyuGcEUHY=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: Re: [PATCH] [media] v4l: vsp1: Add RZ/G support
Date:   Thu, 13 Dec 2018 23:28:26 +0200
Message-ID: <2255820.0av6PIPOI9@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <1544732424-6498-1-git-send-email-fabrizio.castro@bp.renesas.com>
References: <1544732424-6498-1-git-send-email-fabrizio.castro@bp.renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Fabrizio,

Thank you for the patch.

On Thursday, 13 December 2018 22:20:24 EET Fabrizio Castro wrote:
> Document RZ/G1 and RZ/G2 support.
> 
> Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

And applied to my tree.

> ---
>  Documentation/devicetree/bindings/media/renesas,vsp1.txt | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/renesas,vsp1.txt
> b/Documentation/devicetree/bindings/media/renesas,vsp1.txt index
> 1642701..cd5a955 100644
> --- a/Documentation/devicetree/bindings/media/renesas,vsp1.txt
> +++ b/Documentation/devicetree/bindings/media/renesas,vsp1.txt
> @@ -2,13 +2,13 @@
> 
>  The VSP is a video processing engine that supports up-/down-scaling, alpha
>  blending, color space conversion and various other image processing
> features. -It can be found in the Renesas R-Car second generation SoCs.
> +It can be found in the Renesas R-Car Gen2, R-Car Gen3, RZ/G1, and RZ/G2
> SoCs.
> 
>  Required properties:
> 
>    - compatible: Must contain one of the following values
> -    - "renesas,vsp1" for the R-Car Gen2 VSP1
> -    - "renesas,vsp2" for the R-Car Gen3 VSP2
> +    - "renesas,vsp1" for the R-Car Gen2 and RZ/G1 VSP1
> +    - "renesas,vsp2" for the R-Car Gen3 and RZ/G2 VSP2
> 
>    - reg: Base address and length of the registers block for the VSP.
>    - interrupts: VSP interrupt specifier.


-- 
Regards,

Laurent Pinchart



