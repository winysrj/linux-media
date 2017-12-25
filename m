Return-path: <linux-media-owner@vger.kernel.org>
Received: from xnux.eu ([195.181.215.36]:58720 "EHLO megous.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750807AbdLYI6H (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Dec 2017 03:58:07 -0500
Date: Mon, 25 Dec 2017 09:58:02 +0100
From: =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
To: Yong <yong.deng@magewell.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Rick Chang <rick.chang@mediatek.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [linux-sunxi] [PATCH v4 0/2] Initial Allwinner V3s CSI Support
Message-ID: <20171225085802.lfyk4blmbqxq6r2m@core.my.home>
References: <1513935138-35223-1-git-send-email-yong.deng@magewell.com>
 <1513950408.841.81.camel@megous.com>
 <20171225111526.4663f997f5d6bfc6cf157f10@magewell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="h5xnflzmelnza4zb"
Content-Disposition: inline
In-Reply-To: <20171225111526.4663f997f5d6bfc6cf157f10@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--h5xnflzmelnza4zb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Mon, Dec 25, 2017 at 11:15:26AM +0800, Yong wrote:
> Hi,
>=20
> On Fri, 22 Dec 2017 14:46:48 +0100
> Ond=C5=99ej Jirman <megous@megous.com> wrote:
>=20
> > Hello,
> >=20
> > Yong Deng p=C3=AD=C5=A1e v P=C3=A1 22. 12. 2017 v 17:32 +0800:
> > >=20
> > > Test input 0:
> > >=20
> > >         Control ioctls:
> > >                 test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Support=
ed)
> > >                 test VIDIOC_QUERYCTRL: OK (Not Supported)
> > >                 test VIDIOC_G/S_CTRL: OK (Not Supported)
> > >                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
> > >                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supp=
orted)
> > >                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
> > >                 Standard Controls: 0 Private Controls: 0
> >=20
> > I'm not sure if your driver passes control queries to the subdev. It
> > did not originally, and I'm not sure you picked up the change from my
> > version of the driver. "Not supported" here seems to indicate that it
> > does not.
> >=20
> > I'd be interested what's the recommended practice here. It sure helps
> > with some apps that expect to be able to modify various input controls
> > directly on the /dev/video# device. These are then supported out of the
> > box.
> >=20
> > It's a one-line change. See:
> >=20
> > https://www.kernel.org/doc/html/latest/media/kapi/v4l2-controls.html#in
> > heriting-controls
>=20
> I think this is a feature and not affect the driver's main function.
> I just focused on making the CSI main function to work properly in=20
> the initial version. Is this feature mandatory or most commonly used?

I grepped the platform/ code and it seems, that inheriting controls
=66rom subdevs is pretty common for input drivers. (there are varying
approaches though, some inherit by hand in the link function, some
just register and empty ctrl_handler on the v4l2_dev and leave the
rest to the core).

Practically, I haven't found a common app that would allow me to enter
both /dev/video0 and /dev/v4l-subdevX. I'm sure anyone can write one
themselves, but it would be better if current controls were available
at the /dev/video0 device automatically.

It's much simpler for the userspace apps than the alternative, which
is trying to identify the correct subdev that is currently
associated with the CSI driver at runtime, which is not exactly
straightforward and requires much more code, than a few lines in
the kernel, that are required to inherit controls:


	ret =3D v4l2_ctrl_handler_init(&csi->ctrl_handler, 0);
	if (ret) {
		dev_err(csi->dev,
			"V4L2 controls handler init failed (%d)\n",
			ret);
		goto handle_error;
	}

	csi->v4l2_dev.ctrl_handler =3D &csi->ctrl_handler;

See: https://github.com/megous/linux/blob/linux-tbs/drivers/media/platform/=
sun6i-csi/sun6i_csi.c#L1005

regards,
  o.j.

> Thanks,
> Yong

--h5xnflzmelnza4zb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEmrE4sgaRYhzUz5ICbmQmxnfP7/EFAlpAvZQACgkQbmQmxnfP
7/GW3g/+MFTSTEdzJ+sVihRzHdiCJmJZwJDdBLH9u2RVHMMb9Av01iPJIgSpylcz
xdBZw0E5IcJyZqfp0G2WwaRWu8aQrFuvNE7OEM9S1MfAg3y3KRUNmS3dYAmHJLHT
8Z85vVlzMP6Kyvab6OKW5oxSmcJvjTeyOKislTwFnpaNVA3kZuFtRQY1+kBGhGMe
RTDUa1j9ZoQvbUc6LR5vGtUYMrXDOtjA+N5pYDptcWtN7w7njpC9qOG1HXfA3Q2r
R8jW05G6h0GlgnL0wdaIq5yigAkBmKzJtJq8McGkQgoBXQmGInWBShS2SQMVKV7I
R9qkzYYTpHFlLI8X0jKst6TcgtXJClq9wdsEJdztVT+/jH2MIkeuNuvPPyyoC+oa
dnZ0v3IWB4iwNTnZtbpy5wGr7GW/1YbBF0MdjCJAUDOuOnYyQA25VLEAfLRdyAh5
HeobbUm017IYTwDAgnvv50CPGFxAEn2oYhYv+94R7zZj8iz66hrxNe3KkggNYMl9
TQ0U3lwue6k8WHqJKwStnH8WmQ8Hf7fAXtBbejjHUzNID54qDG5NRsNM4uzOKBCk
QjkrR/52luxX4wTtZCgIMmeVOjUu+7YDqKwk+cpwf3XpqlNIMfaKZ7yoAlwQ4MLP
oFJVs+9OkbR82GXRUbXR/L0wCzEBqWkkGUeAmELBQCY+AWVVa88=
=8PBH
-----END PGP SIGNATURE-----

--h5xnflzmelnza4zb--
