Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49109 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751342AbaBAJjl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Feb 2014 04:39:41 -0500
Date: Sat, 1 Feb 2014 11:39:05 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sebastian Reichel <sre@debian.org>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: Re: [RFCv2] Device Tree bindings for OMAP3 Camera System
Message-ID: <20140201093905.GA15635@valkosipuli.retiisi.org.uk>
References: <20131103220315.GA11659@earth.universe>
 <20140115194127.GA30988@earth.universe>
 <20140120041904.GH9997@valkosipuli.retiisi.org.uk>
 <52DDA04B.90809@gmail.com>
 <20140120232719.GA30894@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120232719.GA30894@earth.universe>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sebastian and Sylwester,

On Tue, Jan 21, 2014 at 12:27:21AM +0100, Sebastian Reichel wrote:
> Hi,
> 
> On Mon, Jan 20, 2014 at 11:16:43PM +0100, Sylwester Nawrocki wrote:
> > On 01/20/2014 05:19 AM, Sakari Ailus wrote:
> > >I've also been working on this (besides others); what I have however are
> > >mostly experimental patches. [...]
> 
> Thanks. I will have a look at it.
> 
> > [...]
> > >
> > >Over 80 characters per line.
> 
> Will be fixed in the next revision.
> 
> > >>can be found in Documentation/devicetree/bindings/media/video-interfaces.txt
> > >>
> > >>omap3isp node
> > >>-------------
> > >>
> > >>Required properties:
> > >>
> > >>- compatible    : should be "ti,omap3isp" for OMAP3.
> > >>- reg       : physical addresses and length of the registers set.
> > >>- clocks    : list of clock specifiers, corresponding to entries in
> > >>           clock-names property.
> > >>- clock-names   : must contain "cam_ick", "cam_mclk", "csi2_96m_fck",
> > >>           "l3_ick" entries, matching entries in the clocks property.
> > >>- interrupts    : must contain mmu interrupt.
> > >>- ti,iommu  : phandle to isp mmu.
> > >
> > >Is the TI specific? I'd assume not. Hiroshi's patches assume that
> > >at least.
> 
> I did not see any iommu standard in Documentation/devicetree/bindings,
> so I added the vendor prefix, for now. I don't have strong feelings for
> this. I saw you used iommus instead, which sounds reasonable for me.

Others will have the same so generic it is. It's part of Hiroshi's patches
he sent to linux-arm-kernel (and that I think I also applied to my branch).

> > >>- #address-cells: Should be set to<1>.
> > >>- #size-cells   : Should be set to<0>.
> > >
> > >The ISP also exports clocks. Shouldn't you add
> > >
> > >#clock-cells =<1>;
> 
> Ok. I already though about that possibility, but wasn't sure which
> way is the cleaner one. Thanks for clarifying.
> 
> > [...]
> > 
> > This doesn't seem to follow the common clock bindings.
> 
> I think it does follow common clock bindings at least. Clocks can
> referenced with the following statement:
> 
> camera-sensor-0 {
>     clocks = <&isp_xclk1>;
>     clock-names = ...
> };
> 
> > Instead, you could define value of #clock-cells to be 1 and allow clocks
> > consumers to reference the provider node in a standard way, e.g.:
> 
> This also works and probably better. I will merge clock provider
> into the main omap3isp node.

Ack.

> > [...]
> > >>endpoint subnode for serial interfaces
> > >>--------------------------------------
> > >>
> > >>Required properties:
> > >>  - ti,isp-interface-type    : should be one of the following values
> > >
> > >I think the interface type should be standardised at V4L2 level. We
> > >currently do not do that, but instead do a little bit of guessing.
> > 
> > I'm all for such a standard property. It seems much more clear to use such
> > a property. And I already run into issues with deriving the bus interface
> > type from existing properties, please see https://linuxtv.org/patch/19937
> > 
> > I assume it would be fine to add a string type property like
> > "interface-type"
> > or "bus-type".
> > 
> > >>   *<0>  to use the phy in CSI mode
> > >>   *<1>  to use the phy in CCP mode
> > >>   *<2>  to use the phy in CCP mode, but configured for MIPI CSI2
> 
> mh... from what I understand a port can be configured to be either
> CSI2 or CPP2 type. If CCP2 type is chosen the port can be configured
> to be CSI1 mode instead of actually being CPP2. See
> 
> see "struct isp_ccp2_platform_data" in include/media/omap3isp.h.
> 
> But actually I made a typo above. This is what I meant:
> 
> *<0>  to use the phy in MIPI CSI2 mode
> *<1>  to use the phy in SMIA CCP2 mode
> *<2>  to use the phy in SMIA CCP2 mode, but configured for MIPI CSI1
> 
> I'm not sure if this can be properly be described in a standardized
> type property.

