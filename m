Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751749AbcKOUKz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Nov 2016 15:10:55 -0500
MIME-Version: 1.0
In-Reply-To: <4350940.43ZWQivOUU@avalon>
References: <1475598210-26857-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1488637.i0jADhlNmg@avalon> <CAL_JsqL_41VGf8ZFEzQyqPU_EeK=Ms+jdt_N9cvRyLFkXF2MTg@mail.gmail.com>
 <4350940.43ZWQivOUU@avalon>
From: Rob Herring <robh@kernel.org>
Date: Tue, 15 Nov 2016 14:10:29 -0600
Message-ID: <CAL_Jsq+GZC6HwdnRm7QmyUN5GAbuvYo94ykgS3qkN2qWvAh1ag@mail.gmail.com>
Subject: Re: [PATCH 1/2] devicetree/bindings: display: Add bindings for LVDS panels
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "open list:MEDIA DRIVERS FOR RENESAS - FCP"
        <linux-renesas-soc@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 14, 2016 at 8:11 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Rob,
>
> On Monday 14 Nov 2016 19:40:26 Rob Herring wrote:
>> On Mon, Oct 17, 2016 at 7:42 AM, Laurent Pinchart wrote:
>> > On Friday 14 Oct 2016 07:40:14 Rob Herring wrote:
>> >> On Sun, Oct 9, 2016 at 11:33 AM, Laurent Pinchart wrote:
>> >>> On Saturday 08 Oct 2016 20:29:39 Rob Herring wrote:
>> >>>> On Tue, Oct 04, 2016 at 07:23:29PM +0300, Laurent Pinchart wrote:
>> >>>>> LVDS is a physical layer specification defined in ANSI/TIA/EIA-644-A.
>> >>>>> Multiple incompatible data link layers have been used over time to
>> >>>>> transmit image data to LVDS panels. This binding supports display
>> >>>>> panels compatible with the JEIDA-59-1999, Open-LDI and VESA SWPG
>> >>>>> specifications.

[...]

>> >>> Furthermore, LVDS data organization is controlled by the combination of
>> >>> both data-mapping and data-mirror. It makes little sense from my point
>> >>> of view to handle one as part of the compatible string and the other one
>> >>> as a separate property.
>> >>>
>> >>>> > +Optional properties:
>> >>>> > +- label: a symbolic name for the panel
>> >>>>
>> >>>> Could be for any panel or display connector.
>> >>>
>> >>> Yes, but I'm not sure to understand how that's relevant :-)
>> >>
>> >> Meaning it should be a common property.
>> >
>> > Sure. So you expect me to reorganize all the panels and connectors DT
>> > bindings in order to get this one merged ? :-)
>>
>> No, because I don't think label is widely defined. Just put it in a
>> common place and reference it. Any other panels can be fixed later.
>> Really, the "simple panel" binding should probably morph into the
>> common binding.
>
> The "label" property is actually defined in the "Devicetree Specification,

Yes, so is reg, interrupts, etc. but we still list when those are used.

> Release 0.1" as recently published on devicetree.org. Where would you like me
> to define it in the bindings ?

Just split things into 2 files. Move everything that's used in other
panel bindings (label, width-mm, ports, etc.) to a panel/common.txt.
Then in lvds-panel.txt, it just refers to common.txt and is just the
LVDS specific things. Bonus points if simple-panel (should just go
away), panel-dpi, panel-dsi-cm are converted.

>> >>>>> +- avdd-supply: reference to the regulator that powers the panel
>> >>>>> analog supply
>> >>>>> +- dvdd-supply: reference to the regulator that powers the panel
>> >>>>> digital supply

I would not be against these being common either. It's somewhat better
than simple-panel's "power-supply" property.

>> >>>>
>> >>>> Which one has to be powered on first, what voltage, and with what time
>> >>>> in between? This is why "generic" or "simple" bindings don't work.
>> >>>
>> >>> The above-mentioned specifications also define connectors, pinouts and
>> >>> power supplies, but many LVDS panels compatible with the LVDS physical
>> >>> and data layers use a different connector with small differences in
>> >>> power supplies.
>> >>>
>> >>> I believe the voltage is irrelevant here, it doesn't need to be
>> >>> controlled by the operating system. Power supplies order and timing is
>> >>> relevant, I'll investigate the level of differences between panels. I'm
>> >>> also fine with dropping those properties for now.
>> >>
>> >> Whether you have control of the supplies is dependent on the board.
>> >> Dropping them is just puts us in the simple binding trap. The simple
>> >> bindings start out that way and then people keep adding to them.
>> >
>> > Damn, you can't be fooled easily ;-)
>>
>> I guess you can count all the simple bindings to see how many times I
>> can be fooled. :)
>>
>> > On a more serious note, I'd like to design the bindings in a way that
>> > wouldn't require adding device-specific code in the driver for each panel
>> > model, given that in most cases power supply handling will be generic.
>> > What's your opinion about a generic power supply model that would be used
>> > in the default case, with the option to override it with device-specific
>> > code when needed ?
>>
>> I don't agree. Read Thierry's post on the subject[1].
>
> I'm not sure you understood me correctly (and writing a clarification at
> 4:00am might not help :-)). My point here is that a fair number of panels
> don't care about power sequencing and have no control GPIOs (that's certainly
> the case of the two Mitsubishi panels I use here that have a single power
> supply - good luck trying to convince me that this needs to be sequenced :-) -
> and no enable or reset control pin). This kind of panel should obviously be
> modelled in DT with both a specific and a generic ("panel-lvds") compatible
> string, to ensure that we'll have enough information available on the
> operating system side to control the panel properly. The power supply(ies)
> should be documented in relation to the specific compatible string and not
> mentioned by the generic bindings (whether that should go in one or multiple
> text files is bikeshedding).

Let me rephrase, I don't agree with generic bindings, but I fully
support having a generic driver. So you can have a generic driver
function that can handle your case. Even slightly more complicated can
be handled: turn on all the supplies listed, de-assert any reset
gpios, assert any enable gpios (this is why I push for common naming
of "enable-gpios"). If this is enough for a panel, then the generic
compatible will work. If not, sorry, provide your own power sequencing
code and match on the more specific compatible.

> This being said, on the driver side, I don't see a reason to list the specific
> compatible strings explicitly for those panels when a generic implementation
> matching the generic compatible string can handle them fine. This has no
> impact on the bindings and is an Linux implementation decision.

I think we're in agreement.

Rob
