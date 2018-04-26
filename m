Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:52639 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752148AbeDZH0n (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 03:26:43 -0400
Date: Thu, 26 Apr 2018 09:26:09 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Simon Horman <horms@verge.net.au>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, geert@linux-m68k.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: dts: r8a7740: Enable CEU0
Message-ID: <20180426072609.GH17088@w540>
References: <1524654920-18749-1-git-send-email-jacopo+renesas@jmondi.org>
 <1524654920-18749-3-git-send-email-jacopo+renesas@jmondi.org>
 <20180426061124.hvgl3ijf6ulrdkmn@verge.net.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Q6STzHxy03qt/hK9"
Content-Disposition: inline
In-Reply-To: <20180426061124.hvgl3ijf6ulrdkmn@verge.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Q6STzHxy03qt/hK9
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Simon,

On Thu, Apr 26, 2018 at 08:11:30AM +0200, Simon Horman wrote:
> Thanks Jacopo,
>
> I'm very pleased to see this series.

Credits to Geert that pointed out to me R-Mobile A1 comes with a CEU.
I should mention him in next iteration actually, sorry about that.

>
> On Wed, Apr 25, 2018 at 01:15:20PM +0200, Jacopo Mondi wrote:
> > Enable CEU0 peripheral for Renesas R-Mobile A1 R8A7740.
>
> Given 'status = "disabled"' below I think you
> are describing but not enabling CEU0. Also in the subject.

Right.

>
> Should we also describe CEU1?

Armadillo board file only describe CEU0. If there are R-Mobile A1
board files where I can steal informations from I can do that. If
there's a public datasheet, that would be even better.
>
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  arch/arm/boot/dts/r8a7740.dtsi | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/arch/arm/boot/dts/r8a7740.dtsi b/arch/arm/boot/dts/r8a7740.dtsi
> > index afd3bc5..05ec41e 100644
> > --- a/arch/arm/boot/dts/r8a7740.dtsi
> > +++ b/arch/arm/boot/dts/r8a7740.dtsi
> > @@ -67,6 +67,16 @@
> >  		power-domains = <&pd_d4>;
> >  	};
> >
> > +	ceu0: ceu@fe910000 {
> > +		reg = <0xfe910000 0x100>;
>
> Should the size of the range be 0x3000 ?
> That would seem to match my reading of table 32.3
> and also be consistent with r7s72100.dtsi.

I got this from

static struct resource ceu0_resources[] = {
	[0] = {
		.name	= "CEU",
		.start	= 0xfe910000,
		.end	= 0xfe91009f,
		.flags	= IORESOURCE_MEM,
	},
but I also noticed the r7s72100 one was bigger.
I'm fine enlarging this, if that's what the manual reports too.

> > +		compatible = "renesas,r8a7740-ceu";
> > +		interrupts = <GIC_SPI 160 IRQ_TYPE_LEVEL_HIGH>;
> > +		clocks = <&mstp1_clks R8A7740_CLK_CEU20>;
> > +		clock-names = "ceu20";
> > +		power-domains = <&pd_a4mp>;
>
> My reading of table 1.7 is that the power domain should be A4R (&pd_a4r).

Ah yes, my bad.

The long time goal would be describe the camera module (mt9t112) which
is installed on armadillo. Unfortunately that would probably require
some more work on the CEU side.

Thanks
   j

>
> > +		status = "disabled";
> > +	};
> > +
> >  	cmt1: timer@e6138000 {
> >  		compatible = "renesas,cmt-48-r8a7740", "renesas,cmt-48";
> >  		reg = <0xe6138000 0x170>;
> > --
> > 2.7.4
> >

--Q6STzHxy03qt/hK9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa4X8RAAoJEHI0Bo8WoVY82XIP/RDgvPffkjSFo/rfbxZvVy8Z
eKyaRX0oSCzIMcd4PrHfzcwvpvhJSLKkITMt8XyHWG2ce0Xy3eLJ1ttkSMN8zbdc
DB5ieEu4/sksBo7lDPLIfp0cf6vNYIdghGPdluxefc/1LBOBrbxp78GJSEL43WYL
Tz0W33yOCkQxC3l3z23QjP+oQH3lUkQWdtFVjKQUHM4KyguUHJ7V0WQs8oyI3Mos
8EaOYHM/xZzXbnq1Uju1WsEAYb22//232iLZoT62AEpv0VcqZWgY4nbuDzzokuw0
yFs7/nYndU5ZssfLOPmhYWwxHQ+2a//7NGLkR7UPpcbCC3bSuRCOHVPkBsIKoqPl
ZPO3+Q0Al/HusBi7YdSBTZTVdILcgNYY+UstJWHE1j9W3RP4LKxl5I4ofO70fPxI
ENVht5W1tSAcwjj+u0kN54dduZLHMP3t8V2PwlJR5KPEOrGdgLjuLdNy0HNTZeDE
neUJMTEbFqgay0oli+VhsXmx332rWwGRkXHcbN2bzQPGmb209FXn+P7Bs+bbLeS7
9zs3pkL7vAcrmpj6SBYlWqZrPUhfdZ9LRaxLMxkH6nbf2kaONnDt51tSl+bVpcvr
giycfNoxiYAFDEJ+xDxciRcmQ8717BSfMg9hoG1jGBYQDvka4p0jjowm3si0ex/9
sj6z720geab7BK5UUR/M
=w6OS
-----END PGP SIGNATURE-----

--Q6STzHxy03qt/hK9--
