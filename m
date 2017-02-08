Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44094 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751092AbdBHWaV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Feb 2017 17:30:21 -0500
Date: Wed, 8 Feb 2017 23:30:18 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Rob Herring <robh@kernel.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, devicetree@vger.kernel.org,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devicetree: Add video bus switch
Message-ID: <20170208223017.GA18807@amd>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161222133938.GA30259@amd>
 <20161224152031.GA8420@amd>
 <20170203123508.GA10286@amd>
 <20170208213609.lnemfbzitee5iur2@rob-hp-laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <20170208213609.lnemfbzitee5iur2@rob-hp-laptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2017-02-08 15:36:09, Rob Herring wrote:
> On Fri, Feb 03, 2017 at 01:35:08PM +0100, Pavel Machek wrote:
> >=20
> > N900 contains front and back camera, with a switch between the
> > two. This adds support for the switch component, and it is now
> > possible to select between front and back cameras during runtime.
> >=20
> > This adds documentation for the devicetree binding.
> >=20
> > Signed-off-by: Sebastian Reichel <sre@kernel.org>
> > Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> >=20
> >=20
> > diff --git a/Documentation/devicetree/bindings/media/video-bus-switch.t=
xt b/Documentation/devicetree/bindings/media/video-bus-switch.txt
> > new file mode 100644
> > index 0000000..1b9f8e0
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/video-bus-switch.txt
> > @@ -0,0 +1,63 @@
> > +Video Bus Switch Binding
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>=20
> I'd call it a mux rather than switch.

It is a switch, not a multiplexor (
https://en.wikipedia.org/wiki/Multiplexing ). Only one camera can
operate at a time.

> BTW, there's a new mux-controller binding under review you might look=20
> at. It would only be needed here if the mux ctrl also controls other=20
> things.

Do you have a pointer?

> > +Required Port nodes
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +More documentation on these bindings is available in
> > +video-interfaces.txt in the same directory.
> > +
> > +reg		: The interface:
> > +		  0 - port for image signal processor
> > +		  1 - port for first camera sensor
> > +		  2 - port for second camera sensor
>=20
> This could be used for display side as well. So describe these just as=20
> inputs and outputs.

I'd prefer not to confuse people. I guess that would be 0 -- output
port, 1, 2 -- input ports... But this is media data, are you sure it
is good idea to change this?

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlibm/kACgkQMOfwapXb+vICSwCgmlj2icghfhg3FyPhVYj6YgLO
r2cAnieWslJV+DG14qFtG7j6lYQRsfyB
=wQnK
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
