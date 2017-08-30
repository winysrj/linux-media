Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33130 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751242AbdH3KJv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 06:09:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] [media] v4l: vsp1: Use generic node name
Date: Wed, 30 Aug 2017 13:10:26 +0300
Message-ID: <1912736.Rz1RIKoiZO@avalon>
In-Reply-To: <1504087051-5449-1-git-send-email-geert+renesas@glider.be>
References: <1504087051-5449-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

Thank you for the patch.

On Wednesday, 30 August 2017 12:57:31 EEST Geert Uytterhoeven wrote:
> Use the preferred generic node name in the example.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  Documentation/devicetree/bindings/media/renesas,vsp1.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/renesas,vsp1.txt
> b/Documentation/devicetree/bindings/media/renesas,vsp1.txt index
> 9b695bcbf2190bdd..16427017cb45561e 100644
> --- a/Documentation/devicetree/bindings/media/renesas,vsp1.txt
> +++ b/Documentation/devicetree/bindings/media/renesas,vsp1.txt
> @@ -22,7 +22,7 @@ Optional properties:
> 
>  Example: R8A7790 (R-Car H2) VSP1-S node
> 
> -	vsp1@fe928000 {
> +	vsp@fe928000 {

vsp1 isn't an instance name but an IP core name.

>  		compatible = "renesas,vsp1";
>  		reg = <0 0xfe928000 0 0x8000>;
>  		interrupts = <0 267 IRQ_TYPE_LEVEL_HIGH>;


-- 
Regards,

Laurent Pinchart
