Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750971AbcISUjM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 16:39:12 -0400
Date: Mon, 19 Sep 2016 22:39:06 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 06/17] smiapp: Remove unnecessary BUG_ON()'s
Message-ID: <20160919203906.c5dvmtec44qhu2oe@earth>
References: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
 <1473938551-14503-7-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vsaqyvzvpazc3ysm"
Content-Disposition: inline
In-Reply-To: <1473938551-14503-7-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--vsaqyvzvpazc3ysm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Thu, Sep 15, 2016 at 02:22:20PM +0300, Sakari Ailus wrote:
> Instead, calculate how much is needed and then allocate the memory
> dynamically.

Reviewed-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--vsaqyvzvpazc3ysm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJX4EzqAAoJENju1/PIO/qaT2oP/0FwF19lEIa9o1K+U8cnqj3k
sTTRHd/uqPTwgyLaWnZdx31/+2yKqChuy24sOG+2FGW019VMj5JX3NFruO9F82yP
hm1ndNucXkmIIVJBUpox9CNcnXn2vE0AunF4U3L7aj+10X9x81AtsMr/wsWC25pV
QlgUF7FVgcDRlirNAegiEAY6KaALzYKXV7KdSZ3Nyo8k6mLjL/9lhccOU6RDI/Sz
7m9JW/UCCkBH0+kQHpJmQqjUSHVY9vSsjQFRRcpCij7jbgK/sh4JDBJri4iG/j+J
JnMLai3PkzrtbUcevAsyMgcX3aJYuJy8NkCWYkeqhzjVMLxxk9hvv+RiOazc3xdJ
DyhdpsXKsIQj6KqJw1t97pwFJXD01at0ZQ5dpynH2jh3m+xdPJ0+td3ZKN4s2Jrt
2of+DplJQtmBwFWx6bHpMesortvY7+O692ic8CwXJ340TEumYCvr6NOFlRnuFEcH
KCHLn2wnuJto+OEybhDkgPRiFkJuBzW812OPT4uEoa6vMdBdoRjD324jm9UbAo4k
8C52sqWSFtGlksSZRB0fLSpVjneF6B+NYHE6ddfC0sumlYuTo0ftuJV5rwOD7c18
+EwvzZuJvLTbTZ+Lx2VRkMaUJ0koGD2dUWQ1lthYu5Mu0ZilWkTVtP3NgY5XImN0
n0AlpBWT1ieW7vv4mqYr
=lN72
-----END PGP SIGNATURE-----

--vsaqyvzvpazc3ysm--
