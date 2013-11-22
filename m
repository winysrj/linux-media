Return-path: <linux-media-owner@vger.kernel.org>
Received: from home.keithp.com ([63.227.221.253]:53802 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634Ab3KVXnS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Nov 2013 18:43:18 -0500
From: Keith Packard <keithp@keithp.com>
To: Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
	Kristian =?utf-8?Q?H=C3=B8gsberg?= <hoegsberg@gmail.com>
Cc: Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig\@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	Mesa Dev <mesa-dev@lists.freedesktop.org>,
	"linux-media\@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [Intel-gfx] [Mesa-dev] [PATCH] dri3, i915, i965: Add __DRI_IMAGE_FOURCC_SARGB8888
In-Reply-To: <20131122230504.GK10036@intel.com>
References: <1385093524-22276-1-git-send-email-keithp@keithp.com> <20131122102632.GQ27344@phenom.ffwll.local> <86d2lsem3m.fsf@miki.keithp.com> <CAKMK7uEqHKOmMFXZLKno1q08X1B=U7XcJiExHaHbO9VdMeCihQ@mail.gmail.com> <20131122221213.GA3234@tokamak.local> <20131122230504.GK10036@intel.com>
Date: Fri, 22 Nov 2013 15:43:13 -0800
Message-ID: <86pppsvw8e.fsf@miki.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com> writes:

> What is this format anyway? -ENODOCS

Same as MESA_FORMAT_SARGB8 and __DRI_IMAGE_FORMAT_SARGB8 :-)

> If its just an srgb version of ARGB8888, then I wouldn't really want it
> in drm_fourcc.h. I expect colorspacy stuff will be handled by various
> crtc/plane properties in the kernel so we don't need to encode that
> stuff into the fb format.

It's not any different from splitting YUV codes from RGB codes; a
different color encoding with the same bitfields. And, for mesa, it's
necessary to differentiate between ARGB and SARGB within the same format
code given how the API is structured. So, we have choices:

 1) Let Mesa define it's own fourcc codes and risk future accidental
    collisions
=20
 2) Rewrite piles of mesa code to split out the color encoding from the
    bitfield information and pass it separately.

 3) Add "reasonable" format codes like this to the kernel fourcc list.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUBUo/sEdsiGmkAAAARAQiByQ//YE8vXxdvbYL5ADQVtzRac9L9a69T/8hN
WyjhX40wecxetjdoSxo33/DN72dbc6a6lSmxSLzazQPn0LUQrv3GP0ioFL7V5LZ8
fONTUJRmw/qKR+6RdeTT7+6K/oRPVtr3KXoty59EtINkwKrMVCh1BnEuvLrnT9M7
qakRssPpAwUnOehKFssBdXbanX1wowyeSC32J3l3ipJAqtuiBdXFDltqSagj4WfH
dSP9ulZu98Sca6QNd4u3M/g7adIJYGbEYvin/Yv4ZbT/xkuMa0cEPwVc9kKIueGG
Z5DpBjS+VsueGg1G7+MyRPlh6OPK7wjrxTQliS9jAxVSczJotB9RyaGRwftslIUc
o9+8eKahRTmT5x0uTy9vuGqBocFDZH38FqRVl+B24kvUcWs5xA0/ec7dF0BptBYp
RwFV5EeuQyrUNevnGqbqQaWLukmc4XFfRxtlAFByvo1n7t8A2P82RgAIwXN59UqJ
rDk8EGXHP+YCgS3VBtLUpvwKQ3qNTsQNSX70U0ixLZ3Yn8LgY6R5F3iXAUyDHKGy
ylTro5A6eWpKEBqbgknKc3LRrOxpQwfmB6uvD6Ni1DE7v2Pya6jsat1XKA+ZU7n4
Nwt4RjUmXlSTpVJBaN8BO3tRkl8nSENWBTpoXdlBgGsRbbXFf1CaYyn6RhLCRKz6
0yruu1F/03k=
=4NLo
-----END PGP SIGNATURE-----
--=-=-=--
