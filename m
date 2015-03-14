Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38667 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755372AbbCNOne (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2015 10:43:34 -0400
Date: Sat, 14 Mar 2015 16:43:24 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	pali.rohar@gmail.com
Subject: Re: [RFC 16/18] arm: dts: omap3: Add DT entries for OMAP 3
Message-ID: <20150314144320.GW11954@valkosipuli.retiisi.org.uk>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
 <1425764475-27691-17-git-send-email-sakari.ailus@iki.fi>
 <2423520.KeZmBeFNoH@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2423520.KeZmBeFNoH@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 08, 2015 at 01:51:51AM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Saturday 07 March 2015 23:41:13 Sakari Ailus wrote:
> > The resources the ISP needs are slightly different on 3[45]xx and 3[67]xx.
> > Especially the phy-type property is different.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  arch/arm/boot/dts/omap34xx.dtsi |   15 +++++++++++++++
> >  arch/arm/boot/dts/omap36xx.dtsi |   15 +++++++++++++++
> >  2 files changed, 30 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/omap34xx.dtsi
> > b/arch/arm/boot/dts/omap34xx.dtsi index 3819c1e..4c034d0 100644
> > --- a/arch/arm/boot/dts/omap34xx.dtsi
> > +++ b/arch/arm/boot/dts/omap34xx.dtsi
> > @@ -37,6 +37,21 @@
> >  			pinctrl-single,register-width = <16>;
> >  			pinctrl-single,function-mask = <0xff1f>;
> >  		};
> > +
> > +		omap3_isp: omap3_isp@480bc000 {
> > +			compatible = "ti,omap3-isp";
> > +			reg = <0x480bc000 0x12fc
> > +			       0x480bd800 0x017c>;
> > +			interrupts = <24>;
> > +			iommus = <&mmu_isp>;
> > +			syscon = <&omap3_scm_general 0xdc>;
> > +			ti,phy-type = <0>;
> > +			#clock-cells = <1>;
> > +			ports {
> > +				#address-cells = <1>;
> > +				#size-cells = <0>;
> 
> How about predefining the ports too ?

After a short discussion, we decided not to add port nodes. The arguments
considered were:

- Port nodes could help integrators writing the DT nodes. However the port
  nodes are easier to construct than endpoint nodes. Board specific
  configuration would also still need to be added.
- Extra port nodes take space which could be spent more usefully for other
  purposes.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
