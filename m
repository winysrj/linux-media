Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36457 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757742AbcAKC4m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2016 21:56:42 -0500
Date: Sun, 10 Jan 2016 20:56:37 -0600
From: Rob Herring <robh@kernel.org>
To: Simon Horman <horms+renesas@verge.net.au>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH v2] rcar_jpu: Add R-Car Gen2 Fallback Compatibility String
Message-ID: <20160111025637.GA17825@rob-hp-laptop>
References: <1452478400-4267-1-git-send-email-horms+renesas@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1452478400-4267-1-git-send-email-horms+renesas@verge.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 11, 2016 at 11:13:20AM +0900, Simon Horman wrote:
> Add fallback compatibility string.
> This is in keeping with the fallback scheme being adopted wherever
> appropriate for drivers for Renesas SoCs.
> 
> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
> 
> ---
> v2
> * Make fallback compat string for R-Car Gen2 rather than all renesas
>   hardware: that seems too generic
> ---
>  Documentation/devicetree/bindings/media/renesas,jpu.txt | 13 +++++++------
>  drivers/media/platform/rcar_jpu.c                       |  1 +
>  2 files changed, 8 insertions(+), 6 deletions(-)

Acked-by: Rob Herring <robh@kernel.org>
