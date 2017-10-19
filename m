Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:47293 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751955AbdJSJU6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 05:20:58 -0400
Date: Thu, 19 Oct 2017 11:20:54 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCHv4 0/4] tegra-cec: add Tegra HDMI CEC support
Message-ID: <20171019092054.GC9005@ulmo>
References: <20170911122952.33980-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="p2kqVDKq5asng8Dg"
Content-Disposition: inline
In-Reply-To: <20170911122952.33980-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--p2kqVDKq5asng8Dg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 11, 2017 at 02:29:48PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>=20
> This patch series adds support for the Tegra CEC functionality.
>=20
> This v4 has been rebased to the latest 4.14 pre-rc1 mainline.
>=20
> Please review! Other than for the bindings that are now Acked I have not
> received any feedback.
>=20
> The first patch documents the CEC bindings, the second adds support
> for this to tegra124.dtsi and enables it for the Jetson TK1.
>=20
> The third patch adds the CEC driver itself and the final patch adds
> the cec notifier support to the drm/tegra driver in order to notify
> the CEC driver whenever the physical address changes.
>=20
> I expect that the dts changes apply as well to the Tegra X1/X2 and possib=
ly
> other Tegra SoCs, but I can only test this with my Jetson TK1 board.
>=20
> The dt-bindings and the tegra-cec driver would go in through the media
> subsystem, the drm/tegra part through the drm subsystem and the dts
> changes through (I guess) the linux-tegra developers. Luckily they are
> all independent of one another.
>=20
> To test this you need the CEC utilities from git://linuxtv.org/v4l-utils.=
git.
>=20
> To build this:
>=20
> git clone git://linuxtv.org/v4l-utils.git
> cd v4l-utils
> ./bootstrap.sh; ./configure
> make
> sudo make install # optional, you really only need utils/cec*
>=20
> To test:
>=20
> cec-ctl --playback # configure as playback device
> cec-ctl -S # detect all connected CEC devices

I finally got around to test this. Unfortunately I wasn't able to
properly show connected CEC devices, but I think that may just be
because the monitor I was testing against doesn't support CEC. I
will have to check against a different device eventually to check
that it properly enumerates, though I suspect you've already done
quite extensive testing yourself.

Thanks for doing this!

Thierry

--p2kqVDKq5asng8Dg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAlnobnIACgkQ3SOs138+
s6EZQhAAqeg2RhJGig8cIOH8Isj0CVYUHoTD8JxET9VAawfpmBlCl8k5/bJE+Ajr
7s6pfyQRymH+A2apL806B7NW/y7nVLgoE0cpOOe9gZg37XkR1IGndyX+fWSmz68R
R3rgN9dveLpJNa5dEtE4/fUCZlw1eNj8gxfAAGwGjUwTNmsBgIm4svEdugABoLuD
dnbv15JOjEBbblMXGw42ibO9R5vusn8P++WA+VgwQ7svt9DvQ3ldooY5pxruLael
dYRemwZeJBqbddJC1xALLTXIEPNB2GMtMI/nNR1wFUXB3+xRR8LJMQJf7q6qbgJf
n9lPq2gJdWK16CPKKJLRNvDLRDejU5xYf0Allh3VqCWjNUiX2VTpOIH6mP9hB/6v
Nrhp2JRnRnbInU97krYgpySaOtbJ7/RaqhjFZ3sfM23qgOOi5A2zpXZZizYMHvpW
Nzup2KjUfhZ85AVaBnuxrDOzjzvuTyUnRIO2e69CHBDSewlfuTnZVLhFkY0PC6dD
UnzIj50JZxMi5XF2u1Xr0veWVWv6g9tUdLY0wTmeFJBQ5WGrkenpED00aGu0Xh7A
RRq5esn0X5ieaXPemip09H4zH2kelcBCAPS0A6/CujwOUmXauVsw5mRRkbJ1S5b8
uEqaRPcQg5skqEpUFwi2VOH/fXOOBT3fzTiQ5t0vuwIDb+PyBZA=
=4/tm
-----END PGP SIGNATURE-----

--p2kqVDKq5asng8Dg--
