Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:52288 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752313AbdJSJiP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 05:38:15 -0400
Date: Thu, 19 Oct 2017 11:38:11 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv4 4/4] drm/tegra: add cec-notifier support
Message-ID: <20171019093811.GG9005@ulmo>
References: <20170911122952.33980-1-hverkuil@xs4all.nl>
 <20170911122952.33980-5-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7lMq7vMTJT4tNk0a"
Content-Disposition: inline
In-Reply-To: <20170911122952.33980-5-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--7lMq7vMTJT4tNk0a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 11, 2017 at 02:29:52PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>=20
> In order to support CEC the HDMI driver has to inform the CEC driver
> whenever the physical address changes. So when the EDID is read the
> CEC driver has to be informed and whenever the hotplug detect goes
> away.
>=20
> This is done through the cec-notifier framework.
>=20
> The link between the HDMI driver and the CEC driver is done through
> the hdmi_phandle in the tegra-cec node in the device tree.
>=20
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/gpu/drm/tegra/Kconfig  | 1 +
>  drivers/gpu/drm/tegra/drm.h    | 3 +++
>  drivers/gpu/drm/tegra/hdmi.c   | 9 +++++++++
>  drivers/gpu/drm/tegra/output.c | 6 ++++++
>  4 files changed, 19 insertions(+)

I've applied this to drm/tegra/for-next.

Thanks,
Thierry

--7lMq7vMTJT4tNk0a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAlnocoMACgkQ3SOs138+
s6GqExAAiTqswpXhw3CJpQRU1QAFmyNrdIV6rQjVoSVbu9mWqg4LkUJrKsDq3wux
Y9ZQs6mvsIixjO2WeiLzq7zObYTo88dmMwqEi1+LYWYIAoG/SRZnXM1qb7fIIaQO
JS5w22yz9qe0WOQZvj7W8PEtC+R9hGtaCEOTX80UId9VMHNuu08RKfc9wUf1zT7z
BKz60Pvg+L/VftC9JxFszxtRku3ntnHlrs1rVCgOaAnIkLDrwS/a4aXwK0lClT0D
SuGustGTzgngRZOGJa7XW6XORjfOtgdgJrfg+X5oz3DF51O+hrhIWyQYHhQ9bMAs
YCKgoLu02E+m8ODWKo2SFBWN/OPSM5nA2wxLuJJB/QRjQ2ZDhTB3vCVLrQb2zm30
eqXiDEs8Fo+mmilNyiWLdWh3m2+7y3/TIX70yQWL4cmyFxNkP+LCXkH3YwiLZBGu
s7QmvI0FhxGZUD8fGhtg7PkFj8lO1evV2sLqLI0UAcDFnuHUjOIOquOHCptJh8w3
ZchzkDbJBAVx3ii8Dsk/Ny9sR2bkin9NyhTDdfUwouibQSoZkAoqdcCBzlgsTQou
Cx1Y3zNhGnFUEUxO0lr5kg/n8T80WxERx9Jd3H9p1TCJn0wyWhCtU4/qArmqrsk7
dqFFsaloBHXTgMeAjwSBUAYRTSWNVIXtKXykUpgQctM+ybq4UvY=
=lD6w
-----END PGP SIGNATURE-----

--7lMq7vMTJT4tNk0a--
