Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57635 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751453AbeB1Clo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 21:41:44 -0500
Message-ID: <1519785692.2617.355.camel@decadent.org.uk>
Subject: Re: [PATCH for v3.2 00/12] v4l2-compat-ioctl32.c: remove
 set_fs(KERNEL_DS)
From: Ben Hutchings <ben@decadent.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>, stable@vger.kernel.org
Cc: linux-media@vger.kernel.org
Date: Wed, 28 Feb 2018 02:41:32 +0000
In-Reply-To: <20180214120323.28778-1-hverkuil@xs4all.nl>
References: <20180214120323.28778-1-hverkuil@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-3NkgZ32zMfAFyvHUcN6c"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-3NkgZ32zMfAFyvHUcN6c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-02-14 at 13:03 +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>=20
> This patch series fixes a number of bugs and culminates in the removal
> of the set_fs(KERNEL_DS) call in v4l2-compat-ioctl32.c.
>=20
> This was tested with a VM running 3.2, the vivi driver (a poor substitute=
 for
> the much improved vivid driver that's available in later kernels, but it'=
s the
> best I had) since that emulates the more common V4L2 ioctls that need to =
pass
> through v4l2-compat-ioctl32.c) and the 32-bit v4l2-compliance + 32-bit v4=
l2-ctl
> utilities that together exercised the most common ioctls.
>=20
> Most of the v4l2-compat-ioctl32.c do cleanups and fix subtle issues that
> v4l2-compliance complained about. The purpose is to 1) make it easy to
> verify that the final patch didn't introduce errors by first eliminating
> errors caused by other known bugs, and 2) keep the final patch at least
> somewhat readable.

Thanks, I've queued up all of these.  Again, I rebased these on top
of some earlier fixes to v4l2-compat-ioctl32.c which you incorporated
into your backports.

Ben.

> Regards,
>=20
> 	Hans
>=20
> Daniel Mentz (2):
>   media: v4l2-compat-ioctl32: Copy v4l2_window->global_alpha
>   media: v4l2-compat-ioctl32.c: refactor compat ioctl32 logic
>=20
> Hans Verkuil (10):
>   media: v4l2-ioctl.c: don't copy back the result for -ENOTTY
>   media: v4l2-compat-ioctl32.c: add missing VIDIOC_PREPARE_BUF
>   media: v4l2-compat-ioctl32.c: fix the indentation
>   media: v4l2-compat-ioctl32.c: move 'helper' functions to
>     __get/put_v4l2_format32
>   media: v4l2-compat-ioctl32.c: avoid sizeof(type)
>   media: v4l2-compat-ioctl32.c: copy m.userptr in put_v4l2_plane32
>   media: v4l2-compat-ioctl32.c: fix ctrl_is_pointer
>   media: v4l2-compat-ioctl32.c: copy clip list in put_v4l2_window32
>   media: v4l2-compat-ioctl32.c: drop pr_info for unknown buffer type
>   media: v4l2-compat-ioctl32.c: don't copy back the result for certain
>     errors
>=20
>  drivers/media/video/Makefile              |   7 +-
>  drivers/media/video/v4l2-compat-ioctl32.c | 966 ++++++++++++++++++------=
------
>  drivers/media/video/v4l2-ioctl.c          |   6 +-
>  3 files changed, 597 insertions(+), 382 deletions(-)
>=20
--=20
Ben Hutchings
If the facts do not conform to your theory, they must be disposed of.


--=-3NkgZ32zMfAFyvHUcN6c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAlqWFt0ACgkQ57/I7JWG
EQnJyRAAqSeQ9lP/1c0sNuKq7a1liFLy+xFJzrvCndmHxXkt9ellGjvvqx5BsJtw
QyurrUzj+XkJo0EBq0olONaSj/UJ9fKVQnl1rEUmX+MpiANNu13JtSI35RHIfEGc
f754WqJaZomrsUA2YRfwEDq2G0MYTy7Tre6udyn1VI1Cf8P+63MYEkstE2ASKGnx
2av1SY9dsaN6JDAVQ1459H9NSy+cRAZG+TnvhqDGH9HmV+RlcruwouxHDGz2m4ur
IGhgYM2+09nZ7q7JkU3jxSWk3m6FY9QZGzSHg6eZs4dVxCQjVyD7AWcM6+eJhYTp
w5SNeQny61KoFrrq24WGN9m6xxe6I+OYSWq13FQ7xPWyQIDTlKlORW8RpnRjkOwf
w+r2nyFHQeFzDNq/EnQ7UPAXOU6BNqWPzjMH3Ao8+dDlqLvCIYAAWP1pbkGyf2Sl
/UwNo0tLU48wyXWuwbOA72fewzYqIMoerwsShi3U/xYWxGscJqyMz9PpznzAK69K
TPQteJxo0P/3AA8cf2hd+VHWydtidu3WCHxVh6/CfgasdNzLjIKVCWqpYcvN2idT
24VlrBrpT4XPJaRVE9rjbe8thLR0vUX48EQMpc+CQ5A2WVwfSZeN7P8SRjRTOVOK
t9BKJN0KpqaRxGtIs8Efp9q6owM9BqJYTZqHRcOD3zq+5Z3yy/0=
=cPD0
-----END PGP SIGNATURE-----

--=-3NkgZ32zMfAFyvHUcN6c--
