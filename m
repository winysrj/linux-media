Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57329 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751172AbdH1LJy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 07:09:54 -0400
Date: Mon, 28 Aug 2017 13:09:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, javier@dowhile0.org,
        jacek.anaszewski@gmail.com, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v2 1/3] dt: bindings: Document DT bindings for Analog
 devices as3645a
Message-ID: <20170828110951.GC492@amd>
References: <20170819212410.3084-1-sakari.ailus@linux.intel.com>
 <20170819212410.3084-2-sakari.ailus@linux.intel.com>
 <20170828103351.GF18012@amd>
 <46aaf723-a657-3b43-7be7-8d899d3db9c3@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="iFRdW5/EC4oqxDHL"
Content-Disposition: inline
In-Reply-To: <46aaf723-a657-3b43-7be7-8d899d3db9c3@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--iFRdW5/EC4oqxDHL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Thanks for the review!
>=20
> On 08/28/17 13:33, Pavel Machek wrote:
> > Hi!
> >=20
> >> +
> >> +Ranges below noted as [a, b] are closed ranges between a and b, i.e. a
> >> +and b are included in the range.
> >=20
> > Normally I've seen <a, b> for closed ranges, (a, b) for open
> > ranges. Is that different in your country?
>=20
> I guess there are different notations. :-) I've seen regular parentheses
> being used for open ranges, too, but not < and >.
>=20
> Open range is documented in a related well written Wikipedia article:
>=20
> <URL:https://en.wikipedia.org/wiki/Open_range>
>=20
> Are there such open ranges in Czechia? For instance, reindeer generally
> roam freely in Finnish Lappland.

:-). Well, we have pigs and roes roaming freely in the woods, but
would not normally call it open range.

> What comes to the patch, I guess "interval" could be a more appropriate
> term to use in this case:
>=20
> <URL:https://en.wikipedia.org/wiki/Interval_(mathematics)>
>=20
> The patch is in line with the Wikipedia article in notation but not in
> terminology. I'll send a fix.

Ok, that was really nitpicking, thanks!
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--iFRdW5/EC4oqxDHL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlmj+f8ACgkQMOfwapXb+vKT8wCeP7CFUOb2o/Zi58xXCmOWFDTE
cngAnjV1r76Q6zIJ8X28ISzD+isjVrwk
=ZoXD
-----END PGP SIGNATURE-----

--iFRdW5/EC4oqxDHL--
