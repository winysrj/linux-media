Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:57838 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422711Ab2KNMrZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 07:47:25 -0500
Date: Wed, 14 Nov 2012 13:47:02 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de
Subject: Re: [PATCH v9 4/6] fbmon: add of_videomode helpers
Message-ID: <20121114124702.GE2803@avionic-0098.mockup.avionic-design.de>
References: <1352893403-21168-1-git-send-email-s.trumtrar@pengutronix.de>
 <1352893403-21168-5-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EXKGNeO8l0xGFBjy"
Content-Disposition: inline
In-Reply-To: <1352893403-21168-5-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--EXKGNeO8l0xGFBjy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 14, 2012 at 12:43:21PM +0100, Steffen Trumtrar wrote:
[...]
> diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
[...]
> +#if IS_ENABLED(CONFIG_OF_VIDEOMODE)
> +static void dump_fb_videomode(struct fb_videomode *m)

static inline?

Thierry

--EXKGNeO8l0xGFBjy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQo5LGAAoJEN0jrNd/PrOhMQYQALg1ricKCtsjM8cTxoWnYhgc
deYFU0F1Pq06jd+miWAezoKygHzzx311ITB14zDI4OFLyGmyRxxvvWWz4UANYyGg
Ly/SsYxn8gOVmxaMPatLLffsaAy/K2vkRxqTTltCtIpI0wtV9UryHZ6Yl+G4UcKX
U+m/Ofu+1+mQTPItyYAftDOaWjDR1fGXicaDdVviSxZ64SBZcpKvu89YsTuSkGOS
YkfD4B8CsOgyKrp4lMOBBr0ccPyIJ4kOKaCDf+w0+VRqxN7tvZok+yjSMu0ogdS3
rsoAyxmTYrZY0xsKe7t9A/l2zwpHnYF77mDApubXRo4DrPUYAbe3DsivtSGNLtVe
OnOIWTbL2iu5xs4gPxtokjN4NRCse87rgcAT5IuhngymRvbmF1OsbAlx1Mqazsoy
6Uq9tvPS1rPTe3m+bOoUBKXyv2P0eLdG86+6Vc0ZcVO+vFk9N1eiU6Zg8KBe8iya
bp/DH4LXOfVw8fbBBcPXbdCGPe2IURF95Sot7RlZkjOROddfccz3oQitFFWqyzvb
2UMJY2drPpDwwXr/TOpDI881TONFcioA27M7zbuX12bx4NsJnQlERSqd4VUmpgJ4
MVcjzGikWAqPXGKF/G+MgBV8XXootmRUDUNXstrHs4xX+6KK4Pu58jrNx8HcVv3M
XP1sJE4M2z2pPkSHErSS
=z14w
-----END PGP SIGNATURE-----

--EXKGNeO8l0xGFBjy--
