Return-path: <linux-media-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43885 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbaLVNcK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Dec 2014 08:32:10 -0500
Date: Mon, 22 Dec 2014 13:31:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <20141222133142.GM17800@sirena.org.uk>
References: <1419114892-4550-1-git-send-email-crope@iki.fi>
 <20141222124411.GK17800@sirena.org.uk>
 <549814BB.3040808@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aiCxlS1GuupXjEh3"
Content-Disposition: inline
In-Reply-To: <549814BB.3040808@iki.fi>
Subject: Re: [PATCHv2 1/2] regmap: add configurable lock class key for lockdep
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--aiCxlS1GuupXjEh3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 22, 2014 at 02:55:23PM +0200, Antti Palosaari wrote:
> On 12/22/2014 02:44 PM, Mark Brown wrote:
> >On Sun, Dec 21, 2014 at 12:34:51AM +0200, Antti Palosaari wrote:

> >>I2C client and I2C adapter are using regmap. As a solution, add
> >>configuration option to pass custom lock class key for lockdep
> >>validator.

> >Why is this configurable, how would a device know if the system it is in
> >needs a custom locking class and can safely use one?

> If RegMap instance is bus master, eg. I2C adapter, then you should define
> own custom key. If you don't define own key and there will be slave on that
> bus which uses RegMap too, there will be recursive locking from a lockdep
> point of view.

That doesn't really explain to me why this is configurable, why should
drivers have to worry about this?

Please also write technical terms like regmap normally.

--aiCxlS1GuupXjEh3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmB09AAoJECTWi3JdVIfQxJEH/3tq0Ihg7ca+hzD5RUFYeEfS
08NrbGt1uGEctpQ7W0Y30LSn8Ty0l2cC9L1xT+iqPuM/Js/bvNG2coN4F2UPKF69
ofZUinBLYXQIb1ClcVzO5t/pNLQFlye9HG5qlXOdcPTKvYfTL5vtBvb9q4KH/pwd
kOL23oJ6yRFRKUHG2u3rA1YXOu5vYKv6FDWeobm03R5V3UEHTrn9nWjMVAmY7Cx9
i+NUq9FwrbNEnktm6mjTtbBDGKFXaFX7jOroOOxg+4mMag+LPYK2yLh+ap7QYc+d
u8xafXphV5j9/fsFdLwmgjHLFpvms+KSWVxc4xlnsiT/UBTNWP7hDTjapjpBwQM=
=7BB1
-----END PGP SIGNATURE-----

--aiCxlS1GuupXjEh3--
