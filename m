Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39254 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964792AbcKOCLs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 21:11:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Rob Herring <robh@kernel.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "open list:MEDIA DRIVERS FOR RENESAS - FCP"
        <linux-renesas-soc@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] devicetree/bindings: display: Add bindings for LVDS panels
Date: Tue, 15 Nov 2016 04:11:55 +0200
Message-ID: <4350940.43ZWQivOUU@avalon>
In-Reply-To: <CAL_JsqL_41VGf8ZFEzQyqPU_EeK=Ms+jdt_N9cvRyLFkXF2MTg@mail.gmail.com>
References: <1475598210-26857-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1488637.i0jADhlNmg@avalon> <CAL_JsqL_41VGf8ZFEzQyqPU_EeK=Ms+jdt_N9cvRyLFkXF2MTg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

On Monday 14 Nov 2016 19:40:26 Rob Herring wrote:
> On Mon, Oct 17, 2016 at 7:42 AM, Laurent Pinchart wrote:
> > On Friday 14 Oct 2016 07:40:14 Rob Herring wrote:
> >> On Sun, Oct 9, 2016 at 11:33 AM, Laurent Pinchart wrote:
> >>> On Saturday 08 Oct 2016 20:29:39 Rob Herring wrote:
> >>>> On Tue, Oct 04, 2016 at 07:23:29PM +0300, Laurent Pinchart wrote:
> >>>>> LVDS is a physical layer specification defined in ANSI/TIA/EIA-644-A.
> >>>>> Multiple incompatible data link layers have been used over time to
> >>>>> transmit image data to LVDS panels. This binding supports display
> >>>>> panels compatible with the JEIDA-59-1999, Open-LDI and VESA SWPG
> >>>>> specifications.
> >>>>> 
> >>>>> Signed-off-by: Laurent Pinchart
> >>>>> <laurent.pinchart+renesas@ideasonboard.com>
> >>>>> ---
> >>>>> 
> >>>>>  .../bindings/display/panel/panel-lvds.txt          | 119 ++++++++++++
> >>>>>  1 file changed, 119 insertions(+)
> >>>>>  create mode 100644
> >>>>>  Documentation/devicetree/bindings/display/panel/panel-lvds.txt>
> >>>>> 
> >>>>> diff --git
> >>>>> a/Documentation/devicetree/bindings/display/panel/panel-lvds.txt
> >>>>> b/Documentation/devicetree/bindings/display/panel/panel-lvds.txt
> >>>>> new file mode 100644
> >>>>> index 000000000000..250861f2673e
> >>>>> --- /dev/null
> >>>>> +++ b/Documentation/devicetree/bindings/display/panel/panel-lvds.txt
> >>>>> @@ -0,0 +1,119 @@
> >>>>> +Generic LVDS Panel
> >>>>> +==================
> >>>>> +
> >>>>> +LVDS is a physical layer specification defined in
> >>>>> ANSI/TIA/EIA-644-A. Multiple
> >>>>> +incompatible data link layers have been used over time to transmit
> >>>>> image data
> >>>>> +to LVDS panels. This bindings supports display panels compatible
> >>>>> with the
> >>>>> +following specifications.
> >>>>> +
> >>>>> +[JEIDA] "Digital Interface Standards for Monitor", JEIDA-59-1999,
> >>>>> February
> >>>>> +1999 (Version 1.0), Japan Electronic Industry Development
> >>>>> Association (JEIDA)
> >>>>> +[LDI] "Open LVDS Display Interface", May 1999 (Version 0.95),
> >>>>> National
> >>>>> +Semiconductor
> >>>>> +[VESA] "VESA Notebook Panel Standard", October 2007 (Version 1.0),
> >>>>> Video
> >>>>> +Electronics Standards Association (VESA)
> >>>>> +
> >>>>> +Device compatible with those specifications have been marketed under
> >>>>> the
> >>>>> +FPD-Link and FlatLink brands.
> >>>>> +
> >>>>> +
> >>>>> +Required properties:
> >>>>> +- compatible: shall contain "panel-lvds"
> >>>> 
> >>>> Maybe as a fallback, but on its own, no way.
> >>> 
> >>> Which brings an interesting question: when designing generic DT
> >>> bindings, what's the rule regarding
> > 
> > Looks like I forgot part of the question. I meant to ask what is the rule
> > regarding usage of more precise compatible strings ?
> 
> When in doubt, always have one. If there's any chance at all that s/w
> will need to know or care, then we should have one.
> 
> > For instance (but perhaps not the best example), the
> > input/rotary-encoder.txt bindings define a "rotary-encoder" compatible
> > string, with no other bindings defining more precise compatible strings
> > for the exact rotary encoder model. When it comes to panels I believe it
> > makes sense to define model-specific compatible strings even if they're
> > unused by drivers. I'm however wondering what the rule is there, and
> > where those device-specific compatible strings should be defined. I'd
> > like to avoid using one file per panel model as done today for the
> > simple-panel bindings.
> 
> There's a few exceptions like this where there is not any sort of
> model to base a compatible on. For example, a GPIO connected LED is
> truly generic. The only way to have a more specific compatible would
> be something with the board name in it.
> 
> Your case here is in the middle. It seems like it's generic and
> passive, but perhaps power control is not. Rather than trying to
> decide, we can just cover our ass and put both a generic and specific
> compatible in.

