Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:57492 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755194AbeFNPx1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 11:53:27 -0400
Subject: Re: [PATCH/RFC 2/2] arm64: dts: renesas: salvator-common: Fix adv7482
 decimal unit addresses
To: Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <1528984088-24801-1-git-send-email-geert+renesas@glider.be>
 <1528984088-24801-3-git-send-email-geert+renesas@glider.be>
Reply-To: kieran.bingham@ideasonboard.com
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <c748c4ff-c90f-0373-f7fe-b05e48f97745@ideasonboard.com>
Date: Thu, 14 Jun 2018 16:53:22 +0100
MIME-Version: 1.0
In-Reply-To: <1528984088-24801-3-git-send-email-geert+renesas@glider.be>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

On 14/06/18 14:48, Geert Uytterhoeven wrote:
> With recent dtc and W=1:
> 
>      ...salvator-x.dtb: Warning (graph_port): /soc/i2c@e66d8000/video-receiver@70/port@10: graph node unit address error, expected "a"
>      ...salvator-x.dtb: Warning (graph_port): /soc/i2c@e66d8000/video-receiver@70/port@11: graph node unit address error, expected "b"
> 
> Unit addresses are always hexadecimal (without prefix), while the bases
> of reg property values depend on their prefixes.
> 
> Fixes: 908001d778eba06e ("arm64: dts: renesas: salvator-common: Add ADV7482 support")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>   arch/arm64/boot/dts/renesas/salvator-common.dtsi | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/renesas/salvator-common.dtsi b/arch/arm64/boot/dts/renesas/salvator-common.dtsi
> index 320250d708c3bbab..47088206cc052a15 100644
> --- a/arch/arm64/boot/dts/renesas/salvator-common.dtsi
> +++ b/arch/arm64/boot/dts/renesas/salvator-common.dtsi
> @@ -437,7 +437,7 @@
>   			};
>   		};
>   
> -		port@10 {
> +		port@a {
>   			reg = <10>;

This looks a bit ugly with the different mappings;
If we must move to 'port@a', I think reg needs to be <0xa>, to avoid 
confusion. (but I personally prefer port@10, reg = <10> here)


--
Kieran


>   
>   			adv7482_txa: endpoint {
> @@ -447,7 +447,7 @@
>   			};
>   		};
>   
> -		port@11 {
> +		port@b {
>   			reg = <11>;
>   
>   			adv7482_txb: endpoint {
> 
