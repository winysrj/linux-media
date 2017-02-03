Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33897 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751717AbdBCLus (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Feb 2017 06:50:48 -0500
Date: Fri, 3 Feb 2017 12:50:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: robh+dt@kernel.org, devicetree@vger.kernel.org,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCHv2] dt: bindings: Add support for CSI1 bus
Message-ID: <20170203115045.GA1350@amd>
References: <20161228183036.GA13139@amd>
 <20170111225335.GA21553@amd>
 <20170119214905.GD3205@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <20170119214905.GD3205@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> > +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> > @@ -76,6 +76,11 @@ Optional endpoint properties
> >    mode horizontal and vertical synchronization signals are provided to=
 the
> >    slave device (data source) by the master device (data sink). In the =
master
> >    mode the data source device is also the source of the synchronizatio=
n signals.
> > +- bus-type: data bus type. Possible values are:
> > +  0 - MIPI CSI2
> > +  1 - parallel / Bt656
> > +  2 - MIPI CSI1
> > +  3 - CCP2
>=20
> Actually, thinking about this again --- we only need to explictly specify
> busses if we're dealing with either CCP2 or CSI-1. The vast majority of t=
he
> actual busses are and continue to be CSI-2 or either parallel or Bt.656. =
As
> they can be implicitly detected, we would have an option to just drop val=
ues
> 0 and 1 from above, i.e. only leave CSI-1 and CCP2. For now, specifying
> CSI-2 or parallel / Bt.656 adds no value as the old DT binaries without
> bus-type will need to be supported anyway.

Hmm. "Just deleting the others" may be a bit confusing... but what
about this? It explains what we can autodetect.

Best regards,
								Pavel

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b=
/Documentation/devicetree/bindings/media/video-interfaces.txt
index 08c4498..d54093b 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -77,10 +77,10 @@ Optional endpoint properties
   slave device (data source) by the master device (data sink). In the mast=
er
   mode the data source device is also the source of the synchronization si=
gnals.
 - bus-type: data bus type. Possible values are:
-  0 - MIPI CSI2
-  1 - parallel / Bt656
-  2 - MIPI CSI1
-  3 - CCP2
+  0 - autodetect based on other properties (MIPI CSI2, parallel, Bt656)
+  1 - MIPI CSI1
+  2 - CCP2
+  Autodetection is default, and bus-type property may be omitted in that c=
ase.
 - bus-width: number of data lines actively used, valid for the parallel bu=
sses.
 - data-shift: on the parallel data busses, if bus-width is used to specify=
 the
   number of data lines, data-shift can be used to specify which data lines=
 are


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAliUbpUACgkQMOfwapXb+vKpWgCgjqqV/Dkmc42a5e2en6Xvoq4d
WO8AoIgDGWMJI4yUfUDFFqvOsAYAz6hm
=oRA4
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
