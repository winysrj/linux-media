Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41808C10F0C
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 09:09:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03D4A2075C
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 09:09:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="YF9vKVVi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfCKJJt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 05:09:49 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:49874 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbfCKJJt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 05:09:49 -0400
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5B973304;
        Mon, 11 Mar 2019 10:09:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552295387;
        bh=RBsicthfwwKQf0AZi52EIAvbj1UcPmv77Op5AR3JICY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YF9vKVVieEL/vofuSXNZQb3OfpD31qw7OFZRlfyFuWRrcY85FT2AYiGaqFSgOMtu7
         frZM5WZh90/HpSOStHXNP+Xp9xAXHtglB0FN16073fexQ6/n5MuqA/BmigYz6gCesB
         zxMSK9t8usJyKPN/mFd9MGcPLemfFEzWViuZxl/s=
Date:   Mon, 11 Mar 2019 11:09:41 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Niklas =?utf-8?Q?S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/2] dt-bindings: rcar-csi2: List resets as a
 mandatory property
Message-ID: <20190311090941.GH4775@pendragon.ideasonboard.com>
References: <20190308234722.25775-1-niklas.soderlund+renesas@ragnatech.se>
 <20190308234722.25775-2-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190308234722.25775-2-niklas.soderlund+renesas@ragnatech.se>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

Thank you for the patch.

On Sat, Mar 09, 2019 at 12:47:21AM +0100, Niklas Söderlund wrote:
> The resets property will become mandatory to operate the device, list it
> as such. All device tree source files have always included the reset
> property so making it mandatory will not introduce any regressions.
> 
> While at it improve the description for the clocks property.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
> index d63275e17afdd180..9a0d0531c67df48c 100644
> --- a/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
> +++ b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
> @@ -18,7 +18,8 @@ Mandatory properties
>  
>   - reg: the register base and size for the device registers
>   - interrupts: the interrupt for the device
> - - clocks: reference to the parent clock
> + - clocks: A phandle + clock specifier for the module clock
> + - resets: A phandle + reset specifier for the module reset
>  
>  The device node shall contain two 'port' child nodes according to the
>  bindings defined in Documentation/devicetree/bindings/media/

-- 
Regards,

Laurent Pinchart
