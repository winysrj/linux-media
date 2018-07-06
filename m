Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:39632 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933458AbeGFPya (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2018 11:54:30 -0400
Received: by mail-lf0-f65.google.com with SMTP id a134-v6so10190733lfe.6
        for <linux-media@vger.kernel.org>; Fri, 06 Jul 2018 08:54:30 -0700 (PDT)
Date: Fri, 6 Jul 2018 17:54:27 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>, horms@verge.net.au,
        geert@glider.be, mchehab@kernel.org, hans.verkuil@cisco.com,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v4 6/6] dt-bindings: media: rcar-vin: Clarify optional
 props
Message-ID: <20180706155427.GE5237@bigcity.dyn.berto.se>
References: <1528813566-17927-1-git-send-email-jacopo+renesas@jmondi.org>
 <20180613085455.GC4952@w540>
 <20180627052431.GO5237@bigcity.dyn.berto.se>
 <39247463.ySXe3lkPXm@avalon>
 <20180703195238.GD5611@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180703195238.GD5611@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for not giving up on this work :-)

On 2018-07-03 21:52:38 +0200, Jacopo Mondi wrote:
> Hi Laurent, Niklas,
> 
> On Mon, Jul 02, 2018 at 10:19:25AM +0300, Laurent Pinchart wrote:
> > Hi Niklas,
> >
> > On Wednesday, 27 June 2018 08:24:31 EEST Niklas Söderlund wrote:
> > > On 2018-06-13 10:54:55 +0200, Jacopo Mondi wrote:
> > > > On Tue, Jun 12, 2018 at 06:45:53PM +0300, Sakari Ailus wrote:
> > > >> On Tue, Jun 12, 2018 at 04:26:06PM +0200, Jacopo Mondi wrote:
> > > >>> Add a note to the R-Car VIN interface bindings to clarify that all
> > > >>> properties listed as generic properties in video-interfaces.txt can
> > > >>> be included in port@0 endpoint, but if not explicitly listed in the
> > > >>> interface bindings documentation, they do not modify it behaviour.
> > > >>>
> > > >>> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > > >>> ---
> > > >>>
> > > >>>  Documentation/devicetree/bindings/media/rcar_vin.txt | 6 ++++++
> > > >>>  1 file changed, 6 insertions(+)
> > > >>>
> > > >>> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt
> > > >>> b/Documentation/devicetree/bindings/media/rcar_vin.txt index
> > > >>> 8130849..03544c7 100644
> > > >>> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> > > >>> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> > > >>> @@ -55,6 +55,12 @@ from local SoC CSI-2 receivers (port1) depending on
> > > >>> SoC.
> > > >>>
> > > >>>        instances that are connected to external pins should have port
> > > >>>        0.
> > > >>>
> > > >>>        - Optional properties for endpoint nodes of port@0:
> > > >>> +
> > > >>> +        All properties described in [1] and which apply to the
> > > >>> selected
> > > >>> +        media bus type could be optionally listed here to better
> > > >>> describe
> > > >>> +        the current hardware configuration, but only the following
> > > >>> ones do
> > > >>> +        actually modify the VIN interface behaviour:
> > > >>> +
> > >
> > > I'm not sure the description have to be as explicit to that the
> > > properties in 'video-interfaces.txt' are not currently used by the
> > > driver. I find it not relevant which ones are used or not, what is
> > > important for me is that all properties in 'video-interfaces.txt' which
> > > can be used to describe the specific bus are valid for the DT
> > > description.
> >
> > I agree with you. The driver is irrelevant in this context. What matters is
> > which properties are applicable to the bus. For instance, if the VIN parallel
> > input supports configurable polarities for the h/v sync signals, hsync-active
> > and vsync-active should be listed in the bindings. On the other hand, if the
> > polarities are fixed, then the properties are not needed.
> >
> 
> Fine, I'll surrender then, you're too many to fight against :p
> 
> Joking aside, I see your points, and I'll resend dropping this last
> bit and documenting which properties applies to the interface.
> 
> I can list:
> - vsync-active (added by this series)
> - hsync-active (added by this series)
> - data-enable-active (added by this series)
> - field-active-even (to be added)
> 
> I haven't find a way to configure the plck-sample value in the VINs
> registers. Should we skip it?

