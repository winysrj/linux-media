Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:27627 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab2AIRr3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jan 2012 12:47:29 -0500
Date: Mon, 9 Jan 2012 20:48:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] af9013: change & to &&
Message-ID: <20120109174817.GH3731@mwanda>
References: <20120105062328.GA25744@elgon.mountain>
 <4F0B26A1.2020402@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G44BJl3Aq1QbV/QL"
Content-Disposition: inline
In-Reply-To: <4F0B26A1.2020402@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--G44BJl3Aq1QbV/QL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 09, 2012 at 07:40:49PM +0200, Antti Palosaari wrote:
> Clear bug, I will test it later when applied to master if not
> already. Thanks!

You're welcome, but it's not a bug because (1 & 1 & 0) is the same
as (1 && 1 && 0) but if one of them wasn't a bool it would be a
problem.  The other difference between & and && is that && has
orderring guarantees but that's also not a factor here.

regards,
dan carpenter


--G44BJl3Aq1QbV/QL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPCyhhAAoJEOnZkXI/YHqR76oQAJW+H/Xl5GrYaKIXxJ7EQM3G
OJrpcv2Dru+LZ+CA5MybNZKji9J6nVj1CE9W31DY/jo3uUPzqTBuCPLQcEOqff/O
sHP69JFD8C+lTUJCVV2aHhpoF3IHFl87cEa1T+lsQjwQjgoUWyR5xeM2nd8qze/v
OVaLGvnVQRwX6TjZoy1Uiz9yGxy+dvJ69C+ps74q5qtvU4A0viMT/X8CMJ35Qf8s
v3Mcm7NNYW8zaX5JY6FI7lx4apfF90OmUiNL46+kBuUhcFIS9brko6QYo3xWR81p
Mf1TAzKV8eOcAqHV8TXaJd9y8CR95RQZD7sSxk0vXKx6hJ9pRYFScw4Q+aOC9TsV
O64lozP70WrMBcFb6oR/u9Yz9rra3w+eOPxsfBoUGPJUf3Fv6SXT8zOdnFUohW3g
jYfaoRuvTymGJ6brgy4QWGO3g0pcgXFMhWftlZL9Ri03pBUV+t4QfZr+HIoDeC6Y
e9oRpc5wbtNlmDdpOS0V0/h55TWW1Th8/Hr3dcpLwglP+L6px+PRBd0Fmh4napm8
ED52+HeGexzYFk+jMYa+OMDG3QYg4UePT49F9E1txGp+Gwsf+OZcBp0P7MMscOK5
Wst1XPGAlZxFpe8vi7pFyHNCaz8NbU5cL34py23BJ0Sn4Z+w5f8o9pQs13u/W16B
EwP+8dQ2+/kRBNHVCxSA
=TqZL
-----END PGP SIGNATURE-----

--G44BJl3Aq1QbV/QL--
