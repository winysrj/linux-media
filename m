Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751443AbcISWzg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 18:55:36 -0400
Date: Tue, 20 Sep 2016 00:55:21 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/5] smiapp: Set device for pixel array and binner
Message-ID: <20160919225519.xcy7abku7frm45a2@earth>
References: <1473938961-16067-1-git-send-email-sakari.ailus@linux.intel.com>
 <1473938961-16067-3-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="i3ozvuqp3bkpe2ob"
Content-Disposition: inline
In-Reply-To: <1473938961-16067-3-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--i3ozvuqp3bkpe2ob
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 15, 2016 at 02:29:18PM +0300, Sakari Ailus wrote:
> The dev field of the v4l2_subdev was left NULL for the pixel array and
> binner sub-devices. Fix this.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--i3ozvuqp3bkpe2ob
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJX4GzXAAoJENju1/PIO/qaIOwQAIcgqiGl38FLlVOZAgP6kqa/
iu0Zp4Ea+r/3wvEptiUhulpJXxFYJQbdTRMYH0ryyzfSJtCrY7F8ZBZ3ymx/hlkE
8xv5/TJJIBjBbqw0uWwCyCTX7reEbAsVYpcRG+LTUNk5ESwi3htp2ZXiMjNOnR0F
K4qWc15RV9tNH2gbqoQs2s8jF/hejrO1VbIwGxBcQ+N2RkVnygEBXouqPK7YQ3on
RmWhTmxjMPzdsB/1KOFEhpKD2F0fJe4o8hQfTSj6HScO92pLlRJcVtk5AkORFxRd
QrLy5udBQ6ICzUVndVU61BUGl1+QpKuR6ol/1i4qTR0jivyEIcyo45Me4LbzSaSb
Wacq/QTSGWzY21PtUT/61/nOCH5Ia3phjITfDeMTWUU1+JT87dVNGjcCPJvMjm+c
FnqkXqjZw7Zuo+8iXkwi+YMuiDkoIn2OAXkTSQbZcqIvwRJ1gq3IHw5lSXL3Wz/d
xAyaaEhTrlCO1gkcgagdPBLjHDqED+ajIqNTNi+oHUrBVT+bcZDhO85ENPer9J6h
vTRXWfllQeNowjPKnqpRvijoArjg8jcnOPDxI12SW8OwrCM8RhMrK8EQ5Sh5sEM8
ftmXOoTbgIHMV8Ou9EJn0WQgU5fL1zMNdKWUnYNNn4lO0aBAurwM5DEo2nLheqDa
Z55cxA3Iab4XitmeVNPc
=aR4D
-----END PGP SIGNATURE-----

--i3ozvuqp3bkpe2ob--
