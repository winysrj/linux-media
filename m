Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:33646 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751405AbeA3KBx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 05:01:53 -0500
Date: Tue, 30 Jan 2018 11:01:50 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Martin <dave.martin@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
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
Message-ID: <20180130100150.GB23047@ulmo>
References: <1516695531-23349-1-git-send-email-yong.deng@magewell.com>
 <CACRpkdan52UB7HOyH1gnHWg4CDke_VQxAdq8cBgwUroibE59Ow@mail.gmail.com>
 <20180129082533.6edmqgbauo6q5dgz@flea.lan>
 <CACRpkdYAGwUjr2C-w5U+WuG48pZAOUcnxFjznLbdF6Lmy1uZuQ@mail.gmail.com>
 <CAK8P3a2HmPOTHAzqBnmim388pcWOE=fG50mG5HJifT=vzKOaTg@mail.gmail.com>
 <20180130075441.rqxzkwero6sdfak6@flea.lan>
 <CAK8P3a0QxQE=GM=SGPtT82=UreiqsgY6uMThvQ_woA3rjK0zjA@mail.gmail.com>
 <20180130095916.GA23047@ulmo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GID0FwUMdk1T2AWN"
Content-Disposition: inline
In-Reply-To: <20180130095916.GA23047@ulmo>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--GID0FwUMdk1T2AWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 30, 2018 at 10:59:16AM +0100, Thierry Reding wrote:
> On Tue, Jan 30, 2018 at 10:24:48AM +0100, Arnd Bergmann wrote:
> > On Tue, Jan 30, 2018 at 8:54 AM, Maxime Ripard
> > <maxime.ripard@free-electrons.com> wrote:
> > > On Mon, Jan 29, 2018 at 03:34:02PM +0100, Arnd Bergmann wrote:
> > >> On Mon, Jan 29, 2018 at 10:25 AM, Linus Walleij
> > >> <linus.walleij@linaro.org> wrote:
> > >> > On Mon, Jan 29, 2018 at 9:25 AM, Maxime Ripard
> > >> > <maxime.ripard@free-electrons.com> wrote:
> > >> >> On Sat, Jan 27, 2018 at 05:14:26PM +0100, Linus Walleij wrote:
> >=20
> > >>
> > >> At one point we had discussed adding a 'dma-masters' property that
> > >> lists all the buses on which a device can be a dma master, and
> > >> the respective properties of those masters (iommu, coherency,
> > >> offset, ...).
> > >>
> > >> IIRC at the time we decided that we could live without that complexi=
ty,
> > >> but perhaps we cannot.
> > >
> > > Are you talking about this ?
> > > https://elixir.free-electrons.com/linux/latest/source/Documentation/d=
evicetree/bindings/dma/dma.txt#L41
> > >
> > > It doesn't seem to be related to that issue to me. And in our
> > > particular cases, all the devices are DMA masters, the RAM is just
> > > mapped to another address.
> >=20
> > No, that's not the one I was thinking of. The idea at the time was much
> > more generic, and not limited to dma engines. I don't recall the detail=
s,
> > but I think that Thierry was either involved or made the proposal at the
> > time.
>=20
> Yeah, I vaguely remember discussing something like this before. A quick
> search through my inbox yielded these two threads, mostly related to
> IOMMU but I think there were some mentions about dma-ranges and so on as
> well. I'll have to dig deeper into those threads to refresh my memories,
> but I won't get around to it until later today.
>=20
> If someone wants to read up on this in the meantime, here are the links:
>=20
> 	https://lkml.org/lkml/2014/4/27/346
> 	http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/257200.ht=
ml
>=20
> From a quick glance the issue of dma-ranges was something that we hand-
> waved at the time.
>=20
> Thierry

Also found this, which seems to be relevant as well:

	http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/252715.html

Adding Dave.

Thierry

--GID0FwUMdk1T2AWN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAlpwQo4ACgkQ3SOs138+
s6EL+A//bvLRGsfMxf8AcrC85N4hZkiTDErmoUFcbXCszZgOeYjudGP8rBVFSz4B
kYrz8Oywa7KXtsBNHhBhk8OPKiJ7toWFiEDAuVA/5oWELHTMyWQT7NDJzA4sff08
0mcH0dS6Cb651ON2Wbe+1H7Kn0Vf1eq7m7JViun7su+Lx9Z+VfPO/L/Q7uOHQjun
/0Hgw0s/s2Tt8HkjU4TfjolxQrPNHn7AZ4MavC4SjJ3GV6wCJNyreJHzysvrFr+Y
3rpbXsJhicXf380nJlUmtfkGOSi8OHAFArN5ein1ZLQp73iTtznH8/3uuC+cTQvR
3Y7EtvxAzYctIUkDx9ybo+APJZWlOnTAcQ6ojsCLIHUKg9CkzQY9XlqTYp+q7C2C
zXoDn97JL/9dkjwp+K+iRtU+iZ6O6u1NagEeHeWLv+vIUuqY2P6fpn+JK5xYTcxj
yrlavhNX0/cTPY9iccOqQwZR4/9joKaACLZW0JVXwydgVWDq2PhGdPl15N0okTxF
0pywj71XupJbMR3WkCL6vxyf7/SsZ/PnucNkRiwObzsxt5S9gJVvAnzjmjIHuUEq
ATnmw7Ox1Fm9Gwpwl+0Hy0Ez61Uiql+K8LhXEl5Kro61sIl1yPMXrbRGGKA6pHo9
MAh93ISupLgEhEK47cVJAjPRH7ou02885PA3a8tR3b8Kop43qsI=
=v45/
-----END PGP SIGNATURE-----

--GID0FwUMdk1T2AWN--
