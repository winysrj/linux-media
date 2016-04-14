Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:42002 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545AbcDNLNJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Apr 2016 07:13:09 -0400
Date: Thu, 14 Apr 2016 13:12:58 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-i2c@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: tvp5150 regression after commit 9f924169c035
Message-ID: <20160414111257.GG1533@katana>
References: <20160208105417.GD2220@tetsubishi>
 <56BE57FC.3020407@osg.samsung.com>
 <20160212221352.GY3500@atomide.com>
 <56BE5C97.9070607@osg.samsung.com>
 <20160212224018.GZ3500@atomide.com>
 <56BE65F0.8040600@osg.samsung.com>
 <20160212234623.GB3500@atomide.com>
 <56BE993B.3010804@osg.samsung.com>
 <20160412223254.GK1526@katana>
 <570ECAB0.4050107@osg.samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z9ECzHErBrwFF8sy"
Content-Disposition: inline
In-Reply-To: <570ECAB0.4050107@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--z9ECzHErBrwFF8sy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> I'll write what I found so far in case someone with better knowledge about
> the runtime PM API and the OMAP I2C controller driver can have an idea of
> what could be causing this.

Thanks for the summary. I got no other reports like this, I wonder about
that. That being said, can you try this patch if it makes a change?

http://patchwork.ozlabs.org/patch/609280/


--z9ECzHErBrwFF8sy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXD3s5AAoJEBQN5MwUoCm2SuEP/AjB3bOpk/EH93O6Hux6eC4E
yUX5v5hGS8k7twi1pqt6BqkdWpQ0hYlZBWs7pJ3Ge7LurGteRFA9EZHHZFJaqOuU
UX3F6Y0WcX8m2hSdIOWpLzLXhJT6zV14Gi46yxjHXPdyxqtgl7/RX5NNHPFkbTn+
S0CIXNEEIvjhTG/6/kmaSBpvfc96NmgPYWyw9BkIRpZuUrAvOIkGbyGtQDRYTaqa
3790dbT5der6C3CmSkzMQgmbi6Mu5bPiI8cUwdCiD0a0WwzXBdIJGRc/CFDN4hQR
d+QYn4C36H57j8f7v3+/E3emQ4yHGF8ydDgGdgakVKxog70xmMMcIAYAsDsoQtFq
F9+6rOFQWcgjyZMhaRESAcGJO0JLHMw4udw8kv4LSbdiXUN/wYzNTIeDLfrwMzsn
XaEidWP8qII6QcHbp1M91b4J+dFbBFKVG4qSB47LBaoBN7PUPe9ZgdIRkSkjIwjZ
73F+2dlA27EH8Hjr2YNnfNkuVkPiTJz1YdGXKFCWnr3x/y8qLZpwEFXeDq9igx2x
tG/UBb2wQCv/Hv5IYhI+1QrQAnKMXuR38qQqIbR10BMJ8SzUdtFjFQ5HrK+diZQL
jM6fvPDAlI5RRHT0sMeKMmvra16nReVNXkwnYvYh00m12QRP+hYW4Wuhd5xgkT/O
oX5gL/0QqV3KtOe1Rbfk
=Nwro
-----END PGP SIGNATURE-----

--z9ECzHErBrwFF8sy--
