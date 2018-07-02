Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34582 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933098AbeGBHTd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 03:19:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: jacopo mondi <jacopo@jmondi.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>, horms@verge.net.au,
        geert@glider.be, mchehab@kernel.org, hans.verkuil@cisco.com,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v4 6/6] dt-bindings: media: rcar-vin: Clarify optional props
Date: Mon, 02 Jul 2018 10:19:25 +0300
Message-ID: <39247463.ySXe3lkPXm@avalon>
In-Reply-To: <20180627052431.GO5237@bigcity.dyn.berto.se>
References: <1528813566-17927-1-git-send-email-jacopo+renesas@jmondi.org> <20180613085455.GC4952@w540> <20180627052431.GO5237@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Wednesday, 27 June 2018 08:24:31 EEST Niklas S=F6derlund wrote:
> On 2018-06-13 10:54:55 +0200, Jacopo Mondi wrote:
> > On Tue, Jun 12, 2018 at 06:45:53PM +0300, Sakari Ailus wrote:
> >> On Tue, Jun 12, 2018 at 04:26:06PM +0200, Jacopo Mondi wrote:
> >>> Add a note to the R-Car VIN interface bindings to clarify that all
> >>> properties listed as generic properties in video-interfaces.txt can
> >>> be included in port@0 endpoint, but if not explicitly listed in the
> >>> interface bindings documentation, they do not modify it behaviour.
> >>>=20
> >>> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> >>> ---
> >>>=20
> >>>  Documentation/devicetree/bindings/media/rcar_vin.txt | 6 ++++++
> >>>  1 file changed, 6 insertions(+)
> >>>=20
> >>> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt
> >>> b/Documentation/devicetree/bindings/media/rcar_vin.txt index
> >>> 8130849..03544c7 100644
> >>> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> >>> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> >>> @@ -55,6 +55,12 @@ from local SoC CSI-2 receivers (port1) depending on
> >>> SoC.
> >>>=20
> >>>        instances that are connected to external pins should have port
> >>>        0.
> >>>=20
> >>>        - Optional properties for endpoint nodes of port@0:
> >>> +
> >>> +        All properties described in [1] and which apply to the
> >>> selected
> >>> +        media bus type could be optionally listed here to better
> >>> describe
> >>> +        the current hardware configuration, but only the following
> >>> ones do
> >>> +        actually modify the VIN interface behaviour:
> >>> +
>=20
> I'm not sure the description have to be as explicit to that the
> properties in 'video-interfaces.txt' are not currently used by the
> driver. I find it not relevant which ones are used or not, what is
> important for me is that all properties in 'video-interfaces.txt' which
> can be used to describe the specific bus are valid for the DT
> description.

I agree with you. The driver is irrelevant in this context. What matters is=
=20
which properties are applicable to the bus. For instance, if the VIN parall=
el=20
input supports configurable polarities for the h/v sync signals, hsync-acti=
ve=20
and vsync-active should be listed in the bindings. On the other hand, if th=
e=20
polarities are fixed, then the properties are not needed.

> On a side note, in rcar_vin.txt we have this section describing the Gen2
> bindings:
>=20
>   The per-board settings Gen2 platforms:
>    - port sub-node describing a single endpoint connected to the vin
>      as described in video-interfaces.txt[1]. Only the first one will
>      be considered as each vin interface has one input port.
>=20
> This whole series only deals with documenting the Gen3 optional
> properties and not the Gen2. Maybe with parallel input support for Gen3
> patches on there way to making it upstream this series should be
> extended to in a good way merge the port@0 optional properties for both
> generations of hardware?

That would be nice too :-)

> >> I don't think this should be needed. You should only have properties
> >> that describe the hardware configuration in a given system.
> >=20
> > There has been quite some debate on this, and please bear with me
> > here for re-proposing it: I started by removing properties in some DT
> > files for older Renesas board which listed endpoint properties not
> > documented in the VIN's bindings and not parsed by the VIN driver [1]
> > Niklas (but Simon and Geert seems to agree here) opposed to that
> > patch, as those properties where described in 'video-interfaces.txt' and
> > even if not parsed by the current driver implementation, they actually
> > describe hardware. I rebated that only properties listed in the device
> > bindings documentation should actually be used, and having properties
> > not parsed by the driver confuses users, which may expect changing
> > them modifies the interface configuration, which does not happens at
> > the moment.
> >=20
> > This came out as a middle ground from a discussion with Niklas. As
> > stated in the cover letter if this patch makes someone uncomfortable, f=
eel
> > free to drop it not to hold back the rest of the series which has been
> > well received instead.
>=20
> What I don't agree with and sparked this debate from my side was the
> deletion of properties in dts files which correctly does describe the
> bus but which are not currently parsed by the driver. To me that is
> decreasing the value of the dts. If on the other hand the goal is to
> deprecate a property from the video-interfaces.txt by slowly removing
> them from dts where the driver don't use them I'm all for it. But I
> don't think this is the case here right?

I think you're right, I don't think that's the case.

We should not remove properties from the dts files when they correctly=20
describe the hardware and have an added-value. On the other hand, if a=20
property correctly describes the hardware, but is constrained to a single=20
value due to hardware limitations, then we can omit it.

> > [1] https://www.spinics.net/lists/arm-kernel/msg656302.html
> >=20
> >>> - hsync-active: see [1] for description. Default is active high.
> >>> - vsync-active: see [1] for description. Default is active high.
> >>> - data-enable-active: polarity of CLKENB signal, see [1] for

=2D-=20
Regards,

Laurent Pinchart
