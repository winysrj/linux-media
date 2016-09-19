Return-path: <linux-media-owner@vger.kernel.org>
Received: from ring0.de ([5.45.101.7]:54289 "EHLO ring0.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753086AbcISVQc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 17:16:32 -0400
Date: Mon, 19 Sep 2016 23:16:29 +0200
From: Sebastian Reichel <sre@ring0.de>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 10/17] smiapp: Unify setting up sub-devices
Message-ID: <20160919211628.ouqwok3lpygenoqc@earth>
References: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
 <1473938551-14503-11-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="air2qeebytilnv2x"
Content-Disposition: inline
In-Reply-To: <1473938551-14503-11-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--air2qeebytilnv2x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Thu, Sep 15, 2016 at 02:22:24PM +0300, Sakari Ailus wrote:
> The initialisation of the source sub-device is somewhat different as it's
> not created by the smiapp driver itself. Remove redundancy in initialising
> the two kind of sub-devices.

Reviewed-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--air2qeebytilnv2x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJX4FWsAAoJENju1/PIO/qaKnwQAKMEfKoEMQHkNissvsGQUKXm
902jf1vG/4FS9JL0ECHgCn4PbyQvghxxTq6gGt/oc1RJ/r96CW/bAWArqqkVJI4w
M/r7XF4S5uUsZXquNyZhyZOV6W9M7dAryQ9KpZgJlYi6fCUPxHAxZSCKz0RmZSTX
nnJakWEYggfkhf+aQAO/3iltp8Bj9QNyYhasnwYlH1Yqs6tz5bHh0F4J5iXBgWGX
eMfsRIvrtqWaPBv9YssCfEz6apMKVdbg0iquh+StFEhQ0ll1S7Vkp4OZWDTwkxVd
4UG9P+cXXJUissqBkXelxigt77v12zT3yYe5E+nwJX7KcuR26/BPLbAyVcN769oz
CjJnNQAQU0IVsX3gybwYby+QxmvpE0WTNfk2SXVjk/6lJ6iGppNELazU+P+98xiL
4Zhdii0h3FTH7kDNpM6sIyYS21WMNnKWbXYLSlTUtgVU+rGV+DvNXuOIyGrZg78N
+UKbdDymsIwcEmk7K7ZbFgDWZLOGSq9W0JZUeLfs4KLIJ8ChCMaConl/uBEeL5q3
hudLI+6MO5hRfKy+FShxr1gH2E+FmhR1obd4bA2Jx91VqdJhnsuJaOGk7EIsvHAZ
d4NoRhVNxaL7OlTiI7EII0ZOYYd701iFBtGu4F/hjMbdXue7zroHQX4U7uK7Zg1f
tIOU93eok+lLP5EFV8o7
=2UeT
-----END PGP SIGNATURE-----

--air2qeebytilnv2x--