IIRC my findings agree with yours, no register to control plck-sample in 
the VIN register set.

> 
> I also think 'bus-width' and 'data-shift' are not directly configurable in
> registers but depends on SoC, the selected input interface, and the
> input image format (see tables at 26.3.1 datasheet revision 1.00), so
> it makes sense list them as acceptable properties.
> 
> Do I have your ack on this so I can re-spin?

I think I understand your plan and I think it sounds ok, please try it 
:-)

> 
> > > On a side note, in rcar_vin.txt we have this section describing the Gen2
> > > bindings:
> > >
> > >   The per-board settings Gen2 platforms:
> > >    - port sub-node describing a single endpoint connected to the vin
> > >      as described in video-interfaces.txt[1]. Only the first one will
> > >      be considered as each vin interface has one input port.
> > >
> > > This whole series only deals with documenting the Gen3 optional
> > > properties and not the Gen2. Maybe with parallel input support for Gen3
> > > patches on there way to making it upstream this series should be
> > > extended to in a good way merge the port@0 optional properties for both
> > > generations of hardware?
> >
> > That would be nice too :-)
> 
> I see..
> 
> Well, I would keep the Gen2/Gen3 sections separate, as they have a
> different layout of port nodes (Gen2 has a single 'port' node, while Gen3 could
> have several 'port' nodes enclosed in a 'ports' one).
> 
> But I could indeed reference the optional endpoint properties of
> 'port@0' of Gen3 bindings in Gen2 ones. Or the other way around. Do
> you have any preference?

My preference would be to list the properties in the Gen2 section and in 
the Gen3 port@0 section refer to the Gen2 optional properties.

> 
> Thanks
>    j
> 
> 
> >
> > > >> I don't think this should be needed. You should only have properties
> > > >> that describe the hardware configuration in a given system.
> > > >
> > > > There has been quite some debate on this, and please bear with me
> > > > here for re-proposing it: I started by removing properties in some DT
> > > > files for older Renesas board which listed endpoint properties not
> > > > documented in the VIN's bindings and not parsed by the VIN driver [1]
> > > > Niklas (but Simon and Geert seems to agree here) opposed to that
> > > > patch, as those properties where described in 'video-interfaces.txt' and
> > > > even if not parsed by the current driver implementation, they actually
> > > > describe hardware. I rebated that only properties listed in the device
> > > > bindings documentation should actually be used, and having properties
> > > > not parsed by the driver confuses users, which may expect changing
> > > > them modifies the interface configuration, which does not happens at
> > > > the moment.
> > > >
> > > > This came out as a middle ground from a discussion with Niklas. As
> > > > stated in the cover letter if this patch makes someone uncomfortable, feel
> > > > free to drop it not to hold back the rest of the series which has been
> > > > well received instead.
> > >
> > > What I don't agree with and sparked this debate from my side was the
> > > deletion of properties in dts files which correctly does describe the
> > > bus but which are not currently parsed by the driver. To me that is
> > > decreasing the value of the dts. If on the other hand the goal is to
> > > deprecate a property from the video-interfaces.txt by slowly removing
> > > them from dts where the driver don't use them I'm all for it. But I
> > > don't think this is the case here right?
> >
> > I think you're right, I don't think that's the case.
> >
> > We should not remove properties from the dts files when they correctly
> > describe the hardware and have an added-value. On the other hand, if a
> > property correctly describes the hardware, but is constrained to a single
> > value due to hardware limitations, then we can omit it.
> >
> > > > [1] https://www.spinics.net/lists/arm-kernel/msg656302.html
> > > >
> > > >>> - hsync-active: see [1] for description. Default is active high.
> > > >>> - vsync-active: see [1] for description. Default is active high.
> > > >>> - data-enable-active: polarity of CLKENB signal, see [1] for
> >
> > --
> > Regards,
> >
> > Laurent Pinchart
> >
> >
> >



-- 
Regards,
Niklas Söderlund
