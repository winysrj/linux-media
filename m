Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:48888 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852Ab3J3Pp6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Oct 2013 11:45:58 -0400
Date: Wed, 30 Oct 2013 16:45:54 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] rtl2830: add parent for I2C adapter
Message-ID: <20131030154553.GC3663@katana>
References: <1382386335-3879-1-git-send-email-crope@iki.fi>
 <52658CA7.5080104@iki.fi>
 <20131030151620.GB3663@katana>
 <52712787.3010408@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qtZFehHsKgwS5rPz"
Content-Disposition: inline
In-Reply-To: <52712787.3010408@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--qtZFehHsKgwS5rPz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> >>commit 3923172b3d700486c1ca24df9c4c5405a83e2309
> >>i2c: reduce parent checking to a NOOP in non-I2C_MUX case
> >
> >Did you try reverting it? I am not sure this is the one.
>=20
> Nope, not to mentio bisect. I have done bisect few times and I am
> not going to waste whole day of compiling and booting new kernels.

Well, I intentionally asked for revert not bisect. Removing the #ifdef
can easily be done by hand if needed and will just need one recompile to
make sure.

> Crash disappeared whit that little patch.

Yes, still I'd like to understand where the BUG came from. There are
probably other driver in need of a fix, too.

> Anyway, I am going to ask Mauro to merge that I2C parent patch and
> maybe try to sent it stable too as it is likely a bit too late for
> 3.12 RC.

If it fixes a crash, I wouldn't consider it too late. Yet only given we
have understood this is a proper fix.

Was there a change in using CONFIG_I2C_COMPAT? Is it currently used?

Regards,

   Wolfram


--qtZFehHsKgwS5rPz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJScSmxAAoJEBQN5MwUoCm2j+8P/idsNExbsY9jibVA2f3uqEqB
iBsDgeXiskXhowxHw2kpJAy7AZC9sozNqugQXmEMctkWeqfW6QhrfTafqnHibhFI
dms1ZMnlChhwZ0pcGBROOsp4S23sUwGGGVhYakyudSM0Je9zAkrH/5OaYodX4TL+
1IcpIZt4i8/D/19Gmeq5kLIWD8Vvkxs48U+YBzSnLOnIEemPhmP6DWdVu5rsK8RX
Dtiij2Y69hN9+0GgTmi+9NR0puu/JpqqzthJJq2ivMa0LmxdkpPBZpugdaPPfWRx
ip9b8vBbJD/SM52wXx+j+9En94FZOSvA0AD+dU5OtXWi30HGoPLFiyUMeS2px9JS
6BzkZT83QojpZyhILTDHw7cwON56RDo/6YMdZ+m3wa2D92JETnLVm4ylo2MabQWM
HqvlBkb3RRRAgSv1VY55Dw/bhGAF8pWh+5fqqrajRaJWmm+Oa9RSIBSLXZGQKQ1S
i2K3NRr+fIJUl+NQpKRa6Cb166Z1A46waU6teZZJ0DAvMQ3mTJpFvXnxRJNnexdy
anXsGgoHzn9QxTwCD+dpHLvcqH2D9VJY536SN6SQa4Mm1rIW2TV8LEGOD+qNC1tF
W6E9d2Ba7edxVRBLvWGxjQjZcYPqa408lukWD6+qpncdefLIM7UTgiyS76vcHI1m
yEQiBHZp8ZU7n1FetsH6
=/ffE
-----END PGP SIGNATURE-----

--qtZFehHsKgwS5rPz--
