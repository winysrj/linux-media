Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:40829 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbeGMJEM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jul 2018 05:04:12 -0400
Date: Fri, 13 Jul 2018 10:50:26 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Simon Horman <horms@verge.net.au>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, hverkuil@xs4all.nl,
        geert@linux-m68k.org, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH RESEND] dt-bindings: media: rcar-vin: Add R8A77995 support
Message-ID: <20180713085026.GH23629@w540>
References: <1530694296-6417-1-git-send-email-jacopo+renesas@jmondi.org>
 <20180713073159.6q6xlfkpteiaj35e@verge.net.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bpVaumkpfGNUagdU"
Content-Disposition: inline
In-Reply-To: <20180713073159.6q6xlfkpteiaj35e@verge.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--bpVaumkpfGNUagdU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Simon,

On Fri, Jul 13, 2018 at 09:31:59AM +0200, Simon Horman wrote:
> On Wed, Jul 04, 2018 at 10:51:36AM +0200, Jacopo Mondi wrote:
> > Add compatible string for R-Car D3 R8A7795 to list of SoCs supported by
> > rcar-vin driver.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > Acked-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.se>
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
> > ---
> >
> > Re-sending to have this collected with the following series:
> > [PATCH v6 0/10] rcar-vin: Add support for parallel input on Gen3
>
> Jacopo,
>
> Can I pick up the related DTS patches once this one is accepted
> into the media-tree? If so, please ping me once that happens.
>

Yes, please.

Hans collected this one already and it's now in the media tree master
branch.

Thanks
   j



> >
> > Thanks
> >   j
> > ---
> >  Documentation/devicetree/bindings/media/rcar_vin.txt | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Doc=
umentation/devicetree/bindings/media/rcar_vin.txt
> > index a19517e1..5c6f2a7 100644
> > --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> > +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> > @@ -22,6 +22,7 @@ on Gen3 platforms to a CSI-2 receiver.
> >     - "renesas,vin-r8a7795" for the R8A7795 device
> >     - "renesas,vin-r8a7796" for the R8A7796 device
> >     - "renesas,vin-r8a77970" for the R8A77970 device
> > +   - "renesas,vin-r8a77995" for the R8A77995 device
> >     - "renesas,rcar-gen2-vin" for a generic R-Car Gen2 or RZ/G1 compati=
ble
> >       device.
> >
> > --
> > 2.7.4
> >

--bpVaumkpfGNUagdU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbSGfPAAoJEHI0Bo8WoVY8X5IQALJ+QwMzmftaGlq+vYrAH47W
M6TuYO+fLBu6lG03jlQUxiH6C8ZCtZw2BXy6i439lcUwLlfKl4A2e5tvJdt/HO2M
Mxp5fRf1YWVSVmHBz9AqU2IR47m4x8IhGcYQMeDdWu1kOY4rw8O92Mir+IO8my67
8gpXjWNj1lTUa1LOVLPkCLppiR0mbfUjnESZZJ2elCzn5ppsDUlcCvloKkCyoXjN
7Jny1zmVClCN/KCgnmsYiNb+EepD0R5P4D38jupcuLGjIvKbP98iPwyCjMiUnBzs
VhJak0d8QmW/m36gJN3SZ7O5AHc3fQyNHXSKBKZ1UZZgx9wVub87IqhGykIvUR/x
ryNufkbmdfjgVrlIVvIwEPBeF7mhbkueFCbzhsZO6mZqUNPMWM9c3IJz0muvgh4p
Yuip26Btso0o/UmvGG47H9oAbwvsZvXXAHEv7faO09tunvavbU62vemDCyor4Aoa
jgTUCpYPNNEKuceDx22sI/5qHQk2N6UfGQCx5ZjveLZ6J1kNeNmExqzOC0A1MW4M
3kV241u0NC0RPOTd206vb5BUX4BXZc5QUJNapbSB3eOCMj1cRzsFeluRXOblkTUe
6M3LHzPY/3m5oHucS5knQOqpCwP3UiE636VwaDW5ro5aXhKb+YcYgtDs4yb0t8Ab
pfVmq6V3Fvp+6f2V2EnA
=aeNZ
-----END PGP SIGNATURE-----

--bpVaumkpfGNUagdU--
