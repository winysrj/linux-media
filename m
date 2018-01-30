Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34060 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751671AbeA3JYu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 04:24:50 -0500
MIME-Version: 1.0
In-Reply-To: <20180130075441.rqxzkwero6sdfak6@flea.lan>
References: <1516695531-23349-1-git-send-email-yong.deng@magewell.com>
 <CACRpkdan52UB7HOyH1gnHWg4CDke_VQxAdq8cBgwUroibE59Ow@mail.gmail.com>
 <20180129082533.6edmqgbauo6q5dgz@flea.lan> <CACRpkdYAGwUjr2C-w5U+WuG48pZAOUcnxFjznLbdF6Lmy1uZuQ@mail.gmail.com>
 <CAK8P3a2HmPOTHAzqBnmim388pcWOE=fG50mG5HJifT=vzKOaTg@mail.gmail.com> <20180130075441.rqxzkwero6sdfak6@flea.lan>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 30 Jan 2018 10:24:48 +0100
Message-ID: <CAK8P3a0QxQE=GM=SGPtT82=UreiqsgY6uMThvQ_woA3rjK0zjA@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] media: V3s: Add support for Allwinner CSI.
To: Maxime Ripard <maxime.ripard@free-electrons.com>
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
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Thierry Reding <thierry.reding@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 30, 2018 at 8:54 AM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> On Mon, Jan 29, 2018 at 03:34:02PM +0100, Arnd Bergmann wrote:
>> On Mon, Jan 29, 2018 at 10:25 AM, Linus Walleij
>> <linus.walleij@linaro.org> wrote:
>> > On Mon, Jan 29, 2018 at 9:25 AM, Maxime Ripard
>> > <maxime.ripard@free-electrons.com> wrote:
>> >> On Sat, Jan 27, 2018 at 05:14:26PM +0100, Linus Walleij wrote:

>>
>> At one point we had discussed adding a 'dma-masters' property that
>> lists all the buses on which a device can be a dma master, and
>> the respective properties of those masters (iommu, coherency,
>> offset, ...).
>>
>> IIRC at the time we decided that we could live without that complexity,
>> but perhaps we cannot.
>
> Are you talking about this ?
> https://elixir.free-electrons.com/linux/latest/source/Documentation/devicetree/bindings/dma/dma.txt#L41
>
> It doesn't seem to be related to that issue to me. And in our
> particular cases, all the devices are DMA masters, the RAM is just
> mapped to another address.

No, that's not the one I was thinking of. The idea at the time was much
more generic, and not limited to dma engines. I don't recall the details,
but I think that Thierry was either involved or made the proposal at the
time.

       Arnd
