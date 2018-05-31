Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:37496 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932527AbeEaDN5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 23:13:57 -0400
Date: Wed, 30 May 2018 22:13:53 -0500
From: Rob Herring <robh@kernel.org>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 1/8] dt-bindings: media: rcar-vin: Describe optional
 ep properties
Message-ID: <20180531031353.GA4440@rob-hp-laptop>
References: <1527606359-19261-1-git-send-email-jacopo+renesas@jmondi.org>
 <1527606359-19261-2-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1527606359-19261-2-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 29, 2018 at 05:05:52PM +0200, Jacopo Mondi wrote:
> Describe the optional endpoint properties for endpoint nodes of port@0
> and port@1 of the R-Car VIN driver device tree bindings documentation.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> 
> ---
> v2 -> v3:
> - Do not repeat property description, just reference video-interfaces.txt
> - Indent with spaces, not tabs as the rest of the document
> - Do not remove (yet) the 'bus-width' property from example
> ---
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 10 ++++++++++
>  1 file changed, 10 insertions(+)

Reviewed-by: Rob Herring <robh@kernel.org>
