Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:60583 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161801Ab3LFNIo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Dec 2013 08:08:44 -0500
Date: Fri, 6 Dec 2013 14:07:40 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Denis Carikli <denis@eukrea.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Marek Vasut <marex@denx.de>, devel@driverdev.osuosl.org,
	driverdev-devel@linuxdriverproject.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Eric =?utf-8?Q?B=C3=A9nard?= <eric@eukrea.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	David Airlie <airlied@linux.ie>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Herring <rob.herring@calxeda.com>,
	Shawn Guo <shawn.guo@linaro.org>, devicetree@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Sascha Hauer <kernel@pengutronix.de>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCHv5][ 3/8] staging: imx-drm: Correct BGR666 and the board's
 dts that use them.
Message-ID: <20131206130739.GD30625@ulmo.nvidia.com>
References: <1386268092-21719-1-git-send-email-denis@eukrea.com>
 <1386268092-21719-3-git-send-email-denis@eukrea.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4zI0WCX1RcnW9Hbu"
Content-Disposition: inline
In-Reply-To: <1386268092-21719-3-git-send-email-denis@eukrea.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--4zI0WCX1RcnW9Hbu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 05, 2013 at 07:28:07PM +0100, Denis Carikli wrote:
[...]
> diff --git a/arch/arm/boot/dts/imx51-apf51dev.dts b/arch/arm/boot/dts/imx51-apf51dev.dts
> index f36a3aa..3b6de6a 100644
> --- a/arch/arm/boot/dts/imx51-apf51dev.dts
> +++ b/arch/arm/boot/dts/imx51-apf51dev.dts
> @@ -19,7 +19,7 @@
>  	display@di1 {
               ^^^^

I know this isn't introduced by your patch, but WTF???

Thierry

--4zI0WCX1RcnW9Hbu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSocwbAAoJEN0jrNd/PrOhP94P/0mBACQRMAUOTMWDoLqUY2jk
69YIl1VTy33ezV1Rmhd3TBd8vEBQzJGQvIeR219KrDmKr6tPyvHwV7TSgPvARAju
RcZ5JN91h/NsjkYAQCHIDKNwyGe5uq4uwSNZoGDOAi+a5zmS2MpjfXNPm9BbyJSf
6vm4dGA6KPIlprBZLEbMvi4/AVnJDriBA6giuC09iEVSJhH4uI+e/DE8UsW6fCrm
B5gZrbfcEqecrmh4kDgewmIgkBRdholuK3A1XMBWEnsbkPRHi0w8GCLMR1bwH8GP
W+2GrQ8pmH/yjIS9Deq/aKVrM9BzbQjb4r0uKMpe2CCOI2Yx01BsIWoo3Tr83GlP
E2AoStk1vjnHC5oY0HIvMyCD4a0l5dlUTxsN/6DrVQepYDNm4a4I9PELyX1xCQ+g
02kMV4yuIuKewbtPxPsvSBZY3VV1XY2+F/PNrrqSd+rUIoF12bXNUQXOpClJ1R7Y
qZem14g4JFZwhLYg7oI1F8tBVUlVGaBR0C4P6mjoyEvlWJtQdPqe/spm3xo8Lisa
Tc2cKRXhycSo7SB/BYsMS/rt0Z5+dg8KLvNohJQ9qEVHEO1jpFimIi6r78ZrNOty
6YfzHoT+kOZd21M3WJrOltpTx2uSkhxgOqL1uWRStiUL5kgssIXgUduN3g66oZXb
XkD06/r1ieeI45TlOULZ
=UUqC
-----END PGP SIGNATURE-----

--4zI0WCX1RcnW9Hbu--
