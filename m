Return-path: <linux-media-owner@vger.kernel.org>
Received: from ring0.de ([5.45.101.7]:54878 "EHLO ring0.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752729AbcISVdQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 17:33:16 -0400
Date: Mon, 19 Sep 2016 23:33:14 +0200
From: Sebastian Reichel <sre@ring0.de>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 15/17] smiapp: Obtain correct media bus code for try
 format
Message-ID: <20160919213313.cbungdfsrcmouxya@earth>
References: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
 <1473938551-14503-16-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zmq4ybmdnzqksnlv"
Content-Disposition: inline
In-Reply-To: <1473938551-14503-16-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--zmq4ybmdnzqksnlv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Thu, Sep 15, 2016 at 02:22:29PM +0300, Sakari Ailus wrote:
> The media bus code obtained for try format may have been a code that the
> sensor did not even support. Use a supported code with the current pixel
> order.

Reviewed-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--zmq4ybmdnzqksnlv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJX4FmZAAoJENju1/PIO/qaTcoP/1EiEVn/XdAtmlrOL09I89Oq
zhUvgxD8yFoOGxFdVpi9EOAWtuqTAFeSbsgiXifMmgYfgp3azzUlnJIUJzK+W9co
YPdnnSxbOlGc/7QsIb9EiQ00NSnwf6xBKX+SlhyoyTgbv0AlBIF8gQNL/AUoPuow
uWKmp4n7kCHdOmh1yfiqoRfsu9fBuM/uUG+O2Ha/rLnZovpYDLrMMcHlvGEJ/5Rd
RPCR5BIeer9/lld9wufb06KhUxitHAVLRfkKlusV5gLg6RjW12bw6htOn0qHaOrW
+OvU1BH1+xPRSFZjDFxK/STQrHm9eBMPT6LYC2VRVJmnn2NG6oxsZcpGKPojimkG
HGdfG2Qc036uOQHTbJZs550Bmi+k7LdF/2+qDJR1rk3Ss+Gl1GapLNTpc6958Xys
8YtgDdPnqS8SZsdtpjml9Qm9eK6xJOMpw0+dqP10j9Yd83Gnm8Au5OPUyh+2DzWv
3/D2RqSvVPCYpxAaqLyCo7LOFN7ZJaUXAkcLRvdP+FFH5hqGxRIvTHPthkHuotke
/CM+JcLWXkXqWo5q9lCEtotnn5upby5OU5Ew5P0Is5N5N5xf3DQi8s8v/ayEdirQ
lKWRcLNg6mFlCb3KMhTNY8zTtmwtPVTACiUuBLOMXuO0ClX4FlbmbvfIr8z2XMYs
TxTRTw3LRvOrKl8Mxp36
=i57q
-----END PGP SIGNATURE-----

--zmq4ybmdnzqksnlv--
