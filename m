Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33010 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387759AbeGKNzl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jul 2018 09:55:41 -0400
Date: Wed, 11 Jul 2018 07:51:12 -0600
From: Rob Herring <robh@kernel.org>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v5 1/6] dt-bindings: media: rcar-vin: Align Gen2 and Gen3
Message-ID: <20180711135112.GA12419@rob-hp-laptop>
References: <1531145962-1540-1-git-send-email-jacopo+renesas@jmondi.org>
 <1531145962-1540-2-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1531145962-1540-2-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 09, 2018 at 04:19:16PM +0200, Jacopo Mondi wrote:
> Align description of the Gen2 and Gen3 bindings for parallel input.
> This commit prepares for description of optional endpoint properties in ports
> subnodes accepting parallel video connections.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)

Reviewed-by: Rob Herring <robh@kernel.org>
