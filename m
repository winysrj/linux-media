Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934941AbcHaN5i (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 09:57:38 -0400
Date: Wed, 31 Aug 2016 15:57:33 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v1.1 3/5] smiapp: Return -EPROBE_DEFER if the clock
 cannot be obtained
Message-ID: <20160831135733.rkc3a6ognfmnohnr@earth>
References: <1472629325-30875-4-git-send-email-sakari.ailus@linux.intel.com>
 <1472648277-25888-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ci3e7u6tspka3sw3"
Content-Disposition: inline
In-Reply-To: <1472648277-25888-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ci3e7u6tspka3sw3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Aug 31, 2016 at 03:57:57PM +0300, Sakari Ailus wrote:
> The clock may be provided by a driver which is yet to probe. Print the
> actual error code as well.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>
> ---
> since v1:
> - Add printing of the original error code

Reviewed-By: Sebastian Reichel <sre@kernel.org>

--ci3e7u6tspka3sw3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJXxuJKAAoJENju1/PIO/qayA8P/jwmIlvvVkaCESsY3rr4mEYZ
ytVwUfBrkjSgv89Z8mgBH/vfbNObo+muU33O6GsTxAazdNpWlywWMIOe13tfk/3t
i5spzKsVid2J46cMvueeqwksUY1AwKvu6DhTNDd+FLO2rnq/mOeJG6LyW7XMD2ab
IRQZf8OjCL8l9E+OIT5mUFQDV/gYmU7HGQchH9oprF6O0NOIQhuuSx1aW8HUDjtp
Yg1YXbzyv6LwGTyBHON8W9uC55Zq8j9RGMyOKPLs4YM9a7QHcaTuy802w0GUKu6d
iI0aEzUHyzuSn165elKQmy0SjyxTHdu5qVseapdemH1sn88LqExxL6oG6+uLN61M
Q9D+DQQLL8XKTFpwwbKEWodBL56npnkeu+tC0/X2gHwukcRI1kv5eUbyTLQtWQko
NyPtstjQsZSHpf3psOb4E4sji/Dl+uyQvGVxu63tknq4QXHpGFfRnr6E2pbo2QLG
I5cMrSY+NgO9K3SMCHHPXyXvD5bE705l/2H9UJSO56lBBG6RW5UfcGWSx+rs7DXD
lYSJWxpM0k6pNCyu2Ij0AsKN+pcOmMVy2yKhRJenRqIOUnv/jFJORt2P3w1hVTqh
9yBI8xpZIua7xKNjOwU7kqSRCO9bKP4R+t6Xr9ZjeUTDM8qJSsCNojUXQehMtgHj
KUxbKH2r7OlU+qmiWlnh
=tt1w
-----END PGP SIGNATURE-----

--ci3e7u6tspka3sw3--
