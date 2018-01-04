Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:46877 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752713AbeADOG1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Jan 2018 09:06:27 -0500
Date: Thu, 4 Jan 2018 15:06:25 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
Cc: Yong <yong.deng@magewell.com>,
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
Message-ID: <20180104140625.5gbeaj5vgetusjlf@flea.lan>
References: <1513935138-35223-1-git-send-email-yong.deng@magewell.com>
 <1513950408.841.81.camel@megous.com>
 <20171225111526.4663f997f5d6bfc6cf157f10@magewell.com>
 <20171225085802.lfyk4blmbqxq6r2m@core.my.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nnhklmqa5czybvrd"
Content-Disposition: inline
In-Reply-To: <20171225085802.lfyk4blmbqxq6r2m@core.my.home>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nnhklmqa5czybvrd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 25, 2017 at 09:58:02AM +0100, Ond=C5=99ej Jirman wrote:
> Hello,
>=20
> On Mon, Dec 25, 2017 at 11:15:26AM +0800, Yong wrote:
> > Hi,
> >=20
> > On Fri, 22 Dec 2017 14:46:48 +0100
> > Ond=C5=99ej Jirman <megous@megous.com> wrote:
> >=20
> > > Hello,
> > >=20
> > > Yong Deng p=C3=AD=C5=A1e v P=C3=A1 22. 12. 2017 v 17:32 +0800:
> > > >=20
> > > > Test input 0:
> > > >=20
> > > >         Control ioctls:
> > > >                 test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Suppo=
rted)
> > > >                 test VIDIOC_QUERYCTRL: OK (Not Supported)
> > > >                 test VIDIOC_G/S_CTRL: OK (Not Supported)
> > > >                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
> > > >                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Su=
pported)
> > > >                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
> > > >                 Standard Controls: 0 Private Controls: 0
> > >=20
> > > I'm not sure if your driver passes control queries to the subdev. It
> > > did not originally, and I'm not sure you picked up the change from my
> > > version of the driver. "Not supported" here seems to indicate that it
> > > does not.
> > >=20
> > > I'd be interested what's the recommended practice here. It sure helps
> > > with some apps that expect to be able to modify various input controls
> > > directly on the /dev/video# device. These are then supported out of t=
he
> > > box.
> > >=20
> > > It's a one-line change. See:
> > >=20
> > > https://www.kernel.org/doc/html/latest/media/kapi/v4l2-controls.html#=
in
> > > heriting-controls
> >=20
> > I think this is a feature and not affect the driver's main function.
> > I just focused on making the CSI main function to work properly in=20
> > the initial version. Is this feature mandatory or most commonly used?
>=20
> I grepped the platform/ code and it seems, that inheriting controls
> from subdevs is pretty common for input drivers. (there are varying
> approaches though, some inherit by hand in the link function, some
> just register and empty ctrl_handler on the v4l2_dev and leave the
> rest to the core).
>=20
> Practically, I haven't found a common app that would allow me to enter
> both /dev/video0 and /dev/v4l-subdevX. I'm sure anyone can write one
> themselves, but it would be better if current controls were available
> at the /dev/video0 device automatically.
>=20
> It's much simpler for the userspace apps than the alternative, which
> is trying to identify the correct subdev that is currently
> associated with the CSI driver at runtime, which is not exactly
> straightforward and requires much more code, than a few lines in
> the kernel, that are required to inherit controls:

And it becomes much more complicated once you have the same controls
on the v4l2 device and subdevice, which is not that uncommon.

Maxime



--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--nnhklmqa5czybvrd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlpONOAACgkQ0rTAlCFN
r3Rs5Q//YLSLMwb1Age/HpT5S5h7AAMyD70Uq04lOC/U7YoCvYGcybYGZ0zvpjjF
RfH8BaJ3HJzfzz0Y6buVK5UVwra/bjuKpcqECC8TyJgvMrX6oOLNLtRfwBeuT7na
/c6kz0LuYUrjkaidQlTpMXWCNgpK8shOt32VkLexy/6Q17Su7QFIZJseIbCAgVd/
b0pEL/dYSzh/QfmOA5sn9d9gg76uT/wZ17wKMgG4IOELCuaLOBiHTg6yJig1Safx
jRpWoTOkLwvHp0hhwDH7yY7o4yCN6E17NBlYeGN4mvIZ2FG/NlFXiaAQALIXRj89
Qn0RTCPVb8ipgiss0aimPIst5w/WJHSEAJkJOj8Dx66Cg1qD6VL1dELQdwfIxFcG
9jNVlMeYKfcRD/aPklEJqYpWMKSFXaJJbcWqAOTo9B2LEHec5aEQhKMZ8z355rZT
F5FZNYSe/0NBIxUVmDTtJFkqoO7c3mBYmZvxx9KBC/r50zQJteVeXRNwRfjsH2Le
jkyThgVkSMdGZJD7hMyExLsw2K6dq7+ztoKNY1drDledpRlu4dnjzophZ6Zt33dJ
ArmnyY+lofB0l7aeabZgiTWwnAF6hc6VJKml3gLloa3qJ1eLbHUJAjBsscltgpSO
XYaWiaYGeUHh8SM6P30MvIiYxi5x+lctXwIX6dE+YSC17fGCn/A=
=ZplK
-----END PGP SIGNATURE-----

--nnhklmqa5czybvrd--
