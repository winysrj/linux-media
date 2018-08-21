Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:59329 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbeHUKEF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Aug 2018 06:04:05 -0400
Date: Tue, 21 Aug 2018 08:45:05 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Rob Herring <robh@kernel.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, geert@linux-m68k.org,
        horms@verge.net.au, mark.rutland@arm.com,
        kieran.bingham+renesas@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, damm+renesas@opensource.se,
        ulrich.hecht+renesas@gmail.com, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [RFT 1/8] media: dt-bindings: media: rcar-vin: Add R8A77990
 support
Message-ID: <20180821064505.GG30122@w540>
References: <1534760202-20114-1-git-send-email-jacopo+renesas@jmondi.org>
 <1534760202-20114-2-git-send-email-jacopo+renesas@jmondi.org>
 <20180820223947.GA7090@bogus>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="RMedoP2+Pr6Rq0N2"
Content-Disposition: inline
In-Reply-To: <20180820223947.GA7090@bogus>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--RMedoP2+Pr6Rq0N2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Rob,

On Mon, Aug 20, 2018 at 05:39:47PM -0500, Rob Herring wrote:
> On Mon, Aug 20, 2018 at 12:16:35PM +0200, Jacopo Mondi wrote:
> > Add compatible string for R-Car E3 R8A77990 to the list of SoCs supported by
> > rcar-vin driver.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  Documentation/devicetree/bindings/media/rcar_vin.txt | 1 +
> >  1 file changed, 1 insertion(+)
>
> Why the inconsistent subjects for patches 1 and 3?
>

Beacause I initially used "dt-bindings: media" for both then later realized all
other patches were "media: dt-bindings" and just fixed the first one :/

Sorry for being sloppy, I'll fix in v2.

Thanks
   j

> Otherwise,
>
> Reviewed-by: Rob Herring <robh@kernel.org>

--RMedoP2+Pr6Rq0N2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbe7TwAAoJEHI0Bo8WoVY8xcgQAKhEC4GHbxL0yVJIXXeG4FNT
GIJGR6kWEhIU8R14ziJ10jajqJQVWKWk9c8S6awbquMiMAnpjMn3U1VYI5gww/oJ
1axpikUxpEGr0+8uzCG43GINkDgp2ngN5DgkAIxYb7RmQPxPFcHy9We7IY/m0FlO
+RIA9ab28Di+npfIYsphkAtTB9xuzpAxWVlN2o7LFDLazuwnJ7y99Yt3f1/ZKj5L
tHweeQ8Z4muo4OIkx01nXkjSfsY0dZnj4DvrrZ3utWl90K8RXnfb0az7y91CTzcT
GJEM/2igk+UpKUCNzYnI05NxxTCHwrxvPae8OhalCEx85ZAye6naoBnkgayjg7sx
Ik6mr+v9pTJ4HWBrPPHJ54xhlYkluAdsWPi590x5cs8OYqlkcyeyMRpR7Zl2arZU
PJ2imTtUMx9zUMbctzSF5T+HpKfWyVY5f3xWlvM9wT9ghl9gasDK6eyQe4NiQrOA
mfkTonpLb7DQt6G/uw3hKQHYk73h2xNMzRVP5ODTKi4gXWe8tvX/ZyzwUScKqNIR
Zk2NzlMqza0VHYkFMEfLbVZ/siuhp3iCUpIDlTtxt1r/Ll8mH03PJbX2TfWARt41
wtFPRmaiw3y+rnj0mwRX70S6uZdGT53eIos3+dYqo5YMJfobmdMjqljGPO5+nRt4
PiVG+MV9Hb3eSd3X0+nd
=WqRU
-----END PGP SIGNATURE-----

--RMedoP2+Pr6Rq0N2--
