Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:43793 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932837AbeDXIbS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 04:31:18 -0400
Date: Tue, 24 Apr 2018 10:31:11 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Simon Horman <horms@verge.net.au>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, hverkuil@xs4all.nl, mchehab@kernel.org,
        festevam@gmail.com, sakari.ailus@iki.fi, robh+dt@kernel.org,
        mark.rutland@arm.com, pombredanne@nexb.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 04/10] ARM: dts: r7s72100: Add Capture Engine Unit
 (CEU)
Message-ID: <20180424083111.GG17088@w540>
References: <1519235284-32286-1-git-send-email-jacopo+renesas@jmondi.org>
 <1519235284-32286-5-git-send-email-jacopo+renesas@jmondi.org>
 <20180221182918.fbxnhdl4r4y3ejfj@verge.net.au>
 <20180423152143.GH3999@w540>
 <20180424082355.y2cnfkqa7bj4fpy4@verge.net.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="O8XZ+2Hy8Kj8wLPZ"
Content-Disposition: inline
In-Reply-To: <20180424082355.y2cnfkqa7bj4fpy4@verge.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--O8XZ+2Hy8Kj8wLPZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Simon,

On Tue, Apr 24, 2018 at 10:23:56AM +0200, Simon Horman wrote:
> On Mon, Apr 23, 2018 at 05:21:43PM +0200, jacopo mondi wrote:
> > Hi Simon,
> >
> > On Wed, Feb 21, 2018 at 07:29:18PM +0100, Simon Horman wrote:
> > > On Wed, Feb 21, 2018 at 06:47:58PM +0100, Jacopo Mondi wrote:
> > > > Add Capture Engine Unit (CEU) node to device tree.
> > > >
> > > > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > > > Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > > > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > >
> > > This patch depends on the binding for "renesas,r7s72100-ceu".
> > > Please repost or otherwise ping me once that dependency has been accepted.
> >
> > Bindings for the CEU interface went in v4.17-rc1.
> >
> > Could you please resurect this patch?
>
> Sure, I took the liberty of "rebasing" it to preserve the new node-order
> of r7s72100.dtsi. The result is as follows:

That's even better.

Thanks
   j

>
> From: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Subject: [PATCH] ARM: dts: r7s72100: Add Capture Engine Unit (CEU)
>
> Add Capture Engine Unit (CEU) node to device tree.
>
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> [simon: rebased]
> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
> ---
>  arch/arm/boot/dts/r7s72100.dtsi | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/boot/dts/r7s72100.dtsi b/arch/arm/boot/dts/r7s72100.dtsi
> index ecf9516bcda8..4a1aade0e751 100644
> --- a/arch/arm/boot/dts/r7s72100.dtsi
> +++ b/arch/arm/boot/dts/r7s72100.dtsi
> @@ -375,6 +375,15 @@
>  			status = "disabled";
>  		};
>
> +		ceu: camera@e8210000 {
> +			reg = <0xe8210000 0x3000>;
> +			compatible = "renesas,r7s72100-ceu";
> +			interrupts = <GIC_SPI 332 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks = <&mstp6_clks R7S72100_CLK_CEU>;
> +			power-domains = <&cpg_clocks>;
> +			status = "disabled";
> +		};
> +
>  		wdt: watchdog@fcfe0000 {
>  			compatible = "renesas,r7s72100-wdt", "renesas,rza-wdt";
>  			reg = <0xfcfe0000 0x6>;
> @@ -429,9 +438,9 @@
>  			#clock-cells = <1>;
>  			compatible = "renesas,r7s72100-mstp-clocks", "renesas,cpg-mstp-clocks";
>  			reg = <0xfcfe042c 4>;
> -			clocks = <&p0_clk>;
> -			clock-indices = <R7S72100_CLK_RTC>;
> -			clock-output-names = "rtc";
> +			clocks = <&b_clk>, <&p0_clk>;
> +			clock-indices = <R7S72100_CLK_CEU R7S72100_CLK_RTC>;
> +			clock-output-names = "ceu", "rtc";
>  		};
>
>  		mstp7_clks: mstp7_clks@fcfe0430 {
> --
> 2.11.0
>
>

--O8XZ+2Hy8Kj8wLPZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa3utPAAoJEHI0Bo8WoVY83SwQAMcRemJH4whTol5SgaUhhiwt
7vPzUri9leP+smhF8kzP/cmWuGEHIyQKHzqSivVBZrtRHyk2JZCGNMdp0M1lloCv
SCVfyv6R/nnPVKdTqJNZYrTN1yJOcGXle271QLEEZUXkL1aDxy5K5Xb5qpSuwu89
qH1mKj9K39/B/0lmlrn+ENWlVvzewAaZB+WZfFVU89i+4NncFLhx+6gOMceSF8oy
I4PyfNOIEXXGmKiv7v8H0uHJf0yUTK0NgFLLnFrIwueogXuQTitV2dIdjDuF99SR
yOR2XPE+h+Ws1BeqnWX81AdSbAeDj6uC+3VVkjiQ6uwXq6BsCmkyqRvY04xmOgNl
JDwHUYlW/d3D/xs8zYVJ9GxRywKDW48t5kc6MFWxWEPg2DUYV2LrFiwjBGzkcJIv
wctnUSf3/rh2nNAzeeESbgGvdqSM2iZuCA7PElFZZpudj+F6wcQtLZWoaLrzkdiN
3pwLo63R67nRzGIvR2DA3xz3Y9rB58kCFHaOrebBSI//wWRBQgXaaruCm1ebYtXt
3DkKM3uddKTWAkKcEtH8USq1GReGOwZ1CE9vP8zkgKNjoLjEFYHgdRWYKnn5/Fu1
gDMKw6mStzZHNK/phxoDl1xUehaqH3eMp34fUN4dW6NTnxVYuWdYVx3TINacajjm
UT3EmMoeafGOJen5gXDI
=8F7o
-----END PGP SIGNATURE-----

--O8XZ+2Hy8Kj8wLPZ--
