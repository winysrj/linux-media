Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:45676 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751521AbeAaJhj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Jan 2018 04:37:39 -0500
MIME-Version: 1.0
In-Reply-To: <20180131072910.ajp3jc5dmetsjtf2@flea.lan>
References: <1516695531-23349-1-git-send-email-yong.deng@magewell.com>
 <CACRpkdan52UB7HOyH1gnHWg4CDke_VQxAdq8cBgwUroibE59Ow@mail.gmail.com>
 <20180129082533.6edmqgbauo6q5dgz@flea.lan> <CACRpkdYAGwUjr2C-w5U+WuG48pZAOUcnxFjznLbdF6Lmy1uZuQ@mail.gmail.com>
 <CAK8P3a2HmPOTHAzqBnmim388pcWOE=fG50mG5HJifT=vzKOaTg@mail.gmail.com>
 <20180130075441.rqxzkwero6sdfak6@flea.lan> <CAK8P3a0QxQE=GM=SGPtT82=UreiqsgY6uMThvQ_woA3rjK0zjA@mail.gmail.com>
 <20180130095916.GA23047@ulmo> <20180130100150.GB23047@ulmo> <20180131072910.ajp3jc5dmetsjtf2@flea.lan>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 31 Jan 2018 10:37:37 +0100
Message-ID: <CAK8P3a0X2bpLjKE6xKehG1junZoG1N_DjepOBQ+SZetKf6sgfA@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] media: V3s: Add support for Allwinner CSI.
To: Maxime Ripard <maxime.ripard@free-electrons.com>
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 31, 2018 at 8:29 AM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> Hi Thierry,
>
> On Tue, Jan 30, 2018 at 11:01:50AM +0100, Thierry Reding wrote:
>> On Tue, Jan 30, 2018 at 10:59:16AM +0100, Thierry Reding wrote:
>> > On Tue, Jan 30, 2018 at 10:24:48AM +0100, Arnd Bergmann wrote:
>> > > On Tue, Jan 30, 2018 at 8:54 AM, Maxime Ripard
>> > > <maxime.ripard@free-electrons.com> wrote:
>> > > > On Mon, Jan 29, 2018 at 03:34:02PM +0100, Arnd Bergmann wrote:
>> > > >> On Mon, Jan 29, 2018 at 10:25 AM, Linus Walleij
>> > > >> <linus.walleij@linaro.org> wrote:
>> > > >> > On Mon, Jan 29, 2018 at 9:25 AM, Maxime Ripard
>> > > >> > <maxime.ripard@free-electrons.com> wrote:
>> > > >> >> On Sat, Jan 27, 2018 at 05:14:26PM +0100, Linus Walleij wrote:
>> > >
>> > > >>
>> > > >> At one point we had discussed adding a 'dma-masters' property that
>> > > >> lists all the buses on which a device can be a dma master, and
>> > > >> the respective properties of those masters (iommu, coherency,
>> > > >> offset, ...).
>> > > >>
>> > > >> IIRC at the time we decided that we could live without that complexity,
>> > > >> but perhaps we cannot.
>> > > >
>> > > > Are you talking about this ?
>> > > > https://elixir.free-electrons.com/linux/latest/source/Documentation/devicetree/bindings/dma/dma.txt#L41
>> > > >
>> > > > It doesn't seem to be related to that issue to me. And in our
>> > > > particular cases, all the devices are DMA masters, the RAM is just
>> > > > mapped to another address.
>> > >
>> > > No, that's not the one I was thinking of. The idea at the time was much
>> > > more generic, and not limited to dma engines. I don't recall the details,
>> > > but I think that Thierry was either involved or made the proposal at the
>> > > time.
>> >
>> > Yeah, I vaguely remember discussing something like this before. A quick
>> > search through my inbox yielded these two threads, mostly related to
>> > IOMMU but I think there were some mentions about dma-ranges and so on as
>> > well. I'll have to dig deeper into those threads to refresh my memories,
>> > but I won't get around to it until later today.
>> >
>> > If someone wants to read up on this in the meantime, here are the links:
>> >
>> >     https://lkml.org/lkml/2014/4/27/346
>> >     http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/257200.html
>> >
>> > From a quick glance the issue of dma-ranges was something that we hand-
>> > waved at the time.
>>
>> Also found this, which seems to be relevant as well:
>>
>>       http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/252715.html
>>
>> Adding Dave.
>
> Thanks for the pointers, I started to read through it.
>
> I guess we have to come up with two solutions here: a short term one
> to address the users we already have in the kernel properly, and a
> long term one where we could use that discussion as a starting point.
>
> For the short term one, could we just set the device dma_pfn_offset to
> PHYS_OFFSET at probe time, and use our dma_addr_t directly later on,
> or would this also cause some issues?

That would certainly be an improvement over the current version,
it keeps the hack more localized. That's fine with me. Note that both
PHYS_OFFSET and dma_pfn_offset have architecture specific
meanings and they could in theory change, so ideally we'd do that
fixup somewhere in arch/arm/mach-sunxi/ at boot time before the
driver gets probed, but this wouldn't work on arm64 if we need it
there too.

> For the long term plan, from what I read from the discussion, it's
> mostly centered around IOMMU indeed, and we don't have that. What we
> would actually need is to break the assumption that the DMA "parent"
> bus is the DT node's parent bus.
>
> And I guess this could be done quite easily by adding a dma-parent
> property with a phandle to the bus controller, that would have a
> dma-ranges property of its own with the proper mapping described
> there. It should be simple enough to support, but is there anything
> that could prevent something like that to work properly (such as
> preventing further IOMMU-related developments that were described in
> those mail threads).

I've thought about it a little bit now. A dma-parent property would nicely
solve two problems:

- a device on a memory mapped control bus that is a bus master on
  a different bus. This is the case we are talking about here AFAICT

- a device that is on a different kind of bus (i2c, spi, usb, ...) but also
  happens to be a dma master on another bus. I suspect we have
  some of these today and they work by accident because we set the
  dma_mask and dma_map_ops quite liberally in the DT probe code,
  but it really shouldn't work according to our bindings. We may also
  have drivers that work around the issue by forcing the correct dma
  mask and map_ops today, which makes them work but is rather
  fragile.

I can think of a couple of other problems that may or may not be
relevant in the future that would require a more complex solution:

- a device that is a bus master on more than one bus, e.g. a
  DMA engine that can copy between the CPU address space and
  another memory controller that is not visible to the CPU

- a device that is connected to main memory both through an IOMMU
  and directly through its parent bus, and the device itself is in
  control over which of the two it uses (usually the IOMMU would
  contol whether a device is bypassing translation)

- a device that has a single DMA address space with some form
  of non-linear mapping to one or more parent buses. Some of these
  can be expressed using the parent's dma-ranges properties, but
  our code currently only looks at the first entry in dma-ranges.

Another problem is the interaction with the dma-ranges and iommu
properties. I have not found any real problems here, but we certainly
need to be careful to define what happens in all combinations and
make sure that we document it well in the bindings and have those
reviewed by the affected parties, at least the ARM and PowerPC
architecture folks as well as the Nvidia and Renesas platform
maintainers, which in my experience have the most complex DMA
hardware.

       Arnd
