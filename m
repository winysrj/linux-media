Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36324 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751829AbdFNKqi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 06:46:38 -0400
Date: Wed, 14 Jun 2017 13:45:58 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v7 1/2] media: rcar-csi2: add Renesas R-Car MIPI CSI-2
 receiver documentation
Message-ID: <20170614104558.GL12407@valkosipuli.retiisi.org.uk>
References: <20170524001353.13482-1-niklas.soderlund@ragnatech.se>
 <20170524001353.13482-2-niklas.soderlund@ragnatech.se>
 <20170529111624.GC29527@valkosipuli.retiisi.org.uk>
 <20170613165014.GA10888@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170613165014.GA10888@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Tue, Jun 13, 2017 at 06:50:14PM +0200, Niklas Söderlund wrote:
> Hi Sakari,
> 
> Thanks for your feedback.
> 
> On 2017-05-29 14:16:25 +0300, Sakari Ailus wrote:
> > Hi Niklas,
> > 
> > On Wed, May 24, 2017 at 02:13:52AM +0200, Niklas Söderlund wrote:
> > > From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > > 
> > > Documentation for Renesas R-Car MIPI CSI-2 receiver. The CSI-2 receivers
> > > are located between the video sources (CSI-2 transmitters) and the video
> > > grabbers (VIN) on Gen3 of Renesas R-Car SoC.
> > > 
> > > Each CSI-2 device is connected to more then one VIN device which
> > > simultaneously can receive video from the same CSI-2 device. Each VIN
> > > device can also be connected to more then one CSI-2 device. The routing
> > > of which link are used are controlled by the VIN devices. There are only
> > > a few possible routes which are set by hardware limitations, which are
> > > different for each SoC in the Gen3 family.
> > > 
> > > To work with the limitations of routing possibilities it is necessary
> > > for the DT bindings to describe which VIN device is connected to which
> > > CSI-2 device. This is why port 1 needs to to assign reg numbers for each
> > > VIN device that be connected to it. To setup and to know which links are
> > > valid for each SoC is the responsibility of the VIN driver since the
> > > register to configure it belongs to the VIN hardware.
> > > 
> > > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > > ---
> > >  .../devicetree/bindings/media/rcar-csi2.txt        | 116 +++++++++++++++++++++
> > >  1 file changed, 116 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/media/rcar-csi2.txt
> > > 
> > > diff --git a/Documentation/devicetree/bindings/media/rcar-csi2.txt b/Documentation/devicetree/bindings/media/rcar-csi2.txt
> > > new file mode 100644
> > > index 0000000000000000..f6e2027ee92b171a
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/media/rcar-csi2.txt
> > > @@ -0,0 +1,116 @@
> > > +Renesas R-Car MIPI CSI-2
> > > +------------------------
> > > +
> > > +The rcar-csi2 device provides MIPI CSI-2 capabilities for the Renesas R-Car
> > > +family of devices. It is to be used in conjunction with the R-Car VIN module,
> > > +which provides the video capture capabilities.
> > > +
> > > + - compatible: Must be one or more of the following
> > > +   - "renesas,r8a7795-csi2" for the R8A7795 device.
> > > +   - "renesas,r8a7796-csi2" for the R8A7796 device.
> > > +   - "renesas,rcar-gen3-csi2" for a generic R-Car Gen3 compatible device.
> > > +
> > > +   When compatible with a generic version nodes must list the
> > > +   SoC-specific version corresponding to the platform first
> > > +   followed by the generic version.
> > > +
> > > + - reg: the register base and size for the device registers
> > > + - interrupts: the interrupt for the device
> > > + - clocks: Reference to the parent clock
> > > +
> > > +The device node should contain two 'port' child nodes according to the
> > > +bindings defined in Documentation/devicetree/bindings/media/
> > > +video-interfaces.txt. Port 0 should connect the node that is the video
> > > +source for to the CSI-2. Port 1 should connect all the R-Car VIN
> > > +modules, which can make use of the CSI-2 module.
> > 
> > Should or shall?
> > 
> > I guess you could add that it is possible to leave them unconnected, too.
> 
> Which ports/endpoints are you talking about? In my mind it's not allowed 
> to leave them unconnected.
> 
> If there ever is a system with only 4 VIN instances (I'm not aware of 
> any such system) then yes the endpoints for those VIN not present in the 
> system in port 1 should be left unconnected but other then that they 
> should all be mandatory right? Or am I missing something?

I think so, yes. Then "shall" is right, isn't it?

> 
> > 
> > > +
> > > +- Port 0 - Video source
> > > +	- Reg 0 - sub-node describing the endpoint that is the video source
> > 
> > Which endpoint properties are mandatory for the receiver? Which ones are
> > optional? (I.e. it shouldn't be necessary to read driver code to write board
> > description.)
> 
> I will add a note that all endpoints in port 0 are mandatory and that 
> all endpoints that represents a connection to a VIN instance in the 
> system is mandatory for next version. Thanks I did not think about this 
> possibility.

Please list the mandatory and optional properties, too. Not just the
endpoints.

-- 
Hälsningar,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
