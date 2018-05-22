Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:45294 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752939AbeEVU5u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 16:57:50 -0400
Date: Tue, 22 May 2018 15:57:47 -0500
From: Rob Herring <robh@kernel.org>
To: Simon Horman <horms+renesas@verge.net.au>
Cc: linux-renesas-soc@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] media: rcar-vin:  Drop unnecessary register properties
 from example vin port
Message-ID: <20180522205747.GA2795@rob-hp-laptop>
References: <20180509184558.14960-1-horms+renesas@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180509184558.14960-1-horms+renesas@verge.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 09, 2018 at 08:45:58PM +0200, Simon Horman wrote:
> The example vin port node does not have an address and thus does not
> need address-cells or address size-properties.
> 
> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
> ---
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 3 ---
>  1 file changed, 3 deletions(-)

Reviewed-by: Rob Herring <robh@kernel.org>
