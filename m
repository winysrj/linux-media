Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:46469 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932527AbeEaDOx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 23:14:53 -0400
Date: Wed, 30 May 2018 22:14:51 -0500
From: Rob Herring <robh@kernel.org>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 2/8] dt-bindings: media: Document data-enable-active
 property
Message-ID: <20180531031451.GA5215@rob-hp-laptop>
References: <1527606359-19261-1-git-send-email-jacopo+renesas@jmondi.org>
 <1527606359-19261-3-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1527606359-19261-3-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 29, 2018 at 05:05:53PM +0200, Jacopo Mondi wrote:
> Add 'data-enable-active' property to endpoint node properties list.
> 
> The property allows to specify the polarity of the data-enable signal, which
> when in active state determinates when data lanes have to sampled for valid
> pixel data.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
> v3:
> - new patch
> ---
>  Documentation/devicetree/bindings/media/video-interfaces.txt | 2 ++
>  1 file changed, 2 insertions(+)

Reviewed-by: Rob Herring <robh@kernel.org>
