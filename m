Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:51870 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751467AbeBAP3Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Feb 2018 10:29:25 -0500
Date: Thu, 1 Feb 2018 16:29:08 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Dave Martin <dave.martin@arm.com>,
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
Message-ID: <20180201152908.mdei742x5k4fye6p@flea.lan>
References: <CACRpkdan52UB7HOyH1gnHWg4CDke_VQxAdq8cBgwUroibE59Ow@mail.gmail.com>
 <20180129082533.6edmqgbauo6q5dgz@flea.lan>
 <CACRpkdYAGwUjr2C-w5U+WuG48pZAOUcnxFjznLbdF6Lmy1uZuQ@mail.gmail.com>
 <CAK8P3a2HmPOTHAzqBnmim388pcWOE=fG50mG5HJifT=vzKOaTg@mail.gmail.com>
 <20180130075441.rqxzkwero6sdfak6@flea.lan>
 <CAK8P3a0QxQE=GM=SGPtT82=UreiqsgY6uMThvQ_woA3rjK0zjA@mail.gmail.com>
 <20180130095916.GA23047@ulmo>
 <20180130100150.GB23047@ulmo>
 <20180131072910.ajp3jc5dmetsjtf2@flea.lan>
 <CAK8P3a0X2bpLjKE6xKehG1junZoG1N_DjepOBQ+SZetKf6sgfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="r7dbkulywz34njbb"
Content-Disposition: inline
In-Reply-To: <CAK8P3a0X2bpLjKE6xKehG1junZoG1N_DjepOBQ+SZetKf6sgfA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--r7dbkulywz34njbb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 31, 2018 at 10:37:37AM +0100, Arnd Bergmann wrote:
> On Wed, Jan 31, 2018 at 8:29 AM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > Hi Thierry,
> >
> > On Tue, Jan 30, 2018 at 11:01:50AM +0100, Thierry Reding wrote:
> >> On Tue, Jan 30, 2018 at 10:59:16AM +0100, Thierry Reding wrote:
> >> > On Tue, Jan 30, 2018 at 10:24:48AM +0100, Arnd Bergmann wrote:
> >> > > On Tue, Jan 30, 2018 at 8:54 AM, Maxime Ripard
> >> > > <maxime.ripard@free-electrons.com> wrote:
> >> > > > On Mon, Jan 29, 2018 at 03:34:02PM +0100, Arnd Bergmann wrote:
> >> > > >> On Mon, Jan 29, 2018 at 10:25 AM, Linus Walleij
> >> > > >> <linus.walleij@linaro.org> wrote:
> >> > > >> > On Mon, Jan 29, 2018 at 9:25 AM, Maxime Ripard
> >> > > >> > <maxime.ripard@free-electrons.com> wrote:
> >> > > >> >> On Sat, Jan 27, 2018 at 05:14:26PM +0100, Linus Walleij wrot=
e:
> >> > >
> >> > > >>
> >> > > >> At one point we had discussed adding a 'dma-masters' property t=
hat
> >> > > >> lists all the buses on which a device can be a dma master, and
> >> > > >> the respective properties of those masters (iommu, coherency,
> >> > > >> offset, ...).
> >> > > >>
> >> > > >> IIRC at the time we decided that we could live without that com=
plexity,
> >> > > >> but perhaps we cannot.
> >> > > >
> >> > > > Are you talking about this ?
> >> > > > https://elixir.free-electrons.com/linux/latest/source/Documentat=
ion/devicetree/bindings/dma/dma.txt#L41
> >> > > >
> >> > > > It doesn't seem to be related to that issue to me. And in our
> >> > > > particular cases, all the devices are DMA masters, the RAM is ju=
st
> >> > > > mapped to another address.
> >> > >
> >> > > No, that's not the one I was thinking of. The idea at the time was=
 much
> >> > > more generic, and not limited to dma engines. I don't recall the d=
etails,
> >> > > but I think that Thierry was either involved or made the proposal =
at the
> >> > > time.
> >> >
> >> > Yeah, I vaguely remember discussing something like this before. A qu=
ick
> >> > search through my inbox yielded these two threads, mostly related to
> >> > IOMMU but I think there were some mentions about dma-ranges and so o=
n as
> >> > well. I'll have to dig deeper into those threads to refresh my memor=
ies,
> >> > but I won't get around to it until later today.
> >> >
> >> > If someone wants to read up on this in the meantime, here are the li=
nks:
> >> >
> >> >     https://lkml.org/lkml/2014/4/27/346
> >> >     http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/2=
57200.html
> >> >
> >> > From a quick glance the issue of dma-ranges was something that we ha=
nd-
> >> > waved at the time.
> >>
> >> Also found this, which seems to be relevant as well:
> >>
> >>       http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/2=
52715.html
> >>
> >> Adding Dave.
> >
> > Thanks for the pointers, I started to read through it.
> >
> > I guess we have to come up with two solutions here: a short term one
> > to address the users we already have in the kernel properly, and a
> > long term one where we could use that discussion as a starting point.
> >
> > For the short term one, could we just set the device dma_pfn_offset to
> > PHYS_OFFSET at probe time, and use our dma_addr_t directly later on,
> > or would this also cause some issues?
>=20
> That would certainly be an improvement over the current version,
> it keeps the hack more localized. That's fine with me.

