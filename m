Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:44152 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932527AbeEaDQY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 23:16:24 -0400
Date: Wed, 30 May 2018 22:16:22 -0500
From: Rob Herring <robh@kernel.org>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 4/8] dt-bindings: media: rcar-vin: Add
 'data-enable-active'
Message-ID: <20180531031621.GA7387@rob-hp-laptop>
References: <1527606359-19261-1-git-send-email-jacopo+renesas@jmondi.org>
 <1527606359-19261-5-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1527606359-19261-5-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 29, 2018 at 05:05:55PM +0200, Jacopo Mondi wrote:
> Describe optional endpoint property 'data-enable-active' for R-Car VIN.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
> v3:
> - new patch
> ---
> 
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 2 ++
>  1 file changed, 2 insertions(+)

Reviewed-by: Rob Herring <robh@kernel.org>
