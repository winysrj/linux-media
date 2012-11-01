Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:55340 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758502Ab2KAURo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2012 16:17:44 -0400
Date: Thu, 1 Nov 2012 21:17:39 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: devicetree-discuss@lists.ozlabs.org,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de
Subject: Re: [PATCH v7 3/8] of: add generic videomode description
Message-ID: <20121101201739.GC13137@avionic-0098.mockup.avionic-design.de>
References: <1351675689-26814-1-git-send-email-s.trumtrar@pengutronix.de>
 <1351675689-26814-4-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f+W+jCU1fRNres8c"
Content-Disposition: inline
In-Reply-To: <1351675689-26814-4-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--f+W+jCU1fRNres8c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 31, 2012 at 10:28:03AM +0100, Steffen Trumtrar wrote:
[...]
> +config OF_VIDEOMODE
> +	def_bool y
> +	depends on VIDEOMODE
> +	help
> +	  helper to get videomodes from the devicetree
> +

I think patches 3 and 4 need to be swapped, since patch 4 introduces the
VIDEOMODE Kconfig symbol (as well as the videomode.h helper) that patch
3 uses.

Thierry

--f+W+jCU1fRNres8c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQktjjAAoJEN0jrNd/PrOhYz4P/3cbr9Gtdcr2a5mLvk0QD4Mn
1LZC6jqEn/BeC+tdgPUVO7eUZfah8TPgfvU+3+vU4H3o0PQcrjRFkpsni7xpjVsH
Cu70kJt7el8RAsGoLzFlYAduq1EFzSwbdXnsmwK+MoVE1kvzQn7CT1Ad8foYsYG7
NaKy6YXrEq7ZGn040Jtq6CHidjEyT39OHMimSS5YHCc8k4GfGJxAyYjgMdg+1b77
wy/nZhRChJQF5E2h+A9Lz5SqGvRY5bZ9kR5Tn2u7JiMd05cmaDDhnLXgN79SmaBc
2uXPfXd9Ssiy6XfSS0XSTCj/97weGJhkdD7P2j0dEKOJodhbSZJ/88He3OB0vqbL
uZukjhVohy9xq1+9lHxRnmGqlzuIynOkAAbT9gy9WcHtLL+SdXDLyujtiKt+2rHm
Xdll2NlzTvnn1Q879x0r66aj/LtB+r/pIlfLyqIm4fcs7atJGWuLgGIc50kkn1oW
Eq7WOc3N3BagGJrvJQX33CpE1VruNelrevF26g1Zw1iEwPHh6jwgFuiQ7yUcGNvA
7HkGCY5VUv7VstkR8sil76eC7ezgn8gTlrhoUXD05F3uiVEiGu44LID74s0YfV7K
pMJoiz25fPpU6hQ1yo28SvEb6StBsWn1rfj4UkVhidVtYM1hzrWMKNzpJpWy+b+H
TP1l67LSdtaVbFuFSTrx
=HS2T
-----END PGP SIGNATURE-----

--f+W+jCU1fRNres8c--
