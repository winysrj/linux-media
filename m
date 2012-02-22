Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab2BVRAp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Feb 2012 12:00:45 -0500
Message-ID: <1329930017.30884.84.camel@atropine>
Subject: Re: Kernel Display and Video API Consolidation mini-summit at ELC
 2012 - Notes
From: Adam Jackson <ajax@redhat.com>
To: James Simmons <jsimmons@infradead.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-fbdev@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	Pawel Osciak <pawel@osciak.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	dri-devel@lists.freedesktop.org,
	Alexander Deucher <alexander.deucher@amd.com>,
	Rob Clark <rob@ti.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org
Date: Wed, 22 Feb 2012 12:00:17 -0500
In-Reply-To: <alpine.LFD.2.02.1202221559510.3721@casper.infradead.org>
References: <201201171126.42675.laurent.pinchart@ideasonboard.com>
	 <1775349.d0yvHiVdjB@avalon> <20120217095554.GA5511@phenom.ffwll.local>
	 <2168398.Pv8ir5xFGf@avalon>
	 <alpine.LFD.2.02.1202221559510.3721@casper.infradead.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-gzt8ttsgsYrpcFpaBmPL"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-gzt8ttsgsYrpcFpaBmPL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-02-22 at 16:03 +0000, James Simmons wrote:

> Fbcon scrolling at be painful at HD or better modes. Fbcon needs 3=20
> possible accels; copyarea, imageblit, and fillrect. The first two could b=
e=20
> hooked from the TTM layer. Its something I plan to experiment to see if=
=20
> its worth it.

In my ideal world, the "framebuffer console" is something like vte under
wayland, which avoids this entirely.  Scrolling on early boot until you
manage to get into initramfs would still be slow, but whatever, that's a
debugging feature anyway.

- ajax

--=-gzt8ttsgsYrpcFpaBmPL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk9FHyIACgkQW4otUKDs0NMJ+gCcCFwB/UYrLZdqCRXHaHTw2Tww
yb4AoIjvACDS/dvbZVePv9XOJizEnnAm
=dTsh
-----END PGP SIGNATURE-----

--=-gzt8ttsgsYrpcFpaBmPL--

