Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f52.google.com ([74.125.83.52]:42608 "EHLO
        mail-pg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932159AbeFZT4V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Jun 2018 15:56:21 -0400
Date: Tue, 26 Jun 2018 13:56:18 -0600
From: Rob Herring <robh@kernel.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH/RFC 1/2] media: dt-bindings: adv748x: Fix decimal unit
 addresses
Message-ID: <20180626195618.GA30143@rob-hp-laptop>
References: <1528984088-24801-1-git-send-email-geert+renesas@glider.be>
 <1528984088-24801-2-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1528984088-24801-2-git-send-email-geert+renesas@glider.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 14, 2018 at 03:48:07PM +0200, Geert Uytterhoeven wrote:
> With recent dtc and W=1:
> 
>     Warning (graph_port): video-receiver@70/port@10: graph node unit address error, expected "a"
>     Warning (graph_port): video-receiver@70/port@11: graph node unit address error, expected "b"
> 
> Unit addresses are always hexadecimal (without prefix), while the bases
> of reg property values depend on their prefixes.
> 
> Fixes: e69595170b1cad85 ("media: adv748x: Add adv7481, adv7482 bindings")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  Documentation/devicetree/bindings/media/i2c/adv748x.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Rob Herring <robh@kernel.org>