That sounds good to me. I'll mention in the document that a more precise 
compatible is required.

> >> Call it "simple" so I can easily NAK it. :)
> >> 
> >> Define a generic structure, not a single binding trying to serve all.
> >> 
> >>>>> +- width-mm: panel display width in millimeters
> >>>>> +- height-mm: panel display height in millimeters
> >>>> 
> >>>> This is already documented for all panels IIRC.
> >>> 
> >>> Note that this DT binding has nothing to do with the simple-panel
> >>> binding. It is instead similar to the panel-dpi and panel-dsi-cm
> >>> bindings (which currently don't but should specify the panel size in
> >>> DT). The LVDS panel driver will *not* include any panel-specific
> >>> information such as size or timings, these are specified in DT.
> >> 
> >> The panel bindings aren't really different. The biggest difference was
> >> location in the tree, but we now generally allow panels to be either a
> >> child of the LCD controller or connected with OF graph. We probably
> >> need to work on restructuring the panel bindings a bit. We should have
> >> an inheritance with a base panel binding of things like size, label,
> >> graph, backlight, etc, then perhaps an interface specific bindings for
> >> LVDS, DSI, and parallel, then a panel specific binding. With this the
> >> panel specific binding is typically just a compatible string and which
> >> inherited properties apply to it.
> > 
> > That sounds good to me, but we have multiple models for panel bindings.
> > 
> > As you mentioned panels can be referenced through an LCD controller node
> > property containing a phandle to the panel node, or through OF graph.
> > That's a situation we have today, and we need to keep supporting both (at
> > least for existing panels, perhaps not for the new ones).
> > 
> > Another difference is how to express panel data such as size and timings.
> > The simple-panel DT bindings don't contain such data and expects the
> > drivers to contain a table of panel data for all models supported, while
> > the DPI, DSI and now the proposed LVDS panel bindings contain properties
> > for panel data.
> > 
> > How would you like to reconcile all that ?
> 
> Thierry has outlined the position[1] that simple-panel follows many
> times and I generally agree. I could be convinced that perhaps panel
> timings could go into DT. However, you can't really describe
> *everything*, so we're not going to get away from panel specific
> compatible strings and panel specifics in the kernel.

I'm fine with that middle ground, and will include panel timings in DT but not 
an information related to power sequencing or other panel-specific properties 
(beside the standardized properties defined in this binding of course).

