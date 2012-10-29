Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp01.uk.clara.net ([195.8.89.34]:43432 "EHLO
	claranet-outbound-smtp01.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759625Ab2J2QD1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Oct 2012 12:03:27 -0400
From: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH] saa7134: Add pm_qos_request to fix video corruption
Date: Mon, 29 Oct 2012 16:03:04 +0000
Message-ID: <2614655.PC7gBWDYxH@f17simon>
In-Reply-To: <20121029134445.1f58657e@infradead.org>
References: <1350906611-17498-1-git-send-email-simon.farnsworth@onelan.co.uk> <13391942.y8AEurCsVE@f17simon> <20121029134445.1f58657e@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1879889.QENECiXHnW"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart1879889.QENECiXHnW
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Monday 29 October 2012 13:44:45 Mauro Carvalho Chehab wrote:
> Thanks for digging into it and getting more data. Do you know if this change
> it also needed with USB devices that do DMA (isoc and/or bulk)? Or the USB
> core already handles that?
> 
I'm not a huge expert - the linux-pm list (cc'd) will have people around who
know more.

If I've understood correctly, though, the USB core should take care of pm_qos
requests if they're needed for the hardware; remember that if the HCD has
enough buffering, there's no need for a pm_qos request. It's only needed for
devices like the SAA7134 where the buffer is small (1K split into pieces)
compared to the sample data rate (27 megabytes/second raw video).

For the benefit of the linux-pm list; this all starts with me providing a
patch to have the saa7134 driver request reduced cpu_dma_latency when
streaming, as I've seen buffer exhaustion. We've got far enough to know that
the value I chose was wrong for the saa7134, but Mauro also wants guidance on
whether USB devices (not host controllers) also need to request reduced
latency.
-- 
Simon Farnsworth
Software Engineer
ONELAN Ltd
http://www.onelan.com

--nextPart1879889.QENECiXHnW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAABAgAGBQJQjqi7AAoJEIKsye9/dtRWaZgH/i/Tgt8cDMdxqgijvQClkqcE
O5LBJhuPVg/cOA5JoqhwUNBHo2RdNzvHP4SsmpJd1eXZJzMONAJK9+gGKXqgflHc
a+Ib3ow6CYZ83QwFhlOp1llcPtft65uEBNZ8BL6YU1wy96TFo/k+Ba/jGfnTygJO
0bLiLblZKuaa3pMqdSEUD5i/0JRcHeY7LQK0tL+kGtOQnYRJrDuCNGKqfNeCQGDW
HbovJ6zenh7z3ZZf2spKG5k2ZDGDdiIh6XRG094TyhfaSl6Y4e9POXwXXZ9g2i6e
QeAokiIudhOpky5u0QN9+PuyMfA10rbtA3YTrCpSf4nQ8drcACv9kKLCEezXZKA=
=UVli
-----END PGP SIGNATURE-----

--nextPart1879889.QENECiXHnW--

