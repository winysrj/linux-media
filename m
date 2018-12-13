Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E952C67839
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 21:27:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED20F20880
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 21:27:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="SiIbEZ4M"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED20F20880
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbeLMV1C (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 16:27:02 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:44644 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbeLMV1C (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 16:27:02 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 3307C549;
        Thu, 13 Dec 2018 22:26:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544736419;
        bh=hzH4zJao139Sq9QoPujZQKReE/ul45PsCI+cIpN9ha4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SiIbEZ4MPGWtT2TWBmcRzrFiFJZSb7HzykMG8TkQOEfhZEsjXbg9SoeUDyrnyugLe
         5Pk6wODnuRTsISZW8heMnM8t2voTZz7/K3ZFdpGx8DmA98wmSF5v1ndjKWYXWM7nuQ
         huGTL6BSUaAKfH8cUWI164SlMILbCD8/03OoNDfI=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: Re: [PATCH] dt-bindings: media: renesas-fcp: Add RZ/G2 support
Date:   Thu, 13 Dec 2018 23:27:46 +0200
Message-ID: <16447189.zyKSHM3mdJ@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <1544732433-6543-1-git-send-email-fabrizio.castro@bp.renesas.com>
References: <1544732433-6543-1-git-send-email-fabrizio.castro@bp.renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Fabrizio,

Thank you for the patch.

On Thursday, 13 December 2018 22:20:33 EET Fabrizio Castro wrote:
> Document RZ/G2 support.
> 
> Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

And applied to my tree.

> ---
>  Documentation/devicetree/bindings/media/renesas,fcp.txt | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/renesas,fcp.txt
> b/Documentation/devicetree/bindings/media/renesas,fcp.txt index
> 3ec9180..79c3739 100644
> --- a/Documentation/devicetree/bindings/media/renesas,fcp.txt
> +++ b/Documentation/devicetree/bindings/media/renesas,fcp.txt
> @@ -2,8 +2,9 @@ Renesas R-Car Frame Compression Processor (FCP)
>  -----------------------------------------------
> 
>  The FCP is a companion module of video processing modules in the Renesas
> R-Car -Gen3 SoCs. It provides data compression and decompression, data
> caching, and -conversion of AXI transactions in order to reduce the memory
> bandwidth. +Gen3 and RZ/G2 SoCs. It provides data compression and
> decompression, data +caching, and conversion of AXI transactions in order
> to reduce the memory +bandwidth.
> 
>  There are three types of FCP: FCP for Codec (FCPC), FCP for VSP (FCPV) and
> FCP for FDP (FCPF). Their configuration and behaviour depend on the module
> they


-- 
Regards,

Laurent Pinchart



