Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:33282 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753729AbdFMQuS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 12:50:18 -0400
Received: by mail-lf0-f54.google.com with SMTP id m77so51756555lfe.0
        for <linux-media@vger.kernel.org>; Tue, 13 Jun 2017 09:50:18 -0700 (PDT)
Date: Tue, 13 Jun 2017 18:50:14 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v7 1/2] media: rcar-csi2: add Renesas R-Car MIPI CSI-2
 receiver documentation
Message-ID: <20170613165014.GA10888@bigcity.dyn.berto.se>
References: <20170524001353.13482-1-niklas.soderlund@ragnatech.se>
 <20170524001353.13482-2-niklas.soderlund@ragnatech.se>
 <20170529111624.GC29527@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170529111624.GC29527@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for your feedback.

On 2017-05-29 14:16:25 +0300, Sakari Ailus wrote:
> Hi Niklas,
> 
> On Wed, May 24, 2017 at 02:13:52AM +0200, Niklas Söderlund wrote:
> > From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > 
> > Documentation for Renesas R-Car MIPI CSI-2 receiver. The CSI-2 receivers
> > are located between the video sources (CSI-2 transmitters) and the video
> > grabbers (VIN) on Gen3 of Renesas R-Car SoC.
> > 
> > Each CSI-2 device is connected to more then one VIN device which
> > simultaneously can receive video from the same CSI-2 device. Each VIN
> > device can also be connected to more then one CSI-2 device. The routing
> > of which link are used are controlled by the VIN devices. There are only
> > a few possible routes which are set by hardware limitations, which are
> > different for each SoC in the Gen3 family.
> > 
> > To work with the limitations of routing possibilities it is necessary
> > for the DT bindings to describe which VIN device is connected to which
> > CSI-2 device. This is why port 1 needs to to assign reg numbers for each
> > VIN device that be connected to it. To setup and to know which links are
> > valid for each SoC is the responsibility of the VIN driver since the
> > register to configure it belongs to the VIN hardware.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  .../devicetree/bindings/media/rcar-csi2.txt        | 116 +++++++++++++++++++++
> >  1 file changed, 116 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/rcar-csi2.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/media/rcar-csi2.txt b/Documentation/devicetree/bindings/media/rcar-csi2.txt
> > new file mode 100644
> > index 0000000000000000..f6e2027ee92b171a
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/rcar-csi2.txt
> > @@ -0,0 +1,116 @@
> > +Renesas R-Car MIPI CSI-2
> > +------------------------
> > +
> > +The rcar-csi2 device provides MIPI CSI-2 capabilities for the Renesas R-Car
> > +family of devices. It is to be used in conjunction with the R-Car VIN module,
> > +which provides the video capture capabilities.
> > +
> > + - compatible: Must be one or more of the following
> > +   - "renesas,r8a7795-csi2" for the R8A7795 device.
> > +   - "renesas,r8a7796-csi2" for the R8A7796 device.
> > +   - "renesas,rcar-gen3-csi2" for a generic R-Car Gen3 compatible device.
> > +
> > +   When compatible with a generic version nodes must list the
> > +   SoC-specific version corresponding to the platform first
> > +   followed by the generic version.
> > +
> > + - reg: the register base and size for the device registers
> > + - interrupts: the interrupt for the device
> > + - clocks: Reference to the parent clock
> > +
> > +The device node should contain two 'port' child nodes according to the
> > +bindings defined in Documentation/devicetree/bindings/media/
> > +video-interfaces.txt. Port 0 should connect the node that is the video
> > +source for to the CSI-2. Port 1 should connect all the R-Car VIN
> > +modules, which can make use of the CSI-2 module.
> 
> Should or shall?
> 
> I guess you could add that it is possible to leave them unconnected, too.

Which ports/endpoints are you talking about? In my mind it's not allowed 
to leave them unconnected.

If there ever is a system with only 4 VIN instances (I'm not aware of 
any such system) then yes the endpoints for those VIN not present in the 
system in port 1 should be left unconnected but other then that they 
should all be mandatory right? Or am I missing something?

