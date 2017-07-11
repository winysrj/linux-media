Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:40590 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753498AbdGKUkD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 16:40:03 -0400
Date: Tue, 11 Jul 2017 22:39:17 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 00/11] drm/sun4i: add CEC support
Message-ID: <20170711203917.gcpod5gcsy6zbkyx@flea>
References: <20170711063044.29849-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ek23d4iy5gnm3uen"
Content-Disposition: inline
In-Reply-To: <20170711063044.29849-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ek23d4iy5gnm3uen
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 11, 2017 at 08:30:33AM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>=20
> This patch series adds CEC support for the sun4i HDMI controller.
>=20
> The CEC hardware support for the A10 is very low-level as it just
> controls the CEC pin. Since I also wanted to support GPIO-based CEC
> hardware most of this patch series is in the CEC framework to
> add a generic low-level CEC pin framework. It is only the final patch
> that adds the sun4i support.
>=20
> This patch series first makes some small changes in the CEC framework
> (patches 1-4) to prepare for this CEC pin support.
>=20
> Patch 5-7 adds the new API elements and documents it. Patch 6 reworks
> the CEC core event handling.
>=20
> Patch 8 adds pin monitoring support (allows userspace to see all
> CEC pin transitions as they happen).
>=20
> Patch 9 adds the core cec-pin implementation that translates low-level
> pin transitions into valid CEC messages. Basically this does what any
> SoC with a proper CEC hardware implementation does.
>=20
> Patch 10 documents the cec-pin kAPI (and also the cec-notifier kAPI
> which was missing).
>=20
> Finally patch 11 adds the actual sun4i_hdmi CEC implementation.
>=20
> I tested this on my cubieboard. There were no errors at all
> after 126264 calls of 'cec-ctl --give-device-vendor-id' while at the
> same time running a 'make -j4' of the v4l-utils git repository and
> doing a continuous scp to create network traffic.
>=20
> This patch series is based on top of the mainline kernel as of
> yesterday (so with all the sun4i and cec patches for 4.13 merged).

For the whole serie:
Reviewed-by: Maxime Ripard <maxime.ripard@free-electrons.com>

> Maxime, patches 1-10 will go through the media subsystem. How do you
> want to handle the final patch? It can either go through the media
> subsystem as well, or you can sit on it and handle this yourself during
> the 4.14 merge window. Another option is to separate the Kconfig change
> into its own patch. That way you can merge the code changes and only
> have to handle the Kconfig patch as a final change during the merge
> window.

We'll probably have a number of reworks for 4.14, so it would be
better if I merged it.

However, I guess if we just switch to a depends on CEC_PIN instead of
a select, everything would just work even if we merge your patches in
a separate tree, right?

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--ek23d4iy5gnm3uen
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZZTd1AAoJEBx+YmzsjxAgqO4P/3KsMeBqwzvGRkfZgF5xPEFS
CvuzJfN4a7dDsmppgcPVR9R6XGGJ8Atvmo2FJAyCNhpkKX7oEkDjgaVLM1LFflqf
coCZHhUAFGjBMhdiurksGJd1162ZKpEUXgBIfVYWjcX+b/6+SlRRVuNaUIYamCvf
gogdOaq07PHU8/DKe7LeZIkZidhct/u85ChsJ6vBU5W9QtfC5RwxKxeaL71/jM27
oYh5bO2k35nmsSNLGCZb1Rm4R3uWWaUMVYBFCws2T1Z52MEFEfYioeMxWvcHrUcb
2dLhsixrH8rZMexHVvOqfLvkbGhjqfRO/c19eEBHMLqTZ20qyGjWxsRkpk+edfJJ
Gp5109NeQhGihc1IDFgT8gFghXdcafLejweVvVxV5ZTk+rOOnq9ifEKI8x3y03JG
2if1CiP9Cq02yOnpHLtr3GdmK31OaHP1WmD/mKnnlN4K7EajAcOoYn607Hb6aUZF
ZZUuP0QeRDH3OIR6fRV6MqCfTt0R8913V/vQXjX20XaJfFUixylQZv4xkVbb+TJV
KqvacERIU14O9yJ+vmgGsIFIX4oTr4aNqNJKTpAbU7NetEIUJFQf/L/ip/IdE2uz
iTjeuAfQXuB3mrPzlHboGNxjCcal0gYOF6zDYuQAvJyff6GhU1Mh/EvuJ/Q8UG14
EqVYHocm8YJEaaXvMCqf
=tZT8
-----END PGP SIGNATURE-----

--ek23d4iy5gnm3uen--
