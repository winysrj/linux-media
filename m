Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:52433 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751472AbeBAPyt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Feb 2018 10:54:49 -0500
Date: Thu, 1 Feb 2018 16:54:32 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Liviu Dudau <liviu@dudau.co.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Yong <yong.deng@magewell.com>,
        kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Linus Walleij <linus.walleij@linaro.org>,
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
        DTML <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>, megous@megous.com
Subject: Re: [linux-sunxi] Re: [PATCH v6 2/2] media: V3s: Add support for
 Allwinner CSI.
Message-ID: <20180201155432.odv6p6rals3sujhx@flea.lan>
References: <1516695531-23349-1-git-send-email-yong.deng@magewell.com>
 <201801260759.RyNhDZz4%fengguang.wu@intel.com>
 <20180126094658.aa70ed3f890464f6051e21e4@magewell.com>
 <20180126110041.f89848325b9ecfb07df387ca@magewell.com>
 <20180131030807.GA19945@bart.dudau.co.uk>
 <20180131074212.7hvb3nqkt22h2chg@flea.lan>
 <20180131144753.GB19945@bart.dudau.co.uk>
 <20180201083222.q6rqql4nngn2bhiy@flea.lan>
 <CAK8P3a01DqmVJKt6J2i_okVoeELJCUW0voW0r52EzBY7iF74xQ@mail.gmail.com>
 <20180201113442.GC19945@bart.dudau.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="52oyo5npgo7v2l5n"
Content-Disposition: inline
In-Reply-To: <20180201113442.GC19945@bart.dudau.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--52oyo5npgo7v2l5n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 01, 2018 at 11:34:43AM +0000, Liviu Dudau wrote:
> On Thu, Feb 01, 2018 at 10:20:28AM +0100, Arnd Bergmann wrote:
> > On Thu, Feb 1, 2018 at 9:32 AM, Maxime Ripard
> > <maxime.ripard@free-electrons.com> wrote:
> > > On Wed, Jan 31, 2018 at 02:47:53PM +0000, Liviu Dudau wrote:
> > >> On Wed, Jan 31, 2018 at 08:42:12AM +0100, Maxime Ripard wrote:
> > >> > On Wed, Jan 31, 2018 at 03:08:08AM +0000, Liviu Dudau wrote:
> > >> > > On Fri, Jan 26, 2018 at 11:00:41AM +0800, Yong wrote:
> > >>
> > >> Yeah, sorry, my threading of the discussion was broken and I've seen
> > >> the rest of the thread after I have replied. My bad!
> > >>
> > >> >
> > >> > In our case, the bus where the device is attached will not do the
> > >> > address translations, and shouldn't.
> > >>
> > >> In my view, the bus is already doing address translation at physical
> > >> level, AFAIU it remaps the memory to zero.
> > >
> > > Not really. It uses a separate bus with a different mapping for the
> > > DMA accesses (and only the DMA accesses). The AXI (or AHB, I'm not
> > > sure, but, well, the "registers" bus) doesn't remap anything in
> > > itself, and we only describe this one usually in our DTs.
>=20
> I was actually thinking about the DMA bus (AXI bus, most likely), not the
> "registers" bus (yes, usually APB or AHB). The DMA bus is the one that do=
es
> the implicit remapping for the addresses it uses, if I understood you cor=
rectly.
>=20
> > Exactly, the DT model fundamentally assumes that each a device is
> > connected to exactly one bus, so we make up a device *tree* rather
> > than a non-directed mesh topology that you might see in modern
> > SoCs.
>=20
> I think you are right, but we also have the registers property for a devi=
ce node
> and that can be used for describing the "registers" bus. Now, it is possi=
ble
> that some driver code gets confused between accessing the device registers
> (which in Arm world happens through an APB or AHB bus) and the device doi=
ng system
> read/writes which usually happends through an AXI (or for very old system=
s, AHB) bus.
>=20
> For the sake of making sure we are talking about the same thing and in ho=
pe
> that Maxime or Yong can give a more detailed picture of this device

