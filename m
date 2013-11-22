Return-path: <linux-media-owner@vger.kernel.org>
Received: from home.keithp.com ([63.227.221.253]:53867 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755875Ab3KVXrd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Nov 2013 18:47:33 -0500
From: Keith Packard <keithp@keithp.com>
To: Kristian =?utf-8?Q?H=C3=B8gsberg?= <hoegsberg@gmail.com>,
	Daniel Vetter <daniel@ffwll.ch>
Cc: Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig\@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	Mesa Dev <mesa-dev@lists.freedesktop.org>,
	"linux-media\@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [Intel-gfx] [Mesa-dev] [PATCH] dri3, i915, i965: Add __DRI_IMAGE_FOURCC_SARGB8888
In-Reply-To: <20131122221213.GA3234@tokamak.local>
References: <1385093524-22276-1-git-send-email-keithp@keithp.com> <20131122102632.GQ27344@phenom.ffwll.local> <86d2lsem3m.fsf@miki.keithp.com> <CAKMK7uEqHKOmMFXZLKno1q08X1B=U7XcJiExHaHbO9VdMeCihQ@mail.gmail.com> <20131122221213.GA3234@tokamak.local>
Date: Fri, 22 Nov 2013 15:36:43 -0800
Message-ID: <86siuovwj8.fsf@miki.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Kristian H=C3=B8gsberg <hoegsberg@gmail.com> writes:

> I already explained to Keith why we use different sets of format codes
> in the DRI interface, but it's always fun to slam other peoples code.

As we discussed, my complaint isn't so much about __DRI_IMAGE_FOURCC,
but the fact that the __DRIimage interfaces use *both*
__DRI_IMAGE_FOURCC and __DRI_IMAGE_FORMAT at different times.

Ok, here's a fine thing we can actually fix -- the pattern that mesa
uses all over the place in converting formats looks like this (not to
pick on anyone, it's repeated everywhere, this is just the first one I
found in gbm_dri.c):

	static uint32_t
        gbm_dri_to_gbm_format(uint32_t dri_format)
	{
	   uint32_t ret =3D 0;
=09
	   switch (dri_format) {
	   case __DRI_IMAGE_FORMAT_RGB565:
	      ret =3D GBM_FORMAT_RGB565;
	      break;
	   case __DRI_IMAGE_FORMAT_XRGB8888:
	      ret =3D GBM_FORMAT_XRGB8888;
	      break;
	   case __DRI_IMAGE_FORMAT_ARGB8888:
	      ret =3D GBM_FORMAT_ARGB8888;
	      break;
	   case __DRI_IMAGE_FORMAT_ABGR8888:
	      ret =3D GBM_FORMAT_ABGR8888;
	      break;
	   default:
	      ret =3D 0;
	      break;
	   }
=09
	   return ret;
	}

The problem here is that any unknown incoming formats get translated to
garbage (0) outgoing. With fourcc codes, there is the slight advantage
that 0 is never a legal value, but it sure would be nice to print a
warning or even abort if you get a format code you don't understand as
there's no way 0 is ever going to do what you want.

Anyone have a preference? Abort? Print an error? Silently continue to do
the wrong thing?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUBUo/qi9siGmkAAAARAQgpFg/9GMcrbW/Tycv+ZpqbtgMrdk90wFGMI3NN
zXYe1FtZBgtJIJkdQi8sLS6u67uZm8XEUdXzrnvSSptdi6NYeBFf3JiYKHDb2xOp
cX8AuMTbOPga4k0g5nnX+pdsyl08nOXplWoRjTiHnYsgS91a3AFvU1IRO5hyblpR
8pI6kcai90kjYAbyQj1TV7HZgt5FDFHtA2+jzscnS7EjzUwaKFy3wMvBNi15bHzp
q1Icr6vJku3yvY0gcBqvoQmv8H1GmQ8ikOdbSF/xaOmI+IBhplMw1esSkuon12nz
Duf9cWicDPSi2atSZ+iP5aLYUUpmKSoWZkDMblwobo1V7vMK3LfWTlz0RVBfGPNY
8/mg9pLgIxRdj7s/sHoxQO/dJGLPKgdcT2M0sZEHXgFWFW9dR6zhyDqG9cIJTfIZ
+lsapv8QqzeQ5/5fgDE414dPqq/dQrZcr4srbgLT883FKaJjrkEkQrAV86m6l3E0
WkQ9SGPv1Ak1EoFhDHqWC0x9x+w0+7QK88QJNq45YO5aIGNaJdYoFHkEJE3yW0/x
vwgPa3crTrDnSC2MeZkAqxhqI97muynsYgMNznNJUQzpUXO1eUGsv59b6nMhMYEH
/0td8Hunn0aoPHiHy2xnf1r5ykh2zUxM8qQpku1cQF2d4IvmtD16iuwDZMs77btg
/ebP3OlwXVc=
=w9Sb
-----END PGP SIGNATURE-----
--=-=-=--
