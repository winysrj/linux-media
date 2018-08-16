Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:53550 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728858AbeHPLhw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Aug 2018 07:37:52 -0400
Reply-To: kieran.bingham+renesas@ideasonboard.com
Subject: Re: [PATCH/RFC 1/2] media: dt-bindings: adv748x: Fix decimal unit
 addresses
To: Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <1528984088-24801-1-git-send-email-geert+renesas@glider.be>
 <1528984088-24801-2-git-send-email-geert+renesas@glider.be>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <ec3c39d5-17a6-50f2-b54d-d30c89aadf1f@ideasonboard.com>
Date: Thu, 16 Aug 2018 09:40:50 +0100
MIME-Version: 1.0
In-Reply-To: <1528984088-24801-2-git-send-email-geert+renesas@glider.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

On 14/06/18 14:48, Geert Uytterhoeven wrote:
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
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/adv748x.txt b/Documentation/devicetree/bindings/media/i2c/adv748x.txt
> index 21ffb5ed818302ff..54d1d3bc186949fa 100644
> --- a/Documentation/devicetree/bindings/media/i2c/adv748x.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/adv748x.txt
> @@ -73,7 +73,7 @@ Example:
>  			};
>  		};
>  
> -		port@10 {
> +		port@a {
>  			reg = <10>;
>  
>  			adv7482_txa: endpoint {
> @@ -83,7 +83,7 @@ Example:
>  			};
>  		};
>  
> -		port@11 {
> +		port@b {
>  			reg = <11>;
>  
>  			adv7482_txb: endpoint {
> 

Just looking back through these patches, to make sure they get integrated.

Having read yours and Robs responses, I do agree that this is a correct fix.

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
