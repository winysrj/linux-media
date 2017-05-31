Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36608 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750951AbdEaRhU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 13:37:20 -0400
Date: Wed, 31 May 2017 19:37:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Daniel Mack <daniel@zonque.org>, Rob Herring <robh@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        sebastian.reichel@collabora.co.uk
Subject: Re: [RFC v2 3/3] dt: bindings: Add a binding for referencing EEPROM
 from camera sensors
Message-ID: <20170531173718.GA11983@amd>
References: <1493974110-26510-1-git-send-email-sakari.ailus@linux.intel.com>
 <1493974110-26510-4-git-send-email-sakari.ailus@linux.intel.com>
 <20170508172418.zha3eyfsnuricfjk@rob-hp-laptop>
 <20170529122004.GE29527@valkosipuli.retiisi.org.uk>
 <c7a98681-4c95-0103-96ee-97ca6a02d9b3@zonque.org>
 <20170529130524.GF29527@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
In-Reply-To: <20170529130524.GF29527@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > I agree, yes. I think the only way to solve this is to have a generic
> > EEPROM API that allows the camera sensor to read data from it. If
>=20
> We have one already, and it's defined in Documentation/misc-devices/eepro=
m .
>=20
> > another vendor uses a different type of EEPROM, the sensor driver would
> > remain the same, as it only reads data from the storage behind the
> > phandle, not caring about the details.
> >=20
> > Same goes for the lens driver, and after thinking about it for awhile,
> > I'd say it makes most sense to allow referencing a v4l2_subdev device
> > through a phandle from another v4l2_subdev, and then offload certain
> > commands such as V4L2_CID_FOCUS_ABSOLUTE to the device that does the
> > actual work. Opinions?
>=20
> There are different kinds of lens systems and I don't think the sensor
> drivers should be aware of them. The current approach is that the lens is=
 a
> separate sub-device --- the intent of the patchset I posted was to docume=
nt
> how the information on the related lens and eeprom components is conveyed=
 to
> the software. There's one such driver in the mainline kernel, ad5820.
>=20
> Unfortunately we don't right now have a good user space interface for
> telling which sensor a lens device is related to. The struct
> media_entity_desc does have a group_id field for grouping the sub-devices
> but that's hardly a good way to describe this.

Yeah, it would be good to get the corresponding patches to be merged
to v4l-utils...

								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlku/04ACgkQMOfwapXb+vJ+qACgn6EYKhVRZSY6hYXty1C2e85C
pZQAnRRUOYXCSTDh4iKat5vI9H2yXK0j
=eOq3
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
