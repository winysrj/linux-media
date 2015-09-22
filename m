Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate16.nvidia.com ([216.228.121.65]:16764 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757670AbbIVMUp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 08:20:45 -0400
Date: Tue, 22 Sep 2015 14:20:35 +0200
From: Thierry Reding <treding@nvidia.com>
To: Bryan Wu <pengw@nvidia.com>
CC: <hansverk@cisco.com>, <linux-media@vger.kernel.org>,
	<ebrower@nvidia.com>, <jbang@nvidia.com>, <swarren@nvidia.com>,
	<davidw@nvidia.com>, <gfitzer@nvidia.com>, <bmurthyv@nvidia.com>
Subject: Re: [PATCH 3/3] Documentation: DT bindings: add VI and CSI bindings
Message-ID: <20150922122033.GD1417@ulmo.nvidia.com>
References: <1442861755-22743-1-git-send-email-pengw@nvidia.com>
 <1442861755-22743-4-git-send-email-pengw@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <1442861755-22743-4-git-send-email-pengw@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="JgQwtEuHJzHdouWu"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--JgQwtEuHJzHdouWu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2015 at 11:55:55AM -0700, Bryan Wu wrote:
> Signed-off-by: Bryan Wu <pengw@nvidia.com>
> ---
>  .../bindings/gpu/nvidia,tegra20-host1x.txt         | 211 +++++++++++++++=
+++++-
>  1 file changed, 205 insertions(+), 6 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/gpu/nvidia,tegra20-host1x.=
txt b/Documentation/devicetree/bindings/gpu/nvidia,tegra20-host1x.txt
[...]
> +  - ports: 2 ports presenting 2 channels of CSI. Each port has 2 endpoin=
ts:
> +    one connects to sensor device tree node as input and the other one c=
onnects
> +    to VI endpoint.

It looks to me like we'll only need the first of these endpoints. The
connection to the VI is implied. Even more so if the CSI nodes are moved
into the VI node as children (which I really think they should be).

Thierry

--JgQwtEuHJzHdouWu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWAUeRAAoJEN0jrNd/PrOhwlQP/RKYToDpkzkJHtrvleX3nlpq
2ar+pG8eiXraUpre+RTF1Xd3CHJH7kw6V+mb1bOHQy/iRPEAquOPz8iFww0hWF1X
OUGTAd0VbBCVnyb8lF8SV9h7s1UavsTlKq1maYNMSBSplt4r2s1y8cfFo7+rm7K8
DuNsS2vzoDeANZP75sPVFYYnQd8FMvPDNVxNSlvDVeeo8ElhyRvdhvXw0TEnO/b7
DKpo3J7QENtVWMfff3FgEhWK5fot152E0ljayhDL+oBjDrpqBcCggeI/oQ8T7E5D
/CGXgV06SJR2VbLT79P4g9VTvfAXooRlJLKJ8xeaQmWvB2CsBNk8uYsSZImBU9n9
vSMvyFXuSc+TBH3P8cXvckP4zPWPsm8dXQY5K96TCUXqsO9AZ7xj0iJBamJabc4V
Cps6woLHAUfTEDcxssEBKbOJGQ0Wktb3cNtw9J96VaEsAt6IAll6I/JTTzcGp/Ne
0qxVQv0uMJgOlYjXsvOJQcQdkk87yxFMhmMdiTMgBh/qSIaCRkrIkI4VLXXk/QIn
5qK6G+9HO2qr1RQ81iS0JTpsK4CzZCcfPNOegFXcKPtQGBVuXB3XoXIhaRN38A34
yo5K1wsT/n/xZ5QirlO+hDLs8E6dtQxbd6vDuL+lgaexqxA4cqU6xNNOeDoNxyco
bn3GWVckLFjwmnIkchTJ
=bVL/
-----END PGP SIGNATURE-----

--JgQwtEuHJzHdouWu--
