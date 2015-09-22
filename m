Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate15.nvidia.com ([216.228.121.64]:17306 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbbIVMWN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 08:22:13 -0400
Date: Tue, 22 Sep 2015 14:22:02 +0200
From: Thierry Reding <treding@nvidia.com>
To: Bryan Wu <pengw@nvidia.com>
CC: <hansverk@cisco.com>, <linux-media@vger.kernel.org>,
	<ebrower@nvidia.com>, <jbang@nvidia.com>, <swarren@nvidia.com>,
	<davidw@nvidia.com>, <gfitzer@nvidia.com>, <bmurthyv@nvidia.com>
Subject: Re: [PATCH 3/3] Documentation: DT bindings: add VI and CSI bindings
Message-ID: <20150922122201.GE1417@ulmo.nvidia.com>
References: <1442861755-22743-1-git-send-email-pengw@nvidia.com>
 <1442861755-22743-4-git-send-email-pengw@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <1442861755-22743-4-git-send-email-pengw@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="IDYEmSnFhs3mNXr+"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--IDYEmSnFhs3mNXr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 21, 2015 at 11:55:55AM -0700, Bryan Wu wrote:
> Signed-off-by: Bryan Wu <pengw@nvidia.com>
> ---
>  .../bindings/gpu/nvidia,tegra20-host1x.txt         | 211 ++++++++++++++++++++-
>  1 file changed, 205 insertions(+), 6 deletions(-)

Also you probably want to include devicetree@vger.kernel.org on the
binding patch to give people the chance to review.

Thierry

--IDYEmSnFhs3mNXr+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWAUfpAAoJEN0jrNd/PrOhEaEP/RYYDIl6EubpGVeFjVltPtr8
oGcw0OXKWkVyYIMiFX2/ETBIx+uP8nePv/XACkVQn2JmsiesAfNes3sA/6rGvRtH
pD9pwkpzZtjmXsiyM4JEvp+GuQPrl7GcOjfT5axOtjRwLaXvMO0VGmb765bk5l9b
ipjEJJtD8RQSepuQUfmCIR53rOvESMmN7m0r4RrUEXZI1ui6edWcqfiNxTA4P7Wu
Qv5ToXDHGpORIqhYlxoyN89pxmwCdqd+lz/nJ6Xk0OxeRR8h9MTvqJojIvVFXOVv
y89zpuPz+1HtFNavO07qluwcVUk0SPjuxCZAhaqcrlcx0IIceG6j0n/hvzZLSqgY
E0IaPglHqR7QDULRl6zbW1jxuWdRFBjrsCVQpFhcN8E84GRUYxM6dukT9KgItizB
DrKIK9eGXtOd760rg2JQINz3I4PqNuPZZuE8smq/GeG8Cq1YRHRu5DTowujsHaJ8
6rOW0e2hULQ68q0TLHBO4cisSOsq5tG0BUBbYrwyPGIfHAVtB800f899J94V3GJC
PfAmF4lTqZmB2wxehgVj1YrJTGM6DFl+zC52UUdXe1RaCx6SYVnAKlLs8Hpjj36e
VJ+G8YJSS5iOnV92s2EutTnKgK3ICWFapFODF5qcLgH2D63vpwcUg89haXXer4ca
h/yNA2KfDWJdrVE+ALJz
=s2xL
-----END PGP SIGNATURE-----

--IDYEmSnFhs3mNXr+--
