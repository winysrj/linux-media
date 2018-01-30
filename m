Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:39883 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751530AbeA3J7U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 04:59:20 -0500
Date: Tue, 30 Jan 2018 10:59:16 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Rick Chang <rick.chang@mediatek.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>, megous@megous.com,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH v6 2/2] media: V3s: Add support for Allwinner CSI.
Message-ID: <20180130095916.GA23047@ulmo>
References: <1516695531-23349-1-git-send-email-yong.deng@magewell.com>
 <CACRpkdan52UB7HOyH1gnHWg4CDke_VQxAdq8cBgwUroibE59Ow@mail.gmail.com>
 <20180129082533.6edmqgbauo6q5dgz@flea.lan>
 <CACRpkdYAGwUjr2C-w5U+WuG48pZAOUcnxFjznLbdF6Lmy1uZuQ@mail.gmail.com>
 <CAK8P3a2HmPOTHAzqBnmim388pcWOE=fG50mG5HJifT=vzKOaTg@mail.gmail.com>
 <20180130075441.rqxzkwero6sdfak6@flea.lan>
 <CAK8P3a0QxQE=GM=SGPtT82=UreiqsgY6uMThvQ_woA3rjK0zjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <CAK8P3a0QxQE=GM=SGPtT82=UreiqsgY6uMThvQ_woA3rjK0zjA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 30, 2018 at 10:24:48AM +0100, Arnd Bergmann wrote:
> On Tue, Jan 30, 2018 at 8:54 AM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > On Mon, Jan 29, 2018 at 03:34:02PM +0100, Arnd Bergmann wrote:
> >> On Mon, Jan 29, 2018 at 10:25 AM, Linus Walleij
> >> <linus.walleij@linaro.org> wrote:
> >> > On Mon, Jan 29, 2018 at 9:25 AM, Maxime Ripard
> >> > <maxime.ripard@free-electrons.com> wrote:
> >> >> On Sat, Jan 27, 2018 at 05:14:26PM +0100, Linus Walleij wrote:
>=20
> >>
> >> At one point we had discussed adding a 'dma-masters' property that
> >> lists all the buses on which a device can be a dma master, and
> >> the respective properties of those masters (iommu, coherency,
> >> offset, ...).
> >>
> >> IIRC at the time we decided that we could live without that complexity,
> >> but perhaps we cannot.
> >
> > Are you talking about this ?
> > https://elixir.free-electrons.com/linux/latest/source/Documentation/dev=
icetree/bindings/dma/dma.txt#L41
> >
> > It doesn't seem to be related to that issue to me. And in our
> > particular cases, all the devices are DMA masters, the RAM is just
> > mapped to another address.
>=20
> No, that's not the one I was thinking of. The idea at the time was much
> more generic, and not limited to dma engines. I don't recall the details,
> but I think that Thierry was either involved or made the proposal at the
> time.

Yeah, I vaguely remember discussing something like this before. A quick
search through my inbox yielded these two threads, mostly related to
IOMMU but I think there were some mentions about dma-ranges and so on as
well. I'll have to dig deeper into those threads to refresh my memories,
but I won't get around to it until later today.

If someone wants to read up on this in the meantime, here are the links:

	https://lkml.org/lkml/2014/4/27/346
	http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/257200.html

=46rom a quick glance the issue of dma-ranges was something that we hand-
waved at the time.

Thierry

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAlpwQfIACgkQ3SOs138+
s6Fh7g/8DFGL0MzPPU8t/wdZQbRgTyDjYLOX2sBH8WYUFlkqDLocFVs58lSMZpiU
xD6/muWOblNt9BJX7yd3zcPM4S/sNVTv7VsafkJZ1ssjPRLDwy/WTL2wAwIhOv5t
iQUUYFgG8q8YRCaG+xYiDW+1PCA21P8xl57OgfOc7MaqHKwy2Z7Dnq3rE8LUSiBP
IZDynIHOMSZRKskwbvdXgCRM56faA81pwYPX+B04kmcVap4ellQ+aYq/t6uDRlpA
wmKWxWnCQsrAgpBKBTqARXMFo0XXUo7lzcYsj5AKZFAZZ6uU/DvZm6SryEirr6vh
dW7NPB4KUYJ9OjmtI9S0UGCr80bQRSAetJK1aXbb6qEsS8eu31lB0747a5fG5GU9
6qoqgrg3aM1rPGIagmDHi0bRdxPUUA9syHBMpURfQO4rm0L9O8trafsDdjwVssyC
1NJPftbx0O2HFLzNcyrUw8X3OKlHpkUOizboXehzgqCWrpPS9VQvXwEGSQSGDGXC
X36KBDP1W+8pLvm1Hw+YeWBGouFaL1FVYkNFUJb1BaoDXRYa3tPY0WE7576kHSqd
3BdHBvMBGDDBN++TV1n3mTutufaAH4uqr9IXRupYSJnofBi+oxjfePbOZoXRti96
nM86zevzm19fe1ZZ1ZhFTWFNov4Om2nfaBw6FkNBoRjml62PPyc=
=UHHc
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
