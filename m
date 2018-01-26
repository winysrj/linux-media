Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:39999 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751379AbeAZAYC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 19:24:02 -0500
Received: by mail-lf0-f68.google.com with SMTP id h92so12128176lfi.7
        for <linux-media@vger.kernel.org>; Thu, 25 Jan 2018 16:24:01 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Fri, 26 Jan 2018 01:23:58 +0100
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v12 1/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver
 documentation
Message-ID: <20180126002358.GA19915@bigcity.dyn.berto.se>
References: <20171129193235.25423-1-niklas.soderlund+renesas@ragnatech.se>
 <20171129193235.25423-2-niklas.soderlund+renesas@ragnatech.se>
 <5713027.4ELTcTEoZh@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5713027.4ELTcTEoZh@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your comments.

On 2017-12-11 20:00:21 +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Wednesday, 29 November 2017 21:32:34 EET Niklas Söderlund wrote:
> > Documentation for Renesas R-Car MIPI CSI-2 receiver. The CSI-2 receivers
> > are located between the video sources (CSI-2 transmitters) and the video
> > grabbers (VIN) on Gen3 of Renesas R-Car SoC.
> > 
> > Each CSI-2 device is connected to more then one VIN device which
> 
> s/then/than/
> 
> > simultaneously can receive video from the same CSI-2 device. Each VIN
> > device can also be connected to more then one CSI-2 device. The routing
> 
> s/then/than/
> 
> > of which link are used are controlled by the VIN devices. There are only
> 
> s/link are/links are/ or s/link are/link is/
> s/are controlled/is controlled/
> 
> > a few possible routes which are set by hardware limitations, which are
> > different for each SoC in the Gen3 family.
> > 
> > To work with the limitations of routing possibilities it is necessary
> > for the DT bindings to describe which VIN device is connected to which
> > CSI-2 device. This is why port 1 needs to to assign reg numbers for each
> > VIN device that be connected to it. To setup and to know which links are
> 
> s/that be/that is/

I agree with all spelling fixes above, will fix for next version, 
thanks.

> 
> > valid for each SoC is the responsibility of the VIN driver since the
> > register to configure it belongs to the VIN hardware.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > Acked-by: Rob Herring <robh@kernel.org>
> > ---
> >  .../bindings/media/renesas,rcar-csi2.txt           | 105 ++++++++++++++++++
> >  MAINTAINERS                                        |   1 +
> >  2 files changed, 106 insertions(+)
> >  create mode 100644
> > Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
> > b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt new file
> > mode 100644
> > index 0000000000000000..688afd83bf66f8cf
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
> > @@ -0,0 +1,105 @@
> > +Renesas R-Car MIPI CSI-2
> > +------------------------
> > +
> > +The rcar-csi2 device provides MIPI CSI-2 capabilities for the Renesas R-Car
> 
> rcar-csi2 is the name of the driver, I would call it the "R-Car CSI-2 receiver 
> device" (or s/device/IP core/).

Yes "R-Car CSI-2 receiver device" sounds better.

> 
> > +family of devices. It is to be used in conjunction with the R-Car VIN
> > module,
> 
> The IP core itself doesn't have to be used with the VIN, but in R-Car SoCs it 
> is, so I would phrase it as "It is used ...".

Agreed.


> 
> > +which provides the video capture capabilities.
> > +
> > +Mandatory properties
> > +--------------------
> > + - compatible: Must be one or more of the following
> > +   - "renesas,r8a7795-csi2" for the R8A7795 device.
> > +   - "renesas,r8a7796-csi2" for the R8A7796 device.
> > +
> > + - reg: the register base and size for the device registers
> > + - interrupts: the interrupt for the device
> > + - clocks: Reference to the parent clock
> 
> Either capitalize the first word after the colon or don't, but please don't 
> mix them :-)

It's this not the new thing after camel case, mixed camel case notation?  
Yes looks terrible will fix for next version.

> 
> > +
> > +The device node shall contain two 'port' child nodes according to the
> > +bindings defined in Documentation/devicetree/bindings/media/
> > +video-interfaces.txt. Port 0 shall connect the node that is the video
> > +source for to the CSI-2.
> 
> Or simply "Port 0 shall connect to the CSI-2 source." ?
> 
> > Port 1 shall connect all the R-Car VIN
> > +modules, which can make use of the CSI-2 module.
> 
> And to be a bit more explicit, how about "Port 1 shall connect to all the R-
> Car VIN modules that have a hardware connection to the CSI-2 receiver." ?

The descriptions you provide are better, will use them in the next 
version. Thanks!

> 
> > +
> > +- Port 0 - Video source (Mandatory)
> 
> Nitpicking, I don't think you need to capitalize Mandatory.

