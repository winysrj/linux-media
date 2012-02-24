Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:27575 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab2BXSh6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Feb 2012 13:37:58 -0500
Date: Fri, 24 Feb 2012 21:39:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: mchehab@infradead.org, gregkh@linuxfoundation.org,
	devel@driverdev.osuosl.org, tomas.winkler@intel.com,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 5/9] staging: easycap: Push video registration to
 easycap_register_video()
Message-ID: <20120224183950.GC3649@mwanda>
References: <1330097062-31663-1-git-send-email-elezegarcia@gmail.com>
 <1330097062-31663-5-git-send-email-elezegarcia@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KN5l+BnMqAQyZLvT"
Content-Disposition: inline
In-Reply-To: <1330097062-31663-5-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--KN5l+BnMqAQyZLvT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 24, 2012 at 12:24:18PM -0300, Ezequiel Garcia wrote:
> +		rc = easycap_register_video(peasycap);
> +		if (rc < 0)
>  			return -ENODEV;

Don't resend.  These are beautiful patches you are sending and I
wouldn't want to slow you down.  But it would have been better to
return rc here.

regards,
dan carpenter


--KN5l+BnMqAQyZLvT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPR9l1AAoJEOnZkXI/YHqRM08QAITpW8L+tVEBS6NC+2aPzAdY
3HYdMyU4E+XstnD+OIXcTIMua1omb4K0rq4TjFxmtHdKDgZJ0G3OuluDGsAvYNQ+
cZnyKcb4vhRmyY+Ji5gA6uOs2hIT3AKGZCATw7HnXHGFPfUTGm6O+XrHNItfsacA
x72mBCE9aiLLF6FEAQJRT9ZTS+CV/eTFs2zCBZTuOXEIQEd5nL4RKYzFX7LicmzB
mfXqkpKSEtaPyPZoF3Iy7rxLDoRTCbkk0rtTUd1gs0FXOtQZm7UHFWOqeedJfXXi
2RuyvPkEDZKn2qzGafhvwUHfiBBDwHn/8r7ueD3GkAfrqKhriplFjVB1CS/2HXc6
BRSfwX7w0FM+OWKqU9VhCehqJs8Mtwqi3UNj3H8IfDXLoWiFeRfGeS/oCGi7N4eO
XjieMQGSSBM0QQfhzTSGchh12SP1AlQvkFBY83ffDFhaA8QX7rpSGDgEau/i3mfM
YMkhnfu5ImZcThid2wyN5ZAu8qR61lNFh7fWZF64HGw0C8bp8LpN2GpGkA7TNo40
LHOjdxhWRFvbqWB339lgpGn37yCn9SZmdFHwKIZ3rINo69YDc2+1D+0wzD8MMoZL
1XesiDw2IYnnFscEo9ek8Z4JPBrZp1vIxv95uoOafqUNdiaKPNjQ7XNOJL3gP8xJ
JGJK7V5HqcWq0vRIgDc8
=qrZJ
-----END PGP SIGNATURE-----

--KN5l+BnMqAQyZLvT--
