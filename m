Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50217 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab2K2JfQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Nov 2012 04:35:16 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: hvaibhav@ti.com, linux-media@vger.kernel.org,
	Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
	Archit Taneja <archit@ti.com>
Subject: Re: [PATCH 0/2] omap_vout: remove cpu_is_* uses
Date: Thu, 29 Nov 2012 10:36:19 +0100
Message-ID: <4208124.v72gFsjH2D@avalon>
In-Reply-To: <50B72B34.6080808@ti.com>
References: <1352727220-22540-1-git-send-email-tomi.valkeinen@ti.com> <1421983.jJNXU7RvjW@avalon> <50B72B34.6080808@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1920695.VqbvWLCQEz"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart1920695.VqbvWLCQEz
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Tomi,

On Thursday 29 November 2012 11:30:28 Tomi Valkeinen wrote:
> On 2012-11-28 17:13, Laurent Pinchart wrote:
> > On Monday 12 November 2012 15:33:38 Tomi Valkeinen wrote:
> >> Hi,
> >> 
> >> This patch removes use of cpu_is_* funcs from omap_vout, and uses
> >> omapdss's version instead. The other patch removes an unneeded plat/dma.h
> >> include.
> >> 
> >> These are based on current omapdss master branch, which has the omapdss
> >> version code. The omapdss version code is queued for v3.8. I'm not sure
> >> which is the best way to handle these patches due to the dependency to
> >> omapdss. The easiest option is to merge these for 3.9.
> >> 
> >> There's still the OMAP DMA use in omap_vout_vrfb.c, which is the last
> >> OMAP dependency in the omap_vout driver. I'm not going to touch that, as
> >> it doesn't look as trivial as this cpu_is_* removal, and I don't have
> >> much knowledge of the omap_vout driver.
> >> 
> >> Compiled, but not tested.
> > 
> > Tested on a Beagleboard-xM.
> > 
> > Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Thanks.
> 
> > The patches depend on unmerged OMAP DSS patches. Would you like to push
> > this series through linuxtv or through your DSS tree ? The later might be
> > easier, depending on when the required DSS patches will hit mainline.
> 
> The DSS patches will be merged for 3.8. I can take this via the omapdss
> tree, as there probably won't be any conflicts with other v4l2 stuff.
> 
> Or, we can just delay these until 3.9. These patches remove omap
> platform dependencies, helping the effort to get common ARM kernel.
> However, as there's still the VRFB code in the omap_vout driver, the
> dependency remains. Thus, in way, these patches alone don't help
> anything, and we could delay these for 3.9 and hope that
> omap_vout_vrfb.c gets converted also for that merge window.

OK, I'll queue them for v3.9 then.

-- 
Regards,

Laurent Pinchart

--nextPart1920695.VqbvWLCQEz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAABAgAGBQJQtyyTAAoJEIkPb2GL7hl1VP4H/0XrPiUBRVgIYf/HIKUC+TfO
V9nlfnHe3DFRNwvcNfLlimQyTa1eCohmB94fryK1ZuJrKdNsNknwNWzphgZg3V44
6GyqJ51mWShALHj9/DUztdfJd7xk3u870FDV/3wtTcuVkPrSAUSuXXZSTOuidm8I
Ddvpoh5OJAuRtzoydm40yHemCTLoPpB3Ue3K5kCqxxszDT/OUcmFH2pPdKOvJ5be
GTJ/vLpT4YQ0OZoQ3Z4WTInzOr0XCVNZMCo4GFA+H8DaZ+BdUrpj0DuSa7+JDImx
Nb5UJ47uM63mKupHFrfOFcbKAXIcClhEn9KjE6M+iRWtPdOWU9S3s/0IXCZK8TA=
=CYI2
-----END PGP SIGNATURE-----

--nextPart1920695.VqbvWLCQEz--

