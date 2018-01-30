Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:60214 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751576AbeA3Hyx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 02:54:53 -0500
Date: Tue, 30 Jan 2018 08:54:41 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
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
Message-ID: <20180130075441.rqxzkwero6sdfak6@flea.lan>
References: <1516695531-23349-1-git-send-email-yong.deng@magewell.com>
 <CACRpkdan52UB7HOyH1gnHWg4CDke_VQxAdq8cBgwUroibE59Ow@mail.gmail.com>
 <20180129082533.6edmqgbauo6q5dgz@flea.lan>
 <CACRpkdYAGwUjr2C-w5U+WuG48pZAOUcnxFjznLbdF6Lmy1uZuQ@mail.gmail.com>
 <CAK8P3a2HmPOTHAzqBnmim388pcWOE=fG50mG5HJifT=vzKOaTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="efe3fivtyyp4bqw2"
Content-Disposition: inline
In-Reply-To: <CAK8P3a2HmPOTHAzqBnmim388pcWOE=fG50mG5HJifT=vzKOaTg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--efe3fivtyyp4bqw2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jan 29, 2018 at 03:34:02PM +0100, Arnd Bergmann wrote:
> On Mon, Jan 29, 2018 at 10:25 AM, Linus Walleij
> <linus.walleij@linaro.org> wrote:
> > On Mon, Jan 29, 2018 at 9:25 AM, Maxime Ripard
> > <maxime.ripard@free-electrons.com> wrote:
> >> On Sat, Jan 27, 2018 at 05:14:26PM +0100, Linus Walleij wrote:
> >> However, in DT systems, that
> >> field is filled only with the parent's node dma-ranges property. In
> >> our case, and since the DT parenthood is based on the "control" bus,
> >> and not the "data" bus, our parent node would be the AXI bus, and not
> >> the memory bus that enforce those constraints.
> >>
> >> And other devices doing DMA through regular DMA accesses won't have
> >> that mapping, so we definitely shouldn't enforce it for all the
> >> devices there, but only the one connected to the separate memory bus.
> >>
> >> tl; dr: the DT is not really an option to store that info.
> >>
> >> I suggested setting dma_pfn_offset at probe, but Arnd didn't seem too
> >> fond of that approach either at the time.
> >>
> >> So, well, I guess we could do better. We just have no idea how :)
> >
> > Usually of Arnd cannot suggest something smart, neither can I :(
> >
> > If some aspect of the memory layout of the system *really* doesn't
> > fit into DT because of the assumptions that DT is doing about
> > how systems work, we have a problem.
> >
> > Is the problem that DT's model assumes that devices have one and
> > only one data port to the system memory, and that is how it
> > populates the Linux devices?
> >
> > I guess, if nothing else works, I would use auxdata in the board file.
> > It is our definitive last resort when DT doesn't hold.
> >
> > I.e. I would go into struct of_dev_auxdata
> > (from <linux/of_platform.h>) and add a
> > dma_pfn_offset field that gets set into the device's dma_pfn_offset
> > in drivers/of/platform.c overriding anything else and use that to hammer
> > it down in the boardfile.
> >
> > But I bet some DT people are going to have other ideas.
>=20
> At one point we had discussed adding a 'dma-masters' property that
> lists all the buses on which a device can be a dma master, and
> the respective properties of those masters (iommu, coherency,
> offset, ...).
>
> IIRC at the time we decided that we could live without that complexity,
> but perhaps we cannot.

Are you talking about this ?
https://elixir.free-electrons.com/linux/latest/source/Documentation/devicet=
ree/bindings/dma/dma.txt#L41

It doesn't seem to be related to that issue to me. And in our
particular cases, all the devices are DMA masters, the RAM is just
mapped to another address.

> Another local hack that we can do here is to have two separate
> device nodes and let the device driver bind to one device and then
> look up the other one through a phandle to look up a platform_device
> for it, which it can then use with the DMA mapping interface.

We have multiple devices doing that, a couple of them already merged
(mostly on the display side). I'd rather not do that.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--efe3fivtyyp4bqw2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlpwJMAACgkQ0rTAlCFN
r3TQZg//Xz2uAhCJJkmDsZ3teD3rSn6GiiwjVnZoKdNcILTtEqGHCkwPM0D1PyOp
eoKHDjBH/o2BoGp9aXtyAiWiXVgHsFCjvUxX24bTDizd+BKBcqKx+1VVqPn1lfcB
1+Fq0R5GMFFH+m+ubVRmKS182bdz9LZcKoqM1kINQiBumEfLOwSD96WqCBc0lVvb
LunE+TUKWFBjZVeW+JsmCrjpT00SXccnlKG9yKh11ZJkmnOY2hVnh6usd1hvttQq
JUN2H8CdP/q1c0CLLx9o+3dgTuKpYS/P8Elza0ujnxBO7395YQSs5k8Nn2Ct4VsL
qs5Hd27qC1d4HYwKiROyX+oa9Vh4X0nUi7t7ebdIVMqOJ/yUaJ3bY24/8DBb/RM9
tRgumkd8iQZ0hX+QSfLqtmwiBuYeVSQ4Fq0CnyTIT1BciZ18MIjgVMqbypSOyX9i
4I/DRAYXOR4kdUYEiDeQib+XNsahBmeQI2IZbJI3f0qLbjn5sZRCYaaHPqG3Hk2u
wlOcRNjFrxe4pDLw79ST9DFGOh0D0tbCax16riHNgxTyksVhETBQQweIwn5hi0a0
alEKVBnIi4X8vIceeBYQhjYYEn7j6pHgYc96VCiC/n0NYbazXe6j3qrvLfBhwHMa
fG2osde5Sub0hrWGfqpB/lA431ZQAHKf1xiCvJ9QQXViLjqBmSA=
=Iq2u
-----END PGP SIGNATURE-----

--efe3fivtyyp4bqw2--
