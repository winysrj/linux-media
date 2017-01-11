Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:32842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750958AbdAKV1j (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jan 2017 16:27:39 -0500
MIME-Version: 1.0
In-Reply-To: <1484015754.4057.4.camel@mtkswgap22>
References: <1483632384-8107-1-git-send-email-sean.wang@mediatek.com>
 <1483632384-8107-2-git-send-email-sean.wang@mediatek.com> <20170109183214.xonv52sn3fo4exqp@rob-hp-laptop>
 <1484015754.4057.4.camel@mtkswgap22>
From: Rob Herring <robh@kernel.org>
Date: Wed, 11 Jan 2017 15:27:14 -0600
Message-ID: <CAL_JsqLruJnURULQx1PvemY0dHR62kV6rL-YyAp32vf26FTotw@mail.gmail.com>
Subject: Re: [PATCH 1/2] Documentation: devicetree: Add document bindings for mtk-cir
To: Sean Wang <sean.wang@mediatek.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Sean Young <sean@mess.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-mediatek@lists.infradead.org,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        sean wang <keyhaede@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 9, 2017 at 8:35 PM, Sean Wang <sean.wang@mediatek.com> wrote:
> Hi Rob,
>
> thanks for your effort for reviewing. I added comments inline.
>
> On Mon, 2017-01-09 at 12:32 -0600, Rob Herring wrote:
>> On Fri, Jan 06, 2017 at 12:06:23AM +0800, sean.wang@mediatek.com wrote:
>> > From: Sean Wang <sean.wang@mediatek.com>
>> >
>> > This patch adds documentation for devicetree bindings for
>> > Mediatek IR controller.
>> >
>> > Signed-off-by: Sean Wang <sean.wang@mediatek.com>
>> > ---
>> >  .../devicetree/bindings/media/mtk-cir.txt          | 23 ++++++++++++++++++++++
>> >  1 file changed, 23 insertions(+)
>> >  create mode 100644 linux-4.8.rc1_p0/Documentation/devicetree/bindings/media/mtk-cir.txt
>> >
>> > diff --git a/Documentation/devicetree/bindings/media/mtk-cir.txt b/Documentation/devicetree/bindings/media/mtk-cir.txt
>> > new file mode 100644
>> > index 0000000..bbedd71
>> > --- /dev/null
>> > +++ b/Documentation/devicetree/bindings/media/mtk-cir.txt
>> > @@ -0,0 +1,23 @@
>> > +Device-Tree bindings for Mediatek IR controller found in Mediatek SoC family
>> > +
>> > +Required properties:
>> > +- compatible           : "mediatek,mt7623-ir"
>> > +- clocks       : list of clock specifiers, corresponding to
>> > +                 entries in clock-names property;
>> > +- clock-names          : should contain "clk" entries;
>> > +- interrupts           : should contain IR IRQ number;
>> > +- reg                  : should contain IO map address for IR.
>> > +
>> > +Optional properties:
>> > +- linux,rc-map-name : Remote control map name.
>>
>> Would 'label' be appropriate here instead? If not, this needs to be
>> documented in a common location and explained better.
>>
> I checked with how the way applied in other IR drivers is and found that
> most IR driver also use the same label to identify the scan/key table
> they prefer to use such as gpio-ir-recv, ir-hix5hd2, meson-ir and
> sunxi-cir or use hard coding inside the driver. So I thought it should
> be appropriate here currently.

Maybe so, but anything with linux prefix gets extra scrutiny and I'm
not sure that happened on the previous cases. If label has the same
meaning, then we should start using that and deprecate this property.
In any case, a property used by multiple bindings needs to be
documented in a common place. The explanation of the property is bad
too. It just spells out RC with no explanation. I'm sure you just
copy-n-pasted it from the others, but that doesn't make it okay.

Rob