> >>>>> +- data-mapping: the color signals mapping order, "jeida-18",
> >>>>> "jeida-24"
> >>>>> +  or "vesa-24"
> >>>> 
> >>>> Maybe this should be part of the compatible.
> >>> 
> >>> I've thought about it, but given that some panels support selecting
> >>> between multiple modes (through a mode pin that is usually hardwired),
> >>> I believe a separate DT property makes sense.
> >> 
> >> Okay.
> >> 
> >>> Furthermore, LVDS data organization is controlled by the combination of
> >>> both data-mapping and data-mirror. It makes little sense from my point
> >>> of view to handle one as part of the compatible string and the other one
> >>> as a separate property.
> >>> 
> >>>> > +Optional properties:
> >>>> > +- label: a symbolic name for the panel
> >>>> 
> >>>> Could be for any panel or display connector.
> >>> 
> >>> Yes, but I'm not sure to understand how that's relevant :-)
> >> 
> >> Meaning it should be a common property.
> > 
> > Sure. So you expect me to reorganize all the panels and connectors DT
> > bindings in order to get this one merged ? :-)
> 
> No, because I don't think label is widely defined. Just put it in a
> common place and reference it. Any other panels can be fixed later.
> Really, the "simple panel" binding should probably morph into the
> common binding.

The "label" property is actually defined in the "Devicetree Specification, 
Release 0.1" as recently published on devicetree.org. Where would you like me 
to define it in the bindings ?

> >>>>> +- avdd-supply: reference to the regulator that powers the panel
> >>>>> analog supply
> >>>>> +- dvdd-supply: reference to the regulator that powers the panel
> >>>>> digital supply
> >>>> 
> >>>> Which one has to be powered on first, what voltage, and with what time
> >>>> in between? This is why "generic" or "simple" bindings don't work.
> >>> 
> >>> The above-mentioned specifications also define connectors, pinouts and
> >>> power supplies, but many LVDS panels compatible with the LVDS physical
> >>> and data layers use a different connector with small differences in
> >>> power supplies.
> >>> 
> >>> I believe the voltage is irrelevant here, it doesn't need to be
> >>> controlled by the operating system. Power supplies order and timing is
> >>> relevant, I'll investigate the level of differences between panels. I'm
> >>> also fine with dropping those properties for now.
> >> 
> >> Whether you have control of the supplies is dependent on the board.
> >> Dropping them is just puts us in the simple binding trap. The simple
> >> bindings start out that way and then people keep adding to them.
> > 
> > Damn, you can't be fooled easily ;-)
> 
> I guess you can count all the simple bindings to see how many times I
> can be fooled. :)
> 
> > On a more serious note, I'd like to design the bindings in a way that
> > wouldn't require adding device-specific code in the driver for each panel
> > model, given that in most cases power supply handling will be generic.
> > What's your opinion about a generic power supply model that would be used
> > in the default case, with the option to override it with device-specific
> > code when needed ?
>
> I don't agree. Read Thierry's post on the subject[1].

I'm not sure you understood me correctly (and writing a clarification at 
4:00am might not help :-)). My point here is that a fair number of panels 
don't care about power sequencing and have no control GPIOs (that's certainly 
the case of the two Mitsubishi panels I use here that have a single power 
supply - good luck trying to convince me that this needs to be sequenced :-) - 
and no enable or reset control pin). This kind of panel should obviously be 
modelled in DT with both a specific and a generic ("panel-lvds") compatible 
string, to ensure that we'll have enough information available on the 
operating system side to control the panel properly. The power supply(ies) 
should be documented in relation to the specific compatible string and not 
mentioned by the generic bindings (whether that should go in one or multiple 
text files is bikeshedding).

This being said, on the driver side, I don't see a reason to list the specific 
compatible strings explicitly for those panels when a generic implementation 
matching the generic compatible string can handle them fine. This has no 
impact on the bindings and is an Linux implementation decision.

> [1]
> http://sietch-tagr.blogspot.com/2016/04/display-panels-are-not-special.html

-- 
Regards,

Laurent Pinchart

