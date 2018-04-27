Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:37181 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758984AbeD0UGs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Apr 2018 16:06:48 -0400
Date: Fri, 27 Apr 2018 15:06:46 -0500
From: Rob Herring <robh@kernel.org>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: geert@linux-m68k.org, horms@verge.net.au, mark.rutland@arm.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] dt-bindings: media: renesas-ceu: Add R-Mobile
 R8A7740
Message-ID: <20180427200646.fdvswcnvglkx4j7u@rob-hp-laptop>
References: <1524767083-19862-1-git-send-email-jacopo+renesas@jmondi.org>
 <1524767083-19862-2-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1524767083-19862-2-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 26, 2018 at 08:24:42PM +0200, Jacopo Mondi wrote:
> Add R-Mobile A1 R8A7740 SoC to the list of compatible values for the CEU
> unit.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  Documentation/devicetree/bindings/media/renesas,ceu.txt | 7 ++++---
>  drivers/media/platform/renesas-ceu.c                    | 1 +
>  2 files changed, 5 insertions(+), 3 deletions(-)

Reviewed-by: Rob Herring <robh@kernel.org>