:-)

> 
> > +	- Endpoint 0 - sub-node describing the endpoint that is the video source
> > +
> > +- Port 1 - VIN instances (Mandatory for all VIN present in the SoC)
> > +	- Endpoint 0 - sub-node describing the endpoint that is VIN0
> > +	- Endpoint 1 - sub-node describing the endpoint that is VIN1
> > +	- Endpoint 2 - sub-node describing the endpoint that is VIN2
> > +	- Endpoint 3 - sub-node describing the endpoint that is VIN3
> > +	- Endpoint 4 - sub-node describing the endpoint that is VIN4
> > +	- Endpoint 5 - sub-node describing the endpoint that is VIN5
> > +	- Endpoint 6 - sub-node describing the endpoint that is VIN6
> > +	- Endpoint 7 - sub-node describing the endpoint that is VIN7
> 
> Should we clarify that only a subset of those endpoints shall be present when 
> the CSI-2 receiver isn't connected to all VIN instances ?

Yes. In fact I think this should simply be marked as optional. As it is 
valid to omit a VIN from this as it is possible to use some VIN not only 
with a CSI-2 source but with a parallel input.

Will mark all options in port 1 as optional in next version.

> 
> Furthermore, as explained in a comment I made when reviewing the VIN patch 
> series, I wonder whether we shouldn't identify the CSI-2 receiver instances by 
> ID the same way we do with the VIN instances (using the renesas,id property). 
> In that case I think the endpoint numbering won't matter.

The endpoint numbering here plays no part in identify the CSI-2 receiver 
instances nor dose it carry any other information. I still think it's 
neat to define the binding like this as it more explicit and IMHO this 
makes it easier to understand.

> 
> > +Example:
> > +
> > +	csi20: csi2@fea80000 {
> > +		compatible = "renesas,r8a7796-csi2";
> > +		reg = <0 0xfea80000 0 0x10000>;
> > +		interrupts = <0 184 IRQ_TYPE_LEVEL_HIGH>;
> > +		clocks = <&cpg CPG_MOD 714>;
> > +		power-domains = <&sysc R8A7796_PD_ALWAYS_ON>;
> > +		resets = <&cpg 714>;
> > +
> > +		ports {
> > +			#address-cells = <1>;
> > +			#size-cells = <0>;
> > +
> > +			port@0 {
> > +				#address-cells = <1>;
> > +				#size-cells = <0>;
> > +
> > +				reg = <0>;
> > +
> > +				csi20_in: endpoint@0 {
> > +					reg = <0>;
> > +					clock-lanes = <0>;
> > +					data-lanes = <1>;
> > +					remote-endpoint = <&adv7482_txb>;
> > +				};
> > +			};
> > +
> > +			port@1 {
> > +				#address-cells = <1>;
> > +				#size-cells = <0>;
> > +
> > +				reg = <1>;
> > +
> > +				csi20vin0: endpoint@0 {
> > +					reg = <0>;
> > +					remote-endpoint = <&vin0csi20>;
> > +				};
> > +				csi20vin1: endpoint@1 {
> > +					reg = <1>;
> > +					remote-endpoint = <&vin1csi20>;
> > +				};
> > +				csi20vin2: endpoint@2 {
> > +					reg = <2>;
> > +					remote-endpoint = <&vin2csi20>;
> > +				};
> > +				csi20vin3: endpoint@3 {
> > +					reg = <3>;
> > +					remote-endpoint = <&vin3csi20>;
> > +				};
> > +				csi20vin4: endpoint@4 {
> > +					reg = <4>;
> > +					remote-endpoint = <&vin4csi20>;
> > +				};
> > +				csi20vin5: endpoint@5 {
> > +					reg = <5>;
> > +					remote-endpoint = <&vin5csi20>;
> > +				};
> > +				csi20vin6: endpoint@6 {
> > +					reg = <6>;
> > +					remote-endpoint = <&vin6csi20>;
> > +				};
> > +				csi20vin7: endpoint@7 {
> > +					reg = <7>;
> > +					remote-endpoint = <&vin7csi20>;
> > +				};
> > +			};
> > +		};
> > +	};
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index aa71ab52fd76d160..4737de9f41bff570 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -8652,6 +8652,7 @@ L:	linux-media@vger.kernel.org
> >  L:	linux-renesas-soc@vger.kernel.org
> >  T:	git git://linuxtv.org/media_tree.git
> >  S:	Supported
> > +F:	Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
> >  F:	Documentation/devicetree/bindings/media/rcar_vin.txt
> >  F:	drivers/media/platform/rcar-vin/
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Regards,
Niklas Söderlund
