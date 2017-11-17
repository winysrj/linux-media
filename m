Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933177AbdKQNln (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 08:41:43 -0500
MIME-Version: 1.0
In-Reply-To: <20171115225814.GJ12677@bigcity.dyn.berto.se>
References: <20171111003835.4909-1-niklas.soderlund+renesas@ragnatech.se>
 <20171111003835.4909-2-niklas.soderlund+renesas@ragnatech.se>
 <20171115200226.wd343hd3a52jjhdd@rob-hp-laptop> <20171115225814.GJ12677@bigcity.dyn.berto.se>
From: Rob Herring <robh@kernel.org>
Date: Fri, 17 Nov 2017 07:41:21 -0600
Message-ID: <CAL_Jsq+FxuYw5bpSOj+i_mL_0zVGJJaKgiVdCgOq5BLqeLAUZQ@mail.gmail.com>
Subject: Re: [PATCH v7 01/25] rcar-vin: add Gen3 devicetree bindings documentation
To: =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "open list:MEDIA DRIVERS FOR RENESAS - FCP"
        <linux-renesas-soc@vger.kernel.org>,
        tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 15, 2017 at 4:58 PM, Niklas Söderlund
<niklas.soderlund@ragnatech.se> wrote:
> Hi Rob,
>
> Thanks for your feedback, much appreciated!
>
> On 2017-11-15 14:02:26 -0600, Rob Herring wrote:
>> On Sat, Nov 11, 2017 at 01:38:11AM +0100, Niklas Söderlund wrote:
>> > Document the devicetree bindings for the CSI-2 inputs available on Gen3.
>> >
>> > There is a need to add a custom property 'renesas,id' and to define
>> > which CSI-2 input is described in which endpoint under the port@1 node.
>> > This information is needed since there are a set of predefined routes
>> > between each VIN and CSI-2 block. This routing table will be kept
>> > inside the driver but in order for it to act on it it must know which
>> > VIN and CSI-2 is which.
>> >
>> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
>> > ---
>> >  .../devicetree/bindings/media/rcar_vin.txt         | 116 ++++++++++++++++++---
>> >  1 file changed, 104 insertions(+), 12 deletions(-)
>> >
>> > diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
>> > index 6e4ef8caf759e5d3..df1abd0fb20386f8 100644
>> > --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
>> > +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
>> > @@ -2,8 +2,12 @@ Renesas R-Car Video Input driver (rcar_vin)
>> >  -------------------------------------------
>> >
>> >  The rcar_vin device provides video input capabilities for the Renesas R-Car
>> > -family of devices. The current blocks are always slaves and suppot one input
>> > -channel which can be either RGB, YUYV or BT656.
>> > +family of devices.
>> > +
>> > +Each VIN instance has a single parallel input that supports RGB and YUV video,
>> > +with both external synchronization and BT.656 synchronization for the latter.
>> > +Depending on the instance the VIN input is connected to external SoC pins, or
>> > +on Gen3 to a CSI-2 receiver.
>> >
>> >   - compatible: Must be one or more of the following
>> >     - "renesas,vin-r8a7795" for the R8A7795 device
>> > @@ -28,21 +32,38 @@ channel which can be either RGB, YUYV or BT656.
>> >  Additionally, an alias named vinX will need to be created to specify
>> >  which video input device this is.
>> >
>> > -The per-board settings:
>> > +The per-board settings Gen2:
>> >   - port sub-node describing a single endpoint connected to the vin
>> >     as described in video-interfaces.txt[1]. Only the first one will
>> >     be considered as each vin interface has one input port.
>> >
>> > -   These settings are used to work out video input format and widths
>> > -   into the system.
>> > +The per-board settings Gen3:
>> > +
>> > +Gen3 can support both a single connected parallel input source from
>> > +external SoC pins (port0) and/or multiple parallel input sources from
>> > +local SoC CSI-2 receivers (port1) depending on SoC.
>> >
>> > +- renesas,id - ID number of the VIN, VINx in the documentation.
>>
>> Why is this needed? We try to avoid indexes unless that's the only way a
>> device is addressed (and then we use reg).
>
> This is unfortunately needed (or something similar) as there is a
> register in one VIN instance which controls the routing of the incoming
> CSI-2 video streams, not only to itself, but also to other VIN instances
> inside the same SoC.
>
> To be more specific I will try to clarify this using the R-Car H3 as an
> example. On the H3 there are 8 instances of the capture hardware (VIN0 -
> VIN7) and 3 instances off CSI-2 receivers (CSI20, CSI40 and CSI41) which
> receives CSI-2 streams, split the possible multiple virtual channels
> (VC) encoded in CSI-2 streams and forwards it to the VIN's.
>
> The problem is that VIN0 and VIN4 are different from the other VIN's,
> they have one register (CHSEL) which controls the limited number of
> possible routes of video streams between a CSI-2 + VC to a specific VIN.
> The CHSEL register in VIN0 controls the routing for VIN0-3 and the one
> in VIN4 controls VIN4-7 (the two subgroups are similar so lets only
> consider VIN0-3).
>
> There are only a handful of routes possible and the kicker is that
> changing the CHSEL value in VIN0, directly reflects all routes for
> VIN0-VIN3 per this table:
>
> CHSEL reg in VIN0:  0         1         2         3         4
> Video sent to VIN0: CSI40/VC0 CSI20/VC0 CSI40/VC1 CSI40/VC0 CSI20/VC0
> Video sent to VIN1: CSI20/VC0 CSI40/VC1 CSI40/VC0 CSI40/VC1 CSI20/VC1
> Video sent to VIN2: CSI20/VC1 CSI40/VC0 CSI20/VC0 CSI40/VC2 CSI20/VC2
> Video sent to VIN3: CSI40/VC1 CSI20/VC1 CSI20/VC1 CSI40/VC3 CSI20/VC3
>
> So if CHSEL in VIN0 is set to 2 the following routes are active: VIN0:
> CSI40/VC1, VIN1: CSI40/VC0, VIN2: CSI20/VC0, CSI20/VC1. These routing
> tables are different for most SoCs in the R-Car Gen3 family, and are
> kept inside the driver code.
>
> So the renesas,id properly is used so that the rcar-vin driver knows
> which of the driver instances corresponds to a specific VINx number from
> the documentation so that using the media device API the correct links
> can be added and that the routing table is enforced so a user can't try
> to activate a CSI-2 + VC to a VIN link which is not possible due to
> other routes already being active.
>
> I agree that if possible I would like to not have the need for this
> property, but I can't think of another way on how to give this knowledge
> to the driver in a better way. I'm happy to try out other ideas :-)
>
> Dose this explanation make sens to you?

Yes. Thank you. It would be could to summarize this in the binding and
perhaps capture all of this information in the driver if you haven't
already.

Acked-by: Rob Herring <robh@kernel.org>

Rob
