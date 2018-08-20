Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:45433 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbeHUBmX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Aug 2018 21:42:23 -0400
Date: Mon, 20 Aug 2018 17:24:55 -0500
From: Rob Herring <robh@kernel.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH] rcar-csi2: add R8A77980 support
Message-ID: <20180820222455.GA12251@bogus>
References: <f6edfd44-7b08-e467-3486-795251816187@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6edfd44-7b08-e467-3486-795251816187@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 06, 2018 at 07:56:27PM +0300, Sergei Shtylyov wrote:
> Add the R-Car V3H (AKA R8A77980) SoC support to the R-Car CSI2 driver.
> 
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> 
> ---
> This patch is against the 'media_tree.git' repo's 'master' branch.
> 
>  Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt |    1 

Acked-by: Rob Herring <robh@kernel.org>

>  drivers/media/platform/rcar-vin/rcar-csi2.c                   |   11 ++++++++++
>  2 files changed, 12 insertions(+)
