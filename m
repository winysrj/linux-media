Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:54509 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755635AbeDWPVw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 11:21:52 -0400
Date: Mon, 23 Apr 2018 17:21:43 +0200
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
Message-ID: <20180423152143.GH3999@w540>
References: <1519235284-32286-1-git-send-email-jacopo+renesas@jmondi.org>
 <1519235284-32286-5-git-send-email-jacopo+renesas@jmondi.org>
 <20180221182918.fbxnhdl4r4y3ejfj@verge.net.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="RwxaKO075aXzzOz0"
Content-Disposition: inline
In-Reply-To: <20180221182918.fbxnhdl4r4y3ejfj@verge.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--RwxaKO075aXzzOz0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Simon,

On Wed, Feb 21, 2018 at 07:29:18PM +0100, Simon Horman wrote:
> On Wed, Feb 21, 2018 at 06:47:58PM +0100, Jacopo Mondi wrote:
> > Add Capture Engine Unit (CEU) node to device tree.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>
> This patch depends on the binding for "renesas,r7s72100-ceu".
> Please repost or otherwise ping me once that dependency has been accepted.

Bindings for the CEU interface went in v4.17-rc1.

Could you please resurect this patch?

Thanks
   j

--RwxaKO075aXzzOz0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa3foHAAoJEHI0Bo8WoVY88jgP/jwL5jYnW1PO6nNMb2aW2DdP
lB6YSXYDY25gsU3XZH544VzEmi6Wj2ynXGqKNlkTuWubcvmbvXtMEUqoVuOIfnte
TJhBphhttylk5yhxXK7MpaxDZ5zeD/mnhSsKr55ZIV6M+4g/7AZAESLif4eoJbeL
y0v44ngRjol2VJPFSI9S4lm9jiWy5Vi+LG8OFR4mfCkRO9WbCMIuUpehucEQNnWw
eUnpgr8DnPMCUodbTBxM3E8+3FGZq/EaD9ucNjkxZ5Sb/7wkrfgK37uX6EUuewp8
51b5ZK8Q9vTnuRnKmhmnEVL19GXAdJga5uSPhnbV7t2rabb1awWoXHX1fLvKzjWn
Ag5pTjdT7c0mSykQYS48PiQljRBjBT7qh5laUJ/TKH1xHB62eoBFmjkO8z8Tv4K+
pZA6myEgHSRjI+CerdnzWOn2QmB5i8AmP7f8tbto6EfGMv7Bb3/RBY36cpjkVnhO
hHKbvwiS1EWBoGyeyGneFdbaFYvWhlBUzdlkIMrmOuZM8mQWc0zJhokOS7XQUkik
1WK17peJPt/XOZGiBDX2aQIuVyntyqJGFXbSLNWsMD5Hy+3whA2bFMr+OJxjMx43
pftCR0plJYxIvhLUCIAoiQSRCsVPNtiO/tTmKmknkzx5cDU5cH4jqEkTdJSqhtdr
IlJgVoiaZ+bwN4ko8IZm
=9cTo
-----END PGP SIGNATURE-----

--RwxaKO075aXzzOz0--
