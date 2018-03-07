Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:43147 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754039AbeCGV7W (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2018 16:59:22 -0500
Date: Wed, 7 Mar 2018 15:59:20 -0600
From: Rob Herring <robh@kernel.org>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Yong Deng <yong.deng@magewell.com>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, Chen-Yu Tsai <wens@csie.org>
Subject: Re: [PATCH 1/4] dt-bindings: media: sun6i: Add A31 and H3 compatibles
Message-ID: <20180307215920.wwfhj2yaf7qbssyx@rob-hp-laptop>
References: <20180305100432.15009-1-maxime.ripard@bootlin.com>
 <20180305100432.15009-2-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180305100432.15009-2-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 05, 2018 at 11:04:29AM +0100, Maxime Ripard wrote:
> The H3 has a slightly different CSI controller (no BT656, no CCI) which
> looks a lot like the original A31 controller. Add a compatible for the A31,
> and more specific compatible the for the H3 to be used in combination for
> the A31.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  Documentation/devicetree/bindings/media/sun6i-csi.txt | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Reviewed-by: Rob Herring <robh@kernel.org>