Quoting the spec,

	0x0: MIPI CSI1-compatible mode. When this bit is set, all CCP2B
	settings are ignored. If the settings are not set correctly to MIPI
	CSI1 values, the behavior of the receiver is unpredictable.

I'm not entirely certain whether this is a compatibility mode intended for a
driver which cannot entirely control the CSI-1 block after the CCP2B
extensions (whatever they are) were implemented.

I would suggest leaving this out entirely. New cameras are all CSI-2 and the
Nokia N9 appears to be using value zero for this. I'm not aware of other
potential users.

> > >Hmm. I'm not entirely sure what does this last option mean. I could be
> > >forgetting something, though.
> 
> I hope the above description helped.
> 
> > >>  - ti,isp-clock-divisor     : integer used for configuration of the
> > >>                   video port output clock control.
> > >>
> > >>Optional properties:
> > >>  - ti,disable-crc       : boolean, which disables crc checking.
> > >
> > >I think crc should be standardised as well.
> >
> > Definitely something we should have a common definition for.
> 
> ok.
> 
> > >>  - ti,strobe-mode       : boolean, which setups data/strobe physical
> > >>                   layer instead of data/clock physical layer.
> > >>  - pclk-sample          : integer describing if clk should be interpreted on
> > >>                   rising (<1>) or falling edge (<0>). Default is<1>.
> > >
> > >I see different values on the N9 platform data for CCP2 and CSI2 (front and
> > >back camera). I'm not sure the bus type is related to this or not.
> 
> Not sure, what you mean here.

I wonderer whether the default could or should be related to the bus type.
I'm not sure.

> I merged (isp_ccp2_platform_data.phy_layer) into the bus-type
> property described above.
> 
> > >>- data-lanes: an array of physical data lane indexes. Position of an entry
> > >>   determines the logical lane number, while the value of an entry indicates
> > >>   physical lane, e.g. for 2-lane MIPI CSI-2 bus we could have
> > >>   "data-lanes =<1 2>;", assuming the clock lane is on hardware lane 0.
> > >>   This property is valid for serial busses only (e.g. MIPI CSI-2).
> > >>- clock-lanes: an array of physical clock lane indexes. Position of an entry
> > >>   determines the logical lane number, while the value of an entry indicates
> > >>   physical lane, e.g. for a MIPI CSI-2 bus we could have "clock-lanes =<0>;",
> > >>   which places the clock lane on hardware lane 0. This property is valid for
> > >>   serial busses only (e.g. MIPI CSI-2). Note that for the MIPI CSI-2 bus this
> > >>   array contains only one entry.
> > >
> > >I'd rather refer to
> > >Documentation/devicetree/bindings/media/video-interfaces.txt than copy from
> > >it. It's important that there's a single definition for the standard
> > >properties. Just mentioning the property by name should be enough. What do
> > >you think?
> > 
> > +1
> 
> sounds fine to me. Something like this?
> 
> - data-lanes: see [0]
> - clock-lanes: see [0]
> 
> [0] Documentation/devicetree/bindings/media/video-interfaces.txt

Looks good to me.