> 
> > +
> > +- Port 0 - Video source
> > +	- Reg 0 - sub-node describing the endpoint that is the video source
> 
> Which endpoint properties are mandatory for the receiver? Which ones are
> optional? (I.e. it shouldn't be necessary to read driver code to write board
> description.)

I will add a note that all endpoints in port 0 are mandatory and that 
all endpoints that represents a connection to a VIN instance in the 
system is mandatory for next version. Thanks I did not think about this 
possibility.

> 
> > +
> > +- Port 1 - VIN instances
> > +	- Reg 0 - sub-node describing the endpoint that is VIN0
> > +	- Reg 1 - sub-node describing the endpoint that is VIN1
> > +	- Reg 2 - sub-node describing the endpoint that is VIN2
> > +	- Reg 3 - sub-node describing the endpoint that is VIN3
> > +	- Reg 4 - sub-node describing the endpoint that is VIN4
> > +	- Reg 5 - sub-node describing the endpoint that is VIN5
> > +	- Reg 6 - sub-node describing the endpoint that is VIN6
> > +	- Reg 7 - sub-node describing the endpoint that is VIN7
> > +
> > +Example:
> > +
> > +/* SoC properties */
> > +
> > +	 csi20: csi2@fea80000 {
> > +		 compatible = "renesas,r8a7796-csi2";
> > +		 reg = <0 0xfea80000 0 0x10000>;
> > +		 interrupts = <0 184 IRQ_TYPE_LEVEL_HIGH>;
> > +		 clocks = <&cpg CPG_MOD 714>;
> > +		 power-domains = <&sysc R8A7796_PD_ALWAYS_ON>;
> > +		 status = "disabled";
> > +
> > +		 ports {
> > +			 #address-cells = <1>;
> > +			 #size-cells = <0>;
> > +
> > +			 port@1 {
> > +				 #address-cells = <1>;
> > +				 #size-cells = <0>;
> > +
> > +				 reg = <1>;
> > +
> > +				 csi20vin0: endpoint@0 {
> > +					 reg = <0>;
> > +					 remote-endpoint = <&vin0csi20>;
> > +				 };
> > +				 csi20vin1: endpoint@1 {
> > +					 reg = <1>;
> > +					 remote-endpoint = <&vin1csi20>;
> > +				 };
> > +				 csi20vin2: endpoint@2 {
> > +					 reg = <2>;
> > +					 remote-endpoint = <&vin2csi20>;
> > +				 };
> > +				 csi20vin3: endpoint@3 {
> > +					 reg = <3>;
> > +					 remote-endpoint = <&vin3csi20>;
> > +				 };
> > +				 csi20vin4: endpoint@4 {
> > +					 reg = <4>;
> > +					 remote-endpoint = <&vin4csi20>;
> > +				 };
> > +				 csi20vin5: endpoint@5 {
> > +					 reg = <5>;
> > +					 remote-endpoint = <&vin5csi20>;
> > +				 };
> > +				 csi20vin6: endpoint@6 {
> > +					 reg = <6>;
> > +					 remote-endpoint = <&vin6csi20>;
> > +				 };
> > +				 csi20vin7: endpoint@7 {
> > +					 reg = <7>;
> > +					 remote-endpoint = <&vin7csi20>;
> > +				 };
> > +			 };
> > +		 };
> > +	 };
> > +
> > +/* Board properties */
> > +
> > +	&csi20 {
> > +		status = "okay";
> > +
> > +		ports {
> > +			#address-cells = <1>;
> > +			#size-cells = <0>;
> > +
> > +			port@0 {
> > +				reg = <0>;
> > +				csi20_in: endpoint@0 {
> > +					clock-lanes = <0>;
> > +					data-lanes = <1>;
> > +					remote-endpoint = <&adv7482_txb>;
> > +				};
> > +			};
> > +		};
> > +	};
> 
> -- 
> Kind regards,
> 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

-- 
Regards,
Niklas Söderlund