Ok, we'll do that in that driver and convert the existing drivers
then.

> Note that both PHYS_OFFSET and dma_pfn_offset have architecture
> specific meanings and they could in theory change, so ideally we'd
> do that fixup somewhere in arch/arm/mach-sunxi/ at boot time before
> the driver gets probed, but this wouldn't work on arm64 if we need
> it there too.

Unfortunately, we do :/

> > For the long term plan, from what I read from the discussion, it's
> > mostly centered around IOMMU indeed, and we don't have that. What we
> > would actually need is to break the assumption that the DMA "parent"
> > bus is the DT node's parent bus.
> >
> > And I guess this could be done quite easily by adding a dma-parent
> > property with a phandle to the bus controller, that would have a
> > dma-ranges property of its own with the proper mapping described
> > there. It should be simple enough to support, but is there anything
> > that could prevent something like that to work properly (such as
> > preventing further IOMMU-related developments that were described in
> > those mail threads).
>=20
> I've thought about it a little bit now. A dma-parent property would nicely
> solve two problems:
>=20
> - a device on a memory mapped control bus that is a bus master on
>   a different bus. This is the case we are talking about here AFAICT
>=20
> - a device that is on a different kind of bus (i2c, spi, usb, ...) but al=
so
>   happens to be a dma master on another bus. I suspect we have
>   some of these today and they work by accident because we set the
>   dma_mask and dma_map_ops quite liberally in the DT probe code,
>   but it really shouldn't work according to our bindings. We may also
>   have drivers that work around the issue by forcing the correct dma
>   mask and map_ops today, which makes them work but is rather
>   fragile.

Ok, I'll give it a shot then.

> I can think of a couple of other problems that may or may not be
> relevant in the future that would require a more complex solution:
>=20
> - a device that is a bus master on more than one bus, e.g. a
>   DMA engine that can copy between the CPU address space and
>   another memory controller that is not visible to the CPU
>=20
> - a device that is connected to main memory both through an IOMMU
>   and directly through its parent bus, and the device itself is in
>   control over which of the two it uses (usually the IOMMU would
>   contol whether a device is bypassing translation)
>=20
> - a device that has a single DMA address space with some form
>   of non-linear mapping to one or more parent buses. Some of these
>   can be expressed using the parent's dma-ranges properties, but
>   our code currently only looks at the first entry in dma-ranges.

As far as I know, we're in neither of these cases.

> Another problem is the interaction with the dma-ranges and iommu
> properties. I have not found any real problems here, but we certainly
> need to be careful to define what happens in all combinations and
> make sure that we document it well in the bindings and have those
> reviewed by the affected parties, at least the ARM and PowerPC
> architecture folks as well as the Nvidia and Renesas platform
> maintainers, which in my experience have the most complex DMA
> hardware.

I guess we can discuss it during the review cycles.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--r7dbkulywz34njbb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlpzMkQACgkQ0rTAlCFN
r3R/ohAAmOZd36AL4mDihcwm94fjEonIw/ACHtPDx884QEpz6C2XPk/PckcNU/FE
4TTECil0j6tfzaHzcWsVckYwJyiGFc3m88KO6NdRlVKFkJ28xdRioHymt7u/TDh1
ZHJ1diFX9crgtI5ubx8QZM7cZq1hbzEZqSJQJRB1V8Q78x7Ze/mgVPK4lqQx4rCY
HP85x7fYuIFQkTIEMl3OtKLrd+YabpoRnOG1HbOJeBObCiSLTK25gbpRSiqLumkQ
Pegqc4Heud0FF+SpWY3/0QsdlciX6UNEbbAN41QpJ8SrTgEk+rpGdav4rp4YQukB
Z9W7PSIY+7+XFInCxOkrH2qcuRb0COCAM6GNtUDMGL9T3HNBjovvdVSudGkgZvxg
OEnZLWvABQnUc2+Cr3X7z4vlhFvneEhtbY7a3uWCDp0pwp0EwctKaPD+L1i0+Jsy
AKnhLktVHxsp9Ewp7CHG0Kz3dJHpPE1HMTCPLcOyjN41r5qeaoOMWvDZPVWmuIlF
vuFAvUpqRyrWqnJ+PQoSEG1aTKHOcAyYFdRTgSjLHP73L3ndxN8nh41ymrDhBY3x
kaEaJPRJ06vXQLZkGWUYftUKe6Gx0bxuD1o2LWD5kGddsm5IYa0A38U7M0nrVYpU
gGhf8zYk0iv1qBpXQUXR0PUZ6g6Ps229O+JF/S+ETYZAuYlGbRY=
=OEwJ
-----END PGP SIGNATURE-----

--r7dbkulywz34njbb--