> > >>Example for Nokia N900
> > >>----------------------
> > >>
> > >>omap3isp: isp@480BC000 {
> > >>     compatible = "ti,omap3isp";
> > >>     reg =<0x480BC000 0x070>, /* base */
> > >>         <0x480BC100 0x078>, /* cbuf */
> > >>         <0x480BC400 0x1F0>, /* cpp2 */
> > >>         <0x480BC600 0x0A8>, /* ccdc */
> > >>         <0x480BCA00 0x048>, /* hist */
> > >>         <0x480BCC00 0x060>, /* h3a  */
> > >>         <0x480BCE00 0x0A0>, /* prev */
> > >>         <0x480BD000 0x0AC>, /* resz */
> > >>         <0x480BD200 0x0FC>, /* sbl  */
> > >>         <0x480BD400 0x070>; /* mmu  */
> > >
> > >Mmu is a separate device. (Please see my patches.)
> 
> Ok.
> 
> I simply took over the memory ranges currently defined in the
> omap3isp driver.

The MMU address range hasn't been there for a while. Which kernel did you
use? Could you use the ranges in my patch instead?

> > >>     clocks =<&cam_ick>,
> > >>          <&cam_mclk>,
> > >>          <&csi2_96m_fck>,
> > >>          <&l3_ick>;
> > >>     clock-names = "cam_ick",
> > >>               "cam_mclk",
> > >>               "csi2_96m_fck",
> > >>               "l3_ick";
> > >>
> > >>     interrupts =<24>;
> > >>
> > >>     ti,iommu =<&mmu_isp>;
> > 
> > 
> > >>     isp_xclk1: isp-xclk@0 {
> > >>         compatible = "ti,omap3-isp-xclk";
> > >>         reg =<0>;
> > >>         #clock-cells =<0>;
> > >>     };
> > >>
> > >>     isp_xclk2: isp-xclk@1 {
> > >>         compatible = "ti,omap3-isp-xclk";
> > >>         reg =<1>;
> > >>         #clock-cells =<0>;
> > >>     };
> > 
> > I think these whole 2 nodes could be omitted...
> > 
> > >>     #address-cells =<1>;
> > >>     #size-cells =<0>;
> > 
> > .. if you add here:
> > 
> > 	#clock-cells =<1>;
> 
> will do.
> 
> > >>     port@0 {
> > >>         reg =<0>;
> > >>
> > >>         /* parallel interface is not used on Nokia N900 */
> > >>         parallel_ep: endpoint {};
> > >>     };
> > >>
> > >>     port@1 {
> > >>         reg =<1>;
> > >>
> > >>         csi1_ep: endpoint {
> > >>             remote-endpoint =<&switch_in>;
> > >>             ti,isp-clock-divisor =<1>;
> > >>             ti,strobe-mode;
> > >>         };
> > >>     }
> > >>
> > >>     port@2 {
> > >>         reg =<2>;
> > >>
> > >>         /* second serial interface is not used on Nokia N900 */
> > >>         csi2_ep: endpoint {};
> > >>     }
> > >>};
> > >>
> > >>camera-switch {
> > >>     /*
> > >>      * TODO:
> > >>      *  - check if the switching code is generic enough to use a
> > >>      *    more generic name like "gpio-camera-switch".
> > >>      *  - document the camera-switch binding
> > >>      */
> > >>     compatible = "nokia,n900-camera-switch";
> > >
> > >Indeed. I don't think the hardware engineers realised what kind of a long
> > >standing issue they created for us when they chose that solution. ;)
> > >
> > >Writing a small driver for this that exports a sub-device would probably be
> > >the best option as this is hardly very generic. Should this be shown to the
> > >user space or not? Probably it'd be nice to avoid showing the related sub-device
> > >if there would be one.
> >
> > Probably we should avoid exposing such a hardware detail to user space.
> > OTOH it would be easy to handle as a media entity through the media
> > controller API.
> 
> If this is exposed to the userspace, then a userspace application
> "knows", that it cannot use both cameras at the same time. Otherwise
> it can just react to error messages when it tries to use the second
> camera.

Streaming still wouldn't be possible since both streams would eventually
cross at the CCP2 receiver.

But for that matter, I think there would be benefits of being able to
implement simple drivers that do not touch the format and hide them from
user space also elsewhere. This will still need a little bit of thinking.

> > I'm just wondering if we need to be describing this in DT in such
> > detail.
> 
> Do you have an alternative suggestion for the N900's bus switch
> hack?

I think we must describe it in the DT as it's there. Otherwise at least one
driver must be aware of it. And as the switch matters for a number of
drivers, it likely wouldn't be even a single one.

I'd rather try to hide that driver (and the switch) from the user space, or
figure out an easy way to ignore it.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
