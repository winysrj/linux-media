Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:55889 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751127AbeA2IZf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 03:25:35 -0500
Date: Mon, 29 Jan 2018 09:25:33 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Yong Deng <yong.deng@magewell.com>,
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
        linux-media@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>, megous@megous.com,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH v6 2/2] media: V3s: Add support for Allwinner CSI.
Message-ID: <20180129082533.6edmqgbauo6q5dgz@flea.lan>
References: <1516695531-23349-1-git-send-email-yong.deng@magewell.com>
 <CACRpkdan52UB7HOyH1gnHWg4CDke_VQxAdq8cBgwUroibE59Ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fd5monsbubmdi5cf"
Content-Disposition: inline
In-Reply-To: <CACRpkdan52UB7HOyH1gnHWg4CDke_VQxAdq8cBgwUroibE59Ow@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--fd5monsbubmdi5cf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Sat, Jan 27, 2018 at 05:14:26PM +0100, Linus Walleij wrote:
> > +void sun6i_csi_update_buf_addr(struct sun6i_csi *csi, dma_addr_t addr)
> > +{
> > +       struct sun6i_csi_dev *sdev =3D sun6i_csi_to_dev(csi);
> > +       /* transform physical address to bus address */
> > +       dma_addr_t bus_addr =3D addr - PHYS_OFFSET;
>=20
> I am sorry if this is an unjustified drive-by comment. Maybe you
> have already investigate other ways to do this.

It's definitely not unjustified :)

> Accessing PHYS_OFFSET directly seems unintuitive and not good
> practice.
>=20
> But normally an dma_addr_t only comes from some function inside
> <linux/dma-mapping.h> such as: dma_alloc_coherent() for a contigous
> buffer which is coherent in physical memory, or from some buffer <=3D
> 64KB that is switching ownership between device and CPU explicitly
> with dma_map* or so. Did you check with Documentation/DMA-API.txt?

So, I've discussed this with Arnd a month ago or so, because I'm not
really fond of the current approach but we haven't found better way to
do it yet.

The issue is that all the DMA accesses are done not through the main
AXI bus, but through a separate bus dedicated for memory accesses,
where the RAM is mapped at the address 0. So the CPU and DMA devices
have a different mapping for the RAM.

I guess we could address this by using the field dma_pfn_offset that
seems to be used in similar situations. However, in DT systems, that
field is filled only with the parent's node dma-ranges property. In
our case, and since the DT parenthood is based on the "control" bus,
and not the "data" bus, our parent node would be the AXI bus, and not
the memory bus that enforce those constraints.

And other devices doing DMA through regular DMA accesses won't have
that mapping, so we definitely shouldn't enforce it for all the
devices there, but only the one connected to the separate memory bus.

tl; dr: the DT is not really an option to store that info.

I suggested setting dma_pfn_offset at probe, but Arnd didn't seem too
fond of that approach either at the time.

So, well, I guess we could do better. We just have no idea how :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--fd5monsbubmdi5cf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlpu2nwACgkQ0rTAlCFN
r3SiZg//WZ1rRM2MJvlF8VFkItkJUIW+JrU3CDSFqQURVnmScYKATMSv10r+sJWK
JU0vGokoByqEBjO4wOSCPhFrZ2LffXbdjn9N1OVJTzCBgxEY9SGO6i4wpQiJqGtH
76R6wGZWaNCGBmo5Sgjiti2Qsx9au/j2lxdB1hvsWVjS/sOwtmDfer5cJyQlUewq
zY1C3FH4ob55Of4QEzrkfrlf82JaxGuYI6xvrKjbq7i59xfqacwh7V4d+il2GGos
lopCpQws6q7sT+Ho44wCronvLxHThgExWcxBDZtxivBAJKcWgwbzf6uxYnGi7VE4
9WWMmadLNvylsJiMfLFwlHnUZq143c2oPvf5X0WiQsFIh9Yc8lj83PZ0QllHPiOs
16Wb7lQ+Y8zijqz1A1FztWyRgvqgGO58dZlbzNvyQAg8JNPiwYF2OorU1lbZp5DM
jn1dEUFM90x+ofMiGLbM3V7bxif4dX0MZMWbO0mda//wKEVhqRblwL9F7M5Y6nYA
oUA8lF1aPz0urdIw6g/E6ptIUc/mt847LeyOQgeY9gQi7ujsdhTsZ9Xj0oYwRDhJ
AYXQtvf6UZ/mN0Xol9TQtGgUmGN4aUiYMmADiw67lWuVkb7X08+1auGf7wrDuj4y
ukylv/wMrJisyEdub2fdCge4THAoHBRiUg82pax6yPUaTfQNr/Y=
=1pUN
-----END PGP SIGNATURE-----

--fd5monsbubmdi5cf--
