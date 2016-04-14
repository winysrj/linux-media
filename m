Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:42788 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013AbcDNOT6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Apr 2016 10:19:58 -0400
Date: Thu, 14 Apr 2016 16:19:45 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-i2c@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: tvp5150 regression after commit 9f924169c035
Message-ID: <20160414141945.GA1539@katana>
References: <20160212221352.GY3500@atomide.com>
 <56BE5C97.9070607@osg.samsung.com>
 <20160212224018.GZ3500@atomide.com>
 <56BE65F0.8040600@osg.samsung.com>
 <20160212234623.GB3500@atomide.com>
 <56BE993B.3010804@osg.samsung.com>
 <20160412223254.GK1526@katana>
 <570ECAB0.4050107@osg.samsung.com>
 <20160414111257.GG1533@katana>
 <570F9DF1.3070700@osg.samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <570F9DF1.3070700@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> Yes, I also wonder why I'm the only one facing this issue... maybe no one
> else is using the tvp5150 driver on an OMAP board with mainline?

I wonder why it only affects tvp5150. I don't see the connection yet.


--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXD6cBAAoJEBQN5MwUoCm2CSsP/RXl+PdNZZNw0sjGApuDq0Pa
kclrMtdovb8Jx0zKVERo/SErRbUZwYW8A2TR7ayRZ+lDvPkpueHrcchqh9hr14R7
Dnw23tOwhAcIVZuxRZQ6dQpjkdEu30ZsnFKJD4zjjUBkitLRw8l2/LVTlmH6i0VQ
aUztPJyarwXARuLi/nB30jVFMdnT5OnW8D8k8m0utCG4C3h5ZW/zZWtMuVF+TSnQ
zI7u2WmM8FLrMyk1CiSLniyGgmUEv2CRRu4oWxC4CR4ezOkFGP0TQxqzv0mM2hOY
C3pS6OIJXUgkX/HtyCyIZ7Y5HAbR53CqfQehGKehlb0k90UockAPzlp0BC/1Myja
OgmhPVHHJ9m82jYTblNqROzDsIhgTIJUBWp6KWMmVNV+KMN5J/ga2b8z8HPljIUv
L4mjRe3MbzyWPTXxFDnxhaYW8tSbkml8mEWOZr/NzjO4lfbDAE0JGDDHq8icTCrH
SkhJNs5Hyh7OsTQHY1I0uSAZsnOqQ+cb1PuXA1IyAo3OTigC1nlBbyhAHdryeCZ3
QPR8yqM8SScdnmsYsd0VA1KqxvwS+Wd++liKmTkMAfpCk0ObD/xwHrrOBA/sU3Fo
1+OG47s5n7xJRDSCvOdFZFkRgFSPAa+GPHrYaDsyHm06ombb10Ux6a6Av4ePOxwS
6GeYBY2es/bit5Cy1q+Q
=C6zT
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
