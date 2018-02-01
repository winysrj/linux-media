Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:40517 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751399AbeBAIcY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Feb 2018 03:32:24 -0500
Date: Thu, 1 Feb 2018 09:32:22 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Liviu Dudau <liviu@dudau.co.uk>
Cc: Yong <yong.deng@magewell.com>, kbuild test robot <lkp@intel.com>,
        kbuild-all@01.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
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
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Rick Chang <rick.chang@mediatek.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, megous@megous.com
Subject: Re: [linux-sunxi] Re: [PATCH v6 2/2] media: V3s: Add support for
 Allwinner CSI.
Message-ID: <20180201083222.q6rqql4nngn2bhiy@flea.lan>
References: <1516695531-23349-1-git-send-email-yong.deng@magewell.com>
 <201801260759.RyNhDZz4%fengguang.wu@intel.com>
 <20180126094658.aa70ed3f890464f6051e21e4@magewell.com>
 <20180126110041.f89848325b9ecfb07df387ca@magewell.com>
 <20180131030807.GA19945@bart.dudau.co.uk>
 <20180131074212.7hvb3nqkt22h2chg@flea.lan>
 <20180131144753.GB19945@bart.dudau.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rrkgjn5tpiamdx5h"
Content-Disposition: inline
In-Reply-To: <20180131144753.GB19945@bart.dudau.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--rrkgjn5tpiamdx5h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 31, 2018 at 02:47:53PM +0000, Liviu Dudau wrote:
> On Wed, Jan 31, 2018 at 08:42:12AM +0100, Maxime Ripard wrote:
> > On Wed, Jan 31, 2018 at 03:08:08AM +0000, Liviu Dudau wrote:
> > > On Fri, Jan 26, 2018 at 11:00:41AM +0800, Yong wrote:
> > > > Hi Maxime,
> > > >=20
> > > > On Fri, 26 Jan 2018 09:46:58 +0800
> > > > Yong <yong.deng@magewell.com> wrote:
> > > >=20
> > > > > Hi Maxime,
> > > > >=20
> > > > > Do you have any experience in solving this problem?
> > > > > It seems the PHYS_OFFSET maybe undeclared when the ARCH is not ar=
m.
> > > >=20
> > > > Got it.
> > > > Should I add 'depends on ARM' in Kconfig?
> > >=20
> > > No, I don't think you should do that, you should fix the code.
> > >=20
> > > The dma_addr_t addr that you've got is ideally coming from dma_alloc_=
coherent(),
> > > in which case the addr is already "suitable" for use by the device (b=
ecause the
> > > bus where the device is attached to does all the address translations=
).
> >=20
> > Like we're discussing in that other part of the thread with Thierry
> > and Arnd, things are slightly more complicated than that :)
>=20
> Yeah, sorry, my threading of the discussion was broken and I've seen
> the rest of the thread after I have replied. My bad!
>=20
> >=20
> > In our case, the bus where the device is attached will not do the
> > address translations, and shouldn't.
>=20
> In my view, the bus is already doing address translation at physical
> level, AFAIU it remaps the memory to zero.

Not really. It uses a separate bus with a different mapping for the
DMA accesses (and only the DMA accesses). The AXI (or AHB, I'm not
sure, but, well, the "registers" bus) doesn't remap anything in
itself, and we only describe this one usually in our DTs.

> What you (we?) need is a simple bus driver that registers the
> correct virt_to_bus()/bus_to_virt() hooks for the device that do
> this translation at the DMA API level as well.

Like I said, this only impact DMA transfers, and not the registers
accesses. We have other devices sitting on the same bus that do not
perform DMA accesses through that special memory bus and will not have
that mapping changed.

> > > If you apply PHYS_OFFSET forcefully to it you might get unexpected
> > > results.
> >=20
> > Out of curiosity, what would be these unexpected results?
>=20
> If in the future (or a parallel world setup) the device is sitting
> behind an IOMMU, the addr value might well be smaller than
> PHYS_OFFSET and you will under-wrap, possibly starting to hit kernel
> physical addresses (or anything sitting at the top of the physical
> memory).
>=20
> From my time playing with IOMMUs and PCI domains, I've learned to
> treat the dma_addr_t as a cookie value and never try to do
> arithmetics with it.

I've never worked with PCI or IOMMU, so I tend to overlook them, but
yeah, you're right :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--rrkgjn5tpiamdx5h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlpy0JUACgkQ0rTAlCFN
r3RBqQ/+KKDc5keBlfkDD9E6x9aF2JcBTXtN+1LXzrxMR/Uta+YtmfqQUAGTtrCr
tuBq+uIFhibdir0XGe+e2p+uPfUZ/BJT1+PAN42Z6qZnxHAu1fHGSw1U3zInGsrM
74JGP5ZodoSEefxzOTlEJBFeBn68f2SX7jM0Oo2c2grUaRNsL0G+Y8ZmZwVe70+I
icX2cQTNdr/WtRnKW2AlXfwXpgggMADFGXc4Vxb4CFy1d/l5Qylijpwuo2SxmDaU
yiO+3RYdbtQXWazI6b+DFgCDhQbJXqJDR1S54hvO74Sh0tWFsD7MvYJWsWXm7+Np
YmCdeWPpbvqg3c6xMLanOiqcPs1UPOq3cpDJaCvF4JEwus5BUC0ThmRC4lBWaMQo
ZirgpNqSjsBX5eQ2daImuJoEcEdVT0zD18/wUM8UmxFSHO8KcmrS5QlFxSlxYQKI
76oUrGQqRQAdPSUWTRN0ELfC1M0SlZmnKldl/yvFrKswr+Q63aeCkFoU9282C1hc
Dsud8siGPhfyd1mczLouPhxfm71Sx2WCu53w4eRvkRKSJCaBrRsOiw6o5Tc6+WRM
VXma/iRIOhTyJi/qZNosDilMxQy1JnReOB7GfmzULYtXQ5/3I5S8tNVk/z5mV7hV
tqIysv4zEzqYkbDvZWcQh3SkrnrDVToXbHZPRcBcFnLjtVDb/xo=
=+CTZ
-----END PGP SIGNATURE-----

--rrkgjn5tpiamdx5h--
