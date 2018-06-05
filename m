Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:45937 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751502AbeFEIXY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Jun 2018 04:23:24 -0400
MIME-Version: 1.0
In-Reply-To: <20180605081222.GL10472@w540>
References: <1527606359-19261-1-git-send-email-jacopo+renesas@jmondi.org>
 <1527606359-19261-9-git-send-email-jacopo+renesas@jmondi.org>
 <20180604122325.GH19674@bigcity.dyn.berto.se> <20180605074938.mljwmgpjlplvkp2v@verge.net.au>
 <20180605081222.GL10472@w540>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 5 Jun 2018 10:23:22 +0200
Message-ID: <CAMuHMdXVF_OZCXJ449TJdm3f7ECMabgpRoWEBSmxJ=7f0zA_7Q@mail.gmail.com>
Subject: Re: [PATCH v3 8/8] ARM: dts: rcar-gen2: Remove unused VIN properties
To: jacopo mondi <jacopo@jmondi.org>
Cc: Simon Horman <horms@verge.net.au>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Rob Herring <robh+dt@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Tue, Jun 5, 2018 at 10:12 AM, jacopo mondi <jacopo@jmondi.org> wrote:
> On Tue, Jun 05, 2018 at 09:49:38AM +0200, Simon Horman wrote:
>> On Mon, Jun 04, 2018 at 02:23:25PM +0200, Niklas S=C3=B6derlund wrote:
>> > On 2018-05-29 17:05:59 +0200, Jacopo Mondi wrote:
>> > > The 'bus-width' and 'pclk-sample' properties are not parsed by the V=
IN
>> > > driver and only confuse users. Remove them in all Gen2 SoC that use
>> > > them.
>> > >
>> > > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
>> >
>> > The more I think about this the more I lean towards that this patch
>> > should be dropped. The properties accurately describes the hardware an=
d
>> > I think there is value in that. That the driver currently don't parse =
or
>> > make use of them don't in my view reduce there value. Maybe you should
>> > break out this patch to a separate series?
>>
>> I also think there is value in describing the hardware not the state of =
the
>> driver at this time.  Is there any missmatch between these properties an=
d
>> the bindings?
>
> Niklas and I discussed a bit offline on this yesterday. My main
> concern, and sorry for being pedant on this, is that changing those
> properties value does not change the interface behaviour, and this
> could cause troubles when integrating image sensor not known to be
> working on the VIN interface.
>
> This said, the documentation of those (and all other) properties is in th=
e
> generic "video-interfaces.txt" file and it is my understanding, but I thi=
nk
> Laurent and Rob agree on this as well from their replies to my previous s=
eries,
> that each driver should list which properties it actually supports, as

s/driver/device-specific binding/

> some aspects are very implementation specific, like default values and
> what happens if the property is not specified [1]. Nonetheless, all

In se defaults are not (Linux) implementation-specific, but fixed in the
DT bindings.

> properties describing hardware features and documented in the generic
> file should be accepted in DTS, as those aims to be OS-independent and
> even independent from the single driver implementation.

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