Keep in mind that this part is heavily under-documented to us, and
this is mostly information collected through testing and reading
through the various vendor trees.

As far as I know, a few devices (Display Engine, hardware codec, the
CSI driver that spawned this discussion) are connected to the memory
through a proprietary bus that does the remapping. The registers part
is connected to an AHB bus.

> I'll re-iterate what a lot of devices in the Arm world look like
> nowadays:
>=20
> - they have a bus for accessing the "registers" of the device, for contro=
lling
>   the behaviour of that device. Inside the SoC, that happens through the
>   APB bus and it has a separate clock. The CPU has a view of those regist=
ers
>   through some mapping in the address space that has been backed by the h=
ardware
>   engineers at design time and in DT we express that through the "registe=
rs" property,
>   plus the "apb_clk" for most of the bindings. In DT world we express the=
 mapping
>   vis-a-vis the parent bus by using the "ranges" property.

We do have that.

> - they have a high speed bus for doing data transfers. Inside the SoC that
>   happens through an AXI or more modern CCI interconnect bus. The CPU doe=
s not
>   have a direct view on those transfers, but by using IOMMUs, SMMUs or si=
mple
>   bus mastering capabilities it can gain knowledge of the state of the tr=
ansfers
>   and/or influence the target memory.

Part of that bus controller allows to probe the bus bandwidth and / or
set limits for the various controllers connected to it, so it seems to
match that description.

>   In the DT world, we use the "dma-ranges" property like you say to
>   express the translations that happen on that bus.

Right, except that the way dma-ranges is parsed at the moment is that
it will look on the parent node for dma-ranges. In this case, the
parent in the DT will be our AHB bus, and not all the devices
connected on that AHB bus that do DMA go through that DMA bus with the
different mapping. So setting it there isn't an option.

> Maxime/Yong: does your device have more than one AXI bus for doing
> transfers?

Not as far as I know.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--52oyo5npgo7v2l5n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlpzODcACgkQ0rTAlCFN
r3Ry4A//ftqxc40x32HJ8OqXs6ZO8AGW8747Y1D9u6gLO4wrL8I5F4ttRWT5gqug
Dn+o8lidRtNhsiHgqUc7mqqBZMwqUF1R7A7Tly1kaSMO0B7x6QHbH7Uj2EH8H0Gs
pSI6VFG+lhdKk4WJ5+3tGvuDfLWKlXC1CvoOSSRU5WK/FyfL3jnjDbj29Y0fr3EC
jpP5O+2TUwM9yNGSX//rLSbwgwldSbzRdCgo6zLHlrwgJ+2Xj/Wsml2fwS42j8p5
sqGhwCj/Hy7tKVtUbi8wtT3019y+Y6XpYEjktHwPBeliDWSZKrE0Y8iubpSfvA//
LXR1mFCGBQlDyXNtnxWqETMEmypHuV6U0ZyfldP/rVNybskCEqL3gnNvGKAwyuD+
48rJGD3hy5+R3HTYEFmZHihSPaNez0zIlgDoHqwcdOGAetBgmhq+Dcu+tB9nzK/B
Kvk3tVWtKHJpZu3WLISpkKzFjh85ZSf3JVXI+YnisT/sv6hgznq8lUyuPjlYvJzm
yR9aPY2LygdMrIgIraZ9f5spfeR7ot+eJXD0Vr7b0WeqC+QGp7UEV2uYt+g8lXeL
4IoF1HbngY054Y9cBLXxJNSrjv2syTdpJNU6LSKHb4gb/yb2KsbD1uHo85efJG4L
EJmTwMmFFR2g1Qr+2DQ68G0Uuj9LiVznzhfWfBIbZtrXRkliKG4=
=YY2K
-----END PGP SIGNATURE-----

--52oyo5npgo7v2l5n--
