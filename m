Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:43191 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932749AbeFLN35 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 09:29:57 -0400
Date: Tue, 12 Jun 2018 15:29:49 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, horms@verge.net.au,
        geert@glider.be, mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 6/8] dt-bindings: rcar-vin: Add 'hsync-as-de' custom
 prop
Message-ID: <20180612132949.GB4952@w540>
References: <1527606359-19261-1-git-send-email-jacopo+renesas@jmondi.org>
 <1527606359-19261-7-git-send-email-jacopo+renesas@jmondi.org>
 <20180604121933.GG19674@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ylS2wUBXLOxYXZFQ"
Content-Disposition: inline
In-Reply-To: <20180604121933.GG19674@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ylS2wUBXLOxYXZFQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,

On Mon, Jun 04, 2018 at 02:19:33PM +0200, Niklas S=C3=B6derlund wrote:
> Hi Jacopo,
>
> Thanks for your work.
>
> On 2018-05-29 17:05:57 +0200, Jacopo Mondi wrote:
> > Document the boolean custom property 'renesas,hsync-as-de' that indicat=
es
> > that the HSYNC signal is internally used as data-enable, when the
> > CLKENB signal is not connected.
> >
> > As this is a VIN specificity create a custom property specific to the R=
-Car
> > VIN driver.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> > v3:
> > - new patch
> > ---
> >  Documentation/devicetree/bindings/media/rcar_vin.txt | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Doc=
umentation/devicetree/bindings/media/rcar_vin.txt
> > index ff53226..024c109 100644
> > --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> > +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> > @@ -60,6 +60,9 @@ from local SoC CSI-2 receivers (port1) depending on S=
oC.
> >          - vsync-active: see [1] for description. Default is active hig=
h.
> >          - data-enable-active: polarity of CLKENB signal, see [1] for
> >            description. Default is active high.
> > +        - renesas,hsync-as-de: a boolean property to indicate that HSY=
NC signal
> > +          is internally used as data-enable when the CLKENB signal is
> > +          not available.
>
> I'm not sure I like this, is there really a need to add a custom
> property for this? The datasheet states that when the CLKENB pin is not
> connected the driver should enable 'Clock Enable Hsync Select (CHS)'.
> With the new generic property 'data-enable-active' which describes the
> polarity of the CLKENB pin we also gain the knowledge if the CLKENB pin
> is connected or not.

That was my first proposal, we discussed that in
Re: [PATCH 3/6] media: rcar-vin: Handle data-active property
Re: [PATCH 2/6] dt-bindings: media: rcar-vin: Document data-active

Let's sum it up in this way:
Instead of having to deal again with the "what happens if there is no
data-enable-active and we're running on BT.656 where there is no HSYNC sign=
al"[1]
I decided to go with a custom property.

>
> I propose we drop this custom property and instead let the driver check
> if the CLKENB polarity is described or not and use that to determine if
> CHS bit should be set or not. IMHO that is much simpler then having two
> properties describing the same pin.
>

It is my understanding that both Gen2 and Gen3 boards CVBS input are
BT.656 and none of them has CLKENB input. So 'data-enable-active' is
never there but in this case we should not set CHS. So the absence of
'data-enable-active' has different consequences if we're running on
parallel or BT.656 bus, and that feels confusing to me, so I decided
to make it an explicit property.

Also, as the interface manual describes the "use HSYNC in place of CLKENB"
when on parallel bus as a design choice, that should imo be documented.

Again, this is very minor stuff. I'll leave this out from next
version, maybe we can talk about this f2f next week.

Thanks
  j

> >
> >          If both HSYNC and VSYNC polarities are not specified, embedded
> >          synchronization is selected.
> > --
> > 2.7.4
> >
>
> --
> Regards,
> Niklas S=C3=B6derlund

--ylS2wUBXLOxYXZFQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbH8rNAAoJEHI0Bo8WoVY8wMEQALpFZlqVlYoYO/BkQNg3kluS
8O4wCsG6lWDr92nKrDdo/vPpyfkgD8NkTUQrXl6pSjDyazPDq9MgIyuHvoxy4VYR
BV3bbb6RAbYB2uSXa0O58T0C0qfeskmEsHE7e1EY/sZSBGYcNbOsUHyX1rl+LNZp
6ZpslMtOb15z+P5UHAPIOQmMf+YKq6uijXpv2e7VHvK2Y4MplvRqBISMgl2fMbdx
qCkiI0caiTC9AZ3YPnMJnOjm8z5OyZnDp5rxCRpX4/vIwMZUqJ3Bk8KzXmVt9s/j
ByeOjjRX4i5HPSiEkfUrXO6Xv74QCWzTSFXyOoWTXZWeEEmkTlRIeBxiLdFMcYjm
7GaE2Y56HFnf5LuLp6Rhr31HyyIVhu3YcB/1DtTpGTQtlJdn/snx5jr4KFtDlOgD
YlsCqYOHKlwZJbkD3WseL688rjMyUKCgdl3AVKnOR9TI6U54Z65MEXxAm7RasSA6
9NIcdM2KvF/DRc4iHSVt2kncObdCtqLIvhTsQgxhDihXAdE51Ar0Ad5p3hyd1Khh
UltIPE7S8yvfepr1mDiCARMJdNZ7o44SO55bfpMgz3hpxJOE4/6NO+6K1gKk3LUG
kgeVBkJfDBpkM9uMjTMTct0v7YVgzvVuf8zv4vvqYkoESfew8jwqbK9QXTi4VDfi
1+tLtGULd7VL1TL+TSdX
=2aNA
-----END PGP SIGNATURE-----

--ylS2wUBXLOxYXZFQ--
