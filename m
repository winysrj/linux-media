Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp03.uk.clara.net ([195.8.89.36]:36907 "EHLO
	claranet-outbound-smtp03.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758683Ab2J2L0E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Oct 2012 07:26:04 -0400
From: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] saa7134: Add pm_qos_request to fix video corruption
Date: Mon, 29 Oct 2012 11:25:38 +0000
Message-ID: <3124636.sEoNQbeq5Q@f17simon>
In-Reply-To: <1350906611-17498-1-git-send-email-simon.farnsworth@onelan.co.uk>
References: <1350906611-17498-1-git-send-email-simon.farnsworth@onelan.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2763124.klLcYckpKo"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart2763124.klLcYckpKo
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Monday 22 October 2012 12:50:11 Simon Farnsworth wrote:
> The SAA7134 appears to have trouble buffering more than one line of video
> when doing DMA. Rather than try to fix the driver to cope (as has been done
> by Andy Walls for the cx18 driver), put in a pm_qos_request to limit deep
> sleep exit latencies.
> 
> The visible effect of not having this is that seemingly random lines are
> only partly transferred - if you feed in a static image, you see a portion
> of the image "flicker" into place.
> 
> Signed-off-by: Simon Farnsworth <simon.farnsworth@onelan.co.uk>

Hello Mauro,

I've just noticed that I forgot to CC you in on this patch I sent last week - 
Patchwork grabbed it at https://patchwork.kernel.org/patch/1625311/ but if you 
want me to resend it so that you've got it in a mailbox for consideration, 
just let me know.
-- 
Simon Farnsworth
Software Engineer
ONELAN Ltd
http://www.onelan.com

--nextPart2763124.klLcYckpKo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAABAgAGBQJQjme2AAoJEIKsye9/dtRWksUH/13R/JVFeSmIK/QtHKijLY3d
NC84UHS24AD6r4y+EEmrs9+levCyJ7xiwHKsgIA9sdrbte8jHv4FqGJZRPn1mwtQ
GQLvSmV6Z4bFobqrhXdmpewYz5rNsVla3RFAX06gcEcjBKZHAa/1EvDj8RVAeyyC
48bV3I17oNIsGnGBQ1Mqol3SEJgLwzB/64h4IrpcTYVH986ACPgriKKPAdwIqA6d
np1+S6U9WbDn9pbjp+SACcmx0l72xpLO30jwSQRPUmdvXsm5nQKYv5aNNjilTjfT
D7vEN22kpzPBNig+osPx/gUs/Lz0tNaWk9TPSBT8Nfkh74KNzZF5SxC/kOXQpAM=
=lJx7
-----END PGP SIGNATURE-----

--nextPart2763124.klLcYckpKo--

