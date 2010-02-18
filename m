Return-path: <linux-media-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([212.13.194.111]:2879 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab0BRWAe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2010 17:00:34 -0500
Received: from intmx.carfax.org.uk
	([10.0.0.5] helo=vlad.carfax.org.uk ident=Debian-exim)
	by frost.carfax.org.uk with esmtp (Exim 4.69)
	(envelope-from <hugo@carfax.org.uk>)
	id 1NiDfe-00041W-3q
	for linux-media@vger.kernel.org; Thu, 18 Feb 2010 21:12:28 +0000
Received: from selene.carfax.org.uk ([10.0.0.7])
	by vlad.carfax.org.uk with smtp (Exim 4.69)
	(envelope-from <hugo@carfax.org.uk>)
	id 1NiDfc-00045e-Qh
	for linux-media@vger.kernel.org; Thu, 18 Feb 2010 21:12:25 +0000
Date: Thu, 18 Feb 2010 21:12:24 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-media@vger.kernel.org
Subject: Documentation questions
Message-ID: <20100218211224.GA7879@selene>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Hi,

(Please cc: me, I'm not subscribed yet)

   After struggling to work out how stuff worked from the existing DVB
API docs(+), I'm currently attempting to improve the API
documentation, to cover the v5 API, and I've got a few questions:

 * Is anyone else working on docs right now? (i.e. am I wasting my time?)

 * Looking at the current kernel sources, the properties
DTV_DISEQC_MASTER, DTV_DISEQC_SLAVE_REPLY, DTV_FE_CAPABILITY and
DTV_FE_CAPABILITY_COUNT don't seem to be implemented. Is this actually
the case, or have I missed something?

 * Most of the information in struct dvb_frontend_info doesn't seem to
exist in the v5 API. Is there an expected way of getting this info (or
isn't it considered useful any more?) Is FE_GET_INFO still recommended
for that purpose in the v5 API?

 * DTV_DELIVERY_SYSTEM is writable. What does this do? I would have
thought it's a read-only property.

 * Is there any way of telling which properties are useful for which
delivery system types, or should I be going back to the relevant
specifications for each type to get that information?

 * Is the "v5 API" for frontends only, or is there a similar key/value
system in place/planned for the other DVB components such as demuxers?

   Thanks,
   Hugo.

(+) Actually, the docs were pretty helpful, up to a point. Certainly
better than some I've tried to read in the past. The biggest problem
is the lack of coverage of the v5 API.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- "How deep will this sub go?" "Oh,  she'll go all the way to ---   
                    the bottom if we don't stop her."                    

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFLfa04IKyzvlFcI40RAo4FAJoC0eKZua6DUQnP9rJKZsoQo/1wqQCgwOqY
tnWR67zNZU0RiHShoB12Sl4=
=AlWn
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
